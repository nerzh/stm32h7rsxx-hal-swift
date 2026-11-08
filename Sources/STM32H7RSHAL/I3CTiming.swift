// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Timing computations from stm32h7rsxx_util_i3c.c
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.
// ErrorStatus uses CMSIS stm32h7rsxx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

public enum I3CTimingStatus: UInt32, Sendable {
  // ErrorStatus from the pinned STM32H7RS CMSIS device header.
  case success = 0
  case error = 1
}

public struct I3CControllerTiming: Equatable, Sendable {
  public var clockSourceFrequency: UInt32
  public var i3cPushPullFrequency: UInt32
  public var i2cOpenDrainFrequency: UInt32
  public var dutyCycle: UInt32
  public var busType: UInt32

  public init(
    clockSourceFrequency: UInt32, i3cPushPullFrequency: UInt32,
    i2cOpenDrainFrequency: UInt32, dutyCycle: UInt32, busType: UInt32
  ) {
    self.clockSourceFrequency = clockSourceFrequency
    self.i3cPushPullFrequency = i3cPushPullFrequency
    self.i2cOpenDrainFrequency = i2cOpenDrainFrequency
    self.dutyCycle = dutyCycle
    self.busType = busType
  }
}

public enum I3CTiming {
  public static let pureBus: UInt32 = 0
  public static let mixedBus: UInt32 = 1

  private static func roundedDivide(_ value: UInt32, _ divisor: UInt32) -> UInt32 {
    (value &+ (divisor / 2)) / divisor
  }

  private static func period(_ frequency: UInt32) -> UInt32 {
    UInt32(truncatingIfNeeded: (100_000_000_000 + UInt64(frequency) / 2) / UInt64(frequency))
  }

