// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func baseInitialize() -> HALStatus {

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        resetCallback()
        if callbacks.read(.baseMspInitialize) == nil {
          callbacks.write(.baseMspInitialize, value: defaults.baseMspInitialize)
        }
        callbacks.read(.baseMspInitialize)!(callbacks.context)
      } else {
        defaults.baseMspInitialize(callbacks.context)
      }
    }

    handle.write(.state, value: 0x2)

    baseSetConfig(handle.configuration())

    handle.write(.dmaBurstState, value: 0x1)

    channelSetAllStates(0x1)
    channelNSetAllStates(0x1)

    handle.write(.state, value: 0x1)
    return .ok

  }
  public func baseDeinitialize() -> HALStatus {

    handle.write(.state, value: 0x2)

    disable()
    if useRegisteredCallbacks {
      if callbacks.read(.baseMspDeinitialize) == nil {
        callbacks.write(.baseMspDeinitialize, value: defaults.baseMspDeinitialize)
      }
      callbacks.read(.baseMspDeinitialize)!(callbacks.context)
    } else {
      defaults.baseMspDeinitialize(callbacks.context)
    }

    handle.write(.dmaBurstState, value: 0x0)

    channelSetAllStates(0x0)
    channelNSetAllStates(0x0)

    handle.write(.state, value: 0x0)

    unlock()
    return .ok

  }
  public func baseStart() -> HALStatus {

    var tmpsmcr: UInt32

    if handle.read(.state) != 0x1 {
      return .error
    }

    handle.write(.state, value: 0x2)

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
  public func baseStop() -> HALStatus {

    disable()

    handle.write(.state, value: 0x1)

    return .ok

  }
  public func baseStartInterrupt() -> HALStatus {

    var tmpsmcr: UInt32

    if handle.read(.state) != 0x1 {
      return .error
    }

    handle.write(.state, value: 0x2)

    enableInterrupts(0x1)

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
  public func baseStopInterrupt() -> HALStatus {

    disableInterrupts(0x1)

    disable()

    handle.write(.state, value: 0x1)

    return .ok

  }
  public func baseStartDMA(_ pData: UnsafePointer<UInt32>?, _ Length: UInt16) -> HALStatus {
    let Length = UInt32(Length)

    var tmpsmcr: UInt32

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if (pData == nil) || (Length == 0) {
        return .error
      } else {
        handle.write(.state, value: 0x2)
      }
    } else {
      return .error
    }

    dma.writeCallback(.update, id: .transferComplete, value: dma.callback(.periodElapsedComplete))
    dma.writeCallback(.update, id: .halfTransfer, value: dma.callback(.periodElapsedHalfComplete))

    dma.writeCallback(.update, id: .error, value: dma.callback(.error))

    if dmaStartInterrupt(
      .update, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)), registers.address(of: .arr),
      Length) != .ok
    {
      return .error
    }

    enableDMARequests(0x100)

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
  public func baseStopDMA() -> HALStatus {

    disableDMARequests(0x100)
    _ = dma.abortInterrupt(.update)

    disable()

    handle.write(.state, value: 0x1)

    return .ok

  }
}
