// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func outputCompareConfigureChannel(
    _ sConfig: TIMOutputCompareConfiguration, _ Channel: UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok

    guard lock() else { return .busy }
    switch Channel
    {
    case 0x0:
      do {

        oc1SetConfig(sConfig)
        break
      }
    case 0x4:
      do {

        oc2SetConfig(sConfig)
        break
      }
    case 0x8:
      do {

        oc3SetConfig(sConfig)
        break
      }
    case 0xc:
      do {

        oc4SetConfig(sConfig)
        break
      }
    case 0x10:
      do {

        oc5SetConfig(sConfig)
        break
      }
    case 0x14:
      do {

        oc6SetConfig(sConfig)
        break
      }
    default:
      status = .error
      break
    }
    unlock()
    return status

  }
  public func inputCaptureConfigureChannel(
    _ sConfig: TIMInputCaptureConfiguration, _ Channel: UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok

    guard lock() else { return .busy }
    if Channel == 0x0 {
      ti1SetConfig(
        sConfig.inputCapturePolarity, sConfig.inputCaptureSelection, sConfig.inputCaptureFilter)

      registers.write(.ccmr1, value: registers.read(.ccmr1) & (~0xc))

      registers.write(.ccmr1, value: registers.read(.ccmr1) | (sConfig.inputCapturePrescaler))
    } else if Channel == 0x4 {

      ti2SetConfig(
        sConfig.inputCapturePolarity, sConfig.inputCaptureSelection, sConfig.inputCaptureFilter)

      registers.write(.ccmr1, value: registers.read(.ccmr1) & (~0xc00))

      registers.write(
        .ccmr1, value: registers.read(.ccmr1) | ((sConfig.inputCapturePrescaler << 8)))
    } else if Channel == 0x8 {

      ti3SetConfig(
        sConfig.inputCapturePolarity, sConfig.inputCaptureSelection, sConfig.inputCaptureFilter)

      registers.write(.ccmr2, value: registers.read(.ccmr2) & (~0xc))

      registers.write(.ccmr2, value: registers.read(.ccmr2) | (sConfig.inputCapturePrescaler))
    } else if Channel == 0xc {

      ti4SetConfig(
        sConfig.inputCapturePolarity, sConfig.inputCaptureSelection, sConfig.inputCaptureFilter)

      registers.write(.ccmr2, value: registers.read(.ccmr2) & (~0xc00))

      registers.write(
        .ccmr2, value: registers.read(.ccmr2) | ((sConfig.inputCapturePrescaler << 8)))
    } else {
      status = .error
    }
    unlock()
    return status

  }
  public func pwmConfigureChannel(_ sConfig: TIMOutputCompareConfiguration, _ Channel: UInt32)
    -> HALStatus
  {

    var status: HALStatus = .ok

    guard lock() else { return .busy }
    switch Channel
    {
    case 0x0:
      do {

        oc1SetConfig(sConfig)

        registers.write(.ccmr1, value: registers.read(.ccmr1) | (0x8))

        registers.write(.ccmr1, value: registers.read(.ccmr1) & (~0x4))
        registers.write(.ccmr1, value: registers.read(.ccmr1) | (sConfig.outputCompareFastMode))
        break
      }
    case 0x4:
      do {

        oc2SetConfig(sConfig)

        registers.write(.ccmr1, value: registers.read(.ccmr1) | (0x800))

        registers.write(.ccmr1, value: registers.read(.ccmr1) & (~0x400))
        registers.write(
          .ccmr1, value: registers.read(.ccmr1) | (sConfig.outputCompareFastMode << 8))
        break
      }
    case 0x8:
      do {

        oc3SetConfig(sConfig)

        registers.write(.ccmr2, value: registers.read(.ccmr2) | (0x8))

        registers.write(.ccmr2, value: registers.read(.ccmr2) & (~0x4))
        registers.write(.ccmr2, value: registers.read(.ccmr2) | (sConfig.outputCompareFastMode))
        break
      }
    case 0xc:
      do {

        oc4SetConfig(sConfig)

        registers.write(.ccmr2, value: registers.read(.ccmr2) | (0x800))

        registers.write(.ccmr2, value: registers.read(.ccmr2) & (~0x400))
        registers.write(
          .ccmr2, value: registers.read(.ccmr2) | (sConfig.outputCompareFastMode << 8))
        break
      }
    case 0x10:
      do {

        oc5SetConfig(sConfig)

        registers.write(.ccmr3, value: registers.read(.ccmr3) | (0x8))

        registers.write(.ccmr3, value: registers.read(.ccmr3) & (~0x4))
        registers.write(.ccmr3, value: registers.read(.ccmr3) | (sConfig.outputCompareFastMode))
        break
      }
    case 0x14:
      do {

        oc6SetConfig(sConfig)

        registers.write(.ccmr3, value: registers.read(.ccmr3) | (0x800))

        registers.write(.ccmr3, value: registers.read(.ccmr3) & (~0x400))
        registers.write(
          .ccmr3, value: registers.read(.ccmr3) | (sConfig.outputCompareFastMode << 8))
        break
      }
    default:
      status = .error
      break
    }
    unlock()
    return status

  }
  public func onePulseConfigureChannel(
    _ sConfig: TIMOnePulseConfiguration, _ OutputChannel: UInt32, _ InputChannel: UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok
    var temp1 = TIMOutputCompareConfiguration()

    if OutputChannel != InputChannel {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x2)

      temp1.outputCompareMode = sConfig.outputCompareMode
      temp1.pulse = sConfig.pulse
      temp1.outputComparePolarity = sConfig.outputComparePolarity
      temp1.outputCompareNPolarity = sConfig.outputCompareNPolarity
      temp1.outputCompareIdleState = sConfig.outputCompareIdleState
      temp1.outputCompareNIdleState = sConfig.outputCompareNIdleState
      switch OutputChannel
      {
      case 0x0:
        do {
          oc1SetConfig(temp1)
          break
        }
      case 0x4:
        do {
          oc2SetConfig(temp1)
          break
        }
      default:
        status = .error
        break
      }
      if status == .ok {
        switch InputChannel
        {
        case 0x0:
          do {
            ti1SetConfig(
              sConfig.inputCapturePolarity, sConfig.inputCaptureSelection,
              sConfig.inputCaptureFilter)

            registers.write(.ccmr1, value: registers.read(.ccmr1) & (~0xc))

            registers.write(.smcr, value: registers.read(.smcr) & (~0x300070))
            registers.write(.smcr, value: registers.read(.smcr) | (0x50))

            registers.write(.smcr, value: registers.read(.smcr) & (~0x10007))
            registers.write(.smcr, value: registers.read(.smcr) | (0x6))
            break
          }
        case 0x4:
          do {
            ti2SetConfig(
              sConfig.inputCapturePolarity, sConfig.inputCaptureSelection,
              sConfig.inputCaptureFilter)

            registers.write(.ccmr1, value: registers.read(.ccmr1) & (~0xc00))

            registers.write(.smcr, value: registers.read(.smcr) & (~0x300070))
            registers.write(.smcr, value: registers.read(.smcr) | (0x60))

            registers.write(.smcr, value: registers.read(.smcr) & (~0x10007))
            registers.write(.smcr, value: registers.read(.smcr) | (0x6))
            break
          }
        default:
          status = .error
          break
        }
      }
      handle.write(.state, value: 0x1)
      unlock()
      return status
    } else {
      return .error
    }

  }
}
