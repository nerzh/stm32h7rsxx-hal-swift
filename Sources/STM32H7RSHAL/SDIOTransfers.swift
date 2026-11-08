// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDIO {
  public func readDirect(
    _ Argument: UnsafePointer<SDIODirectCommand>?, _ pData: UnsafeMutablePointer<UInt8>?,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var cmd: UInt32 = 0
    var errorstate: UInt32 = 0

    if (Argument == nil) || (nil == pData) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x2)
      cmd = 0x0 << 31
      cmd = cmd | (((UInt32(truncatingIfNeeded: UInt32(Argument!.pointee.ioFunctionNumber))) << 28))
      cmd = cmd | (((UInt32(truncatingIfNeeded: UInt32(Argument!.pointee.readAfterWrite))) << 27))
      cmd = cmd | ((Argument!.pointee.registerAddress & 0x1FFFF) << 9)
      cmd = cmd | (0)
      errorstate = sdmmc.commandSDIOReadWriteDirect(
        cmd, pData, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != (0x2000000 | 0x2000 | 0x1000 | 0x10000) {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.state, value: 0x1)
          handle.write(.transferContext, value: 0x0)
          return .error
        }
      }
      sdmmc.disableCommandTransfer()

      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.state, value: 0x1)
    } else {
      return .busy
    }
    return .ok

  }
  public func writeDirect(
    _ Argument: UnsafePointer<SDIODirectCommand>?, _ Data: UInt8, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var Data = Data
    var cmd: UInt32 = 0
    var errorstate: UInt32 = 0

    if Argument == nil {
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x2)
      cmd = 0x1 << 31
      cmd = cmd | ((UInt32(truncatingIfNeeded: UInt32(Argument!.pointee.ioFunctionNumber))) << 28)
      cmd = cmd | ((UInt32(truncatingIfNeeded: UInt32(Argument!.pointee.readAfterWrite))) << 27)
      cmd = cmd | ((Argument!.pointee.registerAddress & 0x1FFFF) << 9)
      cmd = cmd | (UInt32(UInt32(Data)))
      errorstate = sdmmc.commandSDIOReadWriteDirect(
        cmd, &Data, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != (0x2000000 | 0x2000 | 0x1000 | 0x10000) {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.state, value: 0x1)
          handle.write(.transferContext, value: 0x0)
          return .error
        }
      }
      sdmmc.disableCommandTransfer()

      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.state, value: 0x1)
    } else {
      return .busy
    }
    return .ok

  }
  public func readExtended(
    _ Argument: UnsafePointer<SDIOExtendedCommand>?, _ pData: UnsafeMutablePointer<UInt8>?,
    _ Size_byte: UInt32, _ Timeout_Ms: UInt32, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var cmd: UInt32 = 0
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0
    var regCount: UInt32 = 0
    var byteCount: UInt8 = 0
    var data: UInt32 = 0
    var dataremaining: UInt32 = 0
    var tempbuff: UnsafeMutablePointer<UInt8>? = nil
    var nbr_of_block: UInt32 = 0

    tickstart = getTick()

    tempbuff = pData

    if (Argument == nil) || (pData == nil) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x2)

      nbr_of_block =
        (Size_byte & ~(UInt32(handle.read(.blockSize)) & 1))
        >> UInt32((UInt32(handle.read(.blockSize))).trailingZeroBitCount)

      if (registers.read(.dctrl) & 0x800) != 0 {
        registers.write(.dctrl, value: 0x800)
      } else {
        registers.write(.dctrl, value: 0)
      }

      config.dataTimeout = 0xffff_ffff

      if Argument!.pointee.blockMode == 0x1 {
        config.dataLength = UInt32(
          truncatingIfNeeded: (nbr_of_block &* UInt32(handle.read(.blockSize))))
        config.dataBlockSize = UInt32(convertBlockSize(UInt32(handle.read(.blockSize))))
      } else {
        config.dataLength = (Size_byte > 0) ? Size_byte : 0x200
        config.dataBlockSize = 0x0
      }
      config.transferDirection = 0x2

      config.transferMode = (Argument!.pointee.blockMode == 0x1) ? 0x0 : 0x4
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      handle.write(.transferContext, value: (Argument!.pointee.blockMode == 0x1) ? 0x2 : 0x1)
      cmd = 0x0 << 31
      cmd = cmd | (Argument!.pointee.ioFunctionNumber << 28)
      cmd = cmd | (Argument!.pointee.blockMode << 27)
      cmd = cmd | (Argument!.pointee.operationCode << 26)
      cmd = cmd | ((Argument!.pointee.registerAddress & 0x1FFFF) << 9)
      if Argument!.pointee.blockMode == 0x0 {
        cmd = cmd | (((UInt32(truncatingIfNeeded: Size_byte)) & 0x1FF))
      } else {
        cmd = cmd | (nbr_of_block & 0x1FF)
      }
      errorstate = sdmmc.commandSDIOReadWriteExtended(cmd, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != (0x2000000 | 0x2000 | 0x1000 | 0x10000) {
          registers.write(.dctrl, value: ((registers.read(.dctrl) & ~(0x2000)) | (0x2000)))
          sdmmc.clearFlag(0x1fe0_0fff)
          sdmmc.clearFlag(0x1800_0f3a)
          handle.write(.state, value: 0x1)
          handle.write(.transferContext, value: 0x0)
          return .error
        }
      }

      dataremaining = config.dataLength
      while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
        if sdmmc.getFlag(0x8000) && (dataremaining >= 0x20) {
          regCount = 0
          while regCount < (0x20 / 4) {
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
            regCount = regCount &+ (1)
          }
          dataremaining = dataremaining &- (0x20)
        } else if dataremaining < 0x20 {
          while !(sdmmc.getFlag(0x80000)) && (dataremaining > 0) {
            data = sdmmc.readFIFO()
            byteCount = UInt8(truncatingIfNeeded: 0)
            while UInt32(byteCount) < 4 {
              if dataremaining > 0 {
                tempbuff!.pointee = UInt8(
                  truncatingIfNeeded: UInt32(
                    UInt8(truncatingIfNeeded: ((data >> (UInt32(UInt32(byteCount)) &* 8)) & 0xFF))))
                tempbuff = tempbuff!.advanced(by: Int(1))
                dataremaining = dataremaining &- (1)
              }
              byteCount = UInt8(truncatingIfNeeded: UInt32(UInt32(byteCount)) &+ (1))
            }
          }
        } else {
        }
        if (getTick() &- tickstart) >= Timeout_Ms {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000_0000))
          handle.write(.state, value: 0x1)
          handle.write(.transferContext, value: 0x0)
          return .timeout
        }
      }
      sdmmc.disableCommandTransfer()

      if sdmmc.getFlag(0x8) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .error
      } else if sdmmc.getFlag(0x2) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .error
      } else if sdmmc.getFlag(0x20) {
        sdmmc.clearFlag(0x1fe0_0fff)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .error
      } else if handle.read(.errorCode) == 0x8000000 {
        sdmmc.clearFlag(0x1800_0f3a)
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .error
      } else {
      }

      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.state, value: 0x1)
    } else {
      return .busy
    }
    return .ok

  }
  public func writeExtended(
    _ Argument: UnsafePointer<SDIOExtendedCommand>?, _ pData: UnsafeMutablePointer<UInt8>?,
    _ Size_byte: UInt32, _ Timeout_Ms: UInt32, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var cmd: UInt32 = 0
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0
    var regCount: UInt32 = 0
    var byteCount: UInt8 = 0
    var data: UInt32 = 0
    var dataremaining: UInt32 = 0
    var u32tempbuff: UnsafeMutablePointer<UInt32>? = nil
    var nbr_of_block: UInt32 = 0
    var u8buff: UnsafePointer<UInt8>? = nil

    tickstart = getTick()

    u32tempbuff = UnsafeMutablePointer<UInt32>(bitPattern: UInt(bitPattern: pData))

    if (Argument == nil) || (pData == nil) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x2)

      nbr_of_block =
        (Size_byte & ~(UInt32(handle.read(.blockSize)) & 1))
        >> UInt32((UInt32(handle.read(.blockSize))).trailingZeroBitCount)

      if (registers.read(.dctrl) & 0x800) != 0 {
        registers.write(.dctrl, value: 0x800)
      } else {
        registers.write(.dctrl, value: 0)
      }

      config.dataTimeout = 0xffff_ffff
      if Argument!.pointee.blockMode == 0x1 {
        config.dataLength = UInt32(
          truncatingIfNeeded: (nbr_of_block &* UInt32(handle.read(.blockSize))))
        config.dataBlockSize = UInt32(convertBlockSize(UInt32(handle.read(.blockSize))))
      } else {
        config.dataLength = (Size_byte > 0) ? Size_byte : 0x200
        config.dataBlockSize = 0x0
      }
      config.transferDirection = 0x0

      config.transferMode = (Argument!.pointee.blockMode == 0x1) ? 0x0 : 0x4
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      handle.write(.transferContext, value: (Argument!.pointee.blockMode == 0x1) ? 0x20 : 0x10)
      cmd = 0x1 << 31
      cmd = cmd | (Argument!.pointee.ioFunctionNumber << 28)
      cmd = cmd | (Argument!.pointee.blockMode << 27)
      cmd = cmd | (Argument!.pointee.operationCode << 26)
      cmd = cmd | ((Argument!.pointee.registerAddress & 0x1FFFF) << 9)
      if Argument!.pointee.blockMode == 0x0 {
        cmd = cmd | (((UInt32(truncatingIfNeeded: Size_byte)) & 0x1FF))
      } else {
        cmd = cmd | (nbr_of_block & 0x1FF)
      }
      errorstate = sdmmc.commandSDIOReadWriteExtended(cmd, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != (0x2000000 | 0x2000 | 0x1000 | 0x10000) {
          registers.write(.dctrl, value: ((registers.read(.dctrl) & ~(0x2000)) | (0x2000)))
          sdmmc.clearFlag(0x1fe0_0fff)
          sdmmc.clearFlag(0x1800_0f3a)
          handle.write(.state, value: 0x1)
          handle.write(.transferContext, value: 0x0)
          return .error
        }
      }
      dataremaining = config.dataLength
      while !sdmmc.getFlag(0x10 | 0x2 | 0x8 | 0x100) {
        if sdmmc.getFlag(0x4000) && (dataremaining >= 0x20) {
          regCount = 0
          while regCount < (0x20 / 4) {
            registers.write(.fifo, value: u32tempbuff!.pointee)
            u32tempbuff = u32tempbuff!.advanced(by: Int(1))
            regCount = regCount &+ (1)
          }
          dataremaining = dataremaining &- (0x20)
        } else if (sdmmc.getFlag(0x4000 | 0x40000)) && (dataremaining < 0x20) {
          u8buff = UnsafeRawPointer(u32tempbuff!).assumingMemoryBound(to: UInt8.self)
          while dataremaining > 0 {
            data = 0
            byteCount = UInt8(truncatingIfNeeded: 0)
            while (UInt32(byteCount) < 4) && (dataremaining > 0) {
              data =
                data
                | ((UInt32(truncatingIfNeeded: (UInt32(u8buff!.pointee)))
                  << (UInt32(UInt32(byteCount)) << 3)))
              u8buff = u8buff!.advanced(by: Int(1))
              dataremaining = dataremaining &- (1)
              byteCount = UInt8(truncatingIfNeeded: UInt32(UInt32(byteCount)) &+ (1))
            }
            registers.write(.fifo, value: data)
          }
        }
        if (getTick() &- tickstart) >= Timeout_Ms {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000_0000))
          handle.write(.state, value: 0x1)
          handle.write(.transferContext, value: 0x0)
          return .timeout
        }
      }
      sdmmc.disableCommandTransfer()

      if sdmmc.getFlag(0x8) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .error
      } else if sdmmc.getFlag(0x2) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .error
      } else if sdmmc.getFlag(0x10) {
        sdmmc.clearFlag(0x1fe0_0fff)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .error
      } else if handle.read(.errorCode) == 0x8000000 {
        sdmmc.clearFlag(0x1800_0f3a)
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .error
      } else {
      }

      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.state, value: 0x1)
    } else {
      return .busy
    }
    return .ok

  }
  public func readExtendedDMA(
    _ Argument: UnsafePointer<SDIOExtendedCommand>?, _ pData: UnsafeMutablePointer<UInt8>?,
    _ Size_byte: UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var p_dma_buffer: UnsafeMutablePointer<UInt8>? = nil
    var cmd: UInt32 = 0
    var nbr_of_block: UInt32 = 0

    if (Argument == nil) || (pData == nil) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x2)

      if (registers.read(.dctrl) & 0x800) != 0 {
        registers.write(.dctrl, value: 0x800)
      } else {
        registers.write(.dctrl, value: 0)
      }
      p_dma_buffer = pData
      handle.writeReceiveBuffer(pData)
      handle.write(.receiveSize, value: Size_byte)
      handle.write(.nextDataAddress, value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))

      nbr_of_block =
        (Size_byte & ~(UInt32(handle.read(.blockSize)) & 1))
        >> UInt32((UInt32(handle.read(.blockSize))).trailingZeroBitCount)
      if nbr_of_block != 0 {
        handle.write(
          .remainingData, value: (Size_byte &- (UInt32(handle.read(.blockSize)) &* nbr_of_block)))
        handle.write(
          .nextRegisterAddress,
          value: (Argument!.pointee.registerAddress)
            | ((((nbr_of_block &* UInt32(handle.read(.blockSize))) >> 1) & 0x3FFF) << 1)
            | ((handle.read(.remainingData) <= 0x200) ? 1 : 0))
        handle.write(
          .nextDataAddress,
          value: handle.read(.nextDataAddress)
            &+ ((nbr_of_block &* UInt32(handle.read(.blockSize)))))
      } else {
        handle.write(
          .nextDataAddress,
          value: handle.read(.nextDataAddress) &+ ((Size_byte < 0x200) ? Size_byte : 0x200))
        if handle.read(.remainingData) != 0 {
          handle.write(
            .remainingData,
            value: (Size_byte >= 0x200)
              ? (Size_byte &- 0x200) : (Size_byte &- handle.read(.remainingData)))
          handle.write(
            .nextRegisterAddress,
            value: handle.read(.nextRegisterAddress)
              &+ ((Size_byte >= 0x200) ? (0x200 &+ 1) : (Size_byte &+ 1)))
        }
      }

      registers.write(.idmactrl, value: 0x1)
      registers.write(.idmabaser, value: UInt32(truncatingIfNeeded: UInt(bitPattern: p_dma_buffer)))

      config.dataTimeout = 0xffff_ffff
      if Argument!.pointee.blockMode == 0x1 {
        config.dataLength = UInt32(
          truncatingIfNeeded: (nbr_of_block &* UInt32(handle.read(.blockSize))))
        config.dataBlockSize = UInt32(convertBlockSize(UInt32(handle.read(.blockSize))))
      } else {
        config.dataLength = (Size_byte > 0) ? Size_byte : 0x200
        config.dataBlockSize = 0x0
      }
      config.transferDirection = 0x2
      config.transferMode = (Argument!.pointee.blockMode == 0x1) ? 0x0 : 0x4
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      handle.write(
        .transferContext,
        value: UInt32(truncatingIfNeeded: ((Argument!.pointee.blockMode == 0x1) ? 0x2 : 0x1)) | 0x80
      )
      cmd = 0x0 << 31
      cmd = cmd | (Argument!.pointee.ioFunctionNumber << 28)
      cmd = cmd | (Argument!.pointee.blockMode << 27)
      cmd = cmd | (Argument!.pointee.operationCode << 26)
      cmd = cmd | ((Argument!.pointee.registerAddress & 0x1FFFF) << 9)
      cmd = cmd | (((nbr_of_block == 0) ? Size_byte : nbr_of_block) & 0x1FF)
      errorstate = sdmmc.commandSDIOReadWriteExtended(cmd, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != (0x2000000 | 0x2000 | 0x1000 | 0x10000) {
          registers.write(.dctrl, value: ((registers.read(.dctrl) & ~(0x2000)) | (0x2000)))
          sdmmc.clearFlag(0x1fe0_0fff)
          sdmmc.clearFlag(0x1800_0f3a)
          handle.write(.state, value: 0x1)
          handle.write(.transferContext, value: 0x0)
          return .error
        }
      }
      sdmmc.enableInterrupts((0x2 | 0x8 | 0x20 | 0x100))
    } else {
      return .busy
    }
    return .ok

  }
  public func writeExtendedDMA(
    _ Argument: UnsafePointer<SDIOExtendedCommand>?, _ pData: UnsafeMutablePointer<UInt8>?,
    _ Size_byte: UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var cmd: UInt32 = 0
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var p_dma_buffer: UnsafeMutablePointer<UInt8>? = nil
    var nbr_of_block: UInt32 = 0

    if (Argument == nil) || (pData == nil) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x2)

      if (registers.read(.dctrl) & 0x800) != 0 {
        registers.write(.dctrl, value: 0x800)
      } else {
        registers.write(.dctrl, value: 0)
      }
      p_dma_buffer = pData
      handle.writeTransmitBuffer(pData)
      handle.write(.transmitSize, value: Size_byte)
      handle.write(.nextDataAddress, value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
      nbr_of_block =
        (Size_byte & ~(UInt32(handle.read(.blockSize)) & 1))
        >> UInt32((UInt32(handle.read(.blockSize))).trailingZeroBitCount)
      if nbr_of_block != 0 {
        handle.write(
          .remainingData, value: (Size_byte &- (UInt32(handle.read(.blockSize)) &* nbr_of_block)))
        if UInt32(handle.read(.blockSize)) <= 128 {
          handle.write(
            .nextRegisterAddress,
            value: (Argument!.pointee.registerAddress)
              | ((((nbr_of_block &* UInt32(handle.read(.blockSize))) >> 1) & 0x3FFF) << 1)
              | ((handle.read(.remainingData) <= 0x200) ? 1 : 0))
        } else {
          handle.write(
            .nextRegisterAddress, value: (nbr_of_block &* UInt32(handle.read(.blockSize))) >> 1)
        }
        handle.write(
          .nextDataAddress,
          value: handle.read(.nextDataAddress)
            &+ ((nbr_of_block &* UInt32(handle.read(.blockSize)))))
      } else {
        handle.write(
          .remainingData,
          value: (Size_byte >= 0x200)
            ? (Size_byte &- 0x200) : (Size_byte &- handle.read(.remainingData)))
        if handle.read(.remainingData) != 0 {
          handle.write(
            .remainingData,
            value: (Size_byte >= 0x200)
              ? (Size_byte &- 0x200) : (Size_byte &- handle.read(.remainingData)))
          handle.write(
            .nextRegisterAddress,
            value: handle.read(.nextRegisterAddress)
              &+ (((Size_byte >= 0x200) ? (0x200 >> 1) : (Size_byte >> 1))
                | (((handle.read(.remainingData) > 0) ? 0 : 1))))
        }
        handle.write(
          .nextDataAddress,
          value: handle.read(.nextDataAddress) &+ ((Size_byte < 0x200) ? Size_byte : 0x200))
      }

      registers.write(.idmactrl, value: 0x1)
      registers.write(.idmabaser, value: UInt32(truncatingIfNeeded: UInt(bitPattern: p_dma_buffer)))

      config.dataTimeout = 0xffff_ffff
      if Argument!.pointee.blockMode == 0x1 {
        config.dataLength = UInt32(
          truncatingIfNeeded: (nbr_of_block &* UInt32(handle.read(.blockSize))))
        config.dataBlockSize = UInt32(convertBlockSize(UInt32(handle.read(.blockSize))))
      } else {
        config.dataLength = (Size_byte > 0x200) ? 0x200 : Size_byte
        config.dataBlockSize = 0x0
      }
      config.transferDirection = 0x0
      config.transferMode =
        (Argument!.pointee.blockMode == 0x1)
        ? 0x0
        : 0x4
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      handle.write(
        .transferContext,
        value: UInt32(truncatingIfNeeded: ((Argument!.pointee.blockMode == 0x1) ? 0x20 : 0x10))
          | 0x80)
      cmd = 0x1 << 31
      cmd = cmd | (Argument!.pointee.ioFunctionNumber << 28)
      cmd = cmd | (Argument!.pointee.blockMode << 27)
      cmd = cmd | (Argument!.pointee.operationCode << 26)
      cmd = cmd | ((Argument!.pointee.registerAddress & 0x1FFFF) << 9)
      cmd =
        cmd
        | (((nbr_of_block == 0) ? ((Size_byte > 0x200) ? 0x200 : Size_byte) : nbr_of_block) & 0x1FF)
      errorstate = sdmmc.commandSDIOReadWriteExtended(cmd, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != (0x2000000 | 0x2000 | 0x1000 | 0x10000) {
          registers.write(.dctrl, value: ((registers.read(.dctrl) & ~(0x2000)) | (0x2000)))
          sdmmc.clearFlag(0x1fe0_0fff)
          sdmmc.clearFlag(0x1800_0f3a)
          handle.write(.state, value: 0x1)
          handle.write(.transferContext, value: 0x0)
          return .error
        }
      }
      sdmmc.enableInterrupts((0x2 | 0x8 | 0x10 | 0x100))
    } else {
      return .busy
    }
    return .ok

  }
  func readDirectByte(
    _ addr: UInt32, _ raw: UInt32, _ function_nbr: UInt32, _ pData: UnsafeMutablePointer<UInt8>?,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var errorstate: UInt32 = 0
    var cmd: UInt32 = 0

    cmd = 0x0 << 31
    cmd = cmd | (function_nbr << 28)
    cmd = cmd | (raw << 27)
    cmd = cmd | ((addr & 0x1FFFF) << 9)
    errorstate = sdmmc.commandSDIOReadWriteDirect(
      cmd, pData, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))

      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.state, value: 0x1)
      handle.write(.transferContext, value: 0x0)
      return .error
    }
    sdmmc.disableCommandTransfer()

    sdmmc.clearFlag(0x1800_0f3a)
    return .ok

  }
  func writeDirectByte(
    _ addr: UInt32, _ raw: UInt32, _ function_nbr: UInt32, _ pData: UnsafePointer<UInt8>?,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var errorstate: UInt32 = 0
    var cmd: UInt32 = 0
    var response: UInt8 = 0

    cmd = 0x1 << 31
    cmd = cmd | (function_nbr << 28)
    cmd = cmd | (raw << 27)
    cmd = cmd | ((addr & 0x1FFFF) << 9)
    cmd = cmd | ((UInt32(truncatingIfNeeded: (UInt32(pData!.pointee))) & 0x0000_00FF))
    errorstate = sdmmc.commandSDIOReadWriteDirect(
      cmd, &response, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))

      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.state, value: 0x1)
      handle.write(.transferContext, value: 0x0)
      return .error
    }
    sdmmc.disableCommandTransfer()

    sdmmc.clearFlag(0x1800_0f3a)
    return .ok

  }
  func writeExtendedBlock(
    _ cmd_arg: UnsafePointer<SDIOExtendedCommand>?, _ pData: UnsafeMutablePointer<UInt8>?,
    _ Size_byte: UInt16, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0
    var regCount: UInt32 = 0
    var byteCount: UInt8 = 0
    var data: UInt32 = 0
    var dataremaining: UInt32 = 0
    var u32tempbuff: UnsafeMutablePointer<UInt32>? = nil
    var cmd: UInt32 = 0
    var nbr_of_block: UInt32 = 0
    var u8buff: UnsafePointer<UInt8>? = nil

    tickstart = getTick()

    u32tempbuff = UnsafeMutablePointer<UInt32>(bitPattern: UInt(bitPattern: pData))

    handle.write(.errorCode, value: 0x0)

    nbr_of_block =
      ((UInt32(truncatingIfNeeded: UInt32(UInt32(Size_byte)))
        & ~(UInt32(truncatingIfNeeded: UInt32(handle.read(.blockSize))) & 1)))
      >> UInt32((UInt32(handle.read(.blockSize))).trailingZeroBitCount)

    if (registers.read(.dctrl) & 0x800) != 0 {
      registers.write(.dctrl, value: 0x800)
    } else {
      registers.write(.dctrl, value: 0)
    }

    config.dataTimeout = 0xffff_ffff
    if cmd_arg!.pointee.blockMode == 0x1 {
      config.dataLength = UInt32(
        truncatingIfNeeded: (nbr_of_block &* UInt32(handle.read(.blockSize))))
      config.dataBlockSize = UInt32(convertBlockSize(UInt32(handle.read(.blockSize))))
    } else {
      config.dataLength = UInt32(UInt32(Size_byte))
      config.dataBlockSize = 0x0
    }
    config.transferDirection = 0x0
    config.transferMode = (cmd_arg!.pointee.blockMode == 0x1) ? 0x0 : 0x4
    config.dpsm = 0x0
    _ = sdmmc.configureData(&config)
    sdmmc.enableCommandTransfer()
    handle.write(.transferContext, value: (cmd_arg!.pointee.blockMode == 0x1) ? 0x20 : 0x10)
    cmd = 0x1 << 31
    cmd = cmd | (cmd_arg!.pointee.ioFunctionNumber << 28)
    cmd = cmd | (cmd_arg!.pointee.blockMode << 27)
    cmd = cmd | (cmd_arg!.pointee.operationCode << 26)
    cmd = cmd | ((cmd_arg!.pointee.registerAddress & 0x1FFFF) << 9)
    cmd = cmd | (((UInt32(truncatingIfNeeded: UInt32(UInt32(Size_byte)))) & 0x1FF))
    errorstate = sdmmc.commandSDIOReadWriteExtended(cmd, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      registers.write(.dctrl, value: ((registers.read(.dctrl) & ~(0x2000)) | (0x2000)))
      sdmmc.clearFlag(0x1fe0_0fff)
      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      handle.write(.state, value: 0x1)
      handle.write(.transferContext, value: 0x0)
      return .error
    }

    dataremaining = config.dataLength
    while !sdmmc.getFlag(0x10 | 0x2 | 0x8 | 0x100) {
      if sdmmc.getFlag(0x4000) && (dataremaining >= 0x20) {
        regCount = 0x20 / 4
        while regCount > 0 {
          registers.write(.fifo, value: u32tempbuff!.pointee)
          u32tempbuff = u32tempbuff!.advanced(by: Int(1))
          regCount = regCount &- (1)
        }
        dataremaining = dataremaining &- (0x20)
      } else if (sdmmc.getFlag(0x4000 | 0x40000)) && (dataremaining < 0x20) {
        u8buff = UnsafeRawPointer(u32tempbuff!).assumingMemoryBound(to: UInt8.self)
        while dataremaining > 0 {
          data = 0
          byteCount = UInt8(truncatingIfNeeded: 0)
          while (UInt32(byteCount) < 4) && (dataremaining > 0) {
            data =
              data
              | ((UInt32(truncatingIfNeeded: (UInt32(u8buff!.pointee)))
                << (UInt32(UInt32(byteCount)) << 3)))
            u8buff = u8buff!.advanced(by: Int(1))
            dataremaining = dataremaining &- (1)
            byteCount = UInt8(truncatingIfNeeded: UInt32(UInt32(byteCount)) &+ (1))
          }
          registers.write(.fifo, value: data)
        }
      }
      if (getTick() &- tickstart) >= 0xffff_ffff {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000_0000))
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        return .timeout
      }
    }
    sdmmc.disableCommandTransfer()
    if sdmmc.getFlag(0x8) {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      handle.write(.state, value: 0x1)
      handle.write(.transferContext, value: 0x0)
      return .error
    } else if sdmmc.getFlag(0x2) {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
      handle.write(.state, value: 0x1)
      handle.write(.transferContext, value: 0x0)
      return .error
    } else if sdmmc.getFlag(0x10) {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
      handle.write(.state, value: 0x1)
      handle.write(.transferContext, value: 0x0)
      return .error
    } else if handle.read(.errorCode) == 0x8000000 {
      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.state, value: 0x1)
      handle.write(.transferContext, value: 0x0)
      return .error
    } else {
    }
    sdmmc.clearFlag(0x1800_0f3a)
    return .ok

  }
  func convertBlockSize(_ block_size: UInt32) -> UInt8 {
    var most_bit: UInt8 = 0

    most_bit = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(truncatingIfNeeded: UInt32((block_size).trailingZeroBitCount))))

    if (UInt32(UInt8(truncatingIfNeeded: block_size)) & ((1 << UInt32(most_bit)) &- 1)) != 0 {
      return UInt8(truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: 0x20)))
    }
    return UInt8(truncatingIfNeeded: UInt32(most_bit) << 0x4)

  }
}
