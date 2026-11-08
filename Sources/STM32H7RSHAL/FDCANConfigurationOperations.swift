// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension FDCAN {
    @discardableResult
    public func configureGlobalFilter(nonMatchingStandard: UInt32, nonMatchingExtended: UInt32, rejectRemoteStandard: UInt32, rejectRemoteExtended: UInt32) -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.rxgfc, clear: FD.FDCAN_RXGFC_ANFS | FD.FDCAN_RXGFC_ANFE | FD.FDCAN_RXGFC_RRFS | FD.FDCAN_RXGFC_RRFE, set: (nonMatchingStandard << FD.FDCAN_RXGFC_ANFS_Pos) | (nonMatchingExtended << FD.FDCAN_RXGFC_ANFE_Pos) | (rejectRemoteStandard << FD.FDCAN_RXGFC_RRFS_Pos) | (rejectRemoteExtended << FD.FDCAN_RXGFC_RRFE_Pos))
        return .ok
    }
    @discardableResult
    public func configureExtendedIDMask(_ mask: UInt32) -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        write(.xidam, mask)
        return .ok
    }
    @discardableResult
    public func configureRxFIFOOverwrite(fifo: UInt32, operationMode: UInt32) -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        if fifo == FD.FDCAN_RX_FIFO0 { modify(.rxgfc, clear: FD.FDCAN_RXGFC_F0OM, set: operationMode << FD.FDCAN_RXGFC_F0OM_Pos) }
        else { modify(.rxgfc, clear: FD.FDCAN_RXGFC_F1OM, set: operationMode << FD.FDCAN_RXGFC_F1OM_Pos) }
        return .ok
    }
    @discardableResult
    public func configureRAMWatchdog(counterStartValue: UInt32) -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.rwd, clear: FD.FDCAN_RWD_WDC, set: counterStartValue)
        return .ok
    }
    @discardableResult
    public func configureTimestampCounter(prescaler: UInt32) -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.tscc, clear: FD.FDCAN_TSCC_TCP, set: prescaler)
        return .ok
    }
    @discardableResult
    public func enableTimestampCounter(operation: UInt32) -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.tscc, clear: FD.FDCAN_TSCC_TSS, set: operation)
        return .ok
    }
    @discardableResult
    public func disableTimestampCounter() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.tscc, clear: FD.FDCAN_TSCC_TSS, set: 0)
        return .ok
    }
    @discardableResult
    public func configureTimeoutCounter(operation: UInt32, period: UInt32) -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.tocc, clear: FD.FDCAN_TOCC_TOS | FD.FDCAN_TOCC_TOP, set: operation | (period << FD.FDCAN_TOCC_TOP_Pos))
        return .ok
    }
    @discardableResult
    public func enableTimeoutCounter() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.tocc, clear: 0, set: FD.FDCAN_TOCC_ETOC)
        return .ok
    }
    @discardableResult
    public func disableTimeoutCounter() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.tocc, clear: FD.FDCAN_TOCC_ETOC, set: 0)
        return .ok
    }
    @discardableResult
    public func configureTxDelayCompensation(offset: UInt32, filter: UInt32) -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        write(.tdcr, (filter << FD.FDCAN_TDCR_TDCF_Pos) | (offset << FD.FDCAN_TDCR_TDCO_Pos))
        return .ok
    }
    @discardableResult
    public func enableTxDelayCompensation() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.dbtp, clear: 0, set: FD.FDCAN_DBTP_TDC)
        return .ok
    }
    @discardableResult
    public func disableTxDelayCompensation() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.dbtp, clear: FD.FDCAN_DBTP_TDC, set: 0)
        return .ok
    }
    @discardableResult
    public func enableISOMode() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.cccr, clear: FD.FDCAN_CCCR_NISO, set: 0)
        return .ok
    }
    @discardableResult
    public func disableISOMode() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_NISO)
        return .ok
    }
    @discardableResult
    public func enableEdgeFiltering() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_EFBI)
        return .ok
    }
    @discardableResult
    public func disableEdgeFiltering() -> HALStatus {
        if getState() != FD.HAL_FDCAN_STATE_READY { return fail(FD.HAL_FDCAN_ERROR_NOT_READY) }
        modify(.cccr, clear: FD.FDCAN_CCCR_EFBI, set: 0)
        return .ok
    }
    public func getTimestampCounter() -> UInt16 { UInt16(truncatingIfNeeded: read(.tscv)) }
    public func getTimeoutCounter() -> UInt16 { UInt16(truncatingIfNeeded: read(.tocv)) }
    @discardableResult
    public func resetTimestampCounter() -> HALStatus {
        if read(.tscc) & FD.FDCAN_TSCC_TSS != FD.FDCAN_TIMESTAMP_EXTERNAL { write(.tscv, 0); return .ok }
        return fail(FD.HAL_FDCAN_ERROR_NOT_SUPPORTED)
    }
    @discardableResult
    public func resetTimeoutCounter() -> HALStatus {
        if read(.tocc) & FD.FDCAN_TOCC_TOS == FD.FDCAN_TIMEOUT_CONTINUOUS { write(.tocv, 0); return .ok }
        return fail(FD.HAL_FDCAN_ERROR_NOT_SUPPORTED)
    }
    @discardableResult
    public func abortTxRequest(bufferIndex: UInt32) -> HALStatus {
        if getState() == FD.HAL_FDCAN_STATE_BUSY { write(.txbcr, bufferIndex); return .ok }
        return fail(FD.HAL_FDCAN_ERROR_NOT_STARTED)
    }
    public func isTxBufferMessagePending(bufferIndex: UInt32) -> UInt32 { read(.txbrp) & bufferIndex == 0 ? 0 : 1 }
    public func getRxFifoFillLevel(fifo: UInt32) -> UInt32 {
        fifo == FD.FDCAN_RX_FIFO0 ? read(.rxf0s) & FD.FDCAN_RXF0S_F0FL : read(.rxf1s) & FD.FDCAN_RXF1S_F1FL
    }
    public func getTxFifoFreeLevel() -> UInt32 { read(.txfqs) & FD.FDCAN_TXFQS_TFFL }
    public func isRestrictedOperationMode() -> UInt32 { (read(.cccr) & FD.FDCAN_CCCR_ASM) >> FD.FDCAN_CCCR_ASM_Pos }
    @discardableResult
    public func exitRestrictedOperationMode() -> HALStatus {
        let state = getState()
        if state == FD.HAL_FDCAN_STATE_READY || state == FD.HAL_FDCAN_STATE_BUSY {
            modify(.cccr, clear: FD.FDCAN_CCCR_ASM, set: 0); return .ok
        }
        return fail(FD.HAL_FDCAN_ERROR_NOT_INITIALIZED)
    }
    @discardableResult
    public func configureFilter(_ c: FDCANFilter) -> HALStatus {
        let state = getState()
        if state == FD.HAL_FDCAN_STATE_READY || state == FD.HAL_FDCAN_STATE_BUSY {
            if c.idType == FD.FDCAN_STANDARD_ID {
                let word = (c.filterType << 30) | (c.filterConfig << 27) | (c.filterID1 << 16) | c.filterID2
                let address = handle.read(.standardFilterSA) &+ (c.filterIndex &* FD.SRAMCAN_FLS_SIZE)
                registers.writeMemory32(at: address, value: word)
            } else {
                let first = (c.filterConfig << 29) | c.filterID1
                let second = (c.filterType << 30) | c.filterID2
                let address = handle.read(.extendedFilterSA) &+ (c.filterIndex &* FD.SRAMCAN_FLE_SIZE)
                registers.writeMemory32(at: address, value: first)
                registers.writeMemory32(at: address &+ 4, value: second)
            }
            return .ok
        }
        return fail(FD.HAL_FDCAN_ERROR_NOT_INITIALIZED)
    }
    @discardableResult
    public func getHighPriorityMessageStatus(_ result: inout FDCANHighPriorityMessageStatus) -> HALStatus {
        result.filterList = ((read(.hpms) & FD.FDCAN_HPMS_FLST) >> FD.FDCAN_HPMS_FLST_Pos)
        result.filterIndex = ((read(.hpms) & FD.FDCAN_HPMS_FIDX) >> FD.FDCAN_HPMS_FIDX_Pos)
        result.messageStorage = (read(.hpms) & FD.FDCAN_HPMS_MSI)
        result.messageIndex = (read(.hpms) & FD.FDCAN_HPMS_BIDX)
        return .ok
    }
    @discardableResult
    public func getProtocolStatus(_ result: inout FDCANProtocolStatus) -> HALStatus {
        let snapshot = read(.psr)
        result.lastErrorCode = (snapshot & FD.FDCAN_PSR_LEC)
        result.dataLastErrorCode = ((snapshot & FD.FDCAN_PSR_DLEC) >> FD.FDCAN_PSR_DLEC_Pos)
        result.activity = (snapshot & FD.FDCAN_PSR_ACT)
        result.errorPassive = ((snapshot & FD.FDCAN_PSR_EP) >> FD.FDCAN_PSR_EP_Pos)
        result.warning = ((snapshot & FD.FDCAN_PSR_EW) >> FD.FDCAN_PSR_EW_Pos)
        result.busOff = ((snapshot & FD.FDCAN_PSR_BO) >> FD.FDCAN_PSR_BO_Pos)
        result.rxESIFlag = ((snapshot & FD.FDCAN_PSR_RESI) >> FD.FDCAN_PSR_RESI_Pos)
        result.rxBRSFlag = ((snapshot & FD.FDCAN_PSR_RBRS) >> FD.FDCAN_PSR_RBRS_Pos)
        result.rxFDFFlag = ((snapshot & FD.FDCAN_PSR_REDL) >> FD.FDCAN_PSR_REDL_Pos)
        result.protocolException = ((snapshot & FD.FDCAN_PSR_PXE) >> FD.FDCAN_PSR_PXE_Pos)
        result.tdcValue = ((snapshot & FD.FDCAN_PSR_TDCV) >> FD.FDCAN_PSR_TDCV_Pos)
        return .ok
    }
    @discardableResult
    public func getErrorCounters(_ result: inout FDCANErrorCounters) -> HALStatus {
        let snapshot = read(.ecr)
        result.txErrorCnt = ((snapshot & FD.FDCAN_ECR_TEC) >> FD.FDCAN_ECR_TEC_Pos)
        result.rxErrorCnt = ((snapshot & FD.FDCAN_ECR_REC) >> FD.FDCAN_ECR_REC_Pos)
        result.rxErrorPassive = ((snapshot & FD.FDCAN_ECR_RP) >> FD.FDCAN_ECR_RP_Pos)
        result.errorLogging = ((snapshot & FD.FDCAN_ECR_CEL) >> FD.FDCAN_ECR_CEL_Pos)
        return .ok
    }
}
