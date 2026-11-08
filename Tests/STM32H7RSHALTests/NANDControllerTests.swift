import CNANDReference
import STM32H7RSHAL
import XCTest

final class NANDControllerTests: XCTestCase {
  func testResetHandleMacroPreservesLockAndInterruptCallback() {
    for variant: UInt32 in [0, 1] {
      let f = checkNAND(
        { f in
          f.write(.state, value: 3)
          f.write(.lock, value: 1)
        }, variant: variant, operation: 23)
      XCTAssertEqual(f.read(NANDHandleWord.state), 0)
      XCTAssertEqual(f.read(NANDHandleWord.lock), 1)
      XCTAssertEqual(f.get(13, 2), 0x202)
      XCTAssertEqual(f.get(13, 0), variant == 0 ? 2 : 0)
      XCTAssertEqual(f.get(13, 1), variant == 0 ? 0x102 : 0)
    }
  }

  func testCallbackDefaultsInvokeTheCorrectHandlersAfterRegistration() {
    for variant: UInt32 in [0, 1] {
      let reference = NANDFixture(variant: variant)
      let swift = NANDFixture(variant: variant)
      for f in [reference, swift] {
        f.write(.state, value: 0)
        for i: UInt32 in 0..<3 { f.set(13, i, 0) }
      }
      for operation: UInt32 in [0, 2, 1] {
        reference.write(.sr, value: 0x47)
        swift.write(.sr, value: 0x47)
        XCTAssertEqual(
          swift.run(operation), CNAND_Run(reference.state, variant, operation, 0, 0, 0))
        XCTAssertEqual(CNAND_Compare(reference.state, swift.state), 0)
      }
    }
  }

  func testInitializationTimingCallbacksAndDeinitialization() {
    for variant: UInt32 in [0, 1] {
      for state: UInt32 in [0, 1, 2, 3, 0xFFFF] {
        for callback: UInt32 in [0, 2] {
          for operation: UInt32 in [0, 1] {
            checkNAND(
              { f in
                f.write(.state, value: state)
                f.write(.lock, value: 1)
                for index: UInt32 in 0..<3 { f.set(13, index, callback) }
                for index: UInt32 in 0..<88 { f.set(0, index, 0xA5A5_0000 | index) }
                f.write(.memoryDataWidth, value: 0x10)
                f.write(.eccComputation, value: 0x40)
                f.write(.eccPageSize, value: 0x60000)
                f.write(.waitFeature, value: 2)
                f.write(.tclrSetupTime, value: 7)
                f.write(.tarSetupTime, value: 11)
              }, variant: variant, operation: operation)
          }
        }
      }
    }
  }

  func testConfigurationCopiesFieldsWithoutChangingStateOrLock() {
    for state: UInt32 in [0, 1, 2, 3] {
      checkNAND(
        { f in
          f.write(.state, value: state)
          f.write(.lock, value: 1)
          for i: UInt32 in 0..<7 { f.set(4, i, 0xF000_0001 &+ i) }
        }, operation: 5)
    }
  }

  func testEntryStatesLocksAndZeroCounts() {
    for operation: UInt32 in [3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 18, 19, 20, 21] {
      for state: UInt32 in [0, 1, 2, 3, 4, 0xFFFF_FFFF] {
        for lock: UInt32 in [0, 1] {
          checkNAND(
            { f in
              f.write(.state, value: state)
              f.write(.lock, value: lock)
              f.write(.sr, value: 0x40)
            }, operation: operation)
        }
      }
    }
  }

  func testReadIDUsesWordReadsAndSixteenByteSecondOffset() {
    for width: UInt32 in [0, 0x10] {
      let f = checkNAND({ $0.write(.memoryDataWidth, value: width) }, operation: 3)
      let expected: [UInt32] = width == 0 ? [0x17, 0x9E, 0xC3, 0x25] : [0x17, 0xC3, 0x48, 0xE3]
      for i in 0..<4 { XCTAssertEqual(f.get(6, UInt32(i)), expected[i]) }
      XCTAssertEqual(f.get(15, 16), 32)
      XCTAssertEqual(f.get(15, 17), 0x8000_0000)
      if width != 0 {
        XCTAssertEqual(f.get(15, 20), 32)
        XCTAssertEqual(f.get(15, 21), 0x8000_0010)
      }
    }
  }

  func testStatusErrorPriorityAndResetCommand() {
    for status: UInt32 in [0, 1, 0x40, 0x41, 0x80, 0xC0, 0xFF] {
      let f = checkNAND({ $0.set(9, 4, status) }, operation: 22)
      XCTAssertEqual(f.get(9, 0), 2)
      XCTAssertEqual(f.get(15, 0), 0x108)
      XCTAssertEqual(f.get(15, 2), 0x70)
      XCTAssertEqual(f.get(15, 4), 8)
    }
    let f = checkNAND(operation: 4)
    XCTAssertEqual(f.get(9, 0), 1)
    XCTAssertEqual(f.get(15, 2), 0xFF)
  }

  func testCallbackRegistrationAcrossStatesAndUnknownIDs() {
    for variant: UInt32 in [0, 1] {
      for operation: UInt32 in [16, 17] {
        for state: UInt32 in [0, 1, 2, 3] {
          for id: UInt32 in [0, 1, 2, 3, 0xFFFF_FFFF] {
            for token: UInt32 in [0, 2] {
              checkNAND(
                { $0.write(.state, value: state) },
                variant: variant, operation: operation, id, token)
            }
          }
        }
      }
    }
  }

  func testInterruptCallbacksObserveUnclearedFlagsAndLiveMutations() {
    for variant: UInt32 in [0, 1] {
      for flags: UInt32 in [0, 1, 2, 4, 0x40, 0x47, 0xFFFF_FFFF] {
        for mutation: UInt32 in [0, 1] {
          checkNAND(
            { f in
              f.write(.sr, value: flags)
              f.set(9, 10, mutation)
              f.set(9, 11, 2)
              f.set(9, 12, 3)
              f.set(9, 13, 1)
              f.set(9, 14, 0x44)
              f.set(9, 15, 17)
            }, variant: variant, operation: 2)
        }
      }
    }
  }

  func testAddressIncrementCarriesAndSixteenBitWrap() {
    for blockSize: UInt32 in [0, 1, 4, 65535, 65536] {
      for page: UInt32 in [0, 3, 65534, 65535] {
        for block: UInt32 in [0, 3, 65535] {
          for plane: UInt32 in [0, 1, 65535] {
            checkNAND(
              { f in
                f.write(.blockSize, value: blockSize)
                f.set(5, 0, page)
                f.set(5, 1, plane)
                f.set(5, 2, block)
              }, operation: 15)
          }
        }
      }
    }
  }

  func testECCSuccessStrictTimeoutWrapAndReadyTransition() {
    for timeout: UInt32 in [0, 1, 3] {
      for tick: UInt32 in [0, 0xFFFF_FFFE] {
        for event: UInt32 in [0, 1, 2, 3] {
          checkNAND(
            { f in
              f.set(10, 0, tick)
              f.set(10, 3, event)
              f.set(10, 4, 0x40)
              f.write(.eccr, value: 0x7856_3412)
            }, operation: 20, timeout)
        }
      }
    }
  }
}
