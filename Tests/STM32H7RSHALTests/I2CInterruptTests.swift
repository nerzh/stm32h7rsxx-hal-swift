import CI2CReference
import STM32H7RSHAL
import XCTest

final class I2CInterruptTests: XCTestCase {
  private let transfers: [UInt32] = [
    10, 11, 12, 13, 14, 15, 16, 17, 20, 21, 22, 23, 25, 26, 27, 28, 29, 30, 31, 32,
  ]
  private let options: [UInt32] = [
    0xFFFF_0000, 0, 0x1000000, 0x2000000, 0x4000000, 0x8000000, 0xAA, 0xAA00,
  ]

  private func prepare(_ f: I2CFixture, state: UInt32 = 0x20) {
    f.write(.state, value: state)
    f.write(.addressingMode, value: 1)
    f.write(.isr, value: 0x10008)
    f.control(15, 0xA57B)
    f.control(14, 3)
    for i in 0..<4096 { f.buffer[i] = UInt8(truncatingIfNeeded: i &* 17 &+ 11) }
    for direction: UARTDMADirection in [.transmit, .receive] {
      f.setting(direction, 0, 1)
      f.setting(direction, 3, 1)
      f.setting(direction, 4, 1)
      f.setting(direction, 5, 1)
    }
    if f.control(31) != 0 {
      for id: UInt32 in 0..<12 { CI2C_SetCallback(f.state, id, CI2C_Callback(id, 2)) }
    }
  }

  func testTransferStartStatesLengthsOptionsAndAddressModes() {
    for registered in [false, true] {
      for op in transfers {
        for size: UInt32 in [0, 1, 2, 254, 255, 256, 257, 511, 65535] {
          for option in options {
            let pair = I2CPair(callbacks: registered)
            pair.setup {
              prepare($0, state: op >= 29 ? 0x28 : 0x20)
              $0.control(17, option)
              $0.write(.previousState, value: size & 1 == 0 ? 0x11 : 0x12)
              $0.write(.addressingMode, value: size & 1 == 0 ? 1 : 2)
              $0.control(16, size & 1 == 0 ? 1 : 2)
              $0.setting(.transmit, 1, size & 1 == 0 ? 0 : 0x80)
              $0.setting(.receive, 1, size & 1 == 0 ? 0 : 0x80)
            }
            pair.verify(op, 0x356, size)
          }
        }
      }
    }
  }

  func testRejectedStartsRetainOriginalPartialWrites() {
    for registered in [false, true] {
      for op in transfers + [33, 34, 35] {
        for state: UInt32 in [0, 0x20, 0x21, 0x22, 0x24, 0x28, 0x29, 0x2A, 0x60] {
          for scenario: UInt32 in 0..<5 {
            let pair = I2CPair(callbacks: registered)
            pair.setup {
              prepare($0, state: state)
              $0.write(.cr1, value: 0xC0FE)
              $0.write(.mode, value: scenario & 1 == 0 ? 0x10 : 0x20)
              $0.write(.lock, value: scenario == 0 ? 1 : 0)
              $0.write(.isr, value: scenario == 1 ? 0x8000 : 0)
              $0.control(13, scenario == 2 ? 1 : 0)
              $0.control(17, 0x2000000)
              $0.setting(.transmit, 0, scenario == 3 ? 0 : 1)
              $0.setting(.receive, 0, scenario == 3 ? 0 : 1)
            }
            pair.verify(op, 0xA0, scenario == 4 ? 0 : 3)
          }
        }
      }
    }
  }

  func testDMAStartFailuresAndMissingLinkedListQueue() {
    for op in transfers.filter({ [14, 15, 16, 17, 22, 23, 26, 28, 30, 32].contains($0) }) {
      for status: UInt32 in 0..<4 {
        for configuration: UInt32 in 0..<5 {
          let pair = I2CPair()
          pair.setup {
            prepare($0, state: op >= 29 ? 0x28 : 0x20)
            $0.control(17, 0x1000000)
            for direction: UARTDMADirection in [.transmit, .receive] {
              $0.setting(direction, 0, configuration == 0 ? 0 : 1)
              $0.setting(direction, 1, configuration >= 2 ? 0x80 : 0)
              $0.setting(direction, 4, configuration == 2 ? 0 : 1)
              $0.setting(direction, 6, status)
              $0.setting(direction, 7, status)
            }
          }
          pair.verify(op, 0xA0, 257)
        }
      }
    }
  }

