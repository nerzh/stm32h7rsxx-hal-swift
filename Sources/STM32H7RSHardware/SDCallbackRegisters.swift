import STM32H7RSHAL
import _Volatile

public struct STM32SDCallbackRegisters: SDCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Nine initially nil native-width slots: eight SDCallbackID functions,
  // followed by the transceiver callback. Storage is unowned.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 9)
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
  private func slotIndex(_ id: SDCallbackID) -> UInt32 {
    id.rawValue < 6 ? id.rawValue : id.rawValue - 10
  }
  public func read(_ id: SDCallbackID) -> SDCallback? {
    let bits = readBits(slotIndex(id))
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDCallback.self)
  }
  public func write(_ id: SDCallbackID, value: SDCallback?) {
    writeBits(slotIndex(id), value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readTransceiver() -> SDTransceiverCallback? {
    let bits = readBits(8)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDTransceiverCallback.self)
  }
  public func writeTransceiver(_ value: SDTransceiverCallback?) {
    writeBits(8, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
