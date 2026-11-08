// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPDIFRX operations and definitions from stm32h7rsxx_hal_spdifrx.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPDIFRX {
    public func setConfiguration(_ config: SPDIFRXConfiguration) {
        handle.write(.inputSelection, value: config.inputSelection)
        handle.write(.retries, value: config.retries)
        handle.write(.waitForActivity, value: config.waitForActivity)
        handle.write(.channelSelection, value: config.channelSelection)
        handle.write(.dataFormat, value: config.dataFormat)
        handle.write(.stereoMode, value: config.stereoMode)
        handle.write(.preambleTypeMask, value: config.preambleTypeMask)
        handle.write(.channelStatusMask, value: config.channelStatusMask)
        handle.write(.validityBitMask, value: config.validityBitMask)
        handle.write(.parityErrorMask, value: config.parityErrorMask)
        handle.write(.symbolClockGeneration, value: config.symbolClockGeneration)
        handle.write(.backupSymbolClockGeneration, value: config.backupSymbolClockGeneration)
    }
    @discardableResult
    public func initialize() -> HALStatus {
        precondition(SPDIFRXInput(rawValue: handle.read(.inputSelection)) != nil)
        precondition(SPDIFRXRetries(rawValue: handle.read(.retries)) != nil)
        precondition(SPDIFRXChannel(rawValue: handle.read(.channelSelection)) != nil)
        precondition(handle.read(.waitForActivity) == 0 || handle.read(.waitForActivity) == 0x4000)
        precondition(handle.read(.symbolClockGeneration) <= 1 && handle.read(.backupSymbolClockGeneration) <= 1)
        validateFormat(.init(dataFormat: handle.read(.dataFormat), stereoMode: handle.read(.stereoMode),
                            preambleTypeMask: handle.read(.preambleTypeMask), channelStatusMask: handle.read(.channelStatusMask),
                            validityBitMask: handle.read(.validityBitMask), parityErrorMask: handle.read(.parityErrorMask)))
        if handle.read(.state) == 0 {
            unlock()
            if useRegisteredCallbacks {
                for raw: UInt32 in 0..<5 { let id = SPDIFRXCallbackID(rawValue: raw)!; callbacks.write(id, value: defaults.callback(id)) }
                prepareMSPCallback(.mspInitialize)
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 2); idle()
        var value = registers.read(.cr)
        value &= ~UInt32(0x377BF8)
        value |= handle.read(.stereoMode) | handle.read(.inputSelection) | handle.read(.retries) | handle.read(.waitForActivity)
        value |= handle.read(.channelSelection) | handle.read(.dataFormat) | handle.read(.preambleTypeMask)
        value |= handle.read(.channelStatusMask) | handle.read(.validityBitMask) | handle.read(.parityErrorMask)
        if handle.read(.symbolClockGeneration) == 1 { value |= 0x100000 }
        if handle.read(.backupSymbolClockGeneration) == 1 { value |= 0x200000 }
        registers.write(.cr, value: value); handle.write(.errorCode, value: 0); handle.write(.state, value: 1); return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        handle.write(.state, value: 2); idle(); prepareMSPCallback(.mspDeinitialize); invoke(.mspDeinitialize)
        handle.write(.errorCode, value: 0); handle.write(.state, value: 0); unlock(); return .ok
    }
    @discardableResult
    public func setDataFormat(_ format: SPDIFRXFormatConfiguration) -> HALStatus {
        validateFormat(format)
        var value = registers.read(.cr)
        if value & 3 == 3 && (value & 0x30 != format.dataFormat || value & 8 != format.stereoMode) { return .error }
        value &= ~UInt32(0x3F8)
        value |= format.stereoMode | format.dataFormat | format.preambleTypeMask | format.channelStatusMask | format.validityBitMask | format.parityErrorMask
        registers.write(.cr, value: value); return .ok
    }
    func validateFormat(_ format: SPDIFRXFormatConfiguration) {
        precondition(SPDIFRXDataFormat(rawValue: format.dataFormat) != nil)
        precondition(format.stereoMode == 0 || format.stereoMode == 8)
        precondition(format.preambleTypeMask == 0 || format.preambleTypeMask == 0x200)
        precondition(format.channelStatusMask == 0 || format.channelStatusMask == 0x100)
        precondition(format.validityBitMask == 0 || format.validityBitMask == 0x80)
        precondition(format.parityErrorMask == 0 || format.parityErrorMask == 0x40)
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func idle() { modify(.cr, clear: 3) }
    public func synchronize() { modify(.cr, set: 1) }
    public func enableReception() { modify(.cr, set: 3) }
    public func enableInterrupts(_ mask: UInt32) { modify(.imr, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { registers.write(.imr, value: registers.read(.imr) & UInt32(UInt16(truncatingIfNeeded: ~mask))) }
    public func getInterruptSource(_ mask: UInt32) -> UInt32 { registers.read(.imr) & mask == mask ? 1 : 0 }
    public func getFlag(_ mask: UInt32) -> UInt32 { registers.read(.sr) & mask == mask ? 1 : 0 }
    public func clearInterrupts(_ mask: UInt32) { registers.write(.ifcr, value: mask) }
    func disableAllInterrupts() { for bit: UInt32 in 0..<7 { disableInterrupts(1 << bit) } }
    func modify(_ register: SPDIFRXRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func lock() -> Bool { if handle.read(.lock) == 1 { return false }; handle.write(.lock, value: 1); return true }
    func unlock() { handle.write(.lock, value: 0) }
}
