// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDRAM {
  func dmaHead() -> UInt32 { dma.readMemory32(at: dma.read(.queueAddress)) }
  public func handleDMAEvent<Source: FMCDMAEventSourceIO>(
    _ kind: FMCDMACallbackKind, sourceContext: UnsafeMutableRawPointer?, source: Source
  ) {
    source.disable()
    switch kind {
    case .complete: handle.write(.state, value: 1)
    case .protectedComplete: handle.write(.state, value: 4)
    case .error: handle.write(.state, value: 3)
    }
    let id: SDRAMCallbackID = kind == .error ? .dmaError : .dmaComplete
    if useRegisteredCallbacks {
      callbacks.read(id)!(sourceContext)
    } else {
      defaults.callback(id)(sourceContext)
    }
  }

  public func readDMA(
    _ pAddress: UInt32, _ pDstBuffer: UnsafeMutablePointer<UInt32>?, _ BufferSize: UInt32
  ) -> HALStatus {
    var status: HALStatus = .ok
    var state: UInt32 = 0
    var size: UInt32 = 0
    var data_width: UInt32 = 0

    state = handle.read(.state)

    if state == 0x2 {
      status = .busy
    } else if (state == 0x1) || (state == 0x4) {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      if state == 0x1 {
        dma.writeCallback(.transferComplete, value: dma.callback(.complete))
      } else {
        dma.writeCallback(.transferComplete, value: dma.callback(.protectedComplete))
      }
      dma.writeCallback(.error, value: dma.callback(.error))
      if (dma.read(.mode) & 0x80) == 0x80 {
        if (dma.read(.queueAddress) != 0) && (dmaHead() != 0) {
          data_width = dma.readMemory32(at: dmaHead() &+ ((0x0) &* 4)) & 0x30000
          if data_width == 0x20000 {
            size = (BufferSize &* 4)
          } else if data_width == 0x10000 {
            size = (BufferSize &* 2)
          } else {
            size = (BufferSize)
          }

          dma.writeMemory32(at: dmaHead() &+ ((0x2) &* 4), value: size)

          dma.writeMemory32(at: dmaHead() &+ ((0x3) &* 4), value: pAddress)

          dma.writeMemory32(
            at: dmaHead() &+ ((0x4) &* 4),
            value: UInt32(truncatingIfNeeded: UInt(bitPattern: pDstBuffer)))

          status = dma.startLinkedListInterrupt()
        } else {
          handle.write(.lock, value: 0)
          status = .error
        }
      } else {
        data_width = dma.readDestinationDataWidth()
        if data_width == 0x20000 {
          size = (BufferSize &* 4)
        } else if data_width == 0x10000 {
          size = (BufferSize &* 2)
        } else {
          size = (BufferSize)
        }

        status = dma.startInterrupt(
          sourceAddress: pAddress,
          destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pDstBuffer)),
          sourceDataSize: size)
      }

      handle.write(.lock, value: 0)
    } else {
      status = .error
    }
    return status

  }
  public func writeDMA(
    _ pAddress: UInt32, _ pSrcBuffer: UnsafeMutablePointer<UInt32>?, _ BufferSize: UInt32
  ) -> HALStatus {
    var status: HALStatus = .ok
    var size: UInt32 = 0
    var data_width: UInt32 = 0

    if handle.read(.state) == 0x2 {
      status = .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      dma.writeCallback(.transferComplete, value: dma.callback(.complete))
      dma.writeCallback(.error, value: dma.callback(.error))
      if (dma.read(.mode) & 0x80) == 0x80 {
        if (dma.read(.queueAddress) != 0) && (dmaHead() != 0) {
          data_width = dma.readMemory32(at: dmaHead() &+ ((0x0) &* 4)) & 0x30000
          if data_width == 0x20000 {
            size = (BufferSize &* 4)
          } else if data_width == 0x10000 {
            size = (BufferSize &* 2)
          } else {
            size = (BufferSize)
          }

          dma.writeMemory32(at: dmaHead() &+ ((0x2) &* 4), value: size)

          dma.writeMemory32(
            at: dmaHead() &+ ((0x3) &* 4),
            value: UInt32(truncatingIfNeeded: UInt(bitPattern: pSrcBuffer)))

          dma.writeMemory32(at: dmaHead() &+ ((0x4) &* 4), value: pAddress)

          status = dma.startLinkedListInterrupt()
        } else {
          handle.write(.lock, value: 0)
          status = .error
        }
      } else {
        data_width = dma.readDestinationDataWidth()
        if data_width == 0x20000 {
          size = (BufferSize &* 4)
        } else if data_width == 0x10000 {
          size = (BufferSize &* 2)
        } else {
          size = (BufferSize)
        }

        status = dma.startInterrupt(
          sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: pSrcBuffer)),
          destinationAddress: pAddress, sourceDataSize: size)
      }

      handle.write(.lock, value: 0)
    } else {
      status = .error
    }
    return status

  }
}
