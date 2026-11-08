import CSMARTCARDReference
import STM32H7RSHAL
import XCTest

extension SMARTCARDPair {
  func configuration(_ field: SMARTCARDConfigurationWord, _ value: UInt32) {
    set(1, UInt32(field.rawValue), value)
  }
  func word(_ field: SMARTCARDHandleWord, _ value: UInt32) {
    set(1, 32 + UInt32(field.rawValue), value)
  }
  func half(_ field: SMARTCARDHandleHalfWord, _ value: UInt16) {
    set(1, 26 + UInt32(field.rawValue), UInt32(value))
  }
  func advanced(_ field: SMARTCARDAdvancedConfigurationWord, _ value: UInt32) {
    set(1, 17 + UInt32(field.rawValue), value)
  }
}

final class SMARTCARDDifferentialTests: XCTestCase {
  func testConfigurationClocksPartialWritesAndReinitialization() {
    for mode: UInt32 in 0...1 {
      let p = SMARTCARDPair(mode)
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
            p.run(20)
          }
        }
      }
    }
  }
  func testCallbacksAndMacroEncodings() {
    let p = SMARTCARDPair(1)
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
      let p = SMARTCARDPair(mode)
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
      let p = SMARTCARDPair(mode)
      for length: UInt32 in [0x1000] {
        for parity: UInt32 in [0x400, 0x600] {
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
      p.run(22)
      for timeout: UInt32 in [0, 1, 7] {
        p.reset()
        p.set(0, 0, 0x1FF)
        p.set(0, 2, 0xC1)
        p.set(2, 12, 0xFFFF_FFFF)
        p.run(23, 0x80, 0, timeout)
      }
    }
  }
  func testInterruptTransfersAndErrorPrecedence() {
    for mode: UInt32 in 0...1 {
      let p = SMARTCARDPair(mode)
      for length: UInt32 in [0x1000] {
        for parity: UInt32 in [0x400, 0x600] {
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
              p.run(16)
              p.set(0, 7, 0x80)
              p.run(16)
            }
            p.set(0, 7, 0x0200_0040)
            p.run(16)
          }
        }
      }
      for errors: UInt32 in [1, 2, 4, 8, 15, 0x800, 0x1000, 0x80F] {
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
            p.run(16)
          }
        }
      }
      for mutated: UInt32 in [0, 0x20, 0x22] {
        p.reset()
        p.run(7, 1)
        p.set(2, 16, 1)
        p.set(2, 17, 1)
        p.set(2, 18, mutated)
        p.set(0, 7, 0x29)
        p.run(16)
      }
    }
  }
  func testDMAStartsLinkedListAndCallbacks() {
    for mode: UInt32 in 0...1 {
      let p = SMARTCARDPair(mode)
      for operation: UInt32 in [8, 9] {
        for dmaMode: UInt32 in [0, 0x80, 0x81, 0x82] {
          for status: UInt32 in 0...3 {
            for shape: UInt32 in 0...2 {
              for size: UInt32 in [1, 0x8001] {
                p.reset()
                p.configuration(.wordLength, 0x1000)

                p.half(.receiveCount, 0xCDEF)
                p.dmaCallback(0, 1, 5)
                p.dmaCallback(1, 1, 5)
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
      for event: UInt32 in [26, 27, 28, 29, 30, 31, 32, 33] {
        for dmaMode: UInt32 in [0, 0x80, 0x81, 0x82] {
          for state: UInt32 in [0x20, 0x21, 0x22] {
            for requests: UInt32 in [0, 0x40, 0x80, 0xC0] {
              p.reset()
              p.word(.globalState, state)
              p.word(.receiveState, state)
              p.half(.transmitCount, 7)
              p.half(.receiveCount, 9)
              p.word(.txISR, 1)
              p.word(.rxISR, 3)
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
      let p = SMARTCARDPair(mode)
      for operation: UInt32 in [10, 11, 12, 13, 14, 15] {
        for present: UInt32 in 0...3 {
          for requests: UInt32 in [0, 0x40, 0x80, 0xC0] {
            for failure: UInt32 in 0...3 {
              p.reset()
              p.word(.globalState, 0x21)
              p.word(.receiveState, 0x22)
              p.half(.transmitCount, 7)
              p.half(.receiveCount, 9)
              p.word(.txISR, 1)
              p.word(.rxISR, 3)
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
        p.run(13)
        p.run(order == 0 ? 30 : 31)
        p.run(order == 0 ? 31 : 30, 1)
      }
    }
  }
  func testFIFOTransmitReadyPrecedesCompletionUntilThresholdInterruptIsCleared() {
    for mode: UInt32 in 0...1 {
      let p = SMARTCARDPair(mode)
      p.run(43)
      p.run(6, 1)
      p.set(0, 7, 0xC0)
      p.run(16)
      p.run(16)
      XCTAssertEqual(p.swift.read(SMARTCARDHandleHalfWord.transmitCount), 0)
      XCTAssertEqual(p.swift.read(SMARTCARDHandleWord.globalState), 0x21)
      XCTAssertEqual(p.swift.read(UARTRegister.cr3) & 0x0080_0000, 0x0080_0000)
      p.set(0, 2, p.swift.read(UARTRegister.cr3) & ~UInt32(0x0080_0000))
      p.run(16)
      XCTAssertEqual(p.swift.read(SMARTCARDHandleWord.globalState), 0x20)
    }
  }

  func testAdvancedSettingsFIFOTailsAndCompletionSelection() {
    for mode: UInt32 in 0...1 {
      let p = SMARTCARDPair(mode)
      for features: UInt32 in [0, 1, 2, 4, 8, 0x10, 0x20, 0x80, 0x100, 0x1FF] {
        p.reset()
        p.advanced(.features, features)
        p.advanced(.txPinLevelInvert, 0x20000)
        p.advanced(.rxPinLevelInvert, 0x10000)
        p.advanced(.dataInvert, 0x40000)
        p.advanced(.swap, 0x8000)
        p.advanced(.overrunDisable, 0x1000)
        p.advanced(.dmaDisableOnReceiveError, 0x2000)
        p.advanced(.mostSignificantBitFirst, 0x80000)
        p.advanced(.transmitCompletionIndication, 0x1978)
        p.set(0, 7, 0x600000)
        p.run(0)
        p.run(21)
        p.run(114)
        p.run(115)
      }
      for nack: UInt32 in [0, 0x10] {
        for transferMode: UInt32 in [4, 8, 12] {
          for completion: UInt32 in [0x626, 0x1978] {
            for threshold: UInt32 in 0...5 {
              for size: UInt32 in [1, 3, 17] {
                p.reset()
                p.configuration(.nackEnable, nack)
                p.configuration(.mode, transferMode)
                p.advanced(.transmitCompletionIndication, completion)
                p.set(0, 7, 0x0200_00E0)
                p.run(4, size, 1)
                p.run(43)
                p.run(45, threshold << 29)
                p.run(46, threshold << 25)
                for id: UInt32 in 0..<10 { p.callback(id, mode == 0 ? 1 : 2) }
                p.run(6, size)
                p.run(7, size)
                for _ in 0..<20 {
                  p.set(0, 7, 0x20)
                  p.run(16)
                  p.set(0, 7, 0x80)
                  p.run(16)
                }
                p.set(0, 7, 0x0200_0040)
                p.run(16)
                p.run(44)
              }
            }
          }
        }
      }
      for state: UInt32 in [0, 0x20, 0x21, 0x22] {
        for lock: UInt32 in 0...1 {
          p.reset()
          p.word(.globalState, state)
          p.word(.lock, lock)
          p.run(39, 255)
          p.run(40, 0xFE12_3456)
          p.run(41)
          p.run(42)
          p.run(43)
          p.run(44)
        }
      }
      for flag: UInt32 in [0x800000, 0x1000000, 0x1800000, 0x1000] {
        p.reset()
        p.set(0, 0, 0xC800_0000)
        p.set(0, 7, flag)
        p.run(16)
      }
    }
  }
}
