import STM32H7RSHAL
import _Volatile

public struct STM32SDIOHandleRegisters: SDIOHandleIO {
  private let wordsAddress: UInt
  private let pointersAddress: UInt

  // Caller-owned storage: 18 zeroed words and two zeroed native pointers.
  // Keep the storage alive across foreground and interrupt calls.
  public init(words: UnsafeMutableBufferPointer<UInt32>, pointers: UnsafeMutableBufferPointer<UInt>)
  {
    precondition(words.count >= 18 && pointers.count >= 2)
    wordsAddress = UInt(bitPattern: words.baseAddress!)
    pointersAddress = UInt(bitPattern: pointers.baseAddress!)
    precondition(wordsAddress & 3 == 0)
    precondition(pointersAddress % UInt(MemoryLayout<UInt>.alignment) == 0)
  }
  private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
    .init(unsafeBitPattern: wordsAddress + UInt(index) * 4)
  }
  public func read(_ word: SDIOConfigurationWord) -> UInt32 { slot(0 + word.rawValue).load() }
  public func write(_ word: SDIOConfigurationWord, value: UInt32) {
    slot(0 + word.rawValue).store(value)
  }
  public func read(_ word: SDIOHandleWord) -> UInt32 { slot(6 + word.rawValue).load() }
  public func write(_ word: SDIOHandleWord, value: UInt32) { slot(6 + word.rawValue).store(value) }
  public func read(_ field: SDIOHandleHalfWord) -> UInt16 {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(15 + field.rawValue) * 4)
      .load()
  }
  public func write(_ field: SDIOHandleHalfWord, value: UInt16) {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: wordsAddress + UInt(15 + field.rawValue) * 4)
      .store(value)
  }
  public func read(_ field: SDIOHandleByte) -> UInt8 {
    VolatileMappedRegister<UInt8>(unsafeBitPattern: wordsAddress + UInt(16 + field.rawValue) * 4)
      .load()
  }
  public func write(_ field: SDIOHandleByte, value: UInt8) {
    VolatileMappedRegister<UInt8>(unsafeBitPattern: wordsAddress + UInt(16 + field.rawValue) * 4)
      .store(value)
  }
  private func readPointer(_ index: Int) -> UInt {
    let address = pointersAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
    if MemoryLayout<UInt>.size == 4 {
      return UInt(VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load())
    }
    return UInt(VolatileMappedRegister<UInt64>(unsafeBitPattern: address).load())
  }
  private func writePointer(_ index: Int, _ bits: UInt) {
    let address = pointersAddress + UInt(index) * UInt(MemoryLayout<UInt>.stride)
    if MemoryLayout<UInt>.size == 4 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: address).store(UInt32(bits))
    } else {
      VolatileMappedRegister<UInt64>(unsafeBitPattern: address).store(UInt64(bits))
    }
  }
  public func readTransmitBuffer() -> UnsafeMutablePointer<UInt8>? {
    .init(bitPattern: readPointer(0))
  }
  public func writeTransmitBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    writePointer(0, UInt(bitPattern: value))
  }
  public func readReceiveBuffer() -> UnsafeMutablePointer<UInt8>? {
    .init(bitPattern: readPointer(1))
  }
  public func writeReceiveBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    writePointer(1, UInt(bitPattern: value))
  }
}
