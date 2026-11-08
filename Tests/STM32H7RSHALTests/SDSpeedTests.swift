import CSDReference
import STM32H7RSHAL
import XCTest

final class SDSpeedTests: XCTestCase {
  func testWideBusClockDividersAndSCRCapabilities() {
    for variant: UInt32 in 0..<6 {
      for mode: UInt32 in [0, 0x4000, 0x8000, UInt32.max] {
        for fifo: UInt32 in [0, 0x100, 0x400, 0x700] {
          for clock: UInt32 in [0, 25_000_000, 64_000_000] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.set(2, 5, clock)
                f.set(0, SDMMCRegister.fifo.rawValue / 4, fifo)
                f.write(.clockDivider, value: 0)
              }, operation: 21, mode, variant: variant)
          }
        }
      }
    }
    for divider: UInt32 in [1, 2, 1023, UInt32.max] {
      for speed: UInt32 in [0, 0x100, 0x200] {
        checkSD(
          { f in
            prepareSDCard(f)
            f.write(.clockDivider, value: divider)
            f.write(.cardSpeed, value: speed)
          }, operation: 21, 0x4000)
      }
    }
  }

  func testSpeedModesTransceiverAndDelayBlockSelection() {
    for variant: UInt32 in 0..<6 {
      for instance: UInt32 in [1, 2] {
        for present: UInt32 in [0, 2] {
          for speed: UInt32 in [0, 0x100, 0x200] {
            for mode: UInt32 in [0, 1, 2, 3, 4, 5, UInt32.max] {
              checkSD(
                { f in
                  prepareSDCard(f)
                  f.set(2, 1, instance)
                  f.write(.cardSpeed, value: speed)
                  f.write(.transceiverPresent, value: present)
                  f.set(0, SDMMCRegister.clkcr.rawValue / 4, 0xAA55_5555)
                  for i: UInt32 in 0..<4 { f.set(15, i, 0x100 + i) }
                }, operation: 22, mode, variant: variant)
            }
          }
        }
      }
    }
    for mode: UInt32 in [3, 4, 5] {
      let f = SDFixture(variant: 3)
      prepareSDCard(f)
      f.write(.cardSpeed, value: 0x200)
      f.write(.transceiverPresent, value: 2)
      XCTAssertEqual(f.run(22, mode), 0)
      XCTAssertEqual(f.readDelayControl() & 1, 1)
      XCTAssertGreaterThan(f.get(2, 14), 0)
    }
  }

  func testSpeedErrorsAndReadinessTimeout() {
    for variant: UInt32 in [0, 1, 2, 3] {
      for mode: UInt32 in [0, 1, 2, 3, 4, 5] {
        for command: UInt32 in [6, 13, 16, 51, 55] {
          for flags: UInt32 in [1, 4, 0x42, 0x48, 0x60] {
            checkSD(
              { f in
                prepareSDCard(f)
                f.write(.cardSpeed, value: 0x200)
                f.write(.transceiverPresent, value: 2)
                f.set(2, 3, UInt32.max)
                f.set(4, command * 6, flags)
              }, operation: 22, mode, variant: variant)
          }
        }
      }
    }
    for state: UInt32 in [0, 1, 5, 6, 7, 15] {
      checkSD(
        { f in
          prepareSDCard(f)
          f.set(2, 3, UInt32.max)
          f.set(4, 13 * 6 + 2, state << 9)
        }, operation: 22, 0)
    }
  }
}
