import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif

public struct STM32SDMMCRegisters: SDRegisterIO {
  public let instance: SDMMCInstance
  public init(_ instance: SDMMCInstance) { self.instance = instance }
  private var peripheral: SDMMC1 { instance == .sdmmc1 ? sdmmc1 : sdmmc2 }
  public func address(of register: SDMMCRegister) -> UInt32 {
    switch register {
    case .power: return UInt32(peripheral.power.unsafeAddress)
    case .clkcr: return UInt32(peripheral.clkcr.unsafeAddress)
    case .arg: return UInt32(peripheral.argr.unsafeAddress)
    case .cmd: return UInt32(peripheral.cmdr.unsafeAddress)
    case .respcmd: return UInt32(peripheral.respcmdr.unsafeAddress)
    case .resp1: return UInt32(peripheral.resp1r.unsafeAddress)
    case .resp2: return UInt32(peripheral.resp2r.unsafeAddress)
    case .resp3: return UInt32(peripheral.resp3r.unsafeAddress)
    case .resp4: return UInt32(peripheral.resp4r.unsafeAddress)
    case .dtimer: return UInt32(peripheral.dtimer.unsafeAddress)
    case .dlen: return UInt32(peripheral.dlenr.unsafeAddress)
    case .dctrl: return UInt32(peripheral.dctrl.unsafeAddress)
    case .dcount: return UInt32(peripheral.dcntr.unsafeAddress)
    case .sta: return UInt32(peripheral.star.unsafeAddress)
    case .icr: return UInt32(peripheral.icr.unsafeAddress)
    case .mask: return UInt32(peripheral.maskr.unsafeAddress)
    case .acktime: return UInt32(peripheral.acktimer.unsafeAddress)
    case .idmactrl: return UInt32(peripheral.idmactrlr.unsafeAddress)
    case .idmabsize: return UInt32(peripheral.idmabsizer.unsafeAddress)
    case .idmabaser: return UInt32(peripheral.idmabaser.unsafeAddress)
    case .idmalar: return UInt32(peripheral.idmalar.unsafeAddress)
    case .idmabar: return UInt32(peripheral.idmabar.unsafeAddress)
    case .fifo: return UInt32(peripheral.fifor[0].unsafeAddress)
    }
  }
  public var delayControlAddress: UInt32 {
    UInt32((instance == .sdmmc1 ? dlyb1 : dlyb2).cr.unsafeAddress)
  }
  public func read(_ register: SDMMCRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: SDMMCRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
  public func readDelayControl() -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(delayControlAddress)).load()
  }
  public func writeDelayControl(_ value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(delayControlAddress)).store(value)
  }
}
