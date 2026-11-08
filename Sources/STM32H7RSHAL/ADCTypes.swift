// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum ADCInstance: UInt32, CaseIterable, Sendable { case adc1 = 0, adc2 = 1 }
public enum ADCRegister: UInt32, CaseIterable, Sendable {
    case isr = 0x0
    case ier = 0x4
    case cr = 0x8
    case cfgr = 0xC
    case cfgr2 = 0x10
    case smpr1 = 0x14
    case smpr2 = 0x18
    case tr1 = 0x20
    case tr2 = 0x24
    case tr3 = 0x28
    case sqr1 = 0x30
    case sqr2 = 0x34
    case sqr3 = 0x38
    case sqr4 = 0x3C
    case dr = 0x40
    case jsqr = 0x4C
    case ofr1 = 0x60
    case ofr2 = 0x64
    case ofr3 = 0x68
    case ofr4 = 0x6C
    case jdr1 = 0x80
    case jdr2 = 0x84
    case jdr3 = 0x88
    case jdr4 = 0x8C
    case awd2cr = 0xA0
    case awd3cr = 0xA4
    case difsel = 0xB0
    case calfact = 0xB4
    case or = 0xC8
}
public enum ADCCommonRegister: UInt32, CaseIterable, Sendable { case csr = 0, ccr = 8, cdr = 12 }
public protocol ADCRegisterIO {
    func read(_ register: ADCRegister, instance: ADCInstance) -> UInt32
    func write(_ register: ADCRegister, instance: ADCInstance, value: UInt32)
    func readCommon(_ register: ADCCommonRegister) -> UInt32
    func writeCommon(_ register: ADCCommonRegister, value: UInt32)
    func dataAddress(instance: ADCInstance) -> UInt32
    func commonDataAddress() -> UInt32
    func systemCoreClock() -> UInt32
    // Execute the original volatile decrement loop, including under optimization.
    func stabilizationDelay(iterations: UInt32)
}
public enum ADCHandleWord: Int, CaseIterable {
    case clockPrescaler = 0
    case resolution = 1
    case dataAlign = 2
    case scanConvMode = 3
    case eocSelection = 4
    case lowPowerAutoWait = 5
    case continuousConvMode = 6
    case nbrOfConversion = 7
    case discontinuousConvMode = 8
    case nbrOfDiscConversion = 9
    case externalTrigConv = 10
    case externalTrigConvEdge = 11
    case samplingMode = 12
    case conversionDataManagement = 13
    case overrun = 14
    case oversamplingMode = 15
    case oversamplingRatio = 16
    case oversamplingRightBitShift = 17
    case oversamplingTriggeredMode = 18
    case oversamplingOversamplingStopReset = 19
    case lock = 20
    case state = 21
    case errorCode = 22
    case injectionContextQueue = 23
    case injectionChannelCount = 24
}
public protocol ADCHandleIO {
    func read(_ word: ADCHandleWord) -> UInt32
    func write(_ word: ADCHandleWord, value: UInt32)
}
public struct ADC<Registers: ADCRegisterIO, Handle: ADCHandleIO, Callbacks: ADCCallbackIO, DMAIO: ADCDMAIO> {
    public let instance: ADCInstance
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let dma: DMAIO
    public let defaults: ADCCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(instance: ADCInstance, registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
                defaults: ADCCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.instance = instance; self.registers = registers; self.handle = handle
        self.callbacks = callbacks; self.dma = dma; self.defaults = defaults
        self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
