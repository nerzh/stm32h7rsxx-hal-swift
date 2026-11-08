import XCTest

final class RAMDMADifferentialTests: XCTestCase {
  func testDirectAndLinkedCountsWidthsFailureResultsAndStates() {
    for sdram in [false, true] {
      for write: UInt32 in [0, 1] {
        for state: UInt32 in [0, 1, 2, 3, 4, 5] {
          for mode: UInt32 in [0, 0x80, 0x81] {
            for width: UInt32 in [0, 0x10000, 0x20000, 0x30000] {
              for result: UInt32 in [0, 1, 2, 3] {
                checkRAM(
                  sdram,
                  { f in
                    f.set(2, 1, state)
                    f.set(11, 0, mode)
                    f.set(11, 1, width)
                    f.set(13, 0, width | 0x5500_0000)
                    f.set(11, 13, result)
                  }, operation: (sdram ? 9 : 8) + write, 0x6000_0080, 17)
              }
            }
          }
        }
      }
    }
  }

  func testMissingQueueHeadRetainsDifferentRecoveryStates() {
    for sdram in [false, true] {
      for state: UInt32 in [1, 4] {
        for queue: UInt32 in [0, 1] {
          for head: UInt32 in [0, 1] where queue == 0 || head == 0 {
            let f = checkRAM(
              sdram,
              { f in
                f.set(2, 1, state)
                f.set(11, 0, 0x80)
                f.set(11, 2, queue)
                f.set(11, 3, head)
              }, operation: sdram ? 9 : 8, 0x6000_0080, 7)
            XCTAssertEqual(f.get(2, 1), sdram ? 2 : 1)
            XCTAssertEqual(f.get(2, 0), 0)
          }
        }
      }
    }
  }

  func testCountArithmeticWrapsAtThirtyTwoBits() {
    for sdram in [false, true] {
      for count: UInt32 in [0, 1, 0x4000_0000, 0x8000_0001, 0xFFFF_FFFF] {
        for width: UInt32 in [0, 0x10000, 0x20000] {
          for mode: UInt32 in [0, 0x80] {
            checkRAM(
              sdram,
              { f in
                f.set(11, 0, mode)
                f.set(11, 1, width)
                f.set(13, 0, width)
              }, operation: sdram ? 9 : 8, 0x6000_0080, count)
          }
        }
      }
    }
  }

  func testCompletionReadsCurrentParentAndDisablesActualSource() {
    for sdram in [false, true] {
      for variant: UInt32 in [0, 1] {
        for event: UInt32 in [0, 1, 2] {
          let cSource = makeRAMFixture(sdram, variant: variant)
          let sSource = makeRAMFixture(sdram, variant: variant)
          let cParent = makeRAMFixture(sdram, variant: variant)
          let sParent = makeRAMFixture(sdram, variant: variant)
          cSource.setParent(0, to: cParent)
          sSource.setParent(0, to: sParent)
          cParent.set(6, 4, 1)
          sParent.set(6, 4, 1)
          XCTAssertEqual(sSource.run(51, event, 0, 0), cSource.runReference(51, event, 0, 0))
          XCTAssertEqual(cSource.compare(to: sSource), 0)
          XCTAssertEqual(cParent.compare(to: sParent), 0)
          XCTAssertEqual(sSource.get(11, 4) & 6, 6)
          XCTAssertEqual(sParent.get(12, 4) & 6, 0)
          XCTAssertEqual(sParent.get(2, 1), event == 0 ? 1 : event == 1 ? 4 : 3)
          XCTAssertEqual(sParent.get(15, 1), 0)
        }
      }
    }
  }

  func testSynchronousDMACompletionAndHeldLock() {
    for sdram in [false, true] {
      for event: UInt32 in [1, 2, 3] {
        for lock: UInt32 in [0, 1] {
          checkRAM(
            sdram,
            { f in
              f.set(2, 0, lock)
              f.set(6, 7, event)
              f.set(6, 8, 0)
              f.set(6, 4, 1)
            }, operation: sdram ? 9 : 8, 0x6000_0080, 7)
        }
      }
    }
  }
}
