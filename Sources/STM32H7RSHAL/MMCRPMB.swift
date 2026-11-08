// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MMC {
  public func programRPMBAuthenticationKey(
    _ pKey: UnsafePointer<UInt8>?, _ Timeout: UInt32, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 12) { tail_pack in
      tail_pack.initialize(repeating: 0)
      return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 4) { zero_pack in
        zero_pack.initialize(repeating: 0)
        var config: SDMMCDataConfiguration = .init()
        var errorstate: UInt32 = 0
        var tickstart: UInt32 = 0
        var count: UInt32 = 0
        var byte_count: UInt32 = 0
        var data: UInt32 = 0
        var dataremaining: UInt32 = 0
        var rtempbuff: UnsafePointer<UInt8>? = nil
        var tempbuff: UnsafeMutablePointer<UInt8>? = nil

        tickstart = getTick()

        byte_count = 0

        tail_pack[Int(Int(11))] = UInt8(truncatingIfNeeded: 0x01)
        if nil == pKey {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
          return .error
        }
        if handle.read(.state) == 0x1 {
          handle.write(.errorCode, value: 0x0)
          handle.write(.state, value: 0x3)

          registers.write(.dctrl, value: 0)
          errorstate = sdmmc.commandBlockCount(0x8000_0001, getSystemCoreClock: getSystemCoreClock)
          if errorstate != 0x0 {
            sdmmc.clearFlag(0x1fe0_0fff)
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
            handle.write(.state, value: 0x1)
            return .error
          }

          config.dataTimeout = 0xffff_ffff
          config.dataLength = 0x200
          config.dataBlockSize = 0x90
          config.transferDirection = 0x0
          config.transferMode = 0x0
          config.dpsm = 0x0
          _ = sdmmc.configureData(&config)
          sdmmc.enableCommandTransfer()

          do {
            handle.write(.transferContext, value: 0x20)

            errorstate = sdmmc.commandWriteMultipleBlocks(0, getSystemCoreClock: getSystemCoreClock)
          }
          if errorstate != 0x0 {
            sdmmc.clearFlag(0x1fe0_0fff)
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
            handle.write(.state, value: 0x1)
            return .error
          }

          rtempbuff = UnsafePointer(zero_pack.baseAddress!)
          dataremaining = config.dataLength
          while !sdmmc.getFlag(0x10 | 0x2 | 0x8 | 0x100) {
            if sdmmc.getFlag(0x4000) && (dataremaining >= 0x20) {
              count = 0
              while count < (0x20 / 4) {
                data = UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee)))
                rtempbuff = rtempbuff!.advanced(by: Int(1))
                byte_count = byte_count &+ (1)
                data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 8))
                rtempbuff = rtempbuff!.advanced(by: Int(1))
                byte_count = byte_count &+ (1)
                data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 16))
                rtempbuff = rtempbuff!.advanced(by: Int(1))
                byte_count = byte_count &+ (1)
                data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 24))
                rtempbuff = rtempbuff!.advanced(by: Int(1))
                byte_count = byte_count &+ (1)
                _ = sdmmc.writeFIFO(&data)
                if byte_count < 0xc4 {
                  rtempbuff = UnsafePointer(zero_pack.baseAddress!)
                } else if byte_count == 0xc4 {
                  rtempbuff = pKey
                } else if (byte_count < 0x1f4) && (byte_count >= 0xe4) {
                  rtempbuff = UnsafePointer(zero_pack.baseAddress!)
                } else if byte_count == 0x1f4 {
                  rtempbuff = UnsafePointer(tail_pack.baseAddress!)
                } else {
                }
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

          errorstate = sdmmc.commandBlockCount(0x0000_0001, getSystemCoreClock: getSystemCoreClock)
          if errorstate != 0x0 {
            sdmmc.clearFlag(0x1fe0_0fff)
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
            handle.write(.state, value: 0x1)
            return .error
          }

          config.dataTimeout = 0xffff_ffff
          config.dataLength = 0x200
          config.dataBlockSize = 0x90
          config.transferDirection = 0x2
          config.transferMode = 0x0
          config.dpsm = 0x0
          _ = sdmmc.configureData(&config)
          sdmmc.enableCommandTransfer()

          handle.write(.transferContext, value: 0x2)

          errorstate = sdmmc.commandReadMultipleBlocks(0, getSystemCoreClock: getSystemCoreClock)
          if errorstate != 0x0 {
            sdmmc.clearFlag(0x1fe0_0fff)
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
            handle.write(.state, value: 0x1)
            return .error
          }

          sdmmc.clearFlag(0x1800_0f3a)

          tempbuff = zero_pack.baseAddress
          byte_count = 0
          dataremaining = config.dataLength
          while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
            if sdmmc.getFlag(0x8000) && (dataremaining >= 0x20) {
              count = 0
              while count < (0x20 / 4) {
                data = sdmmc.readFIFO()
                tempbuff!.pointee = UInt8(
                  truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (data & 0xFF))))
                tempbuff = tempbuff!.advanced(by: Int(1))
                byte_count = byte_count &+ (1)
                tempbuff!.pointee = UInt8(
                  truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 8) & 0xFF))))
                tempbuff = tempbuff!.advanced(by: Int(1))
                byte_count = byte_count &+ (1)
                tempbuff!.pointee = UInt8(
                  truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 16) & 0xFF))))
                tempbuff = tempbuff!.advanced(by: Int(1))
                byte_count = byte_count &+ (1)
                tempbuff!.pointee = UInt8(
                  truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 24) & 0xFF))))
                tempbuff = tempbuff!.advanced(by: Int(1))
                byte_count = byte_count &+ (1)
                if byte_count < 0x1f4 {
                  tempbuff = zero_pack.baseAddress
                } else if byte_count == 0x1f4 {
                  tempbuff = tail_pack.baseAddress
                } else {
                }
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

          if (UInt32(tail_pack[Int(9)]) != 0x00) || (UInt32(tail_pack[Int(10)]) != 0x01) {
            handle.writeRPMBErrorCode(
              UInt16(
                truncatingIfNeeded: UInt32(handle.readRPMBErrorCode())
                  | (UInt32(UInt32(tail_pack[Int(Int(9))])))))
            return .error
          }
          return .ok
        } else {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000_0000))
          return .error
        }

      }
    }
  }
  public func getRPMBWriteCounter(
    _ pNonce: UnsafeMutablePointer<UInt8>?, _ Timeout: UInt32, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 12) { tail_pack in
      tail_pack.initialize(repeating: 0)
      return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 4) { zero_pack in
        zero_pack.initialize(repeating: 0)
        return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 16) { echo_nonce in
          echo_nonce.initialize(repeating: 0)
          var config: SDMMCDataConfiguration = .init()
          var errorstate: UInt32 = 0
          var tickstart: UInt32 = 0
          var count: UInt32 = 0
          var byte_count: UInt32 = 0
          var data: UInt32 = 0
          var dataremaining: UInt32 = 0
          var tempbuff: UnsafeMutablePointer<UInt8>? = nil
          var i: UInt32 = 0

          tickstart = getTick()

          byte_count = 0

          tempbuff = zero_pack.baseAddress
          tail_pack[Int(Int(11))] = UInt8(truncatingIfNeeded: 0x02)
          if nil == pNonce {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
            handle.writeRPMBErrorCode(
              UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
            return 0
          }
          if handle.read(.state) == 0x1 {
            handle.write(.errorCode, value: 0x0)
            handle.write(.state, value: 0x3)

            registers.write(.dctrl, value: 0)
            errorstate = sdmmc.commandBlockCount(
              0x0000_0001, getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              handle.write(.state, value: 0x1)
              handle.writeRPMBErrorCode(
                UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
              return 0
            }

            config.dataTimeout = 0xffff_ffff
            config.dataLength = 0x200
            config.dataBlockSize = 0x90
            config.transferDirection = 0x0
            config.transferMode = 0x0
            config.dpsm = 0x0
            _ = sdmmc.configureData(&config)
            sdmmc.enableCommandTransfer()

            handle.write(.transferContext, value: 0x20)

            errorstate = sdmmc.commandWriteMultipleBlocks(0, getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              handle.write(.state, value: 0x1)
              handle.writeRPMBErrorCode(
                UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
              return 0
            }

            dataremaining = config.dataLength
            while !sdmmc.getFlag(0x10 | 0x2 | 0x8 | 0x100) {
              if sdmmc.getFlag(0x4000) && (dataremaining >= 0x20) {

                count = 0
                while count < (0x20 / 4) {
                  data = UInt32(truncatingIfNeeded: (UInt32(tempbuff!.pointee)))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  data = data | ((UInt32(truncatingIfNeeded: (UInt32(tempbuff!.pointee))) << 8))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  data = data | ((UInt32(truncatingIfNeeded: (UInt32(tempbuff!.pointee))) << 16))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  data = data | ((UInt32(truncatingIfNeeded: (UInt32(tempbuff!.pointee))) << 24))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  _ = sdmmc.writeFIFO(&data)
                  if byte_count < 0x1e4 {
                    tempbuff = zero_pack.baseAddress
                  } else if byte_count == 0x1e4 {
                    tempbuff = pNonce
                  } else if byte_count == 0x1f4 {
                    tempbuff = tail_pack.baseAddress
                  } else {
                  }
                  count = count &+ (1)
                }
                dataremaining = dataremaining &- (0x20)
              }
              if ((getTick() &- tickstart) >= Timeout) || (Timeout == 0) {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
                handle.write(.state, value: 0x1)
                handle.writeRPMBErrorCode(
                  UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
                return 0
              }
            }
            sdmmc.disableCommandTransfer()

            errorstate = sdmmc.commandBlockCount(
              0x0000_0001, getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              handle.write(.state, value: 0x1)
              handle.writeRPMBErrorCode(
                UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
              return 0
            }

            config.dataTimeout = 0xffff_ffff
            config.dataLength = 0x200
            config.dataBlockSize = 0x90
            config.transferDirection = 0x2
            config.transferMode = 0x0
            config.dpsm = 0x0
            _ = sdmmc.configureData(&config)
            sdmmc.enableCommandTransfer()

            handle.write(.transferContext, value: 0x2)

            errorstate = sdmmc.commandReadMultipleBlocks(0, getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              handle.write(.state, value: 0x1)
              handle.writeRPMBErrorCode(
                UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
              return 0
            }

            sdmmc.clearFlag(0x1800_0f3a)

            tempbuff = zero_pack.baseAddress
            byte_count = 0
            dataremaining = config.dataLength
            while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
              if sdmmc.getFlag(0x8000) && (dataremaining >= 0x20) {
                count = 0
                while count < (0x20 / 4) {
                  data = sdmmc.readFIFO()
                  tempbuff!.pointee = UInt8(
                    truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (data & 0xFF))))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  tempbuff!.pointee = UInt8(
                    truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 8) & 0xFF))))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  tempbuff!.pointee = UInt8(
                    truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 16) & 0xFF))))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  tempbuff!.pointee = UInt8(
                    truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 24) & 0xFF))))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  if byte_count < 0x1e4 {
                    tempbuff = zero_pack.baseAddress
                  } else if byte_count == 0x1e4 {
                    tempbuff = echo_nonce.baseAddress
                  } else if byte_count == 0x1f4 {
                    tempbuff = tail_pack.baseAddress
                  } else {
                  }
                  count = count &+ (1)
                }
                dataremaining = dataremaining &- (0x20)
              }
              if ((getTick() &- tickstart) >= Timeout) || (Timeout == 0) {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000_0000))
                handle.write(.state, value: 0x1)
                handle.writeRPMBErrorCode(
                  UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
                return 0
              }
            }
            sdmmc.disableCommandTransfer()

            if sdmmc.getFlag(0x8) {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
              handle.write(.state, value: 0x1)
              handle.writeRPMBErrorCode(
                UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
              return 0
            } else if sdmmc.getFlag(0x2) {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
              handle.write(.state, value: 0x1)
              handle.writeRPMBErrorCode(
                UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
              return 0
            } else if sdmmc.getFlag(0x10) {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
              handle.write(.state, value: 0x1)
              handle.writeRPMBErrorCode(
                UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
              return 0
            } else {
            }

            sdmmc.clearFlag(0x1800_0f3a)
            handle.write(.state, value: 0x1)
            i = 0
            while i < 16 {
              if UInt32(pNonce![Int(i)]) != UInt32(echo_nonce[Int(i)]) {
                handle.writeRPMBErrorCode(
                  UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
                return 0
              }
              i = i &+ (1)
            }
            return
              (UInt32(truncatingIfNeeded: UInt32(tail_pack[Int(3)]))
              | (UInt32(truncatingIfNeeded: UInt32(tail_pack[Int(2)])) << 8)
              | (UInt32(truncatingIfNeeded: UInt32(tail_pack[Int(1)])) << 16)
              | (UInt32(truncatingIfNeeded: UInt32(tail_pack[Int(0)])) << 24))
          } else {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000_0000))
            handle.writeRPMBErrorCode(
              UInt16(truncatingIfNeeded: UInt32(handle.readRPMBErrorCode()) | (0x3)))
            return 0
          }

        }
      }
    }
  }
  public func writeRPMBBlocks(
    _ pData: UnsafePointer<UInt8>?, _ BlockAdd: UInt16, _ NumberOfBlocks: UInt16,
    _ pMAC: UnsafePointer<UInt8>?, _ Timeout: UInt32, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 12) { tail_pack in
      tail_pack.initialize(repeating: 0)
      return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 4) { zero_pack in
        zero_pack.initialize(repeating: 0)
        return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 16) { echo_nonce in
          echo_nonce.initialize(repeating: 0)
          return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 16) { local_nonce in
            local_nonce.initialize(repeating: 0)
            local_nonce[0] = 0x00
            local_nonce[1] = 0x01
            local_nonce[2] = 0x02
            local_nonce[3] = 0x03
            local_nonce[4] = 0x04
            local_nonce[5] = 0x00
            local_nonce[6] = 0x01
            local_nonce[7] = 0x02
            local_nonce[8] = 0x03
            local_nonce[9] = 0x04
            local_nonce[10] = 0x00
            local_nonce[11] = 0x01
            local_nonce[12] = 0x02
            local_nonce[13] = 0x03
            local_nonce[14] = 0x04
            local_nonce[15] = 0x08
            let BlockAdd = UInt32(BlockAdd)
            let NumberOfBlocks = UInt32(NumberOfBlocks)
            var config: SDMMCDataConfiguration = .init()
            var errorstate: UInt32 = 0
            var tickstart: UInt32 = 0
            var count: UInt32 = 0
            var byte_count: UInt32 = 0
            var data: UInt32 = 0
            var dataremaining: UInt32 = 0
            var rtempbuff: UnsafePointer<UInt8>? = nil
            var tempbuff: UnsafeMutablePointer<UInt8>? = nil
            var arg: UInt32 = 0
            var offset: UInt32 = 0
            var i: UInt32 = 0

            tickstart = getTick()

            byte_count = 0

            arg = 0x8000_0000
            offset = 0
            if (NumberOfBlocks != 0x1) && (NumberOfBlocks != 0x2) && (NumberOfBlocks != 0x20) {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
              return .error
            }
            if (nil == pData) || (nil == pMAC) {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
              return .error
            }
            tail_pack[Int(Int(11))] = UInt8(truncatingIfNeeded: 0x02)
            if handle.read(.state) == 0x1 {
              handle.write(.errorCode, value: 0x0)
              handle.write(.state, value: 0x3)

              registers.write(.dctrl, value: 0)
              errorstate = sdmmc.commandBlockCount(
                0x0000_0001, getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
                handle.write(.state, value: 0x1)
                return .error
              }

              config.dataTimeout = 0xffff_ffff
              config.dataLength = 0x200
              config.dataBlockSize = 0x90
              config.transferDirection = 0x0
              config.transferMode = 0x0
              config.dpsm = 0x0
              _ = sdmmc.configureData(&config)
              sdmmc.enableCommandTransfer()

              handle.write(.transferContext, value: 0x20)

              errorstate = sdmmc.commandWriteMultipleBlocks(
                0, getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
                handle.write(.state, value: 0x1)
                return .error
              }

              rtempbuff = UnsafePointer(zero_pack.baseAddress!)
              dataremaining = config.dataLength
              while !sdmmc.getFlag(0x10 | 0x2 | 0x8 | 0x100) {
                if sdmmc.getFlag(0x4000) && (dataremaining >= 0x20) {

                  count = 0
                  while count < (0x20 / 4) {
                    data = UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee)))
                    rtempbuff = rtempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 8))
                    rtempbuff = rtempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 16))
                    rtempbuff = rtempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 24))
                    rtempbuff = rtempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    _ = sdmmc.writeFIFO(&data)
                    if byte_count < 0x1e4 {
                      rtempbuff = UnsafePointer(zero_pack.baseAddress!)
                    } else if byte_count == 0x1e4 {
                      rtempbuff = UnsafePointer(local_nonce.baseAddress!)
                    } else if byte_count == 0x1f4 {
                      rtempbuff = UnsafePointer(tail_pack.baseAddress!)
                    } else {
                    }
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

              errorstate = sdmmc.commandBlockCount(
                0x0000_0001, getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
                handle.write(.state, value: 0x1)
                return .error
              }

              config.dataTimeout = 0xffff_ffff
              config.dataLength = 0x200
              config.dataBlockSize = 0x90
              config.transferDirection = 0x2
              config.transferMode = 0x0
              config.dpsm = 0x0
              _ = sdmmc.configureData(&config)
              sdmmc.enableCommandTransfer()

              handle.write(.transferContext, value: 0x2)

              errorstate = sdmmc.commandReadMultipleBlocks(
                0, getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
                handle.write(.state, value: 0x1)
                return .error
              }

              sdmmc.clearFlag(0x1800_0f3a)

              tempbuff = zero_pack.baseAddress
              byte_count = 0
              dataremaining = config.dataLength
              while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
                if sdmmc.getFlag(0x8000) && (dataremaining >= 0x20) {
                  count = 0
                  while count < (0x20 / 4) {
                    data = sdmmc.readFIFO()
                    tempbuff!.pointee = UInt8(
                      truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (data & 0xFF))))
                    tempbuff = tempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    tempbuff!.pointee = UInt8(
                      truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 8) & 0xFF))))
                    tempbuff = tempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    tempbuff!.pointee = UInt8(
                      truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 16) & 0xFF))))
                    tempbuff = tempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    tempbuff!.pointee = UInt8(
                      truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 24) & 0xFF))))
                    tempbuff = tempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    if byte_count < 0x1e4 {
                      tempbuff = zero_pack.baseAddress
                    } else if byte_count == 0x1e4 {
                      tempbuff = echo_nonce.baseAddress
                    } else if byte_count == 0x1f4 {
                      tempbuff = tail_pack.baseAddress
                    } else {
                    }
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
              i = 0
              while i < 16 {
                if UInt32(local_nonce[Int(i)]) != UInt32(echo_nonce[Int(i)]) {
                  return .error
                }
                i = i &+ (1)
              }
            } else {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000_0000))
              return .error
            }
            tail_pack[Int(Int(11))] = UInt8(truncatingIfNeeded: 0x03)
            tail_pack[Int(Int(10))] = UInt8(truncatingIfNeeded: 0x00)
            tail_pack[Int(Int(7))] = UInt8(
              truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (NumberOfBlocks))) & 0xFF)
            tail_pack[Int(Int(6))] = UInt8(
              truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (NumberOfBlocks >> 8))) & 0xFF)
            tail_pack[Int(Int(5))] = UInt8(
              truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (BlockAdd))) & 0xFF)
            tail_pack[Int(Int(4))] = UInt8(
              truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (BlockAdd >> 8))) & 0xFF)
            rtempbuff = UnsafePointer(zero_pack.baseAddress!)
            byte_count = 0
            arg = arg | (NumberOfBlocks)
            if handle.read(.state) == 0x1 {
              handle.write(.errorCode, value: 0x0)
              handle.write(.state, value: 0x3)

              registers.write(.dctrl, value: 0)
              errorstate = sdmmc.commandBlockCount(arg, getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
                handle.write(.state, value: 0x1)
                return .error
              }

              config.dataTimeout = 0xffff_ffff
              config.dataLength = NumberOfBlocks &* 0x200
              config.dataBlockSize = 0x90
              config.transferDirection = 0x0
              config.transferMode = 0x0
              config.dpsm = 0x0
              _ = sdmmc.configureData(&config)
              sdmmc.enableCommandTransfer()

              do {
                handle.write(.transferContext, value: 0x20)

                errorstate = sdmmc.commandWriteMultipleBlocks(
                  0, getSystemCoreClock: getSystemCoreClock)
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
                    data = UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee)))
                    rtempbuff = rtempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 8))
                    rtempbuff = rtempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 16))
                    rtempbuff = rtempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 24))
                    rtempbuff = rtempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    _ = sdmmc.writeFIFO(&data)
                    // Reset the four-byte scratch buffer before the next padding word.
                    // The pinned C implementation advances beyond zero_pack here.
                    if byte_count < 0xc4 {
                      rtempbuff = UnsafePointer(zero_pack.baseAddress!)
                    } else if byte_count == 0xc4 {
                      rtempbuff = pMAC
                    }
                    if byte_count == 0xe4 {
                      rtempbuff = pData!.advanced(by: Int(offset))
                    }
                    if (byte_count >= 0x1e4) && (byte_count < 0x1f4) {
                      rtempbuff = UnsafePointer(zero_pack.baseAddress!)
                    }
                    if byte_count == 0x1f4 {
                      rtempbuff = UnsafePointer(tail_pack.baseAddress!)
                    } else if byte_count == 0x200 {
                      offset = offset &+ (UInt32(truncatingIfNeeded: 256))
                      byte_count = 0
                      rtempbuff = UnsafePointer(zero_pack.baseAddress!)
                    } else {
                    }
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

              errorstate = sdmmc.commandBlockCount(arg, getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
                handle.write(.state, value: 0x1)
                return .error
              }

              config.dataTimeout = 0xffff_ffff
              config.dataLength = 0x200
              config.dataBlockSize = 0x90
              config.transferDirection = 0x2
              config.transferMode = 0x0
              config.dpsm = 0x0
              _ = sdmmc.configureData(&config)
              sdmmc.enableCommandTransfer()

              do {
                handle.write(.transferContext, value: 0x2)

                errorstate = sdmmc.commandReadMultipleBlocks(
                  0, getSystemCoreClock: getSystemCoreClock)
              }
              if errorstate != 0x0 {
                sdmmc.clearFlag(0x1fe0_0fff)
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
                handle.write(.state, value: 0x1)
                return .error
              }

              sdmmc.clearFlag(0x1800_0f3a)

              tempbuff = zero_pack.baseAddress
              byte_count = 0
              dataremaining = config.dataLength
              while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
                if sdmmc.getFlag(0x8000) && (dataremaining >= 0x20) {
                  count = 0
                  while count < (0x20 / 4) {
                    data = sdmmc.readFIFO()
                    tempbuff!.pointee = UInt8(
                      truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (data & 0xFF))))
                    tempbuff = tempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    tempbuff!.pointee = UInt8(
                      truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 8) & 0xFF))))
                    tempbuff = tempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    tempbuff!.pointee = UInt8(
                      truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 16) & 0xFF))))
                    tempbuff = tempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    tempbuff!.pointee = UInt8(
                      truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 24) & 0xFF))))
                    tempbuff = tempbuff!.advanced(by: Int(1))
                    byte_count = byte_count &+ (1)
                    if byte_count < 0x1f4 {
                      tempbuff = zero_pack.baseAddress
                    } else if byte_count == 0x1f4 {
                      tempbuff = tail_pack.baseAddress
                    } else {
                    }
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

              if ((UInt32(tail_pack[Int(9)]) & UInt32(UInt8(truncatingIfNeeded: 0xFE))) != 0x00)
                || (UInt32(tail_pack[Int(10)]) != 0x03)
              {
                handle.writeRPMBErrorCode(
                  UInt16(
                    truncatingIfNeeded: UInt32(handle.readRPMBErrorCode())
                      | (UInt32(UInt32(tail_pack[Int(Int(9))])))))
                return .error
              }
              return .ok
            } else {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000_0000))
              return .error
            }

          }
        }
      }
    }
  }
  public func readRPMBBlocks(
    _ pData: UnsafeMutablePointer<UInt8>?, _ BlockAdd: UInt16, _ NumberOfBlocks: UInt16,
    _ pNonce: UnsafePointer<UInt8>?, _ pMAC: UnsafeMutablePointer<UInt8>?, _ Timeout: UInt32,
    getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 12) { tail_pack in
      tail_pack.initialize(repeating: 0)
      return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 4) { zero_pack in
        zero_pack.initialize(repeating: 0)
        return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 16) { echo_nonce in
          echo_nonce.initialize(repeating: 0)
          let BlockAdd = UInt32(BlockAdd)
          let NumberOfBlocks = UInt32(NumberOfBlocks)
          var config: SDMMCDataConfiguration = .init()
          var errorstate: UInt32 = 0
          var tickstart: UInt32 = 0
          var count: UInt32 = 0
          var byte_count: UInt32 = 0
          var data: UInt32 = 0
          var dataremaining: UInt32 = 0
          var rtempbuff: UnsafePointer<UInt8>? = nil
          var tempbuff: UnsafeMutablePointer<UInt8>? = nil
          var arg: UInt32 = 0
          var offset: UInt32 = 0
          var i: UInt32 = 0

          tickstart = getTick()

          byte_count = 0

          arg = 0
          offset = 0
          arg = arg | (NumberOfBlocks)
          tail_pack[Int(Int(11))] = UInt8(truncatingIfNeeded: 0x04)
          tail_pack[Int(Int(10))] = UInt8(truncatingIfNeeded: 0x00)
          tail_pack[Int(Int(7))] = UInt8(truncatingIfNeeded: 0x00)
          tail_pack[Int(Int(6))] = UInt8(truncatingIfNeeded: 0x00)
          tail_pack[Int(Int(5))] = UInt8(
            truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (BlockAdd))) & 0xFF)
          tail_pack[Int(Int(4))] = UInt8(
            truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (BlockAdd >> 8))) & 0xFF)
          tail_pack[Int(Int(3))] = UInt8(truncatingIfNeeded: 0x00)
          tail_pack[Int(Int(2))] = UInt8(truncatingIfNeeded: 0x00)
          tail_pack[Int(Int(1))] = UInt8(truncatingIfNeeded: 0x00)
          tail_pack[Int(Int(0))] = UInt8(truncatingIfNeeded: 0x00)
          if handle.read(.state) == 0x1 {
            handle.write(.errorCode, value: 0x0)
            handle.write(.state, value: 0x3)

            registers.write(.dctrl, value: 0)
            errorstate = sdmmc.commandBlockCount(1, getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              handle.write(.state, value: 0x1)
              return .error
            }

            config.dataTimeout = 0xffff_ffff
            config.dataLength = 0x200
            config.dataBlockSize = 0x90
            config.transferDirection = 0x0
            config.transferMode = 0x0
            config.dpsm = 0x0
            _ = sdmmc.configureData(&config)
            sdmmc.enableCommandTransfer()

            handle.write(.transferContext, value: 0x20)

            errorstate = sdmmc.commandWriteMultipleBlocks(0, getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              handle.write(.state, value: 0x1)
              return .error
            }

            rtempbuff = UnsafePointer(zero_pack.baseAddress!)
            dataremaining = config.dataLength
            while !sdmmc.getFlag(0x10 | 0x2 | 0x8 | 0x100) {
              if sdmmc.getFlag(0x4000) && (dataremaining >= 0x20) {

                count = 0
                while count < (0x20 / 4) {
                  data = UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee)))
                  rtempbuff = rtempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 8))
                  rtempbuff = rtempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 16))
                  rtempbuff = rtempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  data = data | ((UInt32(truncatingIfNeeded: (UInt32(rtempbuff!.pointee))) << 24))
                  rtempbuff = rtempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  _ = sdmmc.writeFIFO(&data)
                  if byte_count < 0x1e4 {
                    rtempbuff = UnsafePointer(zero_pack.baseAddress!)
                  } else if byte_count == 0x1e4 {
                    rtempbuff = pNonce
                  } else if byte_count == 0x1f4 {
                    rtempbuff = UnsafePointer(tail_pack.baseAddress!)
                  } else {
                  }
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

            errorstate = sdmmc.commandBlockCount(arg, getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              handle.write(.state, value: 0x1)
              return .error
            }

            config.dataTimeout = 0xffff_ffff
            config.dataLength = NumberOfBlocks &* 0x200
            config.dataBlockSize = 0x90
            config.transferDirection = 0x2
            config.transferMode = 0x0
            config.dpsm = 0x0
            _ = sdmmc.configureData(&config)
            sdmmc.enableCommandTransfer()

            handle.write(.transferContext, value: 0x2)

            errorstate = sdmmc.commandReadMultipleBlocks(0, getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              sdmmc.clearFlag(0x1fe0_0fff)
              handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              handle.write(.state, value: 0x1)
              return .error
            }

            sdmmc.clearFlag(0x1800_0f3a)

            tempbuff = zero_pack.baseAddress
            byte_count = 0
            dataremaining = config.dataLength
            while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
              if sdmmc.getFlag(0x8000) && (dataremaining >= 0x20) {
                count = 0
                while count < (0x20 / 4) {
                  data = sdmmc.readFIFO()
                  tempbuff!.pointee = UInt8(
                    truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (data & 0xFF))))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  tempbuff!.pointee = UInt8(
                    truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 8) & 0xFF))))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  tempbuff!.pointee = UInt8(
                    truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 16) & 0xFF))))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  tempbuff!.pointee = UInt8(
                    truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 24) & 0xFF))))
                  tempbuff = tempbuff!.advanced(by: Int(1))
                  byte_count = byte_count &+ (1)
                  if byte_count < 0xc4 {
                    tempbuff = zero_pack.baseAddress
                  } else if byte_count == 0xc4 {
                    tempbuff = pMAC
                  } else if byte_count == 0xe4 {
                    tempbuff = pData!.advanced(by: Int(offset))
                  } else if byte_count == 0x1e4 {
                    tempbuff = echo_nonce.baseAddress
                  } else if byte_count == 0x1f4 {
                    tempbuff = tail_pack.baseAddress
                  } else if byte_count == 0x200 {
                    byte_count = 0
                    offset = offset &+ (UInt32(truncatingIfNeeded: 256))
                    // Start the next frame in scratch storage, not past tail_pack.
                    tempbuff = zero_pack.baseAddress
                  } else {
                  }
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
            i = 0
            while i < 16 {
              if UInt32(pNonce![Int(i)]) != UInt32(echo_nonce[Int(i)]) {
                return .error
              }
              i = i &+ (1)
            }

            if (UInt32(tail_pack[Int(9)]) != 0x00) || (UInt32(tail_pack[Int(10)]) != 0x04) {
              handle.writeRPMBErrorCode(
                UInt16(
                  truncatingIfNeeded: UInt32(handle.readRPMBErrorCode())
                    | (UInt32(UInt32(tail_pack[Int(Int(9))])))))
              return .error
            }
            return .ok
          } else {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000_0000))
            return .error
          }

        }
      }
    }
  }
}
