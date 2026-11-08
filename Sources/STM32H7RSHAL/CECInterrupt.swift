// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CEC operations and definitions from stm32h7rsxx_hal_cec.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CEC {
    public func handleInterrupt() {
        let flags = registers.read(.isr)
        if flags & 0x80 != 0 { handle.write(.errorCode, value: 0x80); clearFlag(.arbitrationLost) }
        if flags & 1 != 0 {
            handle.write(.receiveState, value: 0x22)
            handle.write(.receiveSize, value: handle.read(.receiveSize) &+ 1)
            let byte = UInt8(truncatingIfNeeded: registers.read(.rxdr))
            handle.readPointer(.receive)!.storeBytes(of: byte, as: UInt8.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
            clearFlag(.receiveByte)
        }
        if flags & 2 != 0 {
            clearFlag(.receiveEnd)
            handle.write(.receiveState, value: 0x20); handle.write(.errorCode, value: 0)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: -Int(handle.read(.receiveSize))))
            invokeReceive(UInt32(handle.read(.receiveSize)))
            handle.write(.receiveSize, value: 0)
        }
        if flags & 0x100 != 0 {
            handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
            if handle.read(.transmitCount) == 0 { setLastTransmitByte() }
            registers.write(.txdr, value: UInt32(handle.readPointer(.transmit)!.load(as: UInt8.self)))
            handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 1))
            clearFlag(.transmitByte)
        }
        if flags & 0x200 != 0 {
            clearFlag(.transmitEnd); handle.write(.globalState, value: 0x20); unlock()
            handle.write(.errorCode, value: 0); invoke(.transmitComplete)
        }
        if flags & 0x1C7C != 0 {
            handle.write(.errorCode, value: flags)
            clearFlag(.init(rawValue: 0x1C7C))
            if flags & 0x7C != 0 {
                handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: -Int(handle.read(.receiveSize))))
                handle.write(.receiveSize, value: 0); handle.write(.receiveState, value: 0x20)
            } else if flags & 0x80 == 0 && flags & 0x1C00 != 0 { handle.write(.globalState, value: 0x20) }
            invoke(.error)
        }
    }
}
