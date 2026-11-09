import XCTest
import STM32H7RSHAL
import CLLReference

private struct LLClockAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}

private final class LLClockImage: LLClockUtilitiesRegisterIO, CRSRegisterIO, CortexRegisterIO, LLIdentificationRegisterIO, RCCSystemIO {
    var cells: [UInt32]
    var trace: [LLClockAccess] = []
    var reads: UInt32 = 0
    let salt: UInt32
    let mode: UInt32
    init(seed: UInt32, salt: UInt32, mode: UInt32) {
        cells = (0..<2304).map { seed ^ (UInt32($0) &* 0x9E3779B9) }
        self.salt = salt
        self.mode = mode
    }
    var oscillators: RCCOscillatorValues {
        let delta: UInt32 = mode & 4 != 0 ? 17 : 0
        return .init(hsi: 64_000_000 + delta, csi: 4_000_000 + delta, hse: 24_000_000 + delta,
                     lse: 32_768 + delta, lsi: 32_000 + delta, hsi48: 48_000_000 + delta, external: 12_288_000 + delta)
    }
    func readIndex(_ index: Int) -> UInt32 {
        if mode & 1 != 0 && reads % 3 == 2 {
            if index == 0 {
                let v = cells[0]
                cells[0] = (v & ~0x2A022124) | ((v & 0x15011080) << 1) | ((v & 1) << 2) | 0x20

            }
            if index == 4 { cells[4] = (cells[4] & ~0x38) | ((cells[4] & 7) << 3) }
        }
        var value = cells[index] ^ (salt &* reads)
        if mode & 1 != 0 && index == 1024 {
            value = (value & ~0x10000) | (reads % 3 == 2 ? 0x10000 : 0)
            cells[1024] &= ~0x10000
        }
        reads &+= 1
        precondition(trace.count < 1024)
        trace.append(.init(index: UInt32(index), value: value, kind: 0))
        return value
    }
    func writeIndex(_ index: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(index), value: value, kind: 1))
        cells[index] = mode & 2 != 0 && index == 512 ? (value & ~15) | (cells[index] & 15) : value
    }
    func getSystemCoreClock() -> UInt32 {
        trace.append(.init(index: 2100, value: cells[2100], kind: 2))
        return cells[2100]
    }
    func setSystemCoreClock(_ frequency: UInt32) {
        trace.append(.init(index: 2100, value: frequency, kind: 3))
        cells[2100] = frequency
    }
    func getTick() -> UInt32 { preconditionFailure("Not used") }
    func getTickPriority() -> UInt32 { preconditionFailure("Not used") }
    func initializeTick(priority: UInt32, coreClockHz: UInt32) -> HALStatus { preconditionFailure("Not used") }
    func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration) { preconditionFailure("Not used") }
    func setPriorityGrouping(_ group: UInt32) { preconditionFailure("Not used") }
    func readPriority(_ register: CortexPriorityRegister) -> UInt8 { preconditionFailure("Not used") }
    func writePriority(_ register: CortexPriorityRegister, value: UInt8) { preconditionFailure("Not used") }
    func perform(_ instruction: CortexInstruction) { preconditionFailure("Not used") }
    func read(_ r: EXTIRegister) -> UInt32 { preconditionFailure("Not used") }
    func write(_ r: EXTIRegister, value: UInt32) { preconditionFailure("Not used") }
    func read(_ r: HALRegister) -> UInt32 {
        guard case .uniqueIDWord(let index) = r else { preconditionFailure("Not used") }
        return readIndex(2048 + index)
    }
    func write(_ r: HALRegister, value: UInt32) { preconditionFailure("Not used") }
    func read(_ r: LLIdentificationRegister) -> UInt32 { readIndex(2051) }
    func read(_ r: PowerExtendedRegister) -> UInt32 {
        precondition(r == .csr4)
        return readIndex(773)
    }
    func write(_ r: PowerExtendedRegister, value: UInt32) { preconditionFailure("Not used") }
    func index(_ r: RCCClockRegister) -> Int {
        switch r {
        case .apbcfgr: return 8
        case .bmcfgr: return 7
        case .cdcfgr: return 6
        case .cfgr: return 4
        case .cr: return 0
        case .pll1divr1: return 12
        case .pll1divr2: return 48
        case .pll1fracr: return 13
        case .pll2divr1: return 14
        case .pll2divr2: return 49
        case .pll2fracr: return 15
        case .pll3divr1: return 16
        case .pll3divr2: return 50
        case .pll3fracr: return 17
        case .pllcfgr: return 11
        case .pllckselr: return 10
        }
    }
    func read(_ r: RCCClockRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: RCCClockRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: RCCExtendedRegister) -> Int {
        switch r {
        case .ccipr1: return 19
        case .ccipr2: return 20
        case .ccipr3: return 21
        case .ccipr4: return 22
        case .ckprotr: return 64
        }
    }
    func read(_ r: RCCExtendedRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: RCCExtendedRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: RCCControlRegister) -> Int {
        switch r {
        case .bdcr: return 28
        case .cicr: return 26
        case .cier: return 24
        case .cifr: return 25
        case .csr: return 29
        case .hsicfgr: return 1
        case .rsr: return 76
        default: preconditionFailure("Unused register")
        }
    }
    func read(_ r: RCCControlRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: RCCControlRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: LLRCCRegister) -> Int {
        switch r {
        case .crrcr: return 2
        case .csicfgr: return 3
        case .pll1sscgr: return 51
        case .pll2sscgr: return 52
        case .pll3sscgr: return 53
        }
    }
    func read(_ r: LLRCCRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: LLRCCRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: LLBusRegister) -> Int {
        switch r {
        case .ahb1lpenr: return 88
        case .apb1rstr2: return 37
        default: preconditionFailure("Unused register")
        }
    }
    func read(_ r: LLBusRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: LLBusRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: FlashTimingRegister) -> Int {
        switch r {
        case .acr: return 512
        }
    }
    func read(_ r: FlashTimingRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: FlashTimingRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: CRSRegister) -> Int {
        switch r {
        case .cfgr: return 257
        case .cr: return 256
        case .icr: return 259
        case .isr: return 258
        default: preconditionFailure("Unused register")
        }
    }
    func read(_ r: CRSRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: CRSRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: CortexRegister) -> Int {
        switch r {
        case .sysTickControl: return 1024
        case .sysTickCurrent: return 1026
        case .sysTickReload: return 1025
        default: preconditionFailure("Unused register")
        }
    }
    func read(_ r: CortexRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: CortexRegister, value: UInt32) { writeIndex(index(r), value) }
}

