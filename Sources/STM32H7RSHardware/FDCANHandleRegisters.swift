import STM32H7RSHAL
import _Volatile

public struct STM32FDCANHandleRegisters: FDCANHandleIO {
    private let storageAddress: UInt
    // Twenty-seven caller-owned UInt32 words in FDCANHandleWord order.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 27)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: FDCANHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: FDCANHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
