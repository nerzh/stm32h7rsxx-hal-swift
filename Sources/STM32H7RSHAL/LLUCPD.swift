// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_UCPD_SR_TXIS: UInt32 = 0x0000_0001
public let LL_UCPD_SR_TXMSGDISC: UInt32 = 0x0000_0002
public let LL_UCPD_SR_TXMSGSENT: UInt32 = 0x0000_0004
public let LL_UCPD_SR_TXMSGABT: UInt32 = 0x0000_0008
public let LL_UCPD_SR_HRSTDISC: UInt32 = 0x0000_0010
public let LL_UCPD_SR_HRSTSENT: UInt32 = 0x0000_0020
public let LL_UCPD_SR_TXUND: UInt32 = 0x0000_0040
public let LL_UCPD_SR_RXNE: UInt32 = 0x0000_0100
public let LL_UCPD_SR_RXORDDET: UInt32 = 0x0000_0200
public let LL_UCPD_SR_RXHRSTDET: UInt32 = 0x0000_0400
public let LL_UCPD_SR_RXOVR: UInt32 = 0x0000_0800
public let LL_UCPD_SR_RXMSGEND: UInt32 = 0x0000_1000
public let LL_UCPD_SR_RXERR: UInt32 = 0x0000_2000
public let LL_UCPD_SR_TYPECEVT1: UInt32 = 0x0000_4000
public let LL_UCPD_SR_TYPECEVT2: UInt32 = 0x0000_8000
public let LL_UCPD_SR_TYPEC_VSTATE_CC1: UInt32 = 0x0003_0000
public let LL_UCPD_SR_TYPEC_VSTATE_CC2: UInt32 = 0x000C_0000
public let LL_UCPD_SR_FRSEVT: UInt32 = 0x0010_0000
public let LL_UCPD_IMR_TXIS: UInt32 = 0x0000_0001
public let LL_UCPD_IMR_TXMSGDISC: UInt32 = 0x0000_0002
public let LL_UCPD_IMR_TXMSGSENT: UInt32 = 0x0000_0004
public let LL_UCPD_IMR_TXMSGABT: UInt32 = 0x0000_0008
public let LL_UCPD_IMR_HRSTDISC: UInt32 = 0x0000_0010
public let LL_UCPD_IMR_HRSTSENT: UInt32 = 0x0000_0020
public let LL_UCPD_IMR_TXUND: UInt32 = 0x0000_0040
public let LL_UCPD_IMR_RXNE: UInt32 = 0x0000_0100
public let LL_UCPD_IMR_RXORDDET: UInt32 = 0x0000_0200
public let LL_UCPD_IMR_RXHRSTDET: UInt32 = 0x0000_0400
public let LL_UCPD_IMR_RXOVR: UInt32 = 0x0000_0800
public let LL_UCPD_IMR_RXMSGEND: UInt32 = 0x0000_1000
public let LL_UCPD_IMR_TYPECEVT1: UInt32 = 0x0000_4000
public let LL_UCPD_IMR_TYPECEVT2: UInt32 = 0x0000_8000
public let LL_UCPD_IMR_FRSEVT: UInt32 = 0x0010_0000
public let LL_UCPD_SYNC1: UInt32 = 0x0000_0018
public let LL_UCPD_SYNC2: UInt32 = 0x0000_0011
public let LL_UCPD_SYNC3: UInt32 = 0x0000_0006
public let LL_UCPD_RST1: UInt32 = 0x0000_0007
public let LL_UCPD_RST2: UInt32 = 0x0000_0019
public let LL_UCPD_EOP: UInt32 = 0x0000_000D
public let LL_UCPD_ORDERED_SET_SOP: UInt32 = 0x0008_E318
public let LL_UCPD_ORDERED_SET_SOP1: UInt32 = 0x0003_1B18
public let LL_UCPD_ORDERED_SET_SOP2: UInt32 = 0x0003_60D8
public let LL_UCPD_ORDERED_SET_HARD_RESET: UInt32 = 0x000C_9CE7
public let LL_UCPD_ORDERED_SET_CABLE_RESET: UInt32 = 0x0003_1F07
public let LL_UCPD_ORDERED_SET_SOP1_DEBUG: UInt32 = 0x0003_6738
public let LL_UCPD_ORDERED_SET_SOP2_DEBUG: UInt32 = 0x0008_9B38
public let LL_UCPD_ROLE_SNK: UInt32 = 0x0000_0200
public let LL_UCPD_ROLE_SRC: UInt32 = 0x0000_0000
public let LL_UCPD_RESISTOR_DEFAULT: UInt32 = 0x0000_0080
public let LL_UCPD_RESISTOR_1_5A: UInt32 = 0x0000_0100
public let LL_UCPD_RESISTOR_3_0A: UInt32 = 0x0000_0180
public let LL_UCPD_RESISTOR_NONE: UInt32 = 0x0000_0000
public let LL_UCPD_ORDERSET_SOP: UInt32 = 0x0010_0000
public let LL_UCPD_ORDERSET_SOP1: UInt32 = 0x0020_0000
public let LL_UCPD_ORDERSET_SOP2: UInt32 = 0x0040_0000
public let LL_UCPD_ORDERSET_HARDRST: UInt32 = 0x0080_0000
public let LL_UCPD_ORDERSET_CABLERST: UInt32 = 0x0100_0000
public let LL_UCPD_ORDERSET_SOP1_DEBUG: UInt32 = 0x0200_0000
public let LL_UCPD_ORDERSET_SOP2_DEBUG: UInt32 = 0x0400_0000
public let LL_UCPD_ORDERSET_SOP_EXT1: UInt32 = 0x0800_0000
public let LL_UCPD_ORDERSET_SOP_EXT2: UInt32 = 0x1000_0000
public let LL_UCPD_SNK_CC1_VOPEN: UInt32 = 0x0000_0000
public let LL_UCPD_SNK_CC1_VRP: UInt32 = 0x0001_0000
public let LL_UCPD_SNK_CC1_VRP15A: UInt32 = 0x0002_0000
public let LL_UCPD_SNK_CC1_VRP30A: UInt32 = 0x0003_0000
public let LL_UCPD_SNK_CC2_VOPEN: UInt32 = 0x0000_0000
public let LL_UCPD_SNK_CC2_VRP: UInt32 = 0x0004_0000
public let LL_UCPD_SNK_CC2_VRP15A: UInt32 = 0x0008_0000
public let LL_UCPD_SNK_CC2_VRP30A: UInt32 = 0x000C_0000
public let LL_UCPD_SRC_CC1_VRA: UInt32 = 0x0000_0000
public let LL_UCPD_SRC_CC1_VRD: UInt32 = 0x0001_0000
public let LL_UCPD_SRC_CC1_OPEN: UInt32 = 0x0002_0000
public let LL_UCPD_SRC_CC2_VRA: UInt32 = 0x0000_0000
public let LL_UCPD_SRC_CC2_VRD: UInt32 = 0x0004_0000
public let LL_UCPD_SRC_CC2_OPEN: UInt32 = 0x0008_0000
public let LL_UCPD_PSC_DIV1: UInt32 = 0x0000_0000
public let LL_UCPD_PSC_DIV2: UInt32 = 0x0002_0000
public let LL_UCPD_PSC_DIV4: UInt32 = 0x0004_0000
public let LL_UCPD_PSC_DIV8: UInt32 = 0x0006_0000
public let LL_UCPD_PSC_DIV16: UInt32 = 0x0008_0000
public let LL_UCPD_CCENABLE_NONE: UInt32 = 0x0000_0000
public let LL_UCPD_CCENABLE_CC1: UInt32 = 0x0000_0400
public let LL_UCPD_CCENABLE_CC2: UInt32 = 0x0000_0800
public let LL_UCPD_CCENABLE_CC1CC2: UInt32 = 0x0000_0C00
public let LL_UCPD_CCPIN_CC1: UInt32 = 0x0000_0000
public let LL_UCPD_CCPIN_CC2: UInt32 = 0x0000_0040
public let LL_UCPD_RXMODE_NORMAL: UInt32 = 0x0000_0000
public let LL_UCPD_RXMODE_BIST_TEST_DATA: UInt32 = 0x0000_0010
public let LL_UCPD_TXMODE_NORMAL: UInt32 = 0x0000_0000
public let LL_UCPD_TXMODE_CABLE_RESET: UInt32 = 0x0000_0001
public let LL_UCPD_TXMODE_BIST_CARRIER2: UInt32 = 0x0000_0002
public let LL_UCPD_RXORDSET_SOP: UInt32 = 0x0000_0000
public let LL_UCPD_RXORDSET_SOP1: UInt32 = 0x0000_0001
public let LL_UCPD_RXORDSET_SOP2: UInt32 = 0x0000_0002
public let LL_UCPD_RXORDSET_SOP1_DEBUG: UInt32 = 0x0000_0003
public let LL_UCPD_RXORDSET_SOP2_DEBUG: UInt32 = 0x0000_0004
public let LL_UCPD_RXORDSET_CABLE_RESET: UInt32 = 0x0000_0005
public let LL_UCPD_RXORDSET_SOPEXT1: UInt32 = 0x0000_0006
public let LL_UCPD_RXORDSET_SOPEXT2: UInt32 = 0x0000_0007

