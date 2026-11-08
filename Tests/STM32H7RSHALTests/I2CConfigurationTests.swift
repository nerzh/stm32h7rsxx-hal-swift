import CI2CReference
import STM32H7RSHAL
import XCTest

final class I2CConfigurationTests: XCTestCase {
  func testInitializeAndDeinitializeRegisterReplacementAndCallbacks() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 0x20, 0x24, 0x21, 0x28, 0x60] {
        for addressMode: UInt32 in [1, 2, 0, 0xFFFF_FFFF] {
          for value: UInt32 in [0, 1, 0xA5A5_A5A5, 0xFFFF_FFFF] {
            let p = I2CPair(callbacks: callbacks)
            p.setup { f in
              for reg in I2CRegister.allCases { f.write(reg, value: .max) }
              for word in I2CConfigurationWord.allCases { f.write(word, value: value) }
              f.write(.addressingMode, value: addressMode)
              f.write(.state, value: state)
              f.write(.lock, value: 1)
              f.write(.errorCode, value: .max)
              f.write(.previousState, value: .max)
              for id in I2CCallbackID.allCases {
                CI2C_SetCallback(f.state, id.rawValue, CI2C_Callback(id.rawValue, 2))
              }
              f.write(.mspInitialize, value: nil)
              f.write(.mspDeinitialize, value: nil)
            }
            p.verify(0)
            p.verify(38)
            p.verify(39)
            p.verify(40)
            p.verify(1)
          }
        }
      }
    }
  }
  func testRegistrationsDoNotAcquireOrReleaseHandleLock() {
    for state: UInt32 in [0, 0x20, 0x24, 0x21, 0x28, 0x60] {
      for locked: UInt32 in [0, 1] {
        for op: UInt32 in 2...5 {
          for id: UInt32 in 0...12 {
            for kind: UInt32 in 0...2 {
              let p = I2CPair()
              p.setup {
                $0.write(.state, value: state)
                $0.write(.lock, value: locked)
                $0.write(.errorCode, value: 0x8000)
              }
              p.verify(op, id, kind)
              XCTAssertEqual(p.swift.read(.lock), locked)
            }
          }
        }
      }
    }
  }
  func testFiltersWakeupAndFastModePreserveUnrelatedBitsAndBusyState() {
    for state: UInt32 in [0, 0x20, 0x24, 0x28] {
      for locked: UInt32 in [0, 1] {
        for op: UInt32 in 73...77 {
          for value: UInt32 in [0, 1, 15, 16, 0x1000, 0x1000000, 0xFFFF_FFFF] {
            let p = I2CPair()
            p.setup {
              $0.write(.state, value: state)
              $0.write(.lock, value: locked)
              $0.write(.cr1, value: 0xA5A5_A5A5)
            }
            p.verify(op, value)
          }
        }
      }
    }
  }
  func testHeaderMacrosIncludeDistinctTXEmptyClearAndCompositeFlags() {
    for callbacks in [false, true] {
      for op: UInt32 in 100...108 {
        for flags: UInt32 in [0, 1, 2, 3, 0xFFFF_FFFF] {
          let p = I2CPair(callbacks: callbacks)
          p.setup {
            $0.write(.cr1, value: 0xA5A5_A5A5)
            $0.write(.isr, value: 0x5A5A_5A5A)
          }
          p.verify(op, flags)
        }
      }
    }
  }
}
