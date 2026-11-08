// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  public func masterTransmitDMA(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)

    var xfermode: UInt32
    var dmaxferstatus: HALStatus
    if handle.read(.state) == 0x20 {
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 4)
      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        xfermode = 0x1000000
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        xfermode = 0x2000000
      }
      if UInt32(handle.read(.transferSize)) > 0 {
        if dma.isPresent(.transmit) {
          dma.writeCallback(
            .transmit, id: .transferComplete, value: dma.callback(.masterTransmitComplete))

          dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

          dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
          dma.writeCallback(.transmit, id: .abort, value: nil)

          if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
            if dma.read(.transmit, word: .queueAddress) != 0 {
              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x2 * 4),
                value: UInt32(handle.read(.transferSize)))

              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x3 * 4),
                value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))

              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x4 * 4), value: registers.address(of: .txdr))
              dmaxferstatus = dma.startLinkedListInterrupt(.transmit)
            } else {
              handle.write(.state, value: 0x20)
              handle.write(.mode, value: 0x0)

              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              unlock()
              return .error
            }
          } else {
            dmaxferstatus = dma.startInterrupt(
              .transmit, sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
              destinationAddress: registers.address(of: .txdr),
              sourceDataSize: UInt32(handle.read(.transferSize)))
          }
        } else {
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

          unlock()
          return .error
        }
        if dmaxferstatus == .ok {

          transferConfiguration(
            UInt16(truncatingIfNeeded: DevAddress),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode,
            0x8000_2000)

          handle.write(
            .transferCount,
            value: UInt16(
              truncatingIfNeeded: UInt32(handle.read(.transferCount))
                &- (UInt32(handle.read(.transferSize)))))

          unlock()

          enableIRQ(0x10)

          registers.write(.cr1, value: registers.read(.cr1) | (0x4000))
        } else {
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

          unlock()
          return .error
        }
      } else {
        handle.write(.transferISR, value: 1)

        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          0x8000_2000)

        unlock()

        enableIRQ(0x1)
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func masterReceiveDMA(address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16)
    -> HALStatus
  {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)

    var xfermode: UInt32
    var dmaxferstatus: HALStatus
    if handle.read(.state) == 0x20 {
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 4)
      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        xfermode = 0x1000000
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        xfermode = 0x2000000
      }
      if UInt32(handle.read(.transferSize)) > 0 {
        if dma.isPresent(.receive) {
          dma.writeCallback(
            .receive, id: .transferComplete, value: dma.callback(.masterReceiveComplete))

          dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

          dma.writeCallback(.receive, id: .halfTransfer, value: nil)
          dma.writeCallback(.receive, id: .abort, value: nil)

          if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
            if dma.read(.receive, word: .queueAddress) != 0 {
              dma.writeMemory32(
                .receive, at: dmaHead(.receive) &+ (0x2 * 4),
                value: UInt32(handle.read(.transferSize)))

              dma.writeMemory32(
                .receive, at: dmaHead(.receive) &+ (0x3 * 4), value: registers.address(of: .rxdr))

              dma.writeMemory32(
                .receive, at: dmaHead(.receive) &+ (0x4 * 4),
                value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
              dmaxferstatus = dma.startLinkedListInterrupt(.receive)
            } else {
              handle.write(.state, value: 0x20)
              handle.write(.mode, value: 0x0)

              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              unlock()
              return .error
            }
          } else {
            dmaxferstatus = dma.startInterrupt(
              .receive, sourceAddress: registers.address(of: .rxdr),
              destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
              sourceDataSize: UInt32(handle.read(.transferSize)))
          }
        } else {
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

          unlock()
          return .error
        }
        if dmaxferstatus == .ok {

          transferConfiguration(
            UInt16(truncatingIfNeeded: DevAddress),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode,
            0x8000_2400)

          handle.write(
            .transferCount,
            value: UInt16(
              truncatingIfNeeded: UInt32(handle.read(.transferCount))
                &- (UInt32(handle.read(.transferSize)))))

          unlock()

          enableIRQ(0x10)

          registers.write(.cr1, value: registers.read(.cr1) | (0x8000))
        } else {
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

          unlock()
          return .error
        }
      } else {
        handle.write(.transferISR, value: 1)

        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          0x8000_2400)

        unlock()

        enableIRQ(0x2)
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveTransmitDMA(buffer: UnsafeMutablePointer<UInt8>?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    var dmaxferstatus: HALStatus
    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }
      guard lock() else { return .busy }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 6)

      if handle.read(.noStretchMode) == 0x20000 {

        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
      }
      if UInt32(handle.read(.transferCount)) != 0 {
        if dma.isPresent(.transmit) {
          dma.writeCallback(
            .transmit, id: .transferComplete, value: dma.callback(.slaveTransmitComplete))

          dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

          dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
          dma.writeCallback(.transmit, id: .abort, value: nil)

          if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
            if dma.read(.transmit, word: .queueAddress) != 0 {
              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x2 * 4),
                value: UInt32(handle.read(.transferSize)))

              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x3 * 4),
                value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())))

              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x4 * 4), value: registers.address(of: .txdr))
              dmaxferstatus = dma.startLinkedListInterrupt(.transmit)
            } else {
              handle.write(.state, value: 0x28)
              handle.write(.mode, value: 0x0)

              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              unlock()
              return .error
            }
          } else {
            dmaxferstatus = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())),
              destinationAddress: registers.address(of: .txdr),
              sourceDataSize: UInt32(handle.read(.transferSize)))
          }
        } else {
          handle.write(.state, value: 0x28)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

          unlock()
          return .error
        }
        if dmaxferstatus == .ok {
          registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

          unlock()

          enableIRQ(0x8000)

          registers.write(.cr1, value: registers.read(.cr1) | (0x4000))
        } else {
          handle.write(.state, value: 0x28)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

          unlock()
          return .error
        }
      } else {
        registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

        unlock()

        enableIRQ(0x8000)
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveReceiveDMA(buffer: UnsafeMutablePointer<UInt8>?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    var dmaxferstatus: HALStatus
    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }
      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 6)
      if dma.isPresent(.receive) {
        dma.writeCallback(
          .receive, id: .transferComplete, value: dma.callback(.slaveReceiveComplete))

        dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

        dma.writeCallback(.receive, id: .halfTransfer, value: nil)
        dma.writeCallback(.receive, id: .abort, value: nil)

        if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
          if dma.read(.receive, word: .queueAddress) != 0 {
            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x2 * 4),
              value: UInt32(handle.read(.transferSize)))

            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x3 * 4), value: registers.address(of: .rxdr))

            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x4 * 4),
              value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
            dmaxferstatus = dma.startLinkedListInterrupt(.receive)
          } else {
            handle.write(.state, value: 0x28)
            handle.write(.mode, value: 0x0)

            handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

            unlock()
            return .error
          }
        } else {
          dmaxferstatus = dma.startInterrupt(
            .receive, sourceAddress: registers.address(of: .rxdr),
            destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
            sourceDataSize: UInt32(handle.read(.transferSize)))
        }
      } else {
        handle.write(.state, value: 0x28)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

        unlock()
        return .error
      }
      if dmaxferstatus == .ok {
        registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

        unlock()

        enableIRQ(0x8000)

        registers.write(.cr1, value: registers.read(.cr1) | (0x8000))
      } else {
        handle.write(.state, value: 0x28)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

        unlock()
        return .error
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func writeMemoryDMA(
    address: UInt16, memoryAddress: UInt16, memoryAddressSize: UInt16,
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let MemAddress = UInt32(memoryAddress)
    let MemAddSize = UInt32(memoryAddressSize)
    let pData = buffer
    let Size = UInt32(count)

    var dmaxferstatus: HALStatus
    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x40)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 5)
      handle.write(.deviceAddress, value: DevAddress)
      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      }

      if MemAddSize == 0x1 {
        registers.write(.txdr, value: (MemAddress & 0xFF))

        handle.write(.memoryAddress, value: 0xFFFF_FFFF)
      } else {
        registers.write(.txdr, value: ((MemAddress & 0xFF00) >> 8))

        handle.write(.memoryAddress, value: (MemAddress & 0xFF))
      }
      if dma.isPresent(.transmit) {
        dma.writeCallback(
          .transmit, id: .transferComplete, value: dma.callback(.masterTransmitComplete))

        dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

        dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
        dma.writeCallback(.transmit, id: .abort, value: nil)

        if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
          if dma.read(.transmit, word: .queueAddress) != 0 {
            dma.writeMemory32(
              .transmit, at: dmaHead(.transmit) &+ (0x2 * 4),
              value: UInt32(handle.read(.transferSize)))

            dma.writeMemory32(
              .transmit, at: dmaHead(.transmit) &+ (0x3 * 4),
              value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))

            dma.writeMemory32(
              .transmit, at: dmaHead(.transmit) &+ (0x4 * 4), value: registers.address(of: .txdr))
            dmaxferstatus = dma.startLinkedListInterrupt(.transmit)
          } else {
            handle.write(.state, value: 0x20)
            handle.write(.mode, value: 0x0)

            handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

            unlock()
            return .error
          }
        } else {
          dmaxferstatus = dma.startInterrupt(
            .transmit, sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
            destinationAddress: registers.address(of: .txdr),
            sourceDataSize: UInt32(handle.read(.transferSize)))
        }
      } else {
        handle.write(.state, value: 0x20)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

        unlock()
        return .error
      }
      if dmaxferstatus == .ok {
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress), UInt8(truncatingIfNeeded: ((MemAddSize) & 0xFF)),
          0x1000000, 0x8000_2000)

        unlock()

        enableIRQ(0x1)
      } else {
        handle.write(.state, value: 0x20)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

        unlock()
        return .error
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func readMemoryDMA(
    address: UInt16, memoryAddress: UInt16, memoryAddressSize: UInt16,
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let MemAddress = UInt32(memoryAddress)
    let MemAddSize = UInt32(memoryAddressSize)
    let pData = buffer
    let Size = UInt32(count)

    var dmaxferstatus: HALStatus
    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x40)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 5)
      handle.write(.deviceAddress, value: DevAddress)
      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      }

      if MemAddSize == 0x1 {
        registers.write(.txdr, value: (MemAddress & 0xFF))

        handle.write(.memoryAddress, value: 0xFFFF_FFFF)
      } else {
        registers.write(.txdr, value: ((MemAddress & 0xFF00) >> 8))

        handle.write(.memoryAddress, value: (MemAddress & 0xFF))
      }
      if dma.isPresent(.receive) {
        dma.writeCallback(
          .receive, id: .transferComplete, value: dma.callback(.masterReceiveComplete))

        dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

        dma.writeCallback(.receive, id: .halfTransfer, value: nil)
        dma.writeCallback(.receive, id: .abort, value: nil)

        if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
          if dma.read(.receive, word: .queueAddress) != 0 {
            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x2 * 4),
              value: UInt32(handle.read(.transferSize)))

            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x3 * 4), value: registers.address(of: .rxdr))

            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x4 * 4),
              value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
            dmaxferstatus = dma.startLinkedListInterrupt(.receive)
          } else {
            handle.write(.state, value: 0x20)
            handle.write(.mode, value: 0x0)

            handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

            unlock()
            return .error
          }
        } else {
          dmaxferstatus = dma.startInterrupt(
            .receive, sourceAddress: registers.address(of: .rxdr),
            destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
            sourceDataSize: UInt32(handle.read(.transferSize)))
        }
      } else {
        handle.write(.state, value: 0x20)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

        unlock()
        return .error
      }
      if dmaxferstatus == .ok {
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress), UInt8(truncatingIfNeeded: ((MemAddSize) & 0xFF)),
          0x0, 0x8000_2000)

        unlock()

        enableIRQ(0x1)
      } else {
        handle.write(.state, value: 0x20)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

        unlock()
        return .error
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func masterSequentialTransmitDMA(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, options: UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)
    let XferOptions = options

    var xfermode: UInt32
    var xferrequest: UInt32 = 0x8000_2000
    var dmaxferstatus: HALStatus
    if handle.read(.state) == 0x20 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: XferOptions)
      handle.write(.transferISR, value: 4)

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        xfermode = 0x1000000
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        xfermode = handle.read(.transferOptions)
      }

      if (handle.read(.previousState) == 0x11)
        && ((((XferOptions == 0xAA) || (XferOptions == 0xAA00)) ? UInt32(1) : UInt32(0)) == 0)
      {
        xferrequest = 0x0
      } else {
        convertOtherTransferOptions()

        if UInt32(handle.read(.transferCount)) <= 0xFF {
          xfermode = handle.read(.transferOptions)
        }
      }
      if UInt32(handle.read(.transferSize)) > 0 {
        if dma.isPresent(.transmit) {
          dma.writeCallback(
            .transmit, id: .transferComplete, value: dma.callback(.masterTransmitComplete))

          dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

          dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
          dma.writeCallback(.transmit, id: .abort, value: nil)

          if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
            if dma.read(.transmit, word: .queueAddress) != 0 {
              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x2 * 4),
                value: UInt32(handle.read(.transferSize)))

              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x3 * 4),
                value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))

              dma.writeMemory32(
                .transmit, at: dmaHead(.transmit) &+ (0x4 * 4), value: registers.address(of: .txdr))
              dmaxferstatus = dma.startLinkedListInterrupt(.transmit)
            } else {
              handle.write(.state, value: 0x20)
              handle.write(.mode, value: 0x0)

              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              unlock()
              return .error
            }
          } else {
            dmaxferstatus = dma.startInterrupt(
              .transmit, sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
              destinationAddress: registers.address(of: .txdr),
              sourceDataSize: UInt32(handle.read(.transferSize)))
          }
        } else {
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

          unlock()
          return .error
        }
        if dmaxferstatus == .ok {
          transferConfiguration(
            UInt16(truncatingIfNeeded: DevAddress),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode,
            xferrequest)

          handle.write(
            .transferCount,
            value: UInt16(
              truncatingIfNeeded: UInt32(handle.read(.transferCount))
                &- (UInt32(handle.read(.transferSize)))))

          unlock()

          enableIRQ(0x10)

          registers.write(.cr1, value: registers.read(.cr1) | (0x4000))
        } else {
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

          unlock()
          return .error
        }
      } else {
        handle.write(.transferISR, value: 1)

        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          0x8000_2000)

        unlock()

        enableIRQ(0x1)
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func masterSequentialReceiveDMA(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, options: UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)
    let XferOptions = options

    var xfermode: UInt32
    var xferrequest: UInt32 = 0x8000_2400
    var dmaxferstatus: HALStatus
    if handle.read(.state) == 0x20 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: XferOptions)
      handle.write(.transferISR, value: 4)

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        xfermode = 0x1000000
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        xfermode = handle.read(.transferOptions)
      }

      if (handle.read(.previousState) == 0x12)
        && ((((XferOptions == 0xAA) || (XferOptions == 0xAA00)) ? UInt32(1) : UInt32(0)) == 0)
      {
        xferrequest = 0x0
      } else {
        convertOtherTransferOptions()

        if UInt32(handle.read(.transferCount)) <= 0xFF {
          xfermode = handle.read(.transferOptions)
        }
      }
      if UInt32(handle.read(.transferSize)) > 0 {
        if dma.isPresent(.receive) {
          dma.writeCallback(
            .receive, id: .transferComplete, value: dma.callback(.masterReceiveComplete))

          dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

          dma.writeCallback(.receive, id: .halfTransfer, value: nil)
          dma.writeCallback(.receive, id: .abort, value: nil)

          if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
            if dma.read(.receive, word: .queueAddress) != 0 {
              dma.writeMemory32(
                .receive, at: dmaHead(.receive) &+ (0x2 * 4),
                value: UInt32(handle.read(.transferSize)))

              dma.writeMemory32(
                .receive, at: dmaHead(.receive) &+ (0x3 * 4), value: registers.address(of: .rxdr))

              dma.writeMemory32(
                .receive, at: dmaHead(.receive) &+ (0x4 * 4),
                value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
              dmaxferstatus = dma.startLinkedListInterrupt(.receive)
            } else {
              handle.write(.state, value: 0x20)
              handle.write(.mode, value: 0x0)

              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              unlock()
              return .error
            }
          } else {
            dmaxferstatus = dma.startInterrupt(
              .receive, sourceAddress: registers.address(of: .rxdr),
              destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
              sourceDataSize: UInt32(handle.read(.transferSize)))
          }
        } else {
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

          unlock()
          return .error
        }
        if dmaxferstatus == .ok {
          transferConfiguration(
            UInt16(truncatingIfNeeded: DevAddress),
            UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode,
            xferrequest)

          handle.write(
            .transferCount,
            value: UInt16(
              truncatingIfNeeded: UInt32(handle.read(.transferCount))
                &- (UInt32(handle.read(.transferSize)))))

          unlock()

          enableIRQ(0x10)

          registers.write(.cr1, value: registers.read(.cr1) | (0x8000))
        } else {
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

          unlock()
          return .error
        }
      } else {
        handle.write(.transferISR, value: 1)

        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          0x8000_2400)

        unlock()

        enableIRQ(0x2)
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveSequentialTransmitDMA(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, options: UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let XferOptions = options

    var tmp: UInt32
    var dmaxferstatus: HALStatus
    if ((handle.read(.state)) & (0x28)) == (0x28) {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }

      guard lock() else { return .busy }

      disableIRQ(0x8000 | 0x1)

      if handle.read(.state) == 0x2A {
        disableIRQ(0x2)
        if (registers.read(.cr1) & 0x8000) == 0x8000 {
          if dma.isPresent(.receive) {
            registers.write(.cr1, value: registers.read(.cr1) & (~0x8000))

            dma.writeCallback(.receive, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.receive) != .ok {
              dma.invokeCallback(.receive, id: .abort)
            }
          }
        }
      } else if handle.read(.state) == 0x29 {
        if (registers.read(.cr1) & 0x4000) == 0x4000 {
          registers.write(.cr1, value: registers.read(.cr1) & (~0x4000))

          if dma.isPresent(.transmit) {
            dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.transmit) != .ok {
              dma.invokeCallback(.transmit, id: .abort)
            }
          }
        }
      } else {
      }
      handle.write(.state, value: 0x29)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferOptions, value: XferOptions)
      handle.write(.transferISR, value: 6)
      if dma.isPresent(.transmit) {
        dma.writeCallback(
          .transmit, id: .transferComplete, value: dma.callback(.slaveTransmitComplete))

        dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

        dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
        dma.writeCallback(.transmit, id: .abort, value: nil)

        if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
          if dma.read(.transmit, word: .queueAddress) != 0 {
            dma.writeMemory32(
              .transmit, at: dmaHead(.transmit) &+ (0x2 * 4),
              value: UInt32(handle.read(.transferSize)))

            dma.writeMemory32(
              .transmit, at: dmaHead(.transmit) &+ (0x3 * 4),
              value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))

            dma.writeMemory32(
              .transmit, at: dmaHead(.transmit) &+ (0x4 * 4), value: registers.address(of: .txdr))
            dmaxferstatus = dma.startLinkedListInterrupt(.transmit)
          } else {
            handle.write(.state, value: 0x28)
            handle.write(.mode, value: 0x0)

            handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

            unlock()
            return .error
          }
        } else {
          dmaxferstatus = dma.startInterrupt(
            .transmit, sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
            destinationAddress: registers.address(of: .txdr),
            sourceDataSize: UInt32(handle.read(.transferSize)))
        }
      } else {
        handle.write(.state, value: 0x28)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

        unlock()
        return .error
      }
      if dmaxferstatus == .ok {
        handle.write(
          .transferCount,
          value: UInt16(
            truncatingIfNeeded: UInt32(handle.read(.transferCount))
              &- (UInt32(handle.read(.transferSize)))))

        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0))
      } else {
        handle.write(.state, value: 0x28)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

        unlock()
        return .error
      }
      tmp = getFlag(0x8)
      if (UInt32(direction()) == 0x1) && (tmp != 0) {

        clearFlag(0x8)
      }

      unlock()

      registers.write(.cr1, value: registers.read(.cr1) | (0x4000))

      enableIRQ(0x8000)
      return .ok
    } else {
      return .error
    }

  }
  public func slaveSequentialReceiveDMA(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, options: UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let XferOptions = options

    var tmp: UInt32
    var dmaxferstatus: HALStatus
    if ((handle.read(.state)) & (0x28)) == (0x28) {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }

      disableIRQ(0x8000 | 0x2)

      guard lock() else { return .busy }

      if handle.read(.state) == 0x29 {
        disableIRQ(0x1)
        if (registers.read(.cr1) & 0x4000) == 0x4000 {
          if dma.isPresent(.transmit) {
            registers.write(.cr1, value: registers.read(.cr1) & (~0x4000))

            dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.transmit) != .ok {
              dma.invokeCallback(.transmit, id: .abort)
            }
          }
        }
      } else if handle.read(.state) == 0x2A {
        if (registers.read(.cr1) & 0x8000) == 0x8000 {
          registers.write(.cr1, value: registers.read(.cr1) & (~0x8000))

          if dma.isPresent(.receive) {
            dma.writeCallback(.receive, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.receive) != .ok {
              dma.invokeCallback(.receive, id: .abort)
            }
          }
        }
      } else {
      }
      handle.write(.state, value: 0x2A)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferOptions, value: XferOptions)
      handle.write(.transferISR, value: 6)
      if dma.isPresent(.receive) {
        dma.writeCallback(
          .receive, id: .transferComplete, value: dma.callback(.slaveReceiveComplete))

        dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

        dma.writeCallback(.receive, id: .halfTransfer, value: nil)
        dma.writeCallback(.receive, id: .abort, value: nil)

        if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
          if dma.read(.receive, word: .queueAddress) != 0 {
            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x2 * 4),
              value: UInt32(handle.read(.transferSize)))

            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x3 * 4), value: registers.address(of: .rxdr))

            dma.writeMemory32(
              .receive, at: dmaHead(.receive) &+ (0x4 * 4),
              value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
            dmaxferstatus = dma.startLinkedListInterrupt(.receive)
          } else {
            handle.write(.state, value: 0x28)
            handle.write(.mode, value: 0x0)

            handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

            unlock()
            return .error
          }
        } else {
          dmaxferstatus = dma.startInterrupt(
            .receive, sourceAddress: registers.address(of: .rxdr),
            destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
            sourceDataSize: UInt32(handle.read(.transferSize)))
        }
      } else {
        handle.write(.state, value: 0x28)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

        unlock()
        return .error
      }
      if dmaxferstatus == .ok {
        handle.write(
          .transferCount,
          value: UInt16(
            truncatingIfNeeded: UInt32(handle.read(.transferCount))
              &- (UInt32(handle.read(.transferSize)))))

        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0))
      } else {
        handle.write(.state, value: 0x28)
        handle.write(.mode, value: 0x0)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

        unlock()
        return .error
      }
      tmp = getFlag(0x8)
      if (UInt32(direction()) == 0x0) && (tmp != 0) {

        clearFlag(0x8)
      }

      unlock()

      registers.write(.cr1, value: registers.read(.cr1) | (0x8000))

      enableIRQ(0x2 | 0x8000)
      return .ok
    } else {
      return .error
    }

  }
}
