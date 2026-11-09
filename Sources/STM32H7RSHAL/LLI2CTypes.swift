// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_I2C_InitTypeDef: Equatable, Sendable {
    public var PeripheralMode: UInt32
    public var Timing: UInt32
    public var AnalogFilter: UInt32
    public var DigitalFilter: UInt32
    public var OwnAddress1: UInt32
    public var TypeAcknowledge: UInt32
    public var OwnAddrSize: UInt32
    public init(
        PeripheralMode: UInt32 = 0, Timing: UInt32 = 0, AnalogFilter: UInt32 = 0, DigitalFilter: UInt32 = 0,
        OwnAddress1: UInt32 = 0, TypeAcknowledge: UInt32 = 0, OwnAddrSize: UInt32 = 0
    ) {
        self.PeripheralMode = PeripheralMode
        self.Timing = Timing
        self.AnalogFilter = AnalogFilter
        self.DigitalFilter = DigitalFilter
        self.OwnAddress1 = OwnAddress1
        self.TypeAcknowledge = TypeAcknowledge
        self.OwnAddrSize = OwnAddrSize
    }
}
