import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif
public struct STM32I2SRegisters: I2SRegisterIO {
  public let instance: I2SInstance
  public init(_ instance: I2SInstance) { self.instance = instance }
  private var peripheral: SPI1 {
    switch instance {
    case .spi1: return spi1
    case .spi2: return spi2
    case .spi3: return spi3
    case .spi6: return spi6
    }
  }
  public func address(of register: I2SRegister) -> UInt32 {
    switch register {
    case .cr1: return UInt32(peripheral.cr1.unsafeAddress)
    case .cr2: return UInt32(peripheral.cr2.unsafeAddress)
    case .cfg1: return UInt32(peripheral.cfg1.unsafeAddress)
    case .cfg2: return UInt32(peripheral.cfg2.unsafeAddress)
    case .ier: return UInt32(peripheral.ier.unsafeAddress)
    case .sr: return UInt32(peripheral.sr.unsafeAddress)
    case .ifcr: return UInt32(peripheral.ifcr.unsafeAddress)
    case .txdr: return UInt32(peripheral.txdr.unsafeAddress)
    case .rxdr: return UInt32(peripheral.rxdr.unsafeAddress)
    case .crcpoly: return UInt32(peripheral.crcpoly.unsafeAddress)
    case .txcrc: return UInt32(peripheral.txcrc.unsafeAddress)
    case .rxcrc: return UInt32(peripheral.rxcrc.unsafeAddress)
    case .udrdr: return UInt32(peripheral.udrdr.unsafeAddress)
    case .i2scfgr: return UInt32(peripheral.i2scfgr.unsafeAddress)
    }
  }
  public func read(_ register: I2SRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: I2SRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
  public func read16(_ register: I2SRegister) -> UInt16 {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write16(_ register: I2SRegister, value: UInt16) {
    VolatileMappedRegister<UInt16>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
}
