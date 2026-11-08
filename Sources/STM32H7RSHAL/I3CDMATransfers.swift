// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func controllerTransmitCCCDMA(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, getTick: () -> UInt32
  ) -> HALStatus {

    var control_dma_status: HALStatus
    var tx_dma_status: HALStatus = .ok
    var handle_state: UInt32
    var status: HALStatus = .ok
    var size_align_word: UInt32

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil)
        || ((handle.read(.transmitTransferCount) != 0)
          && (pXferData!.pointee.transmitBuffer.buffer == nil))
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (!dma.isPresent(.transmit)) || (!dma.isPresent(.control)) {
        handle.write(.errorCode, value: 0x40000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.transferISR, value: I3CTransferISR.controllerTransmitDMA.rawValue)
        handle.writeTransfer(pXferData)
        handle.write(.state, value: 0x21)

        dma.writeCallback(
          .control, id: .transferComplete, value: dma.callback(.controlTransmitComplete))

        dma.writeCallback(.control, id: .error, value: dma.callback(.error))

        dma.writeCallback(.control, id: .halfTransfer, value: nil)
        dma.writeCallback(.control, id: .abort, value: nil)

        control_dma_status = dma.startInterrupt(
          .control,
          sourceAddress: UInt32(
            truncatingIfNeeded: UInt(
              bitPattern: handle.readTransfer()!.pointee.controlBuffer.buffer)),
          destinationAddress: registers.address(of: .cr),
          sourceDataSize: (handle.read(.controlTransferCount) &* 4))

        if handle.read(.transmitTransferCount) != 0 {
          dma.writeCallback(
            .transmit, id: .transferComplete, value: dma.callback(.dataTransmitComplete))

          dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

          dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
          dma.writeCallback(.transmit, id: .abort, value: nil)

          if llGetTxFIFOThreshold() == 0x0 {

            tx_dma_status = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
              destinationAddress: registers.address(of: .tdr),
              sourceDataSize: handle.readTransfer()!.pointee.transmitBuffer.size)
          } else {

            if (handle.readTransfer()!.pointee.transmitBuffer.size % 4) == 0 {
              size_align_word = handle.readTransfer()!.pointee.transmitBuffer.size
            } else {
              size_align_word =
                ((handle.readTransfer()!.pointee.transmitBuffer.size &+ 4)
                  &- (handle.readTransfer()!.pointee.transmitBuffer.size % 4))
            }

            tx_dma_status = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
              destinationAddress: registers.address(of: .tdwr), sourceDataSize: size_align_word)
          }
        }

        if (control_dma_status == .ok) && (tx_dma_status == .ok) {

          enableTransferInterrupts(0x8)

          handle.write(.controlTransferCount, value: 0)

          llEnableDMAReqControl()

          if handle.read(.transmitTransferCount) != 0 {
            handle.write(.transmitTransferCount, value: 0)

            llEnableDMAReqTX()
          }

          llRequestTransfer()
        } else {
          if dma.abort(.control, getTick: getTick) == .ok {
            dma.writeCallback(.control, id: .transferComplete, value: nil)
            dma.writeCallback(.control, id: .error, value: nil)
          }

          if dma.abort(.transmit, getTick: getTick) == .ok {
            dma.writeCallback(.transmit, id: .transferComplete, value: nil)
            dma.writeCallback(.transmit, id: .error, value: nil)
          }
          handle.write(.errorCode, value: 0x10000)
          status = .error

          updateState()
        }
      }
    }
    return status

  }
  public func controllerReceiveCCCDMA(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, getTick: () -> UInt32
  ) -> HALStatus {

    var handle_state: UInt32
    var status: HALStatus = .ok
    var control_dma_status: HALStatus
    var tx_dma_status: HALStatus = .ok
    var rx_dma_status: HALStatus = .ok
    var size_align_word: UInt32

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil) || (pXferData!.pointee.receiveBuffer.buffer == nil)
        || ((pXferData!.pointee.transmitBuffer.buffer == nil)
          && (handle.read(.transmitTransferCount) != 0))
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (!dma.isPresent(.receive)) || (!dma.isPresent(.control)) {
        handle.write(.errorCode, value: 0x40000)
        status = .error
      } else if (handle.read(.transmitTransferCount) != 0) && (!dma.isPresent(.transmit)) {
        handle.write(.errorCode, value: 0x40000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.transferISR, value: I3CTransferISR.controllerReceiveDMA.rawValue)
        handle.writeTransfer(pXferData)
        handle.write(
          .receiveTransferCount, value: handle.readTransfer()!.pointee.receiveBuffer.size)
        handle.write(.state, value: 0x22)

        dma.writeCallback(
          .control, id: .transferComplete, value: dma.callback(.controlTransmitComplete))

        dma.writeCallback(.control, id: .error, value: dma.callback(.error))

        dma.writeCallback(.control, id: .halfTransfer, value: nil)
        dma.writeCallback(.control, id: .abort, value: nil)

        control_dma_status = dma.startInterrupt(
          .control,
          sourceAddress: UInt32(
            truncatingIfNeeded: UInt(
              bitPattern: handle.readTransfer()!.pointee.controlBuffer.buffer)),
          destinationAddress: registers.address(of: .cr),
          sourceDataSize: (handle.read(.controlTransferCount) &* 4))

        if handle.read(.transmitTransferCount) != 0 {
          dma.writeCallback(
            .transmit, id: .transferComplete, value: dma.callback(.dataTransmitComplete))

          dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

          dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
          dma.writeCallback(.transmit, id: .abort, value: nil)

          if llGetTxFIFOThreshold() == 0x0 {

            tx_dma_status = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
              destinationAddress: registers.address(of: .tdr),
              sourceDataSize: handle.readTransfer()!.pointee.transmitBuffer.size)
          } else {

            size_align_word =
              ((handle.readTransfer()!.pointee.transmitBuffer.size &+ 4)
                &- (handle.readTransfer()!.pointee.transmitBuffer.size % 4))

            tx_dma_status = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
              destinationAddress: registers.address(of: .tdwr), sourceDataSize: size_align_word)
          }
        }

        if handle.read(.receiveTransferCount) != 0 {
          dma.writeCallback(
            .receive, id: .transferComplete, value: dma.callback(.dataReceiveComplete))

          dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

          dma.writeCallback(.receive, id: .halfTransfer, value: nil)
          dma.writeCallback(.receive, id: .abort, value: nil)

          if llGetRxFIFOThreshold() == 0x0 {

            rx_dma_status = dma.startInterrupt(
              .receive, sourceAddress: registers.address(of: .rdr),
              destinationAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.receiveBuffer.buffer)),
              sourceDataSize: handle.readTransfer()!.pointee.receiveBuffer.size)
          } else {

            if (handle.readTransfer()!.pointee.receiveBuffer.size % 4) == 0 {
              size_align_word = handle.readTransfer()!.pointee.receiveBuffer.size
            } else {
              size_align_word =
                ((handle.readTransfer()!.pointee.receiveBuffer.size &+ 4)
                  &- (handle.readTransfer()!.pointee.receiveBuffer.size % 4))
            }

            rx_dma_status = dma.startInterrupt(
              .receive, sourceAddress: registers.address(of: .rdwr),
              destinationAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.receiveBuffer.buffer)),
              sourceDataSize: size_align_word)
          }
        }

        if (control_dma_status == .ok) && (tx_dma_status == .ok) && (rx_dma_status == .ok) {

          enableTransferInterrupts(0x8)

          handle.write(.controlTransferCount, value: 0)

          llEnableDMAReqControl()

          if handle.read(.transmitTransferCount) != 0 {
            handle.write(.transmitTransferCount, value: 0)

            llEnableDMAReqTX()
          }

          if handle.read(.receiveTransferCount) != 0 {
            handle.write(.receiveTransferCount, value: 0)

            llEnableDMAReqRX()
          }

          llRequestTransfer()
        } else {
          if dma.abort(.control, getTick: getTick) == .ok {
            dma.writeCallback(.control, id: .transferComplete, value: nil)
            dma.writeCallback(.control, id: .error, value: nil)
          }

          if dma.abort(.transmit, getTick: getTick) == .ok {
            dma.writeCallback(.transmit, id: .transferComplete, value: nil)
            dma.writeCallback(.transmit, id: .error, value: nil)
          }

          if dma.abort(.receive, getTick: getTick) == .ok {
            dma.writeCallback(.receive, id: .transferComplete, value: nil)
            dma.writeCallback(.receive, id: .error, value: nil)
          }
          handle.write(.errorCode, value: 0x10000)
          status = .error

          updateState()
        }
      }
    }
    return status

  }
  public func controllerTransmitDMA(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, getTick: () -> UInt32
  ) -> HALStatus {

    var control_dma_status: HALStatus
    var tx_dma_status: HALStatus = .ok
    var handle_state: UInt32
    var status: HALStatus = .ok
    var size_align_word: UInt32

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil)
        || ((handle.read(.transmitTransferCount) != 0)
          && (pXferData!.pointee.transmitBuffer.buffer == nil))
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (!dma.isPresent(.transmit)) || (!dma.isPresent(.control)) {
        handle.write(.errorCode, value: 0x40000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.transferISR, value: I3CTransferISR.controllerTransmitDMA.rawValue)
        handle.write(.state, value: 0x21)
        handle.writeTransfer(pXferData)

        dma.writeCallback(
          .control, id: .transferComplete, value: dma.callback(.controlTransmitComplete))

        dma.writeCallback(.control, id: .error, value: dma.callback(.error))

        dma.writeCallback(.control, id: .halfTransfer, value: nil)
        dma.writeCallback(.control, id: .abort, value: nil)

        control_dma_status = dma.startInterrupt(
          .control,
          sourceAddress: UInt32(
            truncatingIfNeeded: UInt(
              bitPattern: handle.readTransfer()!.pointee.controlBuffer.buffer)),
          destinationAddress: registers.address(of: .cr),
          sourceDataSize: (handle.read(.controlTransferCount) &* 4))

        if handle.read(.transmitTransferCount) != 0 {
          dma.writeCallback(
            .transmit, id: .transferComplete, value: dma.callback(.dataTransmitComplete))

          dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

          dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
          dma.writeCallback(.transmit, id: .abort, value: nil)

          if llGetTxFIFOThreshold() == 0x0 {

            tx_dma_status = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
              destinationAddress: registers.address(of: .tdr),
              sourceDataSize: handle.readTransfer()!.pointee.transmitBuffer.size)
          } else {

            if (handle.readTransfer()!.pointee.transmitBuffer.size % 4) == 0 {
              size_align_word = handle.readTransfer()!.pointee.transmitBuffer.size
            } else {
              size_align_word =
                ((handle.readTransfer()!.pointee.transmitBuffer.size &+ 4)
                  &- (handle.readTransfer()!.pointee.transmitBuffer.size % 4))
            }

            tx_dma_status = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
              destinationAddress: registers.address(of: .tdwr), sourceDataSize: size_align_word)
          }
        }

        if (control_dma_status == .ok) && (tx_dma_status == .ok) {

          enableTransferInterrupts(0x8)

          handle.write(.controlTransferCount, value: 0)

          llEnableDMAReqControl()

          if handle.read(.transmitTransferCount) != 0 {
            handle.write(.transmitTransferCount, value: 0)

            llEnableDMAReqTX()
          }

          llRequestTransfer()
        } else {
          if dma.abort(.control, getTick: getTick) == .ok {
            dma.writeCallback(.control, id: .transferComplete, value: nil)
            dma.writeCallback(.control, id: .error, value: nil)
          }

          if dma.abort(.transmit, getTick: getTick) == .ok {
            dma.writeCallback(.transmit, id: .transferComplete, value: nil)
            dma.writeCallback(.transmit, id: .error, value: nil)
          }
          handle.write(.errorCode, value: 0x10000)
          status = .error

          updateState()
        }
      }
    }
    return status

  }
  public func controllerReceiveDMA(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, getTick: () -> UInt32
  ) -> HALStatus {

    var control_dma_status: HALStatus
    var rx_dma_status: HALStatus = .ok
    var handle_state: UInt32
    var status: HALStatus = .ok
    var size_align_word: UInt32

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil) || (pXferData!.pointee.receiveBuffer.buffer == nil) {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (!dma.isPresent(.receive)) || (!dma.isPresent(.control)) {
        handle.write(.errorCode, value: 0x40000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.transferISR, value: I3CTransferISR.controllerReceiveDMA.rawValue)
        handle.writeTransfer(pXferData)
        handle.write(
          .receiveTransferCount, value: handle.readTransfer()!.pointee.receiveBuffer.size)
        handle.write(.state, value: 0x22)

        dma.writeCallback(
          .control, id: .transferComplete, value: dma.callback(.controlTransmitComplete))

        dma.writeCallback(.control, id: .error, value: dma.callback(.error))

        dma.writeCallback(.control, id: .halfTransfer, value: nil)
        dma.writeCallback(.control, id: .abort, value: nil)

        control_dma_status = dma.startInterrupt(
          .control,
          sourceAddress: UInt32(
            truncatingIfNeeded: UInt(
              bitPattern: handle.readTransfer()!.pointee.controlBuffer.buffer)),
          destinationAddress: registers.address(of: .cr),
          sourceDataSize: (handle.read(.controlTransferCount) &* 4))

        if handle.read(.receiveTransferCount) != 0 {
          dma.writeCallback(
            .receive, id: .transferComplete, value: dma.callback(.dataReceiveComplete))

          dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

          dma.writeCallback(.receive, id: .halfTransfer, value: nil)
          dma.writeCallback(.receive, id: .abort, value: nil)

          if llGetRxFIFOThreshold() == 0x0 {

            rx_dma_status = dma.startInterrupt(
              .receive, sourceAddress: registers.address(of: .rdr),
              destinationAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.receiveBuffer.buffer)),
              sourceDataSize: handle.readTransfer()!.pointee.receiveBuffer.size)
          } else {

            if (handle.readTransfer()!.pointee.receiveBuffer.size % 4) == 0 {
              size_align_word = handle.readTransfer()!.pointee.receiveBuffer.size
            } else {
              size_align_word =
                ((handle.readTransfer()!.pointee.receiveBuffer.size &+ 4)
                  &- (handle.readTransfer()!.pointee.receiveBuffer.size % 4))
            }

            rx_dma_status = dma.startInterrupt(
              .receive, sourceAddress: registers.address(of: .rdwr),
              destinationAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.receiveBuffer.buffer)),
              sourceDataSize: size_align_word)
          }
        }

        if (control_dma_status == .ok) && (rx_dma_status == .ok) {

          enableTransferInterrupts(0x8)

          handle.write(.controlTransferCount, value: 0)

          llEnableDMAReqControl()

          if handle.read(.receiveTransferCount) != 0 {
            handle.write(.receiveTransferCount, value: 0)

            llEnableDMAReqRX()
          }

          llRequestTransfer()
        } else {
          if dma.abort(.control, getTick: getTick) == .ok {
            dma.writeCallback(.control, id: .transferComplete, value: nil)
            dma.writeCallback(.control, id: .error, value: nil)
          }

          if dma.abort(.receive, getTick: getTick) == .ok {
            dma.writeCallback(.receive, id: .transferComplete, value: nil)
            dma.writeCallback(.receive, id: .error, value: nil)
          }
          handle.write(.errorCode, value: 0x10000)
          status = .error

          updateState()
        }
      }
    }
    return status

  }
  public func controllerMultipleTransferDMA(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, getTick: () -> UInt32
  ) -> HALStatus {

    var control_dma_status: HALStatus
    var tx_dma_status: HALStatus = .ok
    var rx_dma_status: HALStatus = .ok
    var handle_state: UInt32
    var status: HALStatus = .ok
    var size_align_word: UInt32

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil)
        || ((pXferData!.pointee.receiveBuffer.buffer == nil)
          && (handle.read(.receiveTransferCount) != 0))
        || ((pXferData!.pointee.transmitBuffer.buffer == nil)
          && (handle.read(.transmitTransferCount) != 0))
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (!dma.isPresent(.transmit)) || (!dma.isPresent(.control))
        || (!dma.isPresent(.receive))
      {
        handle.write(.errorCode, value: 0x40000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.transferISR, value: I3CTransferISR.controllerMultipleTransferDMA.rawValue)
        handle.writeTransfer(pXferData)
        handle.write(
          .receiveTransferCount, value: handle.readTransfer()!.pointee.receiveBuffer.size)
        handle.write(
          .transmitTransferCount, value: handle.readTransfer()!.pointee.transmitBuffer.size)
        handle.write(.state, value: 0x23)

        dma.writeCallback(
          .control, id: .transferComplete, value: dma.callback(.controlTransmitComplete))

        dma.writeCallback(.control, id: .error, value: dma.callback(.error))

        dma.writeCallback(.control, id: .halfTransfer, value: nil)
        dma.writeCallback(.control, id: .abort, value: nil)

        control_dma_status = dma.startInterrupt(
          .control,
          sourceAddress: UInt32(
            truncatingIfNeeded: UInt(
              bitPattern: handle.readTransfer()!.pointee.controlBuffer.buffer)),
          destinationAddress: registers.address(of: .cr),
          sourceDataSize: (handle.read(.controlTransferCount) &* 4))

        if handle.read(.receiveTransferCount) != 0 {
          dma.writeCallback(
            .receive, id: .transferComplete, value: dma.callback(.dataReceiveComplete))

          dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

          dma.writeCallback(.receive, id: .halfTransfer, value: nil)
          dma.writeCallback(.receive, id: .abort, value: nil)

          if llGetRxFIFOThreshold() == 0x0 {

            rx_dma_status = dma.startInterrupt(
              .receive, sourceAddress: registers.address(of: .rdr),
              destinationAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.receiveBuffer.buffer)),
              sourceDataSize: handle.readTransfer()!.pointee.receiveBuffer.size)
          } else {

            if (handle.readTransfer()!.pointee.receiveBuffer.size % 4) == 0 {
              size_align_word = handle.readTransfer()!.pointee.receiveBuffer.size
            } else {
              size_align_word =
                ((handle.readTransfer()!.pointee.receiveBuffer.size &+ 4)
                  &- (handle.readTransfer()!.pointee.receiveBuffer.size % 4))
            }

            rx_dma_status = dma.startInterrupt(
              .receive, sourceAddress: registers.address(of: .rdwr),
              destinationAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.receiveBuffer.buffer)),
              sourceDataSize: size_align_word)
          }
        }

        if handle.read(.transmitTransferCount) != 0 {
          dma.writeCallback(
            .transmit, id: .transferComplete, value: dma.callback(.dataTransmitComplete))

          dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

          dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
          dma.writeCallback(.transmit, id: .abort, value: nil)

          if llGetTxFIFOThreshold() == 0x0 {

            tx_dma_status = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
              destinationAddress: registers.address(of: .tdr),
              sourceDataSize: handle.readTransfer()!.pointee.transmitBuffer.size)
          } else {

            if (handle.readTransfer()!.pointee.transmitBuffer.size % 4) == 0 {
              size_align_word = handle.readTransfer()!.pointee.transmitBuffer.size
            } else {
              size_align_word =
                ((handle.readTransfer()!.pointee.transmitBuffer.size &+ 4)
                  &- (handle.readTransfer()!.pointee.transmitBuffer.size % 4))
            }

            tx_dma_status = dma.startInterrupt(
              .transmit,
              sourceAddress: UInt32(
                truncatingIfNeeded: UInt(
                  bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
              destinationAddress: registers.address(of: .tdwr), sourceDataSize: size_align_word)
          }
        }

        if (control_dma_status == .ok) && (tx_dma_status == .ok) && (rx_dma_status == .ok) {

          enableTransferInterrupts(0x8)

          handle.write(.controlTransferCount, value: 0)

          llEnableDMAReqControl()

          if handle.read(.receiveTransferCount) != 0 {
            handle.write(.receiveTransferCount, value: 0)

            llEnableDMAReqRX()
          }

          if handle.read(.transmitTransferCount) != 0 {
            handle.write(.transmitTransferCount, value: 0)

            llEnableDMAReqTX()
          }

          llRequestTransfer()
        } else {
          if dma.abort(.control, getTick: getTick) == .ok {
            dma.writeCallback(.control, id: .transferComplete, value: nil)
            dma.writeCallback(.control, id: .error, value: nil)
          }

          if dma.abort(.transmit, getTick: getTick) == .ok {
            dma.writeCallback(.transmit, id: .transferComplete, value: nil)
            dma.writeCallback(.transmit, id: .error, value: nil)
          }

          if dma.abort(.receive, getTick: getTick) == .ok {
            dma.writeCallback(.receive, id: .transferComplete, value: nil)
            dma.writeCallback(.receive, id: .error, value: nil)
          }
          handle.write(.errorCode, value: 0x10000)
          status = .error

          updateState()
        }
      }
    }
    return status

  }
  public func targetTransmitDMA(_ pXferData: UnsafeMutablePointer<I3CTransfer>?) -> HALStatus {

    var tx_dma_status: HALStatus
    var handle_state: UInt32
    var status: HALStatus = .ok
    var size_align_word: UInt32
    var it_source: UInt32

    do {

      it_source = registers.read(.ier)

      handle_state = handle.read(.state)

      if (pXferData == nil) || (pXferData!.pointee.transmitBuffer.buffer == nil)
        || (pXferData!.pointee.transmitBuffer.size == 0)
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if !dma.isPresent(.transmit) {
        handle.write(.errorCode, value: 0x40000)
        status = .error
      } else if handle.read(.mode) != 0x2 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else if ((((((it_source) & (0x4000_0020)) == (0x4000_0020)) ? 1 : 0)) != 0)
        || ((((((it_source) & (0x8000_0020)) == (0x8000_0020)) ? 1 : 0)) != 0)
      {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if llIsEnabledOwnDynAddress() != 1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: 0x21)
        handle.writeTransfer(pXferData)
        handle.write(.transmitTransferCount, value: pXferData!.pointee.transmitBuffer.size)
        handle.write(.transferISR, value: I3CTransferISR.targetTransmitDMA.rawValue)

        llConfigTxPreload(
          UInt32(UInt16(truncatingIfNeeded: handle.readTransfer()!.pointee.transmitBuffer.size)))

        dma.writeCallback(
          .transmit, id: .transferComplete, value: dma.callback(.dataTransmitComplete))

        dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

        dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
        dma.writeCallback(.transmit, id: .abort, value: nil)

        if llGetTxFIFOThreshold() == 0x0 {

          tx_dma_status = dma.startInterrupt(
            .transmit,
            sourceAddress: UInt32(
              truncatingIfNeeded: UInt(
                bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
            destinationAddress: registers.address(of: .tdr),
            sourceDataSize: handle.readTransfer()!.pointee.transmitBuffer.size)
        } else {

          if (handle.readTransfer()!.pointee.transmitBuffer.size % 4) == 0 {
            size_align_word = handle.readTransfer()!.pointee.transmitBuffer.size
          } else {
            size_align_word =
              ((handle.readTransfer()!.pointee.transmitBuffer.size &+ 4)
                &- (handle.readTransfer()!.pointee.transmitBuffer.size % 4))
          }

          tx_dma_status = dma.startInterrupt(
            .transmit,
            sourceAddress: UInt32(
              truncatingIfNeeded: UInt(
                bitPattern: handle.readTransfer()!.pointee.transmitBuffer.buffer)),
            destinationAddress: registers.address(of: .tdwr), sourceDataSize: size_align_word)
        }

        if tx_dma_status == .ok {

          enableTransferInterrupts(0x8)

          handle.write(.transmitTransferCount, value: 0)

          llEnableDMAReqTX()
        } else {
          dma.writeCallback(.transmit, id: .transferComplete, value: nil)
          dma.writeCallback(.transmit, id: .error, value: nil)
          handle.write(.errorCode, value: 0x10000)
          status = .error

          updateState()
        }
      }
    }
    return status

  }
  public func targetReceiveDMA(_ pXferData: UnsafeMutablePointer<I3CTransfer>?) -> HALStatus {

    var rx_dma_status: HALStatus
    var handle_state: UInt32
    var status: HALStatus = .ok
    var size_align_word: UInt32
    var it_source: UInt32

    do {

      it_source = registers.read(.ier)

      handle_state = handle.read(.state)

      if (pXferData == nil) || (pXferData!.pointee.receiveBuffer.buffer == nil)
        || (pXferData!.pointee.receiveBuffer.size == 0)
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if !dma.isPresent(.receive) {
        handle.write(.errorCode, value: 0x40000)
        status = .error

        updateState()
      } else if handle.read(.mode) != 0x2 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else if ((((((it_source) & (0x4000_0020)) == (0x4000_0020)) ? 1 : 0)) != 0)
        || ((((((it_source) & (0x8000_0020)) == (0x8000_0020)) ? 1 : 0)) != 0)
      {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if llIsEnabledOwnDynAddress() != 1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: 0x22)
        handle.writeTransfer(pXferData)
        handle.write(.receiveTransferCount, value: pXferData!.pointee.receiveBuffer.size)
        handle.write(.transferISR, value: I3CTransferISR.targetReceiveDMA.rawValue)

        dma.writeCallback(
          .receive, id: .transferComplete, value: dma.callback(.dataReceiveComplete))

        dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

        dma.writeCallback(.receive, id: .halfTransfer, value: nil)
        dma.writeCallback(.receive, id: .abort, value: nil)

        if llGetRxFIFOThreshold() == 0x0 {

          rx_dma_status = dma.startInterrupt(
            .receive, sourceAddress: registers.address(of: .rdr),
            destinationAddress: UInt32(
              truncatingIfNeeded: UInt(
                bitPattern: handle.readTransfer()!.pointee.receiveBuffer.buffer)),
            sourceDataSize: handle.readTransfer()!.pointee.receiveBuffer.size)
        } else {

          if (handle.readTransfer()!.pointee.receiveBuffer.size % 4) == 0 {
            size_align_word = handle.readTransfer()!.pointee.receiveBuffer.size
          } else {
            size_align_word =
              ((handle.readTransfer()!.pointee.receiveBuffer.size &+ 4)
                &- (handle.readTransfer()!.pointee.receiveBuffer.size % 4))
          }

          rx_dma_status = dma.startInterrupt(
            .receive, sourceAddress: registers.address(of: .rdwr),
            destinationAddress: UInt32(
              truncatingIfNeeded: UInt(
                bitPattern: handle.readTransfer()!.pointee.receiveBuffer.buffer)),
            sourceDataSize: size_align_word)
        }
        if rx_dma_status == .ok {

          enableTransferInterrupts(0x8)

          handle.write(.receiveTransferCount, value: 0)

          llEnableDMAReqRX()
        } else {
          dma.writeCallback(.receive, id: .transferComplete, value: nil)
          dma.writeCallback(.receive, id: .error, value: nil)
          handle.write(.errorCode, value: 0x10000)
          status = .error

          updateState()
        }
      }
    }
    return status

  }
}
