// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// UART_GETCLOCKSOURCE and UART_SetConfig clock selection from HAL revision
// 606ed7132ef1bc32c77fd9a040103bc98f23c748. See LICENSES/NOTICE.txt.
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32UARTClockRegisters: UARTClockIO {
    public let oscillators: RCCOscillatorValues
    public init(oscillators: RCCOscillatorValues = .init()) { self.oscillators = oscillators }

    public func source(for instance: UARTInstance) -> UARTClockSource {
        let selection: UInt32
        let peripheralClock: UARTClockSource
        switch instance {
        case .usart1:
            selection = rcc.ccipr3.read().raw.storage & 7
            peripheralClock = .pclk2
        case .lpuart1:
            selection = rcc.ccipr4.read().raw.storage & 7
            peripheralClock = .pclk4
        default:
            selection = rcc.ccipr2.read().raw.storage & 7
            peripheralClock = .pclk1
        }
        switch selection {
        case 0: return peripheralClock
        case 1: return .pll2Q
        case 2: return .pll3Q
        case 3: return .hsi
        case 4: return .csi
        case 5: return .lse
        default: return .undefined
        }
    }

    public func frequency(_ source: UARTClockSource) -> UInt32 {
        var clocks = RCCClock<STM32RCCClockRegisters>(oscillators: oscillators)
        switch source {
        case .pclk1: return clocks.getPCLK1Freq()
        case .pclk2: return clocks.getPCLK2Freq()
        case .pclk4: return clocks.getPCLK4Freq()
        case .pll2Q: return clocks.getPLL2QFreq()
        case .pll3Q: return clocks.getPLL3QFreq()
        case .hsi:
            if rcc.cr.read().raw.storage & 0x20 != 0 {
                return oscillators.hsi >> ((rcc.cr.read().raw.storage & 0x18) >> 3)
            }
            return oscillators.hsi
        case .csi: return oscillators.csi
        case .lse: return oscillators.lse
        case .undefined: return 0
        }
    }
}
