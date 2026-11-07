import CCortexHALSupport
import CCortexMCore
import CortexMCore
import STM32H7RSHAL
import _Volatile

public struct STM32FlashMemory: FlashMemoryIO {
    public init() {}

    public func read8(at address: UInt32) -> UInt8 {
        VolatileMappedRegister<UInt8>(unsafeBitPattern: UInt(address)).load()
    }
    public func read16(at address: UInt32) -> UInt16 {
        precondition(address & 1 == 0)
        return VolatileMappedRegister<UInt16>(unsafeBitPattern: UInt(address)).load()
    }
    public func read32(at address: UInt32) -> UInt32 { STM32DMAMemory().read32(at: address) }
    public func write8(at address: UInt32, value: UInt8) {
        VolatileMappedRegister<UInt8>(unsafeBitPattern: UInt(address)).store(value)
    }
    public func write16(at address: UInt32, value: UInt16) {
        precondition(address & 1 == 0)
        VolatileMappedRegister<UInt16>(unsafeBitPattern: UInt(address)).store(value)
    }
    public func write32(at address: UInt32, value: UInt32) { STM32DMAMemory().write32(at: address, value: value) }

    public func getPRIMASK() -> UInt32 {
        #if arch(arm)
        return cortex_m_primask()
        #else
        preconditionFailure("PRIMASK is a Cortex-M register")
        #endif
    }
    public func disableIRQ() {
        #if arch(arm)
        CortexMCore.disableInterrupts()
        #else
        preconditionFailure("Cortex-M interrupt masking requires an ARM target")
        #endif
    }
    // CMSIS writes the saved PRIMASK value, including when its low bit is one.
    public func setPRIMASK(_ value: UInt32) { hal_cortex_set_primask(value) }
    public func instructionSynchronizationBarrier() { CortexMCore.instructionSynchronizationBarrier() }
    public func dataSynchronizationBarrier() { CortexMCore.dataSynchronizationBarrier() }
}
