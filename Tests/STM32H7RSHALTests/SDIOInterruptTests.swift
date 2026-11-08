import CSDIOReference
import STM32H7RSHAL
import XCTest

final class SDIOInterruptTests: XCTestCase {
  func testInterruptCompletionErrorsAndCallbackMutation() {
    for variant: UInt32 in [0, 1] {
      for context: UInt32 in [0, 1, 2, 0x10, 0x20, 0x81, 0x82, 0x90, 0xA0, 0xB3] {
        for flags: UInt32 in [0, 0x100, 0x2, 0x8, 0x10, 0x20, 0x13A, 0x1000_0000] {
          for callback: UInt32 in [0, 1, 2] {
            checkSDIO(
              { f in
                prepareSDIO(f)
                f.write(.state, value: 2)
                f.write(.transferContext, value: context)
                f.set(0, SDMMCRegister.sta.rawValue / 4, flags)
                f.set(0, SDMMCRegister.mask.rawValue / 4, UInt32.max)
                f.set(0, SDMMCRegister.idmactrl.rawValue / 4, 3)
                f.set(2, 20, callback + 1)
                f.set(2, 21, 14)
                f.set(2, 22, 0x1234)
                if variant == 1 {
                  CSDIO_SetCallback(f.state, callback, CSDIO_Callback(callback, 2))
                }
              }, operation: 15, variant: variant)
          }
        }
      }
    }
  }

  func testDMAContinuationReusesSourceFunctionAndAddressRules() {
    for variant: UInt32 in [0, 1] {
      for context: UInt32 in [0x81, 0x82, 0x90, 0xA0] {
        for remaining: UInt32 in [1, 3, 31, 511, 512, 513, 1024] {
          for flags: UInt32 in [0x40, 1, 4] {
            checkSDIO(
              { f in
                prepareSDIO(f)
                f.write(.state, value: 2)
                f.write(.transferContext, value: context)
                f.write(.remainingData, value: remaining)
                f.write(
                  .nextDataAddress,
                  value: UInt32(truncatingIfNeeded: UInt(bitPattern: f.buffer(1) + 512)))
                f.write(.nextRegisterAddress, value: 0x12345)
                f.set(0, SDMMCRegister.sta.rawValue / 4, 0x100)
                f.set(4, 53 * 6, flags)
              }, operation: 15, variant: variant)
          }
        }
      }
    }
  }

  func testOriginalIOFunctionIndexRulesWithinArrayBounds() {
    for count: UInt8 in [0, 1, 2, 7, 255] {
      for mask: UInt8 in [1, 2, 3, 4, 5, 6, 7] {
        for pending: UInt32 in [0, 2, 4, 0xFE] {
          checkSDIO(
            { f in
              prepareSDIO(f)
              f.write(.ioInterruptCount, value: count)
              f.write(.ioFunctionMask, value: mask)
              for i: UInt32 in 0..<7 {
                CSDIO_SetCallback(f.state, 20 + i, CSDIO_Callback(20, 2))
              }
              f.set(15, 5, pending)
              f.set(0, SDMMCRegister.sta.rawValue / 4, 0x400000)
            }, operation: 15)
        }
      }
    }
  }
}
