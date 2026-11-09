// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_I3C_CtrlBusConfTypeDef: Equatable, Sendable {
    public var SDAHoldTime: UInt32
    public var WaitTime: UInt32
    public var SCLPPLowDuration: UInt8
    public var SCLI3CHighDuration: UInt8
    public var SCLODLowDuration: UInt8
    public var SCLI2CHighDuration: UInt8
    public var BusFreeDuration: UInt8
    public var BusIdleDuration: UInt8
    public init(
        SDAHoldTime: UInt32 = 0, WaitTime: UInt32 = 0, SCLPPLowDuration: UInt8 = 0, SCLI3CHighDuration: UInt8 = 0,
        SCLODLowDuration: UInt8 = 0, SCLI2CHighDuration: UInt8 = 0, BusFreeDuration: UInt8 = 0,
        BusIdleDuration: UInt8 = 0
    ) {
        self.SDAHoldTime = SDAHoldTime
        self.WaitTime = WaitTime
        self.SCLPPLowDuration = SCLPPLowDuration
        self.SCLI3CHighDuration = SCLI3CHighDuration
        self.SCLODLowDuration = SCLODLowDuration
        self.SCLI2CHighDuration = SCLI2CHighDuration
        self.BusFreeDuration = BusFreeDuration
        self.BusIdleDuration = BusIdleDuration
    }
}

public struct LL_I3C_TgtBusConfTypeDef: Equatable, Sendable {
    public var BusAvailableDuration: UInt8
    public init(BusAvailableDuration: UInt8 = 0) {
        self.BusAvailableDuration = BusAvailableDuration
    }
}

public struct LL_I3C_InitTypeDef: Equatable, Sendable {
    public var CtrlBusCharacteristic: LL_I3C_CtrlBusConfTypeDef
    public var TgtBusCharacteristic: LL_I3C_TgtBusConfTypeDef
    public init(
        CtrlBusCharacteristic: LL_I3C_CtrlBusConfTypeDef = .init(),
        TgtBusCharacteristic: LL_I3C_TgtBusConfTypeDef = .init()
    ) {
        self.CtrlBusCharacteristic = CtrlBusCharacteristic
        self.TgtBusCharacteristic = TgtBusCharacteristic
    }
}
