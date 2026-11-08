import STM32H7RSHAL
import XCTest

final class SDIOFunctionTests: XCTestCase {
  func testEnableDisableSelectAbortAndInterruptMasks() {
    for operation: UInt32 in 23...30 {
      for function: UInt32 in 0..<8 {
        for bits: UInt32 in [0, 1, 2, 0x55, 0xFF] {
          for count: UInt8 in [0, 1, 2, 255] {
            checkSDIO(
              { f in
                prepareSDIO(f)
                f.write(.ioInterruptCount, value: count)
                for address: UInt32 in [2, 3, 4, 22] { f.set(15, address, bits) }
                f.set(0, SDMMCRegister.mask.rawValue / 4, 0x5555_AAAA)
                f.set(0, SDMMCRegister.dctrl.rawValue / 4, 0xA5A5_5A5A)
              }, operation: operation, function)
          }
        }
      }
    }
  }

  func testIOFunctionCallbacksAndCommandFailures() {
    for function: UInt32 in 0..<7 {
      for kind: UInt32 in [0, 1] {
        checkSDIO(
          { f in
            prepareSDIO(f)
            f.write(.ioFunctionMask, value: 0x81)
          }, operation: 31, function, kind)
      }
    }
    for operation: UInt32 in 23...30 {
      for flags: UInt32 in [1, 4] {
        checkSDIO(
          { f in
            prepareSDIO(f)
            f.set(4, 52 * 6, flags)
          }, operation: operation, 2)
      }
    }
  }
}
