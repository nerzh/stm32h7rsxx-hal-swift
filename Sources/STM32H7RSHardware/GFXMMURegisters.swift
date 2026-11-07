import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// Only STM32H7R7/H7S7 contain GFXMMU (DS14359, table 2). The family SVD
// and even the H7S3 CMSIS header describe this block; that is not availability
// evidence for an H7R3/H7S3 device.
public struct STM32GFXMMURegisters: GFXMMURegisterIO {
    public init() {}
    public func read(_ register: GFXMMURegister) -> UInt32 {
        switch register {
        case .cr: return gfxmmu.cr.read().raw.storage
        case .sr: return gfxmmu.sr.read().raw.storage
        case .dvr: return gfxmmu.dvr.read().raw.storage
        case .dar: return gfxmmu.dar.read().raw.storage
        case .b0cr: return gfxmmu.b0cr.read().raw.storage
        case .b1cr: return gfxmmu.b1cr.read().raw.storage
        case .b2cr: return gfxmmu.b2cr.read().raw.storage
        case .b3cr: return gfxmmu.b3cr.read().raw.storage
        case .lut(let index):
            precondition((0..<2048).contains(index))
            return index & 1 == 0 ? gfxmmu.lut[index / 2].lutl.read().raw.storage
                                 : gfxmmu.lut[index / 2].luth.read().raw.storage
        case .fcr: preconditionFailure("GFXMMU flag clear register is write-only")
        }
    }
    public func write(_ register: GFXMMURegister, value: UInt32) {
        switch register {
        case .cr: gfxmmu.cr.write { $0.raw.storage = value }
        case .fcr: gfxmmu.fcr.write { $0.raw.storage = value }
        case .dvr: gfxmmu.dvr.write { $0.raw.storage = value }
        case .dar: gfxmmu.dar.write { $0.raw.storage = value }
        case .b0cr: gfxmmu.b0cr.write { $0.raw.storage = value }
        case .b1cr: gfxmmu.b1cr.write { $0.raw.storage = value }
        case .b2cr: gfxmmu.b2cr.write { $0.raw.storage = value }
        case .b3cr: gfxmmu.b3cr.write { $0.raw.storage = value }
        case .lut(let index):
            precondition((0..<2048).contains(index))
            if index & 1 == 0 { gfxmmu.lut[index / 2].lutl.write { $0.raw.storage = value } }
            else { gfxmmu.lut[index / 2].luth.write { $0.raw.storage = value } }
        case .sr: preconditionFailure("GFXMMU status register is read-only")
        }
    }
    public func address(of register: GFXMMURegister) -> UInt32 {
        switch register {
        case .cr: return UInt32(gfxmmu.cr.unsafeAddress)
        case .sr: return UInt32(gfxmmu.sr.unsafeAddress)
        case .fcr: return UInt32(gfxmmu.fcr.unsafeAddress)
        case .dvr: return UInt32(gfxmmu.dvr.unsafeAddress)
        case .dar: return UInt32(gfxmmu.dar.unsafeAddress)
        case .b0cr: return UInt32(gfxmmu.b0cr.unsafeAddress)
        case .b1cr: return UInt32(gfxmmu.b1cr.unsafeAddress)
        case .b2cr: return UInt32(gfxmmu.b2cr.unsafeAddress)
        case .b3cr: return UInt32(gfxmmu.b3cr.unsafeAddress)
        case .lut(let index):
            precondition((0..<2048).contains(index))
            return UInt32(index & 1 == 0 ? gfxmmu.lut[index / 2].lutl.unsafeAddress
                                        : gfxmmu.lut[index / 2].luth.unsafeAddress)
        }
    }
}

// Reuse the existing volatile memory and exact CMSIS interrupt-mask operations.
extension STM32FlashMemory: GFXMMUMemoryIO {}

public extension STM32H7RSHAL.GFXMMU where Registers == STM32GFXMMURegisters, Memory == STM32FlashMemory {
    init(handle: Handle, callbacks: Callbacks, defaults: GFXMMUCallbackDefaults = .init(),
         useRegisteredCallbacks: Bool = false) {
        self.init(registers: STM32GFXMMURegisters(), handle: handle, callbacks: callbacks,
                  memory: STM32FlashMemory(), defaults: defaults, useRegisteredCallbacks: useRegisteredCallbacks)
    }
}
