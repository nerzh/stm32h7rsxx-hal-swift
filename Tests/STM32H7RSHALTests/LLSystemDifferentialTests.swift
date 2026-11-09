import XCTest
import STM32H7RSHAL
import CLLReference

private struct LLSystemAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}

private final class LLSystemImage: LLCortexRegisterIO, SBSRegisterIO, LLDebugRegisterIO, VREFBUFRegisterIO, FlashRegisterIO, PowerExtendedRegisterIO {
    var cells: [UInt32]
    var trace: [LLSystemAccess] = []
    var reads: UInt32 = 0
    let salt: UInt32
    init(seed: UInt32, salt: UInt32) {
        cells = (0..<2048).map { seed ^ (UInt32($0) &* 0x9E3779B9) }
        self.salt = salt
    }
    func readIndex(_ index: Int) -> UInt32 {
        let value = cells[index] ^ (salt &* reads)
        reads &+= 1
        trace.append(.init(index: UInt32(index), value: value, kind: 0))
        return value
    }
    func writeIndex(_ index: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(index), value: value, kind: 1))
        cells[index] = value
    }
    func readPriority(_ register: CortexPriorityRegister) -> UInt8 { preconditionFailure("Not used") }
    func writePriority(_ register: CortexPriorityRegister, value: UInt8) { preconditionFailure("Not used") }
    func perform(_ instruction: CortexInstruction) {
        let id: UInt32
        switch instruction {
        case .dataMemoryBarrier: id = 1
        case .dataSynchronizationBarrier: id = 2
        case .instructionSynchronizationBarrier: id = 3
        case .sendEvent: id = 4
        case .waitForEvent: id = 5
        default: preconditionFailure("Not used by LL")
        }
        trace.append(.init(index: id, value: 0, kind: 2))
    }
    func index(_ r: CortexRegister) -> Int {
        switch r {
        case .sysTickControl: return 1536
        case .shcsr: return 1289
        case .mpuControl: return 1793
        case .mpuRegionNumber: return 1794
        case .mpuRegionAttributes: return 1796
        case .mpuRegionBaseAddress: return 1795
        default: preconditionFailure("Unused register")
        }
    }
    func read(_ r: CortexRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: CortexRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: LLCoreRegister) -> Int {
        switch r {
        case .systemControl: return 1284
        case .cpuid: return 1280
        }
    }
    func read(_ r: LLCoreRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: LLCoreRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: SBSRegister) -> Int {
        switch r {
        case .bootsr: return 256
        case .hdplcr: return 260
        case .hdplsr: return 261
        case .dbgcr: return 264
        case .dbglockr: return 265
        case .rsscmdr: return 269
        case .pmcr: return 320
        case .fpuimr: return 321
        case .mesr: return 322
        case .cccsr: return 324
        case .ccvalr: return 325
        case .ccswvalr: return 326
        case .bklockr: return 328
        case .extiConfiguration(let i): return 332 + i
        }
    }
    func read(_ r: SBSRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: SBSRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: LLDebugRegister) -> Int {
        switch r {
        case .idcode: return 512
        case .cr: return 513
        case .apb1fzr: return 527
        case .apb4fzr: return 533
        case .apb2fzr: return 531
        case .ahb5fzr: return 519
        case .ahb1fzr: return 521
        }
    }
    func read(_ r: LLDebugRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: LLDebugRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: VREFBUFRegister) -> Int {
        switch r {
        case .csr: return 768
        case .ccr: return 769
        }
    }
    func read(_ r: VREFBUFRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: VREFBUFRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: FlashTimingRegister) -> Int {
        switch r {
        case .acr: return 1024
        }
    }
    func read(_ r: FlashTimingRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: FlashTimingRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: FlashRegister) -> Int {
        switch r {
        case .keyr: return 1025
        case .cr: return 1028
        case .optkeyr: return 1088
        case .optcr: return 1089
        case .sr: return 1029
        case .obw2srp: return 1179
        case .obw2sr: return 1178
        default: preconditionFailure("Unused register")
        }
    }
    func read(_ r: FlashRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: FlashRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: PowerExtendedRegister) -> Int {
        switch r {
        case .cr1: return 0
        case .csr1: return 2
        case .csr2: return 3
        case .ucpdr: return 11
        case .csr3: return 4
        case .csr4: return 5
        case .wakeupEnablePolarity: return 10
        case .apcr: return 12
        case .pullUpN: return 13
        case .pullUpO: return 15
        case .pullDownN: return 14
        case .pullDownO: return 16
        case .pullDownP: return 17
        case .sr1: return 1
        case .wakeupFlags: return 9
        case .wakeupClear: return 8
        default: preconditionFailure("Unused register")
        }
    }
    func read(_ r: PowerExtendedRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: PowerExtendedRegister, value: UInt32) { writeIndex(index(r), value) }
}

