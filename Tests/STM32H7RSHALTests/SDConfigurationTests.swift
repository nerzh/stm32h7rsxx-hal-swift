import CSDReference
import STM32H7RSHAL
import XCTest

func prepareSDCard(_ f: SDFixture) {
  f.write(.state, value: 1)
  f.write(.cardType, value: 1)
  f.write(.cardVersion, value: 1)
  f.write(.cardClass, value: 0x20)
  f.write(.logicalBlockCount, value: 8192)
  f.write(.relativeCardAddress, value: 0x1234)
  f.set(3, 4, 1)
  f.set(3, 8, 1)
  f.set(0, SDMMCRegister.power.rawValue / 4, 3)
  f.set(0, SDMMCRegister.fifo.rawValue / 4, 0x0000_0702)
  f.set(4, 0, 0x80)
  f.set(4, 3 * 6 + 2, 0x1234_0000)
  f.set(4, 41 * 6 + 2, 0xC010_0000)
  for command: UInt32 in [6, 13, 17, 18, 51] { f.set(4, command * 6, 0x8040) }
  for command: UInt32 in [24, 25] { f.set(4, command * 6, 0x4040) }
  f.set(4, 13 * 6 + 2, 0x800)
  f.set(4, 12 * 6, 0x200_140)
  f.set(4, 9 * 6 + 2, 0x400E_0032)
  f.set(4, 9 * 6 + 3, 0x5B59_0000)
  f.set(4, 9 * 6 + 4, 0x01FF_7F80)
  f.set(4, 9 * 6 + 5, 0x0A40_001B)
  f.set(7, 0, 0x2403_0100)
  f.set(7, 1, 0x2403_010C)
  f.set(7, 2, 2)
  f.set(8, 0, 0xE000_000C)
  f.set(8, 1, 0x2401_0000)
  f.set(8, 2, 512)
  f.set(8, 3, 0x6000_0000)
  f.set(8, 4, 0x2401_0200)
  f.set(8, 5, 512)
}

final class SDConfigurationTests: XCTestCase {
  func testSuccessfulCardInitialization() {
    for variant: UInt32 in 0..<6 {
      for operation: UInt32 in [0, 1, 2] {
        checkSD(
          { f in
            prepareSDCard(f)
            f.write(.state, value: 0)
            f.write(.transceiverPresent, value: 0)
          }, operation: operation, variant: variant)
      }
      let f = SDFixture(variant: variant)
      prepareSDCard(f)
      f.write(.state, value: 0)
      XCTAssertEqual(f.run(0), HALStatus.ok.rawValue)
      XCTAssertEqual(f.read(.state), 1)
      XCTAssertEqual(f.read(.cardType), 1)
      XCTAssertEqual(f.read(.relativeCardAddress), 0x1234)
      XCTAssertGreaterThan(f.get(3, 7), 0)
    }
  }

  func testInitializationClockAndCommandFailures() {
    for variant: UInt32 in 0..<6 {
      for command: UInt32 in [0, 8, 55, 41, 2, 3, 9, 7, 16, 13, 51] {
        for flags: UInt32 in [1, 4] {
          checkSD(
            { f in
              prepareSDCard(f)
              f.write(.state, value: 0)
              f.set(4, command * 6, flags)
            }, operation: 0, variant: variant)
        }
      }
      for state: UInt32 in [0, 1, 3, 15] {
        checkSD(
          { f in
            prepareSDCard(f)
            f.write(.state, value: state)
            f.set(2, 5, 0)
          }, operation: 0, variant: variant)
      }
    }
  }

  func testCallbackRegistrationStateAndLockOrder() {
    for variant: UInt32 in 0..<6 {
      for state: UInt32 in [0, 1, 3, 15] {
        for id: UInt32 in [0, 1, 2, 3, 4, 5, 6, 16, 17, 18, UInt32.max] {
          for kind: UInt32 in [0, 1, 2] {
            for op: UInt32 in [13, 14, 15, 16] {
              checkSD(
                { f in
                  prepareSDCard(f)
                  f.write(.state, value: state)
                  f.write(.errorCode, value: 0x1234)
                  f.write(.lock, value: id & 1)
                }, operation: op, id, kind, variant: variant)
            }
          }
        }
      }
    }
  }

  func testCardInformationBitFieldsAndUntouchedMembers() {
    for cardType: UInt32 in [0, 1, 3, UInt32.max] {
      for bit: UInt32 in 0..<32 {
        for op: UInt32 in [11, 12, 17, 18, 20] {
          checkSD(
            { f in
              prepareSDCard(f)
              f.write(.cardType, value: cardType)
              for i in 0..<4 {
                f.writeCardRegister(.cid, index: i, value: (1 << bit) | 0x0101_0101)
                f.writeCardRegister(.csd, index: i, value: 1 << bit)
              }
              for (g, n): (UInt32, UInt32) in [(10, 9), (11, 37), (12, 10), (13, 13)] {
                for i in 0..<n { f.set(g, i, UInt32.max) }
              }
            }, operation: op)
        }
      }
    }
    let f = SDFixture()
    prepareSDCard(f)
    f.set(10, 8, 0xDEAD_BEEF)
    XCTAssertEqual(f.run(20), 0)
    XCTAssertEqual(f.get(10, 8), 0xDEAD_BEEF)
  }

  func testCardStatusFIFOAndBusyState() {
    for state: UInt32 in [0, 1, 3, 15] {
      for word: UInt32 in [0, UInt32.max, 0x0123_4567, 0xAABB_CCDD] {
        checkSD(
          { f in
            prepareSDCard(f)
            f.write(.state, value: state)
            f.set(0, SDMMCRegister.fifo.rawValue / 4, word)
          }, operation: 19)
      }
    }
  }
}
