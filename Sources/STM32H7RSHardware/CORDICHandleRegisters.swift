import STM32H7RSHAL
import _Volatile

public struct STM32CORDICHandleRegisters: CORDICHandleIO {
    private let wordsAddress: UInt
    private let pointersAddress: UInt

    // Caller-owned storage: 6 zeroed UInt32 slots and two zeroed UInt slots.
    // Keep both buffers alive across all foreground, IRQ and DMA calls.
    public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>) {
        precondition(words.count >= 6 && pointers.count >= 2)
        wordsAddress = UInt(bitPattern: words.baseAddress!)
        pointersAddress = UInt(bitPattern: pointers.baseAddress!)
        precondition(wordsAddress & 3 == 0)
        precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    }
    private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
        .init(unsafeBitPattern: wordsAddress + UInt(index) * 4)
    }
    public func read(_ word: CORDICHandleWord) -> UInt32 { slot(word.rawValue).load() }
    public func write(_ word: CORDICHandleWord, value: UInt32) { slot(word.rawValue).store(value) }
    public func readPointer(_ pointer: CORDICBufferPointer) -> UnsafeMutableRawPointer? {
        let address = pointersAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits: UInt
        if MemoryLayout<UInt>.size == 4 {
            bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        } else { bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load()) }
        return UnsafeMutableRawPointer(bitPattern: bits)
    }
    public func writePointer(_ pointer: CORDICBufferPointer, value: UnsafeMutableRawPointer?) {
        let address = pointersAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits = UInt(bitPattern: value)
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
        } else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits)) }
    }
}