private func runLLClock(_ op: Int, _ io: inout LLClockImage, _ args: [UInt32]) -> UInt32 {
    switch op {
    case 0:
        LL_RCC_HSE_EnableCSS(&io)
        return 0
    case 1:
        LL_RCC_HSE_EnableBypass(&io)
        return 0
    case 2:
        LL_RCC_HSE_DisableBypass(&io)
        return 0
    case 3:
        LL_RCC_HSE_SelectAnalogClock(&io)
        return 0
    case 4:
        LL_RCC_HSE_SelectDigitalClock(&io)
        return 0
    case 5:
        LL_RCC_HSE_Enable(&io)
        return 0
    case 6:
        LL_RCC_HSE_Disable(&io)
        return 0
    case 7:
        let result = LL_RCC_HSE_IsReady(&io)
        return result
    case 8:
        LL_RCC_HSI_Enable(&io)
        return 0
    case 9:
        LL_RCC_HSI_Disable(&io)
        return 0
    case 10:
        let result = LL_RCC_HSI_IsReady(&io)
        return result
    case 11:
        let result = LL_RCC_HSI_IsDividerReady(&io)
        return result
    case 12:
        LL_RCC_HSI_SetDivider(&io, args[0])
        return 0
    case 13:
        let result = LL_RCC_HSI_GetDivider(&io)
        return result
    case 14:
        LL_RCC_HSI_EnableStopMode(&io)
        return 0
    case 15:
        LL_RCC_HSI_DisableStopMode(&io)
        return 0
    case 16:
        let result = LL_RCC_HSI_IsEnabledStopMode(&io)
        return result
    case 17:
        LL_RCC_EnableXSPIClockProtection(&io)
        return 0
    case 18:
        LL_RCC_DisableXSPIClockProtection(&io)
        return 0
    case 19:
        let result = LL_RCC_IsEnabledXSPIClockProtection(&io)
        return result
    case 20:
        LL_RCC_EnableFMCClockProtection(&io)
        return 0
    case 21:
        LL_RCC_DisableFMCClockProtection(&io)
        return 0
    case 22:
        let result = LL_RCC_IsEnabledFMCClockProtection(&io)
        return result
    case 23:
        let result = LL_RCC_GetXSPI2SwitchPosition(&io)
        return result
    case 24:
        let result = LL_RCC_GetXSPI1SwitchPosition(&io)
        return result
    case 25:
        let result = LL_RCC_GetFMCSwitchPosition(&io)
        return result
    case 26:
        let result = LL_RCC_HSI_GetCalibration(&io)
        return result
    case 27:
        LL_RCC_HSI_SetCalibTrimming(&io, args[0])
        return 0
    case 28:
        let result = LL_RCC_HSI_GetCalibTrimming(&io)
        return result
    case 29:
        LL_RCC_CSI_Enable(&io)
        return 0
    case 30:
        LL_RCC_CSI_Disable(&io)
        return 0
    case 31:
        let result = LL_RCC_CSI_IsReady(&io)
        return result
    case 32:
        LL_RCC_CSI_EnableStopMode(&io)
        return 0
    case 33:
        LL_RCC_CSI_DisableStopMode(&io)
        return 0
    case 34:
        let result = LL_RCC_CSI_IsEnabledStopMode(&io)
        return result
    case 35:
        let result = LL_RCC_CSI_GetCalibration(&io)
        return result
    case 36:
        LL_RCC_CSI_SetCalibTrimming(&io, args[0])
        return 0
    case 37:
        let result = LL_RCC_CSI_GetCalibTrimming(&io)
        return result
    case 38:
        LL_RCC_HSI48_Enable(&io)
        return 0
    case 39:
        LL_RCC_HSI48_Disable(&io)
        return 0
    case 40:
        let result = LL_RCC_HSI48_IsReady(&io)
        return result
    case 41:
        let result = LL_RCC_HSI48_GetCalibration(&io)
        return result
    case 42:
        LL_RCC_LSE_EnableCSS(&io)
        return 0
    case 43:
        LL_RCC_LSE_DisableCSS(&io)
        return 0
    case 44:
        let result = LL_RCC_LSE_IsFailureDetected(&io)
        return result
    case 45:
        LL_RCC_LSE_ReArmCSS(&io)
        return 0
    case 46:
        LL_RCC_LSE_Enable(&io)
        return 0
    case 47:
        LL_RCC_LSE_Disable(&io)
        return 0
    case 48:
        LL_RCC_LSE_EnableBypass(&io)
        return 0
    case 49:
        LL_RCC_LSE_DisableBypass(&io)
        return 0
    case 50:
        LL_RCC_LSE_SelectDigitalClock(&io)
        return 0
    case 51:
        LL_RCC_LSE_SelectAnalogClock(&io)
        return 0
    case 52:
        LL_RCC_LSE_SetDriveCapability(&io, args[0])
        return 0
    case 53:
        let result = LL_RCC_LSE_GetDriveCapability(&io)
        return result
    case 54:
        let result = LL_RCC_LSE_IsReady(&io)
        return result
    case 55:
        LL_RCC_LSI_Enable(&io)
        return 0
    case 56:
        LL_RCC_LSI_Disable(&io)
        return 0
    case 57:
        let result = LL_RCC_LSI_IsReady(&io)
        return result
    case 58:
        LL_RCC_SetSysClkSource(&io, args[0])
        return 0
    case 59:
        let result = LL_RCC_GetSysClkSource(&io)
        return result
    case 60:
        LL_RCC_SetSysWakeUpClkSource(&io, args[0])
        return 0
    case 61:
        let result = LL_RCC_GetSysWakeUpClkSource(&io)
        return result
    case 62:
        LL_RCC_SetKerWakeUpClkSource(&io, args[0])
        return 0
    case 63:
        let result = LL_RCC_GetKerWakeUpClkSource(&io)
        return result
    case 64:
        LL_RCC_SetSysPrescaler(&io, args[0])
        return 0
    case 65:
        LL_RCC_SetAHBPrescaler(&io, args[0])
        return 0
    case 66:
        LL_RCC_SetAPB1Prescaler(&io, args[0])
        return 0
    case 67:
        LL_RCC_SetAPB2Prescaler(&io, args[0])
        return 0
    case 68:
        LL_RCC_SetAPB4Prescaler(&io, args[0])
        return 0
    case 69:
        LL_RCC_SetAPB5Prescaler(&io, args[0])
        return 0
    case 70:
        let result = LL_RCC_GetSysPrescaler(&io)
        return result
    case 71:
        let result = LL_RCC_GetAHBPrescaler(&io)
        return result
    case 72:
        let result = LL_RCC_GetAPB1Prescaler(&io)
        return result
    case 73:
        let result = LL_RCC_GetAPB2Prescaler(&io)
        return result
    case 74:
        let result = LL_RCC_GetAPB4Prescaler(&io)
        return result
    case 75:
        let result = LL_RCC_GetAPB5Prescaler(&io)
        return result
    case 76:
        LL_RCC_ConfigMCO(&io, args[0], args[1])
        return 0
    case 77:
        LL_RCC_SetClockSource(&io, args[0])
        return 0
    case 78:
        LL_RCC_SetADCClockSource(&io, args[0])
        return 0
    case 79:
        LL_RCC_SetADFClockSource(&io, args[0])
        return 0
    case 80:
        LL_RCC_SetCECClockSource(&io, args[0])
        return 0
    case 81:
        LL_RCC_SetCLKPClockSource(&io, args[0])
        return 0
    case 82:
        LL_RCC_SetETHPHYClockSource(&io, args[0])
        return 0
    case 83:
        LL_RCC_SetETHREFClockSource(&io, args[0])
        return 0
    case 84:
        LL_RCC_SetFDCANClockSource(&io, args[0])
        return 0
    case 85:
        LL_RCC_SetFMCClockSource(&io, args[0])
        return 0
    case 86:
        LL_RCC_SetI2CClockSource(&io, args[0])
        return 0
    case 87:
        LL_RCC_SetI3CClockSource(&io, args[0])
        return 0
    case 88:
        LL_RCC_SetLPTIMClockSource(&io, args[0])
        return 0
    case 89:
        LL_RCC_SetLPUARTClockSource(&io, args[0])
        return 0
    case 90:
        LL_RCC_SetOTGFSClockSource(&io, args[0])
        return 0
    case 91:
        LL_RCC_SetXSPIClockSource(&io, args[0])
        return 0
    case 92:
        LL_RCC_SetPSSIClockSource(&io, args[0])
        return 0
    case 93:
        LL_RCC_SetSAIClockSource(&io, args[0])
        return 0
    case 94:
        LL_RCC_SetSDMMCClockSource(&io, args[0])
        return 0
    case 95:
        LL_RCC_SetSPDIFRXClockSource(&io, args[0])
        return 0
    case 96:
        LL_RCC_SetSPIClockSource(&io, args[0])
        return 0
    case 97:
        LL_RCC_SetUSARTClockSource(&io, args[0])
        return 0
    case 98:
        LL_RCC_SetUSBPHYCClockSource(&io, args[0])
        return 0
    case 99:
        LL_RCC_SetUSBREFClockSource(&io, args[0])
        return 0
    case 100:
        let result = LL_RCC_GetClockSource(&io, args[0])
        return result
    case 101:
        let result = LL_RCC_GetADCClockSource(&io, args[0])
        return result
    case 102:
        let result = LL_RCC_GetADFClockSource(&io, args[0])
        return result
    case 103:
        let result = LL_RCC_GetCECClockSource(&io, args[0])
        return result
    case 104:
        let result = LL_RCC_GetCLKPClockSource(&io, args[0])
        return result
    case 105:
        let result = LL_RCC_GetETHPHYClockSource(&io, args[0])
        return result
    case 106:
        let result = LL_RCC_GetETHREFClockSource(&io, args[0])
        return result
    case 107:
        let result = LL_RCC_GetFDCANClockSource(&io, args[0])
        return result
    case 108:
        let result = LL_RCC_GetFMCClockSource(&io, args[0])
        return result
    case 109:
        let result = LL_RCC_GetI2CClockSource(&io, args[0])
        return result
    case 110:
        let result = LL_RCC_GetI3CClockSource(&io, args[0])
        return result
    case 111:
        let result = LL_RCC_GetLPTIMClockSource(&io, args[0])
        return result
    case 112:
        let result = LL_RCC_GetLPUARTClockSource(&io, args[0])
        return result
    case 113:
        let result = LL_RCC_GetOTGFSClockSource(&io, args[0])
        return result
    case 114:
        let result = LL_RCC_GetXSPIClockSource(&io, args[0])
        return result
    case 115:
        let result = LL_RCC_GetPSSIClockSource(&io, args[0])
        return result
    case 116:
        let result = LL_RCC_GetSAIClockSource(&io, args[0])
        return result
    case 117:
        let result = LL_RCC_GetSDMMCClockSource(&io, args[0])
        return result
    case 118:
        let result = LL_RCC_GetSPDIFRXClockSource(&io, args[0])
        return result
    case 119:
        let result = LL_RCC_GetSPIClockSource(&io, args[0])
        return result
    case 120:
        let result = LL_RCC_GetUSARTClockSource(&io, args[0])
        return result
    case 121:
        let result = LL_RCC_GetUSBPHYCClockSource(&io, args[0])
        return result
    case 122:
        let result = LL_RCC_GetUSBREFClockSource(&io, args[0])
        return result
    case 123:
        LL_RCC_SetRTCClockSource(&io, args[0])
        return 0
    case 124:
        let result = LL_RCC_GetRTCClockSource(&io)
        return result
    case 125:
        LL_RCC_EnableRTC(&io)
        return 0
    case 126:
        LL_RCC_DisableRTC(&io)
        return 0
    case 127:
        let result = LL_RCC_IsEnabledRTC(&io)
        return result
    case 128:
        LL_RCC_ForceBackupDomainReset(&io)
        return 0
    case 129:
        LL_RCC_ReleaseBackupDomainReset(&io)
        return 0
    case 130:
        LL_RCC_SetRTC_HSEPrescaler(&io, args[0])
        return 0
    case 131:
        let result = LL_RCC_GetRTC_HSEPrescaler(&io)
        return result
    case 132:
        LL_RCC_SetTIMPrescaler(&io, args[0])
        return 0
    case 133:
        let result = LL_RCC_GetTIMPrescaler(&io)
        return result
    case 134:
        LL_RCC_USBPHYC_EnablePowerDown(&io)
        return 0
    case 135:
        LL_RCC_USBPHYC_DisablePowerDown(&io)
        return 0
    case 136:
        let result = LL_RCC_USBPHYC_IsEnabledPowerDown(&io)
        return result
    case 137:
        LL_RCC_PLL_SetSource(&io, args[0])
        return 0
    case 138:
        let result = LL_RCC_PLL_GetSource(&io)
        return result
    case 139:
        LL_RCC_PLL1_Enable(&io)
        return 0
    case 140:
        LL_RCC_PLL1_Disable(&io)
        return 0
    case 141:
        let result = LL_RCC_PLL1_IsReady(&io)
        return result
    case 142:
        LL_RCC_PLL1_ConfigDomain_SYS(&io, args[0], args[1], args[2], args[3])
        return 0
    case 143:
        LL_RCC_PLL1P_Enable(&io)
        return 0
    case 144:
        LL_RCC_PLL1Q_Enable(&io)
        return 0
    case 145:
        LL_RCC_PLL1R_Enable(&io)
        return 0
    case 146:
        LL_RCC_PLL1S_Enable(&io)
        return 0
    case 147:
        LL_RCC_PLL1FRACN_Enable(&io)
        return 0
    case 148:
        let result = LL_RCC_PLL1P_IsEnabled(&io)
        return result
    case 149:
        let result = LL_RCC_PLL1Q_IsEnabled(&io)
        return result
    case 150:
        let result = LL_RCC_PLL1R_IsEnabled(&io)
        return result
    case 151:
        let result = LL_RCC_PLL1S_IsEnabled(&io)
        return result
    case 152:
        let result = LL_RCC_PLL1FRACN_IsEnabled(&io)
        return result
    case 153:
        LL_RCC_PLL1P_Disable(&io)
        return 0
    case 154:
        LL_RCC_PLL1Q_Disable(&io)
        return 0
    case 155:
        LL_RCC_PLL1R_Disable(&io)
        return 0
    case 156:
        LL_RCC_PLL1S_Disable(&io)
        return 0
    case 157:
        LL_RCC_PLL1FRACN_Disable(&io)
        return 0
    case 158:
        let result = LL_RCC_PLL1_GetVCOInputRange(&io)
        return result
    case 159:
        let result = LL_RCC_PLL1_GetVCOOutputRange(&io)
        return result
    case 160:
        LL_RCC_PLL1_SetVCOInputRange(&io, args[0])
        return 0
    case 161:
        LL_RCC_PLL1_SetVCOOutputRange(&io, args[0])
        return 0
    case 162:
        let result = LL_RCC_PLL1_GetN(&io)
        return result
    case 163:
        let result = LL_RCC_PLL1_GetM(&io)
        return result
    case 164:
        let result = LL_RCC_PLL1_GetP(&io)
        return result
    case 165:
        let result = LL_RCC_PLL1_GetQ(&io)
        return result
    case 166:
        let result = LL_RCC_PLL1_GetR(&io)
        return result
    case 167:
        let result = LL_RCC_PLL1_GetS(&io)
        return result
    case 168:
        let result = LL_RCC_PLL1_GetFRACN(&io)
        return result
    case 169:
        LL_RCC_PLL1_SetN(&io, args[0])
        return 0
    case 170:
        LL_RCC_PLL1_SetM(&io, args[0])
        return 0
    case 171:
        LL_RCC_PLL1_SetP(&io, args[0])
        return 0
    case 172:
        LL_RCC_PLL1_SetQ(&io, args[0])
        return 0
    case 173:
        LL_RCC_PLL1_SetR(&io, args[0])
        return 0
    case 174:
        LL_RCC_PLL1_SetS(&io, args[0])
        return 0
    case 175:
        LL_RCC_PLL1_SetFRACN(&io, args[0])
        return 0
    case 176:
        LL_RCC_PLL1_EnableSpreadSpectrum(&io)
        return 0
    case 177:
        LL_RCC_PLL1_DisableSpreadSpectrum(&io)
        return 0
    case 178:
        let result = LL_RCC_PLL1_IsEnabledSpreadSpectrum(&io)
        return result
    case 179:
        let result = LL_RCC_PLL1_GetModulationPeriod(&io)
        return result
    case 180:
        let result = LL_RCC_PLL1_GetIncrementStep(&io)
        return result
    case 181:
        let result = LL_RCC_PLL1_GetSpreadSelection(&io)
        return result
    case 182:
        let result = LL_RCC_PLL1_IsEnabledRPDFNDithering(&io)
        return result
    case 183:
        let result = LL_RCC_PLL1_IsEnabledTPDFNDithering(&io)
        return result
    case 184:
        LL_RCC_PLL2_Enable(&io)
        return 0
    case 185:
        LL_RCC_PLL2_Disable(&io)
        return 0
    case 186:
        let result = LL_RCC_PLL2_IsReady(&io)
        return result
    case 187:
        LL_RCC_PLL2P_Enable(&io)
        return 0
    case 188:
        LL_RCC_PLL2Q_Enable(&io)
        return 0
    case 189:
        LL_RCC_PLL2R_Enable(&io)
        return 0
    case 190:
        LL_RCC_PLL2S_Enable(&io)
        return 0
    case 191:
        LL_RCC_PLL2T_Enable(&io)
        return 0
    case 192:
        LL_RCC_PLL2FRACN_Enable(&io)
        return 0
    case 193:
        let result = LL_RCC_PLL2P_IsEnabled(&io)
        return result
    case 194:
        let result = LL_RCC_PLL2Q_IsEnabled(&io)
        return result
    case 195:
        let result = LL_RCC_PLL2R_IsEnabled(&io)
        return result
    case 196:
        let result = LL_RCC_PLL2S_IsEnabled(&io)
        return result
    case 197:
        let result = LL_RCC_PLL2T_IsEnabled(&io)
        return result
    case 198:
        let result = LL_RCC_PLL2FRACN_IsEnabled(&io)
        return result
    case 199:
        LL_RCC_PLL2P_Disable(&io)
        return 0
    case 200:
        LL_RCC_PLL2Q_Disable(&io)
        return 0
    case 201:
        LL_RCC_PLL2R_Disable(&io)
        return 0
    case 202:
        LL_RCC_PLL2S_Disable(&io)
        return 0
    case 203:
        LL_RCC_PLL2T_Disable(&io)
        return 0
    case 204:
        LL_RCC_PLL2FRACN_Disable(&io)
        return 0
    case 205:
        let result = LL_RCC_PLL2_GetVCOInputRange(&io)
        return result
    case 206:
        let result = LL_RCC_PLL2_GetVCOOutputRange(&io)
        return result
    case 207:
        LL_RCC_PLL2_SetVCOInputRange(&io, args[0])
        return 0
    case 208:
        LL_RCC_PLL2_SetVCOOutputRange(&io, args[0])
        return 0
    case 209:
        let result = LL_RCC_PLL2_GetN(&io)
        return result
    case 210:
        let result = LL_RCC_PLL2_GetM(&io)
        return result
    case 211:
        let result = LL_RCC_PLL2_GetP(&io)
        return result
    case 212:
        let result = LL_RCC_PLL2_GetQ(&io)
        return result
    case 213:
        let result = LL_RCC_PLL2_GetR(&io)
        return result
    case 214:
        let result = LL_RCC_PLL2_GetS(&io)
        return result
    case 215:
        let result = LL_RCC_PLL2_GetT(&io)
        return result
    case 216:
        let result = LL_RCC_PLL2_GetFRACN(&io)
        return result
    case 217:
        LL_RCC_PLL2_SetN(&io, args[0])
        return 0
    case 218:
        LL_RCC_PLL2_SetM(&io, args[0])
        return 0
    case 219:
        LL_RCC_PLL2_SetP(&io, args[0])
        return 0
    case 220:
        LL_RCC_PLL2_SetQ(&io, args[0])
        return 0
    case 221:
        LL_RCC_PLL2_SetR(&io, args[0])
        return 0
    case 222:
        LL_RCC_PLL2_SetS(&io, args[0])
        return 0
    case 223:
        LL_RCC_PLL2_SetT(&io, args[0])
        return 0
    case 224:
        LL_RCC_PLL2_SetFRACN(&io, args[0])
        return 0
    case 225:
        LL_RCC_PLL2_EnableSpreadSpectrum(&io)
        return 0
    case 226:
        LL_RCC_PLL2_DisableSpreadSpectrum(&io)
        return 0
    case 227:
        let result = LL_RCC_PLL2_IsEnabledSpreadSpectrum(&io)
        return result
    case 228:
        let result = LL_RCC_PLL2_GetModulationPeriod(&io)
        return result
    case 229:
        let result = LL_RCC_PLL2_GetIncrementStep(&io)
        return result
    case 230:
        let result = LL_RCC_PLL2_GetSpreadSelection(&io)
        return result
    case 231:
        let result = LL_RCC_PLL2_IsEnabledRPDFNDithering(&io)
        return result
    case 232:
        let result = LL_RCC_PLL2_IsEnabledTPDFNDithering(&io)
        return result
    case 233:
        LL_RCC_PLL3_Enable(&io)
        return 0
    case 234:
        LL_RCC_PLL3_Disable(&io)
        return 0
    case 235:
        let result = LL_RCC_PLL3_IsReady(&io)
        return result
    case 236:
        LL_RCC_PLL3P_Enable(&io)
        return 0
    case 237:
        LL_RCC_PLL3Q_Enable(&io)
        return 0
    case 238:
        LL_RCC_PLL3R_Enable(&io)
        return 0
    case 239:
        LL_RCC_PLL3S_Enable(&io)
        return 0
    case 240:
        LL_RCC_PLL3FRACN_Enable(&io)
        return 0
    case 241:
        let result = LL_RCC_PLL3P_IsEnabled(&io)
        return result
    case 242:
        let result = LL_RCC_PLL3Q_IsEnabled(&io)
        return result
    case 243:
        let result = LL_RCC_PLL3R_IsEnabled(&io)
        return result
    case 244:
        let result = LL_RCC_PLL3S_IsEnabled(&io)
        return result
    case 245:
        let result = LL_RCC_PLL3FRACN_IsEnabled(&io)
        return result
    case 246:
        LL_RCC_PLL3P_Disable(&io)
        return 0
    case 247:
        LL_RCC_PLL3Q_Disable(&io)
        return 0
    case 248:
        LL_RCC_PLL3R_Disable(&io)
        return 0
    case 249:
        LL_RCC_PLL3S_Disable(&io)
        return 0
    case 250:
        LL_RCC_PLL3FRACN_Disable(&io)
        return 0
    case 251:
        let result = LL_RCC_PLL3_GetVCOInputRange(&io)
        return result
    case 252:
        let result = LL_RCC_PLL3_GetVCOOutputRange(&io)
        return result
    case 253:
        LL_RCC_PLL3_SetVCOInputRange(&io, args[0])
        return 0
    case 254:
        LL_RCC_PLL3_SetVCOOutputRange(&io, args[0])
        return 0
    case 255:
        let result = LL_RCC_PLL3_GetN(&io)
        return result
    case 256:
        let result = LL_RCC_PLL3_GetM(&io)
        return result
    case 257:
        let result = LL_RCC_PLL3_GetP(&io)
        return result
    case 258:
        let result = LL_RCC_PLL3_GetQ(&io)
        return result
    case 259:
        let result = LL_RCC_PLL3_GetR(&io)
        return result
    case 260:
        let result = LL_RCC_PLL3_GetS(&io)
        return result
    case 261:
        let result = LL_RCC_PLL3_GetFRACN(&io)
        return result
    case 262:
        LL_RCC_PLL3_SetN(&io, args[0])
        return 0
    case 263:
        LL_RCC_PLL3_SetM(&io, args[0])
        return 0
    case 264:
        LL_RCC_PLL3_SetP(&io, args[0])
        return 0
    case 265:
        LL_RCC_PLL3_SetQ(&io, args[0])
        return 0
    case 266:
        LL_RCC_PLL3_SetR(&io, args[0])
        return 0
    case 267:
        LL_RCC_PLL3_SetS(&io, args[0])
        return 0
    case 268:
        LL_RCC_PLL3_SetFRACN(&io, args[0])
        return 0
    case 269:
        LL_RCC_PLL3_EnableSpreadSpectrum(&io)
        return 0
    case 270:
        LL_RCC_PLL3_DisableSpreadSpectrum(&io)
        return 0
    case 271:
        let result = LL_RCC_PLL3_IsEnabledSpreadSpectrum(&io)
        return result
    case 272:
        let result = LL_RCC_PLL3_GetModulationPeriod(&io)
        return result
    case 273:
        let result = LL_RCC_PLL3_GetIncrementStep(&io)
        return result
    case 274:
        let result = LL_RCC_PLL3_GetSpreadSelection(&io)
        return result
    case 275:
        let result = LL_RCC_PLL3_IsEnabledRPDFNDithering(&io)
        return result
    case 276:
        let result = LL_RCC_PLL3_IsEnabledTPDFNDithering(&io)
        return result
    case 277:
        LL_RCC_ClearFlag_LSIRDY(&io)
        return 0
    case 278:
        LL_RCC_ClearFlag_LSERDY(&io)
        return 0
    case 279:
        LL_RCC_ClearFlag_HSIRDY(&io)
        return 0
    case 280:
        LL_RCC_ClearFlag_HSERDY(&io)
        return 0
    case 281:
        LL_RCC_ClearFlag_CSIRDY(&io)
        return 0
    case 282:
        LL_RCC_ClearFlag_HSI48RDY(&io)
        return 0
    case 283:
        LL_RCC_ClearFlag_PLL1RDY(&io)
        return 0
    case 284:
        LL_RCC_ClearFlag_PLL2RDY(&io)
        return 0
    case 285:
        LL_RCC_ClearFlag_PLL3RDY(&io)
        return 0
    case 286:
        LL_RCC_ClearFlag_LSECSS(&io)
        return 0
    case 287:
        LL_RCC_ClearFlag_HSECSS(&io)
        return 0
    case 288:
        let result = LL_RCC_IsActiveFlag_LSIRDY(&io)
        return result
    case 289:
        let result = LL_RCC_IsActiveFlag_LSERDY(&io)
        return result
    case 290:
        let result = LL_RCC_IsActiveFlag_HSIRDY(&io)
        return result
    case 291:
        let result = LL_RCC_IsActiveFlag_HSERDY(&io)
        return result
    case 292:
        let result = LL_RCC_IsActiveFlag_CSIRDY(&io)
        return result
    case 293:
        let result = LL_RCC_IsActiveFlag_HSI48RDY(&io)
        return result
    case 294:
        let result = LL_RCC_IsActiveFlag_PLL1RDY(&io)
        return result
    case 295:
        let result = LL_RCC_IsActiveFlag_PLL2RDY(&io)
        return result
    case 296:
        let result = LL_RCC_IsActiveFlag_PLL3RDY(&io)
        return result
    case 297:
        let result = LL_RCC_IsActiveFlag_LSECSS(&io)
        return result
    case 298:
        let result = LL_RCC_IsActiveFlag_HSECSS(&io)
        return result
    case 299:
        let result = LL_RCC_IsActiveFlag_LPWRRST(&io)
        return result
    case 300:
        let result = LL_RCC_IsActiveFlag_WWDGRST(&io)
        return result
    case 301:
        let result = LL_RCC_IsActiveFlag_IWDGRST(&io)
        return result
    case 302:
        let result = LL_RCC_IsActiveFlag_SFTRST(&io)
        return result
    case 303:
        let result = LL_RCC_IsActiveFlag_PORRST(&io)
        return result
    case 304:
        let result = LL_RCC_IsActiveFlag_PINRST(&io)
        return result
    case 305:
        let result = LL_RCC_IsActiveFlag_BORRST(&io)
        return result
    case 306:
        LL_RCC_ClearResetFlags(&io)
        return 0
    case 307:
        LL_RCC_EnableIT_LSIRDY(&io)
        return 0
    case 308:
        LL_RCC_EnableIT_LSERDY(&io)
        return 0
    case 309:
        LL_RCC_EnableIT_HSIRDY(&io)
        return 0
    case 310:
        LL_RCC_EnableIT_HSERDY(&io)
        return 0
    case 311:
        LL_RCC_EnableIT_CSIRDY(&io)
        return 0
    case 312:
        LL_RCC_EnableIT_HSI48RDY(&io)
        return 0
    case 313:
        LL_RCC_EnableIT_PLL1RDY(&io)
        return 0
    case 314:
        LL_RCC_EnableIT_PLL2RDY(&io)
        return 0
    case 315:
        LL_RCC_EnableIT_PLL3RDY(&io)
        return 0
    case 316:
        LL_RCC_EnableIT_LSECSS(&io)
        return 0
    case 317:
        LL_RCC_DisableIT_LSIRDY(&io)
        return 0
    case 318:
        LL_RCC_DisableIT_LSERDY(&io)
        return 0
    case 319:
        LL_RCC_DisableIT_HSIRDY(&io)
        return 0
    case 320:
        LL_RCC_DisableIT_HSERDY(&io)
        return 0
    case 321:
        LL_RCC_DisableIT_CSIRDY(&io)
        return 0
    case 322:
        LL_RCC_DisableIT_HSI48RDY(&io)
        return 0
    case 323:
        LL_RCC_DisableIT_PLL1RDY(&io)
        return 0
    case 324:
        LL_RCC_DisableIT_PLL2RDY(&io)
        return 0
    case 325:
        LL_RCC_DisableIT_PLL3RDY(&io)
        return 0
    case 326:
        LL_RCC_DisableIT_LSECSS(&io)
        return 0
    case 327:
        let result = LL_RCC_IsEnableIT_LSIRDY(&io)
        return result
    case 328:
        let result = LL_RCC_IsEnableIT_LSERDY(&io)
        return result
    case 329:
        let result = LL_RCC_IsEnableIT_HSIRDY(&io)
        return result
    case 330:
        let result = LL_RCC_IsEnableIT_HSERDY(&io)
        return result
    case 331:
        let result = LL_RCC_IsEnableIT_CSIRDY(&io)
        return result
    case 332:
        let result = LL_RCC_IsEnableIT_HSI48RDY(&io)
        return result
    case 333:
        let result = LL_RCC_IsEnableIT_PLL1RDY(&io)
        return result
    case 334:
        let result = LL_RCC_IsEnableIT_PLL2RDY(&io)
        return result
    case 335:
        let result = LL_RCC_IsEnableIT_PLL3RDY(&io)
        return result
    case 336:
        let result = LL_RCC_IsEnableIT_LSECSS(&io)
        return result
    case 337:
        let result = LL_RCC_CalcPLLClockFreq(args[0], args[1], args[2], args[3], args[4])
        return result
    case 338:
        LL_RCC_DeInit(&io)
        return 0
    case 339:
        var v0 = LL_RCC_ClocksTypeDef(SYSCLK_Frequency: args[0], CPUCLK_Frequency: args[1], HCLK_Frequency: args[2], PCLK1_Frequency: args[3], PCLK2_Frequency: args[4], PCLK4_Frequency: args[5], PCLK5_Frequency: args[6])
        LL_RCC_GetSystemClocksFreq(&io, &v0, oscillators: io.oscillators)
        io.cells[2200] = UInt32(v0.SYSCLK_Frequency)
        io.cells[2201] = UInt32(v0.CPUCLK_Frequency)
        io.cells[2202] = UInt32(v0.HCLK_Frequency)
        io.cells[2203] = UInt32(v0.PCLK1_Frequency)
        io.cells[2204] = UInt32(v0.PCLK2_Frequency)
        io.cells[2205] = UInt32(v0.PCLK4_Frequency)
        io.cells[2206] = UInt32(v0.PCLK5_Frequency)
        return 0
    case 340:
        var v0 = LL_PLL_ClocksTypeDef(PLL_P_Frequency: args[0], PLL_Q_Frequency: args[1], PLL_R_Frequency: args[2], PLL_S_Frequency: args[3], PLL_T_Frequency: args[4])
        LL_RCC_GetPLL1ClockFreq(&io, &v0, oscillators: io.oscillators)
        io.cells[2200] = UInt32(v0.PLL_P_Frequency)
        io.cells[2201] = UInt32(v0.PLL_Q_Frequency)
        io.cells[2202] = UInt32(v0.PLL_R_Frequency)
        io.cells[2203] = UInt32(v0.PLL_S_Frequency)
        io.cells[2204] = UInt32(v0.PLL_T_Frequency)
        return 0
    case 341:
        var v0 = LL_PLL_ClocksTypeDef(PLL_P_Frequency: args[0], PLL_Q_Frequency: args[1], PLL_R_Frequency: args[2], PLL_S_Frequency: args[3], PLL_T_Frequency: args[4])
        LL_RCC_GetPLL2ClockFreq(&io, &v0, oscillators: io.oscillators)
        io.cells[2200] = UInt32(v0.PLL_P_Frequency)
        io.cells[2201] = UInt32(v0.PLL_Q_Frequency)
        io.cells[2202] = UInt32(v0.PLL_R_Frequency)
        io.cells[2203] = UInt32(v0.PLL_S_Frequency)
        io.cells[2204] = UInt32(v0.PLL_T_Frequency)
        return 0
    case 342:
        var v0 = LL_PLL_ClocksTypeDef(PLL_P_Frequency: args[0], PLL_Q_Frequency: args[1], PLL_R_Frequency: args[2], PLL_S_Frequency: args[3], PLL_T_Frequency: args[4])
        LL_RCC_GetPLL3ClockFreq(&io, &v0, oscillators: io.oscillators)
        io.cells[2200] = UInt32(v0.PLL_P_Frequency)
        io.cells[2201] = UInt32(v0.PLL_Q_Frequency)
        io.cells[2202] = UInt32(v0.PLL_R_Frequency)
        io.cells[2203] = UInt32(v0.PLL_S_Frequency)
        io.cells[2204] = UInt32(v0.PLL_T_Frequency)
        return 0
    case 343:
        let v0 = LL_PLL_SpreadSpectrumTypeDef(ModulationPeriod: UInt16(truncatingIfNeeded: args[0]), IncrementStep: UInt16(truncatingIfNeeded: args[1]), SpreadMode: UInt16(truncatingIfNeeded: args[2]), DitheringRPDFN: UInt16(truncatingIfNeeded: args[3]), DitheringTPDFN: UInt16(truncatingIfNeeded: args[4]))
        LL_RCC_PLL1_ConfigSpreadSpectrum(&io, v0)
        io.cells[2200] = UInt32(v0.ModulationPeriod)
        io.cells[2201] = UInt32(v0.IncrementStep)
        io.cells[2202] = UInt32(v0.SpreadMode)
        io.cells[2203] = UInt32(v0.DitheringRPDFN)
        io.cells[2204] = UInt32(v0.DitheringTPDFN)
        return 0
    case 344:
        let v0 = LL_PLL_SpreadSpectrumTypeDef(ModulationPeriod: UInt16(truncatingIfNeeded: args[0]), IncrementStep: UInt16(truncatingIfNeeded: args[1]), SpreadMode: UInt16(truncatingIfNeeded: args[2]), DitheringRPDFN: UInt16(truncatingIfNeeded: args[3]), DitheringTPDFN: UInt16(truncatingIfNeeded: args[4]))
        LL_RCC_PLL2_ConfigSpreadSpectrum(&io, v0)
        io.cells[2200] = UInt32(v0.ModulationPeriod)
        io.cells[2201] = UInt32(v0.IncrementStep)
        io.cells[2202] = UInt32(v0.SpreadMode)
        io.cells[2203] = UInt32(v0.DitheringRPDFN)
        io.cells[2204] = UInt32(v0.DitheringTPDFN)
        return 0
    case 345:
        let v0 = LL_PLL_SpreadSpectrumTypeDef(ModulationPeriod: UInt16(truncatingIfNeeded: args[0]), IncrementStep: UInt16(truncatingIfNeeded: args[1]), SpreadMode: UInt16(truncatingIfNeeded: args[2]), DitheringRPDFN: UInt16(truncatingIfNeeded: args[3]), DitheringTPDFN: UInt16(truncatingIfNeeded: args[4]))
        LL_RCC_PLL3_ConfigSpreadSpectrum(&io, v0)
        io.cells[2200] = UInt32(v0.ModulationPeriod)
        io.cells[2201] = UInt32(v0.IncrementStep)
        io.cells[2202] = UInt32(v0.SpreadMode)
        io.cells[2203] = UInt32(v0.DitheringRPDFN)
        io.cells[2204] = UInt32(v0.DitheringTPDFN)
        return 0
    case 346:
        let result = LL_RCC_GetUSARTClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 347:
        let result = LL_RCC_GetUARTClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 348:
        let result = LL_RCC_GetLPUARTClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 349:
        let result = LL_RCC_GetI2CClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 350:
        let result = LL_RCC_GetI3CClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 351:
        let result = LL_RCC_GetLPTIMClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 352:
        let result = LL_RCC_GetSAIClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 353:
        let result = LL_RCC_GetADCClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 354:
        let result = LL_RCC_GetSDMMCClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 355:
        let result = LL_RCC_GetCECClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 356:
        let result = LL_RCC_GetPSSIClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 357:
        let result = LL_RCC_GetUSBPHYCClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 358:
        let result = LL_RCC_GetADFClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 359:
        let result = LL_RCC_GetSPDIFRXClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 360:
        let result = LL_RCC_GetSPIClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 361:
        let result = LL_RCC_GetETHPHYClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 362:
        let result = LL_RCC_GetFDCANClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 363:
        let result = LL_RCC_GetFMCClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 364:
        let result = LL_RCC_GetXSPIClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 365:
        let result = LL_RCC_GetCLKPClockFreq(&io, args[0], oscillators: io.oscillators)
        return result
    case 366:
        LL_CRS_EnableFreqErrorCounter(&io)
        return 0
    case 367:
        LL_CRS_DisableFreqErrorCounter(&io)
        return 0
    case 368:
        let result = LL_CRS_IsEnabledFreqErrorCounter(&io)
        return result
    case 369:
        LL_CRS_EnableAutoTrimming(&io)
        return 0
    case 370:
        LL_CRS_DisableAutoTrimming(&io)
        return 0
    case 371:
        let result = LL_CRS_IsEnabledAutoTrimming(&io)
        return result
    case 372:
        LL_CRS_SetHSI48SmoothTrimming(&io, args[0])
        return 0
    case 373:
        let result = LL_CRS_GetHSI48SmoothTrimming(&io)
        return result
    case 374:
        LL_CRS_SetReloadCounter(&io, args[0])
        return 0
    case 375:
        let result = LL_CRS_GetReloadCounter(&io)
        return result
    case 376:
        LL_CRS_SetFreqErrorLimit(&io, args[0])
        return 0
    case 377:
        let result = LL_CRS_GetFreqErrorLimit(&io)
        return result
    case 378:
        LL_CRS_SetSyncDivider(&io, args[0])
        return 0
    case 379:
        let result = LL_CRS_GetSyncDivider(&io)
        return result
    case 380:
        LL_CRS_SetSyncSignalSource(&io, args[0])
        return 0
    case 381:
        let result = LL_CRS_GetSyncSignalSource(&io)
        return result
    case 382:
        LL_CRS_SetSyncPolarity(&io, args[0])
        return 0
    case 383:
        let result = LL_CRS_GetSyncPolarity(&io)
        return result
    case 384:
        LL_CRS_ConfigSynchronization(&io, args[0], args[1], args[2], args[3])
        return 0
    case 385:
        LL_CRS_GenerateEvent_SWSYNC(&io)
        return 0
    case 386:
        let result = LL_CRS_GetFreqErrorDirection(&io)
        return result
    case 387:
        let result = LL_CRS_GetFreqErrorCapture(&io)
        return result
    case 388:
        let result = LL_CRS_IsActiveFlag_SYNCOK(&io)
        return result
    case 389:
        let result = LL_CRS_IsActiveFlag_SYNCWARN(&io)
        return result
    case 390:
        let result = LL_CRS_IsActiveFlag_ERR(&io)
        return result
    case 391:
        let result = LL_CRS_IsActiveFlag_ESYNC(&io)
        return result
    case 392:
        let result = LL_CRS_IsActiveFlag_SYNCERR(&io)
        return result
    case 393:
        let result = LL_CRS_IsActiveFlag_SYNCMISS(&io)
        return result
    case 394:
        let result = LL_CRS_IsActiveFlag_TRIMOVF(&io)
        return result
    case 395:
        LL_CRS_ClearFlag_SYNCOK(&io)
        return 0
    case 396:
        LL_CRS_ClearFlag_SYNCWARN(&io)
        return 0
    case 397:
        LL_CRS_ClearFlag_ERR(&io)
        return 0
    case 398:
        LL_CRS_ClearFlag_ESYNC(&io)
        return 0
    case 399:
        LL_CRS_EnableIT_SYNCOK(&io)
        return 0
    case 400:
        LL_CRS_DisableIT_SYNCOK(&io)
        return 0
    case 401:
        let result = LL_CRS_IsEnabledIT_SYNCOK(&io)
        return result
    case 402:
        LL_CRS_EnableIT_SYNCWARN(&io)
        return 0
    case 403:
        LL_CRS_DisableIT_SYNCWARN(&io)
        return 0
    case 404:
        let result = LL_CRS_IsEnabledIT_SYNCWARN(&io)
        return result
    case 405:
        LL_CRS_EnableIT_ERR(&io)
        return 0
    case 406:
        LL_CRS_DisableIT_ERR(&io)
        return 0
    case 407:
        let result = LL_CRS_IsEnabledIT_ERR(&io)
        return result
    case 408:
        LL_CRS_EnableIT_ESYNC(&io)
        return 0
    case 409:
        LL_CRS_DisableIT_ESYNC(&io)
        return 0
    case 410:
        let result = LL_CRS_IsEnabledIT_ESYNC(&io)
        return result
    case 411:
        let result = LL_CRS_DeInit(&io).rawValue
        return result
    case 412:
        let result = LL_GetUID_Word0(&io)
        return result
    case 413:
        let result = LL_GetUID_Word1(&io)
        return result
    case 414:
        let result = LL_GetUID_Word2(&io)
        return result
    case 415:
        let result = LL_GetPackageType(&io)
        return result
    case 416:
        LL_InitTick(&io, args[0], args[1])
        return 0
    case 417:
        LL_Init1msTick(&io, args[0])
        return 0
    case 418:
        LL_mDelay(&io, args[0])
        return 0
    case 419:
        LL_SetSystemCoreClock(args[0], system: io)
        return 0
    case 420:
        var v0 = LL_UTILS_PLLInitTypeDef(PLLM: args[0], PLLN: args[1], PLLP: args[2], FRACN: args[3], VCO_Input: args[4], VCO_Output: args[5])
        var v1 = LL_UTILS_ClkInitTypeDef(SYSCLKDivider: args[6], AHBCLKDivider: args[7], APB1CLKDivider: args[8], APB2CLKDivider: args[9], APB4CLKDivider: args[10], APB5CLKDivider: args[11])
        let result = LL_PLL_ConfigSystemClock_HSI(&io, &v0, &v1, oscillators: io.oscillators, system: io).rawValue
        io.cells[2200] = UInt32(v0.PLLM)
        io.cells[2201] = UInt32(v0.PLLN)
        io.cells[2202] = UInt32(v0.PLLP)
        io.cells[2203] = UInt32(v0.FRACN)
        io.cells[2204] = UInt32(v0.VCO_Input)
        io.cells[2205] = UInt32(v0.VCO_Output)
        io.cells[2206] = UInt32(v1.SYSCLKDivider)
        io.cells[2207] = UInt32(v1.AHBCLKDivider)
        io.cells[2208] = UInt32(v1.APB1CLKDivider)
        io.cells[2209] = UInt32(v1.APB2CLKDivider)
        io.cells[2210] = UInt32(v1.APB4CLKDivider)
        io.cells[2211] = UInt32(v1.APB5CLKDivider)
        return result
    case 421:
        var v0 = LL_UTILS_PLLInitTypeDef(PLLM: args[0], PLLN: args[1], PLLP: args[2], FRACN: args[3], VCO_Input: args[4], VCO_Output: args[5])
        var v1 = LL_UTILS_ClkInitTypeDef(SYSCLKDivider: args[6], AHBCLKDivider: args[7], APB1CLKDivider: args[8], APB2CLKDivider: args[9], APB4CLKDivider: args[10], APB5CLKDivider: args[11])
        let result = LL_PLL_ConfigSystemClock_CSI(&io, &v0, &v1, oscillators: io.oscillators, system: io).rawValue
        io.cells[2200] = UInt32(v0.PLLM)
        io.cells[2201] = UInt32(v0.PLLN)
        io.cells[2202] = UInt32(v0.PLLP)
        io.cells[2203] = UInt32(v0.FRACN)
        io.cells[2204] = UInt32(v0.VCO_Input)
        io.cells[2205] = UInt32(v0.VCO_Output)
        io.cells[2206] = UInt32(v1.SYSCLKDivider)
        io.cells[2207] = UInt32(v1.AHBCLKDivider)
        io.cells[2208] = UInt32(v1.APB1CLKDivider)
        io.cells[2209] = UInt32(v1.APB2CLKDivider)
        io.cells[2210] = UInt32(v1.APB4CLKDivider)
        io.cells[2211] = UInt32(v1.APB5CLKDivider)
        return result
    case 422:
        var v2 = LL_UTILS_PLLInitTypeDef(PLLM: args[2], PLLN: args[3], PLLP: args[4], FRACN: args[5], VCO_Input: args[6], VCO_Output: args[7])
        var v3 = LL_UTILS_ClkInitTypeDef(SYSCLKDivider: args[8], AHBCLKDivider: args[9], APB1CLKDivider: args[10], APB2CLKDivider: args[11], APB4CLKDivider: args[12], APB5CLKDivider: args[13])
        let result = LL_PLL_ConfigSystemClock_HSE(&io, args[0], args[1], &v2, &v3, system: io).rawValue
        io.cells[2200] = UInt32(v2.PLLM)
        io.cells[2201] = UInt32(v2.PLLN)
        io.cells[2202] = UInt32(v2.PLLP)
        io.cells[2203] = UInt32(v2.FRACN)
        io.cells[2204] = UInt32(v2.VCO_Input)
        io.cells[2205] = UInt32(v2.VCO_Output)
        io.cells[2206] = UInt32(v3.SYSCLKDivider)
        io.cells[2207] = UInt32(v3.AHBCLKDivider)
        io.cells[2208] = UInt32(v3.APB1CLKDivider)
        io.cells[2209] = UInt32(v3.APB2CLKDivider)
        io.cells[2210] = UInt32(v3.APB4CLKDivider)
        io.cells[2211] = UInt32(v3.APB5CLKDivider)
        return result
    case 423:
        let result = LL_SetFlashLatency(&io, args[0]).rawValue
        return result
    case 424: return LL_RCC_CALC_SYSCLK_FREQ(args[0], args[1])
    case 425: return LL_RCC_CALC_HCLK_FREQ(args[0], args[1])
    case 426: return LL_RCC_CALC_PCLK1_FREQ(args[0], args[1])
    case 427: return LL_RCC_CALC_PCLK2_FREQ(args[0], args[1])
    case 428: return LL_RCC_CALC_PCLK4_FREQ(args[0], args[1])
    case 429: return LL_RCC_CALC_PCLK5_FREQ(args[0], args[1])
    case 430: return LL_CLKSOURCE_SHIFT(args[0])
    case 431: return LL_CLKSOURCE_MASK(args[0])
    case 432: return LL_CLKSOURCE_CONFIG(args[0])
    case 433: return LL_CLKSOURCE_REG(args[0])
    case 434: return LL_CLKSOURCE(args[0], args[1], args[2], args[3])
    case 435: return __LL_CRS_CALC_CALCULATE_RELOADVALUE(args[0], args[1])
    case 436: LL_RCC_WriteReg(&io, RCCClockRegister.cr, args[0]); return LL_RCC_ReadReg(&io, RCCClockRegister.cr)
    case 437: LL_CRS_WriteReg(&io, .cfgr, args[0]); return LL_CRS_ReadReg(&io, .cfgr)
    default: preconditionFailure("Unknown operation")
    }
}