private func runLLSystem(_ op: Int, _ io: inout LLSystemImage, _ args: [UInt32]) -> UInt32 {
    switch op {
    case 0: return LL_SYSTICK_IsActiveCounterFlag(&io)
    case 1: LL_SYSTICK_SetClkSource(&io, args[0]); return 0
    case 2: return LL_SYSTICK_GetClkSource(&io)
    case 3: LL_SYSTICK_EnableIT(&io); return 0
    case 4: LL_SYSTICK_DisableIT(&io); return 0
    case 5: return LL_SYSTICK_IsEnabledIT(&io)
    case 6: LL_LPM_EnableSleep(&io); return 0
    case 7: LL_LPM_EnableDeepSleep(&io); return 0
    case 8: LL_LPM_EnableSleepOnExit(&io); return 0
    case 9: LL_LPM_DisableSleepOnExit(&io); return 0
    case 10: LL_LPM_EnableEventOnPend(&io); return 0
    case 11: LL_LPM_DisableEventOnPend(&io); return 0
    case 12: LL_LPM_ClearEvent(&io); return 0
    case 13: LL_HANDLER_EnableFault(&io, args[0]); return 0
    case 14: LL_HANDLER_DisableFault(&io, args[0]); return 0
    case 15: return LL_CPUID_GetImplementer(&io)
    case 16: return LL_CPUID_GetVariant(&io)
    case 17: return LL_CPUID_GetArchitecture(&io)
    case 18: return LL_CPUID_GetParNo(&io)
    case 19: return LL_CPUID_GetRevision(&io)
    case 20: LL_MPU_Enable(&io, args[0]); return 0
    case 21: LL_MPU_Disable(&io); return 0
    case 22: return LL_MPU_IsEnabled(&io)
    case 23: LL_MPU_EnableRegion(&io, args[0]); return 0
    case 24: return LL_MPU_IsEnabled_Region(&io, args[0])
    case 25: LL_MPU_ConfigRegion(&io, args[0], args[1], args[2], args[3]); return 0
    case 26: LL_MPU_DisableRegion(&io, args[0]); return 0
    case 27: return LL_SBS_GetBootAddress(&io)
    case 28: LL_SBS_IncrementHDPL(&io); return 0
    case 29: return LL_SBS_GetCurrentHDPL(&io)
    case 30: LL_SBS_SetAuthDbgHDPL(&io, args[0]); return 0
    case 31: return LL_SBS_GetAuthDbgHDPL(&io)
    case 32: LL_SBS_UnlockDebug(&io); return 0
    case 33: return LL_SBS_IsUnlockedDebug(&io)
    case 34: LL_SBS_UnlockAccessPort(&io); return 0
    case 35: return LL_SBS_IsUnlockedAccessPort(&io)
    case 36: LL_SBS_LockDebugConfig(&io); return 0
    case 37: LL_SBS_UnlockDebugConfig(&io); return 0
    case 38: return LL_SBS_IsUnlockedDebugConfig(&io)
    case 39: LL_SBS_SetRSSCmd(&io, args[0]); return 0
    case 40: return LL_SBS_GetRSSCmd(&io)
    case 41: LL_SBS_SetAXISRAMWaitState(&io, args[0]); return 0
    case 42: return LL_SBS_GetAXISRAMWaitState(&io)
    case 43: LL_SBS_SetEthernetPhy(&io, args[0]); return 0
    case 44: return LL_SBS_GetEthernetPhy(&io)
    case 45: LL_SBS_SetBoosterVoltage(&io, args[0]); return 0
    case 46: return LL_SBS_GetBoosterVoltage(&io)
    case 47: LL_SBS_EnableBooster(&io); return 0
    case 48: LL_SBS_DisableBooster(&io); return 0
    case 49: return LL_SBS_IsEnabledBooster(&io)
    case 50: LL_SBS_EnableIT_FPU_IOC(&io); return 0
    case 51: LL_SBS_EnableIT_FPU_DZC(&io); return 0
    case 52: LL_SBS_EnableIT_FPU_UFC(&io); return 0
    case 53: LL_SBS_EnableIT_FPU_OFC(&io); return 0
    case 54: LL_SBS_EnableIT_FPU_IDC(&io); return 0
    case 55: LL_SBS_EnableIT_FPU_IXC(&io); return 0
    case 56: LL_SBS_DisableIT_FPU_IOC(&io); return 0
    case 57: LL_SBS_DisableIT_FPU_DZC(&io); return 0
    case 58: LL_SBS_DisableIT_FPU_UFC(&io); return 0
    case 59: LL_SBS_DisableIT_FPU_OFC(&io); return 0
    case 60: LL_SBS_DisableIT_FPU_IDC(&io); return 0
    case 61: LL_SBS_DisableIT_FPU_IXC(&io); return 0
    case 62: return LL_SBS_IsEnabledIT_FPU_IOC(&io)
    case 63: return LL_SBS_IsEnabledIT_FPU_DZC(&io)
    case 64: return LL_SBS_IsEnabledIT_FPU_UFC(&io)
    case 65: return LL_SBS_IsEnabledIT_FPU_OFC(&io)
    case 66: return LL_SBS_IsEnabledIT_FPU_IDC(&io)
    case 67: return LL_SBS_IsEnabledIT_FPU_IXC(&io)
    case 68: return LL_SBS_IsDoneMemoryErase(&io)
    case 69: LL_SBS_EnableXSPI2SpeedOptim(&io); return 0
    case 70: LL_SBS_DisableXSPI2SpeedOptim(&io); return 0
    case 71: return LL_SBS_IsEnabledXSPI2SpeedOptim(&io)
    case 72: LL_SBS_EnableXSPI1SpeedOptim(&io); return 0
    case 73: LL_SBS_DisableXSPI1SpeedOptim(&io); return 0
    case 74: return LL_SBS_IsEnabledXSPI1SpeedOptim(&io)
    case 75: LL_SBS_EnableIOSpeedOptim(&io); return 0
    case 76: LL_SBS_DisableIOSpeedOptim(&io); return 0
    case 77: return LL_SBS_IsEnabledIOSpeedOptim(&io)
    case 78: return LL_SBS_IsReadyXSPI2CompCell(&io)
    case 79: return LL_SBS_IsReadyXSPI1CompCell(&io)
    case 80: return LL_SBS_IsReadyIOCompCell(&io)
    case 81: LL_SBS_SetXSPI2CompCellCode(&io, args[0]); return 0
    case 82: return LL_SBS_GetXSPI2CompCellCode(&io)
    case 83: LL_SBS_EnableXSPI2CompCell(&io); return 0
    case 84: LL_SBS_DisableXSPI2CompCell(&io); return 0
    case 85: return LL_SBS_IsEnabledXSPI2CompCell(&io)
    case 86: LL_SBS_SetXSPI1CompCellCode(&io, args[0]); return 0
    case 87: return LL_SBS_GetXSPI1CompCellCode(&io)
    case 88: LL_SBS_EnableXSPI1CompCell(&io); return 0
    case 89: LL_SBS_DisableXSPI1CompCell(&io); return 0
    case 90: return LL_SBS_IsEnabledXSPI1CompCell(&io)
    case 91: LL_SBS_SetIOCompCellCode(&io, args[0]); return 0
    case 92: return LL_SBS_GetIOCompCellCode(&io)
    case 93: LL_SBS_EnableIOCompCell(&io); return 0
    case 94: LL_SBS_DisableIOCompCell(&io); return 0
    case 95: return LL_SBS_IsEnabledIOCompCell(&io)
    case 96: return LL_SBS_GetXSPI2PmosComp(&io)
    case 97: return LL_SBS_GetXSPI2NmosComp(&io)
    case 98: return LL_SBS_GetXSPI1PmosComp(&io)
    case 99: return LL_SBS_GetXSPI1NmosComp(&io)
    case 100: return LL_SBS_GetIOPmosComp(&io)
    case 101: return LL_SBS_GetIONmosComp(&io)
    case 102: LL_SBS_SetXSPI2SwPmosComp(&io, args[0]); return 0
    case 103: return LL_SBS_GetXSPI2SwPmosComp(&io)
    case 104: LL_SBS_SetXSPI2SwNmosComp(&io, args[0]); return 0
    case 105: return LL_SBS_GetXSPI2SwNmosComp(&io)
    case 106: LL_SBS_SetXSPI1SwPmosComp(&io, args[0]); return 0
    case 107: return LL_SBS_GetXSPI1SwPmosComp(&io)
    case 108: LL_SBS_SetXSPI1SwNmosComp(&io, args[0]); return 0
    case 109: return LL_SBS_GetXSPI1SwNmosComp(&io)
    case 110: LL_SBS_SetIOSwPmosComp(&io, args[0]); return 0
    case 111: return LL_SBS_GetIOSwPmosComp(&io)
    case 112: LL_SBS_SetIOSwNmosComp(&io, args[0]); return 0
    case 113: return LL_SBS_GetIOSwNmosComp(&io)
    case 114: LL_SBS_SetTIMBreakInputs(&io, args[0]); return 0
    case 115: return LL_SBS_GetTIMBreakInputs(&io)
    case 116: LL_SBS_SetEXTISource(&io, args[0], args[1]); return 0
    case 117: return LL_SBS_GetEXTISource(&io, args[0])
    case 118: return LL_DBGMCU_GetDeviceID(&io)
    case 119: return LL_DBGMCU_GetRevisionID(&io)
    case 120: LL_DBGMCU_EnableDBGSleepMode(&io); return 0
    case 121: LL_DBGMCU_DisableDBGSleepMode(&io); return 0
    case 122: return LL_DBGMCU_IsEnabledDBGSleepMode(&io)
    case 123: LL_DBGMCU_EnableDBGStopMode(&io); return 0
    case 124: LL_DBGMCU_DisableDBGStopMode(&io); return 0
    case 125: return LL_DBGMCU_IsEnabledDBGStopMode(&io)
    case 126: LL_DBGMCU_EnableDBGStandbyMode(&io); return 0
    case 127: LL_DBGMCU_DisableDBGStandbyMode(&io); return 0
    case 128: return LL_DBGMCU_IsEnabledDBGStandbyMode(&io)
    case 129: LL_DBGMCU_SetDbgCredentialResetType(&io, args[0]); return 0
    case 130: return LL_DBGMCU_GetDbgCredentialResetType(&io)
    case 131: LL_DBGMCU_EnableTraceClock(&io); return 0
    case 132: LL_DBGMCU_DisableTraceClock(&io); return 0
    case 133: return LL_DBGMCU_IsEnabledTraceClock(&io)
    case 134: LL_DBGMCU_EnableDebugClock(&io); return 0
    case 135: LL_DBGMCU_DisableDebugClock(&io); return 0
    case 136: return LL_DBGMCU_IsEnabledDebugClock(&io)
    case 137: LL_DBGMCU_EnableTriggerOutput(&io); return 0
    case 138: LL_DBGMCU_DisableTriggerOutput(&io); return 0
    case 139: return LL_DBGMCU_IsEnabledTriggerOutput(&io)
    case 140: LL_DBGMCU_APB1_GRP1_FreezePeriph(&io, args[0]); return 0
    case 141: LL_DBGMCU_APB1_GRP1_UnFreezePeriph(&io, args[0]); return 0
    case 142: LL_DBGMCU_APB4_GRP1_FreezePeriph(&io, args[0]); return 0
    case 143: LL_DBGMCU_APB4_GRP1_UnFreezePeriph(&io, args[0]); return 0
    case 144: LL_DBGMCU_APB2_GRP1_FreezePeriph(&io, args[0]); return 0
    case 145: LL_DBGMCU_APB2_GRP1_UnFreezePeriph(&io, args[0]); return 0
    case 146: LL_DBGMCU_AHB5_GRP1_FreezePeriph(&io, args[0]); return 0
    case 147: LL_DBGMCU_AHB5_GRP1_UnFreezePeriph(&io, args[0]); return 0
    case 148: LL_DBGMCU_AHB1_GRP1_FreezePeriph(&io, args[0]); return 0
    case 149: LL_DBGMCU_AHB1_GRP1_UnFreezePeriph(&io, args[0]); return 0
    case 150: LL_VREFBUF_Enable(&io); return 0
    case 151: LL_VREFBUF_Disable(&io); return 0
    case 152: LL_VREFBUF_EnableHIZ(&io); return 0
    case 153: LL_VREFBUF_DisableHIZ(&io); return 0
    case 154: LL_VREFBUF_SetVoltageScaling(&io, args[0]); return 0
    case 155: return LL_VREFBUF_GetVoltageScaling(&io)
    case 156: return LL_VREFBUF_IsVREFReady(&io)
    case 157: return LL_VREFBUF_GetTrimming(&io)
    case 158: LL_VREFBUF_SetTrimming(&io, args[0]); return 0
    case 159: LL_FLASH_SetLatency(&io, args[0]); return 0
    case 160: return LL_FLASH_GetLatency(&io)
    case 161: LL_FLASH_Unlock(&io); return 0
    case 162: LL_FLASH_Lock(&io); return 0
    case 163: return LL_FLASH_IsLocked(&io)
    case 164: LL_FLASH_OptionBytes_Unlock(&io); return 0
    case 165: LL_FLASH_OptionBytes_Lock(&io); return 0
    case 166: return LL_FLASH_OptionBytes_IsLocked(&io)
    case 167: LL_FLASH_OptionBytes_EnableProg(&io); return 0
    case 168: LL_FLASH_OptionBytes_DisableProg(&io); return 0
    case 169: return LL_FLASH_OptionBytes_IsEnabledProg(&io)
    case 170: return LL_FLASH_IsPendingOperation(&io)
    case 171: LL_FLASH_OptionBytes_EnableI2C(&io); return 0
    case 172: LL_FLASH_OptionBytes_EnableI3C(&io); return 0
    case 173: return LL_FLASH_OptionBytes_IsI2CEnabled(&io)
    case 174: return LL_FLASH_OptionBytes_IsI3CEnabled(&io)
    case 175: LL_PWR_EnablePVD(&io); return 0
    case 176: LL_PWR_DisablePVD(&io); return 0
    case 177: return LL_PWR_IsEnabledPVD(&io)
    case 178: LL_PWR_SetPVDLevel(&io, args[0]); return 0
    case 179: return LL_PWR_GetPVDLevel(&io)
    case 180: LL_PWR_EnableBkUpAccess(&io); return 0
    case 181: LL_PWR_DisableBkUpAccess(&io); return 0
    case 182: return LL_PWR_IsEnabledBkUpAccess(&io)
    case 183: LL_PWR_EnableFlashLowPower(&io); return 0
    case 184: LL_PWR_DisableFlashLowPower(&io); return 0
    case 185: return LL_PWR_IsEnabledFlashLowPower(&io)
    case 186: LL_PWR_EnableAnalogBooster(&io); return 0
    case 187: LL_PWR_DisableAnalogBooster(&io); return 0
    case 188: return LL_PWR_IsEnabledAnalogBooster(&io)
    case 189: LL_PWR_EnableAnalogVoltageReady(&io); return 0
    case 190: LL_PWR_DisableAnalogVoltageReady(&io); return 0
    case 191: return LL_PWR_IsEnabledAnalogVoltageReady(&io)
    case 192: LL_PWR_EnableAVD(&io); return 0
    case 193: LL_PWR_DisableAVD(&io); return 0
    case 194: return LL_PWR_IsEnabledAVD(&io)
    case 195: LL_PWR_SetAVDLevel(&io, args[0]); return 0
    case 196: return LL_PWR_GetAVDLevel(&io)
    case 197: LL_PWR_EnableBkUpRegulator(&io); return 0
    case 198: LL_PWR_DisableBkUpRegulator(&io); return 0
    case 199: return LL_PWR_IsEnabledBkUpRegulator(&io)
    case 200: LL_PWR_EnableMonitoring(&io); return 0
    case 201: LL_PWR_DisableMonitoring(&io); return 0
    case 202: return LL_PWR_IsEnabledMonitoring(&io)
    case 203: LL_PWR_ConfigSupply(&io, args[0]); return 0
    case 204: return LL_PWR_GetSupply(&io)
    case 205: LL_PWR_EnableBatteryCharging(&io); return 0
    case 206: LL_PWR_DisableBatteryCharging(&io); return 0
    case 207: return LL_PWR_IsEnabledBatteryCharging(&io)
    case 208: LL_PWR_SetBattChargResistor(&io, args[0]); return 0
    case 209: return LL_PWR_GetBattChargResistor(&io)
    case 210: LL_PWR_SetXSPI1Capacitor(&io, args[0]); return 0
    case 211: return LL_PWR_GetXSPI1Capacitor(&io)
    case 212: LL_PWR_SetXSPI2Capacitor(&io, args[0]); return 0
    case 213: return LL_PWR_GetXSPI2Capacitor(&io)
    case 214: LL_PWR_EnableUSBVoltageDetector(&io); return 0
    case 215: LL_PWR_DisableUSBVoltageDetector(&io); return 0
    case 216: return LL_PWR_IsEnabledUSBVoltageDetector(&io)
    case 217: LL_PWR_EnableUSBReg(&io); return 0
    case 218: LL_PWR_DisableUSBReg(&io); return 0
    case 219: return LL_PWR_IsEnabledUSBReg(&io)
    case 220: LL_PWR_EnableUSBHSPHYReg(&io); return 0
    case 221: LL_PWR_DisableUSBHSPHYReg(&io); return 0
    case 222: return LL_PWR_IsEnabledUSBHSPHYReg(&io)
    case 223: LL_PWR_EnableUCPDStandbyMode(&io); return 0
    case 224: LL_PWR_DisableUCPDStandbyMode(&io); return 0
    case 225: return LL_PWR_IsEnabledUCPDStandbyMode(&io)
    case 226: LL_PWR_EnableUCPDDeadBattery(&io); return 0
    case 227: LL_PWR_DisableUCPDDeadBattery(&io); return 0
    case 228: return LL_PWR_IsEnabledUCPDDeadBattery(&io)
    case 229: LL_PWR_EnableXSPIM1(&io); return 0
    case 230: LL_PWR_DisableXSPIM1(&io); return 0
    case 231: return LL_PWR_IsEnabledXSPIM1(&io)
    case 232: LL_PWR_EnableXSPIM2(&io); return 0
    case 233: LL_PWR_DisableXSPIM2(&io); return 0
    case 234: return LL_PWR_IsEnabledXSPIM2(&io)
    case 235: LL_PWR_SetPowerDownModeDS(&io, args[0]); return 0
    case 236: return LL_PWR_GetPowerDownModeDS(&io)
    case 237: LL_PWR_SetRegulVoltageScaling(&io, args[0]); return 0
    case 238: return LL_PWR_GetRegulVoltageScaling(&io)
    case 239: LL_PWR_SetStopModeRegulVoltageScaling(&io, args[0]); return 0
    case 240: return LL_PWR_GetStopModeRegulVoltageScaling(&io)
    case 241: LL_PWR_EnableWakeUpPin(&io, args[0]); return 0
    case 242: LL_PWR_DisableWakeUpPin(&io, args[0]); return 0
    case 243: return LL_PWR_IsEnabledWakeUpPin(&io, args[0])
    case 244: LL_PWR_SetWakeUpPinPolarityLow(&io, args[0]); return 0
    case 245: LL_PWR_SetWakeUpPinPolarityHigh(&io, args[0]); return 0
    case 246: return LL_PWR_IsWakeUpPinPolarityLow(&io, args[0])
    case 247: LL_PWR_SetWakeUpPinPullNone(&io, args[0]); return 0
    case 248: LL_PWR_SetWakeUpPinPullUp(&io, args[0]); return 0
    case 249: LL_PWR_SetWakeUpPinPullDown(&io, args[0]); return 0
    case 250: return LL_PWR_GetWakeUpPinPull(&io, args[0])
    case 251: LL_PWR_EnableI3CPB6PU(&io); return 0
    case 252: LL_PWR_DisableI3CPB6PU(&io); return 0
    case 253: return LL_PWR_IsEnabledI3CPB6PU(&io)
    case 254: LL_PWR_EnableI3CPB7PU(&io); return 0
    case 255: LL_PWR_DisableI3CPB7PU(&io); return 0
    case 256: return LL_PWR_IsEnabledI3CPB7PU(&io)
    case 257: LL_PWR_EnableI3CPB8PU(&io); return 0
    case 258: LL_PWR_DisableI3CPB8PU(&io); return 0
    case 259: return LL_PWR_IsEnabledI3CPB8PU(&io)
    case 260: LL_PWR_EnableI3CPB9PU(&io); return 0
    case 261: LL_PWR_DisableI3CPB9PU(&io); return 0
    case 262: return LL_PWR_IsEnabledI3CPB9PU(&io)
    case 263: LL_PWR_EnablePUPDConfig(&io); return 0
    case 264: LL_PWR_DisablePUPDConfig(&io); return 0
    case 265: return LL_PWR_IsEnabledPUPDConfig(&io)
    case 266: LL_PWR_EnableGPIONPullUp(&io, args[0]); return 0
    case 267: LL_PWR_DisableGPIONPullUp(&io, args[0]); return 0
    case 268: return LL_PWR_IsEnabledGPIONPullUp(&io, args[0])
    case 269: LL_PWR_EnableGPIOOPullUp(&io, args[0]); return 0
    case 270: LL_PWR_DisableGPIOOPullUp(&io, args[0]); return 0
    case 271: return LL_PWR_IsEnabledGPIOOPullUp(&io, args[0])
    case 272: LL_PWR_EnableGPIONPullDown(&io, args[0]); return 0
    case 273: LL_PWR_DisableGPIONPullDown(&io, args[0]); return 0
    case 274: return LL_PWR_IsEnabledGPIONPullDown(&io, args[0])
    case 275: LL_PWR_EnableGPIOOPullDown(&io, args[0]); return 0
    case 276: LL_PWR_DisableGPIOOPullDown(&io, args[0]); return 0
    case 277: return LL_PWR_IsEnabledGPIOOPullDown(&io, args[0])
    case 278: LL_PWR_EnableGPIOPPullDown(&io, args[0]); return 0
    case 279: LL_PWR_DisableGPIOPPullDown(&io, args[0]); return 0
    case 280: return LL_PWR_IsEnabledGPIOPPullDown(&io, args[0])
    case 281: return LL_PWR_IsActiveFlag_ACTVOSRDY(&io)
    case 282: return LL_PWR_IsActiveFlag_PVDO(&io)
    case 283: return LL_PWR_IsActiveFlag_AVDO(&io)
    case 284: return LL_PWR_IsActiveFlag_BRRDY(&io)
    case 285: return LL_PWR_IsActiveFlag_VBATL(&io)
    case 286: return LL_PWR_IsActiveFlag_VBATH(&io)
    case 287: return LL_PWR_IsActiveFlag_TEMPL(&io)
    case 288: return LL_PWR_IsActiveFlag_TEMPH(&io)
    case 289: return LL_PWR_IsActiveFlag_SDEXTRDY(&io)
    case 290: return LL_PWR_IsActiveFlag_USB33RDY(&io)
    case 291: return LL_PWR_IsActiveFlag_STOP(&io)
    case 292: return LL_PWR_IsActiveFlag_SB(&io)
    case 293: return LL_PWR_IsActiveFlag_VOSRDY(&io)
    case 294: return LL_PWR_IsActiveFlag_WU1(&io)
    case 295: return LL_PWR_IsActiveFlag_WU2(&io)
    case 296: return LL_PWR_IsActiveFlag_WU3(&io)
    case 297: return LL_PWR_IsActiveFlag_WU4(&io)
    case 298: LL_PWR_ClearFlag_STOP_SB(&io); return 0
    case 299: LL_PWR_ClearFlag_WU1(&io); return 0
    case 300: LL_PWR_ClearFlag_WU2(&io); return 0
    case 301: LL_PWR_ClearFlag_WU3(&io); return 0
    case 302: LL_PWR_ClearFlag_WU4(&io); return 0
    case 303: LL_PWR_ClearFlag_WU(&io); return 0
    case 304: return LL_PWR_DeInit(&io).rawValue
    case 305: LL_PWR_WriteReg(&io, .cr1, args[0]); return 0
    case 306: return LL_PWR_ReadReg(&io, .cr1)
    default: preconditionFailure("Unknown operation")
    }
}

