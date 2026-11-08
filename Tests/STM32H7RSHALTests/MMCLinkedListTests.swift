import STM32H7RSHAL
import XCTest

final class MMCLinkedListTests: XCTestCase {
  func testWrapperReturnValuesPreserveLowLevelErrors() {
    for operation: UInt32 in [45, 48, 49, 50, 51] {
      for absent: UInt32 in [0, 1] {
        for missingConfiguration: UInt32 in [0, 1] {
          checkMMC(
            { f in
              prepareMMCCard(f)
              f.set(2, 11, missingConfiguration)
              f.set(16, 0, 0x2401_0000)
              f.set(16, 1, 512)
            }, operation: operation, absent != 0 ? 0 : operation >= 50 ? 0x2403_0000 : 0x2403_0100)
        }
      }
    }
    for count: UInt32 in [0, 1, 2] {
      for previous: UInt32 in [0, 1] {
        for node: UInt32 in [0, 1, 2] {
          checkMMC(
            { f in
              prepareMMCCard(f)
              f.set(7, 2, count)
              f.set(7, 1, 0x2403_0100 + (count == 2 ? 12 : 0))
            }, operation: 46, 0x2403_0000, 0x2403_0100 + previous * 12, 0x2403_0100 + node * 12)
        }
      }
      checkMMC(
        { f in
          prepareMMCCard(f)
          f.set(7, 2, count)
        }, operation: 47, 0x2403_0000, 0x2403_0100)
    }
    let f = MMCFixture()
    prepareMMCCard(f)
    XCTAssertEqual(f.run(45, 0), 1)
    XCTAssertEqual(f.run(50, 0), 1)
    XCTAssertEqual(f.run(51, 0), 1)
    XCTAssertEqual(f.run(48, 0), 1)
    XCTAssertEqual(f.run(49, 0), 1)
  }
}
