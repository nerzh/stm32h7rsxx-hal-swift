// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SRAM {
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }

  public func enableWrite() -> HALStatus {

    if handle.read(.state) == 0x4 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      _ = fmc.enableNORSRAMWrite(handle.read(.bank))

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func disableWrite() -> HALStatus {

    if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      _ = fmc.disableNORSRAMWrite(handle.read(.bank))

      handle.write(.state, value: 0x4)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
}