  // I3C_CtrlTimingComputation. The reference also divides by the I2C frequency
  // on a pure bus. It must be nonzero whenever the initial validation succeeds.
  public static func computeController(
    _ input: I3CControllerTiming, configuration: inout I3CControllerBusConfiguration
  ) -> I3CTimingStatus {
    var status = I3CTimingStatus.success
    let ti3chMin: UInt32 = 3200
    let ti3chODMax: UInt32 = 4100
    let ti3clODMin: UInt32 = 20000
    let tfmplODMin: UInt32 = 50000
    let tfmlODMin: UInt32 = 130000
    let tfmMin: UInt32 = 250000
    let tsmMin: UInt32 = 1_000_000
    let ti3cCASMin: UInt32 = 3840
    let tcapa: UInt32 = 35000
    var ti3cclk: UInt32 = 0
    var ti3cPPMin: UInt32 = 0
    var ti2cODMin: UInt32 = 0

    if input.clockSourceFrequency > 257_000_000 { status = .error }
    if input.busType != pureBus && input.busType != mixedBus { status = .error }
    if (input.clockSourceFrequency == 0 || input.i3cPushPullFrequency == 0)
      && input.busType == pureBus
    {
      status = .error
    }
    if (input.clockSourceFrequency == 0 || input.i3cPushPullFrequency == 0
      || input.i2cOpenDrainFrequency == 0) && input.busType == mixedBus
    {
      status = .error
    }

    if status == .success {
      ti3cclk = period(input.clockSourceFrequency)
      if input.dutyCycle > 50 || ti3cclk == 0 { status = .error }
    }
    if status == .success && ti3cclk != 0 {
      ti3cPPMin = period(input.i3cPushPullFrequency)
      precondition(
        input.i2cOpenDrainFrequency != 0,
        "The C timing utility divides by i2cODFreq even on a pure I3C bus.")
      ti2cODMin = period(input.i2cOpenDrainFrequency)
      if input.busType != pureBus && ti2cODMin > tsmMin { status = .error }
    }

    if status == .success && ti3cclk != 0 {
      var sclhi3c: UInt32
      var scllpp: UInt32
      var scllod: UInt32
      let sclhi2c: UInt32
      let free: UInt32
      let sdahold: UInt32

      if input.busType == pureBus {
        sclhi3c = roundedDivide(roundedDivide(ti3cPPMin &* input.dutyCycle, ti3cclk), 100) &- 1
        if ((sclhi3c &+ 1) &* ti3cclk) < ti3chMin {
          sclhi3c = roundedDivide(ti3chMin, ti3cclk) &- 1
          if ((sclhi3c &+ 1) &* ti3cclk) < ti3chMin { sclhi3c &+= 1 }
          scllpp = roundedDivide(ti3cPPMin, ti3cclk) &- (sclhi3c &+ 1) &- 1
        } else {
          sclhi3c = roundedDivide(roundedDivide(ti3cPPMin &* input.dutyCycle, ti3cclk), 100) &- 1
          if ((sclhi3c &+ 1) &* ti3cclk) < ti3chMin { sclhi3c &+= 1 }
          scllpp =
            roundedDivide(ti3cPPMin &- ((sclhi3c &+ 1) &* ti3cclk) &+ (ti3cclk / 2), ti3cclk) &- 1
        }
      } else {
        sclhi3c = roundedDivide(ti3chODMax, ti3cclk) &- 1
        if ((sclhi3c &+ 1) &* ti3cclk) < ti3chMin {
          sclhi3c &+= 1
        } else if ((sclhi3c &+ 1) &* ti3cclk) > ti3chODMax {
          sclhi3c = ti3chODMax / ti3cclk
        }
        scllpp = roundedDivide(ti3cPPMin &- ((sclhi3c &+ 1) &* ti3cclk), ti3cclk) &- 1
      }

      let idealScllpp = ti3cPPMin &- ((sclhi3c &+ 1) &* ti3cclk)
      if ((scllpp &+ 1) &* ti3cclk) >= (idealScllpp &+ (ti3cclk / 2) &+ 1) {
        scllpp &-= 1
      }
      if ((scllpp &+ sclhi3c &+ 1 &+ 1) &* ti3cclk) < (idealScllpp &+ (ti3cclk / 2) &+ 1) {
        scllpp &+= 1
      }

      if input.busType == pureBus {
        if ti3cPPMin < ti3clODMin {
          scllod = roundedDivide(ti3clODMin, ti3cclk) &- 1
          if ((scllod &+ 1) &* ti3cclk) < ti3clODMin { scllod &+= 1 }
        } else {
          scllod = scllpp
        }
        if ((scllod &+ 1) &* ti3cclk) < tcapa {
          scllod = roundedDivide(tcapa, ti3cclk) &+ 1
        }
        sclhi2c = 0
      } else {
        scllod =
          roundedDivide(roundedDivide(ti2cODMin &* (100 &- input.dutyCycle), ti3cclk), 100) &- 1
        if ti2cODMin < tfmMin {
          if ((scllod &+ 1) &* ti3cclk) < tfmplODMin {
            scllod = roundedDivide(tfmplODMin, ti3cclk) &- 1
          }
        } else {
          if ((scllod &+ 1) &* ti3cclk) < tfmlODMin {
            scllod = roundedDivide(tfmlODMin, ti3cclk) &- 1
          }
        }
        sclhi2c = roundedDivide(ti2cODMin &- ((scllod &+ 1) &* ti3cclk), ti3cclk) &- 1
      }

      if input.busType == pureBus {
        free = roundedDivide(ti3cCASMin &+ tcapa, 2 &* ti3cclk) &+ 1
      } else {
        free = roundedDivide(((scllod &+ 1) &* ti3cclk) &+ tcapa, 2 &* ti3cclk)
      }
      if ti3cclk > 600 { sdahold = 0 } else { sdahold = 1 }
      let oneus = roundedDivide(100000, ti3cclk) &- 2

      if scllpp > 0xFF || sclhi3c > 0xFF || scllod > 0xFF || sclhi2c > 0xFF
        || free > 0xFF || oneus > 0xFF
      {
        status = .error
      } else {
        configuration.sclppLowDuration = UInt8(truncatingIfNeeded: scllpp)
        configuration.sclI3CHighDuration = UInt8(truncatingIfNeeded: sclhi3c)
        configuration.sclodLowDuration = UInt8(truncatingIfNeeded: scllod)
        configuration.sclI2CHighDuration = UInt8(truncatingIfNeeded: sclhi2c)
        configuration.busFreeDuration = UInt8(truncatingIfNeeded: free)
        configuration.busIdleDuration = UInt8(truncatingIfNeeded: oneus)
        configuration.sdaHoldTime = sdahold << 28
      }
    }
    return status
  }

  // I3C_TgtTimingComputation. This reference accepts frequencies above the
  // controller limit and truncates the computed duration to eight bits.
  public static func computeTarget(
    clockSourceFrequency: UInt32, configuration: inout I3CTargetBusConfiguration
  ) -> I3CTimingStatus {
    var status = I3CTimingStatus.success
    var ti3cclk: UInt32 = 0
    if clockSourceFrequency == 0 { status = .error }
    if status == .success {
      ti3cclk = period(clockSourceFrequency)
      if ti3cclk == 0 { status = .error }
    }
    if status == .success && ti3cclk != 0 {
      let oneus = roundedDivide(100000, ti3cclk) &- 2
      configuration.busAvailableDuration = UInt8(truncatingIfNeeded: oneus)
    }
    return status
  }
}
