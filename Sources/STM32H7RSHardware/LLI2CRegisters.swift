import STM32H7RSHAL

extension STM32I2CRegisters: LLBusRegisterIO {
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        var bus = STM32RCCRegisters()
        return bus.read(register)
    }
    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        var bus = STM32RCCRegisters()
        bus.write(register, value: value)
    }
}

extension STM32I3CRegisters: LLBusRegisterIO {
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        var bus = STM32RCCRegisters()
        return bus.read(register)
    }
    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        var bus = STM32RCCRegisters()
        bus.write(register, value: value)
    }
}
