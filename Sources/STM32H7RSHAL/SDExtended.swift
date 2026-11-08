// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SD {
  public func readBlocksLinkedList(
    _ pLinkedList: UInt32, _ BlockAdd: UInt32, _ NumberOfBlocks: UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var DmaBase0_reg: UInt32 = 0
    var DmaBase1_reg: UInt32 = 0
    var add: UInt32 = 0

    add = BlockAdd
    if handle.read(.state) == 0x1 {
      if (add &+ NumberOfBlocks) > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }
      registers.write(
        .idmabaser,
        value: UInt32(truncatingIfNeeded: memory.read32(at: memory.read32(at: pLinkedList) &+ 4)))
      registers.write(
        .idmabsize,
        value: UInt32(truncatingIfNeeded: memory.read32(at: memory.read32(at: pLinkedList) &+ 8)))
      registers.write(.idmabar, value: UInt32(truncatingIfNeeded: memory.read32(at: pLinkedList)))
      registers.write(
        .idmalar, value: UInt32(truncatingIfNeeded: 0x2000_0000) | 0x4000_0000 | 0x8000_0000 | 12)
      DmaBase0_reg = registers.read(.idmabaser)
      DmaBase1_reg = registers.read(.idmabar)
      if (registers.read(.idmabsize) == 0) || (DmaBase0_reg == 0) || (DmaBase1_reg == 0) {
        handle.write(.errorCode, value: 0x2000000)
        return .error
      }

      registers.write(.dctrl, value: 0)

      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x3)
      if handle.read(.cardType) != 0x1 {
        add = add &* (512)
      }

      config.dataTimeout = 0xffff_ffff
      config.dataLength = 0x200 &* NumberOfBlocks
      config.dataBlockSize = 0x90
      config.transferDirection = 0x2
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      registers.write(.dctrl, value: registers.read(.dctrl) | (0x2000))
      sdmmc.enableCommandTransfer()
      registers.write(.idmactrl, value: 0x3)

      handle.write(.transferContext, value: (0x2 | 0x80))

      errorstate = sdmmc.commandReadMultipleBlocks(add, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        handle.write(.state, value: 0x1)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        return .error
      }
      sdmmc.enableInterrupts((0x2 | 0x8 | 0x20 | 0x100 | 0x1000_0000))
      return .ok
    } else {
      return .busy
    }

  }
  public func writeBlocksLinkedList(
    _ pLinkedList: UInt32, _ BlockAdd: UInt32, _ NumberOfBlocks: UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var DmaBase0_reg: UInt32 = 0
    var DmaBase1_reg: UInt32 = 0
    var add: UInt32 = 0

    add = BlockAdd
    if handle.read(.state) == 0x1 {
      if (add &+ NumberOfBlocks) > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }
      registers.write(
        .idmabaser,
        value: UInt32(truncatingIfNeeded: memory.read32(at: memory.read32(at: pLinkedList) &+ 4)))
      registers.write(
        .idmabsize,
        value: UInt32(truncatingIfNeeded: memory.read32(at: memory.read32(at: pLinkedList) &+ 8)))
      registers.write(.idmabar, value: UInt32(truncatingIfNeeded: memory.read32(at: pLinkedList)))
      registers.write(
        .idmalar, value: UInt32(truncatingIfNeeded: 0x2000_0000) | 0x4000_0000 | 0x8000_0000 | 12)
      DmaBase0_reg = registers.read(.idmabaser)
      DmaBase1_reg = registers.read(.idmabar)
      if (registers.read(.idmabsize) == 0) || (DmaBase0_reg == 0) || (DmaBase1_reg == 0) {
        handle.write(.errorCode, value: 0x2000000)
        return .error
      }

      registers.write(.dctrl, value: 0)
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x3)
      if handle.read(.cardType) != 0x1 {
        add = add &* (512)
      }

      config.dataTimeout = 0xffff_ffff
      config.dataLength = 0x200 &* NumberOfBlocks
      config.dataBlockSize = 0x90
      config.transferDirection = 0x0
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()
      registers.write(.idmactrl, value: 0x3)

      handle.write(.transferContext, value: (0x20 | 0x80))

      errorstate = sdmmc.commandWriteMultipleBlocks(add, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        handle.write(.state, value: 0x1)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        return .error
      }
      sdmmc.enableInterrupts((0x2 | 0x8 | 0x10 | 0x100 | 0x1000_0000))
      return .ok
    } else {
      return .busy
    }

  }
}
