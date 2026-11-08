import STM32H7RSHAL
import _Volatile

public struct STM32I3CCallbackRegisters: I3CCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Thirteen initially nil native-width callback slots in original HAL ID order.
  // Special callback signatures occupy slots 4, 7 and 8. Storage is unowned.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 13)
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
  public func read(_ id: I3CCallbackID) -> I3CCallback? {
    let bits = readBits(id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I3CCallback.self)
  }
  public func write(_ id: I3CCallbackID, value: I3CCallback?) {
    writeBits(id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readTargetRequestDynamicAddress() -> I3CDynamicAddressCallback? {
    let bits = readBits(4)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I3CDynamicAddressCallback.self)
  }
  public func writeTargetRequestDynamicAddress(_ value: I3CDynamicAddressCallback?) {
    writeBits(4, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readTargetHotJoin() -> I3CHotJoinCallback? {
    let bits = readBits(7)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I3CHotJoinCallback.self)
  }
  public func writeTargetHotJoin(_ value: I3CHotJoinCallback?) {
    writeBits(7, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readNotify() -> I3CNotifyCallback? {
    let bits = readBits(8)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I3CNotifyCallback.self)
  }
  public func writeNotify(_ value: I3CNotifyCallback?) {
    writeBits(8, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
