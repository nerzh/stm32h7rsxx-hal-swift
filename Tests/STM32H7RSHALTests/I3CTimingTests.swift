import CI3CReference
import STM32H7RSHAL
import XCTest

final class I3CTimingTests: XCTestCase {
  private func compareController(
    clock: UInt32, pushPull: UInt32, openDrain: UInt32, duty: UInt32, bus: UInt32,
    file: StaticString = #filePath, line: UInt = #line
  ) {
    let input = I3CControllerTiming(
      clockSourceFrequency: clock, i3cPushPullFrequency: pushPull,
      i2cOpenDrainFrequency: openDrain, dutyCycle: duty, busType: bus)
    var swift = I3CControllerBusConfiguration(
      sdaHoldTime: 0x1357_9BDF, waitTime: 0xCAFE_BABE,
      sclppLowDuration: 0x91, sclI3CHighDuration: 0x92,
      sclodLowDuration: 0x93, sclI2CHighDuration: 0x94,
      busFreeDuration: 0x95, busIdleDuration: 0x96)
    let before = swift
    var c: [UInt32] = [0x1357_9BDF, 0xCAFE_BABE, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96]
    let expected = CI3C_ControllerTiming([clock, pushPull, openDrain, duty, bus], &c)
    let actual = I3CTiming.computeController(input, configuration: &swift)
    let message = "clock=\(clock), pp=\(pushPull), od=\(openDrain), duty=\(duty), bus=\(bus)"
    XCTAssertEqual(actual.rawValue, expected, message, file: file, line: line)
    XCTAssertEqual(
      [
        swift.sdaHoldTime, swift.waitTime, UInt32(swift.sclppLowDuration),
        UInt32(swift.sclI3CHighDuration), UInt32(swift.sclodLowDuration),
        UInt32(swift.sclI2CHighDuration), UInt32(swift.busFreeDuration),
        UInt32(swift.busIdleDuration),
      ], c, message, file: file, line: line)
    XCTAssertEqual(swift.waitTime, before.waitTime, message, file: file, line: line)
    if actual == .error { XCTAssertEqual(swift, before, message, file: file, line: line) }
  }

  private func compareTarget(_ clock: UInt32, file: StaticString = #filePath, line: UInt = #line) {
    var swift = I3CTargetBusConfiguration(busAvailableDuration: 0xA5)
    var c: UInt8 = 0xA5
    let expected = CI3C_TargetTiming(clock, &c)
    let actual = I3CTiming.computeTarget(clockSourceFrequency: clock, configuration: &swift)
    XCTAssertEqual(actual.rawValue, expected, "clock=\(clock)", file: file, line: line)
    XCTAssertEqual(swift.busAvailableDuration, c, "clock=\(clock)", file: file, line: line)
  }

  func testControllerTimingMatrix() {
    for clock: UInt32 in [
      1, 7, 23, 24, 46, 47, 1_000, 100_000, 1_000_000, 4_000_000, 16_000_000,
      25_000_000, 64_000_000, 100_000_000, 166_527_893, 166_666_666,
      166_805_671, 200_000_000, 256_000_000, 257_000_000,
    ] {
      for pushPull: UInt32 in [1, 23, 100_000, 1_000_000, 4_000_000, 5_000_000, 12_500_000, .max] {
        for openDrain: UInt32 in [
          1, 23, 99_999, 100_000, 399_999, 400_000, 400_001, 1_000_000, .max,
        ] {
          for duty: UInt32 in [0, 1, 25, 49, 50] {
            for bus: UInt32 in [I3CTiming.pureBus, I3CTiming.mixedBus] {
              compareController(
                clock: clock, pushPull: pushPull, openDrain: openDrain, duty: duty, bus: bus)
            }
          }
        }
      }
    }
  }

  func testInvalidInputsLeaveConfigurationUntouched() {
    for clock: UInt32 in [0, 64_000_000, 257_000_001, .max] {
      for pushPull: UInt32 in [0, 12_500_000] {
        for openDrain: UInt32 in [0, 1_000_000] {
          for duty: UInt32 in [0, 50, 51, .max] {
            for bus: UInt32 in [0, 1, 2, .max] {
              // The pure-bus zero divisor is undefined in C only after its initial checks pass.
              if bus == 0 && clock != 0 && clock <= 257_000_000 && pushPull != 0
                && duty <= 50 && openDrain == 0
              {
                continue
              }
              compareController(
                clock: clock, pushPull: pushPull, openDrain: openDrain, duty: duty, bus: bus)
            }
          }
        }
      }
    }
  }

  func testDeterministicTimingSamples() {
    var seed: UInt32 = 0x9E37_79B9
    for _ in 0..<20000 {
      seed = seed &* 1_664_525 &+ 1_013_904_223
      let clock = (seed % 257_000_000) &+ 1
      seed = seed &* 1_664_525 &+ 1_013_904_223
      let pushPull = seed | 1
      seed = seed &* 1_664_525 &+ 1_013_904_223
      let openDrain = seed | 1
      seed = seed &* 1_664_525 &+ 1_013_904_223
      compareController(
        clock: clock, pushPull: pushPull, openDrain: openDrain, duty: seed % 51,
        bus: (seed >> 8) & 1)
      compareTarget(seed)
    }
  }

  func testTargetTruncationAndFrequencyLimits() {
    for clock: UInt32 in [
      0, 1, 7, 23, 24, 46, 47, 1_000, 100_000, 1_000_000, 16_000_000, 64_000_000,
      200_000_000, 256_000_000, 257_000_000, 257_000_001, 258_000_000, 500_000_000, .max,
    ] { compareTarget(clock) }
    var config = I3CTargetBusConfiguration()
    XCTAssertEqual(
      I3CTiming.computeTarget(clockSourceFrequency: 1_000_000, configuration: &config), .success)
    XCTAssertEqual(config.busAvailableDuration, 255)
    XCTAssertEqual(
      I3CTiming.computeTarget(clockSourceFrequency: 500_000_000, configuration: &config), .success)
    XCTAssertEqual(config.busAvailableDuration, 242)
  }

  func testControllerKnownConfigurationAndStatusEncoding() {
    XCTAssertEqual(I3CTimingStatus.error.rawValue, 1)
    XCTAssertEqual(I3CTimingStatus.success.rawValue, 0)
    var config = I3CControllerBusConfiguration(waitTime: 0xCAFE_BABE)
    let status = I3CTiming.computeController(
      .init(
        clockSourceFrequency: 64_000_000, i3cPushPullFrequency: 12_500_000,
        i2cOpenDrainFrequency: 1_000_000, dutyCycle: 50, busType: I3CTiming.pureBus),
      configuration: &config)
    XCTAssertEqual(status, .success)
    XCTAssertEqual(config.sdaHoldTime, 0)
    XCTAssertEqual(config.waitTime, 0xCAFE_BABE)
    XCTAssertEqual(config.sclI2CHighDuration, 0)
    XCTAssertEqual(config.busIdleDuration, 62)
    compareController(
      clock: 64_000_000, pushPull: 12_500_000, openDrain: 1_000_000, duty: 50, bus: 0)
  }
}
