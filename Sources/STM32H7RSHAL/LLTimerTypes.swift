// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_TIM_InitTypeDef: Equatable, Sendable {
    public var Prescaler: UInt16
    public var CounterMode: UInt32
    public var Autoreload: UInt32
    public var ClockDivision: UInt32
    public var RepetitionCounter: UInt32
    public init(
        Prescaler: UInt16 = 0, CounterMode: UInt32 = 0, Autoreload: UInt32 = 0, ClockDivision: UInt32 = 0,
        RepetitionCounter: UInt32 = 0
    ) {
        self.Prescaler = Prescaler
        self.CounterMode = CounterMode
        self.Autoreload = Autoreload
        self.ClockDivision = ClockDivision
        self.RepetitionCounter = RepetitionCounter
    }
}

public struct LL_TIM_OC_InitTypeDef: Equatable, Sendable {
    public var OCMode: UInt32
    public var OCState: UInt32
    public var OCNState: UInt32
    public var CompareValue: UInt32
    public var OCPolarity: UInt32
    public var OCNPolarity: UInt32
    public var OCIdleState: UInt32
    public var OCNIdleState: UInt32
    public init(
        OCMode: UInt32 = 0, OCState: UInt32 = 0, OCNState: UInt32 = 0, CompareValue: UInt32 = 0, OCPolarity: UInt32 = 0,
        OCNPolarity: UInt32 = 0, OCIdleState: UInt32 = 0, OCNIdleState: UInt32 = 0
    ) {
        self.OCMode = OCMode
        self.OCState = OCState
        self.OCNState = OCNState
        self.CompareValue = CompareValue
        self.OCPolarity = OCPolarity
        self.OCNPolarity = OCNPolarity
        self.OCIdleState = OCIdleState
        self.OCNIdleState = OCNIdleState
    }
}

public struct LL_TIM_IC_InitTypeDef: Equatable, Sendable {
    public var ICPolarity: UInt32
    public var ICActiveInput: UInt32
    public var ICPrescaler: UInt32
    public var ICFilter: UInt32
    public init(ICPolarity: UInt32 = 0, ICActiveInput: UInt32 = 0, ICPrescaler: UInt32 = 0, ICFilter: UInt32 = 0) {
        self.ICPolarity = ICPolarity
        self.ICActiveInput = ICActiveInput
        self.ICPrescaler = ICPrescaler
        self.ICFilter = ICFilter
    }
}

public struct LL_TIM_ENCODER_InitTypeDef: Equatable, Sendable {
    public var EncoderMode: UInt32
    public var IC1Polarity: UInt32
    public var IC1ActiveInput: UInt32
    public var IC1Prescaler: UInt32
    public var IC1Filter: UInt32
    public var IC2Polarity: UInt32
    public var IC2ActiveInput: UInt32
    public var IC2Prescaler: UInt32
    public var IC2Filter: UInt32
    public init(
        EncoderMode: UInt32 = 0, IC1Polarity: UInt32 = 0, IC1ActiveInput: UInt32 = 0, IC1Prescaler: UInt32 = 0,
        IC1Filter: UInt32 = 0, IC2Polarity: UInt32 = 0, IC2ActiveInput: UInt32 = 0, IC2Prescaler: UInt32 = 0,
        IC2Filter: UInt32 = 0
    ) {
        self.EncoderMode = EncoderMode
        self.IC1Polarity = IC1Polarity
        self.IC1ActiveInput = IC1ActiveInput
        self.IC1Prescaler = IC1Prescaler
        self.IC1Filter = IC1Filter
        self.IC2Polarity = IC2Polarity
        self.IC2ActiveInput = IC2ActiveInput
        self.IC2Prescaler = IC2Prescaler
        self.IC2Filter = IC2Filter
    }
}

public struct LL_TIM_HALLSENSOR_InitTypeDef: Equatable, Sendable {
    public var IC1Polarity: UInt32
    public var IC1Prescaler: UInt32
    public var IC1Filter: UInt32
    public var CommutationDelay: UInt32
    public init(IC1Polarity: UInt32 = 0, IC1Prescaler: UInt32 = 0, IC1Filter: UInt32 = 0, CommutationDelay: UInt32 = 0)
    {
        self.IC1Polarity = IC1Polarity
        self.IC1Prescaler = IC1Prescaler
        self.IC1Filter = IC1Filter
        self.CommutationDelay = CommutationDelay
    }
}

public struct LL_TIM_BDTR_InitTypeDef: Equatable, Sendable {
    public var OSSRState: UInt32
    public var OSSIState: UInt32
    public var LockLevel: UInt32
    public var DeadTime: UInt8
    public var BreakState: UInt16
    public var BreakPolarity: UInt32
    public var BreakFilter: UInt32
    public var BreakAFMode: UInt32
    public var Break2State: UInt32
    public var Break2Polarity: UInt32
    public var Break2Filter: UInt32
    public var Break2AFMode: UInt32
    public var AutomaticOutput: UInt32
    public init(
        OSSRState: UInt32 = 0, OSSIState: UInt32 = 0, LockLevel: UInt32 = 0, DeadTime: UInt8 = 0,
        BreakState: UInt16 = 0, BreakPolarity: UInt32 = 0, BreakFilter: UInt32 = 0, BreakAFMode: UInt32 = 0,
        Break2State: UInt32 = 0, Break2Polarity: UInt32 = 0, Break2Filter: UInt32 = 0, Break2AFMode: UInt32 = 0,
        AutomaticOutput: UInt32 = 0
    ) {
        self.OSSRState = OSSRState
        self.OSSIState = OSSIState
        self.LockLevel = LockLevel
        self.DeadTime = DeadTime
        self.BreakState = BreakState
        self.BreakPolarity = BreakPolarity
        self.BreakFilter = BreakFilter
        self.BreakAFMode = BreakAFMode
        self.Break2State = Break2State
        self.Break2Polarity = Break2Polarity
        self.Break2Filter = Break2Filter
        self.Break2AFMode = Break2AFMode
        self.AutomaticOutput = AutomaticOutput
    }
}

public struct LL_LPTIM_InitTypeDef: Equatable, Sendable {
    public var ClockSource: UInt32
    public var Prescaler: UInt32
    public var Waveform: UInt32
    public init(ClockSource: UInt32 = 0, Prescaler: UInt32 = 0, Waveform: UInt32 = 0) {
        self.ClockSource = ClockSource
        self.Prescaler = Prescaler
        self.Waveform = Waveform
    }
}
