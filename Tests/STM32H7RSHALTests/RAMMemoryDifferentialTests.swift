import XCTest

final class RAMMemoryDifferentialTests: XCTestCase {
  func testWidthsCountsStatesAndLocks() {
    for sdram in [false, true] {
      for transfer: UInt32 in 0..<6 {
        for count: UInt32 in [0, 1, 2, 3, 7, 16, 127] {
          for state: UInt32 in [0, 1, 2, 3, 4, 5] {
            for lock: UInt32 in [0, 1] {
              checkRAM(
                sdram,
                { f in
                  f.set(2, 1, state)
                  f.set(2, 0, lock)
                }, operation: (sdram ? 3 : 2) + transfer, 0x6000_0040, count)
            }
          }
        }
      }
    }
  }

  func testHalfwordReadsPreserveTwoIndependentWordLoads() {
    for sdram in [false, true] {
      let f = checkRAM(
        sdram,
        { f in
          f.set(6, 2, 3)
          f.set(9, 0, 0x1111_2222)
          f.set(9, 1, 0x3333_4444)
          f.set(9, 2, 0x5555_6666)
        }, operation: sdram ? 5 : 4, 0x6000_0040, 3)
      XCTAssertEqual(f.get(7, 0), 0x3333_2222)
      XCTAssertEqual(f.get(7, 1) & 0xFFFF, 0x6666)
      XCTAssertEqual(f.get(6, 0), 3)
      for i: UInt32 in 0..<3 {
        XCTAssertEqual(f.get(15, i * 4), 32)
        XCTAssertEqual(f.get(15, i * 4 + 1), i == 2 ? 0x6000_0044 : 0x6000_0040)
      }
    }
  }

  func testHalfwordWritesPreserveSeparateStoreReadModifyStoreAndOddTail() {
    for sdram in [false, true] {
      let f = checkRAM(
        sdram,
        { f in
          f.set(7, 0, 0x5678_1234)
          f.set(7, 1, 0xDEAD_9ABC)
          f.set(8, 17, 0xCDEF_0000)
        }, operation: sdram ? 6 : 5, 0x6000_0040, 3)
      XCTAssertEqual(f.get(6, 0), 5)
      for (i, kind) in [UInt32(0x120), 32, 0x120, 32, 0x120].enumerated() {
        XCTAssertEqual(f.get(15, UInt32(i) * 4), kind)
      }
      XCTAssertEqual(f.get(15, 2), 0x1234)
      XCTAssertEqual(f.get(8, 16), 0x5678_1234)
      XCTAssertEqual(f.get(8, 17), 0xCDEF_9ABC)
    }
  }

  func testReadsUseChangingVolatileValues() {
    for sdram in [false, true] {
      for transfer: UInt32 in [0, 2, 4] {
        checkRAM(
          sdram, { $0.set(6, 3, 1) },
          operation: (sdram ? 3 : 2) + transfer, 0x6000_0000, 7)
      }
    }
  }

  func testZeroSizeAllowsAbsentCallerBuffer() {
    for sdram in [false, true] {
      for transfer: UInt32 in 0..<6 {
        checkRAM(
          sdram, { $0.set(6, 5, 1) },
          operation: (sdram ? 3 : 2) + transfer, 0x6000_0000, 0)
      }
    }
  }
}
