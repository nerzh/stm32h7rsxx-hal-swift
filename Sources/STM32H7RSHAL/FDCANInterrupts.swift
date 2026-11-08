// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension FDCAN {
    @discardableResult
    public func configureInterruptLines(groups: UInt32, line: UInt32) -> HALStatus {
        let state = getState()
        if state == FD.HAL_FDCAN_STATE_READY || state == FD.HAL_FDCAN_STATE_BUSY {
            if line == FD.FDCAN_INTERRUPT_LINE0 { modify(.ils, clear: groups, set: 0) }
            else { modify(.ils, clear: 0, set: groups) }
            return .ok
        }
        return fail(FD.HAL_FDCAN_ERROR_NOT_INITIALIZED)
    }
    private func lineHasInterrupts(_ interrupts: UInt32, selection: UInt32, line1: Bool) -> Bool {
        ((interrupts & FD.FDCAN_IT_LIST_RX_FIFO0) != 0 && ((selection & FD.FDCAN_IT_GROUP_RX_FIFO0) != 0) == line1) ||
        ((interrupts & FD.FDCAN_IT_LIST_RX_FIFO1) != 0 && ((selection & FD.FDCAN_IT_GROUP_RX_FIFO1) != 0) == line1) ||
        ((interrupts & FD.FDCAN_IT_LIST_SMSG) != 0 && ((selection & FD.FDCAN_IT_GROUP_SMSG) != 0) == line1) ||
        ((interrupts & FD.FDCAN_IT_LIST_TX_FIFO_ERROR) != 0 && ((selection & FD.FDCAN_IT_GROUP_TX_FIFO_ERROR) != 0) == line1) ||
        ((interrupts & FD.FDCAN_IT_LIST_MISC) != 0 && ((selection & FD.FDCAN_IT_GROUP_MISC) != 0) == line1) ||
        ((interrupts & FD.FDCAN_IT_LIST_BIT_LINE_ERROR) != 0 && ((selection & FD.FDCAN_IT_GROUP_BIT_LINE_ERROR) != 0) == line1) ||
        ((interrupts & FD.FDCAN_IT_LIST_PROTOCOL_ERROR) != 0 && ((selection & FD.FDCAN_IT_GROUP_PROTOCOL_ERROR) != 0) == line1)
    }
    @discardableResult
    public func activateNotification(interrupts: UInt32, bufferIndexes: UInt32) -> HALStatus {
        let state = getState()
        if state == FD.HAL_FDCAN_STATE_READY || state == FD.HAL_FDCAN_STATE_BUSY {
            let selection = read(.ils)
            if lineHasInterrupts(interrupts, selection: selection, line1: false) { modify(.ile, clear: 0, set: FD.FDCAN_INTERRUPT_LINE0) }
            if lineHasInterrupts(interrupts, selection: selection, line1: true) { modify(.ile, clear: 0, set: FD.FDCAN_INTERRUPT_LINE1) }
            if interrupts & FD.FDCAN_IT_TX_COMPLETE != 0 { modify(.txbtie, clear: 0, set: bufferIndexes) }
            if interrupts & FD.FDCAN_IT_TX_ABORT_COMPLETE != 0 { modify(.txbcie, clear: 0, set: bufferIndexes) }
            enableInterrupts(interrupts)
            return .ok
        }
        return fail(FD.HAL_FDCAN_ERROR_NOT_INITIALIZED)
    }
    @discardableResult
    public func deactivateNotification(interrupts: UInt32) -> HALStatus {
        let state = getState()
        if state == FD.HAL_FDCAN_STATE_READY || state == FD.HAL_FDCAN_STATE_BUSY {
            disableInterrupts(interrupts)
            if interrupts & FD.FDCAN_IT_TX_COMPLETE != 0 { write(.txbtie, 0) }
            if interrupts & FD.FDCAN_IT_TX_ABORT_COMPLETE != 0 { write(.txbcie, 0) }
            let enabled = read(.ie)
            let selection = read(.ils)
            if !lineHasInterrupts(enabled, selection: selection, line1: false) { modify(.ile, clear: FD.FDCAN_INTERRUPT_LINE0, set: 0) }
            if !lineHasInterrupts(enabled, selection: selection, line1: true) { modify(.ile, clear: FD.FDCAN_INTERRUPT_LINE1, set: 0) }
            return .ok
        }
        return fail(FD.HAL_FDCAN_ERROR_NOT_INITIALIZED)
    }
    public func irqHandler() {
        var txEvents = read(.ir) & FD.FDCAN_TX_EVENT_FIFO_MASK
        txEvents &= read(.ie)
        var rx0 = read(.ir) & FD.FDCAN_RX_FIFO0_MASK
        rx0 &= read(.ie)
        var rx1 = read(.ir) & FD.FDCAN_RX_FIFO1_MASK
        rx1 &= read(.ie)
        var errors = read(.ir) & FD.FDCAN_ERROR_MASK
        errors &= read(.ie)
        var errorStatus = read(.ir) & FD.FDCAN_ERROR_STATUS_MASK
        errorStatus &= read(.ie)
        let source = read(.ie)
        let flags = read(.ir)
        if flags & FD.FDCAN_FLAG_RX_HIGH_PRIORITY_MSG != 0 && source & FD.FDCAN_IT_RX_HIGH_PRIORITY_MSG != 0 {
            clearFlag(FD.FDCAN_FLAG_RX_HIGH_PRIORITY_MSG); invoke(.highPriorityMessage)
        }
        if flags & FD.FDCAN_FLAG_TX_ABORT_COMPLETE != 0 && source & FD.FDCAN_IT_TX_ABORT_COMPLETE != 0 {
            var buffers = read(.txbcf); buffers &= read(.txbcie)
            clearFlag(FD.FDCAN_FLAG_TX_ABORT_COMPLETE); invoke(.txBufferAbort, buffers)
        }
        if txEvents != 0 { clearFlag(txEvents); invoke(.txEventFifo, txEvents) }
        if rx0 != 0 { clearFlag(rx0); invoke(.rxFifo0, rx0) }
        if rx1 != 0 { clearFlag(rx1); invoke(.rxFifo1, rx1) }
        if flags & FD.FDCAN_FLAG_TX_FIFO_EMPTY != 0 && source & FD.FDCAN_IT_TX_FIFO_EMPTY != 0 {
            clearFlag(FD.FDCAN_FLAG_TX_FIFO_EMPTY); invoke(.txFifoEmpty)
        }
        if flags & FD.FDCAN_FLAG_TX_COMPLETE != 0 && source & FD.FDCAN_IT_TX_COMPLETE != 0 {
            var buffers = read(.txbto); buffers &= read(.txbtie)
            clearFlag(FD.FDCAN_FLAG_TX_COMPLETE); invoke(.txBufferComplete, buffers)
        }
        if flags & FD.FDCAN_FLAG_TIMESTAMP_WRAPAROUND != 0 && source & FD.FDCAN_IT_TIMESTAMP_WRAPAROUND != 0 {
            clearFlag(FD.FDCAN_FLAG_TIMESTAMP_WRAPAROUND); invoke(.timestampWraparound)
        }
        if flags & FD.FDCAN_FLAG_TIMEOUT_OCCURRED != 0 && source & FD.FDCAN_IT_TIMEOUT_OCCURRED != 0 {
            clearFlag(FD.FDCAN_FLAG_TIMEOUT_OCCURRED); invoke(.timeoutOccurred)
        }
        if flags & FD.FDCAN_FLAG_RAM_ACCESS_FAILURE != 0 && source & FD.FDCAN_IT_RAM_ACCESS_FAILURE != 0 {
            clearFlag(FD.FDCAN_FLAG_RAM_ACCESS_FAILURE); addError(FD.HAL_FDCAN_ERROR_RAM_ACCESS)
        }
        if errorStatus != 0 { clearFlag(errorStatus); invoke(.errorStatus, errorStatus) }
        if errors != 0 { clearFlag(errors); addError(errors) }
        if getError() != FD.HAL_FDCAN_ERROR_NONE { invoke(.error) }
    }
}
