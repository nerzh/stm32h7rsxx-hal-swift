import STM32H7RSHAL
import _Volatile

public struct STM32DMA2DHandleRegisters: DMA2DHandleIO {
    private let storageAddress: UInt

    // Caller-owned 24-word storage shared by foreground and IRQ callbacks.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 24)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: DMA2DHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: DMA2DHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
