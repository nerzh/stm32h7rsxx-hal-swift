import STM32H7RSHAL
import _Volatile

public struct STM32USBEndpointRegisters: USBEndpointIO {
  private let storage: UnsafeMutableBufferPointer<UInt32>
  private let buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>
  // Caller-owned zeroed storage must outlive the driver and USB interrupts.
  public init(
    storage: UnsafeMutableBufferPointer<UInt32>,
    buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>
  ) {
    precondition(storage.count >= 13)
    self.storage = storage
    self.buffer = buffer
  }
  public func read(_ field: USBEndpointField) -> UInt32 {
    let address = UInt(bitPattern: storage.baseAddress! + field.rawValue)
    switch field {
    case .number, .isIn, .isStall, .isIsochronousIncomplete, .type, .dataPIDStart, .evenOddFrame:
      return UInt32(VolatileMappedRegister<UInt8>(unsafeBitPattern: address).load())
    case .transmitFIFONumber:
      return UInt32(VolatileMappedRegister<UInt16>(unsafeBitPattern: address).load())
    case .maximumPacketSize, .transferLength, .transferCount, .dmaAddress, .transferSize:
      return UInt32(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
  }
  public func write(_ field: USBEndpointField, value: UInt32) {
    let address = UInt(bitPattern: storage.baseAddress! + field.rawValue)
    switch field {
    case .number, .isIn, .isStall, .isIsochronousIncomplete, .type, .dataPIDStart, .evenOddFrame:
      VolatileMappedRegister<UInt8>(unsafeBitPattern: address).store(
        UInt8(truncatingIfNeeded: value))
    case .transmitFIFONumber:
      VolatileMappedRegister<UInt16>(unsafeBitPattern: address).store(
        UInt16(truncatingIfNeeded: value))
    case .maximumPacketSize, .transferLength, .transferCount, .dmaAddress, .transferSize:
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(
        UInt32(truncatingIfNeeded: value))
    }
  }
  public func readBuffer() -> UnsafeMutablePointer<UInt8>? {
    let address = UInt(bitPattern: buffer)
    let value: UInt
    if MemoryLayout<UInt>.size == 4 {
      value = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    } else {
      value = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    return UnsafeMutablePointer<UInt8>(bitPattern: value)
  }
  public func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    let address = UInt(bitPattern: buffer)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(
        UInt32(UInt(bitPattern: value)))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(
        UInt64(UInt(bitPattern: value)))
    }
  }
}
