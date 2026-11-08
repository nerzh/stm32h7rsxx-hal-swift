import CNORReference
import STM32H7RSHAL
import XCTest

final class NORStatusTests: XCTestCase {
  func testAMDReadPairsSuccessErrorAndTimeoutOrdering() {
    let scripts: [[UInt32]] = [
      [0, 0], [0, 0x40, 0, 0], [0, 0x40, 0x20, 0x60],
      [0, 0x40, 0, 0x40], [0x20, 0x60, 0, 0x40, 0, 0],
    ]
    for script in scripts {
      for timeout: UInt32 in [0, 1, 3, 0xFFFF_FFFF] {
        for tick: UInt32 in [0, 0xFFFF_FFFE] {
          checkNOR(
            { f in
              f.write(.commandSet, value: 2)
              f.set(7, 1, UInt32(script.count))
              for (i, value) in script.enumerated() { f.set(10, UInt32(i), value) }
              f.set(8, 0, tick)
            }, operation: 16, 0x6000_0040, timeout)
        }
      }
    }
    let f = NORFixture()
    f.write(.commandSet, value: 2)
    XCTAssertEqual(f.run(16, 0x6000_0040, 0), 0)
    XCTAssertEqual(f.get(7, 2), 2)
  }

  func testIntelPollsThenChecksTimeoutEvenWhenReady() {
    for replies: [UInt32] in [[0x80, 0], [0, 0x80, 0x20], [0, 0, 0x80, 0x10], [0x80, 0x30]] {
      for timeout: UInt32 in [0, 1, 3, 0xFFFF_FFFF] {
        for tick: UInt32 in [0, 0xFFFF_FFFE] {
          checkNOR(
            { f in
              f.write(.commandSet, value: 1)
              f.set(7, 1, UInt32(replies.count))
              for (i, value) in replies.enumerated() { f.set(10, UInt32(i), value) }
              f.set(8, 0, tick)
            }, operation: 16, 0x6000_0040, timeout)
        }
      }
    }
    let f = NORFixture()
    f.write(.commandSet, value: 1)
    XCTAssertEqual(f.run(16, 0x6000_0040, 0), 3)
    XCTAssertEqual(f.get(7, 2), 1)
  }

  func testIntelErrorRetainsOriginalReadStatusCommand() {
    let f = checkNOR(
      { f in
        f.write(.commandSet, value: 1)
        f.set(7, 1, 2)
        f.set(10, 0, 0x80)
        f.set(10, 1, 0x20)
      }, operation: 16, 0x6000_0040, 9)
    let count = f.get(7, 0)
    XCTAssertEqual(f.get(13, (count - 2) * 4 + 2), 0x70)
    XCTAssertEqual(f.get(13, (count - 1) * 4), 0x200)
  }

  func testWaitHookRunsBeforeTickAndCanChangeCommandSet() {
    for variant: UInt32 in [0, 1] {
      for command: UInt32 in [1, 2, 3] {
        let f = checkNOR(
          { f in
            f.write(.state, value: 4)
            f.write(.lock, value: 1)
            f.set(7, 10, 1)
            f.set(7, 11, 2)
            f.set(7, 12, 3)
            f.set(7, 13, 0)
            f.set(7, 14, command)
            f.set(7, 15, 1)
          }, variant: variant, operation: 16, 0x6000_0040, 7)
        XCTAssertEqual(f.get(13, 0), 0x302)
        XCTAssertEqual(f.get(13, 2), 7)
        XCTAssertEqual(f.get(13, 3), 0x40001)
        XCTAssertEqual(f.read(NORHandleWord.state), 3)
      }
    }
  }
}
