import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif

public struct STM32FMCRegisters: FMCRegisterIO {
  public init() {}
  public func address(of register: FMCRegister) -> UInt32 {
    let offset: UInt32
    switch register {
    case .btcr(let index):
      precondition(index < 8)
      offset = index * 4
    case .bwtr(let index):
      precondition(index < 7)
      offset = 0x104 + index * 4
    case .pcr: offset = 0x80
    case .sr: offset = 0x84
    case .pmem: offset = 0x88
    case .patt: offset = 0x8C
    case .eccr: offset = 0x94
    case .sdcr(let index):
      precondition(index < 2)
      offset = 0x140 + index * 4
    case .sdtr(let index):
      precondition(index < 2)
      offset = 0x148 + index * 4
    case .sdcmr: offset = 0x150
    case .sdrtr: offset = 0x154
    case .sdsr: offset = 0x158
    }
    return UInt32(fmc.unsafeAddress) &+ offset
  }
  public func read(_ register: FMCRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: FMCRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
}

public typealias STM32FMCMemory = STM32FlashMemory
