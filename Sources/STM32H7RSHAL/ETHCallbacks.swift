// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  public func registerCallback(id: UInt32, callback: ETHCallback?) -> HALStatus {
    guard let callback else {
      addError(0x20)
      return .error
    }
    if handle.read(.state) == 0x10 {
      guard let id = ETHCallbackID(rawValue: id) else {
        addError(0x20)
        return .error
      }
      callbacks.write(id, value: callback)
    } else if handle.read(.state) == 0x0 {
      if id == ETHCallbackID.mspInitialize.rawValue {
        callbacks.write(.mspInitialize, value: callback)
      } else if id == ETHCallbackID.mspDeinitialize.rawValue {
        callbacks.write(.mspDeinitialize, value: callback)
      } else {
        addError(0x20)
        return .error
      }
    } else {
      addError(0x20)
      return .error
    }
    return .ok
  }
  public func unregisterCallback(id: UInt32) -> HALStatus {
    if handle.read(.state) == 0x10 {
      guard let id = ETHCallbackID(rawValue: id) else {
        addError(0x20)
        return .error
      }
      callbacks.write(id, value: defaults.callback(id))
    } else if handle.read(.state) == 0x0 {
      if id == ETHCallbackID.mspInitialize.rawValue {
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
      } else if id == ETHCallbackID.mspDeinitialize.rawValue {
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
      } else {
        addError(0x20)
        return .error
      }
    } else {
      addError(0x20)
      return .error
    }
    return .ok
  }
  public func registerReceiveAllocateCallback(_ callback: ETHReceiveAllocateCallback?) -> HALStatus
  {
    guard let callback else { return .error }
    callbacks.writeReceiveAllocate(callback)
    return .ok
  }
  public func unregisterReceiveAllocateCallback() -> HALStatus {
    callbacks.writeReceiveAllocate(defaults.receiveAllocate)
    return .ok
  }
  public func registerReceiveLinkCallback(_ callback: ETHReceiveLinkCallback?) -> HALStatus {
    guard let callback else { return .error }
    callbacks.writeReceiveLink(callback)
    return .ok
  }
  public func unregisterReceiveLinkCallback() -> HALStatus {
    callbacks.writeReceiveLink(defaults.receiveLink)
    return .ok
  }
  public func registerTransmitFreeCallback(_ callback: ETHTransmitFreeCallback?) -> HALStatus {
    guard let callback else { return .error }
    callbacks.writeTransmitFree(callback)
    return .ok
  }
  public func unregisterTransmitFreeCallback() -> HALStatus {
    callbacks.writeTransmitFree(defaults.transmitFree)
    return .ok
  }
  public func registerTransmitPTPCallback(_ callback: ETHTransmitPTPCallback?) -> HALStatus {
    guard let callback else { return .error }
    callbacks.writeTransmitPTP(callback)
    return .ok
  }
  public func unregisterTransmitPTPCallback() -> HALStatus {
    callbacks.writeTransmitPTP(defaults.transmitPTP)
    return .ok
  }
  func initializeCallbacksToDefault() {
    callbacks.write(.transmitComplete, value: defaults.transmitComplete)
    callbacks.write(.receiveComplete, value: defaults.receiveComplete)
    callbacks.write(.error, value: defaults.error)
    callbacks.write(.powerManagement, value: defaults.powerManagement)
    callbacks.write(.energyEfficientEthernet, value: defaults.energyEfficientEthernet)
    callbacks.write(.wakeUp, value: defaults.wakeUp)
    callbacks.writeReceiveLink(defaults.receiveLink)
    callbacks.writeTransmitFree(defaults.transmitFree)
    if usePTP { callbacks.writeTransmitPTP(defaults.transmitPTP) }
    callbacks.writeReceiveAllocate(defaults.receiveAllocate)
  }
  public func deinitialize() -> HALStatus {
    handle.write(.state, value: 0x20)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invoke(.mspDeinitialize)
    handle.write(.state, value: 0x0)
    return .ok
  }
  public func irqHandler<EXTI: EXTIRegisterIO>(exti: inout EXTI) {
    let macFlags = registers.read(.macisr)
    let dmaFlags = registers.read(.dmacsr)
    let dmaInterrupts = registers.read(.dmacier)
    let extiFlags = exti.read(.pending(bank: 1))
    if dmaFlags & 0x40 != 0 && dmaInterrupts & 0x40 != 0 {
      clearDMAInterrupt(0x40 | 0x8000)
      invoke(.receiveComplete)
    }
    if dmaFlags & 0x1 != 0 && dmaInterrupts & 0x1 != 0 {
      clearDMAInterrupt(0x1 | 0x8000)
      invoke(.transmitComplete)
    }
    if dmaFlags & 0x4000 != 0 && dmaInterrupts & 0x4000 != 0 {
      addError(0x8)
      if dmaFlags & 0x1000 != 0 {
        handle.write(.dmaErrorCode, value: registers.read(.dmacsr) & (0x1000 | 0x2 | 0x100))
        disableDMAInterrupts(0x8000 | 0x4000)
        handle.write(.state, value: 0xe0)
      } else {
        handle.write(
          .dmaErrorCode, value: registers.read(.dmacsr) & (0x2000 | 0x400 | 0x200 | 0x80 | 0x4000))
        clearDMAInterrupt(0x2000 | 0x400 | 0x200 | 0x80 | 0x4000)
      }
      invoke(.error)
    }
    if macFlags & 0x4000 == 0x4000 || macFlags & 0x2000 == 0x2000 {
      addError(0x10)
      handle.write(.macErrorCode, value: registers.read(.macrxtxsr))
      handle.write(.state, value: 0xe0)
      invoke(.error)
      handle.write(.macErrorCode, value: 0)
    }
    if macFlags & 0x10 != 0 {
      handle.write(.macWakeUpEvent, value: registers.read(.macpcsr) & (0x40 | 0x20))
      invoke(.powerManagement)
      handle.write(.macWakeUpEvent, value: 0)
    }
    if macFlags & 0x20 != 0 {
      handle.write(.macLPIEvent, value: registers.read(.maclcsr) & 0xF)
      invoke(.energyEfficientEthernet)
      handle.write(.macLPIEvent, value: 0)
    }
    if extiFlags & 0x4000 != 0 {
      exti.write(.pending(bank: 1), value: 0x4000)
      invoke(.wakeUp)
    }
  }
}
