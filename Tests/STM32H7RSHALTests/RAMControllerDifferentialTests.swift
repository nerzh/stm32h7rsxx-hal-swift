import XCTest

final class RAMControllerDifferentialTests: XCTestCase {
  func testInitializationAndDeinitializationAcrossStatesBanksAndCallbackModes() {
    for sdram in [false, true] {
      for variant: UInt32 in [0, 1] {
        for operation: UInt32 in [0, 1] {
          for state: UInt32 in [0, 1, 2, 3, 4, 5] {
            for bank: UInt32 in (sdram ? [0, 1] : [0, 2, 4, 6]) {
              for token: UInt32 in [0, 2] {
                checkRAM(
                  sdram,
                  { f in
                    f.set(1, 0, bank)
                    f.set(2, 0, 1)
                    f.set(2, 1, state)
                    f.set(6, 6, 1)
                    for i: UInt32 in 0..<(sdram ? 5 : 4) { f.set(10, i, token) }
                    for i: UInt32 in 0..<88 { f.set(0, i, 0xA5A5_0000 | i) }
                  }, variant: variant, operation: operation)
              }
            }
          }
        }
      }
    }
  }

  func testCallbackRegistrationUnregistrationAndReset() {
    for sdram in [false, true] {
      for variant: UInt32 in [0, 1] {
        for operation: UInt32 in [sdram ? 11 : 10, sdram ? 12 : 11, sdram ? 13 : 12, 50] {
          for state: UInt32 in [0, 1, 2, 3, 4, 5] {
            for lock: UInt32 in [0, 1] {
              for id: UInt32 in [0, 1, 2, 3, 4, 5, 0xFFFF_FFFF] {
                for token: UInt32 in [0, 2] {
                  checkRAM(
                    sdram,
                    { f in
                      f.set(2, 0, lock)
                      f.set(2, 1, state)
                    }, variant: variant, operation: operation, id, token)
                }
              }
            }
          }
        }
      }
    }
  }

  func testWriteControlAndGetStatePreserveSourceLockingDifferences() {
    for sdram in [false, true] {
      for operation: UInt32 in [sdram ? 14 : 13, sdram ? 15 : 14, sdram ? 20 : 15] {
        for state: UInt32 in [0, 1, 2, 3, 4, 5, 0xFFFF_FFFF] {
          for lock: UInt32 in [0, 1] {
            for bank: UInt32 in (sdram ? [0, 1] : [0, 2, 4, 6]) {
              checkRAM(
                sdram,
                { f in
                  f.set(1, 0, bank)
                  f.set(2, 0, lock)
                  f.set(2, 1, state)
                  for i: UInt32 in 0..<88 { f.set(0, i, 0x8765_4321) }
                }, operation: operation)
            }
          }
        }
      }
    }
  }

  func testSDRAMCommandsRefreshPrechargedStateAndMode() {
    for operation: UInt32 in [16, 17, 18, 19] {
      for state: UInt32 in [0, 1, 2, 3, 4, 5] {
        for value: UInt32 in [0, 1, 2, 7, 0xFFFF_FFFF] {
          checkRAM(
            true,
            { f in
              f.set(2, 1, state)
              f.set(5, 0, value)
              f.set(5, 1, 0x18)
              f.set(5, 2, value)
              f.set(5, 3, 0xA5)
              f.set(0, 0x158 / 4, 0xFFFF_FFFF)
            }, operation: operation, value)
        }
      }
    }
  }

  func testRefreshInterruptObservesLiveCallbackAndClearsAfterward() {
    for variant: UInt32 in [0, 1] {
      for flags: UInt32 in [0, 1, 2, 3, 0xFFFF_FFFF] {
        for mutation: UInt32 in [0, 1] {
          checkRAM(
            true,
            { f in
              f.set(0, 0x158 / 4, flags)
              f.set(0, 0x154 / 4, 0xA5A5_0000)
              f.set(6, 10, mutation)
              f.set(6, 11, 2)
              f.set(6, 12, 3)
              f.set(6, 13, 1)
              f.set(6, 14, 0)
            }, variant: variant, operation: 2)
        }
      }
    }
  }

  func testInitializedDMAAndMSPDefaultsInvokeCorrectCallbacks() {
    for sdram in [false, true] {
      for variant: UInt32 in [0, 1] {
        let c = makeRAMFixture(sdram, variant: variant)
        let s = makeRAMFixture(sdram, variant: variant)
        for f in [c, s] {
          f.set(2, 1, 0)
          for i: UInt32 in 0..<(sdram ? 5 : 4) { f.set(10, i, 0) }
        }
        for (op, event): (UInt32, UInt32) in [(0, 0), (51, 0), (51, 1), (51, 2), (1, 0)] {
          XCTAssertEqual(s.run(op, event, 0, 0), c.runReference(op, event, 0, 0))
          XCTAssertEqual(c.compare(to: s), 0)
        }
      }
    }
  }
}
