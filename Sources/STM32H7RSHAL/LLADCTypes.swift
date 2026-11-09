// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from stm32h7rsxx_ll_adc.h/.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// CMSIS encodings: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_ADC_CommonInitTypeDef: Equatable, Sendable {
    public var CommonClock: UInt32
    public var Multimode: UInt32
    public var MultiDMATransfer: UInt32
    public var MultiTwoSamplingDelay: UInt32
    public init(
        CommonClock: UInt32 = 0, Multimode: UInt32 = 0, MultiDMATransfer: UInt32 = 0, MultiTwoSamplingDelay: UInt32 = 0
    ) {
        self.CommonClock = CommonClock
        self.Multimode = Multimode
        self.MultiDMATransfer = MultiDMATransfer
        self.MultiTwoSamplingDelay = MultiTwoSamplingDelay
    }
}

public struct LL_ADC_InitTypeDef: Equatable, Sendable {
    public var Resolution: UInt32
    public var DataAlignment: UInt32
    public var LowPowerMode: UInt32
    public init(Resolution: UInt32 = 0, DataAlignment: UInt32 = 0, LowPowerMode: UInt32 = 0) {
        self.Resolution = Resolution
        self.DataAlignment = DataAlignment
        self.LowPowerMode = LowPowerMode
    }
}

public struct LL_ADC_REG_InitTypeDef: Equatable, Sendable {
    public var TriggerSource: UInt32
    public var SequencerLength: UInt32
    public var SequencerDiscont: UInt32
    public var ContinuousMode: UInt32
    public var DMATransfer: UInt32
    public var Overrun: UInt32
    public init(
        TriggerSource: UInt32 = 0, SequencerLength: UInt32 = 0, SequencerDiscont: UInt32 = 0,
        ContinuousMode: UInt32 = 0, DMATransfer: UInt32 = 0, Overrun: UInt32 = 0
    ) {
        self.TriggerSource = TriggerSource
        self.SequencerLength = SequencerLength
        self.SequencerDiscont = SequencerDiscont
        self.ContinuousMode = ContinuousMode
        self.DMATransfer = DMATransfer
        self.Overrun = Overrun
    }
}

public struct LL_ADC_INJ_InitTypeDef: Equatable, Sendable {
    public var TriggerSource: UInt32
    public var SequencerLength: UInt32
    public var SequencerDiscont: UInt32
    public var TrigAuto: UInt32
    public init(
        TriggerSource: UInt32 = 0, SequencerLength: UInt32 = 0, SequencerDiscont: UInt32 = 0, TrigAuto: UInt32 = 0
    ) {
        self.TriggerSource = TriggerSource
        self.SequencerLength = SequencerLength
        self.SequencerDiscont = SequencerDiscont
        self.TrigAuto = TrigAuto
    }
}
