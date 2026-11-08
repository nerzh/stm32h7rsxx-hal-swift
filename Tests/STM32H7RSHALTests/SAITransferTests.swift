import CAudioReference
import STM32H7RSHAL
import XCTest

final class SAITransferTests: XCTestCase {
  private func prepare(_ f: SAIFixture, size: UInt32 = 0x80, companding: UInt32 = 0) {
    f.write(.state, value: 1)
    f.write(.dataSize, value: size)
    f.write(.compandingMode, value: companding)
    f.write(.dr, value: 0xA591_37DE)
    f.write(.sr, value: 0x30000)
    for i in 0..<1024 { f.buffer()[i] = UInt8(truncatingIfNeeded: i * 73 + 19) }
    for d in [UARTDMADirection.transmit, .receive] {
      f.setting(d, 0, 1)
      f.setting(d, 5, 1)
      f.setting(d, 6, 1)
    }
  }
  func testPollingWidthsUnalignedBuffersAndFIFOStartup() {
    for op: UInt32 in [5, 6] {
      for size: UInt32 in [0x40, 0x60, 0x80, 0xA0, 0xC0, 0xE0] {
        for companding: UInt32 in [0, 0x8000] {
          for count: UInt32 in [1, 3, 127] {
            for enabled: UInt32 in [0, 0x10000] {
              let p = SAIPair()
              p.setup {
                prepare($0, size: size, companding: companding)
                $0.write(.cr1, value: enabled)
                $0.control(14, 1)
              }
              p.verify(op, count, 100)
            }
          }
        }
      }
    }
  }
  func testPollingTimeoutAndScheduledFIFOChange() {
    for op: UInt32 in [5, 6] {
      for timeout: UInt32 in [0, 1, 3, 9, .max] {
        for start: UInt32 in [0, .max - 2] {
          for clock: UInt32 in [0, 64_000_000] {
            let p = SAIPair()
            p.setup {
              prepare($0)
              $0.write(.sr, value: op == 5 ? 0x50000 : 0)
              $0.control(2, start)
              $0.control(6, clock)
              $0.control(10, 4)
              $0.control(11, 5)
              $0.control(12, 0x30000)
            }
            p.verify(op, 3, timeout)
          }
        }
      }
    }
  }
  func testArgumentStateAndLockRejection() {
    for op: UInt32 in [5, 6, 7, 8, 13, 14] {
      for state: UInt32 in [0, 1, 2, 0x12, 0x22] {
        for lock: UInt32 in [0, 1] {
          for nilBuffer: UInt32 in [0, 1] {
            for count: UInt32 in [0, 2] {
              let p = SAIPair()
              p.setup {
                prepare($0)
                $0.write(.state, value: state)
                $0.write(.lock, value: lock)
                $0.control(13, nilBuffer)
              }
              p.verify(op, count, 100)
            }
          }
        }
      }
    }
  }
  func testInterruptWidthsFIFOCompletionAndMaskSelection() {
    for registered in [false, true] {
      for op: UInt32 in [7, 8] {
        for size: UInt32 in [0x40, 0x80, 0xE0] {
          for companding: UInt32 in [0, 0x8000] {
            for mode: UInt32 in 0..<4 {
              for protocolMode: UInt32 in [0, 4, 8] {
                let p = SAIPair(callbacks: registered)
                p.setup {
                  prepare($0, size: size, companding: companding)
                  $0.write(.audioMode, value: mode)
                  $0.write(.protocolMode, value: protocolMode)
                  $0.write(.sr, value: 0x50000)
                }
                p.verify(op, 3)
                p.setup { $0.write(.sr, value: 8) }
                for _ in 0..<(op == 7 ? 4 : 3) { p.verify(19) }
              }
            }
          }
        }
      }
    }
  }
  func testDMAStartFailureLinkedQueueWidthsAndFIFOTimeout() {
    for op: UInt32 in [13, 14] {
      for size: UInt32 in [0x40, 0x80, 0xE0] {
        for companding: UInt32 in [0, 0x8000] {
          for mode: UInt32 in [0, 0x80, 0x81] {
            for fail: UInt32 in 0...4 {
              let p = SAIPair()
              p.setup {
                prepare($0, size: size, companding: companding)
                for d in [UARTDMADirection.transmit, .receive] {
                  $0.setting(d, 2, mode)
                  if fail == 1 { $0.setting(d, 5, 0) }
                  if fail == 2 {
                    $0.setting(d, 7, 1)
                    $0.setting(d, 8, 1)
                  }
                }
                if fail >= 3 {
                  $0.write(.sr, value: 0)
                  $0.control(3, 600)
                }
                if fail == 4 {
                  $0.control(10, 2)
                  $0.control(11, 5)
                  $0.control(12, 0x10000)
                }
              }
              p.verify(op, 65535)
            }
          }
        }
      }
    }
  }
  func testDMACallbacksUseHandleModeAndAbortErrorEquality() {
    for registered in [false, true] {
      for op: UInt32 in 33...38 {
        for mode: UInt32 in [0, 1, 0x80, 0x81] {
          for error: UInt32 in [0, 0x20, 0x21] {
            for clock: UInt32 in [0, 64_000_000] {
              let p = SAIPair(callbacks: registered)
              p.setup {
                prepare($0)
                $0.write(.state, value: 0x12)
                $0.write(.transferCount, value: 17)
                $0.write(.errorCode, value: error)
                $0.write(.cr1, value: 0x30000)
                $0.write(.imr, value: 0x7F)
                $0.setting(.transmit, 1, mode == 0x81 ? 0 : 0x81)
                $0.setting(.transmit, 2, mode)
                $0.control(6, clock)
              }
              p.verify(op, 0)
            }
          }
        }
      }
    }
  }
  func testIRQPriorityMuteAndAbortCallbackTiming() {
    for registered in [false, true] {
      for flag: UInt32 in [0, 1, 2, 4, 0x10, 0x20, 0x40, 0x7F] {
        for dma: UInt32 in [0, 0x20000] {
          for synchronous: UInt32 in [0, 1] {
            for fail: UInt32 in [0, 1] {
              let p = SAIPair(callbacks: registered)
              p.setup {
                prepare($0)
                $0.write(.sr, value: 0x50000)
              }
              p.verify(8, 3)
              p.verify(17, 11, 2)
              p.setup {
                $0.write(.sr, value: flag)
                $0.write(.imr, value: 0x7F)
                $0.write(.cr1, value: dma | 0x10000)
                for d in [UARTDMADirection.transmit, .receive] {
                  $0.setting(d, 10, fail)
                  $0.setting(d, 11, synchronous)
                }
              }
              p.verify(19)
            }
          }
        }
      }
    }
  }
  func testStopAbortPauseResumeAndMuteStates() {
    for state: UInt32 in [0, 1, 0x12, 0x22] {
      for lock: UInt32 in [0, 1] {
        for error: UInt32 in [0, 0x20, 0x21] {
          for op: UInt32 in [9, 10, 11, 12, 15, 16, 17, 18] {
            let p = SAIPair()
            p.setup {
              prepare($0)
              $0.write(.state, value: state)
              $0.write(.lock, value: lock)
              $0.write(.cr1, value: 0x30000)
              $0.write(.cr2, value: .max)
              for d in [UARTDMADirection.transmit, .receive] {
                $0.setting(d, 9, 1)
                $0.setting(d, 3, error)
              }
            }
            p.verify(op, 31, 2)
          }
        }
      }
    }
  }
}
