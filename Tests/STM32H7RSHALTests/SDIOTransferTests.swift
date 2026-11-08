import STM32H7RSHAL
import XCTest

final class SDIOTransferTests: XCTestCase {
  func testDirectCommandsFunctionAddressAndRawFields() {
    for operation: UInt32 in [9, 10] {
      for address: UInt32 in [0, 7, 0x123, 0x1FFFF, UInt32.max] {
        for function: UInt32 in 0..<8 {
          for raw: UInt32 in [0, 1, 255] {
            checkSDIO(
              { f in
                prepareSDIO(f)
                f.set(12, 0, address)
                f.set(12, 1, raw)
                f.set(12, 2, function)
                f.set(4, 52 * 6 + 2, 0xA5)
              }, operation: operation, 0x123)
          }
        }
      }
    }
  }

  func testExtendedPollingByteAndBlockTails() {
    for operation: UInt32 in [11, 12] {
      for mode: UInt32 in [0, 1] {
        for blockSize: UInt16 in [1, 4, 32, 512] {
          for count: UInt32 in [0, 1, 2, 3, 4, 7, 31, 32, 33, 511, 512, 513] {
            // A zero block transfer does not complete in the FIFO model; timeout covers that source path.
            checkSDIO(
              { f in
                prepareSDIO(f)
                f.write(.blockSize, value: blockSize)
                f.set(13, 0, 0x12345)
                f.set(13, 1, 1)
                f.set(13, 2, mode)
                f.set(13, 3, 3)
                f.set(2, 2, UInt32.max - 5)
              }, operation: operation, count, 1000)
          }
        }
      }
    }
  }

  func testTransferChecksErrorsAndTimeoutBoundaries() {
    for operation: UInt32 in [9, 10, 11, 12, 13, 14] {
      for state: UInt32 in [0, 1, 2] {
        for flags: UInt32 in [1, 4, 0x42, 0x48, 0x50, 0x60, 0x140] {
          checkSDIO(
            { f in
              prepareSDIO(f)
              f.write(.state, value: state)
              f.write(.errorCode, value: 0x800)
              f.set(4, 52 * 6, flags)
              f.set(4, 53 * 6, flags)
            }, operation: operation, 33, 3)
        }
      }
      for absent: UInt32 in [9, 10] {
        if operation == 10 && absent == 9 { continue }
        checkSDIO(
          { f in
            prepareSDIO(f)
            f.set(2, absent, 1)
          }, operation: operation, 33, 3)
      }
    }
    for operation: UInt32 in [11, 12] {
      for timeout: UInt32 in [0, 1, 2, 4] {
        checkSDIO(prepareSDIO, operation: operation, 33, timeout)
      }
    }
  }

  func testDMAContinuationCountsAndPartialRegisterWrites() {
    for operation: UInt32 in [13, 14] {
      for mode: UInt32 in [0, 1] {
        for size: UInt32 in [0, 1, 31, 32, 511, 512, 513, 1023, 1024, 1025, UInt32.max] {
          for blockSize: UInt16 in [1, 4, 512, 2048] {
            checkSDIO(
              { f in
                prepareSDIO(f)
                f.write(.blockSize, value: blockSize)
                f.set(13, 0, 0x1FFF0)
                f.set(13, 1, 1)
                f.set(13, 2, mode)
                f.set(13, 3, 7)
                f.set(0, SDMMCRegister.dctrl.rawValue / 4, 0xFFFF_FFFF)
              }, operation: operation, size)
          }
        }
      }
    }
  }
}
