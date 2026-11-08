// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// JPEG operations and definitions from stm32h7rsxx_hal_jpeg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension JPEG {
    @discardableResult
    public func encode(input: UnsafeMutablePointer<UInt8>?, inputLength: UInt32,
                         output: UnsafeMutablePointer<UInt8>?, outputLength: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        precondition(inputLength >= 4 && outputLength >= 4)
        guard let input, let output else { return .error }
        guard lock() else { return .busy }
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        if handle.read(.state) == 1 {
        guard handle.read(.context) & 0x100 == 0x100 else { unlock(); return .error }
        handle.write(.state, value: 3); modifyContext(clear: 0xF); modifyContext(set: 5)
        let start = getTick()
        handle.writeBuffer(.input, value: input); handle.writeBuffer(.output, value: output)
        handle.write(.inputLength, value: inputLength - (inputLength % 4))
        handle.write(.outputLength, value: outputLength - (outputLength % 4))
        handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0); initializeProcess()
        while process() == 0 {
            if timeout != .max && (getTick() &- start > timeout || timeout == 0) {
                addError(8); unlock(); handle.write(.state, value: 1); return .timeout
            }
        }
        unlock(); handle.write(.state, value: 1)
        }
        return .ok
    }
    @discardableResult
    public func encodeInterrupt(input: UnsafeMutablePointer<UInt8>?, inputLength: UInt32,
                         output: UnsafeMutablePointer<UInt8>?, outputLength: UInt32) -> HALStatus {
        precondition(inputLength >= 4 && outputLength >= 4)
        guard let input, let output else { return .error }
        guard lock() else { return .busy }
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        guard handle.read(.context) & 0x100 == 0x100 else { unlock(); return .error }
        handle.write(.state, value: 3); modifyContext(clear: 0xF); modifyContext(set: 9)
        handle.writeBuffer(.input, value: input); handle.writeBuffer(.output, value: output)
        handle.write(.inputLength, value: inputLength - (inputLength % 4))
        handle.write(.outputLength, value: outputLength - (outputLength % 4))
        handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0); initializeProcess()
        return .ok
    }
    @discardableResult
    public func encodeDMA(input: UnsafeMutablePointer<UInt8>?, inputLength: UInt32,
                         output: UnsafeMutablePointer<UInt8>?, outputLength: UInt32) -> HALStatus {
        precondition(inputLength >= 4 && outputLength >= 4)
        guard let input, let output else { return .error }
        guard lock() else { return .busy }
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        guard handle.read(.context) & 0x100 == 0x100 else { unlock(); return .error }
        handle.write(.state, value: 3); modifyContext(clear: 0xF); modifyContext(set: 13)
        handle.writeBuffer(.input, value: input); handle.writeBuffer(.output, value: output)
        handle.write(.inputLength, value: inputLength)
        handle.write(.outputLength, value: outputLength)
        handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0); initializeProcess()
        if startDMAProcess() != .ok { handle.write(.state, value: 6); unlock(); return .error }
        return .ok
    }
    @discardableResult
    public func decode(input: UnsafeMutablePointer<UInt8>?, inputLength: UInt32,
                         output: UnsafeMutablePointer<UInt8>?, outputLength: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        precondition(inputLength >= 4 && outputLength >= 4)
        guard let input, let output else { return .error }
        guard lock() else { return .busy }
        let start = getTick()
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        handle.write(.state, value: 4); modifyContext(clear: 0xF); modifyContext(set: 6)
        handle.writeBuffer(.input, value: input); handle.writeBuffer(.output, value: output)
        handle.write(.inputLength, value: inputLength - (inputLength % 4))
        handle.write(.outputLength, value: outputLength - (outputLength % 4))
        handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0); initializeProcess()
        while process() == 0 {
            if timeout != .max && (getTick() &- start > timeout || timeout == 0) {
                addError(8); unlock(); handle.write(.state, value: 1); return .timeout
            }
        }
        unlock(); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func decodeInterrupt(input: UnsafeMutablePointer<UInt8>?, inputLength: UInt32,
                         output: UnsafeMutablePointer<UInt8>?, outputLength: UInt32) -> HALStatus {
        precondition(inputLength >= 4 && outputLength >= 4)
        guard let input, let output else { return .error }
        guard lock() else { return .busy }
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        handle.write(.state, value: 4); modifyContext(clear: 0xF); modifyContext(set: 10)
        handle.writeBuffer(.input, value: input); handle.writeBuffer(.output, value: output)
        handle.write(.inputLength, value: inputLength - (inputLength % 4))
        handle.write(.outputLength, value: outputLength - (outputLength % 4))
        handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0); initializeProcess()
        return .ok
    }
    @discardableResult
    public func decodeDMA(input: UnsafeMutablePointer<UInt8>?, inputLength: UInt32,
                         output: UnsafeMutablePointer<UInt8>?, outputLength: UInt32) -> HALStatus {
        precondition(inputLength >= 4 && outputLength >= 4)
        guard let input, let output else { return .error }
        guard lock() else { return .busy }
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        handle.write(.state, value: 4); modifyContext(clear: 0xF); modifyContext(set: 14)
        handle.writeBuffer(.input, value: input); handle.writeBuffer(.output, value: output)
        handle.write(.inputLength, value: inputLength)
        handle.write(.outputLength, value: outputLength)
        handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0); initializeProcess()
        if startDMAProcess() != .ok { handle.write(.state, value: 6); unlock(); return .error }
        return .ok
    }
    public func configureInputBuffer(_ buffer: UnsafeMutablePointer<UInt8>?, length: UInt32) {
        handle.writeBuffer(.input, value: buffer); handle.write(.inputLength, value: length)
    }
    public func configureOutputBuffer(_ buffer: UnsafeMutablePointer<UInt8>?, length: UInt32) {
        handle.writeBuffer(.output, value: buffer); handle.write(.outputLength, value: length)
    }
    func initializeProcess() {
        modifyContext(clear: 0x3000)
        if handle.read(.context) & 3 == 2 { modify(.confr1, set: 8) } else { modify(.confr1, clear: 8) }
        modify(.confr0, clear: 1); disableInterrupts(0x7E); disableDMA(0x1800)
        modify(.cr, set: 0x2000); modify(.cr, set: 0x4000); clearFlags(0xFE); modify(.confr0, set: 1)
        if handle.read(.context) & 0xC == 8 { enableInterrupts(0x6E) }
        else if handle.read(.context) & 0xC == 0xC { enableInterrupts(0x60) }
    }
    public func handleInterrupt() {
        switch handle.read(.state) {
        case 3, 4:
            if handle.read(.context) & 0xC == 8 { _ = process() }
            else if handle.read(.context) & 0xC == 0xC { continueDMAProcess() }
        default: break
        }
    }
    func process() -> UInt32 {
        let flags = registers.read(.sr)
        if handle.read(.context) & 3 == 2 && flags & 0x40 != 0 {
            getInfoIntoHandle(); handle.write(.imageQuality, value: 0); invokeInfoReady()
            disableInterrupts(0x40); clearFlags(0x40)
        }
        if handle.read(.context) & 0x1000 == 0 {
            if flags & 2 != 0 { readInputData(words: 4) }
            else if flags & 4 != 0 { readInputData(words: 1) }
        }
        if handle.read(.context) & 0x2000 == 0 {
            if flags & 8 != 0 { storeOutputData(words: 4) }
            else if flags & 0x10 != 0 { storeOutputData(words: 1) }
        }
        if flags & 0x38 == 0x20 {
            modify(.confr0, clear: 1)
            if handle.read(.context) & 0xC == 8 { disableInterrupts(0x7E) }
            clearFlags(0xFE)
            if handle.read(.outputCount) > 0 { invokeDataReady(); handle.write(.outputCount, value: 0) }
            finishProcess(); return 1
        }
        return 0
    }
    func finishProcess() {
        let context = handle.read(.context)
        handle.write(.context, value: handle.read(.context) & 0x4100)
        unlock(); handle.write(.state, value: 1)
        invoke(context & 3 == 2 ? .decodeComplete : .encodeComplete)
    }
    func writeOutputWord(_ value: UInt32) {
        for index: UInt32 in 0..<4 {
            handle.readBuffer(.output)![Int(handle.read(.outputCount) &+ index)] = UInt8(truncatingIfNeeded: (value & (0xFF << (8 * index))) >> (8 * index))
        }
        handle.write(.outputCount, value: handle.read(.outputCount) &+ 4)
    }
    func storeOutputData(words: UInt32) {
        if handle.read(.outputLength) >= handle.read(.outputCount) &+ (words &* 4) {
            for _ in 0..<words { writeOutputWord(registers.read(.dor)) }
            if handle.read(.outputLength) == handle.read(.outputCount) { invokeDataReady(); handle.write(.outputCount, value: 0) }
        } else if handle.read(.outputLength) > handle.read(.outputCount) {
            let count = (handle.read(.outputLength) &- handle.read(.outputCount)) / 4
            for _ in 0..<count { writeOutputWord(registers.read(.dor)) }
            if handle.read(.outputLength) == handle.read(.outputCount) { invokeDataReady(); handle.write(.outputCount, value: 0) }
            else {
                var bytes = handle.read(.outputLength) &- handle.read(.outputCount)
                let value = registers.read(.dor)
                for index in 0..<bytes {
                    handle.readBuffer(.output)![Int(handle.read(.outputCount))] = UInt8(truncatingIfNeeded: (value >> (8 * (index & 3))) & 0xFF)
                    handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
                }
                invokeDataReady(); handle.write(.outputCount, value: 0)
                bytes = 4 &- bytes
                // Preserve ST's residual-byte starting index, including short buffers.
                for index in bytes..<4 {
                    handle.readBuffer(.output)![Int(handle.read(.outputCount))] = UInt8(truncatingIfNeeded: (value >> (8 * index)) & 0xFF)
                    handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
                }
            }
        }
    }
    func writeInputWord() {
        let count = handle.read(.inputCount)
        let value = UInt32(handle.readBuffer(.input)![Int(count)])
            | (UInt32(handle.readBuffer(.input)![Int(count &+ 1)]) << 8)
            | (UInt32(handle.readBuffer(.input)![Int(count &+ 2)]) << 16)
            | (UInt32(handle.readBuffer(.input)![Int(count &+ 3)]) << 24)
        registers.write(.dir, value: value); handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
    }
    func readInputData(words: UInt32) {
        var bytes: UInt32 = 0
        if handle.read(.inputLength) == 0 || words == 0 { _ = pause(1) }
        else if handle.read(.inputLength) > handle.read(.inputCount) { bytes = handle.read(.inputLength) &- handle.read(.inputCount) }
        else if handle.read(.inputLength) == handle.read(.inputCount) {
            invokeGetData()
            if handle.read(.inputLength) > 4 { handle.write(.inputLength, value: ((handle.read(.inputLength) &+ 3) / 4) &* 4) }
            handle.write(.inputCount, value: 0); bytes = handle.read(.inputLength)
        }
        if handle.read(.context) & 0x1000 == 0 && bytes > 0 {
            let count = bytes / 4
            if count >= words { for _ in 0..<words { writeInputWord() } }
            else if count > 0 { for _ in 0..<count { writeInputWord() } }
            else {
                var value: UInt32 = 0
                for index in 0..<bytes {
                    value |= UInt32(handle.readBuffer(.input)![Int(handle.read(.inputCount))]) << (8 * (index & 3))
                    handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
                }
                registers.write(.dir, value: value)
            }
        }
    }
}
