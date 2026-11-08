import STM32H7RSHAL
import _Volatile

public struct STM32USBHostChannelRegisters: USBHostChannelIO {
  private let storage: UnsafeMutableBufferPointer<UInt32>
  private let buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>
  // Caller-owned zeroed storage must outlive the driver and USB interrupts.
  public init(
    storage: UnsafeMutableBufferPointer<UInt32>,
    buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>
  ) {
    precondition(storage.count >= 27)
    self.storage = storage
    self.buffer = buffer
  }
  public func read(_ field: USBHostChannelField) -> UInt32 {
    let address = UInt(bitPattern: storage.baseAddress! + field.rawValue)
    switch field {
    case .deviceAddress, .channelNumber, .endpointNumber, .endpointIsIn, .channelDirection, .speed,
      .doPing, .doStartSplit, .doCompleteSplit, .endpointStartSplitSchedule, .hubPortNumber,
      .hubAddress, .endpointType, .dataPID, .toggleIn, .toggleOut:
      return UInt32(VolatileMappedRegister<UInt8>(unsafeBitPattern: address).load())
    case .maximumPacketSize:
      return UInt32(VolatileMappedRegister<UInt16>(unsafeBitPattern: address).load())
    case .isochronousSplitTransactionPosition, .transferSize, .transferLength, .transferCount,
      .dmaAddress, .nakCount, .errorCount, .nyetErrorCount, .urbState, .state:
      return UInt32(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
  }
  public func write(_ field: USBHostChannelField, value: UInt32) {
    let address = UInt(bitPattern: storage.baseAddress! + field.rawValue)
    switch field {
    case .deviceAddress, .channelNumber, .endpointNumber, .endpointIsIn, .channelDirection, .speed,
      .doPing, .doStartSplit, .doCompleteSplit, .endpointStartSplitSchedule, .hubPortNumber,
      .hubAddress, .endpointType, .dataPID, .toggleIn, .toggleOut:
      VolatileMappedRegister<UInt8>(unsafeBitPattern: address).store(
        UInt8(truncatingIfNeeded: value))
    case .maximumPacketSize:
      VolatileMappedRegister<UInt16>(unsafeBitPattern: address).store(
        UInt16(truncatingIfNeeded: value))
    case .isochronousSplitTransactionPosition, .transferSize, .transferLength, .transferCount,
      .dmaAddress, .nakCount, .errorCount, .nyetErrorCount, .urbState, .state:
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
