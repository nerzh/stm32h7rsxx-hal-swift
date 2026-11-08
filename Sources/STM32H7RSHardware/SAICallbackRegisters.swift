import STM32H7RSHAL
import _Volatile

public struct STM32SAICallbackRegisters: SAICallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Eight initially nil native-width slots: seven SAICallbackID functions,
  // followed by the differently typed mute callback. Storage is unowned.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 8)
    storageAddress = UInt(bitPattern: storage.baseAddress!)
    precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    self.context = context
  }
  private func readBits(_ index: UInt32) -> UInt {
    let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
    if MemoryLayout<UInt>.size == 4 {
      return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
    return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
  }
  private func writeBits(_ index: UInt32, _ bits: UInt) {
    let address = storageAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
  public func read(_ id: SAICallbackID) -> SAICallback? {
    let bits = readBits(id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SAICallback.self)
  }
  public func write(_ id: SAICallbackID, value: SAICallback?) {
    writeBits(id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readMute() -> SAIMuteCallback? {
    let bits = readBits(7)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SAIMuteCallback.self)
  }
  public func writeMute(_ value: SAIMuteCallback?) {
    writeBits(7, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
