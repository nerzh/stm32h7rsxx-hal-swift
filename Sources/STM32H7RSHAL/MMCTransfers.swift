// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MMC {
  public func readBlocks(
    _ pData: UnsafeMutablePointer<UInt8>?, _ BlockAdd: UInt32, _ NumberOfBlocks: UInt32,
    _ Timeout: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0
    var count: UInt32 = 0
    var data: UInt32 = 0
    var dataremaining: UInt32 = 0
    var add: UInt32 = 0
    var tempbuff: UnsafeMutablePointer<UInt8>? = nil

    tickstart = getTick()

    add = BlockAdd
    tempbuff = pData
    if nil == pData {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      if (BlockAdd &+ NumberOfBlocks) > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }

      if ((handle.extendedCSDPointer()[Int((0x3d / 4))] >> 0x8)
        & 0x0000_00FF) != 0x0
      {
        if (NumberOfBlocks % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
          return .error
        }
        if (BlockAdd % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          return .error
        }
      }
      handle.write(.state, value: 0x3)

      registers.write(.dctrl, value: 0)
      if (handle.read(.cardType)) != 0x1 {
        add = add &* (0x200)
      }

      config.dataTimeout = 0xffff_ffff
      config.dataLength = NumberOfBlocks &* 0x200
      config.dataBlockSize = 0x90
      config.transferDirection = 0x2
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      if NumberOfBlocks > 1 {
        handle.write(.transferContext, value: 0x2)

        errorstate = sdmmc.commandReadMultipleBlocks(add, getSystemCoreClock: getSystemCoreClock)
      } else {
        handle.write(.transferContext, value: 0x1)

        errorstate = sdmmc.commandReadSingleBlock(add, getSystemCoreClock: getSystemCoreClock)
      }
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }

      dataremaining = config.dataLength
      while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
        if sdmmc.getFlag(0x8000) && (dataremaining >= 0x20) {
          count = 0
          while count < (0x20 / 4) {
            data = sdmmc.readFIFO()
            tempbuff!.pointee = UInt8(
              truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (data & 0xFF))))
            tempbuff = tempbuff!.advanced(by: Int(1))
            tempbuff!.pointee = UInt8(
              truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 8) & 0xFF))))
            tempbuff = tempbuff!.advanced(by: Int(1))
            tempbuff!.pointee = UInt8(
              truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 16) & 0xFF))))
            tempbuff = tempbuff!.advanced(by: Int(1))
            tempbuff!.pointee = UInt8(
              truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 24) & 0xFF))))
            tempbuff = tempbuff!.advanced(by: Int(1))
            count = count &+ (1)
          }
          dataremaining = dataremaining &- (0x20)
        }
        if ((getTick() &- tickstart) >= Timeout) || (Timeout == 0) {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000_0000))
          handle.write(.state, value: 0x1)
          return .timeout
        }
      }
      sdmmc.disableCommandTransfer()

      if sdmmc.getFlag(0x100) && (NumberOfBlocks > 1) {
        errorstate = sdmmc.commandStopTransfer(getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          handle.write(.state, value: 0x1)
          return .error
        }
      }

      if sdmmc.getFlag(0x8) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
        handle.write(.state, value: 0x1)
        return .error
      } else if sdmmc.getFlag(0x2) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
        handle.write(.state, value: 0x1)
        return .error
      } else if sdmmc.getFlag(0x20) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        handle.write(.state, value: 0x1)
        return .error
      } else {
      }

      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.state, value: 0x1)
      return .ok
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000_0000))
      return .error
    }

  }
  public func writeBlocks(
    _ pData: UnsafePointer<UInt8>?, _ BlockAdd: UInt32, _ NumberOfBlocks: UInt32, _ Timeout: UInt32,
    getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0
    var count: UInt32 = 0
    var data: UInt32 = 0
    var dataremaining: UInt32 = 0
    var add: UInt32 = 0
    var tempbuff: UnsafePointer<UInt8>? = nil

    tickstart = getTick()

    add = BlockAdd
    tempbuff = pData
    if nil == pData {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      if (BlockAdd &+ NumberOfBlocks) > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }

      if ((handle.extendedCSDPointer()[Int((0x3d / 4))] >> 0x8) & 0x0000_00FF) != 0x0 {
        if (NumberOfBlocks % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
          return .error
        }
        if (BlockAdd % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          return .error
        }
      }
      handle.write(.state, value: 0x3)

      registers.write(.dctrl, value: 0)
      if (handle.read(.cardType)) != 0x1 {
        add = add &* (0x200)
      }

      config.dataTimeout = 0xffff_ffff
      config.dataLength = NumberOfBlocks &* 0x200
      config.dataBlockSize = 0x90
      config.transferDirection = 0x0
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      if NumberOfBlocks > 1 {
        handle.write(.transferContext, value: 0x20)

        errorstate = sdmmc.commandWriteMultipleBlocks(add, getSystemCoreClock: getSystemCoreClock)
      } else {
        handle.write(.transferContext, value: 0x10)

        errorstate = sdmmc.commandWriteSingleBlock(add, getSystemCoreClock: getSystemCoreClock)
      }
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }

      dataremaining = config.dataLength
      while !sdmmc.getFlag(0x10 | 0x2 | 0x8 | 0x100) {
        if sdmmc.getFlag(0x4000) && (dataremaining >= 0x20) {
          count = 0
          while count < (0x20 / 4) {
            data = UInt32(truncatingIfNeeded: (UInt32(tempbuff!.pointee)))
            tempbuff = tempbuff!.advanced(by: Int(1))
            data = data | ((UInt32(truncatingIfNeeded: (UInt32(tempbuff!.pointee))) << 8))
            tempbuff = tempbuff!.advanced(by: Int(1))
            data = data | ((UInt32(truncatingIfNeeded: (UInt32(tempbuff!.pointee))) << 16))
            tempbuff = tempbuff!.advanced(by: Int(1))
            data = data | ((UInt32(truncatingIfNeeded: (UInt32(tempbuff!.pointee))) << 24))
            tempbuff = tempbuff!.advanced(by: Int(1))
            _ = sdmmc.writeFIFO(&data)
            count = count &+ (1)
          }
          dataremaining = dataremaining &- (0x20)
        }
        if ((getTick() &- tickstart) >= Timeout) || (Timeout == 0) {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          handle.write(.state, value: 0x1)
          return .timeout
        }
      }
      sdmmc.disableCommandTransfer()

      if sdmmc.getFlag(0x100) && (NumberOfBlocks > 1) {
        errorstate = sdmmc.commandStopTransfer(getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          handle.write(.state, value: 0x1)
          return .error
        }
      }

      if sdmmc.getFlag(0x8) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
        handle.write(.state, value: 0x1)
        return .error
      } else if sdmmc.getFlag(0x2) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
        handle.write(.state, value: 0x1)
        return .error
      } else if sdmmc.getFlag(0x10) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
        handle.write(.state, value: 0x1)
        return .error
      } else {
      }

      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.state, value: 0x1)
      return .ok
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000_0000))
      return .error
    }

  }
  public func readBlocksInterrupt(
    _ pData: UnsafeMutablePointer<UInt8>?, _ BlockAdd: UInt32, _ NumberOfBlocks: UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var add: UInt32 = 0

    add = BlockAdd
    if nil == pData {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      if (BlockAdd &+ NumberOfBlocks) > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }

      if ((handle.extendedCSDPointer()[Int((0x3d / 4))] >> 0x8) & 0x0000_00FF) != 0x0 {
        if (NumberOfBlocks % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
          return .error
        }
        if (BlockAdd % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          return .error
        }
      }
      handle.write(.state, value: 0x3)

      registers.write(.dctrl, value: 0)
      handle.writeReceiveBuffer(pData)
      handle.write(.receiveSize, value: 0x200 &* NumberOfBlocks)
      if (handle.read(.cardType)) != 0x1 {
        add = add &* (0x200)
      }

      config.dataTimeout = 0xffff_ffff
      config.dataLength = 0x200 &* NumberOfBlocks
      config.dataBlockSize = 0x90
      config.transferDirection = 0x2
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      if NumberOfBlocks > 1 {
        handle.write(.transferContext, value: (0x2 | 0x8))

        errorstate = sdmmc.commandReadMultipleBlocks(add, getSystemCoreClock: getSystemCoreClock)
      } else {
        handle.write(.transferContext, value: (0x1 | 0x8))

        errorstate = sdmmc.commandReadSingleBlock(add, getSystemCoreClock: getSystemCoreClock)
      }
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }
      sdmmc.enableInterrupts((0x2 | 0x8 | 0x20 | 0x100 | 0x8000))
      return .ok
    } else {
      return .busy
    }

  }
  public func writeBlocksInterrupt(
    _ pData: UnsafePointer<UInt8>?, _ BlockAdd: UInt32, _ NumberOfBlocks: UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var add: UInt32 = 0

    add = BlockAdd
    if nil == pData {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      if (BlockAdd &+ NumberOfBlocks) > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }

      if ((handle.extendedCSDPointer()[Int((0x3d / 4))] >> 0x8) & 0x0000_00FF) != 0x0 {
        if (NumberOfBlocks % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
          return .error
        }
        if (BlockAdd % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          return .error
        }
      }
      handle.write(.state, value: 0x3)

      registers.write(.dctrl, value: 0)
      handle.writeTransmitBuffer(pData)
      handle.write(.transmitSize, value: 0x200 &* NumberOfBlocks)
      if (handle.read(.cardType)) != 0x1 {
        add = add &* (0x200)
      }

      config.dataTimeout = 0xffff_ffff
      config.dataLength = 0x200 &* NumberOfBlocks
      config.dataBlockSize = 0x90
      config.transferDirection = 0x0
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      if NumberOfBlocks > 1 {
        handle.write(.transferContext, value: (0x20 | 0x8))

        errorstate = sdmmc.commandWriteMultipleBlocks(add, getSystemCoreClock: getSystemCoreClock)
      } else {
        handle.write(.transferContext, value: (0x10 | 0x8))

        errorstate = sdmmc.commandWriteSingleBlock(add, getSystemCoreClock: getSystemCoreClock)
      }
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }

      sdmmc.enableInterrupts((0x2 | 0x8 | 0x10 | 0x100 | 0x4000))
      return .ok
    } else {
      return .busy
    }

  }
  public func readBlocksDMA(
    _ pData: UnsafeMutablePointer<UInt8>?, _ BlockAdd: UInt32, _ NumberOfBlocks: UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var add: UInt32 = 0

    add = BlockAdd
    if nil == pData {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      if (BlockAdd &+ NumberOfBlocks) > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }

      if ((handle.extendedCSDPointer()[Int((0x3d / 4))] >> 0x8) & 0x0000_00FF) != 0x0 {
        if (NumberOfBlocks % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
          return .error
        }
        if (BlockAdd % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          return .error
        }
      }
      handle.write(.state, value: 0x3)

      registers.write(.dctrl, value: 0)
      handle.writeReceiveBuffer(pData)
      handle.write(.receiveSize, value: 0x200 &* NumberOfBlocks)
      if (handle.read(.cardType)) != 0x1 {
        add = add &* (0x200)
      }

      config.dataTimeout = 0xffff_ffff
      config.dataLength = 0x200 &* NumberOfBlocks
      config.dataBlockSize = 0x90
      config.transferDirection = 0x2
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()
      registers.write(.idmabaser, value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
      registers.write(.idmactrl, value: 0x1)

      if NumberOfBlocks > 1 {
        handle.write(.transferContext, value: (0x2 | 0x80))

        errorstate = sdmmc.commandReadMultipleBlocks(add, getSystemCoreClock: getSystemCoreClock)
      } else {
        handle.write(.transferContext, value: (0x1 | 0x80))

        errorstate = sdmmc.commandReadSingleBlock(add, getSystemCoreClock: getSystemCoreClock)
      }
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: errorstate)
        handle.write(.state, value: 0x1)
        return .error
      }

      sdmmc.enableInterrupts((0x2 | 0x8 | 0x20 | 0x100))
      return .ok
    } else {
      return .busy
    }

  }
  public func writeBlocksDMA(
    _ pData: UnsafePointer<UInt8>?, _ BlockAdd: UInt32, _ NumberOfBlocks: UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var add: UInt32 = 0

    add = BlockAdd
    if nil == pData {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      if (BlockAdd &+ NumberOfBlocks) > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }

      if ((handle.extendedCSDPointer()[Int((0x3d / 4))] >> 0x8) & 0x0000_00FF) != 0x0 {
        if (NumberOfBlocks % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
          return .error
        }
        if (BlockAdd % 8) != 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          return .error
        }
      }
      handle.write(.state, value: 0x3)

      registers.write(.dctrl, value: 0)
      handle.writeTransmitBuffer(pData)
      handle.write(.transmitSize, value: 0x200 &* NumberOfBlocks)
      if (handle.read(.cardType)) != 0x1 {
        add = add &* (0x200)
      }

      config.dataTimeout = 0xffff_ffff
      config.dataLength = 0x200 &* NumberOfBlocks
      config.dataBlockSize = 0x90
      config.transferDirection = 0x0
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()
      registers.write(.idmabaser, value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
      registers.write(.idmactrl, value: 0x1)

      if NumberOfBlocks > 1 {
        handle.write(.transferContext, value: (0x20 | 0x80))

        errorstate = sdmmc.commandWriteMultipleBlocks(add, getSystemCoreClock: getSystemCoreClock)
      } else {
        handle.write(.transferContext, value: (0x10 | 0x80))

        errorstate = sdmmc.commandWriteSingleBlock(add, getSystemCoreClock: getSystemCoreClock)
      }
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }

      sdmmc.enableInterrupts((0x2 | 0x8 | 0x10 | 0x100))
      return .ok
    } else {
      return .busy
    }

  }
  public func erase(
    _ BlockStartAdd: UInt32, _ BlockEndAdd: UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var errorstate: UInt32 = 0
    var start_add: UInt32 = 0
    var end_add: UInt32 = 0

    start_add = BlockStartAdd
    end_add = BlockEndAdd
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      if end_add < start_add {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
        return .error
      }
      if end_add > (handle.read(.logicalBlockCount)) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
        return .error
      }

      if ((handle.extendedCSDPointer()[Int((0x3d / 4))] >> 0x8)
        & 0x0000_00FF) != 0x0
      {
        if ((start_add % 8) != 0) || ((end_add % 8) != 0) {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          return .error
        }
      }
      handle.write(.state, value: 0x3)

      if ((handle.read(.cardClass)) & 0x20) == 0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4000000))
        handle.write(.state, value: 0x1)
        return .error
      }
      if (sdmmc.getResponse(0x0) & 0x2000000) == 0x2000000 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x800))
        handle.write(.state, value: 0x1)
        return .error
      }
      if (handle.read(.cardType)) != 0x1 {
        start_add = start_add &* (0x200)
        end_add = end_add &* (0x200)
      }

      errorstate = sdmmc.commandEraseStartAddress(start_add, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }

      errorstate = sdmmc.commandEraseEndAddress(end_add, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }

      errorstate = sdmmc.commandErase(0, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }
      handle.write(.state, value: 0x1)
      return .ok
    } else {
      return .busy
    }

  }
}
