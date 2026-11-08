import CUSARTReference
import STM32H7RSHAL
import XCTest

final class USARTDifferentialTests: XCTestCase {
  func testRegisterMacrosMaskingAndResetCallbacks() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for value: UInt32 in [
        0, 1, 0x28, 0x525, 0x626, 0x727, 0x183F, 0x1B77, 0x1A7C, 0x800000, 0xFFFF_183F, 0xFFFF_FFFF,
      ] {
        for bits: UInt32 in [0, 0x1234_5678, 0xFFFF_FFFF] {
          p.reset()
          for r: UInt32 in [0, 1, 2, 6, 7, 8] { p.set(0, r, bits) }
          for op: UInt32 in 100...111 { p.run(op, value) }
        }
      }
    }
  }
  func testConfigurationClocksDividerBoundsAndPartialWrites() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for instance: UInt32 in [0x4200_1000, 0x4000_4400, 0x4000_4800, 0x4000_4C00] {
        for source: UInt32 in 0...7 {
          for prescaler: UInt32 in 0...11 {
            p.reset()
            p.set(2, 3, instance)
            p.set(2, 5, source)
            p.set(2, 6, 1)
            p.set(2, 7, 16)
            p.set(1, 8, prescaler)
            p.set(1, 1, [UInt32(0), 0x1000, 0x1000_0000][Int(prescaler % 3)])
            p.set(1, 2, (prescaler & 3) << 12)
            p.set(1, 3, prescaler & 1 == 0 ? 0 : 0x600)
            p.set(1, 5, (prescaler & 1) << 10)
            p.set(1, 6, (prescaler & 1) << 9)
            p.set(1, 7, (prescaler & 1) << 8)
            for r: UInt32 in [0, 1, 2, 3, 11] { p.set(0, r, 0xA55A_FEEF) }
            p.set(1, 16, 1)
            p.set(1, 17, 0x2000_0000)
            p.set(1, 18, 4)
            p.set(1, 19, 3)
            p.run(32)
          }
        }
      }
      for frequency: UInt32 in [0, 7, 8, 15, 16, 32767, 32768, 65535, UInt32.max] {
        for baud: UInt32 in [1, 2, 115200, 12_500_000] {
          p.reset()
          p.set(2, 4, frequency)
          p.set(1, 0, baud)
          p.run(32)
        }
      }
    }
  }
  func testInitializationTimeoutsReinitializationMSPHooksAndDeinitialization() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for state: UInt32 in [0, 1, 2, 0x12, 0x22, 0x32] {
        for flags: UInt32 in [0, 0x200000, 0x400000, 0x600000] {
          p.reset()
          p.set(1, 21, state)
          p.set(1, 20, 1)
          p.set(0, 7, flags)
          p.set(2, 1, 501)
          p.set(1, 16, 1)
          p.set(1, 17, 0x2000_0000)
          p.callback(9, 2)
          p.callback(10, 0)
          p.run(0)
          p.run(1)
        }
      }
      p.reset()
      p.set(1, 21, 0)
      p.set(0, 7, 0x600000)
      p.set(2, 13, 1)
      p.set(2, 14, 9)
      p.set(2, 15, 0x32)
      XCTAssertEqual(p.run(0), 0)
      XCTAssertEqual(p.swift.get(1, 21), 1)
    }
  }
  func testExtendedFIFOThresholdsSlaveModeAndLock() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for enabled: UInt32 in [0, 1] {
        for locked: UInt32 in [0, 1] {
          for tx: UInt32 in 0...5 {
            for rx: UInt32 in 0...5 {
              p.reset()
              p.set(0, 0, 0x1000_000C | enabled)
              p.set(1, 20, locked)
              p.set(0, 2, (tx << 29) | (rx << 25))
              p.run(46)
              p.run(48, tx << 29)
              p.run(49, rx << 25)
              p.run(47)
              p.run(43)
              p.run(45, 8)
              p.run(44)
            }
          }
        }
      }
    }
  }
  func testCallbackRegistrationStatesNilAndUnknownIDs() {
    let p = USARTPair(1)
    for state: UInt32 in [0, 1, 2, 0x12, 0x22, 0x32, 3, 4] {
      for id: UInt32 in 0...12 {
        for implementation: UInt32 in 0...3 {
          p.reset()
          p.set(1, 21, state)
          p.set(1, 22, 0x8000)
          p.run(2, id, implementation)
          p.run(3, id)
        }
      }
    }
  }
  func testPollingDataWidthsParitySlaveDummyDataAndFlush() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for op: UInt32 in 4...6 {
        for word: UInt32 in [0, 0x1000, 0x1000_0000] {
          for parity: UInt32 in [0, 0x400, 0x600] {
            for slave: UInt32 in [0, 1] {
              for size: UInt32 in [1, 2, 9] {
                p.reset()
                p.set(1, 1, word)
                p.set(1, 3, parity)
                p.set(1, 16, slave)
                p.set(0, 7, 0xE0)
                p.set(0, 9, 0xFEDC_BA98)
                XCTAssertEqual(p.run(op, size, 100), 0)
              }
            }
          }
        }
      }
    }
  }
  func testTransferGuardsAndPollingTimeoutBoundaries() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for op: UInt32 in 4...12 {
        for state: UInt32 in [0, 1, 2, 0x12, 0x22, 0x32] {
          for locked: UInt32 in [0, 1] {
            for nulls: UInt32 in 0...3 {
              p.reset()
              p.set(1, 21, state)
              p.set(1, 20, locked)
              p.set(0, 7, 0xE0)
              p.run(op, nulls == 0 ? 0 : 2, 3, nulls)
            }
          }
        }
      }
      for op: UInt32 in 4...6 {
        for timeout: UInt32 in [0, 1, 2, 4] {
          p.reset()
          p.set(2, 0, UInt32.max - 2)
          p.set(2, 10, 4)
          p.set(2, 11, 0xE0)
          p.run(op, 3, timeout)
        }
      }
      for op: UInt32 in 4...6 {
        p.reset()
        p.set(0, 7, 0xE0)
        p.run(op, 3, UInt32.max)
      }
      for status: UInt32 in [0, 1] {
        p.reset()
        p.set(2, 0, UInt32.max - 2)
        p.set(2, 12, UInt32.max - 2)
        p.set(0, 7, status == 0 ? 0 : 0x80)
        p.set(2, 10, 4)
        p.set(2, 11, status == 0 ? 0x80 : 0)
        p.run(31, 0x80, status, 2)
      }
    }
  }
  func testInterruptTransfersFIFOWidthsTailSwitchAndCompletionOrder() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for op: UInt32 in 7...9 {
        for fifo: UInt32 in [0, 0x2000_0000] {
          for word: UInt32 in [0, 0x1000, 0x1000_0000] {
            for parity: UInt32 in [0, 0x400] {
              for slave: UInt32 in [0, 1] {
                for size: UInt32 in [1, 3, 7] {
                  p.reset()
                  p.set(1, 1, word)
                  p.set(1, 3, parity)
                  p.set(1, 16, slave)
                  p.set(1, 17, fifo)
                  p.set(1, 14, 2)
                  p.set(1, 15, 2)
                  p.set(0, 9, 0xDEAD_BEEF)
                  XCTAssertEqual(p.run(op, size), 0)
                  for _ in 0..<12 {
                    if p.swift.get(1, 21) == 1 { break }
                    p.set(0, 7, 0x80)
                    p.run(18)
                    p.set(0, 7, 0x20)
                    p.run(18)
                    p.set(0, 7, 0x40)
                    p.run(18)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  func testInterruptErrorsUnderrunEarlyReturnDMAFallbackAndFIFOCallbacks() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for state: UInt32 in [1, 0x12, 0x22, 0x32] {
        for flags: UInt32 in [1, 2, 4, 8, 0x800, 0x2000, 0x280F, 0x800000, 0x1000000, 0x1800000] {
          for sources: UInt32 in [0, 1, 0x20, 0x1000_0001] {
            for linked: UInt32 in [0, 1] {
              p.reset()
              p.set(1, 21, state)
              p.set(0, 7, flags)
              p.set(0, 0, 0xC400_0120)
              p.set(0, 2, sources | (linked << 6) | 0x80)
              p.set(4, 0, linked)
              p.set(4, 9, 1)
              p.run(18)
            }
          }
        }
      }
    }
  }
  func testDMAStartsLinkedListsMissingHandlesFailuresAndByteCountWrapping() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for op: UInt32 in 10...12 {
        for config: UInt32 in 0..<48 {
          for size: UInt32 in [1, 0x8001, 0xFFFF] {
            p.reset()
            p.set(1, 1, 0x1000)
            p.set(1, 16, config & 1)
            p.set(1, 10, 77)
            p.set(1, 12, 88)
            p.set(3, 0, (config >> 1) & 1)
            p.set(4, 0, (config >> 2) & 1)
            p.set(3, 1, config & 8 != 0 ? 0x80 : 0)
            p.set(4, 1, config & 8 != 0 ? 0x81 : 0)
            p.set(3, 4, config % 3 == 0 ? 0 : 1)
            p.set(4, 5, config % 5 == 0 ? 0 : 1)
            p.set(3, 6, (config >> 4) & 1)
            p.set(4, 7, (config >> 5) & 1)
            p.run(op, size)
          }
        }
      }
    }
  }
  func testDMAPauseResumeStopAbortFailuresAndCallbackCoordination() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for op: UInt32 in 13...17 {
        for state: UInt32 in [0, 1, 0x12, 0x22, 0x32] {
          for flags: UInt32 in [0, 0x40, 0x80, 0xC0] {
            for failure: UInt32 in 0...3 {
              p.reset()
              p.set(1, 21, state)
              p.set(0, 2, flags | 0x1080_0001)
              p.set(0, 0, 0x1E0)
              p.set(1, 17, 0x2000_0000)
              p.set(1, 10, 5)
              p.set(1, 12, 7)
              p.set(3, 2, failure & 1 != 0 ? 0x10 : 0x20)
              p.set(4, 2, failure & 2 != 0 ? 0x10 : 0x20)
              for i: UInt32 in 8...11 {
                p.set(3, i, failure & 1)
                p.set(4, i, (failure >> 1) & 1)
              }
              p.run(op)
              if op == 17 {
                if CUSART_GetDMACallback(p.swift.state, 0, 3) != 0 { p.run(29, 0) }
                if CUSART_GetDMACallback(p.swift.state, 1, 3) != 0 { p.run(30, 1) }
              }
            }
          }
        }
      }
    }
  }
  func testDMACallbacksCircularModeAndStateChangesInsideUserCallbacks() {
    for mode: UInt32 in 0...1 {
      let p = USARTPair(mode)
      for op: UInt32 in 23...30 {
        for state: UInt32 in [0, 1, 0x12, 0x22, 0x32] {
          for dmaMode: UInt32 in [0, 0x80, 0x81, 0x181] {
            for mutate: UInt32 in [0, 1] {
              p.reset()
              p.set(1, 21, state)
              p.set(1, 10, 7)
              p.set(1, 12, 9)
              p.set(0, 0, 0x1E0)
              p.set(0, 2, 0x1080_00C1)
              p.set(3, 1, dmaMode)
              p.set(4, 1, dmaMode)
              p.set(2, 13, mutate)
              p.set(2, 14, op == 25 ? (state == 0x22 ? 3 : 4) : 5)
              p.set(2, 15, 0x32)
              p.run(op, op == 25 || op == 26 || op == 28 || op == 30 ? 1 : 0)
            }
          }
        }
      }
    }
  }
}
