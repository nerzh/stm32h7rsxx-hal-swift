import STM32H7RSHAL
import XCTest

final class SDLinkedListTests: XCTestCase {
  func testWrapperReturnValuesIncludeOriginalIgnoredErrors() {
    for operation: UInt32 in [39, 42, 43, 44, 45] {
      for absent: UInt32 in [0, 1] {
        for missingConfiguration: UInt32 in [0, 1] {
          checkSD(
            { f in
              prepareSDCard(f)
              f.set(2, 11, missingConfiguration)
              f.set(16, 0, 0x2401_0000)
              f.set(16, 1, 512)
            }, operation: operation, absent != 0 ? 0 : operation >= 44 ? 0x2403_0000 : 0x2403_0100)
        }
      }
    }
    for count: UInt32 in [0, 1, 2] {
      for previous: UInt32 in [0, 1] {
        for node: UInt32 in [0, 1, 2] {
          checkSD(
            { f in
              prepareSDCard(f)
              f.set(7, 2, count)
              f.set(7, 1, 0x2403_0100 + (count == 2 ? 12 : 0))
            }, operation: 40, 0x2403_0000, 0x2403_0100 + previous * 12, 0x2403_0100 + node * 12)
        }
      }
      checkSD(
        { f in
          prepareSDCard(f)
          f.set(7, 2, count)
        }, operation: 41, 0x2403_0000, 0x2403_0100)
    }
    let f = SDFixture()
    prepareSDCard(f)
    XCTAssertEqual(f.run(39, 0), 0)
    XCTAssertEqual(f.run(44, 0), 0)
    XCTAssertEqual(f.run(45, 0), 0)
    XCTAssertEqual(f.run(42, 0), 1)
    XCTAssertEqual(f.run(43, 0), 1)
  }
}