public func LL_UCPD_Enable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg1, value: registers.read(UCPDRegister.cfg1) | (0x8000_0000))
}

public func LL_UCPD_Disable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg1, value: registers.read(UCPDRegister.cfg1) & ~(0x8000_0000))
}

public func LL_UCPD_IsEnabled<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.cfg1) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_UCPD_SetRxOrderSet<IO: UCPDRegisterIO>(_ registers: IO, _ OrderSet: UInt32) {
    registers.write(UCPDRegister.cfg1, value: (registers.read(UCPDRegister.cfg1) & ~(0x1ff0_0000)) | (OrderSet))
}

public func LL_UCPD_SetPSCClk<IO: UCPDRegisterIO>(_ registers: IO, _ Psc: UInt32) {
    registers.write(UCPDRegister.cfg1, value: (registers.read(UCPDRegister.cfg1) & ~(0xe0000)) | (Psc))
}

public func LL_UCPD_SetTransWin<IO: UCPDRegisterIO>(_ registers: IO, _ TransWin: UInt32) {
    registers.write(UCPDRegister.cfg1, value: (registers.read(UCPDRegister.cfg1) & ~(0xf800)) | (TransWin << 0xb))
}

public func LL_UCPD_SetIfrGap<IO: UCPDRegisterIO>(_ registers: IO, _ IfrGap: UInt32) {
    registers.write(UCPDRegister.cfg1, value: (registers.read(UCPDRegister.cfg1) & ~(0x7c0)) | (IfrGap << 0x6))
}

