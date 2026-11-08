// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func controllerTransmitCCC(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32
    var exit_condition: UInt32
    var status: HALStatus = .ok
    var handle_state: UInt32

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
        handle.write(.state, value: 0x21)
        handle.writeTransfer(pXferData)

        if llGetTxFIFOThreshold() == 0x0 {
          handle.write(.transmitTreatment, value: 1)
        } else {
          handle.write(.transmitTreatment, value: 2)
        }

        tickstart = getTick()

        if llIsEnabledControlFIFO() == 1 {
          llRequestTransfer()
        } else {
          handle.write(.controlTransferCount, value: handle.read(.controlTransferCount) &- (1))

          registers.write(.cr, value: handle.readTransfer()!.pointee.controlBuffer.buffer!.pointee)

          handle.readTransfer()!.pointee.controlBuffer.buffer = handle.readTransfer()!.pointee
            .controlBuffer.buffer!.advanced(by: Int(1))
        }

        repeat {
          if handle.read(.controlTransferCount) > 0 {
            controlData()
          }

          if getFlag(0x8) != 0 {
            _ = registers.read(.sr)
          }

          if handle.read(.transmitTransferCount) > 0 {
            invokeTransmitTreatment()
          }

          if timeout != UInt32.max {
            if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
              handle.write(.errorCode, value: 0x20000)
              status = .timeout
              break
            }
          }
          if (getFlag(0x200) == 1) && (handle.read(.controlTransferCount) > 0) {
            llClearFlagFC()

            llRequestTransfer()
          }

          exit_condition = (registers.read(.evr) & (0x200 | 0x800))
        } while (exit_condition == 0)
          || ((exit_condition == 0x200) && (handle.read(.controlTransferCount) > 0))

        if getFlag(0x200) == 1 {
          llClearFlagFC()
        }

        if getFlag(0x800) == 1 {
          llClearFlagERR()

          getErrorSources()

          status = .error
        }

        updateState()
      }
    }
    return status

  }
  public func controllerReceiveCCC(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32
    var exit_condition: UInt32
    var status: HALStatus = .ok
    var handle_state: UInt32

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
        handle.write(.state, value: 0x22)
        handle.writeTransfer(pXferData)
        handle.write(
          .receiveTransferCount, value: handle.readTransfer()!.pointee.receiveBuffer.size)

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

        tickstart = getTick()

        if llIsEnabledControlFIFO() == 1 {
          llRequestTransfer()
        } else {
          handle.write(.controlTransferCount, value: handle.read(.controlTransferCount) &- (1))

          registers.write(.cr, value: handle.readTransfer()!.pointee.controlBuffer.buffer!.pointee)

          handle.readTransfer()!.pointee.controlBuffer.buffer = handle.readTransfer()!.pointee
            .controlBuffer.buffer!.advanced(by: Int(1))
        }

        repeat {
          controlData()
          if handle.read(.transmitTransferCount) != 0 {
            invokeTransmitTreatment()
          }

          invokeReceiveTreatment()

          if timeout != UInt32.max {
            if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
              handle.write(.errorCode, value: 0x20000)
              status = .timeout
              break
            }
          }
          if (getFlag(0x200) == 1) && (handle.read(.controlTransferCount) > 0) {
            llClearFlagFC()

            llRequestTransfer()
          }

          exit_condition = (registers.read(.evr) & (0x200 | 0x800))
        } while (exit_condition == 0)
          || ((exit_condition == 0x200) && (handle.read(.controlTransferCount) > 0))

        if getFlag(0x200) == 1 {
          llClearFlagFC()
        }

        if (handle.read(.receiveTransferCount) != 0) && (status == .ok) {
          handle.write(.errorCode, value: 0x100000)
          status = .error
        }

        if getFlag(0x800) == 1 {
          llClearFlagERR()

          getErrorSources()

          status = .error
        }

        updateState()
      }
    }
    return status

  }
  public func controllerTransmit(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32
    var exit_condition: UInt32
    var status: HALStatus = .ok
    var handle_state: UInt32

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
        handle.write(.state, value: 0x21)
        handle.writeTransfer(pXferData)

        if llGetTxFIFOThreshold() == 0x0 {
          handle.write(.transmitTreatment, value: 1)
        } else {
          handle.write(.transmitTreatment, value: 2)
        }

        tickstart = getTick()

        if llIsEnabledControlFIFO() == 1 {
          llRequestTransfer()
        } else {
          handle.write(.controlTransferCount, value: handle.read(.controlTransferCount) &- (1))

          registers.write(.cr, value: handle.readTransfer()!.pointee.controlBuffer.buffer!.pointee)

          handle.readTransfer()!.pointee.controlBuffer.buffer = handle.readTransfer()!.pointee
            .controlBuffer.buffer!.advanced(by: Int(1))
        }

        repeat {
          controlData()

          invokeTransmitTreatment()

          if timeout != UInt32.max {
            if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
              handle.write(.errorCode, value: 0x20000)
              status = .timeout
              break
            }
          }
          if (getFlag(0x200) == 1) && (handle.read(.controlTransferCount) > 0) {
            llClearFlagFC()

            llRequestTransfer()
          }

          exit_condition = (registers.read(.evr) & (0x200 | 0x800))
        } while (exit_condition == 0)
          || ((exit_condition == 0x200) && (handle.read(.controlTransferCount) > 0))

        if getFlag(0x200) == 1 {
          llClearFlagFC()
        }

        if (handle.read(.transmitTransferCount) != 0) && (status == .ok) {
          handle.write(.errorCode, value: 0x100000)
          status = .error
        }

        if getFlag(0x800) == 1 {
          llClearFlagERR()

          getErrorSources()

          status = .error
        }

        updateState()
      }
    }
    return status

  }
  public func controllerReceive(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32
    var exit_condition: UInt32
    var status: HALStatus = .ok
    var handle_state: UInt32

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
        handle.write(.state, value: 0x22)
        handle.writeTransfer(pXferData)
        handle.write(
          .receiveTransferCount, value: handle.readTransfer()!.pointee.receiveBuffer.size)

        if llGetRxFIFOThreshold() == 0x0 {
          handle.write(.receiveTreatment, value: 1)
        } else {
          handle.write(.receiveTreatment, value: 2)
        }

        tickstart = getTick()

        if llIsEnabledControlFIFO() == 1 {
          llRequestTransfer()
        } else {
          handle.write(.controlTransferCount, value: handle.read(.controlTransferCount) &- (1))

          registers.write(.cr, value: handle.readTransfer()!.pointee.controlBuffer.buffer!.pointee)

          handle.readTransfer()!.pointee.controlBuffer.buffer = handle.readTransfer()!.pointee
            .controlBuffer.buffer!.advanced(by: Int(1))
        }

        repeat {
          controlData()

          invokeReceiveTreatment()

          if timeout != UInt32.max {
            if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
              handle.write(.errorCode, value: 0x20000)
              status = .timeout
              break
            }
          }
          if (getFlag(0x200) == 1) && (handle.read(.controlTransferCount) > 0) {
            llClearFlagFC()

            llRequestTransfer()
          }

          exit_condition = (registers.read(.evr) & (0x200 | 0x800))
        } while (exit_condition == 0)
          || ((exit_condition == 0x200) && (handle.read(.controlTransferCount) > 0))

        if getFlag(0x200) == 1 {
          llClearFlagFC()
        }

        if (handle.read(.receiveTransferCount) != 0) && (status == .ok) {
          handle.write(.errorCode, value: 0x100000)
          status = .error
        }

        if getFlag(0x800) == 1 {
          llClearFlagERR()

          getErrorSources()

          status = .error
        }

        updateState()
      }
    }
    return status

  }
  public func controllerAssignDynamicAddress(
    _ target_payload: UnsafeMutablePointer<UInt64>?, _ dynOption: UInt32, _ timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32
    var handle_state: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)
      if target_payload == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        if (dynOption == 0x1) && ((handle_state == 0x10) || (handle_state == 0x30)) {
          handle.write(.errorCode, value: 0x0)
          handle.write(.state, value: 0x24)

          tickstart = getTick()

          llEnableArbitrationHeader()

          llControllerHandleCCC(0x6, 0, 0x8000_0000)

          status = waitOnFlag(0x200, 0, timeout, tickstart, getTick: getTick)

          if getFlag(0x200) == 1 {
            llClearFlagFC()
          }

          if getFlag(0x800) == 1 {
            llClearFlagERR()

            getErrorSources()
            status = .error
          }

          updateState()
        }
        if status == .ok {
          if (handle_state == 0x10) || (handle_state == 0x30) || (handle_state == 0x24) {
            if handle_state != 0x24 {
              handle.write(.errorCode, value: 0x0)
              handle.write(.state, value: 0x24)

              tickstart = getTick()

              llEnableArbitrationHeader()

              llControllerHandleCCC(0x7, 0, 0x8000_0000)
            } else {
              tickstart = getTick()
            }

            status = waitOnDynamicAddress(timeout, tickstart, getTick: getTick)

            if getFlag(0x10) == 1 {
              target_payload!.pointee = 0

              if llGetRxFIFOThreshold() == 0x0 {
                do {
                  var index: UInt32 = 0
                  while index < 8 {

                    target_payload!.pointee |= UInt64((UInt64(llReceiveData8()) << (index &* 8)))
                    index &+= 1
                  }
                }
              } else {
                target_payload!.pointee = UInt64(llReceiveData32())

                target_payload!.pointee |= UInt64((UInt64(llReceiveData32()) << 32))
              }
              status = .busy
            } else {
              if getFlag(0x200) == 1 {
                llClearFlagFC()
              }
              updateState()
            }
          } else {
            handle.write(.errorCode, value: 0x200000)
            status = .error
          }
        }
      }
    }
    return status

  }
  public func controllerSetDynamicAddress(_ devAddress: UInt8) -> HALStatus {
    let devAddress = UInt32(devAddress)

    var status: HALStatus = .ok

    do {
      if getFlag(0x10) == 1 {
        llTransmitData8(devAddress)
      } else {
        status = .error
      }
    }
    return status

  }
  public func controllerIsI3CDeviceReady(
    _ devAddress: UInt8, _ trials: UInt32, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let devAddress = UInt32(devAddress)

    var device = I3CDeviceProbe()
    var status: HALStatus

    do {

      device.address = UInt8(truncatingIfNeeded: devAddress)

      device.messageType = 0x1000_0000

      status = probeDevice(device, trials, timeout, getTick: getTick)
    }
    return status

  }
  public func controllerIsI2CDeviceReady(
    _ devAddress: UInt8, _ trials: UInt32, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let devAddress = UInt32(devAddress)

    var device = I3CDeviceProbe()
    var status: HALStatus

    do {

      device.address = UInt8(truncatingIfNeeded: devAddress)

      device.messageType = 0x2000_0000

      status = probeDevice(device, trials, timeout, getTick: getTick)
    }
    return status

  }
  public func controllerGenerateArbitration(_ timeout: UInt32, getTick: () -> UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var handle_state: UInt32
    var exit_condition: UInt32
    var tickstart: UInt32

    do {

      handle_state = handle.read(.state)

      if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.state, value: 0x20)

        llDisableExitPattern()
        llDisableResetPattern()

        registers.write(.cr, value: 0x8000000 | 0x8000_0000)

        exit_condition = (registers.read(.evr) & (0x200 | 0x800))
        tickstart = getTick()
        while exit_condition == 0 {
          if timeout != UInt32.max {
            if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x20000))
              status = .timeout
              break
            }
          }

          if getFlag(0x8) != 0 {
            _ = registers.read(.sr)
          }

          exit_condition = (registers.read(.evr) & (0x200 | 0x800))
        }
        if status == .ok {
          if getFlag(0x200) == 1 {
            llClearFlagFC()
          } else {
            llClearFlagERR()

            getErrorSources()

            status = .error
          }
        }

        updateState()
      }
    }
    return status

  }
  public func targetTransmit(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32
    var status: HALStatus = .ok
    var handle_state: UInt32
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

        if llGetTxFIFOThreshold() == 0x0 {
          handle.write(.transmitTreatment, value: 1)
        } else {
          handle.write(.transmitTreatment, value: 2)
        }

        llConfigTxPreload(
          UInt32(UInt16(truncatingIfNeeded: handle.readTransfer()!.pointee.transmitBuffer.size)))

        tickstart = getTick()

        repeat {
          invokeTransmitTreatment()

          if timeout != UInt32.max {
            if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
              handle.write(.errorCode, value: 0x20000)
              status = .timeout
              break
            }
          }
        } while (registers.read(.evr) & (0x200 | 0x800)) == 0

        if getFlag(0x200) == 1 {
          llClearFlagFC()
        }

        if (llGetXferDataCount() != handle.readTransfer()!.pointee.transmitBuffer.size)
          && (status == .ok)
        {
          handle.write(.errorCode, value: 0x100000)
          status = .error
        }

        if getFlag(0x800) == 1 {
          llClearFlagERR()

          getErrorSources()

          status = .error
        }

        updateState()
      }
    }
    return status

  }
  public func targetReceive(
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32
    var status: HALStatus = .ok
    var handle_state: UInt32
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

        if llGetRxFIFOThreshold() == 0x0 {
          handle.write(.receiveTreatment, value: 1)
        } else {
          handle.write(.receiveTreatment, value: 2)
        }

        tickstart = getTick()

        repeat {
          if handle.read(.receiveTransferCount) > 0 {
            invokeReceiveTreatment()
          }

          if timeout != UInt32.max {
            if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
              handle.write(.errorCode, value: 0x20000)
              status = .timeout
              break
            }
          }
        } while (registers.read(.evr) & (0x200 | 0x800)) == 0

        if getFlag(0x200) == 1 {
          llClearFlagFC()
        }

        if (llGetXferDataCount() != handle.readTransfer()!.pointee.receiveBuffer.size)
          && (status == .ok)
        {
          handle.write(.errorCode, value: 0x100000)
          status = .error
        }

        if getFlag(0x800) == 1 {
          llClearFlagERR()

          getErrorSources()
          status = .error
        }

        updateState()
      }
    }
    return status

  }
  public func targetRequestControlRole(_ timeout: UInt32, getTick: () -> UInt32) -> HALStatus {

    var tickstart: UInt32
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

        tickstart = getTick()

        llTargetHandleMessage(0x4800_0000, 0)

        status = waitOnFlag(0x40000, 0, timeout, tickstart, getTick: getTick)

        if getFlag(0x40000) == 1 {
          llClearFlagCRUPD()
        }

        if getFlag(0x800) == 1 {
          llClearFlagERR()

          getErrorSources()

          updateState()
          status = .error
        } else {
          updateState()
        }
      }
    }
    return status

  }
  public func targetRequestHotJoin(
    _ pAddress: UnsafeMutablePointer<UInt8>?, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32
    var handle_state: UInt32
    var valid_dynamic_address: UInt32
    var status: HALStatus = .ok

    do {

      handle_state = handle.read(.state)

      if pAddress == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.mode) != 0x2 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        if llIsEnabledHotJoin() != 1 {
          handle.write(.errorCode, value: 0x200000)
          status = .error
        }
      }
      if status == .ok {
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: 0x20)

        tickstart = getTick()

        llTargetHandleMessage(0x4000_0000, 0)

        status = waitOnFlag(0x1000000, 0, timeout, tickstart, getTick: getTick)

        if getFlag(0x1000000) == 1 {
          llClearFlagDAUPD()
        }

        valid_dynamic_address = llIsEnabledOwnDynAddress()

        if valid_dynamic_address == 0 {
          handle.write(.errorCode, value: 0x400000)
          status = .error

          updateState()
        } else if getFlag(0x800) == 1 {
          llClearFlagERR()

          getErrorSources()

          updateState()
          status = .error
        } else {
          updateState()

          pAddress!.pointee = UInt8(truncatingIfNeeded: llGetOwnDynamicAddress())
        }
      }
    }
    return status

  }
  public func targetRequestIBI(
    _ pPayload: UnsafePointer<UInt8>?, _ payloadSize: UInt8, _ timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    let payloadSize = UInt32(payloadSize)

    var tickstart: UInt32
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
        if status == .ok {
          tickstart = getTick()

          llTargetHandleMessage(0x5000_0000, payloadSize)

          status = waitOnFlag(0x10000, 0, timeout, tickstart, getTick: getTick)
          if getFlag(0x10000) == 1 {
            llClearFlagIBIEND()
          }

          if getFlag(0x800) == 1 {
            llClearFlagERR()

            getErrorSources()

            updateState()
            status = .error
          } else {
            updateState()
          }
        }
      }
    }
    return status

  }
}
