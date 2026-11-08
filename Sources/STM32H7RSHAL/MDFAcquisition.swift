// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MDF {
    @discardableResult
    public func startAcquisition(_ config: MDFFilterConfiguration?) -> HALStatus {
        guard let config, canStart(config) else { return .error }
        registers.write(.dfltcr, value: 0); configureAndEnable(config); return .ok
    }
    @discardableResult
    public func startAcquisitionInterrupt(_ config: MDFFilterConfiguration?) -> HALStatus {
        guard let config, canStart(config) else { return .error }
        if config.soundActivity.activation == 0 || config.soundActivity.dataMemoryTransfer != 0 { modify(.dfltier, set: 3) }
        enableFilterInterrupts(config)
        registers.write(.dfltcr, value: 0); configureAndEnable(config); return .ok
    }
    func canStart(_ config: MDFFilterConfiguration) -> Bool {
        precondition(MDFAcquisitionMode(rawValue: config.acquisitionMode) != nil && config.soundActivity.activation <= 1)
        if config.soundActivity.activation == 1 && (config.acquisitionMode == 0x10 || config.acquisitionMode == 0x30 || config.acquisitionMode == 0x40) { return false }
        if handle.read(.state) != 1 { return false }
        if registers.read(.dfltcr) & 0x80000000 != 0 { return false }
        if registers.read(.sadcr) & 0x80000000 != 0 { return false }
        return true
    }
    func enableFilterInterrupts(_ config: MDFFilterConfiguration) {
        if config.reshapeFilter.activation == 1 { modify(.dfltier, set: 0x800) }
        modify(.dfltier, set: 0x200)
        if config.soundActivity.activation == 1 {
            precondition(config.soundActivity.soundLevelInterrupt <= 1)
            modify(.dfltier, set: config.soundActivity.soundLevelInterrupt == 1 ? 0x3000 : 0x1000)
        }
    }
    @discardableResult
    public func stopAcquisition() -> HALStatus {
        guard canStopAcquisition() else { return .error }
        modify(.dfltcr, clear: 1); modify(.dfltisr, set: 0x3A02); handle.write(.state, value: 1); return .ok
    }
    @discardableResult
    public func stopAcquisitionInterrupt() -> HALStatus {
        guard canStopAcquisition() else { return .error }
        modify(.dfltcr, clear: 1); modify(.dfltier, clear: 0x3A03); modify(.dfltisr, set: 0x3A02)
        handle.write(.state, value: 1); return .ok
    }
    func canStopAcquisition() -> Bool {
        if handle.read(.state) != 2 {
            if handle.read(.state) == 1 {
                if registers.read(.dfltcr) & 0x80000000 != 0x80000000 { return false }
            } else { return false }
        } else if registers.read(.sadcr) & 0x80000000 != 0 { modify(.sadcr, clear: 1) }
        return true
    }
    func configureAndEnable(_ config: MDFFilterConfiguration) {
        precondition(config.discardSamples <= 255 && (config.fifoThreshold == 0 || config.fifoThreshold == 4))
        if config.acquisitionMode == 0 || config.acquisitionMode == 0x10 {
            modify(.dfltcr, set: config.acquisitionMode | config.fifoThreshold | (config.discardSamples << 20))
        } else {
            validateTrigger(source: config.trigger.source, edge: config.trigger.edge)
            modify(.dfltcr, set: config.acquisitionMode | config.fifoThreshold | config.trigger.source | config.trigger.edge | (config.discardSamples << 20))
        }
        precondition(MDFDataSource(rawValue: config.dataSource) != nil && MDFCICMode(rawValue: config.cicMode) != nil)
        precondition((2...512).contains(config.decimationRatio) && (-16...24).contains(config.gain))
        let gain = config.gain < 0 ? UInt32(bitPattern: config.gain - 16) & 0x3F : UInt32(config.gain)
        registers.write(.dfltcicr, value: config.dataSource | config.cicMode | ((config.decimationRatio &- 1) << 8) | (gain << 20))
        precondition(config.delay <= 127); registers.write(.dlycr, value: config.delay)
        precondition(config.reshapeFilter.activation <= 1); registers.write(.dfltrsfr, value: 0)
        if config.reshapeFilter.activation == 1 {
            precondition(config.reshapeFilter.decimationRatio == 0 || config.reshapeFilter.decimationRatio == 0x10)
            modify(.dfltrsfr, set: config.reshapeFilter.decimationRatio)
        } else { modify(.dfltrsfr, set: 1) }
        precondition(config.highPassFilter.activation <= 1)
        if config.highPassFilter.activation == 1 {
            precondition(config.highPassFilter.cutoffFrequency <= 0x300 && config.highPassFilter.cutoffFrequency & 0xFF == 0)
            modify(.dfltrsfr, set: config.highPassFilter.cutoffFrequency)
        } else { modify(.dfltrsfr, set: 0x80) }
        precondition(config.soundActivity.activation <= 1)
        if config.soundActivity.activation == 1 {
            let sound = config.soundActivity
            precondition(MDFSoundActivityMode(rawValue: sound.mode) != nil)
            precondition(sound.frameSize <= 0x700 && sound.frameSize & 0xFF == 0 && sound.frameSize != 0x600)
            if sound.mode != 0x3000 { precondition(sound.hysteresis <= 1) }
            precondition(sound.soundTriggerEvent == 0 || sound.soundTriggerEvent == 8)
            precondition(sound.dataMemoryTransfer == 0 || sound.dataMemoryTransfer == 2 || sound.dataMemoryTransfer == 6)
            if sound.mode != 0x3000 && sound.hysteresis == 1 {
                registers.write(.sadcr, value: sound.mode | sound.frameSize | 0x80 | sound.soundTriggerEvent | sound.dataMemoryTransfer)
            } else {
                registers.write(.sadcr, value: sound.mode | sound.frameSize | sound.soundTriggerEvent | sound.dataMemoryTransfer)
            }
            precondition(sound.minimumNoiseLevel <= 8191)
            precondition(sound.hangoverWindow <= 0x7000 && sound.hangoverWindow & 0xFFF == 0)
            precondition((sound.learningFrames <= 0x300 && sound.learningFrames & 0xFF == 0) || sound.learningFrames == 0x700)
            precondition(sound.signalNoiseThreshold <= 9)
            if sound.mode != 0x1000 {
                precondition(sound.ambientNoiseSlope <= 7)
                registers.write(.sadcfgr, value: (sound.minimumNoiseLevel << 16) | sound.hangoverWindow | sound.learningFrames | (sound.ambientNoiseSlope << 4) | sound.signalNoiseThreshold)
            } else {
                registers.write(.sadcfgr, value: (sound.minimumNoiseLevel << 16) | sound.hangoverWindow | sound.learningFrames | sound.signalNoiseThreshold)
            }
        } else { registers.write(.sadcr, value: 0); registers.write(.sadcfgr, value: 0) }
        handle.write(.state, value: 2)
        if config.soundActivity.activation == 1 { modify(.sadcr, set: 1) }
        modify(.dfltcr, set: 1)
    }
}