public func LL_UCPD_SetHbitClockDiv<IO: UCPDRegisterIO>(_ registers: IO, _ HbitClock: UInt32) {
    registers.write(UCPDRegister.cfg1, value: (registers.read(UCPDRegister.cfg1) & ~(0x3f)) | (HbitClock << 0x0))
}

public func LL_UCPD_RxAnalogFilterEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg2, value: registers.read(UCPDRegister.cfg2) | (0x100))
}

public func LL_UCPD_RxAnalogFilterDisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg2, value: registers.read(UCPDRegister.cfg2) & ~(0x100))
}

public func LL_UCPD_WakeUpEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg2, value: registers.read(UCPDRegister.cfg2) | (0x8))
}

public func LL_UCPD_WakeUpDisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg2, value: registers.read(UCPDRegister.cfg2) & ~(0x8))
}

public func LL_UCPD_ForceClockEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg2, value: registers.read(UCPDRegister.cfg2) | (0x4))
}

public func LL_UCPD_ForceClockDisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg2, value: registers.read(UCPDRegister.cfg2) & ~(0x4))
}

public func LL_UCPD_RxFilterEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg2, value: registers.read(UCPDRegister.cfg2) & ~(0x1))
}

public func LL_UCPD_RxFilterDisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg2, value: registers.read(UCPDRegister.cfg2) | (0x1))
}

public func LL_UCPD_TypeCDetectionCC2Enable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) & ~(0x200000))
}

public func LL_UCPD_TypeCDetectionCC2Disable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x200000))
}

public func LL_UCPD_TypeCDetectionCC1Enable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) & ~(0x100000))
}

