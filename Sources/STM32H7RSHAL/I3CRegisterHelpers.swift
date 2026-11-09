// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
    func llClearFlagASUPD() {
        STM32H7RSHAL.LL_I3C_ClearFlag_ASUPD(registers)
    }
    func llClearFlagCR() {
        STM32H7RSHAL.LL_I3C_ClearFlag_CR(registers)
    }
    func llClearFlagCRUPD() {
        STM32H7RSHAL.LL_I3C_ClearFlag_CRUPD(registers)
    }
    func llClearFlagDAUPD() {
        STM32H7RSHAL.LL_I3C_ClearFlag_DAUPD(registers)
    }
    func llClearFlagDEF() {
        STM32H7RSHAL.LL_I3C_ClearFlag_DEF(registers)
    }
    func llClearFlagERR() {
        STM32H7RSHAL.LL_I3C_ClearFlag_ERR(registers)
    }
    func llClearFlagFC() {
        STM32H7RSHAL.LL_I3C_ClearFlag_FC(registers)
    }
    func llClearFlagGET() {
        STM32H7RSHAL.LL_I3C_ClearFlag_GET(registers)
    }
    func llClearFlagGRP() {
        STM32H7RSHAL.LL_I3C_ClearFlag_GRP(registers)
    }
    func llClearFlagHJ() {
        STM32H7RSHAL.LL_I3C_ClearFlag_HJ(registers)
    }
    func llClearFlagIBI() {
        STM32H7RSHAL.LL_I3C_ClearFlag_IBI(registers)
    }
    func llClearFlagIBIEND() {
        STM32H7RSHAL.LL_I3C_ClearFlag_IBIEND(registers)
    }
    func llClearFlagINTUPD() {
        STM32H7RSHAL.LL_I3C_ClearFlag_INTUPD(registers)
    }
    func llClearFlagMRLUPD() {
        STM32H7RSHAL.LL_I3C_ClearFlag_MRLUPD(registers)
    }
    func llClearFlagMWLUPD() {
        STM32H7RSHAL.LL_I3C_ClearFlag_MWLUPD(registers)
    }
    func llClearFlagRST() {
        STM32H7RSHAL.LL_I3C_ClearFlag_RST(registers)
    }
    func llClearFlagSTA() {
        STM32H7RSHAL.LL_I3C_ClearFlag_STA(registers)
    }
    func llClearFlagWKP() {
        STM32H7RSHAL.LL_I3C_ClearFlag_WKP(registers)
    }
    func llConfigClockWaveForm(_ ClockWaveForm: UInt32) {
        STM32H7RSHAL.LL_I3C_ConfigClockWaveForm(registers, ClockWaveForm)
    }
    func llConfigTxPreload(_ TxDataCount: UInt32) {
        STM32H7RSHAL.LL_I3C_ConfigTxPreload(registers, UInt16(truncatingIfNeeded: TxDataCount))
    }
    func llControllerHandleCCC(_ CCCValue: UInt32, _ AddByteSize: UInt32, _ EndMode: UInt32) {
        STM32H7RSHAL.LL_I3C_ControllerHandleCCC(registers, CCCValue, AddByteSize, EndMode)
    }
    func llDisable() {
        STM32H7RSHAL.LL_I3C_Disable(registers)
    }
    func llDisableArbitrationHeader() {
        STM32H7RSHAL.LL_I3C_DisableArbitrationHeader(registers)
    }
    func llDisableDMAReqControl() {
        STM32H7RSHAL.LL_I3C_DisableDMAReq_Control(registers)
    }
    func llDisableDMAReqRX() {
        STM32H7RSHAL.LL_I3C_DisableDMAReq_RX(registers)
    }
    func llDisableDMAReqStatus() {
        STM32H7RSHAL.LL_I3C_DisableDMAReq_Status(registers)
    }
    func llDisableDMAReqTX() {
        STM32H7RSHAL.LL_I3C_DisableDMAReq_TX(registers)
    }
    func llDisableExitPattern() {
        STM32H7RSHAL.LL_I3C_DisableExitPattern(registers)
    }
    func llDisableResetPattern() {
        STM32H7RSHAL.LL_I3C_DisableResetPattern(registers)
    }
    func llEnable() {
        STM32H7RSHAL.LL_I3C_Enable(registers)
    }
    func llEnableArbitrationHeader() {
        STM32H7RSHAL.LL_I3C_EnableArbitrationHeader(registers)
    }
    func llEnableDMAReqControl() {
        STM32H7RSHAL.LL_I3C_EnableDMAReq_Control(registers)
    }
    func llEnableDMAReqRX() {
        STM32H7RSHAL.LL_I3C_EnableDMAReq_RX(registers)
    }
    func llEnableDMAReqTX() {
        STM32H7RSHAL.LL_I3C_EnableDMAReq_TX(registers)
    }
    func llEnableOwnDynAddress() {
        STM32H7RSHAL.LL_I3C_EnableOwnDynAddress(registers)
    }
    func llEnableResetPattern() {
        STM32H7RSHAL.LL_I3C_EnableResetPattern(registers)
    }
    func llGetActivityState() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetActivityState(registers)
    }
    func llGetDeviceIBIPayload() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetDeviceIBIPayload(registers)
    }
    func llGetIBIPayload() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetIBIPayload(registers)
    }
    func llGetIBITargetAddr() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetIBITargetAddr(registers)
    }
    func llGetMaxReadLength() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetMaxReadLength(registers)
    }
    func llGetMaxWriteLength() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetMaxWriteLength(registers)
    }
    func llGetMessageErrorCode() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetMessageErrorCode(registers)
    }
    func llGetNbIBIAddData() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetNbIBIAddData(registers)
    }
    func llGetOwnDynamicAddress() -> UInt32 {
        UInt32(STM32H7RSHAL.LL_I3C_GetOwnDynamicAddress(registers))
    }
    func llGetResetAction() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetResetAction(registers)
    }
    func llGetRxFIFOThreshold() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetRxFIFOThreshold(registers)
    }
    func llGetTxFIFOThreshold() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetTxFIFOThreshold(registers)
    }
    func llGetXferDataCount() -> UInt32 {
        STM32H7RSHAL.LL_I3C_GetXferDataCount(registers)
    }
    func llIsActiveFlagANACK() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsActiveFlag_ANACK(registers)
    }
    func llIsActiveFlagCOVR() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsActiveFlag_COVR(registers)
    }
    func llIsActiveFlagDERR() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsActiveFlag_DERR(registers)
    }
    func llIsActiveFlagDNACK() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsActiveFlag_DNACK(registers)
    }
    func llIsActiveFlagDOVR() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsActiveFlag_DOVR(registers)
    }
    func llIsActiveFlagPERR() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsActiveFlag_PERR(registers)
    }
    func llIsActiveFlagSTALL() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsActiveFlag_STALL(registers)
    }
    func llIsEnabledArbitrationHeader() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsEnabledArbitrationHeader(registers)
    }
    func llIsEnabledControlFIFO() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsEnabledControlFIFO(registers)
    }
    func llIsEnabledControllerRoleReq() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsEnabledControllerRoleReq(registers)
    }
    func llIsEnabledHotJoin() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsEnabledHotJoin(registers)
    }
    func llIsEnabledIBI() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsEnabledIBI(registers)
    }
    func llIsEnabledOwnDynAddress() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsEnabledOwnDynAddress(registers)
    }
    func llIsEnabledResetPattern() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsEnabledResetPattern(registers)
    }
    func llIsEnabledStatusFIFO() -> UInt32 {
        STM32H7RSHAL.LL_I3C_IsEnabledStatusFIFO(registers)
    }
    func llReceiveData32() -> UInt32 {
        STM32H7RSHAL.LL_I3C_ReceiveData32(registers)
    }
    func llReceiveData8() -> UInt32 {
        UInt32(STM32H7RSHAL.LL_I3C_ReceiveData8(registers))
    }
    func llRequestControlFIFOFlush() {
        STM32H7RSHAL.LL_I3C_RequestControlFIFOFlush(registers)
    }
    func llRequestRxFIFOFlush() {
        STM32H7RSHAL.LL_I3C_RequestRxFIFOFlush(registers)
    }
    func llRequestStatusFIFOFlush() {
        STM32H7RSHAL.LL_I3C_RequestStatusFIFOFlush(registers)
    }
    func llRequestTransfer() {
        STM32H7RSHAL.LL_I3C_RequestTransfer(registers)
    }
    func llRequestTxFIFOFlush() {
        STM32H7RSHAL.LL_I3C_RequestTxFIFOFlush(registers)
    }
    func llSetAvalTiming(_ AvalTiming: UInt32) {
        STM32H7RSHAL.LL_I3C_SetAvalTiming(registers, AvalTiming)
    }
    func llSetCtrlBusCharacteristic(_ CtrlBusCharacteristic: UInt32) {
        STM32H7RSHAL.LL_I3C_SetCtrlBusCharacteristic(registers, CtrlBusCharacteristic)
    }
    func llSetDeviceCharacteristics(_ DeviceCharacteristics: UInt32) {
        STM32H7RSHAL.LL_I3C_SetDeviceCharacteristics(registers, DeviceCharacteristics)
    }
    func llSetIBIPayload(_ OwnIBIPayload: UInt32) {
        STM32H7RSHAL.LL_I3C_SetIBIPayload(registers, OwnIBIPayload)
    }
    func llSetMIPIInstanceID(_ MIPIInstanceID: UInt32) {
        STM32H7RSHAL.LL_I3C_SetMIPIInstanceID(registers, MIPIInstanceID)
    }
    func llSetMaxWriteLength(_ MaxWriteLength: UInt32) {
        STM32H7RSHAL.LL_I3C_SetMaxWriteLength(registers, UInt16(truncatingIfNeeded: MaxWriteLength))
    }
    func llSetMode(_ PeripheralMode: UInt32) {
        STM32H7RSHAL.LL_I3C_SetMode(registers, PeripheralMode)
    }
    func llSetOwnDynamicAddress(_ OwnDynamicAddress: UInt32) {
        STM32H7RSHAL.LL_I3C_SetOwnDynamicAddress(registers, OwnDynamicAddress)
    }
    func llSetPendingReadMDB(_ PendingReadMDB: UInt32) {
        STM32H7RSHAL.LL_I3C_SetPendingReadMDB(registers, PendingReadMDB)
    }
    func llTargetHandleMessage(_ MessageType: UInt32, _ IBISize: UInt32) {
        STM32H7RSHAL.LL_I3C_TargetHandleMessage(registers, MessageType, IBISize)
    }
    func llTransmitData32(_ Data: UInt32) {
        STM32H7RSHAL.LL_I3C_TransmitData32(registers, Data)
    }
    func llTransmitData8(_ Data: UInt32) {
        STM32H7RSHAL.LL_I3C_TransmitData8(registers, UInt8(truncatingIfNeeded: Data))
    }
}
