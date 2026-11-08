import STM32H7RSHAL
import _Volatile

public struct STM32SDIOCallbackRegisters: SDIOCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Fourteen initially zero native-width slots: five regular callbacks,
  // transceiver, identification, and seven IO functions. Storage is unowned.
  // The identification slot uses 1 for the driver's built-in operation.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 14)
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
  private func slotIndex(_ id: SDIOCallbackID) -> UInt32 {
    id.rawValue < 3 ? id.rawValue : id.rawValue - 13
  }
  public func read(_ id: SDIOCallbackID) -> SDIOCallback? {
    let bits = readBits(slotIndex(id))
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDIOCallback.self)
  }
  public func write(_ id: SDIOCallbackID, value: SDIOCallback?) {
    writeBits(slotIndex(id), value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readTransceiver() -> SDIOTransceiverCallback? {
    let bits = readBits(5)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDIOTransceiverCallback.self)
  }
  public func writeTransceiver(_ value: SDIOTransceiverCallback?) {
    writeBits(5, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  public func readIdentify() -> SDIOIdentifyOperation {
    let bits = readBits(6)
    if bits == 0 { return .none }
    if bits == 1 { return .initializeCard }
    return .custom(unsafeBitCast(bits, to: SDIOIdentifyCallback.self))
  }
  public func writeIdentify(_ value: SDIOIdentifyOperation) {
    switch value {
    case .none: writeBits(6, 0)
    case .initializeCard: writeBits(6, 1)
    case .custom(let callback):
      let bits = unsafeBitCast(callback, to: UInt.self)
      precondition(bits > 1)
      writeBits(6, bits)
    }
  }
  public func readIOFunction(_ index: UInt32) -> SDIOFunctionCallback? {
    precondition(index < 7)
    let bits = readBits(7 + index)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDIOFunctionCallback.self)
  }
  public func writeIOFunction(_ index: UInt32, value: SDIOFunctionCallback?) {
    precondition(index < 7)
    writeBits(7 + index, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
