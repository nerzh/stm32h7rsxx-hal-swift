import STM32H7RSHAL
import _Volatile

public struct STM32SPDIFRXHandleRegisters: SPDIFRXHandleIO {
    private let storageAddress: UInt
    private let pointerAddress: UInt
    // Nineteen caller-owned words plus two native-pointer-width slots, shared with IRQ handlers.
    // Count/size fields use the low halfword of slots 12...15; their padding is untouched.
    public init(storage: UnsafeMutableBufferPointer<UInt32>, bufferPointers: UnsafeMutableBufferPointer<UInt>) {
        precondition(storage.count >= 19 && bufferPointers.count >= 2)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        pointerAddress = UInt(bitPattern: bufferPointers.baseAddress!)
        precondition(storageAddress & 3 == 0 && pointerAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    }
    public func read(_ word: SPDIFRXHandleWord) -> UInt32 {
        if (12...15).contains(word.rawValue) { return UInt32(VolatileMappedRegister<UInt16>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()) }
        return VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: SPDIFRXHandleWord, value: UInt32) {
        if (12...15).contains(word.rawValue) {
            VolatileMappedRegister<UInt16>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(UInt16(truncatingIfNeeded: value)); return
        }
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
    public func readBuffer(_ stream: SPDIFRXStream) -> UnsafeMutablePointer<UInt32>? {
        let pointerAddress = self.pointerAddress + UInt(stream.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits: UInt
        if MemoryLayout<UInt>.size == 4 { bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: pointerAddress).load()) }
        else { bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: pointerAddress).load()) }
        return UnsafeMutablePointer<UInt32>(bitPattern: bits)
    }
    public func writeBuffer(_ stream: SPDIFRXStream, value buffer: UnsafeMutablePointer<UInt32>?) {
        let pointerAddress = self.pointerAddress + UInt(stream.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits = UInt(bitPattern: buffer)
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: pointerAddress).store(UInt32(bits)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: pointerAddress).store(UInt64(bits)) }
    }
}