  func testEventDispatchFlagsMasksTransferStatesAndCallbacks() {
    let flags: [UInt32] = [
      0, 1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x12, 0x24, 0x60, 0xA0, 0xEF, 0xA50008, 0xA60008,
    ]
    for registered in [false, true] {
      for isr: UInt32 in 0...6 {
        for state: UInt32 in [0x20, 0x21, 0x22, 0x28, 0x29, 0x2A, 0x60] {
          for flags in flags {
            for enabled: UInt32 in [0, 0xFE, 0xC0FE] {
              let pair = I2CPair(callbacks: registered)
              pair.setup {
                prepare($0, state: state)
                $0.write(.transferISR, value: isr)
                $0.write(.transferCount, value: flags & 1 == 0 ? 1 : 257)
                $0.write(.transferSize, value: flags & 1 == 0 ? 0 : 255)
                $0.write(.transferOptions, value: flags & 2 == 0 ? 0xFFFF_0000 : 0x1000000)
                $0.write(.previousState, value: state & 1 == 0 ? 0x22 : 0x21)
                $0.write(
                  .mode, value: isr == 2 || isr == 5 ? 0x40 : (isr == 3 || isr == 6 ? 0x20 : 0x10))
                $0.write(.isr, value: flags)
                $0.write(.cr1, value: enabled)
                $0.write(.cr2, value: flags & 1 == 0 ? 0x2000000 : 0)
                $0.write(.rxdr, value: 0xABCD_1234)
                $0.write(.memoryAddress, value: 0xA75B)
                $0.write(.ownAddress1, value: 0x355)
                $0.write(.oar1, value: 0x355)
                $0.write(.oar2, value: 0xA6)
                for direction: UARTDMADirection in [.transmit, .receive] {
                  $0.setting(direction, 9, 2)
                  $0.setting(direction, 10, 1)
                }
              }
              pair.verify(36)
            }
          }
        }
      }
    }
  }

  func testErrorInterruptsAbortDMAAndCallbackMutations() {
    for registered in [false, true] {
      for state: UInt32 in [0x20, 0x21, 0x22, 0x28, 0x29, 0x2A, 0x60] {
        for previous: UInt32 in [0, 0x11, 0x12, 0x21, 0x22] {
          for scenario: UInt32 in 0..<8 {
            let pair = I2CPair(callbacks: registered)
            pair.setup {
              prepare($0, state: state)
              $0.write(.previousState, value: previous)
              $0.write(.transferCount, value: 19)
              $0.write(.isr, value: scenario == 0 ? 0 : 0x730)
              $0.write(.cr1, value: scenario == 1 ? 0 : 0xC0FE)
              $0.write(.errorCode, value: scenario == 0 ? 1 : 0)
              $0.control(20, 8)
              $0.control(21, 10)
              $0.control(22, 0x28)
              for direction: UARTDMADirection in [.transmit, .receive] {
                $0.setting(direction, 3, scenario < 2 ? 1 : 2)
                $0.setting(direction, 8, scenario == 2 ? 1 : 0)
                $0.setting(direction, 11, scenario >= 3 ? 1 : 0)
                $0.setting(direction, 0, scenario == 7 ? 0 : 1)
              }
            }
            pair.verify(37)
          }
        }
      }
    }
  }

  func testDMACompletionReloadFailuresAndAsynchronousAbort() {
    for registered in [false, true] {
      for op: UInt32 in 58...63 {
        for count: UInt16 in [0, 1, 254, 255, 256, 257, 511] {
          for scenario: UInt32 in 0..<6 {
            let pair = I2CPair(callbacks: registered)
            pair.setup {
              prepare($0, state: scenario & 1 == 0 ? 0x21 : 0x2A)
              $0.write(.transferCount, value: count)
              $0.write(.transferSize, value: 255)
              $0.write(.transferISR, value: 4)
              $0.write(.previousState, value: 0x11)
              $0.write(.cr1, value: 0xC0FE)
              $0.write(.lock, value: 1)
              $0.write(.transferOptions, value: 0x1000000)
              for direction: UARTDMADirection in [.transmit, .receive] {
                $0.setting(direction, 1, scenario >= 3 ? 0x80 : 0)
                $0.setting(direction, 4, scenario == 3 ? 0 : 1)
                $0.setting(direction, 6, scenario == 2 ? 1 : 0)
                $0.setting(direction, 7, scenario == 4 ? 1 : 0)
                $0.writeCallback(direction, id: .abort, value: $0.callback(.abort))
              }
            }
            pair.verify(op)
          }
        }
      }
    }
  }
  func testTenBitAddressFirstAndSecondEventsAndDualAddress() {
    for registered in [false, true] {
      for own: UInt32 in [0, 0x155, 0x2AA, 0x355, 0x3FF] {
        for match: UInt32 in [0, 2, 4, 6, 0x70, 0x72, 0x74, 0x76] {
          for eventCount: UInt32 in [0, 1, 2, .max] {
            let pair = I2CPair(callbacks: registered)
            pair.setup {
              prepare($0, state: 0x28)
              $0.write(.transferISR, value: 3)
              $0.write(.addressingMode, value: 2)
              $0.write(.oar1, value: own)
              $0.write(.oar2, value: 0xA6)
              $0.write(.addressEventCount, value: eventCount)
              $0.write(.cr1, value: 0xFE)
              $0.write(.isr, value: (match << 16) | 8)
            }
            pair.verify(36)
          }
        }
      }
    }
  }

}
