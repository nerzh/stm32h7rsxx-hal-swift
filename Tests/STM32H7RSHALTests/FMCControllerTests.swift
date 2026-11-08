import STM32H7RSHAL
import XCTest

func prepareFMC(_ f: FMCFixture, seed: UInt32 = 0xA55A_1234) {
  for i: UInt32 in 0..<88 { f.set(0, i, seed ^ (i &* 0x0101_0101)) }
}

final class FMCControllerTests: XCTestCase {
  func testNORSRAMConfigurationMasksAndSharedBankOneSettings() {
    for seed: UInt32 in [0, 0xA55A_1234, UInt32.max] {
      for bank: UInt32 in [0, 2, 4, 6] {
        for field: UInt32 in 1..<15 {
          for value: UInt32 in [0, 8, 0x100000, 0x200000, UInt32.max] {
            checkFMC(
              { f in
                prepareFMC(f, seed: seed)
                f.set(1, 0, bank)
                f.set(1, field, value)
              }, operation: 0)
          }
        }
      }
    }
  }

  func testNORSRAMTimingUnderflowAndContinuousClockPropagation() {
    for bank: UInt32 in [0, 2, 4, 6] {
      for clock: UInt32 in [0, 0x100000] {
        for field: UInt32 in 0..<7 {
          for value: UInt32 in [0, 1, 2, 15, 16, 17, 255, UInt32.max] {
            checkFMC(
              { f in
                prepareFMC(f)
                f.set(0, 0, (f.get(0, 0) & ~0x100000) | clock)
                for i: UInt32 in 0..<7 { f.set(2, i, 2) }
                f.set(2, field, value)
              }, operation: 2, bank)
          }
        }
      }
    }
  }

  func testExtendedTimingDisabledPathDoesNotReadTimingPointer() {
    for bank: UInt32 in [0, 2, 4, 6] {
      for mode: UInt32 in [0, 0x4000, UInt32.max] {
        for field: UInt32 in 0..<7 {
          for value: UInt32 in [0, 1, 15, 255, UInt32.max] {
            checkFMC(
              { f in
                prepareFMC(f)
                f.set(2, field, value)
              }, operation: 3, bank, mode)
          }
        }
        if mode != 0x4000 {
          checkFMC(
            { f in
              prepareFMC(f)
              f.set(8, 9, 1)
            }, operation: 3, bank, mode)
        }
      }
    }
  }

  func testNORSRAMResetAndWriteControlPreserveOtherBanks() {
    for operation: UInt32 in [1, 4, 5] {
      for bank: UInt32 in [0, 2, 4, 6] {
        for seed: UInt32 in [0, UInt32.max, 0x1234_5678] {
          checkFMC({ prepareFMC($0, seed: seed) }, operation: operation, bank)
        }
      }
    }
  }

  func testNANDConfigurationAndBothTimingSpaces() {
    for field: UInt32 in 0..<7 {
      for value: UInt32 in [0, 1, 4, 0x18, 0x40, 0xFFFF, UInt32.max] {
        checkFMC(
          { f in
            prepareFMC(f)
            f.set(3, field, value)
          }, operation: 6)
      }
    }
    for operation: UInt32 in [7, 8] {
      for field: UInt32 in 0..<4 {
        for value: UInt32 in [0, 1, 15, 254, 255, 256, UInt32.max] {
          for bank: UInt32 in [0, 2, UInt32.max] {
            checkFMC(
              { f in
                prepareFMC(f)
                f.set(4, field, value)
              }, operation: operation, bank)
          }
        }
      }
    }
    for operation: UInt32 in [9, 10, 11] {
      checkFMC({ prepareFMC($0) }, operation: operation, 2)
    }
  }

  func testNANDECCStrictTimeoutTickWrapAndLateReadyFlag() {
    for initialFlag: UInt32 in [0, 0x40, UInt32.max] {
      for timeout: UInt32 in [0, 1, 2, 10, UInt32.max] {
        for event: UInt32 in [0, 1, 2, 5, 12] {
          if initialFlag == 0 && timeout == UInt32.max && event != 1 { continue }
          checkFMC(
            { f in
              prepareFMC(f)
              f.set(0, 0x84 / 4, initialFlag)
              f.set(0, 0x94 / 4, 0x1234_ABCD)
              f.set(8, 0, UInt32.max - 5)
              f.set(8, 3, event)
              f.set(8, 4, 0x40)
            }, operation: 12, 2, timeout)
        }
      }
    }
    let f = FMCFixture()
    f.set(0, 0x84 / 4, 0)
    f.set(8, 3, 2)
    f.set(8, 4, 0x40)
    XCTAssertEqual(f.run(12, 2, 0), 3)
    XCTAssertEqual(f.get(9, 0), 0xC001_C0DE)
  }

  func testSDRAMConfigurationAndSharedTimingFields() {
    for bank: UInt32 in [0, 1] {
      for field: UInt32 in 1..<10 {
        for value: UInt32 in [0, 1, 0x100, 0x1800, 0x6000, UInt32.max] {
          checkFMC(
            { f in
              prepareFMC(f)
              f.set(5, 0, bank)
              f.set(5, field, value)
            }, operation: 13)
        }
      }
      for field: UInt32 in 0..<7 {
        for value: UInt32 in [0, 1, 2, 15, 16, UInt32.max] {
          checkFMC(
            { f in
              prepareFMC(f)
              for i: UInt32 in 0..<7 { f.set(6, i, 2) }
              f.set(6, field, value)
            }, operation: 14, bank)
        }
      }
      for operation: UInt32 in [15, 16, 17] {
        checkFMC({ prepareFMC($0) }, operation: operation, bank)
      }
    }
  }

  func testSDRAMCommandsRefreshAndModeBitSelection() {
    for field: UInt32 in 0..<4 {
      for value: UInt32 in [0, 1, 2, 7, 16, 8191, UInt32.max] {
        for timeout: UInt32 in [0, 1, UInt32.max] {
          checkFMC(
            { f in
              prepareFMC(f)
              f.set(7, field, value)
            }, operation: 18, timeout)
        }
      }
    }
    for operation: UInt32 in [19, 20] {
      for value: UInt32 in [0, 1, 2, 16, 8191, 8192, UInt32.max] {
        checkFMC({ prepareFMC($0) }, operation: operation, value)
      }
    }
    for bank: UInt32 in [0, 1, 2, UInt32.max] {
      for status: UInt32 in 0..<32 {
        checkFMC(
          { f in
            prepareFMC(f)
            f.set(0, 0x158 / 4, status)
          }, operation: 21, bank)
      }
    }
  }
  func testRegisterMacrosPreserveFlagAndClearSemantics() {
    for operation: UInt32 in 22...35 {
      for seed: UInt32 in [0, 1, 3, 0x55AA_55AA, UInt32.max] {
        let maximum: UInt32 = (operation == 24 || operation == 25) ? 3 : 6
        for index: UInt32 in 0...maximum {
          let mask: UInt32 =
            (operation == 24 || operation == 25) ? index * 2 : index == 6 ? UInt32.max : index
          checkFMC({ prepareFMC($0, seed: seed) }, operation: operation, mask)
        }
      }
    }
  }

}
