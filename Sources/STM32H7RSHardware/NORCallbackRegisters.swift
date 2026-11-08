import STM32H7RSHAL
import _Volatile

public struct STM32NORCallbackRegisters: NORCallbackIO {
  private let storageAddress: UInt
  public let context: UnsafeMutableRawPointer?

  // Two native-width slots indexed by NORCallbackID.
  // Both function storage and the callback context are unowned.
  public init(storage: UnsafeMutableBufferPointer<UInt>, context: UnsafeMutableRawPointer? = nil) {
    precondition(storage.count >= 2)
    storageAddress = UInt(bitPattern: storage.baseAddress!)
    precondition(storageAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
    self.context = context
  }
  public func read(_ id: NORCallbackID) -> NORCallback? {
    let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
    let bits: UInt
    if MemoryLayout<UInt>.size == 4 {
      bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    } else {
      bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    return bits == 0 ? nil : unsafeBitCast(bits, to: NORCallback.self)
  }
  public func write(_ id: NORCallbackID, value: NORCallback?) {
    let address = storageAddress + UInt(id.rawValue) * UInt(MemoryLayout<UInt>.stride)
    let bits = value.map { unsafeBitCast($0, to: UInt.self) } ?? 0
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
}
