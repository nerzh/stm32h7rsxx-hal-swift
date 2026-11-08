// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPDIFRX operations and definitions from stm32h7rsxx_hal_spdifrx.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPDIFRX {
    @discardableResult
    public func receive(_ stream: SPDIFRXStream, data: UnsafeMutablePointer<UInt32>?, count: UInt16,
                        timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        guard let data, count != 0 else { return .error }
        guard handle.read(.state) == 1 else { return .busy }
        guard lock() else { return .busy }
        handle.write(.state, value: 2); synchronize()
        let start = getTick()
        guard waitOnFlag(32, timeout: timeout, start: start, getTick: getTick) == .ok else { return .timeout }
        enableReception()
        var remaining = count, buffer = data
        while remaining > 0 {
            let start = getTick()
            guard waitOnFlag(stream == .data ? 1 : 2, timeout: timeout, start: start, getTick: getTick) == .ok else { return .timeout }
            buffer.pointee = registers.read(stream == .data ? .dr : .csr)
            buffer += 1; remaining -= 1
        }
        handle.write(.state, value: 1); unlock(); return .ok
    }
    func waitOnFlag(_ flag: UInt32, timeout: UInt32, start: UInt32, getTick: () -> UInt32) -> HALStatus {
        while getFlag(flag) == 0 {
            if timeout != .max && (getTick() &- start > timeout || timeout == 0) {
                disableAllInterrupts(); handle.write(.state, value: 1); unlock(); return .timeout
            }
        }
        return .ok
    }
    @discardableResult
    public func receiveInterrupt(_ stream: SPDIFRXStream, data: UnsafeMutablePointer<UInt32>?, count: UInt16,
                                 systemCoreClock: UInt32) -> HALStatus {
        let budget = 10 &* (systemCoreClock / 24 / 1000)
        let state = handle.read(.state)
        guard state == 1 || state == (stream == .data ? 4 : 3) else { return .busy }
        guard let data, count != 0 else { return .error }
        guard lock() else { return .busy }
        setBuffer(stream, data: data, count: count)
        handle.write(.errorCode, value: 0); handle.write(.state, value: stream == .data ? 3 : 4)
        enableInterrupts(4); enableInterrupts(8); enableInterrupts(stream == .data ? 1 : 2)
        if synchronizeBeforeReception(budget: budget) != .ok { return .timeout }
        unlock(); return .ok
    }
    func setBuffer(_ stream: SPDIFRXStream, data: UnsafeMutablePointer<UInt32>, count: UInt16) {
        handle.writeBuffer(stream, value: data)
        handle.write(stream == .data ? .receiveSize : .controlSize, value: UInt32(count))
        handle.write(stream == .data ? .receiveCount : .controlCount, value: UInt32(count))
    }
    func synchronizeBeforeReception(budget: UInt32) -> HALStatus {
        if registers.readPeripheralControl() & 3 != 3 {
            synchronize()
            var remaining = budget
            repeat {
                if remaining == 0 {
                    disableAllInterrupts(); handle.write(.state, value: 1); unlock(); return .timeout
                }
                remaining -= 1
            } while getFlag(32) == 0
            enableReception()
        }
        return .ok
    }
    public func handleInterrupt() {
        let flags = registers.read(.sr), enabled = registers.read(.imr)
        if flags & 1 == 1 && enabled & 1 == 1 { clearInterrupts(1); receiveWordInterrupt(.data) }
        if flags & 2 == 2 && enabled & 2 == 2 { clearInterrupts(2); receiveWordInterrupt(.control) }
        // These two C branches call the weak default directly even in registered mode.
        if flags & 8 == 8 && enabled & 8 == 8 { clearInterrupts(8); addError(2); defaults.error(callbacks.context) }
        if flags & 4 == 4 && enabled & 4 == 4 { clearInterrupts(4); addError(4); defaults.error(callbacks.context) }
    }
    func receiveWordInterrupt(_ stream: SPDIFRXStream) {
        let buffer = handle.readBuffer(stream)!
        buffer.pointee = registers.read(stream == .data ? .dr : .csr)
        handle.writeBuffer(stream, value: handle.readBuffer(stream)! + 1)
        let count: SPDIFRXHandleWord = stream == .data ? .receiveCount : .controlCount
        handle.write(count, value: UInt32(UInt16(truncatingIfNeeded: handle.read(count)) &- 1))
        if handle.read(count) == 0 {
            disableInterrupts(stream == .data ? 13 : 2)
            handle.write(.state, value: 1); unlock(); invoke(stream == .data ? .receiveComplete : .controlComplete)
        }
    }
}
