// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension FDCAN {
    @discardableResult
    public func initialize(getTick: () -> UInt32) -> HALStatus {
        if getState() == FD.HAL_FDCAN_STATE_RESET {
            handle.write(.lock, value: 0)
            if useRegisteredCallbacks {
                callbacks.write(.txEventFifo, value: defaults.txEventFifo)
                callbacks.write(.rxFifo0, value: defaults.rxFifo0)
                callbacks.write(.rxFifo1, value: defaults.rxFifo1)
                callbacks.write(.txFifoEmpty, value: defaults.txFifoEmpty)
                callbacks.write(.txBufferComplete, value: defaults.txBufferComplete)
                callbacks.write(.txBufferAbort, value: defaults.txBufferAbort)
                callbacks.write(.highPriorityMessage, value: defaults.highPriorityMessage)
                callbacks.write(.timestampWraparound, value: defaults.timestampWraparound)
                callbacks.write(.timeoutOccurred, value: defaults.timeoutOccurred)
                callbacks.write(.error, value: defaults.error)
                callbacks.write(.errorStatus, value: defaults.errorStatus)
                if callbacks.read(.mspInit) == nil { callbacks.write(.mspInit, value: defaults.mspInit) }
            }
            invoke(.mspInit)
        }
        modify(.cccr, clear: FD.FDCAN_CCCR_CSR, set: 0)
        var start = getTick()
        while read(.cccr) & FD.FDCAN_CCCR_CSA == FD.FDCAN_CCCR_CSA {
            if getTick() &- start > FD.FDCAN_TIMEOUT_VALUE { return timeoutError() }
        }
        modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_INIT)
        start = getTick()
        while read(.cccr) & FD.FDCAN_CCCR_INIT == 0 {
            if getTick() &- start > FD.FDCAN_TIMEOUT_VALUE { return timeoutError() }
        }
        modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_CCE)
        if instance == .fdcan1 { registers.writeClockDivider(handle.read(.clockDivider)) }
        if handle.read(.autoRetransmission) == 1 { modify(.cccr, clear: FD.FDCAN_CCCR_DAR, set: 0) }
        else { modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_DAR) }
        if handle.read(.transmitPause) == 1 { modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_TXP) }
        else { modify(.cccr, clear: FD.FDCAN_CCCR_TXP, set: 0) }
        if handle.read(.protocolException) == 1 { modify(.cccr, clear: FD.FDCAN_CCCR_PXHD, set: 0) }
        else { modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_PXHD) }
        modify(.cccr, clear: FD.FDCAN_FRAME_FD_BRS, set: handle.read(.frameFormat))
        modify(.cccr, clear: FD.FDCAN_CCCR_TEST | FD.FDCAN_CCCR_MON | FD.FDCAN_CCCR_ASM, set: 0)
        modify(.test, clear: FD.FDCAN_TEST_LBCK, set: 0)
        if handle.read(.mode) == FD.FDCAN_MODE_RESTRICTED_OPERATION { modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_ASM) }
        else if handle.read(.mode) != FD.FDCAN_MODE_NORMAL {
            if handle.read(.mode) != FD.FDCAN_MODE_BUS_MONITORING {
                modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_TEST)
                modify(.test, clear: 0, set: FD.FDCAN_TEST_LBCK)
                if handle.read(.mode) == FD.FDCAN_MODE_INTERNAL_LOOPBACK { modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_MON) }
            } else { modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_MON) }
        }
        write(.nbtp, ((handle.read(.nominalSyncJumpWidth) &- 1) << FD.FDCAN_NBTP_NSJW_Pos) |
                    ((handle.read(.nominalTimeSeg1) &- 1) << FD.FDCAN_NBTP_NTSEG1_Pos) |
                    ((handle.read(.nominalTimeSeg2) &- 1) << FD.FDCAN_NBTP_NTSEG2_Pos) |
                    ((handle.read(.nominalPrescaler) &- 1) << FD.FDCAN_NBTP_NBRP_Pos))
        if handle.read(.frameFormat) == FD.FDCAN_FRAME_FD_BRS {
            write(.dbtp, ((handle.read(.dataSyncJumpWidth) &- 1) << FD.FDCAN_DBTP_DSJW_Pos) |
                        ((handle.read(.dataTimeSeg1) &- 1) << FD.FDCAN_DBTP_DTSEG1_Pos) |
                        ((handle.read(.dataTimeSeg2) &- 1) << FD.FDCAN_DBTP_DTSEG2_Pos) |
                        ((handle.read(.dataPrescaler) &- 1) << FD.FDCAN_DBTP_DBRP_Pos))
        }
        modify(.txbc, clear: 0, set: handle.read(.txFifoQueueMode))
        calculateRAMBlockAddresses()
        handle.write(.latestTxFifoQRequest, value: 0)
        handle.write(.errorCode, value: FD.HAL_FDCAN_ERROR_NONE)
        handle.write(.state, value: FD.HAL_FDCAN_STATE_READY)
        return .ok
    }
    func calculateRAMBlockAddresses() {
        var base = registers.messageRAMBase()
        if instance == .fdcan2 { base &+= FD.SRAMCAN_SIZE }
        handle.write(.standardFilterSA, value: base &+ FD.SRAMCAN_FLSSA)
        modify(.rxgfc, clear: FD.FDCAN_RXGFC_LSS, set: handle.read(.stdFiltersNbr) << FD.FDCAN_RXGFC_LSS_Pos)
        handle.write(.extendedFilterSA, value: base &+ FD.SRAMCAN_FLESA)
        modify(.rxgfc, clear: FD.FDCAN_RXGFC_LSE, set: handle.read(.extFiltersNbr) << FD.FDCAN_RXGFC_LSE_Pos)
        handle.write(.rxFIFO0SA, value: base &+ FD.SRAMCAN_RF0SA)
        handle.write(.rxFIFO1SA, value: base &+ FD.SRAMCAN_RF1SA)
        handle.write(.txEventFIFOSA, value: base &+ FD.SRAMCAN_TEFSA)
        handle.write(.txFIFOQSA, value: base &+ FD.SRAMCAN_TFQSA)
        var counter = base
        while counter < base &+ FD.SRAMCAN_SIZE { registers.writeMemory32(at: counter, value: 0); counter &+= 4 }
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        _ = stop()
        modify(.ile, clear: FD.FDCAN_INTERRUPT_LINE0 | FD.FDCAN_INTERRUPT_LINE1, set: 0)
        if useRegisteredCallbacks && callbacks.read(.mspDeinit) == nil { callbacks.write(.mspDeinit, value: defaults.mspDeinit) }
        invoke(.mspDeinit)
        handle.write(.errorCode, value: FD.HAL_FDCAN_ERROR_NONE)
        handle.write(.state, value: FD.HAL_FDCAN_STATE_RESET)
        return .ok
    }
    @discardableResult
    public func enterPowerDownMode(getTick: () -> UInt32) -> HALStatus {
        modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_CSR)
        let start = getTick()
        while read(.cccr) & FD.FDCAN_CCCR_CSA == 0 {
            if getTick() &- start > FD.FDCAN_TIMEOUT_VALUE { return timeoutError() }
        }
        return .ok
    }
    @discardableResult
    public func exitPowerDownMode(getTick: () -> UInt32) -> HALStatus {
        modify(.cccr, clear: FD.FDCAN_CCCR_CSR, set: 0)
        let start = getTick()
        while read(.cccr) & FD.FDCAN_CCCR_CSA == FD.FDCAN_CCCR_CSA {
            if getTick() &- start > FD.FDCAN_TIMEOUT_VALUE { return timeoutError() }
        }
        modify(.cccr, clear: FD.FDCAN_CCCR_INIT, set: 0)
        return .ok
    }
    @discardableResult
    public func start() -> HALStatus {
        if getState() == FD.HAL_FDCAN_STATE_READY {
            handle.write(.state, value: FD.HAL_FDCAN_STATE_BUSY)
            modify(.cccr, clear: FD.FDCAN_CCCR_INIT, set: 0)
            handle.write(.errorCode, value: FD.HAL_FDCAN_ERROR_NONE)
            return .ok
        }
        return fail(FD.HAL_FDCAN_ERROR_NOT_READY)
    }
    @discardableResult
    public func stop() -> HALStatus {
        if getState() == FD.HAL_FDCAN_STATE_BUSY {
            var counter: UInt32 = 0
            modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_INIT)
            while read(.cccr) & FD.FDCAN_CCCR_INIT == 0 {
                if counter > FD.FDCAN_TIMEOUT_VALUE { return timeoutError() }; counter &+= 1
            }
            counter = 0
            modify(.cccr, clear: FD.FDCAN_CCCR_CSR, set: 0)
            while read(.cccr) & FD.FDCAN_CCCR_CSA == FD.FDCAN_CCCR_CSA {
                if counter > FD.FDCAN_TIMEOUT_VALUE { return timeoutError() }; counter &+= 1
            }
            modify(.cccr, clear: 0, set: FD.FDCAN_CCCR_CCE)
            handle.write(.latestTxFifoQRequest, value: 0)
            handle.write(.state, value: FD.HAL_FDCAN_STATE_READY)
            return .ok
        }
        return fail(FD.HAL_FDCAN_ERROR_NOT_STARTED)
    }
}