public func LL_UCPD_TypeCDetectionCC1Disable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x100000))
}

public func LL_UCPD_VconnDischargeEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x40000))
}

public func LL_UCPD_VconnDischargeDisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) & ~(0x40000))
}

public func LL_UCPD_SignalFRSTX<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x20000))
}

public func LL_UCPD_FRSDetectionEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x10000))
}

public func LL_UCPD_FRSDetectionDisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) & ~(0x10000))
}

public func LL_UCPD_SetccEnable<IO: UCPDRegisterIO>(_ registers: IO, _ CCEnable: UInt32) {
    registers.write(UCPDRegister.cr, value: (registers.read(UCPDRegister.cr) & ~(0xc00)) | (CCEnable))
}

public func LL_UCPD_SetSNKRole<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x200))
}

public func LL_UCPD_SetSRCRole<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) & ~(0x200))
}

public func LL_UCPD_GetRole<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UCPDRegister.cr) & (0x200)))
}

public func LL_UCPD_SetRpResistor<IO: UCPDRegisterIO>(_ registers: IO, _ Resistor: UInt32) {
    registers.write(UCPDRegister.cr, value: (registers.read(UCPDRegister.cr) & ~(0x180)) | (Resistor))
}

public func LL_UCPD_SetCCPin<IO: UCPDRegisterIO>(_ registers: IO, _ CCPin: UInt32) {
    registers.write(UCPDRegister.cr, value: (registers.read(UCPDRegister.cr) & ~(0x40)) | (CCPin))
}

public func LL_UCPD_RxEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x20))
}

public func LL_UCPD_RxDisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) & ~(0x20))
}

public func LL_UCPD_SetRxMode<IO: UCPDRegisterIO>(_ registers: IO, _ RxMode: UInt32) {
    registers.write(UCPDRegister.cr, value: (registers.read(UCPDRegister.cr) & ~(0x10)) | (RxMode))
}

public func LL_UCPD_SendHardReset<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x8))
}

public func LL_UCPD_SendMessage<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cr, value: registers.read(UCPDRegister.cr) | (0x4))
}

public func LL_UCPD_SetTxMode<IO: UCPDRegisterIO>(_ registers: IO, _ TxMode: UInt32) {
    registers.write(UCPDRegister.cr, value: (registers.read(UCPDRegister.cr) & ~(0x3)) | (TxMode))
}

public func LL_UCPD_EnableIT_FRS<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x100000))
}

public func LL_UCPD_EnableIT_TypeCEventCC2<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x8000))
}

public func LL_UCPD_EnableIT_TypeCEventCC1<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x4000))
}

public func LL_UCPD_EnableIT_RxMsgEnd<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x1000))
}

public func LL_UCPD_EnableIT_RxOvr<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x800))
}

public func LL_UCPD_EnableIT_RxHRST<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x400))
}

public func LL_UCPD_EnableIT_RxOrderSet<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x200))
}

public func LL_UCPD_EnableIT_RxNE<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x100))
}

public func LL_UCPD_EnableIT_TxUND<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x40))
}

public func LL_UCPD_EnableIT_TxHRSTSENT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x20))
}

public func LL_UCPD_EnableIT_TxHRSTDISC<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x10))
}

public func LL_UCPD_EnableIT_TxMSGABT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x8))
}

public func LL_UCPD_EnableIT_TxMSGSENT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x4))
}

public func LL_UCPD_EnableIT_TxMSGDISC<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x2))
}

public func LL_UCPD_EnableIT_TxIS<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) | (0x1))
}

public func LL_UCPD_DisableIT_FRS<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x100000))
}

public func LL_UCPD_DisableIT_TypeCEventCC2<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x8000))
}

public func LL_UCPD_DisableIT_TypeCEventCC1<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x4000))
}

public func LL_UCPD_DisableIT_RxMsgEnd<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x1000))
}

public func LL_UCPD_DisableIT_RxOvr<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x800))
}

public func LL_UCPD_DisableIT_RxHRST<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x400))
}

public func LL_UCPD_DisableIT_RxOrderSet<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x200))
}

public func LL_UCPD_DisableIT_RxNE<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x100))
}

