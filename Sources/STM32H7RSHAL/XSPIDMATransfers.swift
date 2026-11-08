// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func transmitDMA(_ pData: UnsafePointer<UInt8>?) -> HALStatus {

    var status: HALStatus = .ok
    let data_size: UInt32 = registers.read(.dlr) &+ 1
    var p_queue: UInt32 = 0
    var data_width: UInt32 = 0x0

    if pData == nil {
      status = .error
      handle.write(.errorCode, value: 0x8)
    } else {
      if handle.read(.state) == 0x4 {
        if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
          p_queue = dma.read(.transmit, word: .queueAddress)
          if (p_queue != 0) && (dma.readMemory32(.transmit, at: p_queue) != 0) {
            data_width =
              dma.readMemory32(
                .transmit, at: dma.readMemory32(.transmit, at: p_queue) &+ (0x0 &* 4)) & 0x30000
          } else {
            handle.write(.errorCode, value: 0x4)

            status = .error
          }
        } else {
          data_width = dma.readConfiguration(.transmit, word: .destinationDataWidth)
        }
        if data_width == 0x0 {
          handle.write(.transferCount, value: data_size)
        } else if data_width == 0x10000 {
          if ((data_size % 2) != 0) || ((handle.read(.fifoThresholdByte) % 2) != 0) {
            handle.write(.errorCode, value: 0x8)
            status = .error
          } else {
            handle.write(.transferCount, value: data_size)
          }
        } else if data_width == 0x20000 {
          if ((data_size % 4) != 0) || ((handle.read(.fifoThresholdByte) % 4) != 0) {
            handle.write(.errorCode, value: 0x8)
            status = .error
          } else {
            handle.write(.transferCount, value: data_size)
          }
        } else {
        }
        if status == .ok {
          handle.write(.transferSize, value: handle.read(.transferCount))
          handle.writeBuffer(UnsafeMutablePointer(mutating: pData))

          registers.write(.cr, value: (registers.read(.cr) & ~(0x3000_0000)) | (0x0))

          clearFlags(0x1 | 0x2)

          handle.write(.state, value: 0x18)

          dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.complete))

          dma.writeCallback(.transmit, id: .halfTransfer, value: dma.callback(.halfComplete))

          dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

          dma.writeCallback(.transmit, id: .abort, value: nil)

          if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
            if dma.read(.transmit, word: .queueAddress) != 0 {
              dma.writeMemory32(
                .transmit, at: dma.readMemory32(.transmit, at: p_queue) &+ (0x0 &* 4),
                value: (dma.readMemory32(
                  .transmit, at: dma.readMemory32(.transmit, at: p_queue) &+ (0x0 &* 4))
                  & ~((0x8 | 0x80000))) | ((0x8 | 0x0)))
              dma.writeMemory32(
                .transmit, at: dma.readMemory32(.transmit, at: p_queue) &+ (0x1 &* 4),
                value: (dma.readMemory32(
                  .transmit, at: dma.readMemory32(.transmit, at: p_queue) &+ (0x1 &* 4)) & ~(0x400))
                  | (0x400))
              dma.writeMemory32(
                .transmit, at: dma.readMemory32(.transmit, at: p_queue) &+ (0x2 &* 4),
                value: handle.read(.transferSize))
              dma.writeMemory32(
                .transmit, at: dma.readMemory32(.transmit, at: p_queue) &+ (0x3 &* 4),
                value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
              dma.writeMemory32(
                .transmit, at: dma.readMemory32(.transmit, at: p_queue) &+ (0x4 &* 4),
                value: registers.address(of: .dr))
              status = dma.startLinkedListInterrupt(.transmit)
            } else {
              handle.write(.errorCode, value: 0x4)
              handle.write(.state, value: 0x2)

              status = .error
            }
          } else {
            if (dma.readConfiguration(.transmit, word: .direction) == 0x400)
              && (dma.readConfiguration(.transmit, word: .sourceIncrement) == 0x8)
              && (dma.readConfiguration(.transmit, word: .destinationIncrement) == 0x0)
            {
              status = dma.startInterrupt(
                .transmit, sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
                destinationAddress: registers.address(of: .dr),
                sourceDataSize: handle.read(.transferSize))
            } else {
              handle.write(.errorCode, value: 0x8)
              status = .error
            }
          }
          if status == .ok {
            enableInterrupts(0x10000)

            registers.write(.cr, value: registers.read(.cr) | (0x4))
          } else {
            status = .error
            handle.write(.errorCode, value: 0x4)
            handle.write(.state, value: 0x2)
          }
        }
      } else {
        status = .error
        handle.write(.errorCode, value: 0x10)
      }
    }
    return status

  }
  public func receiveDMA(_ pData: UnsafeMutablePointer<UInt8>?) -> HALStatus {

    var status: HALStatus = .ok
    let data_size: UInt32 = registers.read(.dlr) &+ 1
    let addr_reg: UInt32 = registers.read(.ar)
    let ir_reg: UInt32 = registers.read(.ir)
    var p_queue: UInt32 = 0
    var data_width: UInt32 = 0x0

    if pData == nil {
      status = .error
      handle.write(.errorCode, value: 0x8)
    } else {
      if handle.read(.state) == 0x4 {
        if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
          p_queue = dma.read(.receive, word: .queueAddress)
          if (p_queue != 0) && (dma.readMemory32(.receive, at: p_queue) != 0) {
            data_width =
              dma.readMemory32(.receive, at: dma.readMemory32(.receive, at: p_queue) &+ (0x0 &* 4))
              & 0x30000
          } else {
            handle.write(.errorCode, value: 0x4)

            status = .error
          }
        } else {
          data_width = dma.readConfiguration(.receive, word: .destinationDataWidth)
        }

        if data_width == 0x0 {
          handle.write(.transferCount, value: data_size)
        } else if data_width == 0x10000 {
          if ((data_size % 2) != 0) || ((handle.read(.fifoThresholdByte) % 2) != 0) {
            handle.write(.errorCode, value: 0x8)
            status = .error
          } else {
            handle.write(.transferCount, value: data_size)
          }
        } else if data_width == 0x20000 {
          if ((data_size % 4) != 0) || ((handle.read(.fifoThresholdByte) % 4) != 0) {
            handle.write(.errorCode, value: 0x8)
            status = .error
          } else {
            handle.write(.transferCount, value: data_size)
          }
        } else {
        }
        if status == .ok {
          handle.write(.transferSize, value: handle.read(.transferCount))
          handle.writeBuffer(pData)

          registers.write(.cr, value: (registers.read(.cr) & ~(0x3000_0000)) | (0x1000_0000))

          clearFlags(0x1 | 0x2)

          handle.write(.state, value: 0x28)

          dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.complete))

          dma.writeCallback(.receive, id: .halfTransfer, value: dma.callback(.halfComplete))

          dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

          dma.writeCallback(.receive, id: .abort, value: nil)

          if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
            if dma.read(.receive, word: .queueAddress) != 0 {
              dma.writeMemory32(
                .receive, at: dma.readMemory32(.receive, at: p_queue) &+ (0x0 &* 4),
                value: (dma.readMemory32(
                  .receive, at: dma.readMemory32(.receive, at: p_queue) &+ (0x0 &* 4))
                  & ~((0x8 | 0x80000))) | ((0x0 | 0x80000)))
              dma.writeMemory32(
                .receive, at: dma.readMemory32(.receive, at: p_queue) &+ (0x1 &* 4),
                value: (dma.readMemory32(
                  .receive, at: dma.readMemory32(.receive, at: p_queue) &+ (0x1 &* 4)) & ~(0x400))
                  | (0x0))
              dma.writeMemory32(
                .receive, at: dma.readMemory32(.receive, at: p_queue) &+ (0x2 &* 4),
                value: handle.read(.transferSize))
              dma.writeMemory32(
                .receive, at: dma.readMemory32(.receive, at: p_queue) &+ (0x3 &* 4),
                value: registers.address(of: .dr))
              dma.writeMemory32(
                .receive, at: dma.readMemory32(.receive, at: p_queue) &+ (0x4 &* 4),
                value: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)))
              status = dma.startLinkedListInterrupt(.receive)
            } else {
              handle.write(.errorCode, value: 0x4)
              handle.write(.state, value: 0x2)

              status = .error
            }
          } else {
            if (dma.readConfiguration(.receive, word: .direction) == 0x0)
              && (dma.readConfiguration(.receive, word: .sourceIncrement) == 0x0)
              && (dma.readConfiguration(.receive, word: .destinationIncrement) == 0x80000)
            {
              status = dma.startInterrupt(
                .receive, sourceAddress: registers.address(of: .dr),
                destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
                sourceDataSize: handle.read(.transferSize))
            } else {
              handle.write(.errorCode, value: 0x8)
              status = .error
            }
          }
          if status == .ok {
            enableInterrupts(0x10000)

            if handle.read(.memoryType) == 0x4000000 {
              registers.write(.ar, value: addr_reg)
            } else {
              if (registers.read(.ccr) & 0x700) != 0x0 {
                registers.write(.ar, value: addr_reg)
              } else {
                registers.write(.ir, value: ir_reg)
              }
            }

            registers.write(.cr, value: registers.read(.cr) | (0x4))
          } else {
            status = .error
            handle.write(.errorCode, value: 0x4)
            handle.write(.state, value: 0x2)
          }
        }
      } else {
        status = .error
        handle.write(.errorCode, value: 0x10)
      }
    }
    return status

  }
}
