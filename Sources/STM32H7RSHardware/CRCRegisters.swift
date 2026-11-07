import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32CRCRegisters: CRCRegisterIO {
    public init() {}

    public mutating func read(_ register: CRCRegister) -> UInt32 {
        switch register {
        case .dr: return crc.dr.read().raw.storage
        case .idr: return crc.idr.read().raw.storage
        case .cr: return crc.cr.read().raw.storage
        case .initialValue: return crc.`init`.read().raw.storage
        case .polynomial: return crc.pol.read().raw.storage
        }
    }

    public mutating func write(_ register: CRCRegister, value: UInt32) {
        switch register {
        case .dr: crc.dr.write { $0.raw.storage = value }
        case .idr: crc.idr.write { $0.raw.storage = value }
        case .cr: crc.cr.write { $0.raw.storage = value }
        case .initialValue: crc.`init`.write { $0.raw.storage = value }
        case .polynomial: crc.pol.write { $0.raw.storage = value }
        }
    }

    // CRC consumes all bits of each bus transaction: a zero-extended UInt32
    // store would feed extra bytes. Both narrow stores target the DR base address.
    public mutating func writeData8(_ value: UInt8) {
        crc.dr8.write { $0.raw.storage = value }
    }

    public mutating func writeData16(_ value: UInt16) {
        crc.dr16.write { $0.raw.storage = value }
    }
}

public extension STM32H7RSHAL.CRC where IO == STM32CRCRegisters {
    init(configuration: CRCConfiguration = .init(), inputDataFormat: CRCInputDataFormat = .undefined) {
        self.init(registers: STM32CRCRegisters(), configuration: configuration, inputDataFormat: inputDataFormat)
    }
}
