import CAudioReference
import STM32H7RSHAL
import XCTest

final class I2STransferTests: XCTestCase {
  private func prepare(_ f: I2SFixture, format: UInt32 = 0, mode: UInt32 = 4) {
    f.write(.state, value: 1)
    f.write(.dataFormat, value: format)
    f.write(.mode, value: mode)
    f.write(.rxdr, value: 0xA591_37DE)
    f.write(.txdr, value: 0xCDEF_1234)
    f.write(.sr, value: 0x67)
    f.write(.ifcr, value: 0x8000)
    for i in 0..<1024 { f.buffer()[i] = UInt8(truncatingIfNeeded: i * 73 + 19) }
    for d in [UARTDMADirection.transmit, .receive] {
      f.setting(d, 0, 1)
      f.setting(d, 5, 1)
      f.setting(d, 6, 1)
    }
  }
  func testPollingWidthsFullDuplexAndCounterRetention() {
    for op: UInt32 in [4, 5, 6] {
      for format: UInt32 in [0, 0x800, 0x100, 0x200] {
        for count: UInt32 in [1, 2, 3, 17, 127] {
          let p = I2SPair()
          p.setup { prepare($0, format: format) }
          p.verify(op, count, 1000)
        }
      }
    }
  }
  func testRejectedTransferArgumentsStatesAndLocks() {
    for op: UInt32 in 4...12 {
      for state: UInt32 in [0, 1, 2, 3, 4, 5] {
        for lock: UInt32 in [0, 1] {
          for nilMask: UInt32 in [0, 1, 2, 3] {
            let p = I2SPair()
            p.setup {
              prepare($0)
              $0.write(.state, value: state)
              $0.write(.lock, value: lock)
              $0.control(13, nilMask & 1)
              $0.control(15, nilMask >> 1)
            }
            p.verify(op, 2, 100)
            let empty = I2SPair()
            empty.setup {
              prepare($0)
              $0.write(.state, value: state)
              $0.write(.lock, value: lock)
            }
            empty.verify(op, 0, 0)
          }
        }
      }
    }
  }
  func testTimeoutBoundariesTickWrapAndFlagArrival() {
    for op: UInt32 in [4, 5, 6] {
      for timeout: UInt32 in [0, 1, 3, 9, UInt32.max] {
        for start: UInt32 in [0, UInt32.max - 2] {
          let p = I2SPair()
          p.setup {
            prepare($0)
            $0.write(.sr, value: timeout == .max && op != 6 ? 3 : 0)
            $0.control(2, start)
            $0.control(10, 4)
            $0.control(11, 5)
            $0.control(12, 3)
          }
          p.verify(op, 3, timeout)
        }
      }
    }
  }
  func testInterruptTransfersAndCompletionCallbacks() {
    for registered in [false, true] {
      for format: UInt32 in [0, 0x800, 0x100, 0x200] {
        for op: UInt32 in [7, 8, 9] {
          for mode: UInt32 in [0, 2, 4, 6, 8, 10] {
            let p = I2SPair(callbacks: registered)
            p.setup {
              prepare($0, format: format, mode: mode)
              $0.write(.sr, value: 0x7)
            }
            p.verify(op, 3)
            for _ in 0..<3 { p.verify(19) }
          }
        }
      }
    }
  }
  func testIRQSnapshotAndSimultaneousErrors() {
    for registered in [false, true] {
      for op: UInt32 in [7, 8, 9] {
        for flags: UInt32 in [0, 1, 2, 4, 7, 0x20, 0x40, 0x60, 0x67, 0x100, 0x167] {
          for mask: UInt32 in [0, 7, 0x60, 0x167] {
            let p = I2SPair(callbacks: registered)
            p.setup { prepare($0, mode: 10) }
            p.verify(op, 2)
            p.setup {
              $0.write(.sr, value: flags)
              $0.write(.ier, value: mask)
            }
            p.verify(19)
          }
        }
      }
    }
  }
  func testDMAWidthsLinkedListAndPartialStartFailures() {
    for op: UInt32 in [10, 11, 12] {
      for format: UInt32 in [0, 0x800, 0x100, 0x200] {
        for mode: UInt32 in [0, 0x80, 0x81] {
          for fail: UInt32 in 0...4 {
            for count: UInt32 in [1, 16384, 32768, 65535] {
              let p = I2SPair()
              p.setup {
                prepare($0, format: format)
                for d in [UARTDMADirection.transmit, .receive] { $0.setting(d, 2, mode) }
                if fail == 1 { $0.setting(.transmit, 5, 0) }
                if fail == 2 { $0.setting(.receive, 5, 0) }
                if fail == 3 {
                  $0.setting(.transmit, 7, 1)
                  $0.setting(.transmit, 8, 1)
                }
                if fail == 4 {
                  $0.setting(.receive, 7, 3)
                  $0.setting(.receive, 8, 3)
                }
              }
              p.verify(op, count)
            }
          }
        }
      }
    }
  }
  func testDMACallbackUsesConfigurationModeNotHandleMode() {
    for registered in [false, true] {
      for op: UInt32 in 22...28 {
        for configurationMode: UInt32 in [0, 1, 0x80, 0x81] {
          for handleMode: UInt32 in [0, 0x81] {
            for direction: UInt32 in [0, 1] {
              let p = I2SPair(callbacks: registered)
              p.setup {
                prepare($0)
                $0.write(.state, value: 5)
                $0.write(.transmitCount, value: 17)
                $0.write(.receiveCount, value: 19)
                $0.write(.cfg1, value: 0xFFFF_FFFF)
                $0.setting(direction == 0 ? .transmit : .receive, 1, configurationMode)
                $0.setting(direction == 0 ? .transmit : .receive, 2, handleMode)
              }
              p.verify(op, direction)
            }
          }
        }
      }
    }
  }
  func testPauseResumeAndStopKeepOriginalOrdering() {
    for mode: UInt32 in [0, 2, 4, 6, 8, 10] {
      for lock: UInt32 in [0, 1] {
        for start: UInt32 in [0, 0x200] {
          for outcome: UInt32 in [0, 1, 2] {
            let p = I2SPair()
            p.setup {
              prepare($0, mode: mode)
              $0.write(.lock, value: lock)
              $0.write(.cr1, value: start | 1)
              $0.control(3, 40000)
              if outcome == 0 {
                $0.control(10, 2)
                $0.control(11, 0)
                $0.control(12, 1)
              }
              $0.setting(.transmit, 9, outcome)
              $0.setting(.receive, 9, outcome)
            }
            p.verify(13)
            p.verify(14)
            p.verify(15)
          }
        }
      }
    }
  }
}
