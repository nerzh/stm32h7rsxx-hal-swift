// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DCMIPP operations from stm32h7rsxx_hal_dcmipp.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DCMIPP {
    @discardableResult
    public func initialize() -> HALStatus {
        if handle.read(.state) == 0 {
            if useRegisteredCallbacks {
                callbacks.write(DCMIPPPipeCallbackID.frame, value: defaults.pipeFrame)
                callbacks.write(DCMIPPPipeCallbackID.vsync, value: defaults.pipeVsync)
                callbacks.write(DCMIPPPipeCallbackID.line, value: defaults.pipeLine)
                callbacks.write(DCMIPPPipeCallbackID.limit, value: defaults.pipeLimit)
                callbacks.write(DCMIPPPipeCallbackID.error, value: defaults.pipeError)
                callbacks.write(DCMIPPCallbackID.error, value: defaults.error)
                if callbacks.read(.mspInitialize) == nil { callbacks.write(.mspInitialize, value: defaults.mspInitialize) }
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 3); handle.write(.pipeState, value: 0)
        handle.write(.errorCode, value: 0); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        modify(.prcr, clear: 0x4000); registers.write(.p0fscr, value: 0)
        if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
            callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        }
        invoke(.mspDeinitialize)
        handle.write(.errorCode, value: 0); handle.write(.state, value: 0); handle.write(.pipeState, value: 0)
        return .ok
    }
    @discardableResult
    public func configureParallel(_ c: DCMIPPParallelConfiguration) -> HALStatus {
        precondition(DCMIPPFormat(rawValue: c.format) != nil)
        precondition(DCMIPPVerticalSyncPolarity(rawValue: c.vsPolarity) != nil)
        precondition(DCMIPPHorizontalSyncPolarity(rawValue: c.hsPolarity) != nil)
        precondition(DCMIPPPixelClockPolarity(rawValue: c.pixelClockPolarity) != nil)
        precondition(DCMIPPDataWidth(rawValue: c.dataWidth) != nil)
        precondition(DCMIPPSynchronization(rawValue: c.synchronization) != nil)
        precondition(DCMIPPSwapBits(rawValue: c.swapBits) != nil && DCMIPPSwapCycles(rawValue: c.swapCycles) != nil)
        if handle.read(.state) != 1 { return .error }
        registers.write(.prcr, value: c.format | c.vsPolarity | c.hsPolarity | c.pixelClockPolarity |
                        c.dataWidth | c.synchronization | c.swapCycles | c.swapBits)
        if c.synchronization == 0x10 {
            registers.write(.prescr, value: c.synchronizationCodes)
            registers.write(.presur, value: .max)
        }
        enableInterrupts(0x40); modify(.prcr, set: 0x4000)
        handle.write(.state, value: 2)
        return .ok
    }
    @discardableResult
    public func configurePipe(frameRate: DCMIPPFrameRate, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        let state = handle.read(.pipeState)
        if handle.read(.state) != 2 { return .error }
        if state != 1 && state != 0 && state != 4 { return .error }
        handle.write(.pipeState, value: 2)
        modify(.p0fctcr, clear: 3, set: frameRate.rawValue)
        handle.write(.pipeState, value: 1)
        return .ok
    }
    @discardableResult
    public func configureIPPlug(_ c: DCMIPPIPPlugConfiguration, getTick: () -> UInt32) -> HALStatus {
        precondition(c.client == 1 && c.end <= 0x1F && c.start <= 0x1F && c.arbitrationRatio <= 15)
        precondition(DCMIPPOutstandingTransactions(rawValue: c.maxOutstandingTransactions) != nil)
        precondition(DCMIPPMemoryPageSize(rawValue: c.memoryPageSize) != nil)
        precondition(DCMIPPTrafficBurstSize(rawValue: c.traffic) != nil)
        if handle.read(.state) == 0 { return .error }
        modify(.ipgr2, set: 1)
        let start = getTick()
        repeat {
            if getTick() &- start > 1000 { return .error }
        } while registers.read(.ipgr3) & 1 != 1
        registers.write(.ipgr1, value: c.memoryPageSize)
        registers.write(.ipc1r1, value: c.traffic | (c.maxOutstandingTransactions << 8))
        registers.write(.ipc1r2, value: c.arbitrationRatio << 16)
        registers.write(.ipc1r3, value: c.start | (c.end << 16))
        modify(.ipgr2, clear: 1); enableInterrupts(0x20)
        return .ok
    }
    @discardableResult
    public func start(address: UInt32, mode: DCMIPPCaptureMode, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if address & 0xF != 0 { return .error }
        if handle.read(.pipeState) != 1 { return .error }
        handle.write(.pipeState, value: 2)
        // C ORs CaptureMode and leaves an existing double-buffer bit unchanged.
        modify(.p0fctcr, set: mode.rawValue)
        registers.write(.p0ppm0ar1, value: address)
        enableInterrupts(0x8620)
        beginCapture()
        return .ok
    }
    @discardableResult
    public func startDoubleBuffer(address0: UInt32, address1: UInt32, mode: DCMIPPCaptureMode, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if address0 & 0xF != 0 || address1 & 0xF != 0 { return .error }
        if handle.read(.pipeState) != 1 { return .error }
        handle.write(.pipeState, value: 2); modify(.p0fctcr, set: mode.rawValue)
        registers.write(.p0ppm0ar1, value: address0); registers.write(.p0ppm0ar2, value: address1)
        modify(.p0ppcr, set: 0x10000)
        // Unlike the single-buffer path, C does not enable the AXI error IRQ here.
        enableInterrupts(0x8600); beginCapture()
        return .ok
    }
    @discardableResult
    public func stop(pipe: UInt32 = 0, getTick: () -> UInt32) -> HALStatus {
        precondition(pipe == 0)
        if handle.read(.pipeState) == 0 { return .error }
        modify(.p0fctcr, clear: 8)
        let start = getTick()
        repeat {
            if getTick() &- start > 1000 { return .error }
        } while registers.read(.cmsr1) & 0x8000 != 0
        if registers.read(.p0ppcr) & 0x10000 == 0x10000 { modify(.p0ppcr, clear: 0x10000) }
        modify(.p0fscr, clear: 0x80000000); disableInterrupts(0xC700)
        handle.write(.pipeState, value: 1)
        return .ok
    }
    @discardableResult
    public func suspend(pipe: UInt32 = 0, getTick: () -> UInt32) -> HALStatus {
        precondition(pipe == 0)
        if handle.read(.pipeState) != 2 { return .error }
        modify(.p0fctcr, clear: 8); handle.write(.pipeState, value: 3)
        let start = getTick()
        repeat {
            if getTick() &- start > 1000 { handle.write(.pipeState, value: 4); return .error }
        } while registers.read(.cmsr1) & 0x8000 != 0
        return .ok
    }
    @discardableResult
    public func resume(pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if handle.read(.pipeState) != 3 { return .error }
        modify(.p0fctcr, set: 8); handle.write(.pipeState, value: 2)
        return .ok
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getPipeState(pipe: UInt32 = 0) -> UInt32 { precondition(pipe == 0); return handle.read(.pipeState) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func enableInterrupts(_ mask: UInt32) { modify(.cmier, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { modify(.cmier, clear: mask) }
    public func getFlag(_ mask: UInt32) -> UInt32 { registers.read(.cmsr2) & mask }
    public func clearFlag(_ mask: UInt32) { registers.write(.cmfcr, value: mask) }
    public func getInterruptSource(_ mask: UInt32) -> Bool { registers.read(.cmier) & mask == mask }
    func modify(_ register: DCMIPPRegister, clear: UInt32 = 0, set: UInt32 = 0) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    private func beginCapture() { modify(.p0fscr, set: 0x80000000); modify(.p0fctcr, set: 8) }
}
