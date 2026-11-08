import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif
public struct STM32SAIRegisters: SAIRegisterIO {
  public let instance: SAIInstance
  public init(_ instance: SAIInstance) { self.instance = instance }
  private var peripheral: SAI1 {
    switch instance {
    case .sai1A, .sai1B: return sai1
    case .sai2A, .sai2B: return sai2
    }
  }
  public func address(of register: SAIRegister) -> UInt32 {
    switch instance {
    case .sai1A, .sai2A:
      switch register {
      case .cr1: return UInt32(peripheral.acr1.unsafeAddress)
      case .cr2: return UInt32(peripheral.acr2.unsafeAddress)
      case .frcr: return UInt32(peripheral.afrcr.unsafeAddress)
      case .slotr: return UInt32(peripheral.aslotr.unsafeAddress)
      case .imr: return UInt32(peripheral.aim.unsafeAddress)
      case .sr: return UInt32(peripheral.asr.unsafeAddress)
      case .clrfr: return UInt32(peripheral.aclrfr.unsafeAddress)
      case .dr: return UInt32(peripheral.adr.unsafeAddress)
      }
    case .sai1B, .sai2B:
      switch register {
      case .cr1: return UInt32(peripheral.bcr1.unsafeAddress)
      case .cr2: return UInt32(peripheral.bcr2.unsafeAddress)
      case .frcr: return UInt32(peripheral.bfrcr.unsafeAddress)
      case .slotr: return UInt32(peripheral.bslotr.unsafeAddress)
      case .imr: return UInt32(peripheral.bim.unsafeAddress)
      case .sr: return UInt32(peripheral.bsr.unsafeAddress)
      case .clrfr: return UInt32(peripheral.bclrfr.unsafeAddress)
      case .dr: return UInt32(peripheral.bdr.unsafeAddress)
      }
    }
  }
  public func address(of register: SAIGlobalRegister, peripheral: SAIPeripheral) -> UInt32 {
    let device: SAI1 = peripheral == .sai1 ? sai1 : sai2
    switch register {
    case .gcr: return UInt32(device.gcr.unsafeAddress)
    case .pdmcr: return UInt32(device.pdmcr.unsafeAddress)
    case .pdmdly: return UInt32(device.pdmdly.unsafeAddress)
    }
  }
  public func readGlobal(_ peripheral: SAIPeripheral, _ register: SAIGlobalRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(
      unsafeBitPattern: UInt(address(of: register, peripheral: peripheral))
    ).load()
  }
  public func writeGlobal(_ peripheral: SAIPeripheral, _ register: SAIGlobalRegister, value: UInt32)
  {
    VolatileMappedRegister<UInt32>(
      unsafeBitPattern: UInt(address(of: register, peripheral: peripheral))
    ).store(value)
  }
  public func read(_ register: SAIRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: SAIRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
}
