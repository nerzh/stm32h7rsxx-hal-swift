// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  func dmaMasterTransmitComplete() {

    var dmaxferstatus: HALStatus = .ok

    registers.write(.cr1, value: registers.read(.cr1) & (~0x4000))

    if UInt32(handle.read(.transferCount)) == 0 {
      enableIRQ(0x20)
    } else {
      advanceBuffer(UInt32(handle.read(.transferSize)))

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      }

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
          interruptError(0x10)
        }
      } else {
        dmaxferstatus = dma.startInterrupt(
          .transmit,
          sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())),
          destinationAddress: registers.address(of: .txdr),
          sourceDataSize: UInt32(handle.read(.transferSize)))
      }
      if dmaxferstatus != .ok {
        interruptError(0x10)
      } else {
        enableIRQ(0x40)
      }
    }

  }
  func dmaSlaveTransmitComplete() {

    let tmpoptions: UInt32 = handle.read(.transferOptions)
    if (tmpoptions == 0x1000000) || (tmpoptions == 0x0) {
      registers.write(.cr1, value: registers.read(.cr1) & (~0x4000))

      slaveSequenceComplete()
    } else {

    }

  }
  func dmaMasterReceiveComplete() {

    var dmaxferstatus: HALStatus = .ok

    registers.write(.cr1, value: registers.read(.cr1) & (~0x8000))

    if UInt32(handle.read(.transferCount)) == 0 {
      enableIRQ(0x20)
    } else {
      advanceBuffer(UInt32(handle.read(.transferSize)))

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      }

      if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
        if dma.read(.receive, word: .queueAddress) != 0 {
          dma.writeMemory32(
            .receive, at: dmaHead(.receive) &+ (0x2 * 4), value: UInt32(handle.read(.transferSize)))

          dma.writeMemory32(
            .receive, at: dmaHead(.receive) &+ (0x3 * 4), value: registers.address(of: .rxdr))

          dma.writeMemory32(
            .receive, at: dmaHead(.receive) &+ (0x4 * 4),
            value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())))
          dmaxferstatus = dma.startLinkedListInterrupt(.receive)
        } else {
          interruptError(0x10)
        }
      } else {
        dmaxferstatus = dma.startInterrupt(
          .receive, sourceAddress: registers.address(of: .rxdr),
          destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())),
          sourceDataSize: UInt32(handle.read(.transferSize)))
      }
      if dmaxferstatus != .ok {
        interruptError(0x10)
      } else {
        enableIRQ(0x40)
      }
    }

  }
  func dmaSlaveReceiveComplete() {

    let tmpoptions: UInt32 = handle.read(.transferOptions)
    if ((dma.getCounter(.receive) &+ dma.getFIFOLevel(.receive)) == 0)
      && (tmpoptions != 0xFFFF_0000)
    {
      registers.write(.cr1, value: registers.read(.cr1) & (~0x8000))

      slaveSequenceComplete()
    } else {

    }

  }
  func dmaError() {

    registers.write(.cr2, value: registers.read(.cr2) | (0x8000))

    interruptError(0x10)

  }
  func dmaAbort() {

    if dma.isPresent(.transmit) {
      dma.writeCallback(.transmit, id: .abort, value: nil)
    }
    if dma.isPresent(.receive) {
      dma.writeCallback(.receive, id: .abort, value: nil)
    }
    treatError()

  }
  func dmaHead(_ direction: UARTDMADirection) -> UInt32 {
    dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress))
  }
  public func dmaCallback(_ kind: I2CDMACallbackKind) {
    switch kind {
    case .masterTransmitComplete: dmaMasterTransmitComplete()
    case .masterReceiveComplete: dmaMasterReceiveComplete()
    case .slaveTransmitComplete: dmaSlaveTransmitComplete()
    case .slaveReceiveComplete: dmaSlaveReceiveComplete()
    case .error: dmaError()
    case .abort: dmaAbort()
    }
  }
}
