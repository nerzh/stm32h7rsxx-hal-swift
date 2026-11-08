import CSDReference
import STM32H7RSHAL
import XCTest

final class SDInterruptTests: XCTestCase {
  func testInterruptPriorityAndBufferMovement() {
    for variant: UInt32 in [0, 1] {
      for context: UInt32 in [0, 0x9, 0xA, 0x18, 0x28, 0x81, 0x82, 0x90, 0xA0, 0xB3] {
        for flags: UInt32 in [
          0, 0x8000, 0x4000, 0x100, 0x2, 0x8, 0x10, 0x20, 0x1000_0000, 0x3A, 0xC13A, UInt32.max,
        ] {
          for size: UInt32 in [0, 31, 32, 64] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.write(.state, value: 3)
                f.write(.transferContext, value: context)
                f.write(.receiveSize, value: size)
                f.write(.transmitSize, value: size)
                f.write(.errorCode, value: 0x800)
                f.set(0, SDMMCRegister.sta.rawValue / 4, flags)
                f.set(0, SDMMCRegister.mask.rawValue / 4, 0x5555_AAAA)
                f.set(0, SDMMCRegister.dctrl.rawValue / 4, 0x1234)
                f.set(0, SDMMCRegister.idmactrl.rawValue / 4, 3)
              }, operation: 10, variant: variant)
          }
        }
      }
    }
  }

  func testCompletionErrorsAndCallbackReentrancy() {
    for variant: UInt32 in [0, 1] {
      for context: UInt32 in [0xA, 0x28, 0x82, 0xA0, 0xB3] {
        for callback: UInt32 in [0, 1, 2, 3, 4, 5] {
          for flags: UInt32 in [0x100, 0x3A, 0x1000_0000] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.write(.state, value: 3)
                f.write(.transferContext, value: context)
                f.set(0, SDMMCRegister.sta.rawValue / 4, flags)
                f.set(4, 12 * 6, 4)
                f.set(2, 20, callback + 1)
                f.set(2, 21, 9)
                f.set(2, 22, 0xDEAD_BEEF)
                if variant == 1 {
                  CSD_SetCallback(f.state, callback, CSD_Callback(callback, 2))
                }
              }, operation: 10, variant: variant)
          }
        }
      }
    }
  }

  func testAbortDirectionsErrorsAndTimeouts() {
    for variant: UInt32 in [0, 1] {
      for state: UInt32 in [0, 1, 3, 15] {
        for direction: UInt32 in [0, 2] {
          for response: UInt32 in [1, 4, 0x40, 0x140, 0x840, 0x20_0040] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.write(.state, value: state)
                f.write(.transferContext, value: 0xA0)
                f.write(.errorCode, value: 0x800)
                f.set(2, 3, UInt32.max)
                f.set(0, SDMMCRegister.dctrl.rawValue / 4, direction | 0x90)
                f.set(0, SDMMCRegister.mask.rawValue / 4, UInt32.max)
                f.set(0, SDMMCRegister.idmactrl.rawValue / 4, 3)
                f.set(4, 12 * 6, response)
              }, operation: 24, variant: variant)
          }
        }
      }
      for cardState: UInt32 in 0..<16 {
        for error: UInt32 in [0, 0x800] {
          for failure: UInt32 in [0x40, 1, 4] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.write(.state, value: 3)
                f.write(.errorCode, value: error)
                f.set(4, 13 * 6 + 2, cardState << 9)
                f.set(4, 12 * 6, failure)
              }, operation: 25, variant: variant)
          }
        }
      }
    }
  }
}
