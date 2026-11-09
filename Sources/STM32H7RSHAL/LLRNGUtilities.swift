// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public func LL_RNG_WriteReg<IO: RNGRegisterIO>(_ registers: IO, _ register: RNGRegister, _ value: UInt32) {
    registers.write(register, value: value)
}
public func LL_RNG_ReadReg<IO: RNGRegisterIO>(_ registers: IO, _ register: RNGRegister) -> UInt32 {
    registers.read(register)
}