final class LLSystemDifferentialTests: XCTestCase {
    private func compare(_ op: Int, _ args: [UInt32], seed: UInt32, salt: UInt32,
                         file: StaticString = #filePath, line: UInt = #line) {
        let c = CL49_Create()!
        defer { CL49_Destroy(c) }
        CL49_Reset(c, seed, salt)
        var io = LLSystemImage(seed: seed, salt: salt)
        let cr = CL49_Run(c, UInt32(op), args)
        let sr = runLLSystem(op, &io, args)
        let context = "op=\(op) args=\(args) seed=\(seed) salt=\(salt)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        XCTAssertEqual(io.cells, Array(UnsafeBufferPointer(start: CL49_GetCells(c), count: 2048)), context, file: file, line: line)
        let trace = UnsafeBufferPointer(start: CL49_GetTrace(c), count: Int(CL49_GetTraceCount(c)))
        XCTAssertEqual(io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file, line: line)
    }

    func testAllFunctionsAgainstCIncludingChangingRegisterReads() {
        for op in 0..<307 {
            for sample in 0..<64 {
                let seed = UInt32(sample) &* 0x9E3779B9
                var args: [UInt32] = [seed, ~seed, seed ^ 0x55AA55AA, seed &+ 17]
                if op == 116 { args[1] = UInt32((sample % 16) / 4) | (UInt32((sample % 4) * 4) << 16) }
                if op == 117 { args[0] = UInt32((sample % 16) / 4) | (UInt32((sample % 4) * 4) << 16) }
                compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x10204081)
            }
        }
    }

    func testPowerWakeupPullAllPositionsIncludingZero() {
        for pin: UInt32 in 0...32 { compare(247, [pin == 32 ? 0 : 1 << pin, 0, 0, 0], seed: 0x12345678, salt: 0x12345) }
        for pin: UInt32 in 0...32 { compare(248, [pin == 32 ? 0 : 1 << pin, 0, 0, 0], seed: 0x12345678, salt: 0x12345) }
        for pin: UInt32 in 0...32 { compare(249, [pin == 32 ? 0 : 1 << pin, 0, 0, 0], seed: 0x12345678, salt: 0x12345) }
        for pin: UInt32 in 0...32 { compare(250, [pin == 32 ? 0 : 1 << pin, 0, 0, 0], seed: 0x12345678, salt: 0x12345) }
    }

    func testMPUBarriersAndFaultEnableRemainDistinctFromHAL() {
        var io = LLSystemImage(seed: 0, salt: 0)
        let shcsr = io.cells[io.index(CortexRegister.shcsr)]
        LL_MPU_Enable(&io, LL_MPU_CTRL_PRIVILEGED_DEFAULT)
        XCTAssertEqual(io.cells[io.index(CortexRegister.shcsr)], shcsr)
        XCTAssertEqual(io.trace.map(\.kind), [2, 1, 2, 2])
        XCTAssertEqual(io.trace.filter { $0.kind == 2 }.map(\.index), [1, 2, 3])
        io.trace = []
        LL_MPU_Disable(&io)
        XCTAssertEqual(io.cells[io.index(CortexRegister.shcsr)], shcsr)
        XCTAssertEqual(io.trace.map(\.kind), [2, 1])
        XCTAssertEqual(io.trace[0].index, 1)
    }

    func testMPUConfigurationMasksOnlyLowAddressBitsAndWritesThreeRegisters() {
        var io = LLSystemImage(seed: 0, salt: 0)
        LL_MPU_ConfigRegion(&io, 7, 0x81, 0x24000123, 0x03000012)
        XCTAssertEqual(io.trace.map(\.kind), [1, 1, 1])
        XCTAssertEqual(io.trace.map(\.value), [7, 0x24000120, 0x03008113])
    }

    func testFlashUnlockPreservesBothKeysWithoutPreliminaryLockRead() {
        var io = LLSystemImage(seed: 0, salt: 0)
        LL_FLASH_Unlock(&io)
        XCTAssertEqual(io.trace.map(\.kind), [1, 1])
        XCTAssertEqual(io.trace.map(\.value), [0x45670123, 0xCDEF89AB])
        io.trace = []
        LL_FLASH_OptionBytes_Unlock(&io)
        XCTAssertEqual(io.trace.map(\.kind), [1, 1])
        XCTAssertEqual(io.trace.map(\.value), [0x08192A3B, 0x4C5D6E7F])
    }

    func testEventClearPreservesSEVThenWFE() {
        var io = LLSystemImage(seed: 0, salt: 0)
        LL_LPM_ClearEvent(&io)
        XCTAssertEqual(io.trace.map(\.kind), [2, 2])
        XCTAssertEqual(io.trace.map(\.index), [4, 5])
    }

    func testPowerDeInitClearsFlagsUnlikeEmptyHALDeInit() {
        var io = LLSystemImage(seed: .max, salt: 0)
        XCTAssertEqual(LL_PWR_DeInit(&io), .success)
        XCTAssertEqual(io.trace.map(\.kind), [0, 1, 1])
        XCTAssertEqual(io.trace.last?.value, 15)
    }

    func testEveryConstantAgainstExactCHeaders() {
        XCTAssertEqual(LL_SYSTICK_CLKSOURCE_HCLK_DIV8, CL49_Constant(0), "LL_SYSTICK_CLKSOURCE_HCLK_DIV8")
        XCTAssertEqual(LL_SYSTICK_CLKSOURCE_HCLK, CL49_Constant(1), "LL_SYSTICK_CLKSOURCE_HCLK")
        XCTAssertEqual(LL_HANDLER_FAULT_USG, CL49_Constant(2), "LL_HANDLER_FAULT_USG")
        XCTAssertEqual(LL_HANDLER_FAULT_BUS, CL49_Constant(3), "LL_HANDLER_FAULT_BUS")
        XCTAssertEqual(LL_HANDLER_FAULT_MEM, CL49_Constant(4), "LL_HANDLER_FAULT_MEM")
        XCTAssertEqual(LL_MPU_CTRL_HFNMI_PRIVDEF_NONE, CL49_Constant(5), "LL_MPU_CTRL_HFNMI_PRIVDEF_NONE")
        XCTAssertEqual(LL_MPU_CTRL_HARDFAULT_NMI, CL49_Constant(6), "LL_MPU_CTRL_HARDFAULT_NMI")
        XCTAssertEqual(LL_MPU_CTRL_PRIVILEGED_DEFAULT, CL49_Constant(7), "LL_MPU_CTRL_PRIVILEGED_DEFAULT")
        XCTAssertEqual(LL_MPU_CTRL_HFNMI_PRIVDEF, CL49_Constant(8), "LL_MPU_CTRL_HFNMI_PRIVDEF")
        XCTAssertEqual(LL_MPU_REGION_NUMBER0, CL49_Constant(9), "LL_MPU_REGION_NUMBER0")
        XCTAssertEqual(LL_MPU_REGION_NUMBER1, CL49_Constant(10), "LL_MPU_REGION_NUMBER1")
        XCTAssertEqual(LL_MPU_REGION_NUMBER2, CL49_Constant(11), "LL_MPU_REGION_NUMBER2")
        XCTAssertEqual(LL_MPU_REGION_NUMBER3, CL49_Constant(12), "LL_MPU_REGION_NUMBER3")
        XCTAssertEqual(LL_MPU_REGION_NUMBER4, CL49_Constant(13), "LL_MPU_REGION_NUMBER4")
        XCTAssertEqual(LL_MPU_REGION_NUMBER5, CL49_Constant(14), "LL_MPU_REGION_NUMBER5")
        XCTAssertEqual(LL_MPU_REGION_NUMBER6, CL49_Constant(15), "LL_MPU_REGION_NUMBER6")
        XCTAssertEqual(LL_MPU_REGION_NUMBER7, CL49_Constant(16), "LL_MPU_REGION_NUMBER7")
        XCTAssertEqual(LL_MPU_REGION_NUMBER8, CL49_Constant(17), "LL_MPU_REGION_NUMBER8")
        XCTAssertEqual(LL_MPU_REGION_NUMBER9, CL49_Constant(18), "LL_MPU_REGION_NUMBER9")
        XCTAssertEqual(LL_MPU_REGION_NUMBER10, CL49_Constant(19), "LL_MPU_REGION_NUMBER10")
        XCTAssertEqual(LL_MPU_REGION_NUMBER11, CL49_Constant(20), "LL_MPU_REGION_NUMBER11")
        XCTAssertEqual(LL_MPU_REGION_NUMBER12, CL49_Constant(21), "LL_MPU_REGION_NUMBER12")
        XCTAssertEqual(LL_MPU_REGION_NUMBER13, CL49_Constant(22), "LL_MPU_REGION_NUMBER13")
        XCTAssertEqual(LL_MPU_REGION_NUMBER14, CL49_Constant(23), "LL_MPU_REGION_NUMBER14")
        XCTAssertEqual(LL_MPU_REGION_NUMBER15, CL49_Constant(24), "LL_MPU_REGION_NUMBER15")
        XCTAssertEqual(LL_MPU_REGION_SIZE_32B, CL49_Constant(25), "LL_MPU_REGION_SIZE_32B")
        XCTAssertEqual(LL_MPU_REGION_SIZE_64B, CL49_Constant(26), "LL_MPU_REGION_SIZE_64B")
        XCTAssertEqual(LL_MPU_REGION_SIZE_128B, CL49_Constant(27), "LL_MPU_REGION_SIZE_128B")
        XCTAssertEqual(LL_MPU_REGION_SIZE_256B, CL49_Constant(28), "LL_MPU_REGION_SIZE_256B")
        XCTAssertEqual(LL_MPU_REGION_SIZE_512B, CL49_Constant(29), "LL_MPU_REGION_SIZE_512B")
        XCTAssertEqual(LL_MPU_REGION_SIZE_1KB, CL49_Constant(30), "LL_MPU_REGION_SIZE_1KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_2KB, CL49_Constant(31), "LL_MPU_REGION_SIZE_2KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_4KB, CL49_Constant(32), "LL_MPU_REGION_SIZE_4KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_8KB, CL49_Constant(33), "LL_MPU_REGION_SIZE_8KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_16KB, CL49_Constant(34), "LL_MPU_REGION_SIZE_16KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_32KB, CL49_Constant(35), "LL_MPU_REGION_SIZE_32KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_64KB, CL49_Constant(36), "LL_MPU_REGION_SIZE_64KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_128KB, CL49_Constant(37), "LL_MPU_REGION_SIZE_128KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_256KB, CL49_Constant(38), "LL_MPU_REGION_SIZE_256KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_512KB, CL49_Constant(39), "LL_MPU_REGION_SIZE_512KB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_1MB, CL49_Constant(40), "LL_MPU_REGION_SIZE_1MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_2MB, CL49_Constant(41), "LL_MPU_REGION_SIZE_2MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_4MB, CL49_Constant(42), "LL_MPU_REGION_SIZE_4MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_8MB, CL49_Constant(43), "LL_MPU_REGION_SIZE_8MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_16MB, CL49_Constant(44), "LL_MPU_REGION_SIZE_16MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_32MB, CL49_Constant(45), "LL_MPU_REGION_SIZE_32MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_64MB, CL49_Constant(46), "LL_MPU_REGION_SIZE_64MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_128MB, CL49_Constant(47), "LL_MPU_REGION_SIZE_128MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_256MB, CL49_Constant(48), "LL_MPU_REGION_SIZE_256MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_512MB, CL49_Constant(49), "LL_MPU_REGION_SIZE_512MB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_1GB, CL49_Constant(50), "LL_MPU_REGION_SIZE_1GB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_2GB, CL49_Constant(51), "LL_MPU_REGION_SIZE_2GB")
        XCTAssertEqual(LL_MPU_REGION_SIZE_4GB, CL49_Constant(52), "LL_MPU_REGION_SIZE_4GB")
        XCTAssertEqual(LL_MPU_REGION_NO_ACCESS, CL49_Constant(53), "LL_MPU_REGION_NO_ACCESS")
        XCTAssertEqual(LL_MPU_REGION_PRIV_RW, CL49_Constant(54), "LL_MPU_REGION_PRIV_RW")
        XCTAssertEqual(LL_MPU_REGION_PRIV_RW_URO, CL49_Constant(55), "LL_MPU_REGION_PRIV_RW_URO")
        XCTAssertEqual(LL_MPU_REGION_FULL_ACCESS, CL49_Constant(56), "LL_MPU_REGION_FULL_ACCESS")
        XCTAssertEqual(LL_MPU_REGION_PRIV_RO, CL49_Constant(57), "LL_MPU_REGION_PRIV_RO")
        XCTAssertEqual(LL_MPU_REGION_PRIV_RO_URO, CL49_Constant(58), "LL_MPU_REGION_PRIV_RO_URO")
        XCTAssertEqual(LL_MPU_TEX_LEVEL0, CL49_Constant(59), "LL_MPU_TEX_LEVEL0")
        XCTAssertEqual(LL_MPU_TEX_LEVEL1, CL49_Constant(60), "LL_MPU_TEX_LEVEL1")
        XCTAssertEqual(LL_MPU_TEX_LEVEL2, CL49_Constant(61), "LL_MPU_TEX_LEVEL2")
        XCTAssertEqual(LL_MPU_INSTRUCTION_ACCESS_ENABLE, CL49_Constant(62), "LL_MPU_INSTRUCTION_ACCESS_ENABLE")
        XCTAssertEqual(LL_MPU_INSTRUCTION_ACCESS_DISABLE, CL49_Constant(63), "LL_MPU_INSTRUCTION_ACCESS_DISABLE")
        XCTAssertEqual(LL_MPU_ACCESS_SHAREABLE, CL49_Constant(64), "LL_MPU_ACCESS_SHAREABLE")
        XCTAssertEqual(LL_MPU_ACCESS_NOT_SHAREABLE, CL49_Constant(65), "LL_MPU_ACCESS_NOT_SHAREABLE")
        XCTAssertEqual(LL_MPU_ACCESS_CACHEABLE, CL49_Constant(66), "LL_MPU_ACCESS_CACHEABLE")
        XCTAssertEqual(LL_MPU_ACCESS_NOT_CACHEABLE, CL49_Constant(67), "LL_MPU_ACCESS_NOT_CACHEABLE")
        XCTAssertEqual(LL_MPU_ACCESS_BUFFERABLE, CL49_Constant(68), "LL_MPU_ACCESS_BUFFERABLE")
        XCTAssertEqual(LL_MPU_ACCESS_NOT_BUFFERABLE, CL49_Constant(69), "LL_MPU_ACCESS_NOT_BUFFERABLE")
        XCTAssertEqual(LL_SBS_REGISTER_PINPOS_SHFT, CL49_Constant(70), "LL_SBS_REGISTER_PINPOS_SHFT")
        XCTAssertEqual(LL_SBS_HDPL_INCREMENT_VALUE, CL49_Constant(71), "LL_SBS_HDPL_INCREMENT_VALUE")
        XCTAssertEqual(LL_SBS_DBG_UNLOCK, CL49_Constant(72), "LL_SBS_DBG_UNLOCK")
        XCTAssertEqual(LL_SBS_ACCESS_PORT_UNLOCK, CL49_Constant(73), "LL_SBS_ACCESS_PORT_UNLOCK")
        XCTAssertEqual(LL_SBS_DBG_CONFIG_LOCK, CL49_Constant(74), "LL_SBS_DBG_CONFIG_LOCK")
        XCTAssertEqual(LL_SBS_DBG_CONFIG_UNLOCK, CL49_Constant(75), "LL_SBS_DBG_CONFIG_UNLOCK")
        XCTAssertEqual(LL_SBS_HDPL0, CL49_Constant(76), "LL_SBS_HDPL0")
        XCTAssertEqual(LL_SBS_HDPL1, CL49_Constant(77), "LL_SBS_HDPL1")
        XCTAssertEqual(LL_SBS_HDPL2, CL49_Constant(78), "LL_SBS_HDPL2")
        XCTAssertEqual(LL_SBS_HDPL3, CL49_Constant(79), "LL_SBS_HDPL3")
        XCTAssertEqual(LL_SBS_AXISRAM_NO_WS, CL49_Constant(80), "LL_SBS_AXISRAM_NO_WS")
        XCTAssertEqual(LL_SBS_AXISRAM_ONE_WS, CL49_Constant(81), "LL_SBS_AXISRAM_ONE_WS")
        XCTAssertEqual(LL_SBS_ETH_PHYSEL_GMII_MII, CL49_Constant(82), "LL_SBS_ETH_PHYSEL_GMII_MII")
        XCTAssertEqual(LL_SBS_ETH_PHYSEL_RMII, CL49_Constant(83), "LL_SBS_ETH_PHYSEL_RMII")
        XCTAssertEqual(LL_SBS_BOOSTVDDSEL_VDDA, CL49_Constant(84), "LL_SBS_BOOSTVDDSEL_VDDA")
        XCTAssertEqual(LL_SBS_BOOSTVDDSEL_VDD, CL49_Constant(85), "LL_SBS_BOOSTVDDSEL_VDD")
        XCTAssertEqual(LL_SBS_XSPI2_CODE_CELL, CL49_Constant(86), "LL_SBS_XSPI2_CODE_CELL")
        XCTAssertEqual(LL_SBS_XSPI2_CODE_REG, CL49_Constant(87), "LL_SBS_XSPI2_CODE_REG")
        XCTAssertEqual(LL_SBS_XSPI1_CODE_CELL, CL49_Constant(88), "LL_SBS_XSPI1_CODE_CELL")
        XCTAssertEqual(LL_SBS_XSPI1_CODE_REG, CL49_Constant(89), "LL_SBS_XSPI1_CODE_REG")
        XCTAssertEqual(LL_SBS_IO_CODE_CELL, CL49_Constant(90), "LL_SBS_IO_CODE_CELL")
        XCTAssertEqual(LL_SBS_IO_CODE_REG, CL49_Constant(91), "LL_SBS_IO_CODE_REG")
        XCTAssertEqual(LL_SBS_TIMBREAK_PVD, CL49_Constant(92), "LL_SBS_TIMBREAK_PVD")
        XCTAssertEqual(LL_SBS_TIMBREAK_FLASHECC, CL49_Constant(93), "LL_SBS_TIMBREAK_FLASHECC")
        XCTAssertEqual(LL_SBS_TIMBREAK_CM7LCKUP, CL49_Constant(94), "LL_SBS_TIMBREAK_CM7LCKUP")
        XCTAssertEqual(LL_SBS_TIMBREAK_BKRAMECC, CL49_Constant(95), "LL_SBS_TIMBREAK_BKRAMECC")
        XCTAssertEqual(LL_SBS_TIMBREAK_DTCMECC, CL49_Constant(96), "LL_SBS_TIMBREAK_DTCMECC")
        XCTAssertEqual(LL_SBS_TIMBREAK_ITCMECC, CL49_Constant(97), "LL_SBS_TIMBREAK_ITCMECC")
        XCTAssertEqual(LL_SBS_TIMBREAK_ARAM3ECC, CL49_Constant(98), "LL_SBS_TIMBREAK_ARAM3ECC")
        XCTAssertEqual(LL_SBS_TIMBREAK_ARAM1ECC, CL49_Constant(99), "LL_SBS_TIMBREAK_ARAM1ECC")
        XCTAssertEqual(LL_SBS_EXTI_PORTA, CL49_Constant(100), "LL_SBS_EXTI_PORTA")
        XCTAssertEqual(LL_SBS_EXTI_PORTB, CL49_Constant(101), "LL_SBS_EXTI_PORTB")
        XCTAssertEqual(LL_SBS_EXTI_PORTC, CL49_Constant(102), "LL_SBS_EXTI_PORTC")
        XCTAssertEqual(LL_SBS_EXTI_PORTD, CL49_Constant(103), "LL_SBS_EXTI_PORTD")
        XCTAssertEqual(LL_SBS_EXTI_PORTE, CL49_Constant(104), "LL_SBS_EXTI_PORTE")
        XCTAssertEqual(LL_SBS_EXTI_PORTF, CL49_Constant(105), "LL_SBS_EXTI_PORTF")
        XCTAssertEqual(LL_SBS_EXTI_PORTG, CL49_Constant(106), "LL_SBS_EXTI_PORTG")
        XCTAssertEqual(LL_SBS_EXTI_PORTH, CL49_Constant(107), "LL_SBS_EXTI_PORTH")
        XCTAssertEqual(LL_SBS_EXTI_PORTM, CL49_Constant(108), "LL_SBS_EXTI_PORTM")
        XCTAssertEqual(LL_SBS_EXTI_PORTN, CL49_Constant(109), "LL_SBS_EXTI_PORTN")
        XCTAssertEqual(LL_SBS_EXTI_PORTO, CL49_Constant(110), "LL_SBS_EXTI_PORTO")
        XCTAssertEqual(LL_SBS_EXTI_PORTP, CL49_Constant(111), "LL_SBS_EXTI_PORTP")
        XCTAssertEqual(LL_SBS_EXTI_LINE0, CL49_Constant(112), "LL_SBS_EXTI_LINE0")
        XCTAssertEqual(LL_SBS_EXTI_LINE1, CL49_Constant(113), "LL_SBS_EXTI_LINE1")
        XCTAssertEqual(LL_SBS_EXTI_LINE2, CL49_Constant(114), "LL_SBS_EXTI_LINE2")
        XCTAssertEqual(LL_SBS_EXTI_LINE3, CL49_Constant(115), "LL_SBS_EXTI_LINE3")
        XCTAssertEqual(LL_SBS_EXTI_LINE4, CL49_Constant(116), "LL_SBS_EXTI_LINE4")
        XCTAssertEqual(LL_SBS_EXTI_LINE5, CL49_Constant(117), "LL_SBS_EXTI_LINE5")
        XCTAssertEqual(LL_SBS_EXTI_LINE6, CL49_Constant(118), "LL_SBS_EXTI_LINE6")
        XCTAssertEqual(LL_SBS_EXTI_LINE7, CL49_Constant(119), "LL_SBS_EXTI_LINE7")
        XCTAssertEqual(LL_SBS_EXTI_LINE8, CL49_Constant(120), "LL_SBS_EXTI_LINE8")
        XCTAssertEqual(LL_SBS_EXTI_LINE9, CL49_Constant(121), "LL_SBS_EXTI_LINE9")
        XCTAssertEqual(LL_SBS_EXTI_LINE10, CL49_Constant(122), "LL_SBS_EXTI_LINE10")
        XCTAssertEqual(LL_SBS_EXTI_LINE11, CL49_Constant(123), "LL_SBS_EXTI_LINE11")
        XCTAssertEqual(LL_SBS_EXTI_LINE12, CL49_Constant(124), "LL_SBS_EXTI_LINE12")
        XCTAssertEqual(LL_SBS_EXTI_LINE13, CL49_Constant(125), "LL_SBS_EXTI_LINE13")
        XCTAssertEqual(LL_SBS_EXTI_LINE14, CL49_Constant(126), "LL_SBS_EXTI_LINE14")
        XCTAssertEqual(LL_SBS_EXTI_LINE15, CL49_Constant(127), "LL_SBS_EXTI_LINE15")
        XCTAssertEqual(LL_DBGMCU_DCRT_SYSTEM, CL49_Constant(128), "LL_DBGMCU_DCRT_SYSTEM")
        XCTAssertEqual(LL_DBGMCU_DCRT_POWER, CL49_Constant(129), "LL_DBGMCU_DCRT_POWER")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA0_STOP, CL49_Constant(130), "LL_DBGMCU_AHB5_GRP1_HPDMA0_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA1_STOP, CL49_Constant(131), "LL_DBGMCU_AHB5_GRP1_HPDMA1_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA2_STOP, CL49_Constant(132), "LL_DBGMCU_AHB5_GRP1_HPDMA2_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA3_STOP, CL49_Constant(133), "LL_DBGMCU_AHB5_GRP1_HPDMA3_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA4_STOP, CL49_Constant(134), "LL_DBGMCU_AHB5_GRP1_HPDMA4_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA5_STOP, CL49_Constant(135), "LL_DBGMCU_AHB5_GRP1_HPDMA5_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA6_STOP, CL49_Constant(136), "LL_DBGMCU_AHB5_GRP1_HPDMA6_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA7_STOP, CL49_Constant(137), "LL_DBGMCU_AHB5_GRP1_HPDMA7_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA8_STOP, CL49_Constant(138), "LL_DBGMCU_AHB5_GRP1_HPDMA8_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA9_STOP, CL49_Constant(139), "LL_DBGMCU_AHB5_GRP1_HPDMA9_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA10_STOP, CL49_Constant(140), "LL_DBGMCU_AHB5_GRP1_HPDMA10_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA11_STOP, CL49_Constant(141), "LL_DBGMCU_AHB5_GRP1_HPDMA11_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA12_STOP, CL49_Constant(142), "LL_DBGMCU_AHB5_GRP1_HPDMA12_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA13_STOP, CL49_Constant(143), "LL_DBGMCU_AHB5_GRP1_HPDMA13_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA14_STOP, CL49_Constant(144), "LL_DBGMCU_AHB5_GRP1_HPDMA14_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB5_GRP1_HPDMA15_STOP, CL49_Constant(145), "LL_DBGMCU_AHB5_GRP1_HPDMA15_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA0_STOP, CL49_Constant(146), "LL_DBGMCU_AHB1_GRP1_GPDMA0_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA1_STOP, CL49_Constant(147), "LL_DBGMCU_AHB1_GRP1_GPDMA1_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA2_STOP, CL49_Constant(148), "LL_DBGMCU_AHB1_GRP1_GPDMA2_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA3_STOP, CL49_Constant(149), "LL_DBGMCU_AHB1_GRP1_GPDMA3_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA4_STOP, CL49_Constant(150), "LL_DBGMCU_AHB1_GRP1_GPDMA4_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA5_STOP, CL49_Constant(151), "LL_DBGMCU_AHB1_GRP1_GPDMA5_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA6_STOP, CL49_Constant(152), "LL_DBGMCU_AHB1_GRP1_GPDMA6_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA7_STOP, CL49_Constant(153), "LL_DBGMCU_AHB1_GRP1_GPDMA7_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA8_STOP, CL49_Constant(154), "LL_DBGMCU_AHB1_GRP1_GPDMA8_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA9_STOP, CL49_Constant(155), "LL_DBGMCU_AHB1_GRP1_GPDMA9_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA10_STOP, CL49_Constant(156), "LL_DBGMCU_AHB1_GRP1_GPDMA10_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA11_STOP, CL49_Constant(157), "LL_DBGMCU_AHB1_GRP1_GPDMA11_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA12_STOP, CL49_Constant(158), "LL_DBGMCU_AHB1_GRP1_GPDMA12_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA13_STOP, CL49_Constant(159), "LL_DBGMCU_AHB1_GRP1_GPDMA13_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA14_STOP, CL49_Constant(160), "LL_DBGMCU_AHB1_GRP1_GPDMA14_STOP")
        XCTAssertEqual(LL_DBGMCU_AHB1_GRP1_GPDMA15_STOP, CL49_Constant(161), "LL_DBGMCU_AHB1_GRP1_GPDMA15_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM2_STOP, CL49_Constant(162), "LL_DBGMCU_APB1_GRP1_TIM2_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM3_STOP, CL49_Constant(163), "LL_DBGMCU_APB1_GRP1_TIM3_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM4_STOP, CL49_Constant(164), "LL_DBGMCU_APB1_GRP1_TIM4_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM5_STOP, CL49_Constant(165), "LL_DBGMCU_APB1_GRP1_TIM5_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM6_STOP, CL49_Constant(166), "LL_DBGMCU_APB1_GRP1_TIM6_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM7_STOP, CL49_Constant(167), "LL_DBGMCU_APB1_GRP1_TIM7_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM12_STOP, CL49_Constant(168), "LL_DBGMCU_APB1_GRP1_TIM12_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM13_STOP, CL49_Constant(169), "LL_DBGMCU_APB1_GRP1_TIM13_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_TIM14_STOP, CL49_Constant(170), "LL_DBGMCU_APB1_GRP1_TIM14_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_LPTIM1_STOP, CL49_Constant(171), "LL_DBGMCU_APB1_GRP1_LPTIM1_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_WWDG_STOP, CL49_Constant(172), "LL_DBGMCU_APB1_GRP1_WWDG_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_I2C1_STOP, CL49_Constant(173), "LL_DBGMCU_APB1_GRP1_I2C1_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_I2C2_STOP, CL49_Constant(174), "LL_DBGMCU_APB1_GRP1_I2C2_STOP")
        XCTAssertEqual(LL_DBGMCU_APB1_GRP1_I2C3_STOP, CL49_Constant(175), "LL_DBGMCU_APB1_GRP1_I2C3_STOP")
        XCTAssertEqual(LL_DBGMCU_APB2_GRP1_TIM1_STOP, CL49_Constant(176), "LL_DBGMCU_APB2_GRP1_TIM1_STOP")
        XCTAssertEqual(LL_DBGMCU_APB2_GRP1_TIM9_STOP, CL49_Constant(177), "LL_DBGMCU_APB2_GRP1_TIM9_STOP")
        XCTAssertEqual(LL_DBGMCU_APB2_GRP1_TIM15_STOP, CL49_Constant(178), "LL_DBGMCU_APB2_GRP1_TIM15_STOP")
        XCTAssertEqual(LL_DBGMCU_APB2_GRP1_TIM16_STOP, CL49_Constant(179), "LL_DBGMCU_APB2_GRP1_TIM16_STOP")
        XCTAssertEqual(LL_DBGMCU_APB2_GRP1_TIM17_STOP, CL49_Constant(180), "LL_DBGMCU_APB2_GRP1_TIM17_STOP")
        XCTAssertEqual(LL_DBGMCU_APB4_GRP1_LPTIM2_STOP, CL49_Constant(181), "LL_DBGMCU_APB4_GRP1_LPTIM2_STOP")
        XCTAssertEqual(LL_DBGMCU_APB4_GRP1_LPTIM3_STOP, CL49_Constant(182), "LL_DBGMCU_APB4_GRP1_LPTIM3_STOP")
        XCTAssertEqual(LL_DBGMCU_APB4_GRP1_LPTIM4_STOP, CL49_Constant(183), "LL_DBGMCU_APB4_GRP1_LPTIM4_STOP")
        XCTAssertEqual(LL_DBGMCU_APB4_GRP1_LPTIM5_STOP, CL49_Constant(184), "LL_DBGMCU_APB4_GRP1_LPTIM5_STOP")
        XCTAssertEqual(LL_DBGMCU_APB4_GRP1_IWDG_STOP, CL49_Constant(185), "LL_DBGMCU_APB4_GRP1_IWDG_STOP")
        XCTAssertEqual(LL_DBGMCU_APB4_GRP1_RTC_STOP, CL49_Constant(186), "LL_DBGMCU_APB4_GRP1_RTC_STOP")
        XCTAssertEqual(LL_VREFBUF_VOLTAGE_SCALE0, CL49_Constant(187), "LL_VREFBUF_VOLTAGE_SCALE0")
        XCTAssertEqual(LL_VREFBUF_VOLTAGE_SCALE1, CL49_Constant(188), "LL_VREFBUF_VOLTAGE_SCALE1")
        XCTAssertEqual(LL_VREFBUF_VOLTAGE_SCALE2, CL49_Constant(189), "LL_VREFBUF_VOLTAGE_SCALE2")
        XCTAssertEqual(LL_VREFBUF_VOLTAGE_SCALE3, CL49_Constant(190), "LL_VREFBUF_VOLTAGE_SCALE3")
        XCTAssertEqual(LL_FLASH_LATENCY_0, CL49_Constant(191), "LL_FLASH_LATENCY_0")
        XCTAssertEqual(LL_FLASH_LATENCY_1, CL49_Constant(192), "LL_FLASH_LATENCY_1")
        XCTAssertEqual(LL_FLASH_LATENCY_2, CL49_Constant(193), "LL_FLASH_LATENCY_2")
        XCTAssertEqual(LL_FLASH_LATENCY_3, CL49_Constant(194), "LL_FLASH_LATENCY_3")
        XCTAssertEqual(LL_FLASH_LATENCY_4, CL49_Constant(195), "LL_FLASH_LATENCY_4")
        XCTAssertEqual(LL_FLASH_LATENCY_5, CL49_Constant(196), "LL_FLASH_LATENCY_5")
        XCTAssertEqual(LL_FLASH_LATENCY_6, CL49_Constant(197), "LL_FLASH_LATENCY_6")
        XCTAssertEqual(LL_FLASH_LATENCY_7, CL49_Constant(198), "LL_FLASH_LATENCY_7")
        XCTAssertEqual(LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET, CL49_Constant(199), "LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET")
        XCTAssertEqual(LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK, CL49_Constant(200), "LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK")
        XCTAssertEqual(LL_PWR_SR_CSSF, CL49_Constant(201), "LL_PWR_SR_CSSF")
        XCTAssertEqual(LL_PWR_WKUPCR_WKUPC1, CL49_Constant(202), "LL_PWR_WKUPCR_WKUPC1")
        XCTAssertEqual(LL_PWR_WKUPCR_WKUPC2, CL49_Constant(203), "LL_PWR_WKUPCR_WKUPC2")
        XCTAssertEqual(LL_PWR_WKUPCR_WKUPC3, CL49_Constant(204), "LL_PWR_WKUPCR_WKUPC3")
        XCTAssertEqual(LL_PWR_WKUPCR_WKUPC4, CL49_Constant(205), "LL_PWR_WKUPCR_WKUPC4")
        XCTAssertEqual(LL_PWR_WKUPCR_WKUPC, CL49_Constant(206), "LL_PWR_WKUPCR_WKUPC")
        XCTAssertEqual(LL_PWR_FLAG_VOSRDY, CL49_Constant(207), "LL_PWR_FLAG_VOSRDY")
        XCTAssertEqual(LL_PWR_FLAG_STOPF, CL49_Constant(208), "LL_PWR_FLAG_STOPF")
        XCTAssertEqual(LL_PWR_FLAG_SBF, CL49_Constant(209), "LL_PWR_FLAG_SBF")
        XCTAssertEqual(LL_PWR_WAKEUP_FLAG1, CL49_Constant(210), "LL_PWR_WAKEUP_FLAG1")
        XCTAssertEqual(LL_PWR_WAKEUP_FLAG2, CL49_Constant(211), "LL_PWR_WAKEUP_FLAG2")
        XCTAssertEqual(LL_PWR_WAKEUP_FLAG3, CL49_Constant(212), "LL_PWR_WAKEUP_FLAG3")
        XCTAssertEqual(LL_PWR_WAKEUP_FLAG4, CL49_Constant(213), "LL_PWR_WAKEUP_FLAG4")
        XCTAssertEqual(LL_PWR_POWERDOWN_MODE_DS_STOP, CL49_Constant(214), "LL_PWR_POWERDOWN_MODE_DS_STOP")
        XCTAssertEqual(LL_PWR_POWERDOWN_MODE_DS_STANDBY, CL49_Constant(215), "LL_PWR_POWERDOWN_MODE_DS_STANDBY")
        XCTAssertEqual(LL_PWR_REGU_VOLTAGE_SCALE0, CL49_Constant(216), "LL_PWR_REGU_VOLTAGE_SCALE0")
        XCTAssertEqual(LL_PWR_REGU_VOLTAGE_SCALE1, CL49_Constant(217), "LL_PWR_REGU_VOLTAGE_SCALE1")
        XCTAssertEqual(LL_PWR_REGU_STOP_VOLTAGE_SCALE3, CL49_Constant(218), "LL_PWR_REGU_STOP_VOLTAGE_SCALE3")
        XCTAssertEqual(LL_PWR_REGU_STOP_VOLTAGE_SCALE5, CL49_Constant(219), "LL_PWR_REGU_STOP_VOLTAGE_SCALE5")
        XCTAssertEqual(LL_PWR_PVDLEVEL_1, CL49_Constant(220), "LL_PWR_PVDLEVEL_1")
        XCTAssertEqual(LL_PWR_PVDLEVEL_2, CL49_Constant(221), "LL_PWR_PVDLEVEL_2")
        XCTAssertEqual(LL_PWR_PVDLEVEL_3, CL49_Constant(222), "LL_PWR_PVDLEVEL_3")
        XCTAssertEqual(LL_PWR_PVDLEVEL_4, CL49_Constant(223), "LL_PWR_PVDLEVEL_4")
        XCTAssertEqual(LL_PWR_PVDLEVEL_5, CL49_Constant(224), "LL_PWR_PVDLEVEL_5")
        XCTAssertEqual(LL_PWR_PVDLEVEL_6, CL49_Constant(225), "LL_PWR_PVDLEVEL_6")
        XCTAssertEqual(LL_PWR_PVDLEVEL_7, CL49_Constant(226), "LL_PWR_PVDLEVEL_7")
        XCTAssertEqual(LL_PWR_PVDLEVEL_EXT, CL49_Constant(227), "LL_PWR_PVDLEVEL_EXT")
        XCTAssertEqual(LL_PWR_AVDLEVEL_1, CL49_Constant(228), "LL_PWR_AVDLEVEL_1")
        XCTAssertEqual(LL_PWR_AVDLEVEL_2, CL49_Constant(229), "LL_PWR_AVDLEVEL_2")
        XCTAssertEqual(LL_PWR_AVDLEVEL_3, CL49_Constant(230), "LL_PWR_AVDLEVEL_3")
        XCTAssertEqual(LL_PWR_AVDLEVEL_4, CL49_Constant(231), "LL_PWR_AVDLEVEL_4")
        XCTAssertEqual(LL_PWR_XSPI1_CAPACITOR_OFF, CL49_Constant(232), "LL_PWR_XSPI1_CAPACITOR_OFF")
        XCTAssertEqual(LL_PWR_XSPI1_CAPACITOR_1_DIV_3, CL49_Constant(233), "LL_PWR_XSPI1_CAPACITOR_1_DIV_3")
        XCTAssertEqual(LL_PWR_XSPI1_CAPACITOR_2_DIV_3, CL49_Constant(234), "LL_PWR_XSPI1_CAPACITOR_2_DIV_3")
        XCTAssertEqual(LL_PWR_XSPI1_CAPACITOR_FULL, CL49_Constant(235), "LL_PWR_XSPI1_CAPACITOR_FULL")
        XCTAssertEqual(LL_PWR_XSPI2_CAPACITOR_OFF, CL49_Constant(236), "LL_PWR_XSPI2_CAPACITOR_OFF")
        XCTAssertEqual(LL_PWR_XSPI2_CAPACITOR_1_DIV_3, CL49_Constant(237), "LL_PWR_XSPI2_CAPACITOR_1_DIV_3")
        XCTAssertEqual(LL_PWR_XSPI2_CAPACITOR_2_DIV_3, CL49_Constant(238), "LL_PWR_XSPI2_CAPACITOR_2_DIV_3")
        XCTAssertEqual(LL_PWR_XSPI2_CAPACITOR_FULL, CL49_Constant(239), "LL_PWR_XSPI2_CAPACITOR_FULL")
        XCTAssertEqual(LL_PWR_BATT_CHARG_RESISTOR_5K, CL49_Constant(240), "LL_PWR_BATT_CHARG_RESISTOR_5K")
        XCTAssertEqual(LL_PWR_BATT_CHARG_RESISTOR_1_5K, CL49_Constant(241), "LL_PWR_BATT_CHARG_RESISTOR_1_5K")
        XCTAssertEqual(LL_PWR_WAKEUP_PIN1, CL49_Constant(242), "LL_PWR_WAKEUP_PIN1")
        XCTAssertEqual(LL_PWR_WAKEUP_PIN2, CL49_Constant(243), "LL_PWR_WAKEUP_PIN2")
        XCTAssertEqual(LL_PWR_WAKEUP_PIN3, CL49_Constant(244), "LL_PWR_WAKEUP_PIN3")
        XCTAssertEqual(LL_PWR_WAKEUP_PIN4, CL49_Constant(245), "LL_PWR_WAKEUP_PIN4")
        XCTAssertEqual(LL_PWR_WAKEUP_PIN_NOPULL, CL49_Constant(246), "LL_PWR_WAKEUP_PIN_NOPULL")
        XCTAssertEqual(LL_PWR_WAKEUP_PIN_PULLUP, CL49_Constant(247), "LL_PWR_WAKEUP_PIN_PULLUP")
        XCTAssertEqual(LL_PWR_WAKEUP_PIN_PULLDOWN, CL49_Constant(248), "LL_PWR_WAKEUP_PIN_PULLDOWN")
        XCTAssertEqual(LL_PWR_LDO_SUPPLY, CL49_Constant(249), "LL_PWR_LDO_SUPPLY")
        XCTAssertEqual(LL_PWR_DIRECT_SMPS_SUPPLY, CL49_Constant(250), "LL_PWR_DIRECT_SMPS_SUPPLY")
        XCTAssertEqual(LL_PWR_SMPS_1V8_SUPPLIES_LDO, CL49_Constant(251), "LL_PWR_SMPS_1V8_SUPPLIES_LDO")
        XCTAssertEqual(LL_PWR_SMPS_1V8_SUPPLIES_EXT_AND_LDO, CL49_Constant(252), "LL_PWR_SMPS_1V8_SUPPLIES_EXT_AND_LDO")
        XCTAssertEqual(LL_PWR_SMPS_1V8_SUPPLIES_EXT, CL49_Constant(253), "LL_PWR_SMPS_1V8_SUPPLIES_EXT")
        XCTAssertEqual(LL_PWR_EXTERNAL_SOURCE_SUPPLY, CL49_Constant(254), "LL_PWR_EXTERNAL_SOURCE_SUPPLY")
        XCTAssertEqual(LL_PWR_GPIO_PIN_0, CL49_Constant(255), "LL_PWR_GPIO_PIN_0")
        XCTAssertEqual(LL_PWR_GPIO_PIN_1, CL49_Constant(256), "LL_PWR_GPIO_PIN_1")
        XCTAssertEqual(LL_PWR_GPIO_PIN_2, CL49_Constant(257), "LL_PWR_GPIO_PIN_2")
        XCTAssertEqual(LL_PWR_GPIO_PIN_3, CL49_Constant(258), "LL_PWR_GPIO_PIN_3")
        XCTAssertEqual(LL_PWR_GPIO_PIN_4, CL49_Constant(259), "LL_PWR_GPIO_PIN_4")
        XCTAssertEqual(LL_PWR_GPIO_PIN_5, CL49_Constant(260), "LL_PWR_GPIO_PIN_5")
        XCTAssertEqual(LL_PWR_GPIO_PIN_6, CL49_Constant(261), "LL_PWR_GPIO_PIN_6")
        XCTAssertEqual(LL_PWR_GPIO_PIN_7, CL49_Constant(262), "LL_PWR_GPIO_PIN_7")
        XCTAssertEqual(LL_PWR_GPIO_PIN_8, CL49_Constant(263), "LL_PWR_GPIO_PIN_8")
        XCTAssertEqual(LL_PWR_GPIO_PIN_9, CL49_Constant(264), "LL_PWR_GPIO_PIN_9")
        XCTAssertEqual(LL_PWR_GPIO_PIN_10, CL49_Constant(265), "LL_PWR_GPIO_PIN_10")
        XCTAssertEqual(LL_PWR_GPIO_PIN_11, CL49_Constant(266), "LL_PWR_GPIO_PIN_11")
        XCTAssertEqual(LL_PWR_GPIO_PIN_12, CL49_Constant(267), "LL_PWR_GPIO_PIN_12")
        XCTAssertEqual(LL_PWR_GPIO_PIN_13, CL49_Constant(268), "LL_PWR_GPIO_PIN_13")
        XCTAssertEqual(LL_PWR_GPIO_PIN_14, CL49_Constant(269), "LL_PWR_GPIO_PIN_14")
        XCTAssertEqual(LL_PWR_GPIO_PIN_15, CL49_Constant(270), "LL_PWR_GPIO_PIN_15")
    }
}
