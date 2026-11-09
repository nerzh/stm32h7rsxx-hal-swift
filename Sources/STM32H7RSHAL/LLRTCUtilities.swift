// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public func LL_RTC_WriteReg<IO: RTCRegisterIO>(_ registers: IO, _ register: RTCRegister, _ value: UInt32) {
    registers.write(register, value: value)
}
public func LL_RTC_ReadReg<IO: RTCRegisterIO>(_ registers: IO, _ register: RTCRegister) -> UInt32 {
    registers.read(register)
}

public func __LL_RTC_CONVERT_BIN2BCD(_ value: UInt32) -> UInt8 {
    UInt8(truncatingIfNeeded: ((value / 10) << 4) | (value % 10))
}
public func __LL_RTC_CONVERT_BCD2BIN(_ value: UInt32) -> UInt8 {
    RTCEncoding.bcdToByte(UInt8(truncatingIfNeeded: value))
}
@available(*, unavailable, message: "The pinned ST macro refers to undefined RTC_BACKUP_NB.")
public var LL_RTC_BKP_NUMBER: UInt32 { preconditionFailure("Missing upstream definition") }
public func __LL_RTC_GET_WEEKDAY(_ value: UInt32) -> UInt32 { (value >> 24) & 0xFF }
public func __LL_RTC_GET_YEAR(_ value: UInt32) -> UInt32 { (value >> 0) & 0xFF }
public func __LL_RTC_GET_MONTH(_ value: UInt32) -> UInt32 { (value >> 8) & 0xFF }
public func __LL_RTC_GET_DAY(_ value: UInt32) -> UInt32 { (value >> 16) & 0xFF }
public func __LL_RTC_GET_HOUR(_ value: UInt32) -> UInt32 { (value >> 16) & 0xFF }
public func __LL_RTC_GET_MINUTE(_ value: UInt32) -> UInt32 { (value >> 8) & 0xFF }
public func __LL_RTC_GET_SECOND(_ value: UInt32) -> UInt32 { (value >> 0) & 0xFF }
