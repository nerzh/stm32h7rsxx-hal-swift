import CSMBUSReference
import STM32H7RSHAL
import XCTest

final class SMBUSConfigurationTests: XCTestCase {
  func testInitializeAndDeinitializePreserveConfigurationAndCallbackModes() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 1, 2, 8, 0x12, 0x4A] {
        for own: UInt32 in [0, 0x52, 0x3FF] {
          for pec: UInt32 in [0, 0x800000] {
            for mode: UInt32 in [0, 0x100000, 0x200000] {
              let p = SMBUSPair(callbacks: callbacks)
              p.setup { f in
                f.write(.state, value: state)
                f.write(.lock, value: 1)
                f.write(.timing, value: .max)
                f.write(.smbusTimeout, value: 0xFFFF_FFFF)
                f.write(.analogFilter, value: 0x1000)
                f.write(.ownAddress1, value: own)
                f.write(.addressingMode, value: 1)
                f.write(.dualAddressMode, value: 0x8000)
                f.write(.ownAddress2, value: 0xA4)
                f.write(.ownAddress2Masks, value: 7)
                f.write(.generalCallMode, value: 0x80000)
                f.write(.noStretchMode, value: 0x20000)
                f.write(.packetErrorCheckMode, value: pec)
                f.write(.peripheralMode, value: mode)
                for r in I2CRegister.allCases { f.write(r, value: 0xA5A5_5A5A) }
                f.write(.mspInitialize, value: nil)
                f.write(.mspDeinitialize, value: nil)
              }
              p.verify(0)
              XCTAssertEqual(p.swift.read(.timingr), 0xF0FF_FFFF)
              XCTAssertEqual(p.swift.read(.timeoutr), .max)
              p.verify(1)
            }
          }
        }
      }
    }
  }

  func testFiltersWakeupAndFastModePlusStateLockGuards() {
    for op: UInt32 in [2, 3, 31, 32, 33] {
      for state: UInt32 in [0, 1, 2, 8, 0x12, 0x22, 0x3A, 0x4A] {
        for lock: UInt32 in [0, 1] {
          for value: UInt32 in [0, 1, 15, 0x1000, 0x1000000, .max] {
            let p = SMBUSPair()
            p.setup { f in
              f.write(.state, value: state)
              f.write(.lock, value: lock)
              f.write(.cr1, value: 0xA5A5_5A5A)
            }
            p.verify(op, value)
          }
        }
      }
    }
  }

  func testCallbackRegistrationAndResetAcrossStatesAndLocks() {
    for op: UInt32 in 4...7 {
      for state: UInt32 in [0, 1, 2, 8, 0x12, 0x4A] {
        for lock: UInt32 in [0, 1] {
          for id: UInt32 in 0...9 {
            for token: UInt32 in 0...2 {
              let p = SMBUSPair()
              p.setup { f in
                f.write(.state, value: state)
                f.write(.lock, value: lock)
                f.write(.errorCode, value: 0x8000)
              }
              p.verify(op, id, token)
              p.verify(108)
            }
          }
        }
      }
    }
  }

  func testAllPublicAndPrivateMacrosUseOriginalEncodings() {
    for callbacks in [false, true] {
      for op: UInt32 in 100...119 {
        for a: UInt32 in [0, 1, 2, 8, 0x1FFFF, 0x8000_0000, 0xAA00_0000, .max] {
          let p = SMBUSPair(callbacks: callbacks)
          p.setup { f in
            for r in I2CRegister.allCases { f.write(r, value: 0xA5FE_A5A5) }
            f.write(.state, value: 0x4A)
          }
          p.verify(op, a, 0x152)
        }
      }
    }
  }

  func testTransferConfigurationRetainsRequestBitAndNarrowsArguments() {
    for address: UInt32 in [0, 0x52, 0x3FF, 0xFFFF, 0x10052] {
      for size: UInt32 in [0, 1, 255, 256, 0xFFFF] {
        for request: UInt32 in [0, 0x4000, 0x8000_2000, 0x8000_2400] {
          for mode: UInt32 in [0, 0x1000000, 0x2000000, 0x4000000, 0x7000000] {
            let p = SMBUSPair()
            p.setup { f in
              f.write(.cr2, value: 0xA5A5_5A5A)
              f.control(19, mode)
            }
            p.verify(29, address, size, request)
            if request & 0x8000_0000 != 0 { XCTAssertNotEqual(p.swift.read(.cr2) & 0x8000_0000, 0) }
          }
        }
      }
    }
  }

  func testInterruptMasksAndOtherOptionsConversion() {
    for op: UInt32 in [24, 25, 30] {
      for bits: UInt32 in [0, 2, 4, 8, 0x38, 0x80, 0xD4, 0xF2, 0xF6, 0xFE, .max] {
        let p = SMBUSPair()
        p.setup { f in
          f.write(.cr1, value: 0xA5A5_FFFF)
          f.write(.transferOptions, value: bits)
        }
        p.verify(op, bits)
      }
    }
  }
}
