import STM32H7RSHAL
import _Volatile

public struct STM32RTCHandleRegisters: RTCHandleIO {
    private let storageAddress: UInt
    // Twelve caller-owned UInt32 words in RTCHandleWord order.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 12)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    public func read(_ word: RTCHandleWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }
    public func write(_ word: RTCHandleWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }
}
