// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func baseGetState() -> UInt32 {

    return handle.read(.state)

  }
  public func outputCompareGetState() -> UInt32 {

    return handle.read(.state)

  }
  public func pwmGetState() -> UInt32 {

    return handle.read(.state)

  }
  public func inputCaptureGetState() -> UInt32 {

    return handle.read(.state)

  }
  public func onePulseGetState() -> UInt32 {

    return handle.read(.state)

  }
  public func encoderGetState() -> UInt32 {

    return handle.read(.state)

  }
  public func getActiveChannel() -> UInt32 {

    return handle.read(.channel)

  }
  public func getChannelState(_ Channel: UInt32) -> UInt32 {

    var channel_state: UInt32

    channel_state = channelState(Channel)
    return channel_state

  }
  public func dmaBurstState() -> UInt32 {

    return handle.read(.dmaBurstState)

  }
  public func hallSensorGetState() -> UInt32 {

    return handle.read(.state)

  }
  public func getChannelNState(_ ChannelN: UInt32) -> UInt32 {

    var channel_state: UInt32

    channel_state = channelNState(ChannelN)
    return channel_state

  }
}
