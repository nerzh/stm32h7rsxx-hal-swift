import MMIO
import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif
public enum USBInstance: Sendable { case fullSpeed, highSpeed }
public struct STM32USBRegisters: USBRegisterIO {
  public let instance: USBInstance
  public init(_ instance: USBInstance) { self.instance = instance }
  public var isHighSpeedInstance: Bool { instance == .highSpeed }
  public func address(of register: USBRegister) -> UInt32 {
    UInt32(instance == .highSpeed ? otg_hs.unsafeAddress : otg_fs.unsafeAddress)
      &+ register.rawValue
  }
  public func read(_ register: USBRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: USBRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
  public func delayAfterAHBIdle() {
    // Preserve USB_CoreReset's ten volatile countdown iterations.
    var count: UInt32 = 10
    withUnsafeMutablePointer(to: &count) { pointer in
      let counter = VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(bitPattern: pointer))
      while counter.load() > 0 { counter.store(counter.load() &- 1) }
    }
  }
}
