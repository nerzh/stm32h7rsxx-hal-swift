import STM32H7RSHAL
import _Volatile

public struct STM32HASHHandleRegisters: HASHHandleIO {
    private let storageAddress: UInt

    // Caller-owned 25-word storage shared by foreground, IRQ, and DMA callbacks.
    // Buffer fields contain 32-bit Cortex-M addresses, as in the C driver.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 25)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: HASHHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: HASHHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
