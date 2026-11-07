import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32GPIORegisters: GPIORegisterIO {
    private let gpio: GPIOA

    public init(port: GPIOPort) {
        let address: UInt
        switch port {
        case .a: address = gpioa.unsafeAddress
        case .b: address = gpiob.unsafeAddress
        case .c: address = gpioc.unsafeAddress
        case .d: address = gpiod.unsafeAddress
        case .e: address = gpioe.unsafeAddress
        case .f: address = gpiof.unsafeAddress
        case .g: address = gpiog.unsafeAddress
        case .h: address = gpioh.unsafeAddress
        case .m: address = gpiom.unsafeAddress
        case .n: address = gpion.unsafeAddress
        case .o: address = gpioo.unsafeAddress
        case .p: address = gpiop.unsafeAddress
        }
        // All GPIO ports share the CMSIS GPIO_TypeDef register layout.
        // Use the device library's addresses and volatile register accesses.
        gpio = GPIOA(unsafeAddress: address)
    }

    public mutating func read(_ register: GPIORegister) -> UInt32 {
        switch register {
        case .moder: return gpio.moder.read().raw.storage
        case .otyper: return gpio.otyper.read().raw.storage
        case .ospeedr: return gpio.ospeedr.read().raw.storage
        case .pupdr: return gpio.pupdr.read().raw.storage
        case .idr: return gpio.idr.read().raw.storage
        case .odr: return gpio.odr.read().raw.storage
        case .lckr: return gpio.lckr.read().raw.storage
        case .bsrr, .brr:
            preconditionFailure("GPIO set/reset registers are write-only")
        case .alternateFunction(let index):
            precondition(index == 0 || index == 1)
            return index == 0 ? gpio.afrl.read().raw.storage : gpio.afrh.read().raw.storage
        case .extiConfiguration(let index): return SBSGPIOSelection.read(index)
        case .extiRisingTrigger: return CMSISEXTI.rtsr1.read().raw.storage
        case .extiFallingTrigger: return CMSISEXTI.ftsr1.read().raw.storage
        case .extiEventMask: return CMSISEXTI.emr1.read().raw.storage
        case .extiInterruptMask: return CMSISEXTI.imr1.read().raw.storage
        case .extiPending: return CMSISEXTI.pr1.read().raw.storage
        case .extiSoftwareInterrupt: return CMSISEXTI.swier1.read().raw.storage
        }
    }

    public mutating func write(_ register: GPIORegister, value: UInt32) {
        switch register {
        case .moder: gpio.moder.write { $0.raw.storage = value }
        case .otyper: gpio.otyper.write { $0.raw.storage = value }
        case .ospeedr: gpio.ospeedr.write { $0.raw.storage = value }
        case .pupdr: gpio.pupdr.write { $0.raw.storage = value }
        case .idr: preconditionFailure("GPIO input register is read-only")
        case .odr: gpio.odr.write { $0.raw.storage = value }
        case .bsrr: gpio.bsrr.write { $0.raw.storage = value }
        case .brr: gpio.brr.write { $0.raw.storage = value }
        case .lckr: gpio.lckr.write { $0.raw.storage = value }
        case .alternateFunction(let index):
            precondition(index == 0 || index == 1)
            if index == 0 {
                gpio.afrl.write { $0.raw.storage = value }
            } else {
                gpio.afrh.write { $0.raw.storage = value }
            }
        case .extiConfiguration(let index): SBSGPIOSelection.write(index, value: value)
        case .extiRisingTrigger: CMSISEXTI.rtsr1.write { $0.raw.storage = value }
        case .extiFallingTrigger: CMSISEXTI.ftsr1.write { $0.raw.storage = value }
        case .extiEventMask: CMSISEXTI.emr1.write { $0.raw.storage = value }
        case .extiInterruptMask: CMSISEXTI.imr1.write { $0.raw.storage = value }
        case .extiPending: CMSISEXTI.pr1.write { $0.raw.storage = value }
        case .extiSoftwareInterrupt: CMSISEXTI.swier1.write { $0.raw.storage = value }
        }
    }
}

enum SBSGPIOSelection {
    static func read(_ index: Int) -> UInt32 {
        switch index {
        case 0: return sbs.exticr1.read().raw.storage
        case 1: return sbs.exticr2.read().raw.storage
        case 2: return sbs.exticr3.read().raw.storage
        case 3: return sbs.exticr4.read().raw.storage
        default: preconditionFailure("Invalid SBS EXTI register index")
        }
    }

    static func write(_ index: Int, value: UInt32) {
        // The SVD marks these fields read-only, but STM32 HAL writes EXTICR.
        // Raw storage preserves the upstream full-word write without an extra read.
        switch index {
        case 0: sbs.exticr1.write { $0.raw.storage = value }
        case 1: sbs.exticr2.write { $0.raw.storage = value }
        case 2: sbs.exticr3.write { $0.raw.storage = value }
        case 3: sbs.exticr4.write { $0.raw.storage = value }
        default: preconditionFailure("Invalid SBS EXTI register index")
        }
    }
}

public extension GPIO where IO == STM32GPIORegisters {
    init(port: GPIOPort) {
        self.init(registers: STM32GPIORegisters(port: port), port: port)
    }
}
