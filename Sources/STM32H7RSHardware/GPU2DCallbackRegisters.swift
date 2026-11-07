import STM32H7RSHAL
import _Volatile

public struct STM32GPU2DCallbackRegisters: GPU2DCallbackIO {
    private let storageAddress: UInt
    public let context: UnsafeMutableRawPointer?
    // Three initially zero native-width slots: MSP init, MSP deinit, completion.
    // Storage and context remain owned by the caller throughout IRQ handling.
    public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
        precondition(storage.count >= 3)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
        self.context = context
    }
    public func read(_ id: GPU2DCallbackID) -> GPU2DCallback? {
        let bits = load(Int(id.rawValue))
        return bits == 0 ? nil : unsafeBitCast(bits, to: GPU2DCallback.self)
    }
    public func write(_ id: GPU2DCallbackID, value: GPU2DCallback?) {
        store(Int(id.rawValue), value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    public func readCommandListComplete() -> GPU2DCommandListCallback? {
        let bits = load(2)
        return bits == 0 ? nil : unsafeBitCast(bits, to: GPU2DCommandListCallback.self)
    }
    public func writeCommandListComplete(_ value: GPU2DCommandListCallback?) {
        store(2, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
    }
    private func load(_ index: Int) -> UInt {
        let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()) }
        return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    private func store(_ index: Int, _ bits: UInt) {
        let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
        if MemoryLayout<UInt>.size == 4 { VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits)) }
        else { VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits)) }
    }
}
