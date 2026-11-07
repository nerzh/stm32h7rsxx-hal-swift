import STM32H7RSHAL
import _Volatile

public struct STM32UARTHandleRegisters: UARTHandleIO {
    private let wordsAddress: UInt
    private let pointersAddress: UInt

    // Caller-owned storage: 35 zeroed UInt32 slots and two zeroed UInt slots.
    // Halfword fields occupy the low 16 bits of slots 19...25; padding is untouched.
    // Keep both buffers alive across all foreground, IRQ and DMA calls.
    public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>) {
        precondition(words.count >= 35 && pointers.count >= 2)
        wordsAddress = UInt(bitPattern: words.baseAddress!)
        pointersAddress = UInt(bitPattern: pointers.baseAddress!)
        precondition(wordsAddress & 3 == 0)
        precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    }
    private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
        .init(unsafeBitPattern: wordsAddress + UInt(index) * 4)
    }
    public func read(_ word: UARTConfigurationWord) -> UInt32 { slot(word.rawValue).load() }
    public func write(_ word: UARTConfigurationWord, value: UInt32) { slot(word.rawValue).store(value) }
    public func read(_ word: UARTAdvancedConfigurationWord) -> UInt32 { slot(9 + word.rawValue).load() }
    public func write(_ word: UARTAdvancedConfigurationWord, value: UInt32) { slot(9 + word.rawValue).store(value) }
    public func read(_ word: UARTHandleHalfWord) -> UInt16 {
        VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(19 + word.rawValue) * 4).load()
    }
    public func write(_ word: UARTHandleHalfWord, value: UInt16) {
        VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(19 + word.rawValue) * 4).store(value)
    }
    public func read(_ word: UARTHandleWord) -> UInt32 { slot(26 + word.rawValue).load() }
    public func write(_ word: UARTHandleWord, value: UInt32) { slot(26 + word.rawValue).store(value) }
    public func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer? {
        let address = pointersAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits: UInt
        if MemoryLayout<UInt>.size == 4 {
            bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
        } else { bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load()) }
        return UnsafeMutableRawPointer(bitPattern: bits)
    }
    public func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?) {
        let address = pointersAddress + UInt(pointer.rawValue) * UInt(MemoryLayout<UInt>.stride)
        let bits = UInt(bitPattern: value)
        if MemoryLayout<UInt>.size == 4 {
            VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
        } else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits)) }
    }
}
