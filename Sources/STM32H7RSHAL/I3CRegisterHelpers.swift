// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  func llClearFlagASUPD() {

    registers.write(.cevr, value: 0x1000_0000)

  }
  func llClearFlagCR() {

    registers.write(.cevr, value: 0x20000)

  }
  func llClearFlagCRUPD() {

    registers.write(.cevr, value: 0x40000)

  }
  func llClearFlagDAUPD() {

    registers.write(.cevr, value: 0x1000000)

  }
  func llClearFlagDEF() {

    registers.write(.cevr, value: 0x4000_0000)

  }
  func llClearFlagERR() {

    registers.write(.cevr, value: 0x800)

  }
  func llClearFlagFC() {

    registers.write(.cevr, value: 0x200)

  }
  func llClearFlagGET() {

    registers.write(.cevr, value: 0x400000)

  }
  func llClearFlagGRP() {

    registers.write(.cevr, value: 0x8000_0000)

  }
  func llClearFlagHJ() {

    registers.write(.cevr, value: 0x80000)

  }
  func llClearFlagIBI() {

    registers.write(.cevr, value: 0x8000)

  }
  func llClearFlagIBIEND() {

    registers.write(.cevr, value: 0x10000)

  }
  func llClearFlagINTUPD() {

    registers.write(.cevr, value: 0x2000_0000)

  }
  func llClearFlagMRLUPD() {

    registers.write(.cevr, value: 0x4000000)

  }
  func llClearFlagMWLUPD() {

    registers.write(.cevr, value: 0x2000000)

  }
  func llClearFlagRST() {

    registers.write(.cevr, value: 0x8000000)

  }
  func llClearFlagSTA() {

    registers.write(.cevr, value: 0x800000)

  }
  func llClearFlagWKP() {

    registers.write(.cevr, value: 0x200000)

  }
  func llConfigClockWaveForm(_ ClockWaveForm: UInt32) {

    registers.write(.timingr0, value: ClockWaveForm)

  }
  func llConfigTxPreload(_ TxDataCount: UInt32) {
    let TxDataCount = UInt32(UInt16(truncatingIfNeeded: TxDataCount))

    registers.write(
      .tgttdr,
      value: ((registers.read(.tgttdr) & ~((0x10000 | 0xffff))) | ((0x10000 | TxDataCount))))

  }
  func llControllerHandleCCC(_ CCCValue: UInt32, _ AddByteSize: UInt32, _ EndMode: UInt32) {

    registers.write(
      .cr,
      value: ((CCCValue << 0x10) | AddByteSize | EndMode | 0x3000_0000)
        & (0xff0000 | 0xffff | 0x7800_0000 | 0x8000_0000))

  }
  func llDisable() {

    registers.write(.cfgr, value: registers.read(.cfgr) & (~(0x1)))

  }
  func llDisableArbitrationHeader() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x4))

  }
  func llDisableDMAReqControl() {

    registers.write(.cfgr, value: registers.read(.cfgr) & (~(0x100000)))

  }
  func llDisableDMAReqRX() {

    registers.write(.cfgr, value: registers.read(.cfgr) & (~(0x100)))

  }
  func llDisableDMAReqStatus() {

    registers.write(.cfgr, value: registers.read(.cfgr) & (~(0x10000)))

  }
  func llDisableDMAReqTX() {

    registers.write(.cfgr, value: registers.read(.cfgr) & (~(0x1000)))

  }
  func llDisableExitPattern() {

    registers.write(.cfgr, value: registers.read(.cfgr) & (~(0x10)))

  }
  func llDisableResetPattern() {

    registers.write(.cfgr, value: registers.read(.cfgr) & (~(0x8)))

  }
  func llEnable() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x1))

  }
  func llEnableArbitrationHeader() {

    registers.write(.cfgr, value: registers.read(.cfgr) & (~(0x4)))

  }
  func llEnableDMAReqControl() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x100000))

  }
  func llEnableDMAReqRX() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x100))

  }
  func llEnableDMAReqTX() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x1000))

  }
  func llEnableOwnDynAddress() {

    registers.write(.devr0, value: registers.read(.devr0) | (0x1))

  }
  func llEnableResetPattern() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x8))

  }
  func llGetActivityState() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.devr0) & 0x300000)))

  }
  func llGetDeviceIBIPayload() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.bcr) & 0x4)))

  }
  func llGetIBIPayload() -> UInt32 {

    return UInt32(truncatingIfNeeded: (registers.read(.ibidr)))

  }
  func llGetIBITargetAddr() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.rmr) & 0xfe0000) >> 0x11))

  }
  func llGetMaxReadLength() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.maxrlr) & 0xffff)))

  }
  func llGetMaxWriteLength() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.maxwlr) & 0xffff)))

  }
  func llGetMessageErrorCode() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.ser) & 0xf)))

  }
  func llGetNbIBIAddData() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.rmr) & 0x7)))

  }
  func llGetOwnDynamicAddress() -> UInt32 {

    return UInt32(UInt8(truncatingIfNeeded: ((registers.read(.devr0) & 0xfe) >> 0x1)))

  }
  func llGetResetAction() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.devr0) & 0xc00000)))

  }
  func llGetRxFIFOThreshold() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.cfgr) & 0x400)))

  }
  func llGetTxFIFOThreshold() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.cfgr) & 0x4000)))

  }
  func llGetXferDataCount() -> UInt32 {

    return UInt32(truncatingIfNeeded: ((registers.read(.sr) & 0xffff)))

  }
  func llIsActiveFlagANACK() -> UInt32 {

    return (((registers.read(.ser) & 0x100) == (0x100)) ? 1 : 0)

  }
  func llIsActiveFlagCOVR() -> UInt32 {

    return (((registers.read(.ser) & 0x80) == (0x80)) ? 1 : 0)

  }
  func llIsActiveFlagDERR() -> UInt32 {

    return (((registers.read(.ser) & 0x400) == (0x400)) ? 1 : 0)

  }
  func llIsActiveFlagDNACK() -> UInt32 {

    return (((registers.read(.ser) & 0x200) == (0x200)) ? 1 : 0)

  }
  func llIsActiveFlagDOVR() -> UInt32 {

    return (((registers.read(.ser) & 0x40) == (0x40)) ? 1 : 0)

  }
  func llIsActiveFlagPERR() -> UInt32 {

    return (((registers.read(.ser) & 0x10) == (0x10)) ? 1 : 0)

  }
  func llIsActiveFlagSTALL() -> UInt32 {

    return (((registers.read(.ser) & 0x20) == (0x20)) ? 1 : 0)

  }
  func llIsEnabledArbitrationHeader() -> UInt32 {

    return (((registers.read(.cfgr) & 0x4) == (0x4)) ? 0 : 1)

  }
  func llIsEnabledControlFIFO() -> UInt32 {

    return (((registers.read(.cfgr) & 0x80000) == (0x80000)) ? 1 : 0)

  }
  func llIsEnabledControllerRoleReq() -> UInt32 {

    return (((registers.read(.devr0) & 0x20000) == (0x20000)) ? 1 : 0)

  }
  func llIsEnabledHotJoin() -> UInt32 {

    return (((registers.read(.devr0) & 0x80000) == (0x80000)) ? 1 : 0)

  }
  func llIsEnabledIBI() -> UInt32 {

    return (((registers.read(.devr0) & 0x10000) == (0x10000)) ? 1 : 0)

  }
  func llIsEnabledOwnDynAddress() -> UInt32 {

    return (((registers.read(.devr0) & 0x1) == (0x1)) ? 1 : 0)

  }
  func llIsEnabledResetPattern() -> UInt32 {

    return (((registers.read(.cfgr) & 0x8) == (0x8)) ? 1 : 0)

  }
  func llIsEnabledStatusFIFO() -> UInt32 {

    return (((registers.read(.cfgr) & 0x40000) == (0x40000)) ? 1 : 0)

  }
  func llReceiveData32() -> UInt32 {

    return UInt32(truncatingIfNeeded: (registers.read(.rdwr)))

  }
  func llReceiveData8() -> UInt32 {

    return UInt32(UInt8(truncatingIfNeeded: ((registers.read(.rdr) & 0xff))))

  }
  func llRequestControlFIFOFlush() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x200000))

  }
  func llRequestRxFIFOFlush() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x200))

  }
  func llRequestStatusFIFOFlush() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x20000))

  }
  func llRequestTransfer() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x4000_0000))

  }
  func llRequestTxFIFOFlush() {

    registers.write(.cfgr, value: registers.read(.cfgr) | (0x2000))

  }
  func llSetAvalTiming(_ AvalTiming: UInt32) {

    registers.write(
      .timingr1, value: ((registers.read(.timingr1) & ~(0xff)) | ((AvalTiming << 0x0))))

  }
  func llSetCtrlBusCharacteristic(_ CtrlBusCharacteristic: UInt32) {

    registers.write(.timingr1, value: CtrlBusCharacteristic)

  }
  func llSetDeviceCharacteristics(_ DeviceCharacteristics: UInt32) {

    registers.write(.dcr, value: ((registers.read(.dcr) & ~(0xff)) | (DeviceCharacteristics)))

  }
  func llSetIBIPayload(_ OwnIBIPayload: UInt32) {

    registers.write(.ibidr, value: OwnIBIPayload)

  }
  func llSetMIPIInstanceID(_ MIPIInstanceID: UInt32) {

    registers.write(
      .epidr, value: ((registers.read(.epidr) & ~(0xf000)) | ((MIPIInstanceID << 0xc))))

  }
  func llSetMaxWriteLength(_ MaxWriteLength: UInt32) {
    let MaxWriteLength = UInt32(UInt16(truncatingIfNeeded: MaxWriteLength))

    registers.write(.maxwlr, value: ((registers.read(.maxwlr) & ~(0xffff)) | (MaxWriteLength)))

  }
  func llSetMode(_ PeripheralMode: UInt32) {

    registers.write(.cfgr, value: ((registers.read(.cfgr) & ~(0x2)) | (PeripheralMode)))

  }
  func llSetOwnDynamicAddress(_ OwnDynamicAddress: UInt32) {

    registers.write(
      .devr0, value: ((registers.read(.devr0) & ~(0xfe)) | ((OwnDynamicAddress << 0x1))))

  }
  func llSetPendingReadMDB(_ PendingReadMDB: UInt32) {

    registers.write(.getcapr, value: ((registers.read(.getcapr) & ~(0x4000)) | (PendingReadMDB)))

  }
  func llTargetHandleMessage(_ MessageType: UInt32, _ IBISize: UInt32) {

    registers.write(.cr, value: (MessageType | IBISize) & (0xffff | 0x7800_0000))

  }
  func llTransmitData32(_ Data: UInt32) {

    registers.write(.tdwr, value: Data)

  }
  func llTransmitData8(_ Data: UInt32) {
    let Data = UInt32(UInt8(truncatingIfNeeded: Data))

    registers.write(.tdr, value: Data)

  }
}
