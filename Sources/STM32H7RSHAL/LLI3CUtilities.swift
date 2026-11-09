// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public func LL_I3C_WriteReg<IO: I3CRegisterIO>(_ registers: IO, _ register: I3CRegister, _ value: UInt32) {
    registers.write(register, value: value)
}
public func LL_I3C_ReadReg<IO: I3CRegisterIO>(_ registers: IO, _ register: I3CRegister) -> UInt32 {
    registers.read(register)
}

func _llI3CTargetRegister(_ target: UInt32) -> I3CRegister {
    precondition(target >= 1 && target <= 4, "I3C target table index is out of bounds")
    return I3CRegister(rawValue: 0x64 &+ 4 &* (target &- 1))!
}
@available(*, unavailable, message: "The pinned ST macro refers to undefined I3C_SR_OK.")
public var LL_I3C_MESSAGE_SUCCESS: UInt32 { preconditionFailure("Missing upstream definition") }

public func LL_I3C_GET_BCR(_ payload: UInt64) -> UInt32 {
    UInt32(truncatingIfNeeded: payload >> LL_I3C_BCR_IN_PAYLOAD_SHIFT) & 0xFF
}
public func LL_I3C_GET_IBI_CAPABLE(_ bcr: UInt32) -> UInt32 {
    ((bcr & 0x2) >> 1) == 1 ? LL_I3C_IBI_CAPABILITY : LL_I3C_IBI_NO_CAPABILITY
}
public func LL_I3C_GET_IBI_PAYLOAD(_ bcr: UInt32) -> UInt32 {
    ((bcr & 0x4) >> 2) == 1 ? LL_I3C_IBI_DATA_ENABLE : LL_I3C_IBI_DATA_DISABLE
}
public func LL_I3C_GET_CR_CAPABLE(_ bcr: UInt32) -> UInt32 {
    ((bcr & 0x40) >> 6) == 1 ? LL_I3C_CR_CAPABILITY : LL_I3C_CR_NO_CAPABILITY
}
