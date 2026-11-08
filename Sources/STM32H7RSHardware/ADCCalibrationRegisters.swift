// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Factory calibration addresses from stm32h7rsxx_ll_adc.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

import STM32H7RSHAL
import _Volatile

public struct STM32ADCCalibrationRegisters: ADCCalibrationIO {
    public init() {}
    public func read(_ word: ADCFactoryCalibrationWord) -> UInt16 {
        VolatileMappedRegister<UInt16>(unsafeBitPattern: address(of: word)).load()
    }
    func address(of word: ADCFactoryCalibrationWord) -> UInt { 0x08FFF810 + UInt(word.rawValue) }
}
