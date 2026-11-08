// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func initialize() -> HALStatus {

    let status: HALStatus = .ok
    var waveform_value: UInt32
    var timing_value: UInt32

    do {

      if handle.read(.state) == 0x0 {
        if useRegisteredCallbacks {

          callbacks.write(.controllerTransmitComplete, value: defaults.controllerTransmitComplete)
          callbacks.write(.controllerReceiveComplete, value: defaults.controllerReceiveComplete)
          callbacks.write(
            .controllerMultipleTransferComplete, value: defaults.controllerMultipleTransferComplete)
          callbacks.write(
            .controllerDynamicAddressComplete, value: defaults.controllerDynamicAddressComplete)
          callbacks.writeTargetRequestDynamicAddress(defaults.targetRequestDynamicAddress)
          callbacks.write(.targetTransmitComplete, value: defaults.targetTransmitComplete)
          callbacks.write(.targetReceiveComplete, value: defaults.targetReceiveComplete)
          callbacks.writeTargetHotJoin(defaults.targetHotJoin)
          callbacks.writeNotify(defaults.notify)
          callbacks.write(.error, value: defaults.error)
          callbacks.write(.abortComplete, value: defaults.abortComplete)

          if callbacks.read(.mspInitialize) == nil {
            callbacks.write(.mspInitialize, value: defaults.mspInitialize)
          }

          callbacks.read(.mspInitialize)!(callbacks.context)
        } else {
          defaults.mspInitialize(callbacks.context)
        }
      }

      handle.write(.state, value: 0x20)

      llDisable()

      if handle.read(.mode) == 0x1 {

        llSetMode(0x2)

        waveform_value =
          (UInt32(truncatingIfNeeded: (handle.read(.sclppLowDuration) & 0xFF))
            | (UInt32(truncatingIfNeeded: (handle.read(.sclI3CHighDuration) & 0xFF)) << 0x8)
            | (UInt32(truncatingIfNeeded: (handle.read(.sclodLowDuration) & 0xFF)) << 0x10)
            | (UInt32(truncatingIfNeeded: (handle.read(.sclI2CHighDuration) & 0xFF)) << 0x18))
        llConfigClockWaveForm(waveform_value)

        timing_value =
          (UInt32(truncatingIfNeeded: handle.read(.sdaHoldTime))
            | UInt32(truncatingIfNeeded: handle.read(.waitTime))
            | (UInt32(truncatingIfNeeded: (handle.read(.busFreeDuration) & 0xFF)) << 0x10)
            | UInt32(truncatingIfNeeded: (handle.read(.busIdleDuration) & 0xFF)))
        llSetCtrlBusCharacteristic(timing_value)
      } else {
        llSetMode(0x0)

        llSetAvalTiming((handle.read(.busAvailableDuration) & 0xFF))
      }

      llEnable()
      handle.write(.errorCode, value: 0x0)

      handle.write(.state, value: 0x10)
      handle.write(.previousState, value: 0x10)
    }
    return status

  }
  public func deinitialize() -> HALStatus {

    let status: HALStatus = .ok

    do {

      handle.write(.state, value: 0x20)

      llDisable()
      if useRegisteredCallbacks {
        if callbacks.read(.mspDeinitialize) == nil {
          callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        }

        callbacks.read(.mspDeinitialize)!(callbacks.context)
      } else {
        defaults.mspDeinitialize(callbacks.context)
      }

      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x0)
      handle.write(.previousState, value: 0x0)
      handle.write(.mode, value: 0x0)
    }
    return status

  }
  public func registerCallback(_ callbackID: UInt32, _ pCallback: I3CCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok

    do {
      if pCallback == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if 0x10 == handle.read(.state) {
        switch callbackID
        {
        case 0x0:
          callbacks.write(.controllerTransmitComplete, value: pCallback)
          break
        case 0x1:
          callbacks.write(.controllerReceiveComplete, value: pCallback)
          break
        case 0x2:
          callbacks.write(.controllerMultipleTransferComplete, value: pCallback)
          break
        case 0x3:
          callbacks.write(.controllerDynamicAddressComplete, value: pCallback)
          break
        case 0x5:
          callbacks.write(.targetTransmitComplete, value: pCallback)
          break
        case 0x6:
          callbacks.write(.targetReceiveComplete, value: pCallback)
          break
        case 0x9:
          callbacks.write(.error, value: pCallback)
          break
        case 0xa:
          callbacks.write(.abortComplete, value: pCallback)
          break
        case 0xb:
          callbacks.write(.mspInitialize, value: pCallback)
          break
        case 0xc:
          callbacks.write(.mspDeinitialize, value: pCallback)
          break
        default:
          handle.write(.errorCode, value: 0x800000)
          status = .error
          break
        }
      } else if 0x0 == handle.read(.state) {
        switch callbackID
        {
        case 0xb:
          callbacks.write(.mspInitialize, value: pCallback)
          break
        case 0xc:
          callbacks.write(.mspDeinitialize, value: pCallback)
          break
        default:
          handle.write(.errorCode, value: 0x800000)
          status = .error
          break
        }
      } else {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      }
    }
    return status

  }
  public func registerNotifyCallback(_ pNotifyCallback: I3CNotifyCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok

    do {
      if pNotifyCallback == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if 0x10 == handle.read(.state) {
        callbacks.writeNotify(pNotifyCallback)
      } else {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      }
    }
    return status

  }
  public func registerTargetDynamicAddressCallback(
    _ pTgtReqAddrCallback: I3CDynamicAddressCallback?
  ) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok

    do {
      if pTgtReqAddrCallback == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if 0x10 == handle.read(.state) {
        callbacks.writeTargetRequestDynamicAddress(pTgtReqAddrCallback)
      } else {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      }
    }
    return status

  }
  public func registerTargetHotJoinCallback(_ pTgtHotJoinCallback: I3CHotJoinCallback?) -> HALStatus
  {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok

    do {
      if pTgtHotJoinCallback == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if 0x10 == handle.read(.state) {
        callbacks.writeTargetHotJoin(pTgtHotJoinCallback)
      } else {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      }
    }
    return status

  }
  public func unregisterCallback(_ callbackID: UInt32) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok

    do {
      if 0x10 == handle.read(.state) {
        switch callbackID
        {
        case 0x0:
          callbacks.write(.controllerTransmitComplete, value: defaults.controllerTransmitComplete)
          break
        case 0x1:
          callbacks.write(.controllerReceiveComplete, value: defaults.controllerReceiveComplete)
          break
        case 0x2:
          callbacks.write(
            .controllerMultipleTransferComplete, value: defaults.controllerMultipleTransferComplete)
          break
        case 0x3:
          callbacks.write(
            .controllerDynamicAddressComplete, value: defaults.controllerDynamicAddressComplete)
          break
        case 0x4:
          callbacks.writeTargetRequestDynamicAddress(defaults.targetRequestDynamicAddress)
          break
        case 0x5:
          callbacks.write(.targetTransmitComplete, value: defaults.targetTransmitComplete)
          break
        case 0x6:
          callbacks.write(.targetReceiveComplete, value: defaults.targetReceiveComplete)
          break
        case 0x7:
          callbacks.writeTargetHotJoin(defaults.targetHotJoin)
          break
        case 0x8:
          callbacks.writeNotify(defaults.notify)
          break
        case 0x9:
          callbacks.write(.error, value: defaults.error)
          break
        case 0xa:
          callbacks.write(.abortComplete, value: defaults.abortComplete)
          break
        case 0xb:
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
          break
        case 0xc:
          callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
          break
        default:
          handle.write(.errorCode, value: 0x800000)
          status = .error
          break
        }
      } else if 0x0 == handle.read(.state) {
        switch callbackID
        {
        case 0xb:
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
          break
        case 0xc:
          callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
          break
        default:
          handle.write(.errorCode, value: 0x800000)
          status = .error
          break
        }
      } else {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      }
    }
    return status

  }
  public func configureControllerBus(_ pConfig: UnsafePointer<I3CControllerBusConfiguration>?)
    -> HALStatus
  {

    var status: HALStatus = .ok
    var waveform_value: UInt32
    var timing_value: UInt32

    do {

      if pConfig == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (handle.read(.state) != 0x10) || (handle.read(.mode) != 0x1) {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {

        llDisable()

        waveform_value =
          (UInt32(truncatingIfNeeded: UInt32(pConfig!.pointee.sclppLowDuration))
            | (UInt32(truncatingIfNeeded: UInt32(pConfig!.pointee.sclI3CHighDuration)) << 0x8)
            | (UInt32(truncatingIfNeeded: UInt32(pConfig!.pointee.sclodLowDuration)) << 0x10)
            | (UInt32(truncatingIfNeeded: UInt32(pConfig!.pointee.sclI2CHighDuration)) << 0x18))
        llConfigClockWaveForm(waveform_value)

        timing_value =
          (UInt32(truncatingIfNeeded: pConfig!.pointee.sdaHoldTime)
            | UInt32(truncatingIfNeeded: pConfig!.pointee.waitTime)
            | (UInt32(truncatingIfNeeded: UInt32(pConfig!.pointee.busFreeDuration)) << 0x10)
            | UInt32(truncatingIfNeeded: UInt32(pConfig!.pointee.busIdleDuration)))
        llSetCtrlBusCharacteristic(timing_value)

        llEnable()
      }
    }
    return status

  }
  public func configureTargetBus(_ pConfig: UnsafePointer<I3CTargetBusConfiguration>?) -> HALStatus
  {

    var status: HALStatus = .ok

    do {
      if pConfig == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else {

        if (handle.read(.state) != 0x10) || (handle.read(.mode) != 0x2) {
          handle.write(.errorCode, value: 0x200000)
          status = .error
        } else {
          llDisable()

          llSetAvalTiming(UInt32(pConfig!.pointee.busAvailableDuration))

          llEnable()
        }
      }
    }
    return status

  }
  public func configureFIFO(_ pConfig: UnsafePointer<I3CFIFOConfiguration>?) -> HALStatus {

    var status: HALStatus = .ok
    var cfgr_value: UInt32
    var cfgr_mask: UInt32

    do {
      if pConfig == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.state) == 0x0 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {

        cfgr_value = (pConfig!.pointee.txFifoThreshold | pConfig!.pointee.rxFifoThreshold)
        cfgr_mask = (0x4000 | 0x400)

        if handle.read(.mode) == 0x1 {

          cfgr_value |= (pConfig!.pointee.statusFifo | pConfig!.pointee.controlFifo)
          cfgr_mask |= (0x80000 | 0x40000)
        }

        registers.write(.cfgr, value: ((registers.read(.cfgr) & ~(cfgr_mask)) | (cfgr_value)))
      }
    }
    return status

  }
  public func configureController(_ pConfig: UnsafePointer<I3CControllerConfiguration>?)
    -> HALStatus
  {

    var status: HALStatus = .ok
    var timing2_value: UInt32
    var cfgr_value: UInt32

    do {

      if pConfig == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (handle.read(.state) == 0x0) || (handle.read(.mode) != 0x1) {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {

        llDisable()

        timing2_value =
          ((UInt32(truncatingIfNeeded: UInt32(pConfig!.pointee.stallTime)) << 0x8)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.ackStallState) << 0x3)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.cccStallState) << 0x2)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.txStallState) << 0x1)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.rxStallState) << 0x0))

        registers.write(.timingr2, value: timing2_value)

        cfgr_value =
          ((UInt32(truncatingIfNeeded: pConfig!.pointee.highKeeperSDA) << 0x5)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.hotJoinAllowed) << 0x7))

        registers.write(.cfgr, value: ((registers.read(.cfgr) & ~(0x20 | 0x80)) | (cfgr_value)))

        llSetOwnDynamicAddress(UInt32(pConfig!.pointee.dynamicAddr))

        llEnableOwnDynAddress()

        llEnable()
      }
    }
    return status

  }
  public func configureTarget(_ pConfig: UnsafePointer<I3CTargetConfiguration>?) -> HALStatus {

    var status: HALStatus = .ok
    var getmxdsr_value: UInt32
    var maxrlr_value: UInt32
    var crccapr_value: UInt32
    var bcr_value: UInt32
    var devr0_value: UInt32

    do {

      if pConfig == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (handle.read(.state) == 0x0) || (handle.read(.mode) != 0x2) {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {

        llDisable()

        getmxdsr_value =
          (pConfig!.pointee.handOffActivityState | pConfig!.pointee.maxDataSpeed
            | pConfig!.pointee.dataTurnAroundDuration
            | (UInt32(truncatingIfNeeded: UInt32(pConfig!.pointee.maxReadTurnAround)) << 0x10))

        registers.write(.getmxdsr, value: getmxdsr_value)

        maxrlr_value =
          (pConfig!.pointee.ibiPayloadSize | (UInt32(pConfig!.pointee.maxReadDataSize) & 0xffff))

        registers.write(.maxrlr, value: maxrlr_value)

        llSetMaxWriteLength(UInt32(pConfig!.pointee.maxWriteDataSize))

        llSetMIPIInstanceID(UInt32(pConfig!.pointee.mipiIdentifier))

        llSetDeviceCharacteristics(UInt32(pConfig!.pointee.identifier))

        crccapr_value =
          ((UInt32(truncatingIfNeeded: pConfig!.pointee.handOffDelay) << 0x3)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.groupAddrCapability) << 0x9))

        registers.write(.crcapr, value: crccapr_value)

        llSetPendingReadMDB((UInt32(truncatingIfNeeded: pConfig!.pointee.pendingReadMDB) << 0xe))

        bcr_value =
          ((UInt32(truncatingIfNeeded: pConfig!.pointee.maxSpeedLimitation) << 0x0)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.ibiPayload) << 0x2)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.ctrlCapability) << 0x6))

        registers.write(.bcr, value: bcr_value)

        devr0_value =
          ((UInt32(truncatingIfNeeded: pConfig!.pointee.ibiRequest) << 0x10)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.ctrlRoleRequest) << 0x11)
            | (UInt32(truncatingIfNeeded: pConfig!.pointee.hotJoinRequest) << 0x13))

        registers.write(
          .devr0,
          value: ((registers.read(.devr0) & ~((0x80000 | 0x10000 | 0x20000))) | (devr0_value)))

        llEnable()
      }
    }
    return status

  }
  public func configureBusDevices(
    _ pDesc: UnsafePointer<I3CDeviceConfiguration>?, _ nbDevice: UInt8
  ) -> HALStatus {
    let nbDevice = UInt32(nbDevice)

    var status: HALStatus = .ok
    var write_value: UInt32

    do {
      if pDesc == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if (handle.read(.state) == 0x0) || (handle.read(.mode) != 0x1) {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {

        do {
          var index: UInt32 = 0
          while index < nbDevice {

            write_value =
              ((UInt32(truncatingIfNeeded: UInt32(pDesc![Int(index)].targetDynamicAddr)) << 0x1)
                | (UInt32(truncatingIfNeeded: pDesc![Int(index)].ibiAck) << 0x10)
                | (UInt32(truncatingIfNeeded: pDesc![Int(index)].ctrlRoleReqAck) << 0x11)
                | (UInt32(truncatingIfNeeded: pDesc![Int(index)].ctrlStopTransfer) << 0x13)
                | (UInt32(truncatingIfNeeded: pDesc![Int(index)].ibiPayload) << 0x12))

            registers.write(
              I3CRegister(rawValue: 0x64 &+ 4 &* ((UInt32(pDesc![Int(index)].deviceIndex) &- 1)))!,
              value: write_value)
            index &+= 1
          }
        }
      }
    }
    return status

  }
  public func setResetPattern(_ resetPattern: UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var handle_state: UInt32

    do {

      handle_state = handle.read(.state)

      if handle.read(.mode) != 0x1 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else if (handle_state != 0x10) && (handle_state != 0x30) {
        status = .busy
      } else {
        handle.write(.state, value: 0x20)
        if resetPattern == 0x8 {
          llEnableResetPattern()
        } else {
          llDisableResetPattern()
        }

        updateState()
      }
    }
    return status

  }
  public func getResetPattern(_ pResetPattern: UnsafeMutablePointer<UInt32>?) -> HALStatus {

    var status: HALStatus = .ok

    if pResetPattern == nil {
      status = .error
    } else {

      if llIsEnabledResetPattern() == 1 {
        pResetPattern!.pointee = 0x8
      } else {
        pResetPattern!.pointee = 0x0
      }
    }
    return status

  }
  public func flushAllFIFO() -> HALStatus {

    var status: HALStatus = .ok
    var cfgr_value: UInt32

    do {

      if handle.read(.state) == 0x0 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        cfgr_value = (0x2000 | 0x200)

        if handle.read(.mode) == 0x1 {
          cfgr_value = (0x20000 | 0x200000)
        }

        registers.write(.cfgr, value: ((registers.read(.cfgr) & ~(cfgr_value)) | (cfgr_value)))
      }
    }
    return status

  }
  public func flushTransmitFIFO() -> HALStatus {

    var status: HALStatus = .ok

    do {

      if handle.read(.state) == 0x0 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        llRequestTxFIFOFlush()
      }
    }
    return status

  }
  public func flushReceiveFIFO() -> HALStatus {

    var status: HALStatus = .ok

    do {

      if handle.read(.state) == 0x0 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        llRequestRxFIFOFlush()
      }
    }
    return status

  }
  public func flushControlFIFO() -> HALStatus {

    var status: HALStatus = .ok

    do {

      if (handle.read(.state) == 0x0) || (handle.read(.mode) != 0x1) {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        llRequestControlFIFOFlush()
      }
    }
    return status

  }
  public func flushStatusFIFO() -> HALStatus {

    var status: HALStatus = .ok

    do {

      if (handle.read(.state) == 0x0) || (handle.read(.mode) != 0x1) {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        llRequestStatusFIFOFlush()
      }
    }
    return status

  }
  public func clearFIFOConfiguration() -> HALStatus {

    var status: HALStatus = .ok
    var cfgr_value: UInt32
    var cfgr_mask: UInt32

    do {

      if handle.read(.state) == 0x0 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        cfgr_value = (0x0 | 0x0)
        cfgr_mask = (0x4000 | 0x400)

        if handle.read(.mode) == 0x1 {
          cfgr_value |= (0x0 | 0x0)
          cfgr_mask |= (0x80000 | 0x40000)
        }

        registers.write(.cfgr, value: ((registers.read(.cfgr) & ~(cfgr_mask)) | (cfgr_value)))
      }
    }
    return status

  }
  public func getFIFOConfiguration(_ pConfig: UnsafeMutablePointer<I3CFIFOConfiguration>?)
    -> HALStatus
  {

    var status: HALStatus = .ok

    do {

      if pConfig == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.state) == 0x0 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        pConfig!.pointee.txFifoThreshold = llGetTxFIFOThreshold()

        pConfig!.pointee.rxFifoThreshold = llGetRxFIFOThreshold()

        pConfig!.pointee.controlFifo = UInt32(
          truncatingIfNeeded: (llIsEnabledControlFIFO() << 0x13))

        pConfig!.pointee.statusFifo = UInt32(truncatingIfNeeded: (llIsEnabledStatusFIFO() << 0x12))
      }
    }
    return status

  }
}