public func LL_UCPD_DisableIT_TxUND<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x40))
}

public func LL_UCPD_DisableIT_TxHRSTSENT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x20))
}

public func LL_UCPD_DisableIT_TxHRSTDISC<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x10))
}

public func LL_UCPD_DisableIT_TxMSGABT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x8))
}

public func LL_UCPD_DisableIT_TxMSGSENT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x4))
}

public func LL_UCPD_DisableIT_TxMSGDISC<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x2))
}

public func LL_UCPD_DisableIT_TxIS<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.imr, value: registers.read(UCPDRegister.imr) & ~(0x1))
}

public func LL_UCPD_IsEnableIT_FRS<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x100000)) == 0x100000) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TypeCEventCC2<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x8000)) == 0x8000) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TypeCEventCC1<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x4000)) == 0x4000) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_RxMsgEnd<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x1000)) == 0x1000) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_RxOvr<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x800)) == 0x800) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_RxHRST<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x400)) == 0x400) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_RxOrderSet<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x200)) == 0x200) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_RxNE<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x100)) == 0x100) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TxUND<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x40)) == 0x40) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TxHRSTSENT<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x20)) == 0x20) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TxHRSTDISC<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x10)) == 0x10) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TxMSGABT<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x8)) == 0x8) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TxMSGSENT<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x4)) == 0x4) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TxMSGDISC<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x2)) == 0x2) ? 1 : 0)
}

public func LL_UCPD_IsEnableIT_TxIS<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.imr) & (0x1)) == 0x1) ? 1 : 0)
}

public func LL_UCPD_ClearFlag_FRS<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x100000))
}

public func LL_UCPD_ClearFlag_TypeCEventCC2<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x8000))
}

public func LL_UCPD_ClearFlag_TypeCEventCC1<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x4000))
}

public func LL_UCPD_ClearFlag_RxMsgEnd<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x1000))
}

public func LL_UCPD_ClearFlag_RxOvr<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x800))
}

public func LL_UCPD_ClearFlag_RxHRST<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x400))
}

public func LL_UCPD_ClearFlag_RxOrderSet<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x200))
}

public func LL_UCPD_ClearFlag_TxUND<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x40))
}

public func LL_UCPD_ClearFlag_TxHRSTSENT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x20))
}

public func LL_UCPD_ClearFlag_TxHRSTDISC<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x10))
}

public func LL_UCPD_ClearFlag_TxMSGABT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x8))
}

public func LL_UCPD_ClearFlag_TxMSGSENT<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x4))
}

public func LL_UCPD_ClearFlag_TxMSGDISC<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.icr, value: registers.read(UCPDRegister.icr) | (0x2))
}

public func LL_UCPD_IsActiveFlag_FRS<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x100000)) == 0x100000) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TypeCEventCC2<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x8000)) == 0x8000) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TypeCEventCC1<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x4000)) == 0x4000) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_RxErr<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x2000)) == 0x2000) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_RxMsgEnd<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x1000)) == 0x1000) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_RxOvr<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x800)) == 0x800) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_RxHRST<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x400)) == 0x400) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_RxOrderSet<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x200)) == 0x200) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_RxNE<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x100)) == 0x100) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TxUND<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x40)) == 0x40) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TxHRSTSENT<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x20)) == 0x20) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TxHRSTDISC<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x10)) == 0x10) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TxMSGABT<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x8)) == 0x8) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TxMSGSENT<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x4)) == 0x4) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TxMSGDISC<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x2)) == 0x2) ? 1 : 0)
}

public func LL_UCPD_IsActiveFlag_TxIS<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.sr) & (0x1)) == 0x1) ? 1 : 0)
}

public func LL_UCPD_GetTypeCVstateCC2<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return registers.read(UCPDRegister.sr) & 0xc0000
}

public func LL_UCPD_GetTypeCVstateCC1<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return registers.read(UCPDRegister.sr) & 0x30000
}

public func LL_UCPD_RxDMAEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg1, value: registers.read(UCPDRegister.cfg1) | (0x4000_0000))
}

public func LL_UCPD_RxDMADisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg1, value: registers.read(UCPDRegister.cfg1) & ~(0x4000_0000))
}

