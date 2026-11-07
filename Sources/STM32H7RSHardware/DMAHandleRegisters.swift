import STM32H7RSHAL
import _Volatile

public struct STM32DMAHandleRegisters: DMAHandleIO {
    private let storageAddress: UInt

    // Five caller-owned words: lock, mode, state, error code, queue bus address.
    // Initialize them to zero before first use; copies share this storage.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 5)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition((storageAddress & 3) == 0)
    }

    public func read(_ word: DMAHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }

    public func write(_ word: DMAHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
