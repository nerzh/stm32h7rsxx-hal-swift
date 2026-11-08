import CAudioReference
import STM32H7RSHAL
import XCTest

final class I2SConfigurationTests: XCTestCase {
  func testDividerRoundingModesFormatsClockSelectionsAndRegisterMasks() {
    for registered in [false, true] {
      for instance: UInt32 in 0..<4 {
        for mode: UInt32 in [0, 2, 4, 6, 8, 10] {
          for format: UInt32 in [0, 0x100, 0x200, 0x400] {
            for frequency: UInt32 in [2, 8_000, 11_025, 44_100, 48_000, 192_000, 666_667, 1] {
              let pair = I2SPair(callbacks: registered)
              pair.setup {
                $0.control(0, instance)
                $0.write(.mode, value: mode)
                $0.write(.dataFormat, value: format)
                $0.write(.standard, value: instance & 1 == 0 ? 0 : 0xB0)
                $0.write(.audioFrequency, value: frequency)
                $0.write(.masterClockOutput, value: mode & 4 == 0 ? 0x2000000 : 0)
                $0.write(.clockPolarity, value: 0x800)
                $0.write(.wordSelectInversion, value: 0x1000)
                $0.write(.data24BitAlignment, value: 0x2000)
                $0.write(.masterKeepIOState, value: 0x8000_0000)
                $0.write(.firstBit, value: 0x800000)
                $0.write(.cr1, value: 0xFFFF_FFFF)
                $0.write(.cfg2, value: 0x5A5A_5A5A)
                $0.write(.i2scfgr, value: .max)
                $0.write(.errorCode, value: 0x8000_0000)
              }
              pair.verify(0)
            }
          }
        }
      }
    }
  }
  func testClockExtremesAndDefaultFrequencySkipClockRead() {
    for clock: UInt32 in [0, 1, 48_000_000, 49_152_000, 64_000_000, .max] {
      for frequency: UInt32 in [2, 1, 8_000, 48_000, .max] {
        for masterClock: UInt32 in [0, 0x2000000] {
          let pair = I2SPair()
          pair.setup {
            $0.control(5, clock)
            $0.write(.mode, value: 4)
            $0.write(.standard, value: 0x30)
            $0.write(.audioFrequency, value: frequency)
            $0.write(.masterClockOutput, value: masterClock)
            $0.write(.state, value: 1)
          }
          pair.verify(0)
          XCTAssertEqual(pair.swift.control(7), frequency == 2 ? 0 : 1)
        }
      }
    }
  }
  func testMSPCallbacksAreReadBeforeContinuingInitialization() {
    for registered in [false, true] {
      for callback: UInt32 in [0, 1, 2] {
        let pair = I2SPair(callbacks: registered)
        pair.setup {
          CI2S_SetCallback($0.state, 7, CI2S_Callback(7, callback))
          $0.control(20, 8)
          $0.control(21, 0)
          $0.control(22, 4)
          $0.write(.audioFrequency, value: 48_000)
        }
        pair.verify(0)
        pair.verify(16)
        pair.verify(18)
        pair.verify(17)
        pair.verify(18)
        pair.verify(1)
      }
    }
  }
}
