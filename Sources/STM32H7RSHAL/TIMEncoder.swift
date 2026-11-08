// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func encoderInitialize(_ sConfig: TIMEncoderConfiguration) -> HALStatus {

    var tmpsmcr: UInt32
    var tmpccmr1: UInt32
    var tmpccer: UInt32

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        resetCallback()
        if callbacks.read(.encoderMspInitialize) == nil {
          callbacks.write(.encoderMspInitialize, value: defaults.encoderMspInitialize)
        }
        callbacks.read(.encoderMspInitialize)!(callbacks.context)
      } else {
        defaults.encoderMspInitialize(callbacks.context)
      }
    }

    handle.write(.state, value: 0x2)

    registers.write(.smcr, value: registers.read(.smcr) & (~(0x10007 | 0x4000)))

    baseSetConfig(handle.configuration())

    tmpsmcr = registers.read(.smcr)

    tmpccmr1 = registers.read(.ccmr1)

    tmpccer = registers.read(.ccer)

    tmpsmcr |= sConfig.encoderMode

    tmpccmr1 &= ~(0x3 | 0x300)
    tmpccmr1 |= (sConfig.inputCapture1Selection | (sConfig.inputCapture2Selection << 8))

    tmpccmr1 &= ~(0xc | 0xc00)
    tmpccmr1 &= ~(0xf0 | 0xf000)
    tmpccmr1 |= sConfig.inputCapture1Prescaler | (sConfig.inputCapture2Prescaler << 8)
    tmpccmr1 |= (sConfig.inputCapture1Filter << 4) | (sConfig.inputCapture2Filter << 12)

    tmpccer &= ~(0x2 | 0x20)
    tmpccer &= ~(0x8 | 0x80)
    tmpccer |= sConfig.inputCapture1Polarity | (sConfig.inputCapture2Polarity << 4)

    registers.write(.smcr, value: tmpsmcr)

    registers.write(.ccmr1, value: tmpccmr1)

    registers.write(.ccer, value: tmpccer)

    handle.write(.dmaBurstState, value: 0x1)

    channelSetState(0x0, 0x1)
    channelSetState(0x4, 0x1)
    channelNSetState(0x0, 0x1)
    channelNSetState(0x4, 0x1)

    handle.write(.state, value: 0x1)
    return .ok

  }
  public func encoderDeinitialize() -> HALStatus {

    handle.write(.state, value: 0x2)

    disable()
    if useRegisteredCallbacks {
      if callbacks.read(.encoderMspDeinitialize) == nil {
        callbacks.write(.encoderMspDeinitialize, value: defaults.encoderMspDeinitialize)
      }
      callbacks.read(.encoderMspDeinitialize)!(callbacks.context)
    } else {
      defaults.encoderMspDeinitialize(callbacks.context)
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
  public func encoderStart(_ Channel: UInt32) -> HALStatus {

    var channel_1_state: UInt32 = channelState(0x0)
    var channel_2_state: UInt32 = channelState(0x4)
    var complementary_channel_1_state: UInt32 = channelNState(0x0)
    var complementary_channel_2_state: UInt32 = channelNState(0x4)

    if Channel == 0x0 {
      if (channel_1_state != 0x1)
        || (complementary_channel_1_state != 0x1)
      {
        return .error
      } else {
        channelSetState(0x0, 0x2)
        channelNSetState(0x0, 0x2)
      }
    } else if Channel == 0x4 {
      if (channel_2_state != 0x1)
        || (complementary_channel_2_state != 0x1)
      {
        return .error
      } else {
        channelSetState(0x4, 0x2)
        channelNSetState(0x4, 0x2)
      }
    } else {
      if (channel_1_state != 0x1)
        || (channel_2_state != 0x1)
        || (complementary_channel_1_state != 0x1)
        || (complementary_channel_2_state != 0x1)
      {
        return .error
      } else {
        channelSetState(0x0, 0x2)
        channelSetState(0x4, 0x2)
        channelNSetState(0x0, 0x2)
        channelNSetState(0x4, 0x2)
      }
    }

    switch Channel
    {
    case 0x0:
      do {
        ccxChannelCmd(0x0, 0x1)
        break
      }
    case 0x4:
      do {
        ccxChannelCmd(0x4, 0x1)
        break
      }
    default:
      do {
        ccxChannelCmd(0x0, 0x1)
        ccxChannelCmd(0x4, 0x1)
        break
      }
    }
    enable()

    return .ok

  }
  public func encoderStop(_ Channel: UInt32) -> HALStatus {

    switch Channel
    {
    case 0x0:
      do {
        ccxChannelCmd(0x0, 0x0)
        break
      }
    case 0x4:
      do {
        ccxChannelCmd(0x4, 0x0)
        break
      }
    default:
      do {
        ccxChannelCmd(0x0, 0x0)
        ccxChannelCmd(0x4, 0x0)
        break
      }
    }

    disable()

    if (Channel == 0x0) || (Channel == 0x4) {
      channelSetState(Channel, 0x1)
      channelNSetState(Channel, 0x1)
    } else {
      channelSetState(0x0, 0x1)
      channelSetState(0x4, 0x1)
      channelNSetState(0x0, 0x1)
      channelNSetState(0x4, 0x1)
    }

    return .ok

  }
  public func encoderStartInterrupt(_ Channel: UInt32) -> HALStatus {

    var channel_1_state: UInt32 = channelState(0x0)
    var channel_2_state: UInt32 = channelState(0x4)
    var complementary_channel_1_state: UInt32 = channelNState(0x0)
    var complementary_channel_2_state: UInt32 = channelNState(0x4)

    if Channel == 0x0 {
      if (channel_1_state != 0x1)
        || (complementary_channel_1_state != 0x1)
      {
        return .error
      } else {
        channelSetState(0x0, 0x2)
        channelNSetState(0x0, 0x2)
      }
    } else if Channel == 0x4 {
      if (channel_2_state != 0x1)
        || (complementary_channel_2_state != 0x1)
      {
        return .error
      } else {
        channelSetState(0x4, 0x2)
        channelNSetState(0x4, 0x2)
      }
    } else {
      if (channel_1_state != 0x1)
        || (channel_2_state != 0x1)
        || (complementary_channel_1_state != 0x1)
        || (complementary_channel_2_state != 0x1)
      {
        return .error
      } else {
        channelSetState(0x0, 0x2)
        channelSetState(0x4, 0x2)
        channelNSetState(0x0, 0x2)
        channelNSetState(0x4, 0x2)
      }
    }

    switch Channel
    {
    case 0x0:
      do {
        ccxChannelCmd(0x0, 0x1)
        enableInterrupts(0x2)
        break
      }
    case 0x4:
      do {
        ccxChannelCmd(0x4, 0x1)
        enableInterrupts(0x4)
        break
      }
    default:
      do {
        ccxChannelCmd(0x0, 0x1)
        ccxChannelCmd(0x4, 0x1)
        enableInterrupts(0x2)
        enableInterrupts(0x4)
        break
      }
    }

    enable()

    return .ok

  }
  public func encoderStopInterrupt(_ Channel: UInt32) -> HALStatus {

    if Channel == 0x0 {
      ccxChannelCmd(0x0, 0x0)

      disableInterrupts(0x2)
    } else if Channel == 0x4 {
      ccxChannelCmd(0x4, 0x0)

      disableInterrupts(0x4)
    } else {
      ccxChannelCmd(0x0, 0x0)
      ccxChannelCmd(0x4, 0x0)

      disableInterrupts(0x2)
      disableInterrupts(0x4)
    }

    disable()

    if (Channel == 0x0) || (Channel == 0x4) {
      channelSetState(Channel, 0x1)
      channelNSetState(Channel, 0x1)
    } else {
      channelSetState(0x0, 0x1)
      channelSetState(0x4, 0x1)
      channelNSetState(0x0, 0x1)
      channelNSetState(0x4, 0x1)
    }

    return .ok

  }
  public func encoderStartDMA(
    _ Channel: UInt32, _ pData1: UnsafeMutablePointer<UInt32>?,
    _ pData2: UnsafeMutablePointer<UInt32>?, _ Length: UInt16
  ) -> HALStatus {
    let Length = UInt32(Length)

    var channel_1_state: UInt32 = channelState(0x0)
    var channel_2_state: UInt32 = channelState(0x4)
    var complementary_channel_1_state: UInt32 = channelNState(0x0)
    var complementary_channel_2_state: UInt32 = channelNState(0x4)

    if Channel == 0x0 {
      if (channel_1_state == 0x2)
        || (complementary_channel_1_state == 0x2)
      {
        return .busy
      } else if (channel_1_state == 0x1)
        && (complementary_channel_1_state == 0x1)
      {
        if (pData1 == nil) || (Length == 0) {
          return .error
        } else {
          channelSetState(0x0, 0x2)
          channelNSetState(0x0, 0x2)
        }
      } else {
        return .error
      }
    } else if Channel == 0x4 {
      if (channel_2_state == 0x2)
        || (complementary_channel_2_state == 0x2)
      {
        return .busy
      } else if (channel_2_state == 0x1)
        && (complementary_channel_2_state == 0x1)
      {
        if (pData2 == nil) || (Length == 0) {
          return .error
        } else {
          channelSetState(0x4, 0x2)
          channelNSetState(0x4, 0x2)
        }
      } else {
        return .error
      }
    } else {
      if (channel_1_state == 0x2)
        || (channel_2_state == 0x2)
        || (complementary_channel_1_state == 0x2)
        || (complementary_channel_2_state == 0x2)
      {
        return .busy
      } else if (channel_1_state == 0x1)
        && (channel_2_state == 0x1)
        && (complementary_channel_1_state == 0x1)
        && (complementary_channel_2_state == 0x1)
      {
        if (((pData1 == nil) || (pData2 == nil))) || (Length == 0) {
          return .error
        } else {
          channelSetState(0x0, 0x2)
          channelSetState(0x4, 0x2)
          channelNSetState(0x0, 0x2)
          channelNSetState(0x4, 0x2)
        }
      } else {
        return .error
      }
    }
    switch Channel
    {
    case 0x0:
      do {
        dma.writeCallback(
          .captureCompare1, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare1, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare1, registers.address(of: .ccr1),
          UInt32(truncatingIfNeeded: UInt(bitPattern: pData1)), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x200)

        ccxChannelCmd(0x0, 0x1)

        enable()
        break
      }
    case 0x4:
      do {
        dma.writeCallback(
          .captureCompare2, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare2, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare2, id: .error, value: dma.callback(.error))
        if dmaStartInterrupt(
          .captureCompare2, registers.address(of: .ccr2),
          UInt32(truncatingIfNeeded: UInt(bitPattern: pData2)), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x400)

        ccxChannelCmd(0x4, 0x1)

        enable()
        break
      }
    default:
      do {
        dma.writeCallback(
          .captureCompare1, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare1, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare1, registers.address(of: .ccr1),
          UInt32(truncatingIfNeeded: UInt(bitPattern: pData1)), Length) != .ok
        {
          return .error
        }

        dma.writeCallback(
          .captureCompare2, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare2, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare2, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare2, registers.address(of: .ccr2),
          UInt32(truncatingIfNeeded: UInt(bitPattern: pData2)), Length) != .ok
        {
          return .error
        }

        enableDMARequests(0x200)
        enableDMARequests(0x400)

        ccxChannelCmd(0x0, 0x1)
        ccxChannelCmd(0x4, 0x1)

        enable()
        break
      }
    }

    return .ok

  }
  public func encoderStopDMA(_ Channel: UInt32) -> HALStatus {

    if Channel == 0x0 {
      ccxChannelCmd(0x0, 0x0)

      disableDMARequests(0x200)
      _ = dma.abortInterrupt(.captureCompare1)
    } else if Channel == 0x4 {
      ccxChannelCmd(0x4, 0x0)

      disableDMARequests(0x400)
      _ = dma.abortInterrupt(.captureCompare2)
    } else {
      ccxChannelCmd(0x0, 0x0)
      ccxChannelCmd(0x4, 0x0)

      disableDMARequests(0x200)
      disableDMARequests(0x400)
      _ = dma.abortInterrupt(.captureCompare1)
      _ = dma.abortInterrupt(.captureCompare2)
    }

    disable()

    if (Channel == 0x0) || (Channel == 0x4) {
      channelSetState(Channel, 0x1)
      channelNSetState(Channel, 0x1)
    } else {
      channelSetState(0x0, 0x1)
      channelSetState(0x4, 0x1)
      channelNSetState(0x0, 0x1)
      channelNSetState(0x4, 0x1)
    }

    return .ok

  }
}
