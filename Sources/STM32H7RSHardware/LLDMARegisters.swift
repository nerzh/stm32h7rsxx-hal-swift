import STM32H7RSHAL

public struct STM32LLDMARegisters: LLDMARegisterIO {
    public let controller: DMAController
    public init(controller: DMAController) { self.controller = controller }
    private func channelRegisters(_ channel: UInt32) -> STM32DMARegisters {
        precondition(channel < 16)
        return STM32DMARegisters(channel: .init(controller: controller, index: Int(channel)))
    }
    public func read(_ register: DMARegister, channel: UInt32) -> UInt32 {
        channelRegisters(channel).read(register)
    }
    public func write(_ register: DMARegister, channel: UInt32, value: UInt32) {
        channelRegisters(channel).write(register, value: value)
    }
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        var bus = STM32RCCRegisters()
        return bus.read(register)
    }
    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        var bus = STM32RCCRegisters()
        bus.write(register, value: value)
    }
}
