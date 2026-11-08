import CNANDReference
import STM32H7RSHAL
import XCTest

final class NANDTransferTests: XCTestCase {
  func testPageAndSpareCommandsAcrossAddressCycleBoundaries() {
    for operation: UInt32 in 6...13 {
      for pageSize: UInt32 in [0, 7, 512, 513, 2048] {
        for blocks: UInt32 in [32, 65535, 65536, 0x1000001] {
          for width: UInt32 in [0, 0x10] {
            for extra: UInt32 in [0, 1] {
              checkNAND(
                { f in
                  f.write(.pageSize, value: pageSize)
                  f.write(.spareAreaSize, value: 5)
                  f.write(.blockSize, value: 1)
                  f.write(.blockCount, value: blocks)
                  f.write(.memoryDataWidth, value: width)
                  f.write(.extraCommandEnable, value: extra)
                  f.set(5, 0, 3)
                }, operation: operation, 2)
            }
          }
        }
      }
    }
  }

  func testTransfersStopAtDeviceEndAndPreserveCallerAddress() {
    for operation: UInt32 in 6...13 {
      for page: UInt32 in [0, 2, 3, 4, 5] {
        let f = checkNAND(
          { f in
            f.write(.blockSize, value: 1)
            f.write(.blockCount, value: 4)
            f.set(5, 0, page)
          }, operation: operation, 7)
        XCTAssertEqual(f.get(5, 0), page)
      }
    }
  }

  func testStatusPollingTimeoutAndTickWrap() {
    for operation: UInt32 in 6...13 {
      for tick: UInt32 in [0, 0xFFFF_FFFE] {
        for status: UInt32 in [0, 1, 0x41] {
          let f = checkNAND(
            { f in
              f.write(.extraCommandEnable, value: 1)
              f.set(9, 4, status)
              f.set(10, 0, tick)
              f.set(10, 1, 0x0100_0000)
            }, operation: operation, 2)
          XCTAssertEqual(f.read(NANDHandleWord.state), 3)
          XCTAssertEqual(f.read(NANDHandleWord.lock), 0)
          XCTAssertEqual(f.get(10, 2), 3)
        }
      }
    }
  }

  func testStatusPollingRecoversFromBusyAndErrorReplies() {
    for operation: UInt32 in 6...13 {
      checkNAND(
        { f in
          f.write(.extraCommandEnable, value: 1)
          f.set(9, 3, 4)
          f.set(12, 0, 0)
          f.set(12, 1, 1)
          f.set(12, 2, 0x41)
          f.set(12, 3, 0x40)
        }, operation: operation, 3)
    }
  }

  func testSixteenBitPagesRetainRepeatedPageSizeHalving() {
    for operation: UInt32 in [7, 9] {
      let f = checkNAND(
        { f in
          f.write(.pageSize, value: 16)
          f.write(.memoryDataWidth, value: 0)
        }, operation: operation, 3)
      XCTAssertEqual(f.read(NANDDeviceConfigurationWord.pageSize), 2)
      var count: UInt32 = 0
      for i in 0..<f.get(9, 0) {
        let kind = f.get(15, i * 4)
        if kind == (operation == 7 ? 16 : 0x110) { count += 1 }
      }
      XCTAssertEqual(count, 8 + 4 + 2)
    }
  }

  func testEraseAlwaysUsesThreeRowCyclesAndBarriers() {
    for page: UInt32 in [0, 255, 256, 65535] {
      for block: UInt32 in [0, 65535] {
        let f = checkNAND(
          { f in
            f.set(5, 0, page)
            f.set(5, 1, 65535)
            f.set(5, 2, block)
            f.write(.planeSize, value: 0xFFFF_FFFE)
            f.write(.blockSize, value: 0xFFFF_FFFD)
          }, operation: 14)
        XCTAssertEqual(f.get(9, 0), 10)
        XCTAssertEqual(f.get(15, 2), 0x60)
        XCTAssertEqual(f.get(15, 34), 0xD0)
        for i: UInt32 in [1, 3, 5, 7, 9] { XCTAssertEqual(f.get(15, i * 4), 0x200) }
      }
    }
  }
}
