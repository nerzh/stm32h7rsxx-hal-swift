// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func onePulseInitialize(_ OnePulseMode: UInt32) -> HALStatus {

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        resetCallback()
        if callbacks.read(.onePulseMspInitialize) == nil {
          callbacks.write(.onePulseMspInitialize, value: defaults.onePulseMspInitialize)
        }
        callbacks.read(.onePulseMspInitialize)!(callbacks.context)
      } else {
        defaults.onePulseMspInitialize(callbacks.context)
      }
    }

    handle.write(.state, value: 0x2)

    baseSetConfig(handle.configuration())

    registers.write(.cr1, value: registers.read(.cr1) & (~0x8))

    registers.write(.cr1, value: registers.read(.cr1) | (OnePulseMode))

    handle.write(.dmaBurstState, value: 0x1)

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    handle.write(.state, value: 0x1)
    return .ok

  }
  public func onePulseDeinitialize() -> HALStatus {

    handle.write(.state, value: 0x2)

    disable()
    if useRegisteredCallbacks {
      if callbacks.read(.onePulseMspDeinitialize) == nil {
        callbacks.write(.onePulseMspDeinitialize, value: defaults.onePulseMspDeinitialize)
      }
      callbacks.read(.onePulseMspDeinitialize)!(callbacks.context)
    } else {
      defaults.onePulseMspDeinitialize(callbacks.context)
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
  public func onePulseStart(_ OutputChannel: UInt32) -> HALStatus {

    var channel_1_state: UInt32 = channelState(0x0)
    var channel_2_state: UInt32 = channelState(0x4)
    var complementary_channel_1_state: UInt32 = channelNState(0x0)
    var complementary_channel_2_state: UInt32 = channelNState(0x4)

    _ = OutputChannel

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
    ccxChannelCmd(0x4, 0x1)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      enableMainOutput()
    }

    return .ok

  }
  public func onePulseStop(_ OutputChannel: UInt32) -> HALStatus {

    _ = OutputChannel

    ccxChannelCmd(0x0, 0x0)
    ccxChannelCmd(0x4, 0x0)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      disableMainOutput()
    }

    disable()

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    return .ok

  }
  public func onePulseStartInterrupt(_ OutputChannel: UInt32) -> HALStatus {

    var channel_1_state: UInt32 = channelState(0x0)
    var channel_2_state: UInt32 = channelState(0x4)
    var complementary_channel_1_state: UInt32 = channelNState(0x0)
    var complementary_channel_2_state: UInt32 = channelNState(0x4)

    _ = OutputChannel

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

    enableInterrupts(0x4)
    ccxChannelCmd(0x0, 0x1)
    ccxChannelCmd(0x4, 0x1)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      enableMainOutput()
    }

    return .ok

  }
  public func onePulseStopInterrupt(_ OutputChannel: UInt32) -> HALStatus {

    _ = OutputChannel

    disableInterrupts(0x2)

    disableInterrupts(0x4)

    ccxChannelCmd(0x0, 0x0)
    ccxChannelCmd(0x4, 0x0)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      disableMainOutput()
    }

    disable()

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    return .ok

  }
}
