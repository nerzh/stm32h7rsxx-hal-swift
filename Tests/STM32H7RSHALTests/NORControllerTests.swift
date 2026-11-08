import CNORReference
import STM32H7RSHAL
import XCTest

final class NORControllerTests: XCTestCase {
  func testInitializationCommandDetectionProtectionAndCallbacks() {
    for variant: UInt32 in [0, 1] {
      for state: UInt32 in [0, 1, 2, 4] {
        for bank: UInt32 in [0, 2, 4, 6] {
          for width: UInt32 in [0, 0x10, 0x20] {
            for command: UInt32 in [1, 2, 3] {
              for write: UInt32 in [0, 0x1000] {
                checkNOR(
                  { f in
                    f.write(.state, value: state)
                    f.write(.lock, value: 0)
                    f.write(.bank, value: bank)
                    f.write(.memoryDataWidth, value: width)
                    f.write(.writeOperation, value: write)
                    f.set(7, 9, 1)
                    f.set(7, 1, 1)
                    f.set(10, 0, command)
                    for i: UInt32 in 0..<2 { f.set(11, i, 0) }
                  }, variant: variant, operation: 0)
              }
            }
          }
        }
      }
    }
  }

  func testStateAndLockGuardsAcrossOperations() {
    for operation: UInt32 in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15] {
      for state: UInt32 in [0, 1, 2, 3, 4, 0xFFFF_FFFF] {
        for lock: UInt32 in [0, 1] {
          for command: UInt32 in [1, 2, 0xFFFF] {
            checkNOR(
              { f in
                f.write(.state, value: state)
                f.write(.lock, value: lock)
                f.write(.commandSet, value: command)
              }, operation: operation, operation == 7 ? 0x200 : 0x6000_0200, 0)
          }
        }
      }
    }
  }

  func testCommandsAndReadWidthsAcrossBanksAndSharedBusWidths() {
    for operation: UInt32 in [2, 3, 4, 5, 6, 7, 8, 9, 10] {
      for bank: UInt32 in [0, 2, 4, 6] {
        for width: UInt32 in [0, 1, 7] {
          for command: UInt32 in [1, 2, 3] {
            checkNOR(
              { f in
                f.write(.bank, value: bank)
                f.write(.commandSet, value: command)
                f.writeMemoryDataWidth(width)
                f.set(7, 3, 0xA1B2_C3D4)
              }, operation: operation, operation == 7 ? 0x246 : 0x6000_0246, 5)
          }
        }
      }
    }
  }

  func testSingleReadLoadsThirtyTwoBitsAndTruncatesToSixteen() {
    let f = checkNOR(
      { f in
        f.write(.commandSet, value: 1)
        f.set(7, 3, 0xA1B2_C3D4)
      }, operation: 4, 0x6000_0040)
    XCTAssertEqual(f.get(9, 0), 0xC3D4)
    XCTAssertEqual(f.get(7, 0), 3)
    XCTAssertEqual(f.get(13, 8), 32)
    XCTAssertEqual(f.get(13, 9), 0x6000_0040)
    XCTAssertEqual(f.get(13, 10), 0xA1B2_C3D4)
  }

  func testBufferedProgrammingUsesBankRelativeAddressesAndHalfwordSteps() {
    for size: UInt32 in [0, 1, 2, 17, 128] {
      for command: UInt32 in [1, 2] {
        let f = checkNOR(
          { f in
            f.write(.bank, value: 4)
            f.write(.commandSet, value: command)
            f.writeMemoryDataWidth(1)
          }, operation: 7, 0x600, size)
        var dataWrites: UInt32 = 0
        let headerEvents: UInt32 = command == 1 ? 4 : 8
        for index in 0..<size {
          let event = headerEvents + 2 * index
          XCTAssertEqual(f.get(13, event * 4), 0x110)
          XCTAssertEqual(f.get(13, event * 4 + 1), 0x6800_0600 + 2 * index)
          XCTAssertEqual(f.get(13, event * 4 + 2), f.get(9, index))
          dataWrites += 1
        }
        XCTAssertEqual(dataWrites, size)
        let countEvent: UInt32 = command == 1 ? 2 : 6
        XCTAssertEqual(f.get(13, countEvent * 4 + 2), UInt32(UInt16(truncatingIfNeeded: size &- 1)))
      }
    }
  }

  func testSharedWidthIsVisibleAcrossDifferentHandles() {
    let c1 = NORFixture()
    let c2 = NORFixture()
    let s1 = NORFixture()
    let s2 = NORFixture()
    c2.shareWidth(with: c1)
    s2.shareWidth(with: s1)
    for f in [c1, s1] {
      f.write(.memoryDataWidth, value: 0x10)
      f.write(.writeOperation, value: 0)
    }
    XCTAssertEqual(s1.run(0), CNOR_Run(c1.state, 1, 0, 0, 0, 0))
    XCTAssertEqual(s2.readMemoryDataWidth(), 1)
    for f in [c2, s2] {
      f.write(.bank, value: 2)
      f.write(.memoryDataWidth, value: 0)
    }
    XCTAssertEqual(s2.run(2), CNOR_Run(c2.state, 1, 2, 0, 0, 0))
    XCTAssertEqual(CNOR_Compare(c2.state, s2.state), 0)
    XCTAssertEqual(s2.get(13, 1), 0x6400_0AAA)
    s2.write(.writeOperation, value: 0)
    c2.write(.writeOperation, value: 0)
    XCTAssertEqual(s2.run(0), CNOR_Run(c2.state, 1, 0, 0, 0, 0))
    XCTAssertEqual(s1.readMemoryDataWidth(), 0)
    XCTAssertEqual(CNOR_Compare(c1.state, s1.state), 0)
    XCTAssertEqual(CNOR_Compare(c2.state, s2.state), 0)
  }

  func testCallbackRegistrationResetAndInvocation() {
    for variant: UInt32 in [0, 1] {
      for operation: UInt32 in [11, 12, 17] {
        for state: UInt32 in [0, 1, 2, 3, 4] {
          for id: UInt32 in [0, 1, 2, 0xFFFF_FFFF] {
            for token: UInt32 in [0, 2] {
              checkNOR(
                { f in
                  f.write(.state, value: state)
                  f.write(.lock, value: 1)
                }, variant: variant, operation: operation, id, token)
            }
          }
        }
      }
      let c = NORFixture(variant: variant)
      let s = NORFixture(variant: variant)
      for f in [c, s] {
        f.write(.state, value: 0)
        f.write(.writeOperation, value: 0)
        f.set(11, 0, 0)
        f.set(11, 1, 0)
      }
      for op: UInt32 in [0, 1] {
        XCTAssertEqual(s.run(op), CNOR_Run(c.state, variant, op, 0, 0, 0))
        XCTAssertEqual(CNOR_Compare(c.state, s.state), 0)
      }
    }
  }

  func testIdentifierAndCFIReadsPreserveWidthsAndOffsets() {
    for operation: UInt32 in [2, 10] {
      for width: UInt32 in [0, 1] {
        let f = checkNOR(
          { f in
            f.writeMemoryDataWidth(width)
            f.set(7, 1, 4)
            for i: UInt32 in 0..<4 { f.set(10, i, 0xABCD_0000 | (0x100 + i)) }
          }, operation: operation)
        let group: UInt32 = operation == 2 ? 3 : 4
        for i: UInt32 in 0..<4 { XCTAssertEqual(f.get(group, i), 0x100 + i) }
      }
    }
  }
}
