// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDRAM {
  public func initialize(_ Timing: UnsafeMutablePointer<FMCSDRAMTiming>?) -> HALStatus {

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
        callbacks.write(.refreshError, value: defaults.refreshError)
        callbacks.write(.dmaComplete, value: defaults.dmaComplete)
        callbacks.write(.dmaError, value: defaults.dmaError)

        callbacks.read(.mspInitialize)!(callbacks.context)
      } else {
        defaults.mspInitialize(callbacks.context)
      }
    }

    handle.write(.state, value: 0x2)

    _ = withUnsafePointer(
      to: FMCSDRAMConfiguration(
        bank: handle.read(.bank), columnBitsNumber: handle.read(.columnBitsNumber),
        rowBitsNumber: handle.read(.rowBitsNumber), memoryDataWidth: handle.read(.memoryDataWidth),
        internalBankNumber: handle.read(.internalBankNumber), casLatency: handle.read(.casLatency),
        writeProtection: handle.read(.writeProtection), sdClockPeriod: handle.read(.sdClockPeriod),
        readBurst: handle.read(.readBurst), readPipeDelay: handle.read(.readPipeDelay))
    ) { configuration in fmc.initializeSDRAM(configuration) }

    _ = fmc.configureSDRAMTiming(Timing, handle.read(.bank))

    fmc.enable()

    handle.write(.state, value: 0x1)
    return .ok

  }
  public func deinitialize() -> HALStatus {

    if useRegisteredCallbacks {
      if callbacks.read(.mspDeinitialize) == nil {
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
      }

      callbacks.read(.mspDeinitialize)!(callbacks.context)
    } else {
      defaults.mspDeinitialize(callbacks.context)
    }

    _ = fmc.deinitializeSDRAM(handle.read(.bank))

    handle.write(.state, value: 0x0)

    handle.write(.lock, value: 0)
    return .ok

  }
  public func registerCallback(_ CallbackId: UInt32, _ pCallback: SDRAMCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }
    var status: HALStatus = .ok
    var state: UInt32 = 0

    status = .ok

    if pCallback == nil {
      return .error
    }
    state = handle.read(.state)
    if (state == 0x1) || (state == 0x4) {
      switch CallbackId
      {
      case 0x0:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x1:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      case 0x2:
        callbacks.write(.refreshError, value: pCallback)
        break
      default:
        status = .error
        break
      }
    } else if handle.read(.state) == 0x0 {
      switch CallbackId
      {
      case 0x0:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x1:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        status = .error
        break
      }
    } else {
      status = .error
    }
    return status

  }
  public func unregisterCallback(_ CallbackId: UInt32) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }
    var status: HALStatus = .ok
    var state: UInt32 = 0

    status = .ok

    state = handle.read(.state)
    if (state == 0x1) || (state == 0x4) {
      switch CallbackId
      {
      case 0x0:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x1:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      case 0x2:
        callbacks.write(.refreshError, value: defaults.refreshError)
        break
      case 0x3:
        callbacks.write(.dmaComplete, value: defaults.dmaComplete)
        break
      case 0x4:
        callbacks.write(.dmaError, value: defaults.dmaError)
        break
      default:
        status = .error
        break
      }
    } else if handle.read(.state) == 0x0 {
      switch CallbackId
      {
      case 0x0:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x1:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        status = .error
        break
      }
    } else {
      status = .error
    }
    return status

  }
  public func registerDMACallback(_ CallbackId: UInt32, _ pCallback: SDRAMCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }
    var status: HALStatus = .ok
    var state: UInt32 = 0

    status = .ok

    if pCallback == nil {
      return .error
    }

    if handle.read(.lock) == 1 { return .busy }
    handle.write(.lock, value: 1)
    state = handle.read(.state)
    if (state == 0x1) || (state == 0x4) {
      switch CallbackId
      {
      case 0x3:
        callbacks.write(.dmaComplete, value: pCallback)
        break
      case 0x4:
        callbacks.write(.dmaError, value: pCallback)
        break
      default:
        status = .error
        break
      }
    } else {
      status = .error
    }

    handle.write(.lock, value: 0)
    return status

  }
}
