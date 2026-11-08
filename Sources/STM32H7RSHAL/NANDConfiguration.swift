// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NAND operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension NAND {
  public func initialize(
    _ ComSpace_Timing: UnsafeMutablePointer<FMCNANDTiming>?,
    _ AttSpace_Timing: UnsafeMutablePointer<FMCNANDTiming>?
  ) -> HALStatus {

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
        callbacks.write(.interrupt, value: defaults.interrupt)

        callbacks.read(.mspInitialize)!(callbacks.context)
      } else {
        defaults.mspInitialize(callbacks.context)
      }
    }

    _ = withUnsafePointer(
      to: FMCNANDConfiguration(
        bank: handle.read(.bank), waitFeature: handle.read(.waitFeature),
        memoryDataWidth: handle.read(.memoryDataWidth),
        eccComputation: handle.read(.eccComputation), eccPageSize: handle.read(.eccPageSize),
        tclrSetupTime: handle.read(.tclrSetupTime), tarSetupTime: handle.read(.tarSetupTime))
    ) { configuration in fmc.initializeNAND(configuration) }

    _ = fmc.configureNANDCommonSpaceTiming(ComSpace_Timing, handle.read(.bank))

    _ = fmc.configureNANDAttributeSpaceTiming(AttSpace_Timing, handle.read(.bank))

    fmc.enableNAND()

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

    _ = fmc.deinitializeNAND(handle.read(.bank))

    handle.write(.state, value: 0x0)

    handle.write(.lock, value: 0)
    return .ok

  }
  public func configureDevice(_ pDeviceConfig: UnsafePointer<NANDDeviceConfiguration>?) -> HALStatus
  {

    handle.write(.pageSize, value: pDeviceConfig!.pointee.pageSize)
    handle.write(.spareAreaSize, value: pDeviceConfig!.pointee.spareAreaSize)
    handle.write(.blockSize, value: pDeviceConfig!.pointee.blockSize)
    handle.write(.blockCount, value: pDeviceConfig!.pointee.blockCount)
    handle.write(.planeSize, value: pDeviceConfig!.pointee.planeSize)
    handle.write(.planeCount, value: pDeviceConfig!.pointee.planeCount)
    handle.write(.extraCommandEnable, value: pDeviceConfig!.pointee.extraCommandEnable)
    return .ok

  }
  public func registerCallback(_ CallbackId: UInt32, _ pCallback: NANDCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }
    var status: HALStatus = .ok

    status = .ok
    if pCallback == nil {
      return .error
    }
    if handle.read(.state) == 0x1 {
      switch CallbackId
      {
      case 0x0:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x1:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      case 0x2:
        callbacks.write(.interrupt, value: pCallback)
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

    status = .ok
    if handle.read(.state) == 0x1 {
      switch CallbackId
      {
      case 0x0:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x1:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      case 0x2:
        callbacks.write(.interrupt, value: defaults.interrupt)
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
}
