import STM32H7RSHAL
import _Volatile

public struct STM32MMCCallbackRegisters: MMCCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Eight initially nil native-width callback slots. Storage is unowned.
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
  private func slotIndex(_ id: MMCCallbackID) -> UInt32 {
    id.rawValue < 6 ? id.rawValue : id.rawValue - 10
  }
  public func read(_ id: MMCCallbackID) -> MMCCallback? {
    let bits = readBits(slotIndex(id))
    return bits == 0 ? nil : unsafeBitCast(bits, to: MMCCallback.self)
  }
  public func write(_ id: MMCCallbackID, value: MMCCallback?) {
    writeBits(slotIndex(id), value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
