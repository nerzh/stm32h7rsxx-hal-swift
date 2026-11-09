// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public enum DLYBRegister: UInt32, CaseIterable, Sendable {
    case cr = 0x0
    case cfgr = 0x4
}

public protocol DLYBRegisterIO {
    func read(_ register: DLYBRegister) -> UInt32
    func write(_ register: DLYBRegister, value: UInt32)
}

public enum DLYBInstance: Sendable { case sdmmc1, sdmmc2 }
