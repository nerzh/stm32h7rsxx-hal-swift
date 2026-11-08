import CIRDAReference
import STM32H7RSHAL
import XCTest

extension IRDAPair {
  func configuration(_ field: IRDAConfigurationWord, _ value: UInt32) {
    set(1, UInt32(field.rawValue), value)
  }
  func word(_ field: IRDAHandleWord, _ value: UInt32) { set(1, 12 + UInt32(field.rawValue), value) }
  func half(_ field: IRDAHandleHalfWord, _ value: UInt16) {
    set(1, 7 + UInt32(field.rawValue), UInt32(value))
  }
}

final class IRDADifferentialTests: XCTestCase {
  func testConfigurationClocksPartialWritesAndReinitialization() {
    for mode: UInt32 in 0...1 {
      let p = IRDAPair(mode)
      for instance in UARTInstance.allCases {
        for source: UInt32 in 0...6 {
          for prescaler: UInt32 in [0, 5, 11] {
            for divider: UInt32 in [0, 8, 24] {
              p.reset()
              p.set(2, 3, instance.rawValue)
              p.set(2, 5, source)
              p.set(2, 6, divider == 8 ? 0 : 1)
              p.set(2, 7, divider)
              p.configuration(.clockPrescaler, prescaler)
              p.configuration(.baudRate, source == 5 ? 100 : 9600)
              p.set(0, 0, 0xF3F3_F3F3)
              p.set(0, 1, 0x57A5_A5A5)
              p.set(0, 2, 0xEEFF_FFFF)
              p.set(0, 7, 0x0060_0000)
              p.word(.globalState, 0)
              p.callback(8, 0)
              p.callback(9, 0)
              p.run(0)
              p.run(1)
            }
          }
        }
      }
      for baud: UInt32 in [1, 16, 17, 1000, 65535, 65536, 64_000_000] {
        for frequency: UInt32 in [32768, 65535, 65536, 64_000_000, 0xFFFF_FFFF] {
          for source: UInt32 in [0, 3, 5, 7] {
            p.reset()
            p.configuration(.baudRate, baud)
            p.set(2, 4, frequency)
            p.set(2, 5, source)
            p.set(0, 3, 0x1357)
            p.run(23)
          }
        }
      }
    }
  }
  func testCallbacksAndMacroEncodings() {
    let p = IRDAPair(1)
    for state: UInt32 in [0, 0x20, 0x21, 0x24, 0x60] {
      for id: UInt32 in 0...11 {
        for token: UInt32 in 0...3 {
          p.reset()
          p.word(.globalState, state)
          p.word(.errorCode, 0xA0)
          p.run(2, id, token)
          p.run(3, id)
        }
      }
    }
    for mode: UInt32 in 0...1 {
      let p = IRDAPair(mode)
      for operation: UInt32 in 100...113 {
        for value: UInt32 in [0, 1, 0x20, 0x626, 0x1978, 0xFFE0, 0xA5A5_FFFF] {
          p.reset()
          p.set(0, 0, 0x81F0_FFFF)
          p.set(0, 1, 0x5678_4321)
          p.set(0, 2, 0xCDEF_4567)
          p.set(0, 6, 0xA0)
          p.set(0, 7, 0xA5A5_A5A5)
          p.set(0, 8, 0x1234)
          p.word(.globalState, 0x21)
          p.word(.receiveState, 0x22)
          p.run(operation, value)
        }
      }
    }
  }
  func testPollingWidthsTimeoutsAndTickWraparound() {
    for mode: UInt32 in 0...1 {
      let p = IRDAPair(mode)
      for length: UInt32 in [0, 0x1000, 0x1000_0000] {
        for parity: UInt32 in [0, 0x400, 0x600] {
          for flags: UInt32 in [0, 0x20, 0x80, 0xE0, 0x0200_00E0] {
            for operation: UInt32 in [4, 5] {
              p.reset()
              p.configuration(.wordLength, length)
              p.configuration(.parity, parity)
              p.set(0, 0, 0x1FF)
              p.set(0, 2, 0xC1)
              p.set(0, 7, flags)
              p.set(0, 9, 0x1A5)
              p.run(operation, 3, 5)
              p.reset()
              p.configuration(.wordLength, length)
              p.configuration(.parity, parity)
              p.set(2, 0, 0xFFFF_FFFD)
              p.set(2, 10, 4)
              p.set(2, 11, 0x0200_00E0)
              p.set(0, 9, 0x1FE)
              p.run(operation, 3, 8)
              p.reset()
              p.set(0, 7, 0x0200_00E0)
              p.run(operation, 3, UInt32.max)
            }
          }
        }
      }
      for operation: UInt32 in [4, 5, 6, 7, 8, 9] {
        for state: UInt32 in [0, 0x20, 0x21, 0x22] {
          for lock: UInt32 in 0...1 {
            for nulls: UInt32 in [0, 3] {
              p.reset()
              p.word(.globalState, state)
              p.word(.receiveState, state)
              p.word(.lock, lock)
              p.set(0, 7, 0x0200_00E0)
              p.run(operation, 0, 0, nulls)
              p.run(operation, 1, 0, nulls)
            }
          }
        }
      }
      p.reset()
      p.set(0, 0, 12)
      p.run(24)
      for timeout: UInt32 in [0, 1, 7] {
        p.reset()
        p.set(0, 0, 0x1FF)
        p.set(0, 2, 0xC1)
        p.set(2, 12, 0xFFFF_FFFF)
        p.run(25, 0x80, 0, timeout)
      }
    }
  }
  func testInterruptTransfersAndErrorPrecedence() {
    for mode: UInt32 in 0...1 {
      let p = IRDAPair(mode)
      for length: UInt32 in [0, 0x1000, 0x1000_0000] {
        for parity: UInt32 in [0, 0x400, 0x600] {
          for size: UInt32 in [1, 3, 17] {
            p.reset()
            p.configuration(.wordLength, length)
            p.configuration(.parity, parity)
            for id: UInt32 in 0..<10 { p.callback(id, mode == 0 ? 1 : 2) }
            p.run(6, size)
            p.run(7, size)
            for i in 0..<(size + 1) {
              p.set(0, 9, 0x1A5 &+ i)
              p.set(0, 7, 0x20)
              p.run(19)
              p.set(0, 7, 0x80)
              p.run(19)
            }
            p.set(0, 7, 0x0200_0040)
            p.run(19)
          }
        }
      }
      for errors: UInt32 in [1, 2, 4, 8, 15] {
        for enables: UInt32 in [0, 0x100, 0x20, 0x1E0, 0x0C00_01E0] {
          for dma: UInt32 in [0, 0x40, 0x80, 0xC0] {
            p.reset()
            p.run(6, 3)
            p.run(7, 3)
            p.set(0, 0, enables)
            p.set(0, 2, dma | 1)
            p.set(0, 7, errors | 0xE0)
            p.set(0, 9, 0x155)
            p.set(4, 9, 1)
            p.set(3, 9, 1)
            p.run(19)
          }
        }
      }
      for mutated: UInt32 in [0, 0x20, 0x22] {
        p.reset()
        p.run(7, 1)
        p.set(2, 16, 1)
        p.set(2, 17, 3)
        p.set(2, 18, mutated)
        p.set(0, 7, 0x29)
        p.run(19)
      }
    }
  }
  func testDMAStartsLinkedListAndCallbacks() {
    for mode: UInt32 in 0...1 {
      let p = IRDAPair(mode)
      for operation: UInt32 in [8, 9] {
        for dmaMode: UInt32 in [0, 0x80, 0x81, 0x82] {
          for status: UInt32 in 0...3 {
            for shape: UInt32 in 0...2 {
              for size: UInt32 in [1, 0x8001] {
                p.reset()
                p.configuration(.wordLength, 0x1000)
                p.configuration(.parity, 0)
                p.half(.receiveCount, 0xCDEF)
                for direction: UInt32 in 0...1 {
                  p.set(3 + direction, 1, dmaMode)
                  p.set(3 + direction, 6, status)
                  p.set(3 + direction, 7, status)
                  p.set(3 + direction, 4, shape == 0 ? 0 : 1)
                  p.set(3 + direction, 5, shape == 2 ? 1 : 0)
                }
                p.run(operation, size)
              }
            }
          }
        }
      }
      for event: UInt32 in [28, 29, 30, 31, 32, 33, 34, 35, 36, 37] {
        for dmaMode: UInt32 in [0, 0x80, 0x81, 0x82] {
          for state: UInt32 in [0x20, 0x21, 0x22] {
            for requests: UInt32 in [0, 0x40, 0x80, 0xC0] {
              p.reset()
              p.word(.globalState, state)
              p.word(.receiveState, state)
              p.half(.transmitCount, 7)
              p.half(.receiveCount, 9)
              p.set(0, 0, 0x1FF)
              p.set(0, 2, requests | 1)
              p.set(3, 1, dmaMode)
              p.set(4, 1, dmaMode)
              p.run(event, event & 1)
            }
          }
        }
      }
    }
  }
  func testAbortPathsFailuresAndCoordinatedCallbacks() {
    for mode: UInt32 in 0...1 {
      let p = IRDAPair(mode)
      for operation: UInt32 in [13, 14, 15, 16, 17, 18] {
        for present: UInt32 in 0...3 {
          for requests: UInt32 in [0, 0x40, 0x80, 0xC0] {
            for failure: UInt32 in 0...3 {
              p.reset()
              p.word(.globalState, 0x21)
              p.word(.receiveState, 0x22)
              p.half(.transmitCount, 7)
              p.half(.receiveCount, 9)
              p.set(0, 0, 0xFFFF_FFFF)
              p.set(0, 2, 0x1080_0001 | requests)
              p.set(3, 0, present & 1)
              p.set(4, 0, present & 2)
              p.set(3, 8, failure & 1)
              p.set(4, 8, failure >> 1)
              p.set(3, 9, failure & 1)
              p.set(4, 9, failure >> 1)
              p.set(3, 2, 0x10)
              p.set(4, 2, 0x10)
              p.run(operation)
            }
          }
        }
      }
      for order: UInt32 in 0...1 {
        p.reset()
        p.set(0, 2, 0xC0)
        p.word(.globalState, 0x21)
        p.word(.receiveState, 0x22)
        p.run(16)
        p.run(order == 0 ? 34 : 35)
        p.run(order == 0 ? 35 : 34, 1)
      }
    }
  }
  func testPauseResumeStopStateAndLockCombinations() {
    for mode: UInt32 in 0...1 {
      let p = IRDAPair(mode)
      for state: UInt32 in [0, 0x20, 0x21, 0x22] {
        for receive: UInt32 in [0, 0x20, 0x22] {
          for lock: UInt32 in 0...1 {
            p.reset()
            p.word(.globalState, state)
            p.word(.receiveState, receive)
            p.word(.lock, lock)
            p.set(0, 2, 0xC1)
            p.run(10)
            p.run(11)
            p.run(12)
          }
        }
      }
    }
  }
}
