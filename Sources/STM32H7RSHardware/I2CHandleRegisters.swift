import STM32H7RSHAL
import _Volatile

public struct STM32I2CHandleRegisters: I2CHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt

  // Caller-owned storage: 20 zeroed words and one zeroed native pointer.
  // Halfwords occupy the low 16 bits of slots 8 and 9; padding is untouched.
  // Keep both buffers alive across foreground, IRQ and DMA calls.
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
  public func read(_ word: I2CConfigurationWord) -> UInt32 { slot(word.rawValue).load() }
  public func write(_ word: I2CConfigurationWord, value: UInt32) {
    slot(word.rawValue).store(value)
  }
  public func read(_ word: I2CHandleHalfWord) -> UInt16 {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(8 + word.rawValue) * 4)
      .load()
  }
  public func write(_ word: I2CHandleHalfWord, value: UInt16) {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(8 + word.rawValue) * 4)
      .store(value)
  }
  public func read(_ word: I2CHandleWord) -> UInt32 { slot(10 + word.rawValue).load() }
  public func write(_ word: I2CHandleWord, value: UInt32) { slot(10 + word.rawValue).store(value) }
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
