import CSDReference
import STM32H7RSHAL
import XCTest

final class SDTransferTests: XCTestCase {
  func testPollingTransfersAndTimeoutBoundaries() {
    for operation: UInt32 in [3, 4] {
      for cardType: UInt32 in [0, 1, 3] {
        for count: UInt32 in [0, 1, 2] {
          for timeout: UInt32 in [0, 1, 3, 1000] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.write(.cardType, value: cardType)
                f.set(2, 2, UInt32.max - 5)
              }, operation: operation, 7, count, timeout)
          }
        }
      }
      let f = SDFixture()
      prepareSDCard(f)
      XCTAssertEqual(f.run(operation, 7, 2, 1000), 0)
      XCTAssertEqual(f.get(3, 7), 256)
      XCTAssertEqual(f.read(.state), 1)
    }
  }

  func testTransferEntryChecksAndCommandErrors() {
    for operation: UInt32 in [3, 4, 5, 6, 7, 8, 46, 47] {
      for state: UInt32 in [0, 1, 3, 15] {
        for address: UInt32 in [0, 8191, 8192, UInt32.max] {
          for count: UInt32 in [1, 2] {
            for failure: UInt32 in [0, 1, 4, 0x40] {
              checkSD(
                { f in
                  prepareSDCard(f)
                  f.write(.state, value: state)
                  f.write(.errorCode, value: 0x800)
                  for command: UInt32 in [17, 18, 24, 25] {
                    if failure != 0 { f.set(4, command * 6, failure) }
                  }
                }, operation: operation, address, count, 3)
            }
          }
        }
      }
      if operation < 9 {
        checkSD(
          { f in
            prepareSDCard(f)
            f.set(2, 9, 1)
            f.write(.errorCode, value: 0x800)
          }, operation: operation, 1, 2, 3)
      }
    }
  }

  func testDMAAndInterruptCountsUseWrappingArithmetic() {
    for operation: UInt32 in [5, 6, 7, 8, 46, 47] {
      for count: UInt32 in [0, 1, 2, 0x0080_0000, 0x8000_0000, UInt32.max] {
        for cardType: UInt32 in [0, 1, 3] {
          checkSD(
            { f in
              prepareSDCard(f)
              f.write(.logicalBlockCount, value: UInt32.max)
              f.write(.cardType, value: cardType)
              f.set(0, SDMMCRegister.dctrl.rawValue / 4, UInt32.max)
              f.set(0, SDMMCRegister.mask.rawValue / 4, 0x5555_AAAA)
            }, operation: operation, 0x0080_0001, count)
        }
      }
    }
  }

  func testDataErrorsAndStopCommandFailurePriority() {
    for operation: UInt32 in [3, 4] {
      for flags: UInt32 in [0x2, 0x8, 0x10, 0x20, 0x100, 0x3A, 0x13A] {
        for count: UInt32 in [1, 2] {
          for stopFlags: UInt32 in [1, 4, 0x40] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.set(3, 8, 0)
                for command: UInt32 in [17, 18, 24, 25] {
                  f.set(4, command * 6, 0x40 | flags)
                }
                f.set(4, 12 * 6, stopFlags)
              }, operation: operation, 7, count, 3)
          }
        }
      }
    }
  }

  func testLinkedListSetupPreservesPartialRegisterWrites() {
    for operation: UInt32 in [46, 47] {
      for field: UInt32 in [1, 2] {
        checkSD(
          { f in
            prepareSDCard(f)
            f.set(8, field, 0)
            f.write(.errorCode, value: 0x800)
            f.set(0, SDMMCRegister.idmabaser.rawValue / 4, 0x1111)
            f.set(0, SDMMCRegister.idmabsize.rawValue / 4, 0x2222)
            f.set(0, SDMMCRegister.idmabar.rawValue / 4, 0x3333)
            f.set(0, SDMMCRegister.idmalar.rawValue / 4, 0x4444)
          }, operation: operation, 7, 2)
      }
    }
  }

  func testEraseValidationAndCommandFailures() {
    for state: UInt32 in [0, 1, 3] {
      for cardType: UInt32 in [0, 1, 3] {
        for cardClass: UInt32 in [0, 0x20] {
          for (start, end): (UInt32, UInt32) in [
            (0, 0), (7, 6), (7, 8), (8191, 8192), (UInt32.max, UInt32.max),
          ] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.write(.state, value: state)
                f.write(.cardType, value: cardType)
                f.write(.cardClass, value: cardClass)
              }, operation: 9, start, end)
          }
        }
      }
    }
    for command: UInt32 in [32, 33, 38] {
      for flags: UInt32 in [1, 4] {
        checkSD(
          { f in
            prepareSDCard(f)
            f.set(4, command * 6, flags)
          }, operation: 9, 1, 2)
      }
    }
    checkSD(
      { f in
        prepareSDCard(f)
        f.set(0, SDMMCRegister.resp1.rawValue / 4, 0x0200_0000)
      }, operation: 9, 1, 2)
  }
}
