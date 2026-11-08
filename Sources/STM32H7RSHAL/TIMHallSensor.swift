// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func hallSensorInitialize(_ sConfig: TIMHallSensorConfiguration) -> HALStatus {

    var OC_Config = TIMOutputCompareConfiguration()

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        resetCallback()
        if callbacks.read(.hallSensorMspInitialize) == nil {
          callbacks.write(.hallSensorMspInitialize, value: defaults.hallSensorMspInitialize)
        }
        callbacks.read(.hallSensorMspInitialize)!(callbacks.context)
      } else {
        defaults.hallSensorMspInitialize(callbacks.context)
      }
    }

    handle.write(.state, value: 0x2)

    baseSetConfig(handle.configuration())

    ti1SetConfig(sConfig.inputCapture1Polarity, 0x3, sConfig.inputCapture1Filter)

    registers.write(.ccmr1, value: registers.read(.ccmr1) & (~0xc))
    registers.write(.ccmr1, value: registers.read(.ccmr1) | (sConfig.inputCapture1Prescaler))

    registers.write(.cr2, value: registers.read(.cr2) | (0x80))

    registers.write(.smcr, value: registers.read(.smcr) & (~0x300070))
    registers.write(.smcr, value: registers.read(.smcr) | (0x40))

    registers.write(.smcr, value: registers.read(.smcr) & (~0x10007))
    registers.write(.smcr, value: registers.read(.smcr) | (0x4))

    OC_Config.outputCompareFastMode = 0x0
    OC_Config.outputCompareIdleState = 0x0
    OC_Config.outputCompareMode = 0x70
    OC_Config.outputCompareNIdleState = 0x0
    OC_Config.outputCompareNPolarity = 0x0
    OC_Config.outputComparePolarity = 0x0
    OC_Config.pulse = sConfig.commutationDelay
    oc2SetConfig(OC_Config)

    registers.write(.cr2, value: registers.read(.cr2) & (~0x2000070))
    registers.write(.cr2, value: registers.read(.cr2) | (0x50))

    handle.write(.dmaBurstState, value: 0x1)

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    handle.write(.state, value: 0x1)
    return .ok

  }
  public func hallSensorDeinitialize() -> HALStatus {

    handle.write(.state, value: 0x2)

    disable()
    if useRegisteredCallbacks {
      if callbacks.read(.hallSensorMspDeinitialize) == nil {
        callbacks.write(.hallSensorMspDeinitialize, value: defaults.hallSensorMspDeinitialize)
      }
      callbacks.read(.hallSensorMspDeinitialize)!(callbacks.context)
    } else {
      defaults.hallSensorMspDeinitialize(callbacks.context)
    }

    handle.write(.dmaBurstState, value: 0x0)

    channelSetState(0x0, 0x0)
    channelSetState(0x4, 0x0)
    channelNSetState(0x0, 0x0)
    channelNSetState(0x4, 0x0)

    handle.write(.state, value: 0x0)

    unlock()
    return .ok

  }
  public func hallSensorStart() -> HALStatus {

    var tmpsmcr: UInt32
    var channel_1_state: UInt32 = channelState(0x0)
    var channel_2_state: UInt32 = channelState(0x4)
    var complementary_channel_1_state: UInt32 = channelNState(0x0)
    var complementary_channel_2_state: UInt32 = channelNState(0x4)

    if (channel_1_state != 0x1)
      || (channel_2_state != 0x1)
      || (complementary_channel_1_state != 0x1)
      || (complementary_channel_2_state != 0x1)
    {
      return .error
    }

    channelSetState(0x0, 0x2)
    channelSetState(0x4, 0x2)
    channelNSetState(0x0, 0x2)
    channelNSetState(0x4, 0x2)

    ccxChannelCmd(0x0, 0x1)

    if ((((registers.instance)) == TIMInstance.tim1) || (((registers.instance)) == TIMInstance.tim2)
      || (((registers.instance)) == TIMInstance.tim3)
      || (((registers.instance)) == TIMInstance.tim4)
      || (((registers.instance)) == TIMInstance.tim5)
      || (((registers.instance)) == TIMInstance.tim9)
      || (((registers.instance)) == TIMInstance.tim12)
      || (((registers.instance)) == TIMInstance.tim15))
    {
      tmpsmcr = registers.read(.smcr) & 0x10007
      if !(((tmpsmcr) == 0x6) || ((tmpsmcr) == 0x10000)) {
        enable()
      }
    } else {
      enable()
    }

    return .ok

  }
  public func hallSensorStop() -> HALStatus {

    ccxChannelCmd(0x0, 0x0)

    disable()

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    return .ok

  }
  public func hallSensorStartInterrupt() -> HALStatus {

    var tmpsmcr: UInt32
    var channel_1_state: UInt32 = channelState(0x0)
    var channel_2_state: UInt32 = channelState(0x4)
    var complementary_channel_1_state: UInt32 = channelNState(0x0)
    var complementary_channel_2_state: UInt32 = channelNState(0x4)

    if (channel_1_state != 0x1)
      || (channel_2_state != 0x1)
      || (complementary_channel_1_state != 0x1)
      || (complementary_channel_2_state != 0x1)
    {
      return .error
    }

    channelSetState(0x0, 0x2)
    channelSetState(0x4, 0x2)
    channelNSetState(0x0, 0x2)
    channelNSetState(0x4, 0x2)

    enableInterrupts(0x2)

    ccxChannelCmd(0x0, 0x1)

    if ((((registers.instance)) == TIMInstance.tim1) || (((registers.instance)) == TIMInstance.tim2)
      || (((registers.instance)) == TIMInstance.tim3)
      || (((registers.instance)) == TIMInstance.tim4)
      || (((registers.instance)) == TIMInstance.tim5)
      || (((registers.instance)) == TIMInstance.tim9)
      || (((registers.instance)) == TIMInstance.tim12)
      || (((registers.instance)) == TIMInstance.tim15))
    {
      tmpsmcr = registers.read(.smcr) & 0x10007
      if !(((tmpsmcr) == 0x6) || ((tmpsmcr) == 0x10000)) {
        enable()
      }
    } else {
      enable()
    }

    return .ok

  }
  public func hallSensorStopInterrupt() -> HALStatus {

    ccxChannelCmd(0x0, 0x0)

    disableInterrupts(0x2)

    disable()

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    return .ok

  }
  public func hallSensorStartDMA(_ pData: UnsafeMutablePointer<UInt32>?, _ Length: UInt16)
    -> HALStatus
  {
    let Length = UInt32(Length)

    var tmpsmcr: UInt32
    var channel_1_state: UInt32 = channelState(0x0)
    var complementary_channel_1_state: UInt32 = channelNState(0x0)

    if (channel_1_state == 0x2)
      || (complementary_channel_1_state == 0x2)
    {
      return .busy
    } else if (channel_1_state == 0x1)
      && (complementary_channel_1_state == 0x1)
    {
      if (pData == nil) || (Length == 0) {
        return .error
      } else {
        channelSetState(0x0, 0x2)
        channelNSetState(0x0, 0x2)
      }
    } else {
      return .error
    }

    ccxChannelCmd(0x0, 0x1)

    dma.writeCallback(
      .captureCompare1, id: .transferComplete, value: dma.callback(.captureComplete))
    dma.writeCallback(
      .captureCompare1, id: .halfTransfer, value: dma.callback(.captureHalfComplete))
    dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.error))

    if dmaStartInterrupt(
      .captureCompare1, registers.address(of: .ccr1),
      UInt32(truncatingIfNeeded: UInt(bitPattern: pData)), Length) != .ok
    {
      return .error
    }
    enableDMARequests(0x200)

    if ((((registers.instance)) == TIMInstance.tim1) || (((registers.instance)) == TIMInstance.tim2)
      || (((registers.instance)) == TIMInstance.tim3)
      || (((registers.instance)) == TIMInstance.tim4)
      || (((registers.instance)) == TIMInstance.tim5)
      || (((registers.instance)) == TIMInstance.tim9)
      || (((registers.instance)) == TIMInstance.tim12)
      || (((registers.instance)) == TIMInstance.tim15))
    {
      tmpsmcr = registers.read(.smcr) & 0x10007
      if !(((tmpsmcr) == 0x6) || ((tmpsmcr) == 0x10000)) {
        enable()
      }
    } else {
      enable()
    }

    return .ok

  }
  public func hallSensorStopDMA() -> HALStatus {

    ccxChannelCmd(0x0, 0x0)

    disableDMARequests(0x200)
    _ = dma.abortInterrupt(.captureCompare1)

    disable()

    channelSetState(0x0, 0x1)
    channelNSetState(0x0, 0x1)

    return .ok

  }
}
