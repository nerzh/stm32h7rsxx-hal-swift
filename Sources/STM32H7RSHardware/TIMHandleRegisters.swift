import STM32H7RSHAL
import _Volatile

public struct STM32TIMHandleRegisters: TIMHandleIO {
  private let storageAddress: UInt
  // Caller-owned 20 zeroed words, kept alive across foreground and interrupt calls.
  public init(words: UnsafeMutableBufferPointer<UInt32>) {
    precondition(words.count >= 20)
    storageAddress = UInt(bitPattern: words.baseAddress!)
    precondition(storageAddress & 3 == 0)
  }
  private func slot(_ index: Int) -> VolatileMappedRegister<UInt32> {
    .init(unsafeBitPattern: storageAddress + UInt(index) * 4)
  }
  public func read(_ word: TIMConfigurationWord) -> UInt32 { slot(word.rawValue).load() }
  public func write(_ word: TIMConfigurationWord, value: UInt32) {
    slot(word.rawValue).store(value)
  }
  public func read(_ word: TIMHandleWord) -> UInt32 { slot(6 + word.rawValue).load() }
  public func write(_ word: TIMHandleWord, value: UInt32) { slot(6 + word.rawValue).store(value) }
  public func readChannelState(_ index: Int, complementary: Bool) -> UInt32 {
    precondition(index >= 0 && index < (complementary ? 4 : 6))
    return slot((complementary ? 16 : 10) + index).load()
  }
  public func writeChannelState(_ index: Int, complementary: Bool, value: UInt32) {
    precondition(index >= 0 && index < (complementary ? 4 : 6))
    slot((complementary ? 16 : 10) + index).store(value)
  }
}
