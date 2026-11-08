import CXSPIReference
import STM32H7RSHAL
import XCTest

final class XSPITransferTests: XCTestCase {
  func testBusyAbortCompletesAfterHardwareClearsBusy() {
    for callbacks in [false, true] {
      let p = XSPIPair(callbacks: callbacks)
      p.setup { f in
        f.write(.state, value: 0x88)
        f.write(.timeout, value: 3)
        f.raw(.cr, 0x3000_0000)
        f.raw(.sr, 0x22)
        f.control(25, 3)
        f.control(26, 0)
      }
      p.verify(19)
      XCTAssertEqual(p.swift.read(.state), 2)
      XCTAssertEqual(p.swift.read(.errorCode), 0)
      XCTAssertEqual(p.swift.raw(.cr) & 0x3000_0000, 0)
    }
  }
  func testInfiniteWaitAndCallbackChangesHandle() {
    for callbacks in [false, true] {
      let p = XSPIPair(callbacks: callbacks)
      p.setup { f in
        f.control(18, UInt32.max)
        f.control(25, 2)
        f.control(26, 4)
      }
      p.verify(36, 6, 1)
      XCTAssertEqual(p.swift.control(4), 0)
      p.setup { f in
        f.write(.state, value: 0x18)
        f.write(.transferCount, value: 1)
        f.writeBuffer(f.buffer())
        f.raw(.cr, 0x1F0000)
        f.raw(.sr, 6)
        f.control(20, 3)
        f.control(21, 17)
        f.control(22, 0x200)
      }
      p.verify(2)
      XCTAssertEqual(p.swift.read(.state), 0x200)
    }
  }
  func testPollingFIFOBytesAndCompletion() {
    for callbacks in [false, true] {
      for op: UInt32 in [7, 8] {
        for size: UInt32 in [1, 2, 3, 7, 16, 32, 63] {
          for trigger: UInt32 in [0, 1, 2] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: 4)
              f.raw(.dlr, size - 1)
              f.raw(.sr, 6)
              f.raw(.ar, 0x1234)
              f.raw(.ir, 0x9F)
              f.raw(.ccr, trigger == 1 ? 0x400 : 0)
              f.write(.memoryType, value: trigger == 2 ? 0x4000000 : 0)
              for i in 0..<128 { f.buffer()[i] = UInt8(truncatingIfNeeded: i * 7 + 3) }
              f.raw(.dr, 0x1234_5678)
              f.control(33, 1)
            }
            p.verify(op, 0, 100)
            XCTAssertEqual(p.swift.read(.transferCount), 0)
            XCTAssertEqual(p.swift.read(.state), 2)
          }
        }
      }
    }
  }
  func testTransferPreconditionsAndTimeouts() {
    for callbacks in [false, true] {
      for op: UInt32 in [7, 8, 9, 10] {
        for state: UInt32 in [0, 2, 4, 8, 0x18, 0x28] {
          for mask: UInt32 in 0..<4 {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.raw(.dlr, 3)
              f.raw(.sr, mask & 1 == 0 ? 0 : 6)
              f.control(13, mask >> 1)
              f.control(2, 0xFFFF_FFFE)
              f.control(3, 1)
            }
            p.verify(op, 0, 2)
          }
        }
      }
    }
  }
  func testPartialTransferAndCompletionTimeout() {
    for callbacks in [false, true] {
      for op: UInt32 in [7, 8] {
        for count: UInt32 in [0, 1, 3] {
          let p = XSPIPair(callbacks: callbacks)
          p.setup { f in
            f.write(.state, value: 4)
            f.raw(.dlr, 3)
            f.raw(.sr, 4)
            if op == 7 {
              f.control(31, count)
              f.control(32, 0)
            } else {
              f.control(28, count)
              f.control(29, 0)
            }
          }
          p.verify(op, 0, 2)
          XCTAssertEqual(p.swift.read(.errorCode) & 1, 1)
        }
      }
    }
  }
  func testInterruptPriorityAndCallbackState() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 2, 4, 8, 0x18, 0x28, 0x48, 0x88, 0x100] {
        for flags: UInt32 in [0, 1, 2, 4, 8, 16, 0x1F, 0x104, 0x102] {
          for enabled: UInt32 in [0, 0x1F0000] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.transferCount, value: 2)
              f.writeBuffer(f.buffer())
              f.raw(.sr, flags)
              f.raw(.cr, enabled | 0x400000)
              f.raw(.dr, 0x1234_5678)
            }
            p.verify(2)
          }
        }
      }
    }
  }
  func testInterruptReceiveTailAndCommandCompletion() {
    for callbacks in [false, true] {
      for state: UInt32 in [8, 0x18, 0x28, 0x100] {
        for count: UInt32 in [0, 1, 2] {
          for error: UInt32 in [0, 2] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.errorCode, value: error)
              f.write(.transferCount, value: count)
              f.writeBuffer(f.buffer())
              f.raw(.sr, 0x102)
              f.raw(.cr, 0x1F0000)
            }
            p.verify(2)
            p.verify(2)
            p.verify(2)
          }
        }
      }
    }
  }
  func testAbortStatusAndBusyTimeout() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 2, 4, 0x18, 0x88] {
        for flags: UInt32 in [0, 2, 0x20, 0x22] {
          for op: UInt32 in [19, 20] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.timeout, value: 2)
              f.raw(.sr, flags)
              f.raw(.cr, 0x301F_0000)
            }
            p.verify(op)
          }
        }
      }
    }
  }
  func testWaitFlagAnyBitAndWraparound() {
    for callbacks in [false, true] {
      for flags: UInt32 in [0, 2, 4, 6] {
        for desired: UInt32 in [0, 1] {
          for timeout: UInt32 in [0, 1, 3] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.raw(.sr, flags)
              f.control(2, 0xFFFF_FFFE)
              f.control(18, timeout)
              f.write(.errorCode, value: 0x80)
            }
            p.verify(36, 6, desired, 0xFFFF_FFFE)
          }
        }
      }
    }
  }
}
