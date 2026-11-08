import STM32H7RSHAL
import _Volatile

public struct STM32XSPIHandleRegisters: XSPIHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt

  // Caller-owned storage: 20 zeroed UInt32 slots and one zeroed UInt slot.
  // Keep both buffers alive across all foreground, IRQ and DMA calls.
  public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>)
  {
    precondition(words.count >= 20 && pointers.count >= 1)
    wordsAddress = UInt(bitPattern: words.baseAddress!)
    pointersAddress = UInt(bitPattern: pointers.baseAddress!)
    precondition(wordsAddress & 3 == 0)
    precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
  }
  private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
    .init(unsafeBitPattern: wordsAddress + UInt(index) * 4)
  }
  public func read(_ word: XSPIConfigurationWord) -> UInt32 { slot(word.rawValue).load() }
  public func write(_ word: XSPIConfigurationWord, value: UInt32) {
    slot(word.rawValue).store(value)
  }
  public func read(_ word: XSPIHandleWord) -> UInt32 { slot(15 + word.rawValue).load() }
  public func write(_ word: XSPIHandleWord, value: UInt32) {
    slot(15 + word.rawValue).store(value)
  }
  public func readBuffer() -> UnsafeMutablePointer<UInt8>? {
    let address = pointersAddress
    let bits: UInt
    if MemoryLayout<UInt>.size == 4 {
      bits = UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    } else {
      bits = UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
    }
    return UnsafeMutablePointer<UInt8>(bitPattern: bits)
  }
  public func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    let address = pointersAddress
    let bits = UInt(bitPattern: value)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
}
