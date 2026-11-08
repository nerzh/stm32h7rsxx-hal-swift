import CSDMMCReference
import STM32H7RSHAL
import XCTest

func prepareSDMMCList(_ f: SDMMCFixture, count: UInt32) {
  f.set(6, 0, count == 0 ? 0 : 0x2403_0100)
  f.set(6, 1, count == 0 ? 0 : 0x2403_0100 + (count - 1) * 12)
  f.set(6, 2, count)
  for i: UInt32 in 0..<8 {
    f.set(7, i * 3, (i + 1 < count ? 0xE000_0000 | ((i + 1) * 12) : 0x6000_0000))
    f.set(7, i * 3 + 1, 0x2401_0000 + i * 512)
    f.set(7, i * 3 + 2, 512)
  }
}

final class SDMMCLinkedListTests: XCTestCase {
  func testBuildLockAndCircularMode() {
    for value: UInt32 in [0, 1, 0x8000_0000, UInt32.max] {
      for missing: UInt32 in [0, 1] {
        for operation: UInt32 in [54, 57, 58, 59, 60] {
          for absent: UInt32 in [0, 1] {
            checkSDMMC(
              { f in
                prepareSDMMCList(f, count: 3)
                f.set(7, 0, value)
                f.set(5, 0, value)
                f.set(5, 1, value)
                f.set(1, 15, missing)
              }, operation: operation, absent != 0 ? 0 : operation >= 59 ? 0x2403_0000 : 0x2403_0100
            )
          }
        }
      }
    }
  }

  func testInsertFirstTailAndMiddlePreservesOriginalWrites() {
    for count: UInt32 in [0, 1, 3] {
      for previous: UInt32 in [0, 1, 2] {
        for newNode: UInt32 in [0, 1, 4, 5] {
          checkSDMMC(
            { f in
              prepareSDMMCList(f, count: count)
              f.set(7, newNode * 3, 0x6000_0024)
            }, operation: 55, 0x2403_0000, 0x2403_0100 + previous * 12, 0x2403_0100 + newNode * 12)
        }
      }
    }
  }

  func testOriginalRemovalEmptyAndHeadRejection() {
    // Pointer-walking removal executes against unchanged C in the ARM harness.
    for count: UInt32 in [0, 1, 3] {
      checkSDMMC(
        { prepareSDMMCList($0, count: count) },
        operation: 56, 0x2403_0000, 0x2403_0100)
    }
  }

  func testMiddleRemovalRetainsSourceTailAssignment() {
    let io = SDMMCFixture()
    prepareSDMMCList(io, count: 3)
    XCTAssertEqual(io.list.removeNode(0x2403_0000, node: 0x2403_010C), 0)
    XCTAssertEqual(io.get(6, 0), 0x2403_0100)
    XCTAssertEqual(io.get(6, 1), 0x2403_0100)
    XCTAssertEqual(io.get(6, 2), 2)
    XCTAssertEqual(io.get(7, 0), 0xE000_0018)
    XCTAssertEqual(io.get(7, 3), 0xE000_0018)
    XCTAssertEqual(io.list.removeNode(0x2403_0000, node: 0x2403_0148), 0x0800_0000)
  }

  func testTailInsertionDoesNotCoalesceIntermediateWrites() {
    let io = DMAListTestIO()
    let list = SDMMCDMALinkedList(memory: io)
    io.memory[0x2000] = 0x3000
    io.memory[0x2004] = 0x3000
    io.memory[0x2008] = 1
    io.memory[0x3000] = 0xE000_0048
    XCTAssertEqual(list.insertNode(0x2000, previousNode: 0x3000, node: 0x300C), 0)
    XCTAssertEqual(
      io.memoryWrites,
      [
        .memoryWrite(0x3000, 0x6000_0048),
        .memoryWrite(0x3000, 0xE000_0048),
        .memoryWrite(0x3000, 0xE000_000C),
        .memoryWrite(0x2008, 2),
        .memoryWrite(0x2004, 0x300C),
      ])
  }
}
