import STM32H7RSHAL
import _Volatile

public struct STM32JPEGHandleRegisters: JPEGHandleIO {
    private let storageAddress: UInt
    private let pointerAddress: UInt
    // Fourteen words (slot 9 uses its low byte), followed separately by six native pointer slots.
    // Pointer order: input, output, quantization tables 0...3. Storage remains caller-owned.
    public init(storage: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>) {
        precondition(storage.count >= 14 && pointers.count >= 6)
        storageAddress = UInt(bitPattern: storage.baseAddress!); pointerAddress = UInt(bitPattern: pointers.baseAddress!)
        precondition(storageAddress & 3 == 0 && pointerAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    }
    public var configurationPointer: UnsafeMutablePointer<UInt32> { .init(bitPattern: storageAddress)! }
    public func read(_ word: JPEGHandleWord) -> UInt32 {
        let address = storageAddress + UInt(word.rawValue) * 4
        if word == .customQuantizationTable { return UInt32(VolatileMappedRegister<UInt8>(unsafeBitPattern: address).load()) }
        return VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()
    }
    public func write(_ word: JPEGHandleWord, value: UInt32) {
        let address = storageAddress + UInt(word.rawValue) * 4
        if word == .customQuantizationTable { VolatileMappedRegister<UInt8>(unsafeBitPattern: address).store(UInt8(truncatingIfNeeded: value)) }
        else { VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(value) }
    }
    private func readPointer(_ index: Int) -> UInt {
        let address = pointerAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()) }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    private func writePointer(_ index: Int, value: UInt) {
        let address = pointerAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(value)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(value)) }
    }
    public func readBuffer(_ stream: JPEGStream) -> UnsafeMutablePointer<UInt8>? { .init(bitPattern: readPointer(Int(stream.rawValue))) }
    public func writeBuffer(_ stream: JPEGStream, value: UnsafeMutablePointer<UInt8>?) { writePointer(Int(stream.rawValue), value: UInt(bitPattern: value)) }
    public func readQuantizationTable(_ index: Int) -> UnsafePointer<UInt8>? { precondition((0..<4).contains(index)); return .init(bitPattern: readPointer(index + 2)) }
    public func writeQuantizationTable(_ index: Int, value: UnsafePointer<UInt8>?) { precondition((0..<4).contains(index)); writePointer(index + 2, value: UInt(bitPattern: value)) }
}
