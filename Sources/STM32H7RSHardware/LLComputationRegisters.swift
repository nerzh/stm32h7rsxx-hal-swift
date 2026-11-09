import STM32H7RSHAL

extension STM32CRCRegisters: LLBusRegisterIO {
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        var bus = STM32RCCRegisters()
        return bus.read(register)
    }
    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        var bus = STM32RCCRegisters()
        bus.write(register, value: value)
    }
}

extension STM32CORDICRegisters: LLBusRegisterIO {
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        var bus = STM32RCCRegisters()
        return bus.read(register)
    }
    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        var bus = STM32RCCRegisters()
        bus.write(register, value: value)
    }
}

extension STM32RNGRegisters: LLBusRegisterIO {
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        var bus = STM32RCCRegisters()
        return bus.read(register)
    }
    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        var bus = STM32RCCRegisters()
        bus.write(register, value: value)
    }
}

extension STM32PKARegisters: LLBusRegisterIO {
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        var bus = STM32RCCRegisters()
        return bus.read(register)
    }
    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        var bus = STM32RCCRegisters()
        bus.write(register, value: value)
    }
}
