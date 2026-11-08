import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif

public enum I2CInstance: UInt32, CaseIterable {
  case i2c1 = 0x4000_5400
  case i2c2 = 0x4000_5800
  case i2c3 = 0x4000_5C00
}
public struct STM32I2CRegisters: I2CRegisterIO {
  public let instance: I2CInstance
  public init(_ instance: I2CInstance) { self.instance = instance }
  private var peripheral: I2C1_I3C1 {
    switch instance {
    case .i2c1: return i2c1_i3c1
    case .i2c2: return i2c2
    case .i2c3: return i2c3
    }
  }
  public func address(of register: I2CRegister) -> UInt32 {
    switch register {
    case .cr1: return UInt32(peripheral.cr1.unsafeAddress)
    case .cr2: return UInt32(peripheral.cr2.unsafeAddress)
    case .oar1: return UInt32(peripheral.oar1.unsafeAddress)
    case .oar2: return UInt32(peripheral.oar2.unsafeAddress)
    case .timingr: return UInt32(peripheral.timingr.unsafeAddress)
    case .timeoutr: return UInt32(peripheral.timeoutr.unsafeAddress)
    case .isr: return UInt32(peripheral.isr.unsafeAddress)
    case .icr: return UInt32(peripheral.icr.unsafeAddress)
    case .pecr: return UInt32(peripheral.pecr.unsafeAddress)
    case .rxdr: return UInt32(peripheral.rxdr.unsafeAddress)
    case .txdr: return UInt32(peripheral.txdr.unsafeAddress)
    }
  }
  public func read(_ register: I2CRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: I2CRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
}
