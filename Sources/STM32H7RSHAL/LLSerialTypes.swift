// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_USART_InitTypeDef: Equatable, Sendable {
    public var PrescalerValue: UInt32
    public var BaudRate: UInt32
    public var DataWidth: UInt32
    public var StopBits: UInt32
    public var Parity: UInt32
    public var TransferDirection: UInt32
    public var HardwareFlowControl: UInt32
    public var OverSampling: UInt32
    public init(
        PrescalerValue: UInt32 = 0, BaudRate: UInt32 = 0, DataWidth: UInt32 = 0, StopBits: UInt32 = 0,
        Parity: UInt32 = 0, TransferDirection: UInt32 = 0, HardwareFlowControl: UInt32 = 0, OverSampling: UInt32 = 0
    ) {
        self.PrescalerValue = PrescalerValue
        self.BaudRate = BaudRate
        self.DataWidth = DataWidth
        self.StopBits = StopBits
        self.Parity = Parity
        self.TransferDirection = TransferDirection
        self.HardwareFlowControl = HardwareFlowControl
        self.OverSampling = OverSampling
    }
}

public struct LL_USART_ClockInitTypeDef: Equatable, Sendable {
    public var ClockOutput: UInt32
    public var ClockPolarity: UInt32
    public var ClockPhase: UInt32
    public var LastBitClockPulse: UInt32
    public init(
        ClockOutput: UInt32 = 0, ClockPolarity: UInt32 = 0, ClockPhase: UInt32 = 0, LastBitClockPulse: UInt32 = 0
    ) {
        self.ClockOutput = ClockOutput
        self.ClockPolarity = ClockPolarity
        self.ClockPhase = ClockPhase
        self.LastBitClockPulse = LastBitClockPulse
    }
}

public struct LL_LPUART_InitTypeDef: Equatable, Sendable {
    public var PrescalerValue: UInt32
    public var BaudRate: UInt32
    public var DataWidth: UInt32
    public var StopBits: UInt32
    public var Parity: UInt32
    public var TransferDirection: UInt32
    public var HardwareFlowControl: UInt32
    public init(
        PrescalerValue: UInt32 = 0, BaudRate: UInt32 = 0, DataWidth: UInt32 = 0, StopBits: UInt32 = 0,
        Parity: UInt32 = 0, TransferDirection: UInt32 = 0, HardwareFlowControl: UInt32 = 0
    ) {
        self.PrescalerValue = PrescalerValue
        self.BaudRate = BaudRate
        self.DataWidth = DataWidth
        self.StopBits = StopBits
        self.Parity = Parity
        self.TransferDirection = TransferDirection
        self.HardwareFlowControl = HardwareFlowControl
    }
}
