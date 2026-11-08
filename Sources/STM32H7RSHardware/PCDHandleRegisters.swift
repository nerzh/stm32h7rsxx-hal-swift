import STM32H7RSHAL
import _Volatile

public struct STM32PCDHandleRegisters: PCDHandleIO {
  private let words: UnsafeMutableBufferPointer<UInt32>
  private let configuration: UnsafeMutableBufferPointer<UInt8>
  private let input: UnsafeMutableBufferPointer<UInt32>
  private let output: UnsafeMutableBufferPointer<UInt32>
  private let inputBuffers: UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt8>?>
  private let outputBuffers: UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt8>?>
  private let setup: UnsafeMutableBufferPointer<UInt32>
  // Caller-owned zeroed storage must outlive the driver and all interrupts.
  public init(
    words: UnsafeMutableBufferPointer<UInt32>, configuration: UnsafeMutableBufferPointer<UInt8>,
    inEndpoints: UnsafeMutableBufferPointer<UInt32>,
    outEndpoints: UnsafeMutableBufferPointer<UInt32>,
    inBuffers: UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt8>?>,
    outBuffers: UnsafeMutableBufferPointer<UnsafeMutablePointer<UInt8>?>,
    setup: UnsafeMutableBufferPointer<UInt32>
  ) {
    precondition(
      words.count >= 9 && configuration.count >= 13 && inEndpoints.count >= 208
        && outEndpoints.count >= 208 && inBuffers.count >= 16 && outBuffers.count >= 16
        && setup.count >= 12)
    self.words = words
    self.configuration = configuration
    input = inEndpoints
    output = outEndpoints
    inputBuffers = inBuffers
    outputBuffers = outBuffers
    self.setup = setup
  }
  public func endpoint(_ index: UInt32, isIn: Bool) -> STM32USBEndpointRegisters {
    precondition(index < 16)
    let storage = isIn ? input : output
    let buffers = isIn ? inputBuffers : outputBuffers
    let start = Int(index) * 13
    return STM32USBEndpointRegisters(
      storage: .init(rebasing: storage[start..<(start + 13)]),
      buffer: buffers.baseAddress! + Int(index))
  }
  public func setupBuffer() -> UnsafeMutablePointer<UInt8> {
    UnsafeMutableRawPointer(setup.baseAddress!).assumingMemoryBound(to: UInt8.self)
  }
  public func read(_ word: PCDHandleWord) -> UInt32 {
    let address = UInt(bitPattern: words.baseAddress! + word.rawValue)
    if word == .address {
      return UInt32(VolatileMappedRegister<UInt8>(unsafeBitPattern: address).load())
    }
    return VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()
  }
  public func write(_ word: PCDHandleWord, value: UInt32) {
    let address = UInt(bitPattern: words.baseAddress! + word.rawValue)
    if word == .address {
      VolatileMappedRegister<UInt8>(unsafeBitPattern: address).store(
        UInt8(truncatingIfNeeded: value))
      return
    }
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
