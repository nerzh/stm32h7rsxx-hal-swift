// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_SPI_InitTypeDef: Equatable, Sendable {
    public var TransferDirection: UInt32
    public var Mode: UInt32
    public var DataWidth: UInt32
    public var ClockPolarity: UInt32
    public var ClockPhase: UInt32
    public var NSS: UInt32
    public var BaudRate: UInt32
    public var BitOrder: UInt32
    public var CRCCalculation: UInt32
    public var CRCPoly: UInt32
    public init(
        TransferDirection: UInt32 = 0, Mode: UInt32 = 0, DataWidth: UInt32 = 0, ClockPolarity: UInt32 = 0,
        ClockPhase: UInt32 = 0, NSS: UInt32 = 0, BaudRate: UInt32 = 0, BitOrder: UInt32 = 0, CRCCalculation: UInt32 = 0,
        CRCPoly: UInt32 = 0
    ) {
        self.TransferDirection = TransferDirection
        self.Mode = Mode
        self.DataWidth = DataWidth
        self.ClockPolarity = ClockPolarity
        self.ClockPhase = ClockPhase
        self.NSS = NSS
        self.BaudRate = BaudRate
        self.BitOrder = BitOrder
        self.CRCCalculation = CRCCalculation
        self.CRCPoly = CRCPoly
    }
}

public struct LL_I2S_InitTypeDef: Equatable, Sendable {
    public var Mode: UInt32
    public var Standard: UInt32
    public var DataFormat: UInt32
    public var MCLKOutput: UInt32
    public var AudioFreq: UInt32
    public var ClockPolarity: UInt32
    public init(
        Mode: UInt32 = 0, Standard: UInt32 = 0, DataFormat: UInt32 = 0, MCLKOutput: UInt32 = 0, AudioFreq: UInt32 = 0,
        ClockPolarity: UInt32 = 0
    ) {
        self.Mode = Mode
        self.Standard = Standard
        self.DataFormat = DataFormat
        self.MCLKOutput = MCLKOutput
        self.AudioFreq = AudioFreq
        self.ClockPolarity = ClockPolarity
    }
}
