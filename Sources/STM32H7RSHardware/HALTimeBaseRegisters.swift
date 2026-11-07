import STM32H7RSHAL
import _Volatile

public struct STM32HALTimeBaseRegisters: HALTimeBaseIO {
    private let storageAddress: UInt

    // Supply three word-aligned, long-lived words initially containing [0, 16, 1]
    // (uwTick, uwTickPrio, uwTickFreq). The caller owns storage and must keep it
    // alive for both foreground code and the SysTick handler. Copies share state.
    public init(storage: UnsafeMutableBufferPointer<UInt32>) {
        precondition(storage.count >= 3)
        storageAddress = UInt(bitPattern: storage.baseAddress!)
        precondition((storageAddress & 3) == 0)
    }

    public func read(_ word: HALTimeBaseWord) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).load()
    }

    public func write(_ word: HALTimeBaseWord, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: storageAddress + UInt(word.rawValue) * 4).store(value)
    }

    public func configureSysTick(ticks: UInt32) -> UInt32 {
        var cortex = Cortex(registers: STM32CortexRegisters())
        return cortex.configureSysTick(ticks: ticks)
    }

    public func setSysTickPriority(_ priority: UInt32) {
        var cortex = Cortex(registers: STM32CortexRegisters())
        cortex.setPriority(irq: -1, preemptPriority: priority, subpriority: 0)
    }

    public func readSysTickControl() -> UInt32 {
        var registers = STM32CortexRegisters()
        return registers.read(.sysTickControl)
    }

    public func writeSysTickControl(_ value: UInt32) {
        var registers = STM32CortexRegisters()
        registers.write(.sysTickControl, value: value)
    }
}
