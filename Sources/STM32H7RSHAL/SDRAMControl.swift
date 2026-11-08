// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDRAM {
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }

  public func interruptHandler() {

    if fmc.getSDRAMFlag(0x1) {
      if useRegisteredCallbacks {
        callbacks.read(.refreshError)!(callbacks.context)
      } else {
        defaults.refreshError(callbacks.context)
      }

      fmc.clearSDRAMFlag(0x1)
    }

  }
  public func enableWriteProtection() -> HALStatus {

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x2)

      _ = fmc.enableSDRAMWriteProtection(handle.read(.bank))

      handle.write(.state, value: 0x4)
    } else {
      return .error
    }
    return .ok

  }
  public func disableWriteProtection() -> HALStatus {
    var state: UInt32 = 0

    state = handle.read(.state)

    if state == 0x2 {
      return .busy
    } else if state == 0x4 {
      handle.write(.state, value: 0x2)

      _ = fmc.disableSDRAMWriteProtection(handle.read(.bank))

      handle.write(.state, value: 0x1)
    } else {
      return .error
    }
    return .ok

  }
  public func sendCommand(_ Command: UnsafeMutablePointer<FMCSDRAMCommand>?, _ Timeout: UInt32)
    -> HALStatus
  {
    var state: UInt32 = 0

    state = handle.read(.state)

    if state == 0x2 {
      return .busy
    } else if (state == 0x1) || (state == 0x5) {
      handle.write(.state, value: 0x2)

      _ = fmc.sendSDRAMCommand(Command, Timeout)

      if Command!.pointee.commandMode == 0x2 {
        handle.write(.state, value: 0x5)
      } else {
        handle.write(.state, value: 0x1)
      }
    } else {
      return .error
    }
    return .ok

  }
  public func programRefreshRate(_ RefreshRate: UInt32) -> HALStatus {

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x2)

      _ = fmc.programSDRAMRefreshRate(RefreshRate)

      handle.write(.state, value: 0x1)
    } else {
      return .error
    }
    return .ok

  }
  public func setAutoRefreshNumber(_ AutoRefreshNumber: UInt32) -> HALStatus {

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x2)

      _ = fmc.setSDRAMAutoRefreshNumber(AutoRefreshNumber)

      handle.write(.state, value: 0x1)
    } else {
      return .error
    }
    return .ok

  }
  public func getModeStatus() -> UInt32 {

    return (fmc.getSDRAMModeStatus(handle.read(.bank)))

  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
}
