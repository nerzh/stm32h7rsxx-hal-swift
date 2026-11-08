import CXSPIReference
import STM32H7RSHAL
import XCTest

final class XSPIConfigurationTests: XCTestCase {
  func testControlMacrosAndFlagMasks() {
    for callbacks in [false, true] {
      for bits: UInt32 in [0, 1, 2, 4, 6, 0x20, 0x1F0000, 0xFFFF_FFFF] {
        for mask: UInt32 in [0, 1, 2, 4, 6, 0x20, 0x1F0000] {
          let p = XSPIPair(callbacks: callbacks)
          p.setup { f in
            f.raw(.cr, bits)
            f.raw(.sr, bits)
            f.write(.state, value: 0x88)
          }
          for op: UInt32 in [43, 44, 39, 40, 41, 44, 42, 45, 46] { p.verify(op, mask) }
        }
      }
    }
  }
  func testInitializationAndDeinitialization() {
    for callbacks in [false, true] {
      for instance: UInt32 in [0, 1] {
        for state: UInt32 in [0, 1, 2, 4, 8, 0x18, 0x88, 0x200] {
          for type: UInt32 in [0, 0x0100_0000, 0x0400_0000, 0x0600_0000] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.control(0, instance)
              f.write(.state, value: state)
              f.write(.errorCode, value: 0xA5)
              f.setConfiguration(
                .init(
                  fifoThresholdByte: 7, memoryMode: 0x40, memoryType: type, memorySize: 24,
                  chipSelectHighTimeCycle: 4, freeRunningClock: 2, clockMode: 1, wrapSize: 0x20000,
                  clockPrescaler: 5, sampleShifting: 0x4000_0000,
                  delayHoldQuarterCycle: 0xFFFF_FFFF, chipSelectBoundary: 12, maxTran: 18,
                  refresh: 0x1234, memorySelect: 0x8000_0000))
              for r in XSPIRegister.allCases { f.raw(r, 0xA55A_55A5) }
              f.raw(.sr, 0)
            }
            p.verify(0)
            p.verify(27)
            p.verify(28)
            p.verify(1)
          }
        }
      }
    }
  }
  func testInitializationTimeoutAndPreemption() {
    for callbacks in [false, true] {
      for transition: UInt32 in [0, 1, 3] {
        let p = XSPIPair(callbacks: callbacks)
        p.setup { f in
          f.setConfiguration(.init(fifoThresholdByte: 1, chipSelectHighTimeCycle: 1))
          f.raw(.sr, 0x20)
          f.control(3, 5001)
          f.control(25, transition)
          f.control(26, 0)
        }
        p.verify(0)
      }
    }
  }
  func testCallbackRegistrationStateMatrix() {
    for state: UInt32 in [0, 1, 2, 4, 8, 0x100] {
      for id: UInt32 in 0...13 {
        for custom: UInt32 in [0, 1, 2] {
          let p = XSPIPair()
          p.setup { f in
            f.write(.state, value: state)
            f.write(.errorCode, value: 0x80)
          }
          p.verify(17, id, custom)
          p.verify(18, id)
        }
      }
    }
  }
  func testSettersAndGetters() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 1, 2, 4, 0x14, 0x24, 8, 0x18, 0x28, 0x48, 0x88, 0x100, 0x200] {
        for value: UInt32 in [0, 1, 16, 32, 255, 0xFFFF_FFFF] {
          let p = XSPIPair(callbacks: callbacks)
          p.setup { f in
            f.write(.state, value: state)
            f.raw(.cr, 0xA5A5_A5A5)
            f.raw(.dcr1, 0x5A5A_5A5A)
            f.raw(.dcr2, 0xA55A_55AA)
          }
          p.verify(21, value)
          p.verify(22)
          p.verify(23, value)
          p.verify(24, value)
          p.verify(25, value)
          p.verify(26, 0, value)
          p.verify(27)
          p.verify(28)
          p.verify(16)
        }
      }
    }
  }
  func testManagerPreservesOtherInstanceAndEnableState() {
    for callbacks in [false, true] {
      for instance: UInt32 in [0, 1] {
        for mode: UInt32 in 0..<32 {
          for override: UInt32 in [0, 0x10, 0x70] {
            for port: UInt32 in [0, 1] {
              let p = XSPIPair(callbacks: callbacks)
              p.setup { f in
                f.control(0, instance)
                f.setConfig(
                  XSPIManagerConfiguration(
                    nCSOverride: override, ioPort: port, req2AckTime: mode & 1 == 0 ? 1 : 256))
                CXSPI_Set(f.state, 11, 0, (mode & 3) | ((mode & 0x1C) << 2) | 0xAA00_0000)
                CXSPI_Set(f.state, 14, 0, 0xA500_0000 | (mode & 1))
                CXSPI_Set(f.state, 14, 139, 0x5A00_0000 | ((mode >> 1) & 1))
              }
              p.verify(29, 0, 17)
            }
          }
        }
      }
    }
  }
  func testCalibrationReadWriteAndRejectedStates() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 2, 4, 8, 0x18, 0x28, 0x48, 0x88, 0x100, 0x200] {
        for type: UInt32 in 0...5 {
          for fine: UInt32 in [0, 0x3F, 0x7F] {
            let p = XSPIPair(callbacks: callbacks)
            p.setup { f in
              f.write(.state, value: state)
              f.write(.errorCode, value: 0x80)
              f.setConfig(
                XSPICalibrationConfiguration(
                  delayValueType: type, fineCalibrationUnit: fine, coarseCalibrationUnit: 31,
                  maxCalibration: 0xDEAD_BEEF))
              f.raw(.calfcr, 0xAF127F)
              f.raw(.calmr, 0x1234_5678)
              f.raw(.calsor, 0x8765_4321)
              f.raw(.calsir, 0xAA55_AA55)
            }
            p.verify(31)
            p.verify(30)
          }
        }
      }
    }
  }
}
