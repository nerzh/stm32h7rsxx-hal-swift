import STM32H7RSHAL
import _Volatile

public struct STM32RCCSystem<TimeIO: HALTimeBaseIO>: RCCSystemIO {
    public let timeBase: HALTimeBase<TimeIO>
    private let clockAddress: UInt

    // The caller owns an aligned, long-lived SystemCoreClock word initialized
    // to the current CPU frequency (64 MHz after reset). Copies share this word
    // and the timebase storage. The SysTick ISR must hold its own timebase copy.
    public init(systemCoreClock: UnsafeMutablePointer<UInt32>, timeBase: HALTimeBase<TimeIO>) {
        clockAddress = UInt(bitPattern: systemCoreClock)
        precondition((clockAddress & 3) == 0)
        self.timeBase = timeBase
    }

    public func getTick() -> UInt32 { timeBase.getTick() }
    public func getTickPriority() -> UInt32 { timeBase.getTickPriority() }

    public func getSystemCoreClock() -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: clockAddress).load()
    }

    public func setSystemCoreClock(_ frequency: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: clockAddress).store(frequency)
    }

    public func initializeTick(priority: UInt32, coreClockHz: UInt32) -> HALStatus {
        timeBase.initializeTick(priority: priority, coreClockHz: coreClockHz)
    }
}