public func LL_UCPD_TxDMAEnable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg1, value: registers.read(UCPDRegister.cfg1) | (0x2000_0000))
}

public func LL_UCPD_TxDMADisable<IO: UCPDRegisterIO>(_ registers: IO) {
    registers.write(UCPDRegister.cfg1, value: registers.read(UCPDRegister.cfg1) & ~(0x2000_0000))
}

public func LL_UCPD_IsEnabledTxDMA<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.cfg1) & (0x2000_0000)) == (0x2000_0000)) ? 1 : 0)
}

public func LL_UCPD_IsEnabledRxDMA<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UCPDRegister.cfg1) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_UCPD_WriteTxOrderSet<IO: UCPDRegisterIO>(_ registers: IO, _ TxOrderSet: UInt32) {
    registers.write(UCPDRegister.tx_ordset, value: TxOrderSet)
}

public func LL_UCPD_WriteTxPaySize<IO: UCPDRegisterIO>(_ registers: IO, _ TxPaySize: UInt32) {
    registers.write(UCPDRegister.tx_paysz, value: TxPaySize)
}

public func LL_UCPD_WriteData<IO: UCPDRegisterIO>(_ registers: IO, _ Data: UInt8) {
    registers.write(UCPDRegister.txdr, value: UInt32(Data))
}

public func LL_UCPD_ReadRxOrderSet<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(UCPDRegister.rx_ordset) & (0x7))
}

public func LL_UCPD_ReadRxPaySize<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(UCPDRegister.rx_paysz) & (0x3ff))
}

public func LL_UCPD_ReadData<IO: UCPDRegisterIO>(_ registers: IO) -> UInt32 {
    return registers.read(UCPDRegister.rxdr)
}

public func LL_UCPD_SetRxOrdExt1<IO: UCPDRegisterIO>(_ registers: IO, _ SOPExt: UInt32) {
    registers.write(UCPDRegister.rx_ordext1, value: SOPExt)
}

public func LL_UCPD_SetRxOrdExt2<IO: UCPDRegisterIO>(_ registers: IO, _ SOPExt: UInt32) {
    registers.write(UCPDRegister.rx_ordext2, value: SOPExt)
}

public func LL_UCPD_DeInit<IO: UCPDRegisterIO & LLBusRegisterIO>(_ registers: inout IO, isKnownInstance: Bool = true)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.error.rawValue

    LL_UCPD_Disable(registers)
    if isKnownInstance {
        LL_APB1_GRP2_ForceReset(&registers, LL_APB1_GRP2_PERIPH_UCPD1)

        LL_APB1_GRP2_ReleaseReset(&registers, LL_APB1_GRP2_PERIPH_UCPD1)

        LL_APB1_GRP2_DisableClock(&registers, LL_APB1_GRP2_PERIPH_UCPD1)
        status = LLErrorStatus.success.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_UCPD_Init<IO: UCPDRegisterIO & LLBusRegisterIO>(
    _ registers: inout IO, _ UCPD_InitStruct: inout LL_UCPD_InitTypeDef, isKnownInstance: Bool = true
) -> LLErrorStatus {

    if isKnownInstance {
        LL_APB1_GRP2_EnableClock(&registers, LL_APB1_GRP2_PERIPH_UCPD1)
    }
    LL_UCPD_Disable(registers)

    registers.write(
        UCPDRegister.cfg1,
        value: (registers.read(UCPDRegister.cfg1) & ~(0xe0000 | 0xf800 | 0x7c0 | 0x3f))
            | (UCPD_InitStruct.psc_ucpdclk | (UCPD_InitStruct.transwin << 0xb) | (UCPD_InitStruct.IfrGap << 0x6)
                | UCPD_InitStruct.HbitClockDiv))
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_UCPD_StructInit(_ UCPD_InitStruct: inout LL_UCPD_InitTypeDef) {
    UCPD_InitStruct.psc_ucpdclk = LL_UCPD_PSC_DIV2
    UCPD_InitStruct.transwin = 0x7
    UCPD_InitStruct.IfrGap = 0x10
    UCPD_InitStruct.HbitClockDiv = 0x0D
}
