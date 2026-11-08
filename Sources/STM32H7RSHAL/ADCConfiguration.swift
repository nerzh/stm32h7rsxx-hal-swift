// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct ADCOversampling: Equatable, Sendable {
    public var ratio: UInt32
    public var rightBitShift: UInt32
    public var triggeredMode: UInt32
    public var oversamplingStopReset: UInt32
    public init(ratio: UInt32 = 0, rightBitShift: UInt32 = 0, triggeredMode: UInt32 = 0, oversamplingStopReset: UInt32 = 0) {
        self.ratio = ratio
        self.rightBitShift = rightBitShift
        self.triggeredMode = triggeredMode
        self.oversamplingStopReset = oversamplingStopReset
    }
}
public struct ADCConfiguration: Equatable, Sendable {
    public var clockPrescaler: UInt32
    public var resolution: UInt32
    public var dataAlign: UInt32
    public var scanConvMode: UInt32
    public var eocSelection: UInt32
    public var lowPowerAutoWait: UInt32
    public var continuousConvMode: UInt32
    public var nbrOfConversion: UInt32
    public var discontinuousConvMode: UInt32
    public var nbrOfDiscConversion: UInt32
    public var externalTrigConv: UInt32
    public var externalTrigConvEdge: UInt32
    public var samplingMode: UInt32
    public var conversionDataManagement: UInt32
    public var overrun: UInt32
    public var oversamplingMode: UInt32
    public var oversampling: ADCOversampling
    public init(clockPrescaler: UInt32 = 0, resolution: UInt32 = 0, dataAlign: UInt32 = 0, scanConvMode: UInt32 = 0, eocSelection: UInt32 = 0, lowPowerAutoWait: UInt32 = 0, continuousConvMode: UInt32 = 0, nbrOfConversion: UInt32 = 0, discontinuousConvMode: UInt32 = 0, nbrOfDiscConversion: UInt32 = 0, externalTrigConv: UInt32 = 0, externalTrigConvEdge: UInt32 = 0, samplingMode: UInt32 = 0, conversionDataManagement: UInt32 = 0, overrun: UInt32 = 0, oversamplingMode: UInt32 = 0, oversampling: ADCOversampling = .init()) {
        self.clockPrescaler = clockPrescaler
        self.resolution = resolution
        self.dataAlign = dataAlign
        self.scanConvMode = scanConvMode
        self.eocSelection = eocSelection
        self.lowPowerAutoWait = lowPowerAutoWait
        self.continuousConvMode = continuousConvMode
        self.nbrOfConversion = nbrOfConversion
        self.discontinuousConvMode = discontinuousConvMode
        self.nbrOfDiscConversion = nbrOfDiscConversion
        self.externalTrigConv = externalTrigConv
        self.externalTrigConvEdge = externalTrigConvEdge
        self.samplingMode = samplingMode
        self.conversionDataManagement = conversionDataManagement
        self.overrun = overrun
        self.oversamplingMode = oversamplingMode
        self.oversampling = oversampling
    }
}
public struct ADCChannelConfiguration: Equatable, Sendable {
    public var channel: UInt32
    public var rank: UInt32
    public var samplingTime: UInt32
    public var singleDiff: UInt32
    public var offsetNumber: UInt32
    public var offset: UInt32
    public var offsetSign: UInt32
    public var offsetSaturation: UInt32
    public init(channel: UInt32 = 0, rank: UInt32 = 0, samplingTime: UInt32 = 0, singleDiff: UInt32 = 0, offsetNumber: UInt32 = 0, offset: UInt32 = 0, offsetSign: UInt32 = 0, offsetSaturation: UInt32 = 0) {
        self.channel = channel
        self.rank = rank
        self.samplingTime = samplingTime
        self.singleDiff = singleDiff
        self.offsetNumber = offsetNumber
        self.offset = offset
        self.offsetSign = offsetSign
        self.offsetSaturation = offsetSaturation
    }
}
public struct ADCAnalogWatchdogConfiguration: Equatable, Sendable {
    public var watchdogNumber: UInt32
    public var watchdogMode: UInt32
    public var channel: UInt32
    public var interruptMode: UInt32
    public var highThreshold: UInt32
    public var lowThreshold: UInt32
    public var filteringConfig: UInt32
    public init(watchdogNumber: UInt32 = 0, watchdogMode: UInt32 = 0, channel: UInt32 = 0, interruptMode: UInt32 = 0, highThreshold: UInt32 = 0, lowThreshold: UInt32 = 0, filteringConfig: UInt32 = 0) {
        self.watchdogNumber = watchdogNumber
        self.watchdogMode = watchdogMode
        self.channel = channel
        self.interruptMode = interruptMode
        self.highThreshold = highThreshold
        self.lowThreshold = lowThreshold
        self.filteringConfig = filteringConfig
    }
}
public struct ADCInjectedOversampling: Equatable, Sendable {
    public var ratio: UInt32
    public var rightBitShift: UInt32
    public init(ratio: UInt32 = 0, rightBitShift: UInt32 = 0) {
        self.ratio = ratio
        self.rightBitShift = rightBitShift
    }
}
public struct ADCInjectedConfiguration: Equatable, Sendable {
    public var injectedChannel: UInt32
    public var injectedRank: UInt32
    public var injectedSamplingTime: UInt32
    public var injectedSingleDiff: UInt32
    public var injectedOffsetNumber: UInt32
    public var injectedOffset: UInt32
    public var injectedOffsetSign: UInt32
    public var injectedOffsetSaturation: UInt32
    public var injectedNbrOfConversion: UInt32
    public var injectedDiscontinuousConvMode: UInt32
    public var autoInjectedConv: UInt32
    public var queueInjectedContext: UInt32
    public var externalTrigInjecConv: UInt32
    public var externalTrigInjecConvEdge: UInt32
    public var injecOversamplingMode: UInt32
    public var injecOversampling: ADCInjectedOversampling
    public init(injectedChannel: UInt32 = 0, injectedRank: UInt32 = 0, injectedSamplingTime: UInt32 = 0, injectedSingleDiff: UInt32 = 0, injectedOffsetNumber: UInt32 = 0, injectedOffset: UInt32 = 0, injectedOffsetSign: UInt32 = 0, injectedOffsetSaturation: UInt32 = 0, injectedNbrOfConversion: UInt32 = 0, injectedDiscontinuousConvMode: UInt32 = 0, autoInjectedConv: UInt32 = 0, queueInjectedContext: UInt32 = 0, externalTrigInjecConv: UInt32 = 0, externalTrigInjecConvEdge: UInt32 = 0, injecOversamplingMode: UInt32 = 0, injecOversampling: ADCInjectedOversampling = .init()) {
        self.injectedChannel = injectedChannel
        self.injectedRank = injectedRank
        self.injectedSamplingTime = injectedSamplingTime
        self.injectedSingleDiff = injectedSingleDiff
        self.injectedOffsetNumber = injectedOffsetNumber
        self.injectedOffset = injectedOffset
        self.injectedOffsetSign = injectedOffsetSign
        self.injectedOffsetSaturation = injectedOffsetSaturation
        self.injectedNbrOfConversion = injectedNbrOfConversion
        self.injectedDiscontinuousConvMode = injectedDiscontinuousConvMode
        self.autoInjectedConv = autoInjectedConv
        self.queueInjectedContext = queueInjectedContext
        self.externalTrigInjecConv = externalTrigInjecConv
        self.externalTrigInjecConvEdge = externalTrigInjecConvEdge
        self.injecOversamplingMode = injecOversamplingMode
        self.injecOversampling = injecOversampling
    }
}
public struct ADCMultimodeConfiguration: Equatable, Sendable {
    public var mode: UInt32
    public var dmaAccessMode: UInt32
    public var twoSamplingDelay: UInt32
    public init(mode: UInt32 = 0, dmaAccessMode: UInt32 = 0, twoSamplingDelay: UInt32 = 0) {
        self.mode = mode
        self.dmaAccessMode = dmaAccessMode
        self.twoSamplingDelay = twoSamplingDelay
    }
}
