import STM32H7RSHAL
import XCTest

final class MMCSpeedTests: XCTestCase {
  func testWideBusPowerClassesAndVoltageBranches() {
    for variant: UInt32 in 0..<8 {
      for mode: UInt32 in [0, 0x4000, 0x8000, UInt32.max] {
        for speed: UInt32 in [0, 0x80000, 0xC0000] {
          for fifo: UInt32 in [0, 0x1234_5678, UInt32.max] {
            checkMMC(
              { f in
                prepareMMCCard(f)
                f.set(0, SDMMCRegister.clkcr.rawValue / 4, speed)
                f.set(0, SDMMCRegister.fifo.rawValue / 4, fifo)
              }, operation: 19, mode, variant: variant)
          }
        }
      }
    }
  }

  func testSpeedModesDeviceCapabilitiesAndDividers() {
    for variant: UInt32 in [0, 1, 2, 3] {
      for capability: UInt32 in [0, 1, 2, 4, 7, 0xFF] {
        for mode: UInt32 in [0, 1, 2, 4, 8, UInt32.max] {
          for clock: UInt32 in [0, 26_000_000, 52_000_000, 64_000_000] {
            checkMMC(
              { f in
                prepareMMCCard(f)
                f.extendedCSDPointer()[49] = capability
                f.set(0, SDMMCRegister.clkcr.rawValue / 4, 0x4002)
                f.set(2, 5, clock)
              }, operation: 20, mode, variant: variant)
          }
        }
      }
    }
    for register: UInt32 in [0, 1, 0xC000, 0x8C000, 0xCC002] {
      for divider: UInt32 in [0, 1, 1023, UInt32.max] {
        checkMMC(
          { f in
            prepareMMCCard(f)
            f.extendedCSDPointer()[49] = 7
            f.set(0, SDMMCRegister.clkcr.rawValue / 4, register)
            f.write(.clockDivider, value: divider)
          }, operation: 20, 1)
      }
    }
  }

  func testSpeedCommandErrorsReadinessAndCounterTimeouts() {
    for operation: UInt32 in [19, 20] {
      for command: UInt32 in [6, 8, 13] {
        for flags: UInt32 in [1, 4, 0x42, 0x48, 0x60] {
          checkMMC(
            { f in
              prepareMMCCard(f)
              f.extendedCSDPointer()[49] = 7
              f.set(0, SDMMCRegister.clkcr.rawValue / 4, 0x4002)
              f.set(2, 3, UInt32.max)
              f.set(4, command * 6, flags)
            }, operation: operation, operation == 19 ? 0x4000 : 4)
        }
      }
      for response: UInt32 in [0x900, 0x980, 0] {
        checkMMC(
          { f in
            prepareMMCCard(f)
            f.extendedCSDPointer()[49] = 7
            f.set(3, 12, 1)
            f.set(2, 3, UInt32.max)
            f.set(0, SDMMCRegister.clkcr.rawValue / 4, 0x4002)
            f.set(4, 13 * 6 + 2, response)
          }, operation: operation, operation == 19 ? 0x4000 : 4)
      }
    }
  }
}
