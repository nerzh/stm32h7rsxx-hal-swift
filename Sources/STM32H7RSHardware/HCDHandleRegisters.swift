import STM32H7RSHAL
import _Volatile

public struct STM32HCDHandleRegisters: HCDHandleIO {
  private let words: UnsafeMutableBufferPointer<UInt32>
  private let configuration: UnsafeMutableBufferPointer<UInt8>
  private let channels: UnsafeMutableBufferPointer<UInt32>
  private let buffers: UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt8>?>
  // Caller-owned zeroed storage must outlive the driver and all interrupts.
  public init(
    words: UnsafeMutableBufferPointer<UInt32>, configuration: UnsafeMutableBufferPointer<UInt8>,
    channels: UnsafeMutableBufferPointer<UInt32>,
    buffers: UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt8>?>
  ) {
    precondition(
      words.count >= 3 && configuration.count >= 13 && channels.count >= 432 && buffers.count >= 16)
    self.words = words
    self.configuration = configuration
    self.channels = channels
    self.buffers = buffers
  }
  public func channel(_ index: UInt32) -> STM32USBHostChannelRegisters {
    precondition(index < 16)
    let start = Int(index) * 27
    return STM32USBHostChannelRegisters(
      storage: .init(rebasing: channels[start..<(start + 27)]),
      buffer: buffers.baseAddress! + Int(index))
  }
  public func read(_ word: HCDHandleWord) -> UInt32 {
    let address = UInt(bitPattern: words.baseAddress! + word.rawValue)
    return VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()
  }
  public func write(_ word: HCDHandleWord, value: UInt32) {
    let address = UInt(bitPattern: words.baseAddress! + word.rawValue)
    VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(value)
  }
  public func readConfiguration(_ field: USBConfigurationField) -> UInt8 {
    VolatileMappedRegister<UInt8>(
      unsafeBitPattern: UInt(bitPattern: configuration.baseAddress! + field.rawValue)
    ).load()
  }
  public func writeConfiguration(_ field: USBConfigurationField, value: UInt8) {
    VolatileMappedRegister<UInt8>(
      unsafeBitPattern: UInt(bitPattern: configuration.baseAddress! + field.rawValue)
    ).store(value)
  }
}
