// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public enum UCPDRegister: UInt32, CaseIterable, Sendable {
    case cfg1 = 0x0
    case cfg2 = 0x4
    case cfg3 = 0x8
    case cr = 0xC
    case imr = 0x10
    case sr = 0x14
    case icr = 0x18
    case tx_ordset = 0x1C
    case tx_paysz = 0x20
    case txdr = 0x24
    case rx_ordset = 0x28
    case rx_paysz = 0x2C
    case rxdr = 0x30
    case rx_ordext1 = 0x34
    case rx_ordext2 = 0x38
}

public protocol UCPDRegisterIO {
    func read(_ register: UCPDRegister) -> UInt32
    func write(_ register: UCPDRegister, value: UInt32)
}
