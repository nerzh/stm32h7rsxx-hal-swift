import CXSPIReference
import STM32H7RSHAL
import XCTest

final class XSPIDMATests: XCTestCase {
  func testReceiveTriggerAndWrappingDataLength() {
    for callbacks in [false, true] {
      for hyperbus in [false, true] {
        for address in [false, true] {
          for dlr: UInt32 in [3, UInt32.max] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: 4)
              f.write(.memoryType, value: hyperbus ? 0x4000000 : 0)
              f.raw(.ccr, address ? 0x400 : 0)
              f.raw(.dlr, dlr)
              f.raw(.ar, 0x1234_5678)
              f.raw(.ir, 0x9F)
              f.setting(.receive, 0, 1)
              f.setting(.receive, 18, 0x80000)
            }
            p.verify(12)
            XCTAssertEqual(p.swift.read(.transferCount), dlr &+ 1)
          }
        }
      }
    }
  }
  func testDMAWidthsAndFIFOAlignment() {
    for callbacks in [false, true] {
      for op: UInt32 in [11, 12] {
        for width: UInt32 in [0, 0x10000, 0x20000, 0x30000] {
          for size: UInt32 in [1, 2, 3, 4, 7, 8] {
            for threshold: UInt32 in [1, 2, 3, 4] {
              let p = XSPIPair(callbacks: callbacks)
              p.setup { f in
                f.write(.state, value: 4)
                f.write(.transferCount, value: 17)
                f.write(.fifoThresholdByte, value: threshold)
                f.raw(.dlr, size - 1)
                let d: UARTDMADirection = op == 11 ? .transmit : .receive
                f.setting(d, 0, 1)
                f.setting(d, 14, width)
                f.setting(d, 16, op == 11 ? 0x400 : 0)
                f.setting(d, 17, op == 11 ? 8 : 0)
                f.setting(d, 18, op == 11 ? 0 : 0x80000)
              }
              p.verify(op)
            }
          }
        }
      }
    }
  }
  func testLinkedListValidationAndNodeMutation() {
    for callbacks in [false, true] {
      for op: UInt32 in [11, 12] {
        for mask: UInt32 in 0..<16 {
          for width: UInt32 in [0, 0x10000, 0x20000] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: 4)
              f.write(.fifoThresholdByte, value: 4)
              f.raw(.dlr, 7)
              let d: UARTDMADirection = op == 11 ? .transmit : .receive
              f.setting(d, 0, 1)
              f.setting(d, 2, 0x80)
              f.setting(d, 5, mask & 1)
              f.setting(d, 6, (mask >> 1) & 1)
              f.setting(d, 8, (mask >> 2) & 3)
              CXSPI_Set(f.state, op == 11 ? 5 : 6, 0, 0x1234_5678 & ~0x30000 | width)
              CXSPI_Set(f.state, op == 11 ? 5 : 6, 1, 0xA5A5_A5A5)
            }
            p.verify(op)
          }
        }
      }
    }
  }
  func testDMAInvalidConfigurationAndStartFailures() {
    for callbacks in [false, true] {
      for op: UInt32 in [11, 12] {
        for mask: UInt32 in 0..<8 {
          for status: UInt32 in 0...3 {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: 4)
              f.write(.fifoThresholdByte, value: 4)
              f.raw(.dlr, 7)
              let d: UARTDMADirection = op == 11 ? .transmit : .receive
              f.setting(d, 0, 1)
              f.setting(d, 7, status)
              f.setting(d, 16, mask & 1 == 0 ? 0 : 0x400)
              f.setting(d, 17, mask & 2 == 0 ? 0 : 8)
              f.setting(d, 18, mask & 4 == 0 ? 0 : 0x80000)
            }
            p.verify(op)
          }
        }
      }
    }
  }
  func testDMACompletionStateMatrix() {
    for callbacks in [false, true] {
      for op: UInt32 in [32, 33, 34, 35] {
        for state: UInt32 in [0, 2, 4, 8, 0x18, 0x28, 0x88, 0x100] {
          for flags: UInt32 in [0, 0x20] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.transferCount, value: 9)
              f.raw(.sr, flags)
              f.raw(.cr, 0x301F_0004)
              f.setting(.transmit, 0, 1)
              f.setting(.receive, 0, 1)
            }
            p.verify(op)
          }
        }
      }
    }
  }
  func testAbortBothDMAChannelsAndSynchronousCallbacks() {
    for callbacks in [false, true] {
      for op: UInt32 in [2, 19, 20] {
        for tx: UInt32 in 0...3 {
          for rx: UInt32 in 0...3 {
            for immediate: UInt32 in [0, 1] {
              let p = XSPIPair(callbacks: callbacks)
              p.setup { f in
                f.write(.state, value: 0x18)
                f.write(.transferCount, value: 8)
                f.write(.timeout, value: 2)
                f.raw(.sr, 1)
                f.raw(.cr, 0x301F_0004)
                f.setting(.transmit, 0, 1)
                f.setting(.receive, 0, 1)
                for d in [UARTDMADirection.transmit, .receive] {
                  f.setting(d, 9, d == .transmit ? tx : rx)
                  f.setting(d, 10, d == .transmit ? tx : rx)
                  f.setting(d, 11, immediate)
                }
              }
              p.verify(op)
            }
          }
        }
      }
    }
  }
  func testDMARejectsNullAndWrongSequence() {
    for callbacks in [false, true] {
      for op: UInt32 in [11, 12] {
        for state: UInt32 in [0, 2, 4, 8, 0x28] {
          for null: UInt32 in [0, 1] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.control(13, null)
              f.raw(.dlr, 3)
              f.setting(.transmit, 0, 1)
              f.setting(.receive, 0, 1)
            }
            p.verify(op)
          }
        }
      }
    }
  }
}
