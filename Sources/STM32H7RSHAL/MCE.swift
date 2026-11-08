// Copyright (c) 2024 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MCE operations and definitions from stm32h7rsxx_hal_mce.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MCE {
    @discardableResult
    public func initialize() -> HALStatus {
        if handle.read(.state) == 0 {
            unlock()
            if useRegisteredCallbacks { callbacks.write(.error, value: defaults.error); prepareMSPCallback(.mspInitialize) }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 1); return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        handle.write(.state, value: 2); modify(.iaier, clear: 3)
        for i: UInt32 in 0...3 { modify(.region(i, .regcr), clear: 1); modify(.region(i, .attr), clear: 0x10000) }
        if registers.instance == .mce1 { for i: UInt32 in 0..<2 { modify(.context(i, .cccfgr), clear: 1) } }
        modify(.privcfgr, clear: 1); registers.write(.iacr, value: 3)
        prepareMSPCallback(.mspDeinitialize); invoke(.mspDeinitialize)
        handle.write(.state, value: 0); handle.write(.errorCode, value: 0); unlock(); return .ok
    }
    @discardableResult
    public func configureRegion(_ config: MCERegionConfiguration?, index: UInt32) -> HALStatus {
        precondition(index < 4)
        if let config {
            precondition(MCECipher(rawValue: config.cipher) != nil && (registers.instance == .mce1 || config.cipher != 0x4000))
            precondition(MCERegionAccess(rawValue: config.access) != nil)
            precondition(MCERegionPrivilege(rawValue: config.privilege) != nil)
        }
        guard registers.read(.cr) & 1 != 1, let config else { return .error }
        guard lock() else { return .busy }
        if registers.read(.region(index, .regcr)) & 1 == 1 { modify(.region(index, .regcr), clear: 1) }
        // ContextID is not applied by this C operation; SetRegionAESContext is separate.
        modify(.region(index, .regcr), clear: 0x1C000, set: config.privilege | config.cipher)
        registers.write(.region(index, .saddr), value: config.startAddress)
        registers.write(.region(index, .eaddr), value: config.endAddress)
        modify(.region(index, .attr), clear: 0x10000, set: config.access)
        modify(.region(index, .regcr), set: 1); unlock(); return .ok
    }
    @discardableResult
    public func setRegionAESContext(_ context: UInt32, region: UInt32) -> HALStatus {
        validateContext(context); precondition(region < 4)
        guard registers.read(.cr) & 1 != 1 else { return .error }
        guard lock() else { return .busy }
        if registers.read(.region(region, .regcr)) & 1 == 1 { modify(.region(region, .regcr), clear: 1) }
        modify(.region(region, .regcr), clear: 0x600, set: context)
        modify(.region(region, .regcr), set: 1); unlock(); return .ok
    }
    @discardableResult
    public func enableRegion(_ index: UInt32) -> HALStatus {
        precondition(index < 4)
        guard registers.read(.cr) & 1 != 1 else { return .error }
        guard lock() else { return .busy }
        var result = HALStatus.error
        if registers.read(.region(index, .regcr)) & 1 != 1 { modify(.region(index, .regcr), set: 1); result = .ok }
        unlock(); return result
    }
    @discardableResult
    public func disableRegion(_ index: UInt32) -> HALStatus {
        precondition(index < 4)
        guard registers.read(.cr) & 1 != 1 else { return .error }
        guard lock() else { return .busy }
        var result = HALStatus.error
        if registers.read(.region(index, .regcr)) & 1 == 1 { modify(.region(index, .regcr), clear: 1); result = .ok }
        unlock(); return result
    }
    @discardableResult
    public func lockGlobalConfiguration() -> HALStatus {
        guard lock() else { return .busy }
        modify(.cr, set: 1); unlock(); return .ok
    }
    @discardableResult
    public func lockNoekeonMasterKeys() -> HALStatus {
        guard registers.read(.cr) & 1 != 1 else { return .error }
        guard lock() else { return .busy }
        modify(.cr, set: 2); unlock(); return .ok
    }
    public func handleInterrupt() {
        let flags = registers.read(.iasr)
        if flags & 1 == 1 { addError(1); registers.write(.iacr, value: 1) }
        if flags & 2 == 2 {
            let access = registers.read(.iaesr) & 0x90
            registers.write(.iacr, value: 2)
            if access == 0x10 { addError(2) }
            else if access == 0x90 { addError(8) }
            else if access == 0x80 { addError(16) }
            else { addError(4) }
        }
        invoke(.error)
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func enableInterrupts(_ mask: MCEInterrupts) { modify(.iaier, set: mask.rawValue) }
    public func disableInterrupts(_ mask: MCEInterrupts) { modify(.iaier, clear: mask.rawValue) }
    public func getFlag(_ flag: UInt32) -> Bool {
        if flag == 1 { return registers.read(.iasr) & 1 == 1 }
        return registers.read(.iasr) & 2 == 2 && registers.read(.iaesr) & (flag & ~UInt32(2)) == flag & ~UInt32(2)
    }
    public func clearFlag(_ flag: UInt32) { registers.write(.iacr, value: flag == 1 ? 1 : 2) }
    public func getFlag(_ flag: MCEFlag) -> Bool { getFlag(flag.rawValue) }
    public func clearFlag(_ flag: MCEFlag) { clearFlag(flag.rawValue) }
    func validateContext(_ context: UInt32) {
        precondition(registers.instance == .mce1 ? MCEContext(rawValue: context) != nil : context == 0)
    }
    func modify(_ register: MCERegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func lock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func unlock() { handle.write(.lock, value: 0) }
}
