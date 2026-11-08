// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func controllerTransmitCCCInterrupt(_ pXferData: UnsafeMutablePointer<I3CTransfer>?)
    -> HALStatus
  {

    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil)
        || ((handle.read(.transmitTransferCount) != 0)
          && (pXferData!.pointee.transmitBuffer.buffer == nil))
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        if handle_state == 0x30 {
          handle.write(.transferISR, value: I3CTransferISR.controllerTransmitListen.rawValue)
        } else {
          handle.write(.transferISR, value: I3CTransferISR.controllerTransmit.rawValue)
        }
        handle.writeTransfer(pXferData)
        handle.write(.state, value: 0x21)

        if llGetTxFIFOThreshold() == 0x0 {
          handle.write(.transmitTreatment, value: 1)
        } else {
          handle.write(.transmitTreatment, value: 2)
        }

        enableTransferInterrupts(0x80)

        llRequestTransfer()
      }
    }
    return status

  }
  public func controllerReceiveCCCInterrupt(_ pXferData: UnsafeMutablePointer<I3CTransfer>?)
    -> HALStatus
  {

    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil) || (pXferData!.pointee.receiveBuffer.buffer == nil)
        || ((pXferData!.pointee.transmitBuffer.buffer == nil)
          && (handle.read(.transmitTransferCount) != 0))
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        if handle_state == 0x30 {
          handle.write(.transferISR, value: I3CTransferISR.controllerReceiveListen.rawValue)
        } else {
          handle.write(.transferISR, value: I3CTransferISR.controllerReceive.rawValue)
        }
        handle.writeTransfer(pXferData)
        handle.write(.receiveTransferCount, value: pXferData!.pointee.receiveBuffer.size)
        handle.write(.state, value: 0x22)

        if handle.read(.transmitTransferCount) != 0 {
          if llGetTxFIFOThreshold() == 0x0 {
            handle.write(.transmitTreatment, value: 1)
          } else {
            handle.write(.transmitTreatment, value: 2)
          }
        }

        if llGetRxFIFOThreshold() == 0x0 {
          handle.write(.receiveTreatment, value: 1)
        } else {
          handle.write(.receiveTreatment, value: 2)
        }

        enableTransferInterrupts(0x400)

        llRequestTransfer()
      }
    }
    return status

  }
  public func controllerTransmitInterrupt(_ pXferData: UnsafeMutablePointer<I3CTransfer>?)
    -> HALStatus
  {

    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil)
        || ((handle.read(.transmitTransferCount) != 0)
          && (pXferData!.pointee.transmitBuffer.buffer == nil))
      {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        if handle_state == 0x30 {
          handle.write(.transferISR, value: I3CTransferISR.controllerTransmitListen.rawValue)
        } else {
          handle.write(.transferISR, value: I3CTransferISR.controllerTransmit.rawValue)
        }
        handle.writeTransfer(pXferData)
        handle.write(.state, value: 0x21)

        if llGetTxFIFOThreshold() == 0x0 {
          handle.write(.transmitTreatment, value: 1)
        } else {
          handle.write(.transmitTreatment, value: 2)
        }

        enableTransferInterrupts(0x80)

        llRequestTransfer()
      }
    }
    return status

  }
  public func controllerReceiveInterrupt(_ pXferData: UnsafeMutablePointer<I3CTransfer>?)
    -> HALStatus
  {

    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if (pXferData == nil) || (pXferData!.pointee.receiveBuffer.buffer == nil) {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        if handle_state == 0x30 {
          handle.write(.transferISR, value: I3CTransferISR.controllerReceiveListen.rawValue)
        } else {
          handle.write(.transferISR, value: I3CTransferISR.controllerReceive.rawValue)
        }
        handle.writeTransfer(pXferData)
        handle.write(
          .receiveTransferCount, value: handle.readTransfer()!.pointee.receiveBuffer.size)
        handle.write(.state, value: 0x22)

        if llGetRxFIFOThreshold() == 0x0 {
          handle.write(.receiveTreatment, value: 1)
        } else {
          handle.write(.receiveTreatment, value: 2)
        }

        enableTransferInterrupts(0x100)

        llRequestTransfer()
      }
    }
    return status

  }
  public func controllerMultipleTransferInterrupt(_ pXferData: UnsafeMutablePointer<I3CTransfer>?)
    -> HALStatus
  {

    var handle_state: UInt32
    var status: HALStatus = .ok

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
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        if handle_state == 0x30 {
          handle.write(
            .transferISR, value: I3CTransferISR.controllerMultipleTransferListen.rawValue)
        } else {
          handle.write(.transferISR, value: I3CTransferISR.controllerMultipleTransfer.rawValue)
        }
        handle.writeTransfer(pXferData)
        handle.write(
          .transmitTransferCount, value: handle.readTransfer()!.pointee.transmitBuffer.size)
        handle.write(
          .receiveTransferCount, value: handle.readTransfer()!.pointee.receiveBuffer.size)
        handle.write(.state, value: 0x23)

        if llGetTxFIFOThreshold() == 0x0 {
          handle.write(.transmitTreatment, value: 1)
        } else {
          handle.write(.transmitTreatment, value: 2)
        }

        if llGetRxFIFOThreshold() == 0x0 {
          handle.write(.receiveTreatment, value: 1)
        } else {
          handle.write(.receiveTreatment, value: 2)
        }

        enableTransferInterrupts((0x80 | 0x100))

        llRequestTransfer()
      }
    }
    return status

  }
  public func controllerAssignDynamicAddressInterrupt(_ dynOption: UInt32) -> HALStatus {

    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: 0x24)
        handle.write(.transferISR, value: I3CTransferISR.controllerDynamicAddress.rawValue)

        enableTransferInterrupts(0x1000)

        llEnableArbitrationHeader()

        if dynOption == 0x1 {
          llControllerHandleCCC(0x6, 0, 0x0)
        } else {
          llControllerHandleCCC(0x7, 0, 0x8000_0000)
        }
      }
    }
    return status

  }
  public func targetTransmitInterrupt(_ pXferData: UnsafeMutablePointer<I3CTransfer>?) -> HALStatus
  {

    var handle_state: UInt32
    var status: HALStatus = .ok
    var it_source: UInt32

    do {

      it_source = registers.read(.ier)

      handle_state = handle.read(.state)

      if (pXferData == nil) || (pXferData!.pointee.transmitBuffer.buffer == nil)
        || (pXferData!.pointee.transmitBuffer.size == 0)
      {
        handle.write(.errorCode, value: 0x80000)
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
        handle.write(.transferISR, value: I3CTransferISR.targetTransmit.rawValue)

        if llGetTxFIFOThreshold() == 0x0 {
          handle.write(.transmitTreatment, value: 1)
        } else {
          handle.write(.transmitTreatment, value: 2)
        }

        llConfigTxPreload(
          UInt32(UInt16(truncatingIfNeeded: handle.readTransfer()!.pointee.transmitBuffer.size)))

        enableTransferInterrupts(0x2)
      }
    }
    return status

  }
  public func targetReceiveInterrupt(_ pXferData: UnsafeMutablePointer<I3CTransfer>?) -> HALStatus {

    var handle_state: UInt32
    var status: HALStatus = .ok
    var it_source: UInt32

    do {

      it_source = registers.read(.ier)

      handle_state = handle.read(.state)

      if (pXferData == nil) || (pXferData!.pointee.receiveBuffer.buffer == nil)
        || (pXferData!.pointee.receiveBuffer.size == 0)
      {
        handle.write(.errorCode, value: 0x80000)
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
        handle.write(.state, value: 0x22)
        handle.writeTransfer(pXferData)
        handle.write(.receiveTransferCount, value: pXferData!.pointee.receiveBuffer.size)
        handle.write(.transferISR, value: I3CTransferISR.targetReceive.rawValue)

        if llGetRxFIFOThreshold() == 0x0 {
          handle.write(.receiveTreatment, value: 1)
        } else {
          handle.write(.receiveTreatment, value: 2)
        }

        enableTransferInterrupts(0x4)
      }
    }
    return status

  }
  public func targetRequestControlRoleInterrupt() -> HALStatus {

    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if handle.read(.mode) != 0x2 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else if llIsEnabledOwnDynAddress() != 1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        if llIsEnabledControllerRoleReq() != 1 {
          handle.write(.errorCode, value: 0x200000)
          status = .error
        }
      }
      if status == .ok {
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: 0x20)
        handle.write(.transferISR, value: I3CTransferISR.targetControlRole.rawValue)

        enableTransferInterrupts(0x10)

        llTargetHandleMessage(0x4800_0000, 0)
      }
    }
    return status

  }
  public func targetRequestHotJoinInterrupt() -> HALStatus {

    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if handle.read(.mode) != 0x2 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else if llIsEnabledHotJoin() != 1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: 0x20)
        handle.write(.transferISR, value: I3CTransferISR.targetHotJoin.rawValue)

        enableTransferInterrupts(0x20)

        llTargetHandleMessage(0x4000_0000, 0)
      }
    }
    return status

  }
  public func targetRequestIBIInterrupt(_ pPayload: UnsafePointer<UInt8>?, _ payloadSize: UInt8)
    -> HALStatus
  {
    let payloadSize = UInt32(payloadSize)

    var payload_value: UInt32 = 0
    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if handle.read(.mode) != 0x2 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else if llIsEnabledOwnDynAddress() != 1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        if llIsEnabledIBI() != 1 {
          handle.write(.errorCode, value: 0x200000)
          status = .error
        }
      }
      if status == .ok {
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: 0x20)
        handle.write(.transferISR, value: I3CTransferISR.targetIBI.rawValue)

        if llGetDeviceIBIPayload() == 0x4 {
          if (pPayload == nil) || (payloadSize == 0) {
            handle.write(.errorCode, value: 0x80000)
            status = .error

            updateState()
          } else {
            do {
              var index: UInt32 = 0
              while index < payloadSize {
                payload_value |=
                  (UInt32(truncatingIfNeeded: UInt32(pPayload![Int(index)])) << (index &* 8))
                index &+= 1
              }
            }

            llSetIBIPayload(payload_value)
          }
        }

        enableTransferInterrupts(0x40)

        llTargetHandleMessage(0x5000_0000, payloadSize)
      }
    }
    return status

  }
  public func abortInterrupt() -> HALStatus {

    let status: HALStatus = .ok

    do {
      if handle.read(.state) != 0x60 {
        handle.write(.state, value: 0x60)

        registers.write(.ier, value: registers.read(.ier) & (~(0x800)))
        handle.write(.transferISR, value: I3CTransferISR.abort.rawValue)

        llRequestTxFIFOFlush()

        llRequestRxFIFOFlush()

        if handle.read(.mode) == 0x1 {
          llRequestControlFIFOFlush()

          llRequestStatusFIFOFlush()
        }

        llDisableDMAReqControl()
        llDisableDMAReqRX()
        llDisableDMAReqTX()
        llDisableDMAReqStatus()
        if handle.read(.mode) == 0x1 {
          enableTransferInterrupts(0x400)
        } else {
          enableTransferInterrupts(0x4)
        }
      } else {
        return .busy
      }
    }
    return status

  }
}
