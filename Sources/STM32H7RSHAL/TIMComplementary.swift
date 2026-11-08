// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func outputCompareNStart(_ Channel: UInt32) -> HALStatus {

    var tmpsmcr: UInt32

    if channelNState(Channel) != 0x1 {
      return .error
    }

    channelNSetState(Channel, 0x2)

    ccxNChannelCmd(Channel, 0x4)

    enableMainOutput()

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
  public func outputCompareNStop(_ Channel: UInt32) -> HALStatus {

    ccxNChannelCmd(Channel, 0x0)

    disableMainOutput()

    disable()

    channelNSetState(Channel, 0x1)

    return .ok

  }
  public func outputCompareNStartInterrupt(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var tmpsmcr: UInt32

    if channelNState(Channel) != 0x1 {
      return .error
    }

    channelNSetState(Channel, 0x2)
    switch Channel
    {
    case 0x0:
      do {
        enableInterrupts(0x2)
        break
      }
    case 0x4:
      do {
        enableInterrupts(0x4)
        break
      }
    case 0x8:
      do {
        enableInterrupts(0x8)
        break
      }
    case 0xc:
      do {
        enableInterrupts(0x10)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      enableInterrupts(0x80)

      ccxNChannelCmd(Channel, 0x4)

      enableMainOutput()

      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim2)
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
    }

    return status

  }
  public func outputCompareNStopInterrupt(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var tmpccer: UInt32

    switch Channel
    {
    case 0x0:
      do {
        disableInterrupts(0x2)
        break
      }
    case 0x4:
      do {
        disableInterrupts(0x4)
        break
      }
    case 0x8:
      do {
        disableInterrupts(0x8)
        break
      }
    case 0xc:
      do {
        disableInterrupts(0x10)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxNChannelCmd(Channel, 0x0)

      tmpccer = registers.read(.ccer)
      if (tmpccer & 0x4444) == (0) {
        disableInterrupts(0x80)
      }

      disableMainOutput()

      disable()

      channelNSetState(Channel, 0x1)
    }

    return status

  }
  public func outputCompareNStartDMA(
    _ Channel: UInt32, _ pData: UnsafePointer<UInt32>?, _ Length: UInt16
  ) -> HALStatus {
    let Length = UInt32(Length)

    var status: HALStatus = .ok
    var tmpsmcr: UInt32

    if channelNState(Channel) == 0x2 {
      return .busy
    } else if channelNState(Channel) == 0x1 {
      if (pData == nil) || (Length == 0) {
        return .error
      } else {
        channelNSetState(Channel, 0x2)
      }
    } else {
      return .error
    }
    switch Channel
    {
    case 0x0:
      do {
        dma.writeCallback(
          .captureCompare1, id: .transferComplete, value: dma.callback(.delayPulseNComplete))
        dma.writeCallback(
          .captureCompare1, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.errorCCxN))

        if dmaStartInterrupt(
          .captureCompare1, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr1), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x200)
        break
      }
    case 0x4:
      do {
        dma.writeCallback(
          .captureCompare2, id: .transferComplete, value: dma.callback(.delayPulseNComplete))
        dma.writeCallback(
          .captureCompare2, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare2, id: .error, value: dma.callback(.errorCCxN))

        if dmaStartInterrupt(
          .captureCompare2, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr2), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x400)
        break
      }
    case 0x8:
      do {
        dma.writeCallback(
          .captureCompare3, id: .transferComplete, value: dma.callback(.delayPulseNComplete))
        dma.writeCallback(
          .captureCompare3, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare3, id: .error, value: dma.callback(.errorCCxN))

        if dmaStartInterrupt(
          .captureCompare3, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr3), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x800)
        break
      }
    case 0xc:
      do {
        dma.writeCallback(
          .captureCompare4, id: .transferComplete, value: dma.callback(.delayPulseNComplete))
        dma.writeCallback(
          .captureCompare4, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare4, id: .error, value: dma.callback(.errorCCxN))

        if dmaStartInterrupt(
          .captureCompare4, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr4), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x1000)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxNChannelCmd(Channel, 0x4)

      enableMainOutput()

      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim2)
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
    }

    return status

  }
  public func outputCompareNStopDMA(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    switch Channel
    {
    case 0x0:
      do {
        disableDMARequests(0x200)
        _ = dma.abortInterrupt(.captureCompare1)
        break
      }
    case 0x4:
      do {
        disableDMARequests(0x400)
        _ = dma.abortInterrupt(.captureCompare2)
        break
      }
    case 0x8:
      do {
        disableDMARequests(0x800)
        _ = dma.abortInterrupt(.captureCompare3)
        break
      }
    case 0xc:
      do {
        disableDMARequests(0x1000)
        _ = dma.abortInterrupt(.captureCompare4)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxNChannelCmd(Channel, 0x0)

      disableMainOutput()

      disable()

      channelNSetState(Channel, 0x1)
    }

    return status

  }
  public func pwmNStart(_ Channel: UInt32) -> HALStatus {

    var tmpsmcr: UInt32

    if channelNState(Channel) != 0x1 {
      return .error
    }

    channelNSetState(Channel, 0x2)

    ccxNChannelCmd(Channel, 0x4)

    enableMainOutput()

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
  public func pwmNStop(_ Channel: UInt32) -> HALStatus {

    ccxNChannelCmd(Channel, 0x0)

    disableMainOutput()

    disable()

    channelNSetState(Channel, 0x1)

    return .ok

  }
  public func pwmNStartInterrupt(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var tmpsmcr: UInt32

    if channelNState(Channel) != 0x1 {
      return .error
    }

    channelNSetState(Channel, 0x2)
    switch Channel
    {
    case 0x0:
      do {
        enableInterrupts(0x2)
        break
      }
    case 0x4:
      do {
        enableInterrupts(0x4)
        break
      }
    case 0x8:
      do {
        enableInterrupts(0x8)
        break
      }
    case 0xc:
      do {
        enableInterrupts(0x10)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      enableInterrupts(0x80)

      ccxNChannelCmd(Channel, 0x4)

      enableMainOutput()

      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim2)
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
    }

    return status

  }
  public func pwmNStopInterrupt(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var tmpccer: UInt32

    switch Channel
    {
    case 0x0:
      do {
        disableInterrupts(0x2)
        break
      }
    case 0x4:
      do {
        disableInterrupts(0x4)
        break
      }
    case 0x8:
      do {
        disableInterrupts(0x8)
        break
      }
    case 0xc:
      do {
        disableInterrupts(0x10)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxNChannelCmd(Channel, 0x0)

      tmpccer = registers.read(.ccer)
      if (tmpccer & 0x4444) == (0) {
        disableInterrupts(0x80)
      }

      disableMainOutput()

      disable()

      channelNSetState(Channel, 0x1)
    }

    return status

  }
  public func pwmNStartDMA(_ Channel: UInt32, _ pData: UnsafePointer<UInt32>?, _ Length: UInt16)
    -> HALStatus
  {
    let Length = UInt32(Length)

    var status: HALStatus = .ok
    var tmpsmcr: UInt32

    if channelNState(Channel) == 0x2 {
      return .busy
    } else if channelNState(Channel) == 0x1 {
      if (pData == nil) || (Length == 0) {
        return .error
      } else {
        channelNSetState(Channel, 0x2)
      }
    } else {
      return .error
    }
    switch Channel
    {
    case 0x0:
      do {
        dma.writeCallback(
          .captureCompare1, id: .transferComplete, value: dma.callback(.delayPulseNComplete))
        dma.writeCallback(
          .captureCompare1, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.errorCCxN))

        if dmaStartInterrupt(
          .captureCompare1, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr1), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x200)
        break
      }
    case 0x4:
      do {
        dma.writeCallback(
          .captureCompare2, id: .transferComplete, value: dma.callback(.delayPulseNComplete))
        dma.writeCallback(
          .captureCompare2, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare2, id: .error, value: dma.callback(.errorCCxN))

        if dmaStartInterrupt(
          .captureCompare2, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr2), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x400)
        break
      }
    case 0x8:
      do {
        dma.writeCallback(
          .captureCompare3, id: .transferComplete, value: dma.callback(.delayPulseNComplete))
        dma.writeCallback(
          .captureCompare3, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare3, id: .error, value: dma.callback(.errorCCxN))

        if dmaStartInterrupt(
          .captureCompare3, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr3), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x800)
        break
      }
    case 0xc:
      do {
        dma.writeCallback(
          .captureCompare4, id: .transferComplete, value: dma.callback(.delayPulseNComplete))
        dma.writeCallback(
          .captureCompare4, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare4, id: .error, value: dma.callback(.errorCCxN))

        if dmaStartInterrupt(
          .captureCompare4, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr4), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x1000)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxNChannelCmd(Channel, 0x4)

      enableMainOutput()

      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim2)
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
    }

    return status

  }
  public func pwmNStopDMA(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    switch Channel
    {
    case 0x0:
      do {
        disableDMARequests(0x200)
        _ = dma.abortInterrupt(.captureCompare1)
        break
      }
    case 0x4:
      do {
        disableDMARequests(0x400)
        _ = dma.abortInterrupt(.captureCompare2)
        break
      }
    case 0x8:
      do {
        disableDMARequests(0x800)
        _ = dma.abortInterrupt(.captureCompare3)
        break
      }
    case 0xc:
      do {
        disableDMARequests(0x1000)
        _ = dma.abortInterrupt(.captureCompare4)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxNChannelCmd(Channel, 0x0)

      disableMainOutput()

      disable()

      channelNSetState(Channel, 0x1)
    }

    return status

  }
  public func onePulseNStart(_ OutputChannel: UInt32) -> HALStatus {

    var input_channel: UInt32 = (OutputChannel == 0x0) ? 0x4 : 0x0
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

    ccxNChannelCmd(OutputChannel, 0x4)
    ccxChannelCmd(input_channel, 0x1)

    enableMainOutput()

    return .ok

  }
  public func onePulseNStop(_ OutputChannel: UInt32) -> HALStatus {

    var input_channel: UInt32 = (OutputChannel == 0x0) ? 0x4 : 0x0

    ccxNChannelCmd(OutputChannel, 0x0)
    ccxChannelCmd(input_channel, 0x0)

    disableMainOutput()

    disable()

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    return .ok

  }
  public func onePulseNStartInterrupt(_ OutputChannel: UInt32) -> HALStatus {

    var input_channel: UInt32 = (OutputChannel == 0x0) ? 0x4 : 0x0
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

    enableInterrupts(0x4)

    ccxNChannelCmd(OutputChannel, 0x4)
    ccxChannelCmd(input_channel, 0x1)

    enableMainOutput()

    return .ok

  }
  public func onePulseNStopInterrupt(_ OutputChannel: UInt32) -> HALStatus {

    var input_channel: UInt32 = (OutputChannel == 0x0) ? 0x4 : 0x0

    disableInterrupts(0x2)

    disableInterrupts(0x4)

    ccxNChannelCmd(OutputChannel, 0x0)
    ccxChannelCmd(input_channel, 0x0)

    disableMainOutput()

    disable()

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    return .ok

  }
}
