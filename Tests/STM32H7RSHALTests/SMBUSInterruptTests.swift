import CSMBUSReference
import STM32H7RSHAL
import XCTest

final class SMBUSInterruptTests: XCTestCase {
  func testMasterAndSlavePriorityFlagsCountsPECAndStop() {
    for callbacks in [false, true] {
      for op: UInt32 in [22, 23] {
        for state: UInt32 in [1, 8, 0x12, 0x22, 0x32, 0x42, 0x3A, 0x4A] {
          for flags: UInt32 in [0, 2, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x24, 0x28, 0x30, 0x84, 0xFE] {
            for count: UInt16 in [0, 1, 2, 255, 256] {
              let p = SMBUSPair(callbacks: callbacks)
              p.setup { f in
                f.write(.state, value: state)
                f.write(.transferCount, value: count)
                f.write(.transferSize, value: count > 1 ? 0 : count)
                f.write(.transferOptions, value: 0x4000000)
                f.write(.cr1, value: 0x80 | 0xFE)
                f.write(.cr2, value: 0x4000000)
                f.write(.isr, value: flags | 0xA50000)
                f.write(.rxdr, value: 0x8765_4321)
                f.buffer[0] = 0xAB
              }
              p.verify(op, flags)
              p.verify(20)
              p.verify(21)
            }
          }
        }
      }
    }
  }

  func testEventDispatcherUsesCapturedSourcesAndRechecksState() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 1, 8, 0x12, 0x22, 0x3A, 0x4A] {
        for sources: UInt32 in [0, 2, 4, 8, 0x10, 0x20, 0x72, 0x74, 0xFE] {
          for flags: UInt32 in [2, 4, 8, 0x10, 0x20, 0x28, 0x30, 0x40, 0x80, 0xFE] {
            let p = SMBUSPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.transferSize, value: 2)
              f.write(.transferCount, value: 2)
              f.write(.cr1, value: sources)
              f.write(.isr, value: flags | 0xB50000)
              f.write(.rxdr, value: 0x2345)
              f.buffer[0] = 0xA1
              f.control(20, 6)
              f.control(21, 14)
              f.control(22, 0x4A)
            }
            p.verify(18)
          }
        }
      }
    }
  }

  func testErrorsPreserveAlertStateAndACKOnlyCallbackSuppression() {
    for callbacks in [false, true] {
      for state: UInt32 in [1, 8, 0x12, 0x22, 0x32, 0x42, 0x3A, 0x4A] {
        for flags: UInt32 in [0, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x3F03] {
          for previousError: UInt32 in [0, 4, 0x40, 0x100] {
            for source: UInt32 in [0, 0x80] {
              let p = SMBUSPair(callbacks: callbacks)
              p.setup { f in
                f.write(.state, value: state)
                f.write(.lock, value: 1)
                f.write(.errorCode, value: previousError)
                f.write(.cr1, value: source)
                f.write(.isr, value: flags)
              }
              p.verify(19)
            }
          }
        }
      }
    }
  }

  func testAddressCallbackReceivesUnshiftedSevenBitAddress() {
    for callbacks in [false, true] {
      for address: UInt32 in [0, 1, 0x52, 0x7F] {
        for direction: UInt32 in [0, 1] {
          let p = SMBUSPair(callbacks: callbacks)
          p.setup { f in
            f.write(.state, value: 8)
            f.write(.cr1, value: 8)
            f.write(.isr, value: (address << 17) | (direction << 16) | 8)
          }
          p.verify(18)
          XCTAssertEqual(CSMBUS_Get(p.swift.state, 4, 0), 8)
          XCTAssertEqual(CSMBUS_Get(p.swift.state, 4, 2), direction)
          XCTAssertEqual(CSMBUS_Get(p.swift.state, 4, 3), address)
          XCTAssertEqual(CSMBUS_Get(p.swift.state, 4, 6), 0)
        }
      }
    }
  }

  func testMasterTransferSequenceAcrossReloadAndCompletion() {
    for callbacks in [false, true] {
      for receive in [false, true] {
        let p = SMBUSPair(callbacks: callbacks)
        p.setup { f in
          f.write(.state, value: 1)
          f.control(17, 0x2000000)
          for i in 0..<300 { f.buffer[i] = UInt8(truncatingIfNeeded: i) }
        }
        p.verify(receive ? 9 : 8, 0xA4, 300)
        for i in 0..<300 {
          p.setup { f in
            f.write(.isr, value: receive ? 4 : 2)
            f.write(.rxdr, value: UInt32(i) ^ 0xA5)
          }
          p.verify(18)
          if i == 254 {
            p.setup { $0.write(.isr, value: 0x80) }
            p.verify(18)
          }
        }
        p.setup { $0.write(.isr, value: 0x20) }
        p.verify(18)
        XCTAssertEqual(p.swift.read(.state), 1)
        XCTAssertEqual(p.swift.read(.transferCount), 0)
      }
    }
  }

  func testQuickCommandGeneratesStopWithoutDereferencingNullBuffer() {
    for op: UInt32 in [8, 9] {
      let p = SMBUSPair()
      p.setup { f in
        f.write(.state, value: 1)
        f.control(13, 1)
        f.control(17, 0x2000000)
      }
      p.verify(op, 0xA4, 0)
      p.setup { $0.write(.isr, value: 0x40) }
      p.verify(18)
      XCTAssertNotEqual(p.swift.read(.cr2) & 0x4000, 0)
      XCTAssertNil(p.swift.readBuffer())
      p.setup { $0.write(.isr, value: 0x20) }
      p.verify(18)
    }
  }

  func testHeldLockAndChangingCallbackState() {
    for callbacks in [false, true] {
      for op: UInt32 in [22, 23] {
        for flags: UInt32 in [0x10, 0x20, 0x28, 0x3C, 0xFE] {
          for lock: UInt32 in [0, 1] {
            let p = SMBUSPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: op == 22 ? 0x12 : 0x4A)
              f.write(.lock, value: lock)
              f.write(.isr, value: flags)
              f.write(.cr1, value: 0xFE)
              f.write(.transferCount, value: 1)
              f.write(.transferSize, value: 1)
              f.control(20, 6)
              f.control(21, 14)
              f.control(22, 8)
            }
            p.verify(op, flags)
          }
        }
      }
    }
  }
}
