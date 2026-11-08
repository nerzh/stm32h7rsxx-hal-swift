// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getMode() -> UInt32 {

    return handle.read(.mode)

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
  public func getCCCInfo(_ notifyId: UInt32, _ pCCCInfo: UnsafeMutablePointer<I3CCCCInfo>?)
    -> HALStatus
  {

    var status: HALStatus = .ok

    do {
      if pCCCInfo == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else if handle.read(.state) == 0x0 {
        handle.write(.errorCode, value: 0x200000)
        status = .error
      } else {
        if (notifyId & 0x4) == 0x4 {
          pCCCInfo!.pointee.dynamicAddrValid = llIsEnabledOwnDynAddress()
          pCCCInfo!.pointee.dynamicAddr = llGetOwnDynamicAddress()
        }

        if (notifyId & 0x20) == 0x20 {
          pCCCInfo!.pointee.maxWriteLength = llGetMaxWriteLength()
        }

        if (notifyId & 0x40) == 0x40 {
          pCCCInfo!.pointee.maxReadLength = llGetMaxReadLength()
        }

        if (notifyId & 0x80) == 0x80 {
          pCCCInfo!.pointee.resetAction = llGetResetAction()
        }

        if (notifyId & 0x100) == 0x100 {
          pCCCInfo!.pointee.activityState = llGetActivityState()
        }

        if (notifyId & 0x200) == 0x200 {
          pCCCInfo!.pointee.hotJoinAllowed = llIsEnabledHotJoin()
          pCCCInfo!.pointee.inBandAllowed = llIsEnabledIBI()
          pCCCInfo!.pointee.ctrlRoleAllowed = llIsEnabledControllerRoleReq()
        }

        if (notifyId & 0x2000) == 0x2000 {
          pCCCInfo!.pointee.ibicrTgtAddr = llGetIBITargetAddr()
          pCCCInfo!.pointee.ibiTgtNbPayload = llGetNbIBIAddData()
          pCCCInfo!.pointee.ibiTgtPayload = llGetIBIPayload()
        }

        if (notifyId & 0x4000) == 0x4000 {
          pCCCInfo!.pointee.ibicrTgtAddr = llGetIBITargetAddr()
        }
      }
    }
    return status

  }
  public func getDynamicAddressPayload(
    _ ENTDAA_payload: UInt64, _ pENTDAA_payload: UnsafeMutablePointer<I3CENTDAAPayload>?
  ) -> HALStatus {

    var status: HALStatus = .ok
    var BCR: UInt32
    var PID: UInt64

    do {
      if pENTDAA_payload == nil {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else {
        BCR = (((UInt32(truncatingIfNeeded: (UInt64((ENTDAA_payload)) >> 0x30))) & 0xff))

        pENTDAA_payload!.pointee.bcr.ibiPayload = ((((((BCR) & 0x4) >> 0x2) == 1) ? 1 : 0))
        pENTDAA_payload!.pointee.bcr.ibiRequestCapable = ((((((BCR) & 0x2) >> 0x1) == 1) ? 1 : 0))
        pENTDAA_payload!.pointee.bcr.deviceRole = ((((((BCR) & 0x40) >> 0x6) == 1) ? 1 : 0))
        pENTDAA_payload!.pointee.bcr.advancedCapabilities =
          ((((((BCR) & 0x20) >> 0x5) == 1) ? 1 : 0))
        pENTDAA_payload!.pointee.bcr.offlineCapable = ((((((BCR) & 0x8) >> 0x3) == 1) ? 1 : 0))
        pENTDAA_payload!.pointee.bcr.virtualTargetSupport =
          ((((((BCR) & 0x10) >> 0x4) == 1) ? 1 : 0))
        pENTDAA_payload!.pointee.bcr.maxDataSpeedLimitation =
          ((((((BCR) & 0x1) >> 0x0) == 1) ? 1 : 0))

        pENTDAA_payload!.pointee.dcr =
          (((UInt32(truncatingIfNeeded: (UInt64((ENTDAA_payload)) >> 0x38))) & 0xff))

        PID = ((UInt64((ENTDAA_payload)) & 0xffff_ffff_ffff))

        PID = UInt64(
          (((UInt64(
            ((UInt32(
              truncatingIfNeeded: ((((UInt32(truncatingIfNeeded: PID)) & 0xff00_0000) >> 24)
                | (((UInt32(truncatingIfNeeded: PID)) & 0x00ff_0000) >> 8)
                | (((UInt32(truncatingIfNeeded: PID)) & 0x0000_ff00) << 8)
                | (((UInt32(truncatingIfNeeded: PID)) & 0x0000_00ff) << 24)))))) << 32)
            | (UInt64(
              ((UInt32(
                truncatingIfNeeded: ((((UInt32(truncatingIfNeeded: (PID >> 32))) & 0xff00_0000)
                  >> 24) | (((UInt32(truncatingIfNeeded: (PID >> 32))) & 0x00ff_0000) >> 8)
                  | (((UInt32(truncatingIfNeeded: (PID >> 32))) & 0x0000_ff00) << 8)
                  | (((UInt32(truncatingIfNeeded: (PID >> 32))) & 0x0000_00ff) << 24))))))))
            >> 16))

        pENTDAA_payload!.pointee.pid.mipimid = UInt16(
          truncatingIfNeeded: ((UInt32(UInt16(truncatingIfNeeded: (UInt64((PID)) >> 0x21))) & 0x7fff))
        )
        pENTDAA_payload!.pointee.pid.idtsel = UInt8(
          truncatingIfNeeded: ((UInt32(UInt8(truncatingIfNeeded: (UInt64((PID)) >> 0x20))) & 0x1)))
        pENTDAA_payload!.pointee.pid.partID = UInt16(
          truncatingIfNeeded: ((UInt32(UInt16(truncatingIfNeeded: (UInt64((PID)) >> 0x10))) & 0xffff))
        )
        pENTDAA_payload!.pointee.pid.mipiid = UInt8(
          truncatingIfNeeded: ((UInt32(UInt8(truncatingIfNeeded: (UInt64((PID)) >> 0xc))) & 0xf)))
      }
    }
    return status

  }
}
