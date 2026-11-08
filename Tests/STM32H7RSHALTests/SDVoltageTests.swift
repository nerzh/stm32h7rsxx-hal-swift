import CSDReference
import STM32H7RSHAL
import XCTest

final class SDVoltageTests: XCTestCase {
  func testVoltageSwitchSequenceAndFailureStates() {
    for variant: UInt32 in [2, 3] {
      for flags: UInt32 in [1, 4, 0x40, 0x0400_0040, 0x0410_0040, 0x0610_0040] {
        for afterSwitch: UInt32 in [0, 0x0200_0040, 0x0210_0040] {
          checkSD(
            { f in
              prepareSDCard(f)
              f.write(.transceiverPresent, value: 2)
              f.set(4, 41 * 6 + 2, 0xC110_0000)
              f.set(4, 11 * 6, flags)
              f.set(2, 3, UInt32.max)
              f.set(2, 24, afterSwitch == 0 ? 0 : 1)
              f.set(2, 25, afterSwitch)
            }, operation: 1, variant: variant)
        }
      }
      let f = SDFixture(variant: variant)
      prepareSDCard(f)
      f.write(.transceiverPresent, value: 2)
      f.set(4, 41 * 6 + 2, 0xC110_0000)
      f.set(4, 11 * 6, 0x0410_0040)
      f.set(2, 24, 1)
      f.set(2, 25, 0x0200_0040)
      XCTAssertEqual(f.run(1), 0)
      XCTAssertEqual(f.read(.cardSpeed), 0x200)
      XCTAssertEqual(f.read(.power), 0x13)
      XCTAssertGreaterThan(f.get(2, 14), 0)
    }
  }
}
