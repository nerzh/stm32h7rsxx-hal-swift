import STM32H7RSHAL
import _Volatile

public struct STM32DTSHandleRegisters: DTSHandleIO {
    private let storageAddress: UInt

    // Nine caller-owned UInt32 slots: seven configuration fields, lock, state.
    // Keep the zero-initialized storage alive across foreground and IRQ calls.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 9)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress & 3 == 0)
    }
    private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
        .init(unsafeBitPattern: storageAddress + UInt(index) * 4)
    }
    public func read(_ word: DTSConfigurationWord) -> UInt32 { slot(word.rawValue).load() }
    public func write(_ word: DTSConfigurationWord, value: UInt32) { slot(word.rawValue).store(value) }
    public func read(_ word: DTSHandleWord) -> UInt32 { slot(7 + word.rawValue).load() }
    public func write(_ word: DTSHandleWord, value: UInt32) { slot(7 + word.rawValue).store(value) }
}