final class LLClockDifferentialTests: XCTestCase {
    private func compare(_ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0,
                         mode: UInt32 = 0, patch: [(Int, UInt32)] = [],
                         file: StaticString = #filePath, line: UInt = #line) {
        let c = CL50_Create()!
        defer { CL50_Destroy(c) }
        CL50_Reset(c, seed, salt, mode)
        var io = LLClockImage(seed: seed, salt: salt, mode: mode)
        for (index, value) in patch { CL50_GetCells(c)![index] = value; io.cells[index] = value }
        let cr = CL50_Run(c, UInt32(op), args)
        let sr = runLLClock(op, &io, args)
        let context = "op=\(op) args=\(args) seed=\(seed) salt=\(salt) mode=\(mode)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL50_GetCells(c), count: 2304)
        for index in cells.indices where cells[index] != io.cells[index] {
            XCTFail("\(context) cell \(index): Swift \(io.cells[index]), C \(cells[index])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL50_GetTrace(c), count: Int(CL50_GetTraceCount(c)))
        XCTAssertEqual(io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file, line: line)
    }

    func testInlineFunctionsAndSpreadSpectrumAgainstC() {
        for op in Array(0..<338) + Array(343...345) + Array(366...417) + [419, 436, 437] {
            for sample in 0..<64 {
                let seed = UInt32(sample) &* 0x9E3779B9
                var args = [seed, ~seed, seed ^ 0x55AA55AA, seed &+ 17, seed &+ 33, seed, seed]
                if op == 77 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 86 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 88 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 91 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 93 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 96 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 97 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 100 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 109 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 111 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 114 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 116 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 119 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 120 { args[0] = LL_CLKSOURCE(UInt32(sample % 4) * 4, 7 << 20, 20, UInt32(sample % 8) << 20) }
                if op == 337 { args = [64_000_000, UInt32(sample % 63 + 1), UInt32(sample * 7 + 4), UInt32(sample * 131 % 8192), 128] }
                compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x10204081)
            }
        }
    }

    func testPLLFloatingPointOrderAgainstC() {
        let inputs: [UInt32] = [0, 1, 2, 16_777_215, 16_777_216, 16_777_217, 64_000_000, 128_000_000]
        for input in inputs {
            for sample: UInt32 in 0..<512 {
                compare(337, [input, sample % 63 + 1, sample, sample * 17 % 8192, sample % 97 + 32])
            }
        }
    }

    func testClockQueriesAcrossSourcesAndPrescalers() {
        for sample in 0..<256 {
            let seed = UInt32(sample) &* 0x9E3779B9
            let divr1: UInt32 = 127 | (31 << 9) | (31 << 16) | (31 << 24)
            let patch: [(Int, UInt32)] = [(10, UInt32(sample % 4) | (UInt32(sample % 64) << 4) | (8 << 12) | (16 << 20)),
                (12, divr1), (14, divr1), (16, divr1), (48, 0x1F1F), (49, 0x1F1F), (50, 0x1F1F)]
            for op in 339...365 where !(343...345).contains(op) {
                var args: [UInt32] = [UInt32(sample), 0xDEADBEEF, 7, 11, 13, 17, 19]
                switch op {
                case 346: args[0] = LL_RCC_USART1_CLKSOURCE
                case 347: args[0] = LL_RCC_USART234578_CLKSOURCE
                case 349: args[0] = sample % 2 == 0 ? LL_RCC_I2C1_CLKSOURCE : LL_RCC_I2C23_CLKSOURCE
                case 350: args[0] = LL_RCC_I3C1_CLKSOURCE
                case 352: args[0] = sample % 2 == 0 ? LL_RCC_SAI1_CLKSOURCE : LL_RCC_SAI2_CLKSOURCE
                case 364: args[0] = sample % 2 == 0 ? LL_RCC_XSPI1_CLKSOURCE : LL_RCC_XSPI2_CLKSOURCE
                case 351: args[0] = sample % 2 == 0 ? LL_RCC_LPTIM1_CLKSOURCE : LL_RCC_LPTIM23_CLKSOURCE
                case 360: args[0] = sample % 3 == 0 ? LL_RCC_SPI1_CLKSOURCE : sample % 3 == 1 ? LL_RCC_SPI23_CLKSOURCE : LL_RCC_SPI45_CLKSOURCE
                default: break
                }
                compare(op, args, seed: seed,
                        mode: sample % 2 == 0 ? 0 : 4, patch: patch)
            }
        }
    }

    func testResetAndUtilityWaitLoopsAgainstC() {
        for sample in 0..<64 {
            let seed = UInt32(sample) &* 0x9E3779B9
            compare(338, [], seed: seed, mode: 1)
            compare(418, [UInt32(sample)], seed: seed, mode: 1)
            for op in 420...422 {
                let args: [UInt32] = (op == 422 ? [24_000_000, UInt32(sample % 2)] : []) +
                    [8, UInt32(12 + sample * 2), 2, UInt32(sample * 131 % 8192), 0, 0,
                     UInt32(sample % 16), UInt32(sample % 16), 4, 0x50, 0x600, 0x7000]
                let patch: [(Int, UInt32)] = [(0, sample % 8 == 0 ? 0x2A000000 : 0), (4, 0), (512, 0),
                    (773, sample % 2 == 0 ? 1 : 0), (2100, sample % 3 == 0 ? 600_000_000 : 4_000_000)]
                compare(op, args, seed: seed, mode: sample % 4 == 0 ? 3 : 1, patch: patch)
            }
        }
    }

    func testFlashLatencyThresholdsAndFailedReadback() {
        let thresholds: [UInt32] = [0, 1, 36_000_000, 40_000_000, 72_000_000, 80_000_000, 108_000_000,
            120_000_000, 144_000_000, 160_000_000, 180_000_000, 200_000_000, 216_000_000,
            240_000_000, 280_000_000, 320_000_000, .max]
        for scale: UInt32 in 0...1 {
            for stuck: UInt32 in [0, 2] {
                for threshold in thresholds {
                    for frequency in [threshold &- 1, threshold, threshold &+ 1] {
                        compare(423, [frequency], mode: stuck, patch: [(773, scale), (512, 15)])
                    }
                }
            }
        }
    }

    func testMacrosAgainstC() {
        for sample: UInt32 in 0..<256 {
            let seed = sample &* 0x9E3779B9
            for op in 424...435 {
                var args = [seed, sample &* 0x01010101, sample % 32, seed]
                if op == 434 { args[0] = sample % 16; args[1] = 0xF0000000 }
                if op == 435 { args[1] = sample + 1 }
                compare(op, args)
            }
        }
    }

    func testPreservedResetQuirkAndUntouchedCPUField() {
        var io = LLClockImage(seed: 0x12345678, salt: 0, mode: 1)
        let pll3 = [io.cells[16], io.cells[50]]
        LL_RCC_DeInit(&io)
        XCTAssertEqual([io.cells[16], io.cells[50]], pll3)
        XCTAssertEqual(io.trace.filter { $0.kind == 1 && $0.index == 14 }.count, 2)
        XCTAssertEqual(io.trace.filter { $0.kind == 1 && $0.index == 49 }.count, 2)
        var clocks = LL_RCC_ClocksTypeDef(CPUCLK_Frequency: 0xDEADBEEF)
        LL_RCC_GetSystemClocksFreq(&io, &clocks)
        XCTAssertEqual(clocks.CPUCLK_Frequency, 0xDEADBEEF)
    }

    func testTickConfigurationAndDelayReadClear() {
        var io = LLClockImage(seed: 0, salt: 0, mode: 1)
        LL_InitTick(&io, 64_000_000, 0)
        XCTAssertTrue(io.trace.isEmpty)
        LL_Init1msTick(&io, 64_000_000)
        XCTAssertEqual(io.trace.map(\.value), [63_999, 0, 5])
        io.trace = []
        LL_mDelay(&io, 0)
        XCTAssertEqual(io.trace.count, 3)
        XCTAssertEqual(io.trace.map(\.index), [1024, 1024, 1024])
        XCTAssertEqual(io.trace.last!.value & 0x10000, 0x10000)
    }

    func testEveryConstantAndPrescalerTableAgainstC() {
        XCTAssertEqual(LL_RCC_REG_SHIFT, CL50_Constant(0), "LL_RCC_REG_SHIFT")
        XCTAssertEqual(LL_RCC_POS_SHIFT, CL50_Constant(1), "LL_RCC_POS_SHIFT")
        XCTAssertEqual(LL_RCC_CONFIG_SHIFT, CL50_Constant(2), "LL_RCC_CONFIG_SHIFT")
        XCTAssertEqual(LL_RCC_MASK_SHIFT, CL50_Constant(3), "LL_RCC_MASK_SHIFT")
        XCTAssertEqual(LL_RCC_HSI_DIV_1, CL50_Constant(4), "LL_RCC_HSI_DIV_1")
        XCTAssertEqual(LL_RCC_HSI_DIV_2, CL50_Constant(5), "LL_RCC_HSI_DIV_2")
        XCTAssertEqual(LL_RCC_HSI_DIV_4, CL50_Constant(6), "LL_RCC_HSI_DIV_4")
        XCTAssertEqual(LL_RCC_HSI_DIV_8, CL50_Constant(7), "LL_RCC_HSI_DIV_8")
        XCTAssertEqual(LL_RCC_SWP_XSPI1_NEUTRAL, CL50_Constant(8), "LL_RCC_SWP_XSPI1_NEUTRAL")
        XCTAssertEqual(LL_RCC_SWP_XSPI1_HCLK5, CL50_Constant(9), "LL_RCC_SWP_XSPI1_HCLK5")
        XCTAssertEqual(LL_RCC_SWP_XSPI1_PLL2S, CL50_Constant(10), "LL_RCC_SWP_XSPI1_PLL2S")
        XCTAssertEqual(LL_RCC_SWP_XSPI1_PLL2T, CL50_Constant(11), "LL_RCC_SWP_XSPI1_PLL2T")
        XCTAssertEqual(LL_RCC_SWP_XSPI1_HCLK_DIV4, CL50_Constant(12), "LL_RCC_SWP_XSPI1_HCLK_DIV4")
        XCTAssertEqual(LL_RCC_SWP_XSPI2_NEUTRAL, CL50_Constant(13), "LL_RCC_SWP_XSPI2_NEUTRAL")
        XCTAssertEqual(LL_RCC_SWP_XSPI2_HCLK5, CL50_Constant(14), "LL_RCC_SWP_XSPI2_HCLK5")
        XCTAssertEqual(LL_RCC_SWP_XSPI2_PLL2S, CL50_Constant(15), "LL_RCC_SWP_XSPI2_PLL2S")
        XCTAssertEqual(LL_RCC_SWP_XSPI2_PLL2T, CL50_Constant(16), "LL_RCC_SWP_XSPI2_PLL2T")
        XCTAssertEqual(LL_RCC_SWP_XSPI2_HCLK_DIV4, CL50_Constant(17), "LL_RCC_SWP_XSPI2_HCLK_DIV4")
        XCTAssertEqual(LL_RCC_SWP_FMC_NEUTRAL, CL50_Constant(18), "LL_RCC_SWP_FMC_NEUTRAL")
        XCTAssertEqual(LL_RCC_SWP_FMC_HCLK5, CL50_Constant(19), "LL_RCC_SWP_FMC_HCLK5")
        XCTAssertEqual(LL_RCC_SWP_FMC_PLL1Q, CL50_Constant(20), "LL_RCC_SWP_FMC_PLL1Q")
        XCTAssertEqual(LL_RCC_SWP_FMC_PLL2R, CL50_Constant(21), "LL_RCC_SWP_FMC_PLL2R")
        XCTAssertEqual(LL_RCC_SWP_FMC_HSI, CL50_Constant(22), "LL_RCC_SWP_FMC_HSI")
        XCTAssertEqual(LL_RCC_SWP_FMC_HCLK_DIV4, CL50_Constant(23), "LL_RCC_SWP_FMC_HCLK_DIV4")
        XCTAssertEqual(LL_RCC_LSEDRIVE_LOW, CL50_Constant(24), "LL_RCC_LSEDRIVE_LOW")
        XCTAssertEqual(LL_RCC_LSEDRIVE_MEDIUMLOW, CL50_Constant(25), "LL_RCC_LSEDRIVE_MEDIUMLOW")
        XCTAssertEqual(LL_RCC_LSEDRIVE_MEDIUMHIGH, CL50_Constant(26), "LL_RCC_LSEDRIVE_MEDIUMHIGH")
        XCTAssertEqual(LL_RCC_LSEDRIVE_HIGH, CL50_Constant(27), "LL_RCC_LSEDRIVE_HIGH")
        XCTAssertEqual(LL_RCC_SYS_CLKSOURCE_HSI, CL50_Constant(28), "LL_RCC_SYS_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_SYS_CLKSOURCE_CSI, CL50_Constant(29), "LL_RCC_SYS_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_SYS_CLKSOURCE_HSE, CL50_Constant(30), "LL_RCC_SYS_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_SYS_CLKSOURCE_PLL1, CL50_Constant(31), "LL_RCC_SYS_CLKSOURCE_PLL1")
        XCTAssertEqual(LL_RCC_SYS_CLKSOURCE_STATUS_HSI, CL50_Constant(32), "LL_RCC_SYS_CLKSOURCE_STATUS_HSI")
        XCTAssertEqual(LL_RCC_SYS_CLKSOURCE_STATUS_CSI, CL50_Constant(33), "LL_RCC_SYS_CLKSOURCE_STATUS_CSI")
        XCTAssertEqual(LL_RCC_SYS_CLKSOURCE_STATUS_HSE, CL50_Constant(34), "LL_RCC_SYS_CLKSOURCE_STATUS_HSE")
        XCTAssertEqual(LL_RCC_SYS_CLKSOURCE_STATUS_PLL1, CL50_Constant(35), "LL_RCC_SYS_CLKSOURCE_STATUS_PLL1")
        XCTAssertEqual(LL_RCC_SYSWAKEUP_CLKSOURCE_HSI, CL50_Constant(36), "LL_RCC_SYSWAKEUP_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_SYSWAKEUP_CLKSOURCE_CSI, CL50_Constant(37), "LL_RCC_SYSWAKEUP_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_KERWAKEUP_CLKSOURCE_HSI, CL50_Constant(38), "LL_RCC_KERWAKEUP_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_KERWAKEUP_CLKSOURCE_CSI, CL50_Constant(39), "LL_RCC_KERWAKEUP_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_1, CL50_Constant(40), "LL_RCC_SYSCLK_DIV_1")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_2, CL50_Constant(41), "LL_RCC_SYSCLK_DIV_2")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_4, CL50_Constant(42), "LL_RCC_SYSCLK_DIV_4")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_8, CL50_Constant(43), "LL_RCC_SYSCLK_DIV_8")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_16, CL50_Constant(44), "LL_RCC_SYSCLK_DIV_16")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_64, CL50_Constant(45), "LL_RCC_SYSCLK_DIV_64")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_128, CL50_Constant(46), "LL_RCC_SYSCLK_DIV_128")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_256, CL50_Constant(47), "LL_RCC_SYSCLK_DIV_256")
        XCTAssertEqual(LL_RCC_SYSCLK_DIV_512, CL50_Constant(48), "LL_RCC_SYSCLK_DIV_512")
        XCTAssertEqual(LL_RCC_AHB_DIV_1, CL50_Constant(49), "LL_RCC_AHB_DIV_1")
        XCTAssertEqual(LL_RCC_AHB_DIV_2, CL50_Constant(50), "LL_RCC_AHB_DIV_2")
        XCTAssertEqual(LL_RCC_AHB_DIV_4, CL50_Constant(51), "LL_RCC_AHB_DIV_4")
        XCTAssertEqual(LL_RCC_AHB_DIV_8, CL50_Constant(52), "LL_RCC_AHB_DIV_8")
        XCTAssertEqual(LL_RCC_AHB_DIV_16, CL50_Constant(53), "LL_RCC_AHB_DIV_16")
        XCTAssertEqual(LL_RCC_AHB_DIV_64, CL50_Constant(54), "LL_RCC_AHB_DIV_64")
        XCTAssertEqual(LL_RCC_AHB_DIV_128, CL50_Constant(55), "LL_RCC_AHB_DIV_128")
        XCTAssertEqual(LL_RCC_AHB_DIV_256, CL50_Constant(56), "LL_RCC_AHB_DIV_256")
        XCTAssertEqual(LL_RCC_AHB_DIV_512, CL50_Constant(57), "LL_RCC_AHB_DIV_512")
        XCTAssertEqual(LL_RCC_APB1_DIV_1, CL50_Constant(58), "LL_RCC_APB1_DIV_1")
        XCTAssertEqual(LL_RCC_APB1_DIV_2, CL50_Constant(59), "LL_RCC_APB1_DIV_2")
        XCTAssertEqual(LL_RCC_APB1_DIV_4, CL50_Constant(60), "LL_RCC_APB1_DIV_4")
        XCTAssertEqual(LL_RCC_APB1_DIV_8, CL50_Constant(61), "LL_RCC_APB1_DIV_8")
        XCTAssertEqual(LL_RCC_APB1_DIV_16, CL50_Constant(62), "LL_RCC_APB1_DIV_16")
        XCTAssertEqual(LL_RCC_APB2_DIV_1, CL50_Constant(63), "LL_RCC_APB2_DIV_1")
        XCTAssertEqual(LL_RCC_APB2_DIV_2, CL50_Constant(64), "LL_RCC_APB2_DIV_2")
        XCTAssertEqual(LL_RCC_APB2_DIV_4, CL50_Constant(65), "LL_RCC_APB2_DIV_4")
        XCTAssertEqual(LL_RCC_APB2_DIV_8, CL50_Constant(66), "LL_RCC_APB2_DIV_8")
        XCTAssertEqual(LL_RCC_APB2_DIV_16, CL50_Constant(67), "LL_RCC_APB2_DIV_16")
        XCTAssertEqual(LL_RCC_APB4_DIV_1, CL50_Constant(68), "LL_RCC_APB4_DIV_1")
        XCTAssertEqual(LL_RCC_APB4_DIV_2, CL50_Constant(69), "LL_RCC_APB4_DIV_2")
        XCTAssertEqual(LL_RCC_APB4_DIV_4, CL50_Constant(70), "LL_RCC_APB4_DIV_4")
        XCTAssertEqual(LL_RCC_APB4_DIV_8, CL50_Constant(71), "LL_RCC_APB4_DIV_8")
        XCTAssertEqual(LL_RCC_APB4_DIV_16, CL50_Constant(72), "LL_RCC_APB4_DIV_16")
        XCTAssertEqual(LL_RCC_APB5_DIV_1, CL50_Constant(73), "LL_RCC_APB5_DIV_1")
        XCTAssertEqual(LL_RCC_APB5_DIV_2, CL50_Constant(74), "LL_RCC_APB5_DIV_2")
        XCTAssertEqual(LL_RCC_APB5_DIV_4, CL50_Constant(75), "LL_RCC_APB5_DIV_4")
        XCTAssertEqual(LL_RCC_APB5_DIV_8, CL50_Constant(76), "LL_RCC_APB5_DIV_8")
        XCTAssertEqual(LL_RCC_APB5_DIV_16, CL50_Constant(77), "LL_RCC_APB5_DIV_16")
        XCTAssertEqual(LL_RCC_MCO1SOURCE_HSI, CL50_Constant(78), "LL_RCC_MCO1SOURCE_HSI")
        XCTAssertEqual(LL_RCC_MCO1SOURCE_LSE, CL50_Constant(79), "LL_RCC_MCO1SOURCE_LSE")
        XCTAssertEqual(LL_RCC_MCO1SOURCE_HSE, CL50_Constant(80), "LL_RCC_MCO1SOURCE_HSE")
        XCTAssertEqual(LL_RCC_MCO1SOURCE_PLL1Q, CL50_Constant(81), "LL_RCC_MCO1SOURCE_PLL1Q")
        XCTAssertEqual(LL_RCC_MCO1SOURCE_HSI48, CL50_Constant(82), "LL_RCC_MCO1SOURCE_HSI48")
        XCTAssertEqual(LL_RCC_MCO2SOURCE_SYSCLK, CL50_Constant(83), "LL_RCC_MCO2SOURCE_SYSCLK")
        XCTAssertEqual(LL_RCC_MCO2SOURCE_PLL2P, CL50_Constant(84), "LL_RCC_MCO2SOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_MCO2SOURCE_HSE, CL50_Constant(85), "LL_RCC_MCO2SOURCE_HSE")
        XCTAssertEqual(LL_RCC_MCO2SOURCE_PLL1P, CL50_Constant(86), "LL_RCC_MCO2SOURCE_PLL1P")
        XCTAssertEqual(LL_RCC_MCO2SOURCE_CSI, CL50_Constant(87), "LL_RCC_MCO2SOURCE_CSI")
        XCTAssertEqual(LL_RCC_MCO2SOURCE_LSI, CL50_Constant(88), "LL_RCC_MCO2SOURCE_LSI")
        XCTAssertEqual(LL_RCC_MCO1_DIV_1, CL50_Constant(89), "LL_RCC_MCO1_DIV_1")
        XCTAssertEqual(LL_RCC_MCO1_DIV_2, CL50_Constant(90), "LL_RCC_MCO1_DIV_2")
        XCTAssertEqual(LL_RCC_MCO1_DIV_3, CL50_Constant(91), "LL_RCC_MCO1_DIV_3")
        XCTAssertEqual(LL_RCC_MCO1_DIV_4, CL50_Constant(92), "LL_RCC_MCO1_DIV_4")
        XCTAssertEqual(LL_RCC_MCO1_DIV_5, CL50_Constant(93), "LL_RCC_MCO1_DIV_5")
        XCTAssertEqual(LL_RCC_MCO1_DIV_6, CL50_Constant(94), "LL_RCC_MCO1_DIV_6")
        XCTAssertEqual(LL_RCC_MCO1_DIV_7, CL50_Constant(95), "LL_RCC_MCO1_DIV_7")
        XCTAssertEqual(LL_RCC_MCO1_DIV_8, CL50_Constant(96), "LL_RCC_MCO1_DIV_8")
        XCTAssertEqual(LL_RCC_MCO1_DIV_9, CL50_Constant(97), "LL_RCC_MCO1_DIV_9")
        XCTAssertEqual(LL_RCC_MCO1_DIV_10, CL50_Constant(98), "LL_RCC_MCO1_DIV_10")
        XCTAssertEqual(LL_RCC_MCO1_DIV_11, CL50_Constant(99), "LL_RCC_MCO1_DIV_11")
        XCTAssertEqual(LL_RCC_MCO1_DIV_12, CL50_Constant(100), "LL_RCC_MCO1_DIV_12")
        XCTAssertEqual(LL_RCC_MCO1_DIV_13, CL50_Constant(101), "LL_RCC_MCO1_DIV_13")
        XCTAssertEqual(LL_RCC_MCO1_DIV_14, CL50_Constant(102), "LL_RCC_MCO1_DIV_14")
        XCTAssertEqual(LL_RCC_MCO1_DIV_15, CL50_Constant(103), "LL_RCC_MCO1_DIV_15")
        XCTAssertEqual(LL_RCC_MCO2_DIV_1, CL50_Constant(104), "LL_RCC_MCO2_DIV_1")
        XCTAssertEqual(LL_RCC_MCO2_DIV_2, CL50_Constant(105), "LL_RCC_MCO2_DIV_2")
        XCTAssertEqual(LL_RCC_MCO2_DIV_3, CL50_Constant(106), "LL_RCC_MCO2_DIV_3")
        XCTAssertEqual(LL_RCC_MCO2_DIV_4, CL50_Constant(107), "LL_RCC_MCO2_DIV_4")
        XCTAssertEqual(LL_RCC_MCO2_DIV_5, CL50_Constant(108), "LL_RCC_MCO2_DIV_5")
        XCTAssertEqual(LL_RCC_MCO2_DIV_6, CL50_Constant(109), "LL_RCC_MCO2_DIV_6")
        XCTAssertEqual(LL_RCC_MCO2_DIV_7, CL50_Constant(110), "LL_RCC_MCO2_DIV_7")
        XCTAssertEqual(LL_RCC_MCO2_DIV_8, CL50_Constant(111), "LL_RCC_MCO2_DIV_8")
        XCTAssertEqual(LL_RCC_MCO2_DIV_9, CL50_Constant(112), "LL_RCC_MCO2_DIV_9")
        XCTAssertEqual(LL_RCC_MCO2_DIV_10, CL50_Constant(113), "LL_RCC_MCO2_DIV_10")
        XCTAssertEqual(LL_RCC_MCO2_DIV_11, CL50_Constant(114), "LL_RCC_MCO2_DIV_11")
        XCTAssertEqual(LL_RCC_MCO2_DIV_12, CL50_Constant(115), "LL_RCC_MCO2_DIV_12")
        XCTAssertEqual(LL_RCC_MCO2_DIV_13, CL50_Constant(116), "LL_RCC_MCO2_DIV_13")
        XCTAssertEqual(LL_RCC_MCO2_DIV_14, CL50_Constant(117), "LL_RCC_MCO2_DIV_14")
        XCTAssertEqual(LL_RCC_MCO2_DIV_15, CL50_Constant(118), "LL_RCC_MCO2_DIV_15")
        XCTAssertEqual(LL_RCC_RTC_NOCLOCK, CL50_Constant(119), "LL_RCC_RTC_NOCLOCK")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_2, CL50_Constant(120), "LL_RCC_RTC_HSE_DIV_2")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_3, CL50_Constant(121), "LL_RCC_RTC_HSE_DIV_3")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_4, CL50_Constant(122), "LL_RCC_RTC_HSE_DIV_4")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_5, CL50_Constant(123), "LL_RCC_RTC_HSE_DIV_5")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_6, CL50_Constant(124), "LL_RCC_RTC_HSE_DIV_6")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_7, CL50_Constant(125), "LL_RCC_RTC_HSE_DIV_7")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_8, CL50_Constant(126), "LL_RCC_RTC_HSE_DIV_8")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_9, CL50_Constant(127), "LL_RCC_RTC_HSE_DIV_9")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_10, CL50_Constant(128), "LL_RCC_RTC_HSE_DIV_10")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_11, CL50_Constant(129), "LL_RCC_RTC_HSE_DIV_11")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_12, CL50_Constant(130), "LL_RCC_RTC_HSE_DIV_12")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_13, CL50_Constant(131), "LL_RCC_RTC_HSE_DIV_13")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_14, CL50_Constant(132), "LL_RCC_RTC_HSE_DIV_14")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_15, CL50_Constant(133), "LL_RCC_RTC_HSE_DIV_15")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_16, CL50_Constant(134), "LL_RCC_RTC_HSE_DIV_16")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_17, CL50_Constant(135), "LL_RCC_RTC_HSE_DIV_17")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_18, CL50_Constant(136), "LL_RCC_RTC_HSE_DIV_18")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_19, CL50_Constant(137), "LL_RCC_RTC_HSE_DIV_19")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_20, CL50_Constant(138), "LL_RCC_RTC_HSE_DIV_20")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_21, CL50_Constant(139), "LL_RCC_RTC_HSE_DIV_21")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_22, CL50_Constant(140), "LL_RCC_RTC_HSE_DIV_22")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_23, CL50_Constant(141), "LL_RCC_RTC_HSE_DIV_23")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_24, CL50_Constant(142), "LL_RCC_RTC_HSE_DIV_24")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_25, CL50_Constant(143), "LL_RCC_RTC_HSE_DIV_25")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_26, CL50_Constant(144), "LL_RCC_RTC_HSE_DIV_26")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_27, CL50_Constant(145), "LL_RCC_RTC_HSE_DIV_27")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_28, CL50_Constant(146), "LL_RCC_RTC_HSE_DIV_28")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_29, CL50_Constant(147), "LL_RCC_RTC_HSE_DIV_29")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_30, CL50_Constant(148), "LL_RCC_RTC_HSE_DIV_30")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_31, CL50_Constant(149), "LL_RCC_RTC_HSE_DIV_31")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_32, CL50_Constant(150), "LL_RCC_RTC_HSE_DIV_32")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_33, CL50_Constant(151), "LL_RCC_RTC_HSE_DIV_33")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_34, CL50_Constant(152), "LL_RCC_RTC_HSE_DIV_34")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_35, CL50_Constant(153), "LL_RCC_RTC_HSE_DIV_35")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_36, CL50_Constant(154), "LL_RCC_RTC_HSE_DIV_36")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_37, CL50_Constant(155), "LL_RCC_RTC_HSE_DIV_37")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_38, CL50_Constant(156), "LL_RCC_RTC_HSE_DIV_38")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_39, CL50_Constant(157), "LL_RCC_RTC_HSE_DIV_39")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_40, CL50_Constant(158), "LL_RCC_RTC_HSE_DIV_40")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_41, CL50_Constant(159), "LL_RCC_RTC_HSE_DIV_41")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_42, CL50_Constant(160), "LL_RCC_RTC_HSE_DIV_42")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_43, CL50_Constant(161), "LL_RCC_RTC_HSE_DIV_43")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_44, CL50_Constant(162), "LL_RCC_RTC_HSE_DIV_44")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_45, CL50_Constant(163), "LL_RCC_RTC_HSE_DIV_45")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_46, CL50_Constant(164), "LL_RCC_RTC_HSE_DIV_46")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_47, CL50_Constant(165), "LL_RCC_RTC_HSE_DIV_47")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_48, CL50_Constant(166), "LL_RCC_RTC_HSE_DIV_48")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_49, CL50_Constant(167), "LL_RCC_RTC_HSE_DIV_49")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_50, CL50_Constant(168), "LL_RCC_RTC_HSE_DIV_50")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_51, CL50_Constant(169), "LL_RCC_RTC_HSE_DIV_51")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_52, CL50_Constant(170), "LL_RCC_RTC_HSE_DIV_52")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_53, CL50_Constant(171), "LL_RCC_RTC_HSE_DIV_53")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_54, CL50_Constant(172), "LL_RCC_RTC_HSE_DIV_54")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_55, CL50_Constant(173), "LL_RCC_RTC_HSE_DIV_55")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_56, CL50_Constant(174), "LL_RCC_RTC_HSE_DIV_56")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_57, CL50_Constant(175), "LL_RCC_RTC_HSE_DIV_57")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_58, CL50_Constant(176), "LL_RCC_RTC_HSE_DIV_58")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_59, CL50_Constant(177), "LL_RCC_RTC_HSE_DIV_59")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_60, CL50_Constant(178), "LL_RCC_RTC_HSE_DIV_60")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_61, CL50_Constant(179), "LL_RCC_RTC_HSE_DIV_61")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_62, CL50_Constant(180), "LL_RCC_RTC_HSE_DIV_62")
        XCTAssertEqual(LL_RCC_RTC_HSE_DIV_63, CL50_Constant(181), "LL_RCC_RTC_HSE_DIV_63")
        XCTAssertEqual(LL_RCC_ADC_CLKSOURCE_PLL2P, CL50_Constant(182), "LL_RCC_ADC_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_ADC_CLKSOURCE_PLL3R, CL50_Constant(183), "LL_RCC_ADC_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_ADC_CLKSOURCE_CLKP, CL50_Constant(184), "LL_RCC_ADC_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_ADF1_CLKSOURCE_HCLK, CL50_Constant(185), "LL_RCC_ADF1_CLKSOURCE_HCLK")
        XCTAssertEqual(LL_RCC_ADF1_CLKSOURCE_PLL2P, CL50_Constant(186), "LL_RCC_ADF1_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_ADF1_CLKSOURCE_PLL3P, CL50_Constant(187), "LL_RCC_ADF1_CLKSOURCE_PLL3P")
        XCTAssertEqual(LL_RCC_ADF1_CLKSOURCE_I2S_CKIN, CL50_Constant(188), "LL_RCC_ADF1_CLKSOURCE_I2S_CKIN")
        XCTAssertEqual(LL_RCC_ADF1_CLKSOURCE_CSI, CL50_Constant(189), "LL_RCC_ADF1_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_ADF1_CLKSOURCE_HSI, CL50_Constant(190), "LL_RCC_ADF1_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_CEC_CLKSOURCE_LSE, CL50_Constant(191), "LL_RCC_CEC_CLKSOURCE_LSE")
        XCTAssertEqual(LL_RCC_CEC_CLKSOURCE_LSI, CL50_Constant(192), "LL_RCC_CEC_CLKSOURCE_LSI")
        XCTAssertEqual(LL_RCC_CEC_CLKSOURCE_CSI_DIV_122, CL50_Constant(193), "LL_RCC_CEC_CLKSOURCE_CSI_DIV_122")
        XCTAssertEqual(LL_RCC_CLKP_CLKSOURCE_HSI, CL50_Constant(194), "LL_RCC_CLKP_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_CLKP_CLKSOURCE_CSI, CL50_Constant(195), "LL_RCC_CLKP_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_CLKP_CLKSOURCE_HSE, CL50_Constant(196), "LL_RCC_CLKP_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_ETH1PHY_CLKSOURCE_HSE, CL50_Constant(197), "LL_RCC_ETH1PHY_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_ETH1PHY_CLKSOURCE_PLL3S, CL50_Constant(198), "LL_RCC_ETH1PHY_CLKSOURCE_PLL3S")
        XCTAssertEqual(LL_RCC_ETH1REF_CLKSOURCE_RMII, CL50_Constant(199), "LL_RCC_ETH1REF_CLKSOURCE_RMII")
        XCTAssertEqual(LL_RCC_ETH1REF_CLKSOURCE_HSE, CL50_Constant(200), "LL_RCC_ETH1REF_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_ETH1REF_CLKSOURCE_FB, CL50_Constant(201), "LL_RCC_ETH1REF_CLKSOURCE_FB")
        XCTAssertEqual(LL_RCC_FDCAN_CLKSOURCE_HSE, CL50_Constant(202), "LL_RCC_FDCAN_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_FDCAN_CLKSOURCE_PLL1Q, CL50_Constant(203), "LL_RCC_FDCAN_CLKSOURCE_PLL1Q")
        XCTAssertEqual(LL_RCC_FDCAN_CLKSOURCE_PLL2Q, CL50_Constant(204), "LL_RCC_FDCAN_CLKSOURCE_PLL2Q")
        XCTAssertEqual(LL_RCC_FMC_CLKSOURCE_HCLK, CL50_Constant(205), "LL_RCC_FMC_CLKSOURCE_HCLK")
        XCTAssertEqual(LL_RCC_FMC_CLKSOURCE_PLL1Q, CL50_Constant(206), "LL_RCC_FMC_CLKSOURCE_PLL1Q")
        XCTAssertEqual(LL_RCC_FMC_CLKSOURCE_PLL2R, CL50_Constant(207), "LL_RCC_FMC_CLKSOURCE_PLL2R")
        XCTAssertEqual(LL_RCC_FMC_CLKSOURCE_HSI, CL50_Constant(208), "LL_RCC_FMC_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_FMC_CLKSOURCE_HCLK_DIV4, CL50_Constant(209), "LL_RCC_FMC_CLKSOURCE_HCLK_DIV4")
        XCTAssertEqual(LL_RCC_I2C1_CLKSOURCE_PCLK1, CL50_Constant(210), "LL_RCC_I2C1_CLKSOURCE_PCLK1")
        XCTAssertEqual(LL_RCC_I2C1_CLKSOURCE_PLL3R, CL50_Constant(211), "LL_RCC_I2C1_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_I2C1_CLKSOURCE_HSI, CL50_Constant(212), "LL_RCC_I2C1_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_I2C1_CLKSOURCE_CSI, CL50_Constant(213), "LL_RCC_I2C1_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_I2C23_CLKSOURCE_PCLK1, CL50_Constant(214), "LL_RCC_I2C23_CLKSOURCE_PCLK1")
        XCTAssertEqual(LL_RCC_I2C23_CLKSOURCE_PLL3R, CL50_Constant(215), "LL_RCC_I2C23_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_I2C23_CLKSOURCE_HSI, CL50_Constant(216), "LL_RCC_I2C23_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_I2C23_CLKSOURCE_CSI, CL50_Constant(217), "LL_RCC_I2C23_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_I3C1_CLKSOURCE_PCLK1, CL50_Constant(218), "LL_RCC_I3C1_CLKSOURCE_PCLK1")
        XCTAssertEqual(LL_RCC_I3C1_CLKSOURCE_PLL3R, CL50_Constant(219), "LL_RCC_I3C1_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_I3C1_CLKSOURCE_HSI, CL50_Constant(220), "LL_RCC_I3C1_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_I3C1_CLKSOURCE_CSI, CL50_Constant(221), "LL_RCC_I3C1_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_LPTIM1_CLKSOURCE_PCLK1, CL50_Constant(222), "LL_RCC_LPTIM1_CLKSOURCE_PCLK1")
        XCTAssertEqual(LL_RCC_LPTIM1_CLKSOURCE_PLL2P, CL50_Constant(223), "LL_RCC_LPTIM1_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_LPTIM1_CLKSOURCE_PLL3R, CL50_Constant(224), "LL_RCC_LPTIM1_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_LPTIM1_CLKSOURCE_LSE, CL50_Constant(225), "LL_RCC_LPTIM1_CLKSOURCE_LSE")
        XCTAssertEqual(LL_RCC_LPTIM1_CLKSOURCE_LSI, CL50_Constant(226), "LL_RCC_LPTIM1_CLKSOURCE_LSI")
        XCTAssertEqual(LL_RCC_LPTIM1_CLKSOURCE_CLKP, CL50_Constant(227), "LL_RCC_LPTIM1_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_LPTIM23_CLKSOURCE_PCLK4, CL50_Constant(228), "LL_RCC_LPTIM23_CLKSOURCE_PCLK4")
        XCTAssertEqual(LL_RCC_LPTIM23_CLKSOURCE_PLL2P, CL50_Constant(229), "LL_RCC_LPTIM23_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_LPTIM23_CLKSOURCE_PLL3R, CL50_Constant(230), "LL_RCC_LPTIM23_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_LPTIM23_CLKSOURCE_LSE, CL50_Constant(231), "LL_RCC_LPTIM23_CLKSOURCE_LSE")
        XCTAssertEqual(LL_RCC_LPTIM23_CLKSOURCE_LSI, CL50_Constant(232), "LL_RCC_LPTIM23_CLKSOURCE_LSI")
        XCTAssertEqual(LL_RCC_LPTIM23_CLKSOURCE_CLKP, CL50_Constant(233), "LL_RCC_LPTIM23_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_LPTIM45_CLKSOURCE_PCLK4, CL50_Constant(234), "LL_RCC_LPTIM45_CLKSOURCE_PCLK4")
        XCTAssertEqual(LL_RCC_LPTIM45_CLKSOURCE_PLL2P, CL50_Constant(235), "LL_RCC_LPTIM45_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_LPTIM45_CLKSOURCE_PLL3R, CL50_Constant(236), "LL_RCC_LPTIM45_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_LPTIM45_CLKSOURCE_LSE, CL50_Constant(237), "LL_RCC_LPTIM45_CLKSOURCE_LSE")
        XCTAssertEqual(LL_RCC_LPTIM45_CLKSOURCE_LSI, CL50_Constant(238), "LL_RCC_LPTIM45_CLKSOURCE_LSI")
        XCTAssertEqual(LL_RCC_LPTIM45_CLKSOURCE_CLKP, CL50_Constant(239), "LL_RCC_LPTIM45_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_LPUART1_CLKSOURCE_PCLK4, CL50_Constant(240), "LL_RCC_LPUART1_CLKSOURCE_PCLK4")
        XCTAssertEqual(LL_RCC_LPUART1_CLKSOURCE_PLL2Q, CL50_Constant(241), "LL_RCC_LPUART1_CLKSOURCE_PLL2Q")
        XCTAssertEqual(LL_RCC_LPUART1_CLKSOURCE_PLL3Q, CL50_Constant(242), "LL_RCC_LPUART1_CLKSOURCE_PLL3Q")
        XCTAssertEqual(LL_RCC_LPUART1_CLKSOURCE_HSI, CL50_Constant(243), "LL_RCC_LPUART1_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_LPUART1_CLKSOURCE_CSI, CL50_Constant(244), "LL_RCC_LPUART1_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_LPUART1_CLKSOURCE_LSE, CL50_Constant(245), "LL_RCC_LPUART1_CLKSOURCE_LSE")
        XCTAssertEqual(LL_RCC_LTDC_CLKSOURCE_PLL3R, CL50_Constant(246), "LL_RCC_LTDC_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_PSSI_CLKSOURCE_PLL3R, CL50_Constant(247), "LL_RCC_PSSI_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_PSSI_CLKSOURCE_CLKP, CL50_Constant(248), "LL_RCC_PSSI_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_SAI1_CLKSOURCE_PLL1Q, CL50_Constant(249), "LL_RCC_SAI1_CLKSOURCE_PLL1Q")
        XCTAssertEqual(LL_RCC_SAI1_CLKSOURCE_PLL2P, CL50_Constant(250), "LL_RCC_SAI1_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_SAI1_CLKSOURCE_PLL3P, CL50_Constant(251), "LL_RCC_SAI1_CLKSOURCE_PLL3P")
        XCTAssertEqual(LL_RCC_SAI1_CLKSOURCE_I2S_CKIN, CL50_Constant(252), "LL_RCC_SAI1_CLKSOURCE_I2S_CKIN")
        XCTAssertEqual(LL_RCC_SAI1_CLKSOURCE_CLKP, CL50_Constant(253), "LL_RCC_SAI1_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_SAI2_CLKSOURCE_PLL1Q, CL50_Constant(254), "LL_RCC_SAI2_CLKSOURCE_PLL1Q")
        XCTAssertEqual(LL_RCC_SAI2_CLKSOURCE_PLL2P, CL50_Constant(255), "LL_RCC_SAI2_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_SAI2_CLKSOURCE_PLL3P, CL50_Constant(256), "LL_RCC_SAI2_CLKSOURCE_PLL3P")
        XCTAssertEqual(LL_RCC_SAI2_CLKSOURCE_I2S_CKIN, CL50_Constant(257), "LL_RCC_SAI2_CLKSOURCE_I2S_CKIN")
        XCTAssertEqual(LL_RCC_SAI2_CLKSOURCE_CLKP, CL50_Constant(258), "LL_RCC_SAI2_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_SAI2_CLKSOURCE_SPDIFRX, CL50_Constant(259), "LL_RCC_SAI2_CLKSOURCE_SPDIFRX")
        XCTAssertEqual(LL_RCC_SDMMC_CLKSOURCE_PLL2S, CL50_Constant(260), "LL_RCC_SDMMC_CLKSOURCE_PLL2S")
        XCTAssertEqual(LL_RCC_SDMMC_CLKSOURCE_PLL2T, CL50_Constant(261), "LL_RCC_SDMMC_CLKSOURCE_PLL2T")
        XCTAssertEqual(LL_RCC_SPDIFRX_CLKSOURCE_PLL1Q, CL50_Constant(262), "LL_RCC_SPDIFRX_CLKSOURCE_PLL1Q")
        XCTAssertEqual(LL_RCC_SPDIFRX_CLKSOURCE_PLL2R, CL50_Constant(263), "LL_RCC_SPDIFRX_CLKSOURCE_PLL2R")
        XCTAssertEqual(LL_RCC_SPDIFRX_CLKSOURCE_PLL3R, CL50_Constant(264), "LL_RCC_SPDIFRX_CLKSOURCE_PLL3R")
        XCTAssertEqual(LL_RCC_SPDIFRX_CLKSOURCE_HSI, CL50_Constant(265), "LL_RCC_SPDIFRX_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_SPI1_CLKSOURCE_PLL1Q, CL50_Constant(266), "LL_RCC_SPI1_CLKSOURCE_PLL1Q")
        XCTAssertEqual(LL_RCC_SPI1_CLKSOURCE_PLL2P, CL50_Constant(267), "LL_RCC_SPI1_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_SPI1_CLKSOURCE_PLL3P, CL50_Constant(268), "LL_RCC_SPI1_CLKSOURCE_PLL3P")
        XCTAssertEqual(LL_RCC_SPI1_CLKSOURCE_I2S_CKIN, CL50_Constant(269), "LL_RCC_SPI1_CLKSOURCE_I2S_CKIN")
        XCTAssertEqual(LL_RCC_SPI1_CLKSOURCE_CLKP, CL50_Constant(270), "LL_RCC_SPI1_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_SPI23_CLKSOURCE_PLL1Q, CL50_Constant(271), "LL_RCC_SPI23_CLKSOURCE_PLL1Q")
        XCTAssertEqual(LL_RCC_SPI23_CLKSOURCE_PLL2P, CL50_Constant(272), "LL_RCC_SPI23_CLKSOURCE_PLL2P")
        XCTAssertEqual(LL_RCC_SPI23_CLKSOURCE_PLL3P, CL50_Constant(273), "LL_RCC_SPI23_CLKSOURCE_PLL3P")
        XCTAssertEqual(LL_RCC_SPI23_CLKSOURCE_I2S_CKIN, CL50_Constant(274), "LL_RCC_SPI23_CLKSOURCE_I2S_CKIN")
        XCTAssertEqual(LL_RCC_SPI23_CLKSOURCE_CLKP, CL50_Constant(275), "LL_RCC_SPI23_CLKSOURCE_CLKP")
        XCTAssertEqual(LL_RCC_SPI45_CLKSOURCE_PCLK2, CL50_Constant(276), "LL_RCC_SPI45_CLKSOURCE_PCLK2")
        XCTAssertEqual(LL_RCC_SPI45_CLKSOURCE_PLL2Q, CL50_Constant(277), "LL_RCC_SPI45_CLKSOURCE_PLL2Q")
        XCTAssertEqual(LL_RCC_SPI45_CLKSOURCE_PLL3Q, CL50_Constant(278), "LL_RCC_SPI45_CLKSOURCE_PLL3Q")
        XCTAssertEqual(LL_RCC_SPI45_CLKSOURCE_HSI, CL50_Constant(279), "LL_RCC_SPI45_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_SPI45_CLKSOURCE_CSI, CL50_Constant(280), "LL_RCC_SPI45_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_SPI45_CLKSOURCE_HSE, CL50_Constant(281), "LL_RCC_SPI45_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_SPI6_CLKSOURCE_PCLK4, CL50_Constant(282), "LL_RCC_SPI6_CLKSOURCE_PCLK4")
        XCTAssertEqual(LL_RCC_SPI6_CLKSOURCE_PLL2Q, CL50_Constant(283), "LL_RCC_SPI6_CLKSOURCE_PLL2Q")
        XCTAssertEqual(LL_RCC_SPI6_CLKSOURCE_PLL3Q, CL50_Constant(284), "LL_RCC_SPI6_CLKSOURCE_PLL3Q")
        XCTAssertEqual(LL_RCC_SPI6_CLKSOURCE_HSI, CL50_Constant(285), "LL_RCC_SPI6_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_SPI6_CLKSOURCE_CSI, CL50_Constant(286), "LL_RCC_SPI6_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_SPI6_CLKSOURCE_HSE, CL50_Constant(287), "LL_RCC_SPI6_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_USART1_CLKSOURCE_PCLK2, CL50_Constant(288), "LL_RCC_USART1_CLKSOURCE_PCLK2")
        XCTAssertEqual(LL_RCC_USART1_CLKSOURCE_PLL2Q, CL50_Constant(289), "LL_RCC_USART1_CLKSOURCE_PLL2Q")
        XCTAssertEqual(LL_RCC_USART1_CLKSOURCE_PLL3Q, CL50_Constant(290), "LL_RCC_USART1_CLKSOURCE_PLL3Q")
        XCTAssertEqual(LL_RCC_USART1_CLKSOURCE_HSI, CL50_Constant(291), "LL_RCC_USART1_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_USART1_CLKSOURCE_CSI, CL50_Constant(292), "LL_RCC_USART1_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_USART1_CLKSOURCE_LSE, CL50_Constant(293), "LL_RCC_USART1_CLKSOURCE_LSE")
        XCTAssertEqual(LL_RCC_USART234578_CLKSOURCE_PCLK1, CL50_Constant(294), "LL_RCC_USART234578_CLKSOURCE_PCLK1")
        XCTAssertEqual(LL_RCC_USART234578_CLKSOURCE_PLL2Q, CL50_Constant(295), "LL_RCC_USART234578_CLKSOURCE_PLL2Q")
        XCTAssertEqual(LL_RCC_USART234578_CLKSOURCE_PLL3Q, CL50_Constant(296), "LL_RCC_USART234578_CLKSOURCE_PLL3Q")
        XCTAssertEqual(LL_RCC_USART234578_CLKSOURCE_HSI, CL50_Constant(297), "LL_RCC_USART234578_CLKSOURCE_HSI")
        XCTAssertEqual(LL_RCC_USART234578_CLKSOURCE_CSI, CL50_Constant(298), "LL_RCC_USART234578_CLKSOURCE_CSI")
        XCTAssertEqual(LL_RCC_USART234578_CLKSOURCE_LSE, CL50_Constant(299), "LL_RCC_USART234578_CLKSOURCE_LSE")
        XCTAssertEqual(LL_RCC_OTGFS_CLKSOURCE_HSI48, CL50_Constant(300), "LL_RCC_OTGFS_CLKSOURCE_HSI48")
        XCTAssertEqual(LL_RCC_OTGFS_CLKSOURCE_PLL3Q, CL50_Constant(301), "LL_RCC_OTGFS_CLKSOURCE_PLL3Q")
        XCTAssertEqual(LL_RCC_OTGFS_CLKSOURCE_HSE, CL50_Constant(302), "LL_RCC_OTGFS_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_OTGFS_CLKSOURCE_CLK48, CL50_Constant(303), "LL_RCC_OTGFS_CLKSOURCE_CLK48")
        XCTAssertEqual(LL_RCC_USBPHYC_CLKSOURCE_HSE, CL50_Constant(304), "LL_RCC_USBPHYC_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_USBPHYC_CLKSOURCE_HSE_DIV_2, CL50_Constant(305), "LL_RCC_USBPHYC_CLKSOURCE_HSE_DIV_2")
        XCTAssertEqual(LL_RCC_USBPHYC_CLKSOURCE_PLL3Q, CL50_Constant(306), "LL_RCC_USBPHYC_CLKSOURCE_PLL3Q")
        XCTAssertEqual(LL_RCC_USBPHYC_CLKSOURCE_DISABLE, CL50_Constant(307), "LL_RCC_USBPHYC_CLKSOURCE_DISABLE")
        XCTAssertEqual(LL_RCC_USBREF_CLKSOURCE_16M, CL50_Constant(308), "LL_RCC_USBREF_CLKSOURCE_16M")
        XCTAssertEqual(LL_RCC_USBREF_CLKSOURCE_19_2M, CL50_Constant(309), "LL_RCC_USBREF_CLKSOURCE_19_2M")
        XCTAssertEqual(LL_RCC_USBREF_CLKSOURCE_20M, CL50_Constant(310), "LL_RCC_USBREF_CLKSOURCE_20M")
        XCTAssertEqual(LL_RCC_USBREF_CLKSOURCE_24M, CL50_Constant(311), "LL_RCC_USBREF_CLKSOURCE_24M")
        XCTAssertEqual(LL_RCC_USBREF_CLKSOURCE_26M, CL50_Constant(312), "LL_RCC_USBREF_CLKSOURCE_26M")
        XCTAssertEqual(LL_RCC_USBREF_CLKSOURCE_32M, CL50_Constant(313), "LL_RCC_USBREF_CLKSOURCE_32M")
        XCTAssertEqual(LL_RCC_XSPI1_CLKSOURCE_HCLK, CL50_Constant(314), "LL_RCC_XSPI1_CLKSOURCE_HCLK")
        XCTAssertEqual(LL_RCC_XSPI1_CLKSOURCE_PLL2S, CL50_Constant(315), "LL_RCC_XSPI1_CLKSOURCE_PLL2S")
        XCTAssertEqual(LL_RCC_XSPI1_CLKSOURCE_PLL2T, CL50_Constant(316), "LL_RCC_XSPI1_CLKSOURCE_PLL2T")
        XCTAssertEqual(LL_RCC_XSPI1_CLKSOURCE_HCLK_DIV4, CL50_Constant(317), "LL_RCC_XSPI1_CLKSOURCE_HCLK_DIV4")
        XCTAssertEqual(LL_RCC_XSPI2_CLKSOURCE_HCLK, CL50_Constant(318), "LL_RCC_XSPI2_CLKSOURCE_HCLK")
        XCTAssertEqual(LL_RCC_XSPI2_CLKSOURCE_PLL2S, CL50_Constant(319), "LL_RCC_XSPI2_CLKSOURCE_PLL2S")
        XCTAssertEqual(LL_RCC_XSPI2_CLKSOURCE_PLL2T, CL50_Constant(320), "LL_RCC_XSPI2_CLKSOURCE_PLL2T")
        XCTAssertEqual(LL_RCC_XSPI2_CLKSOURCE_HCLK_DIV4, CL50_Constant(321), "LL_RCC_XSPI2_CLKSOURCE_HCLK_DIV4")
        XCTAssertEqual(LL_RCC_ADC_CLKSOURCE, CL50_Constant(322), "LL_RCC_ADC_CLKSOURCE")
        XCTAssertEqual(LL_RCC_ADF1_CLKSOURCE, CL50_Constant(323), "LL_RCC_ADF1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_CEC_CLKSOURCE, CL50_Constant(324), "LL_RCC_CEC_CLKSOURCE")
        XCTAssertEqual(LL_RCC_CLKP_CLKSOURCE, CL50_Constant(325), "LL_RCC_CLKP_CLKSOURCE")
        XCTAssertEqual(LL_RCC_ETH1PHY_CLKSOURCE, CL50_Constant(326), "LL_RCC_ETH1PHY_CLKSOURCE")
        XCTAssertEqual(LL_RCC_ETH1REF_CLKSOURCE, CL50_Constant(327), "LL_RCC_ETH1REF_CLKSOURCE")
        XCTAssertEqual(LL_RCC_FDCAN_CLKSOURCE, CL50_Constant(328), "LL_RCC_FDCAN_CLKSOURCE")
        XCTAssertEqual(LL_RCC_FMC_CLKSOURCE, CL50_Constant(329), "LL_RCC_FMC_CLKSOURCE")
        XCTAssertEqual(LL_RCC_I2C1_CLKSOURCE, CL50_Constant(330), "LL_RCC_I2C1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_I2C23_CLKSOURCE, CL50_Constant(331), "LL_RCC_I2C23_CLKSOURCE")
        XCTAssertEqual(LL_RCC_I3C1_CLKSOURCE, CL50_Constant(332), "LL_RCC_I3C1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_LPTIM1_CLKSOURCE, CL50_Constant(333), "LL_RCC_LPTIM1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_LPTIM23_CLKSOURCE, CL50_Constant(334), "LL_RCC_LPTIM23_CLKSOURCE")
        XCTAssertEqual(LL_RCC_LPTIM45_CLKSOURCE, CL50_Constant(335), "LL_RCC_LPTIM45_CLKSOURCE")
        XCTAssertEqual(LL_RCC_LPUART1_CLKSOURCE, CL50_Constant(336), "LL_RCC_LPUART1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_OTGFS_CLKSOURCE, CL50_Constant(337), "LL_RCC_OTGFS_CLKSOURCE")
        XCTAssertEqual(LL_RCC_PSSI_CLKSOURCE, CL50_Constant(338), "LL_RCC_PSSI_CLKSOURCE")
        XCTAssertEqual(LL_RCC_SAI1_CLKSOURCE, CL50_Constant(339), "LL_RCC_SAI1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_SAI2_CLKSOURCE, CL50_Constant(340), "LL_RCC_SAI2_CLKSOURCE")
        XCTAssertEqual(LL_RCC_SDMMC_CLKSOURCE, CL50_Constant(341), "LL_RCC_SDMMC_CLKSOURCE")
        XCTAssertEqual(LL_RCC_SPDIFRX_CLKSOURCE, CL50_Constant(342), "LL_RCC_SPDIFRX_CLKSOURCE")
        XCTAssertEqual(LL_RCC_SPI1_CLKSOURCE, CL50_Constant(343), "LL_RCC_SPI1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_SPI23_CLKSOURCE, CL50_Constant(344), "LL_RCC_SPI23_CLKSOURCE")
        XCTAssertEqual(LL_RCC_SPI45_CLKSOURCE, CL50_Constant(345), "LL_RCC_SPI45_CLKSOURCE")
        XCTAssertEqual(LL_RCC_SPI6_CLKSOURCE, CL50_Constant(346), "LL_RCC_SPI6_CLKSOURCE")
        XCTAssertEqual(LL_RCC_USART1_CLKSOURCE, CL50_Constant(347), "LL_RCC_USART1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_USART234578_CLKSOURCE, CL50_Constant(348), "LL_RCC_USART234578_CLKSOURCE")
        XCTAssertEqual(LL_RCC_USBPHYC_CLKSOURCE, CL50_Constant(349), "LL_RCC_USBPHYC_CLKSOURCE")
        XCTAssertEqual(LL_RCC_USBREF_CLKSOURCE, CL50_Constant(350), "LL_RCC_USBREF_CLKSOURCE")
        XCTAssertEqual(LL_RCC_XSPI1_CLKSOURCE, CL50_Constant(351), "LL_RCC_XSPI1_CLKSOURCE")
        XCTAssertEqual(LL_RCC_XSPI2_CLKSOURCE, CL50_Constant(352), "LL_RCC_XSPI2_CLKSOURCE")
        XCTAssertEqual(LL_RCC_RTC_CLKSOURCE_NONE, CL50_Constant(353), "LL_RCC_RTC_CLKSOURCE_NONE")
        XCTAssertEqual(LL_RCC_RTC_CLKSOURCE_LSE, CL50_Constant(354), "LL_RCC_RTC_CLKSOURCE_LSE")
        XCTAssertEqual(LL_RCC_RTC_CLKSOURCE_LSI, CL50_Constant(355), "LL_RCC_RTC_CLKSOURCE_LSI")
        XCTAssertEqual(LL_RCC_RTC_CLKSOURCE_HSE, CL50_Constant(356), "LL_RCC_RTC_CLKSOURCE_HSE")
        XCTAssertEqual(LL_RCC_TIM_PRESCALER_TWICE, CL50_Constant(357), "LL_RCC_TIM_PRESCALER_TWICE")
        XCTAssertEqual(LL_RCC_TIM_PRESCALER_FOUR_TIMES, CL50_Constant(358), "LL_RCC_TIM_PRESCALER_FOUR_TIMES")
        XCTAssertEqual(LL_RCC_TIM_PRESCALER_DISABLE, CL50_Constant(359), "LL_RCC_TIM_PRESCALER_DISABLE")
        XCTAssertEqual(LL_RCC_TIM_PRESCALER_ENABLE, CL50_Constant(360), "LL_RCC_TIM_PRESCALER_ENABLE")
        XCTAssertEqual(LL_RCC_PLLSOURCE_HSI, CL50_Constant(361), "LL_RCC_PLLSOURCE_HSI")
        XCTAssertEqual(LL_RCC_PLLSOURCE_CSI, CL50_Constant(362), "LL_RCC_PLLSOURCE_CSI")
        XCTAssertEqual(LL_RCC_PLLSOURCE_HSE, CL50_Constant(363), "LL_RCC_PLLSOURCE_HSE")
        XCTAssertEqual(LL_RCC_PLLSOURCE_NONE, CL50_Constant(364), "LL_RCC_PLLSOURCE_NONE")
        XCTAssertEqual(LL_RCC_PLLINPUTRANGE_1_2, CL50_Constant(365), "LL_RCC_PLLINPUTRANGE_1_2")
        XCTAssertEqual(LL_RCC_PLLINPUTRANGE_2_4, CL50_Constant(366), "LL_RCC_PLLINPUTRANGE_2_4")
        XCTAssertEqual(LL_RCC_PLLINPUTRANGE_4_8, CL50_Constant(367), "LL_RCC_PLLINPUTRANGE_4_8")
        XCTAssertEqual(LL_RCC_PLLINPUTRANGE_8_16, CL50_Constant(368), "LL_RCC_PLLINPUTRANGE_8_16")
        XCTAssertEqual(LL_RCC_PLLVCORANGE_WIDE, CL50_Constant(369), "LL_RCC_PLLVCORANGE_WIDE")
        XCTAssertEqual(LL_RCC_PLLVCORANGE_MEDIUM, CL50_Constant(370), "LL_RCC_PLLVCORANGE_MEDIUM")
        XCTAssertEqual(LL_RCC_PLL_SPREAD_CENTER, CL50_Constant(371), "LL_RCC_PLL_SPREAD_CENTER")
        XCTAssertEqual(LL_RCC_PLL_SPREAD_DOWN, CL50_Constant(372), "LL_RCC_PLL_SPREAD_DOWN")
        XCTAssertEqual(LL_RCC_PLL_DITHERING_TPDFN_ENABLE, CL50_Constant(373), "LL_RCC_PLL_DITHERING_TPDFN_ENABLE")
        XCTAssertEqual(LL_RCC_PLL_DITHERING_TPDFN_DISABLE, CL50_Constant(374), "LL_RCC_PLL_DITHERING_TPDFN_DISABLE")
        XCTAssertEqual(LL_RCC_PLL_DITHERING_RPDFN_ENABLE, CL50_Constant(375), "LL_RCC_PLL_DITHERING_RPDFN_ENABLE")
        XCTAssertEqual(LL_RCC_PLL_DITHERING_RPDFN_DISABLE, CL50_Constant(376), "LL_RCC_PLL_DITHERING_RPDFN_DISABLE")
        XCTAssertEqual(LL_RCC_PERIPH_FREQUENCY_NO, CL50_Constant(377), "LL_RCC_PERIPH_FREQUENCY_NO")
        XCTAssertEqual(LL_RCC_PERIPH_FREQUENCY_NA, CL50_Constant(378), "LL_RCC_PERIPH_FREQUENCY_NA")
        XCTAssertEqual(LL_CRS_ISR_SYNCOKF, CL50_Constant(379), "LL_CRS_ISR_SYNCOKF")
        XCTAssertEqual(LL_CRS_ISR_SYNCWARNF, CL50_Constant(380), "LL_CRS_ISR_SYNCWARNF")
        XCTAssertEqual(LL_CRS_ISR_ERRF, CL50_Constant(381), "LL_CRS_ISR_ERRF")
        XCTAssertEqual(LL_CRS_ISR_ESYNCF, CL50_Constant(382), "LL_CRS_ISR_ESYNCF")
        XCTAssertEqual(LL_CRS_ISR_SYNCERR, CL50_Constant(383), "LL_CRS_ISR_SYNCERR")
        XCTAssertEqual(LL_CRS_ISR_SYNCMISS, CL50_Constant(384), "LL_CRS_ISR_SYNCMISS")
        XCTAssertEqual(LL_CRS_ISR_TRIMOVF, CL50_Constant(385), "LL_CRS_ISR_TRIMOVF")
        XCTAssertEqual(LL_CRS_CR_SYNCOKIE, CL50_Constant(386), "LL_CRS_CR_SYNCOKIE")
        XCTAssertEqual(LL_CRS_CR_SYNCWARNIE, CL50_Constant(387), "LL_CRS_CR_SYNCWARNIE")
        XCTAssertEqual(LL_CRS_CR_ERRIE, CL50_Constant(388), "LL_CRS_CR_ERRIE")
        XCTAssertEqual(LL_CRS_CR_ESYNCIE, CL50_Constant(389), "LL_CRS_CR_ESYNCIE")
        XCTAssertEqual(LL_CRS_SYNC_DIV_1, CL50_Constant(390), "LL_CRS_SYNC_DIV_1")
        XCTAssertEqual(LL_CRS_SYNC_DIV_2, CL50_Constant(391), "LL_CRS_SYNC_DIV_2")
        XCTAssertEqual(LL_CRS_SYNC_DIV_4, CL50_Constant(392), "LL_CRS_SYNC_DIV_4")
        XCTAssertEqual(LL_CRS_SYNC_DIV_8, CL50_Constant(393), "LL_CRS_SYNC_DIV_8")
        XCTAssertEqual(LL_CRS_SYNC_DIV_16, CL50_Constant(394), "LL_CRS_SYNC_DIV_16")
        XCTAssertEqual(LL_CRS_SYNC_DIV_32, CL50_Constant(395), "LL_CRS_SYNC_DIV_32")
        XCTAssertEqual(LL_CRS_SYNC_DIV_64, CL50_Constant(396), "LL_CRS_SYNC_DIV_64")
        XCTAssertEqual(LL_CRS_SYNC_DIV_128, CL50_Constant(397), "LL_CRS_SYNC_DIV_128")
        XCTAssertEqual(LL_CRS_SYNC_SOURCE_GPIO, CL50_Constant(398), "LL_CRS_SYNC_SOURCE_GPIO")
        XCTAssertEqual(LL_CRS_SYNC_SOURCE_LSE, CL50_Constant(399), "LL_CRS_SYNC_SOURCE_LSE")
        XCTAssertEqual(LL_CRS_SYNC_SOURCE_OTG_FS, CL50_Constant(400), "LL_CRS_SYNC_SOURCE_OTG_FS")
        XCTAssertEqual(LL_CRS_SYNC_SOURCE_OTG_HS, CL50_Constant(401), "LL_CRS_SYNC_SOURCE_OTG_HS")
        XCTAssertEqual(LL_CRS_SYNC_POLARITY_RISING, CL50_Constant(402), "LL_CRS_SYNC_POLARITY_RISING")
        XCTAssertEqual(LL_CRS_SYNC_POLARITY_FALLING, CL50_Constant(403), "LL_CRS_SYNC_POLARITY_FALLING")
        XCTAssertEqual(LL_CRS_FREQ_ERROR_DIR_UP, CL50_Constant(404), "LL_CRS_FREQ_ERROR_DIR_UP")
        XCTAssertEqual(LL_CRS_FREQ_ERROR_DIR_DOWN, CL50_Constant(405), "LL_CRS_FREQ_ERROR_DIR_DOWN")
        XCTAssertEqual(LL_CRS_RELOADVALUE_DEFAULT, CL50_Constant(406), "LL_CRS_RELOADVALUE_DEFAULT")
        XCTAssertEqual(LL_CRS_ERRORLIMIT_DEFAULT, CL50_Constant(407), "LL_CRS_ERRORLIMIT_DEFAULT")
        XCTAssertEqual(LL_CRS_HSI48CALIBRATION_DEFAULT, CL50_Constant(408), "LL_CRS_HSI48CALIBRATION_DEFAULT")
        XCTAssertEqual(LL_MAX_DELAY, CL50_Constant(409), "LL_MAX_DELAY")
        XCTAssertEqual(LL_UTILS_HSEBYPASS_OFF, CL50_Constant(410), "LL_UTILS_HSEBYPASS_OFF")
        XCTAssertEqual(LL_UTILS_HSEBYPASS_ON, CL50_Constant(411), "LL_UTILS_HSEBYPASS_ON")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_VFQFPN68_GP, CL50_Constant(412), "LL_UTILS_PACKAGETYPE_VFQFPN68_GP")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_TFBGA100_SMPS_GP, CL50_Constant(413), "LL_UTILS_PACKAGETYPE_TFBGA100_SMPS_GP")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_LQFP100_GP, CL50_Constant(414), "LL_UTILS_PACKAGETYPE_LQFP100_GP")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_LQFP144_GP, CL50_Constant(415), "LL_UTILS_PACKAGETYPE_LQFP144_GP")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_UFBGA144_SMPS_GP, CL50_Constant(416), "LL_UTILS_PACKAGETYPE_UFBGA144_SMPS_GP")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_UFBGA144_SMPS_GFX, CL50_Constant(417), "LL_UTILS_PACKAGETYPE_UFBGA144_SMPS_GFX")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_UFBGA169_SMPS_GFX, CL50_Constant(418), "LL_UTILS_PACKAGETYPE_UFBGA169_SMPS_GFX")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_UFBGA169_SMPS_GP, CL50_Constant(419), "LL_UTILS_PACKAGETYPE_UFBGA169_SMPS_GP")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_UFBGA176_25_SMPS_GP, CL50_Constant(420), "LL_UTILS_PACKAGETYPE_UFBGA176_25_SMPS_GP")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_LQFP176_SMPS_GP, CL50_Constant(421), "LL_UTILS_PACKAGETYPE_LQFP176_SMPS_GP")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_LQFP176_SMPS_GFX, CL50_Constant(422), "LL_UTILS_PACKAGETYPE_LQFP176_SMPS_GFX")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_UFBGA176_25_SMPS_GFX, CL50_Constant(423), "LL_UTILS_PACKAGETYPE_UFBGA176_25_SMPS_GFX")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_TFBGA225_OCTO, CL50_Constant(424), "LL_UTILS_PACKAGETYPE_TFBGA225_OCTO")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_TFBGA225_HEXA, CL50_Constant(425), "LL_UTILS_PACKAGETYPE_TFBGA225_HEXA")
        XCTAssertEqual(LL_UTILS_PACKAGETYPE_WLCSP_SMPS_GP, CL50_Constant(426), "LL_UTILS_PACKAGETYPE_WLCSP_SMPS_GP")
        for i in 0..<16 { XCTAssertEqual(UInt32(LL_RCC_PrescTable[i]), CL50_Constant(427 + UInt32(i))) }
        XCTAssertEqual(RCCOscillatorValues.llDefaults.external, 12_288_000)
    }
}
