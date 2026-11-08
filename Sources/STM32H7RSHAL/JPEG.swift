// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// JPEG operations and definitions from stm32h7rsxx_hal_jpeg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension JPEG {
    @discardableResult
    public func initialize() -> HALStatus {
        if handle.read(.state) == 0 {
            unlock()
            if useRegisteredCallbacks {
                callbacks.writeInfoReady(defaults.infoReady); callbacks.write(.encodeComplete, value: defaults.encodeComplete)
                callbacks.write(.decodeComplete, value: defaults.decodeComplete); callbacks.write(.error, value: defaults.error)
                callbacks.writeGetData(defaults.getData); callbacks.writeDataReady(defaults.dataReady); prepareMSP(.mspInitialize)
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 2); enable(); modify(.confr0, clear: 1)
        disableInterrupts(0x7E); disableDMA(0x1800); modify(.cr, set: 0x2000); modify(.cr, set: 0x4000); clearFlags(0xFE)
        handle.writeQuantizationTable(0, value: JPEGDefaultTables.luminance.utf8Start)
        handle.writeQuantizationTable(1, value: JPEGDefaultTables.chrominance.utf8Start)
        handle.writeQuantizationTable(2, value: nil); handle.writeQuantizationTable(3, value: nil)
        if setHuffmanEncodingMemory() != .ok { handle.write(.errorCode, value: 1); return .error }
        modify(.confr1, set: 0x100); handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0)
        handle.write(.state, value: 1); handle.write(.errorCode, value: 0); handle.write(.context, value: 0); return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        prepareMSP(.mspDeinitialize); invoke(.mspDeinitialize)
        handle.write(.state, value: 2); handle.write(.errorCode, value: 0)
        handle.write(.inputCount, value: 0); handle.write(.outputCount, value: 0)
        handle.write(.state, value: 0); handle.write(.context, value: 0); unlock(); return .ok
    }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func enable() { modify(.cr, set: 1) }
    public func disable() { modify(.cr, clear: 1) }
    public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.sr) & flag }
    public func clearFlags(_ flags: UInt32) { modify(.cfr, set: flags & 0x60) }
    public func enableInterrupts(_ mask: UInt32) { modify(.cr, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { modify(.cr, clear: mask) }
    public func getInterruptSource(_ mask: UInt32) -> UInt32 { registers.read(.cr) & mask }
    func enableDMA(_ mask: UInt32) { modify(.cr, set: mask & 0x1800) }
    func disableDMA(_ mask: UInt32) { modify(.cr, clear: mask & 0x1800) }
    @discardableResult
    public func setHeaderParsing(enabled: Bool) -> HALStatus {
        guard lock() else { return .busy }
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        handle.write(.state, value: 2)
        if enabled { modify(.confr1, set: 0x100) } else { modify(.confr1, clear: 0x100) }
        unlock(); handle.write(.state, value: 1); return .ok
    }
    @discardableResult
    public func setUserQuantizationTables(_ table0: UnsafePointer<UInt8>?, _ table1: UnsafePointer<UInt8>?,
                                          _ table2: UnsafePointer<UInt8>?, _ table3: UnsafePointer<UInt8>?) -> HALStatus {
        guard lock() else { return .busy }
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        handle.write(.state, value: 2); modifyContext(set: 0x4000)
        handle.writeQuantizationTable(0, value: table0); handle.writeQuantizationTable(1, value: table1)
        handle.writeQuantizationTable(2, value: table2); handle.writeQuantizationTable(3, value: table3)
        unlock(); handle.write(.state, value: 1); return .ok
    }
    @discardableResult
    public func configureEncoding(_ configuration: JPEGConfiguration?) -> HALStatus {
        guard let c = configuration else { return .error }
        precondition(JPEGColorSpace(rawValue: c.colorSpace) != nil && JPEGChromaSubsampling(rawValue: c.chromaSubsampling) != nil)
        precondition((1...100).contains(c.imageQuality))
        guard lock() else { return .busy }
        guard handle.read(.state) == 1 else { unlock(); return .busy }
        handle.write(.state, value: 2)
        handle.write(.colorSpace, value: c.colorSpace); handle.write(.chromaSubsampling, value: c.chromaSubsampling)
        handle.write(.imageHeight, value: c.imageHeight); handle.write(.imageWidth, value: c.imageWidth); handle.write(.imageQuality, value: c.imageQuality)
        modify(.confr1, clear: 0x30)
        let error: UInt32
        if handle.read(.colorSpace) == 0 {
            handle.write(.chromaSubsampling, value: 0); setColorGrayscale()
            error = setQuantizationMemory(handle.readQuantizationTable(0)!, table: .quantization0)
        } else if handle.read(.colorSpace) == 0x10 {
            modify(.confr1, set: 0x10); setColorYCbCr()
            error = setQuantizationMemory(handle.readQuantizationTable(0)!, table: .quantization0)
            _ = setQuantizationMemory(handle.readQuantizationTable(1)!, table: .quantization1)
            if handle.read(.context) & 0x4000 != 0 {
                modify(.confr1, clear: 0x30); modify(.confr1, set: 0x20)
                _ = setQuantizationMemory(handle.readQuantizationTable(2)!, table: .quantization2)
                modify(.confr5, clear: 0xC); modify(.confr5, set: 4); modify(.confr6, clear: 0xC); modify(.confr6, set: 8)
            }
        } else {
            setColorCMYK(); error = setQuantizationMemory(handle.readQuantizationTable(0)!, table: .quantization0)
            if handle.read(.context) & 0x4000 != 0 {
                modify(.confr1, set: 0x30)
                _ = setQuantizationMemory(handle.readQuantizationTable(1)!, table: .quantization1)
                _ = setQuantizationMemory(handle.readQuantizationTable(2)!, table: .quantization2)
                _ = setQuantizationMemory(handle.readQuantizationTable(3)!, table: .quantization3)
                modify(.confr5, set: 4); modify(.confr6, set: 8); modify(.confr7, set: 0xC)
            }
        }
        if error != 0 { handle.write(.errorCode, value: 2); unlock(); handle.write(.state, value: 1); return .error }
        modify(.confr1, clear: 0xFFFF0000, set: (handle.read(.imageHeight) & 0xFFFF) << 16)
        modify(.confr3, clear: 0xFFFF0000, set: (handle.read(.imageWidth) & 0xFFFF) << 16)
        let horizontal: UInt32, vertical: UInt32
        if handle.read(.chromaSubsampling) == 1 { horizontal = 16; vertical = 16 }
        else if handle.read(.chromaSubsampling) == 2 { horizontal = 16; vertical = 8 }
        else { horizontal = 8; vertical = 8 }
        var h = handle.read(.imageWidth) / horizontal
        if handle.read(.imageWidth) % horizontal != 0 { h &+= 1 }
        var v = handle.read(.imageHeight) / vertical
        if handle.read(.imageHeight) % vertical != 0 { v &+= 1 }
        let count = (h &* v) &- 1
        registers.write(.confr2, value: count & 0x3FFFFFF); modifyContext(set: 0x100)
        unlock(); handle.write(.state, value: 1); return .ok
    }
    func sampling() -> (UInt32, UInt32, UInt32) {
        if handle.read(.chromaSubsampling) == 1 { return (0x2000, 0x200, 0x30) }
        else if handle.read(.chromaSubsampling) == 2 { return (0x2000, 0x100, 0x10) }
        return (0x1000, 0x100, 0)
    }
    func setColorYCbCr() {
        let (horizontal, vertical, count) = sampling()
        modify(.confr1, clear: 0xC3); modify(.confr1, set: 0x82)
        registers.write(.confr4, value: 0); modify(.confr4, set: horizontal | vertical | (count & 0xF0))
        registers.write(.confr5, value: 0); modify(.confr5, set: 0x1107)
        registers.write(.confr6, value: 0); modify(.confr6, set: 0x1107)
    }
    func setColorGrayscale() {
        modify(.confr1, clear: 0xC3); registers.write(.confr4, value: 0); modify(.confr4, set: 0x1100)
    }
    func setColorCMYK() {
        modify(.confr1, set: 0xC3); let (horizontal, vertical, count) = sampling()
        registers.write(.confr4, value: 0); modify(.confr4, set: horizontal | vertical | (count & 0xF0))
        registers.write(.confr5, value: 0); modify(.confr5, set: 0x1100)
        registers.write(.confr6, value: 0); modify(.confr6, set: 0x1100)
        registers.write(.confr7, value: 0); modify(.confr7, set: 0x1100)
    }
    func readInfo(write: (JPEGHandleWord, UInt32) -> Void, readColorSpace: () -> UInt32) -> HALStatus {
        if registers.read(.confr1) & 3 == 2 { write(.colorSpace, 0x10) }
        else if registers.read(.confr1) & 3 == 0 { write(.colorSpace, 0) }
        else if registers.read(.confr1) & 3 == 3 { write(.colorSpace, 0x30) }
        else { return .error }
        write(.imageHeight, (registers.read(.confr1) & 0xFFFF0000) >> 16)
        write(.imageWidth, (registers.read(.confr3) & 0xFFFF0000) >> 16)
        if readColorSpace() == 0x10 || readColorSpace() == 0x30 {
            let y = (registers.read(.confr4) & 0xF0) >> 4, cb = (registers.read(.confr5) & 0xF0) >> 4, cr = (registers.read(.confr6) & 0xF0) >> 4
            if y == 1 && cb == 0 && cr == 0 { write(.chromaSubsampling, 2) }
            else if y == 0 && cb == 0 && cr == 0 { write(.chromaSubsampling, 0) }
            else if y == 3 && cb == 0 && cr == 0 { write(.chromaSubsampling, 1) }
            else { write(.chromaSubsampling, 0) }
        } else { write(.chromaSubsampling, 0) }
        write(.imageQuality, getQuality()); return .ok
    }
    @discardableResult
    public func getInfo(_ output: UnsafeMutablePointer<JPEGConfiguration>?) -> HALStatus {
        guard let output else { return .error }
        return readInfo(write: { field, value in
            switch field {
            case .colorSpace: output.pointee.colorSpace = value
            case .chromaSubsampling: output.pointee.chromaSubsampling = value
            case .imageHeight: output.pointee.imageHeight = value
            case .imageWidth: output.pointee.imageWidth = value
            case .imageQuality: output.pointee.imageQuality = value
            default: preconditionFailure()
            }
        }, readColorSpace: { output.pointee.colorSpace })
    }
    func getInfoIntoHandle() {
        _ = readInfo(write: { handle.write($0, value: $1) }, readColorSpace: { handle.read(.colorSpace) })
    }
}
