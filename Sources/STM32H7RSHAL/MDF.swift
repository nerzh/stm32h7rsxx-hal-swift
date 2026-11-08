// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MDF {
    public func setConfiguration(_ configuration: MDFConfiguration) {
        handle.write(.processClockDivider, value: configuration.processClockDivider)
        handle.write(.outputClockActivation, value: configuration.outputClock.activation)
        handle.write(.outputClockPins, value: configuration.outputClock.pins)
        handle.write(.outputClockDivider, value: configuration.outputClock.divider)
        handle.write(.clockTriggerActivation, value: configuration.outputClock.trigger.activation)
        handle.write(.clockTriggerSource, value: configuration.outputClock.trigger.source)
        handle.write(.clockTriggerEdge, value: configuration.outputClock.trigger.edge)
        handle.write(.serialInterfaceActivation, value: configuration.serialInterface.activation)
        handle.write(.serialMode, value: configuration.serialInterface.mode)
        handle.write(.serialClockSource, value: configuration.serialInterface.clockSource)
        handle.write(.serialThreshold, value: configuration.serialInterface.threshold)
        handle.write(.filterBitstream, value: configuration.filterBitstream)
    }
    @discardableResult
    public func initialize() -> HALStatus {
        precondition(handle.read(.filterBitstream) <= 1 && handle.read(.serialInterfaceActivation) <= 1)
        guard shared.readRegisteredHandle() == 0 else { return .error }
        if useRegisteredCallbacks {
            callbacks.writeSoundLevel(defaults.soundLevel); callbacks.write(.soundActivity, value: defaults.soundActivity)
            callbacks.write(.acquisitionComplete, value: defaults.acquisitionComplete)
            callbacks.write(.acquisitionHalfComplete, value: defaults.acquisitionHalfComplete)
            callbacks.write(.error, value: defaults.error); prepareMSPCallback(.mspInitialize)
        }
        invoke(.mspInitialize)
        guard registers.read(.ckgcr) & 0x80000000 == 0 else { return .error }
        precondition((1...128).contains(handle.read(.processClockDivider)) && handle.read(.outputClockActivation) <= 1)
        registers.write(.ckgcr, value: 0)
        modify(.ckgcr, set: (handle.read(.processClockDivider) &- 1) << 24)
        if handle.read(.outputClockActivation) == 1 {
            precondition(handle.read(.outputClockPins) == 0x20 || handle.read(.outputClockPins) == 0x40 || handle.read(.outputClockPins) == 0x60)
            precondition((1...16).contains(handle.read(.outputClockDivider)) && handle.read(.clockTriggerActivation) <= 1)
            modify(.ckgcr, set: ((handle.read(.outputClockDivider) &- 1) << 16) | handle.read(.outputClockPins) | (handle.read(.outputClockPins) >> 4))
            if handle.read(.clockTriggerActivation) == 1 {
                validateTrigger(source: handle.read(.clockTriggerSource), edge: handle.read(.clockTriggerEdge))
                modify(.ckgcr, set: handle.read(.clockTriggerSource) | handle.read(.clockTriggerEdge) | 0x10)
            }
        }
        modify(.ckgcr, set: 1)
        if handle.read(.serialInterfaceActivation) == 1 {
            guard registers.read(.sitfcr) & 0x80000000 == 0 else { return .error }
            precondition(MDFSerialMode(rawValue: handle.read(.serialMode)) != nil)
            precondition(handle.read(.serialClockSource) == 0 || handle.read(.serialClockSource) == 2)
            precondition((4...31).contains(handle.read(.serialThreshold)))
            registers.write(.sitfcr, value: 0)
            modify(.sitfcr, set: (handle.read(.serialThreshold) << 8) | handle.read(.serialMode) | handle.read(.serialClockSource))
            modify(.sitfcr, set: 1)
        }
        modify(.bsmxcr, clear: 0x1F); modify(.bsmxcr, set: handle.read(.filterBitstream))
        precondition(handle.identity != 0); shared.writeRegisteredHandle(handle.identity)
        handle.write(.errorCode, value: 0); handle.write(.state, value: 1); return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        guard shared.readRegisteredHandle() != 0 else { return .error }
        if registers.read(.sadcr) & 0x80000000 != 0 { modify(.sadcr, clear: 1) }
        if registers.read(.dfltcr) & 0x80000000 != 0 { modify(.dfltcr, clear: 1) }
        if registers.read(.sitfcr) & 0x80000000 != 0 { modify(.sitfcr, clear: 1) }
        registers.write(.dfltier, value: 0); registers.write(.dfltisr, value: .max); modify(.ckgcr, clear: 1)
        prepareMSPCallback(.mspDeinitialize); invoke(.mspDeinitialize)
        shared.writeRegisteredHandle(0); handle.write(.state, value: 0); return .ok
    }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func modify(_ register: MDFRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func validateTrigger(source: UInt32, edge: UInt32) {
        precondition(source == 0 || source == 0x2000); precondition(edge == 0 || edge == 0x100)
    }
}
