// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// GPU2D register access from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748
// and CMSIS device 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import STM32H7RSHAL
import _Volatile

// Only STM32H7R7/H7S7 contain GPU2D. The pinned SVDs have no GPU2D block;
// the C HAL likewise exposes raw offsets instead of typed GPU2D registers.
public struct STM32GPU2DRegisters: GPU2DRegisterIO {
    public init() {}
    public static func address(offset: UInt32) -> UInt {
        precondition(offset < 0x1000)
        return 0x5201_4000 + UInt(offset)
    }
    public func read(offset: UInt32) -> UInt32 {
        precondition(offset & 3 == 0)
        return VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.address(offset: offset)).load()
    }
    public func write(offset: UInt32, value: UInt32) {
        precondition(offset & 3 == 0)
        VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.address(offset: offset)).store(value)
    }
}
public extension GPU2D where Registers == STM32GPU2DRegisters {
    init(handle: Handle, callbacks: Callbacks, defaults: GPU2DCallbackDefaults = .init(),
         useRegisteredCallbacks: Bool = false) {
        self.init(registers: STM32GPU2DRegisters(), handle: handle, callbacks: callbacks,
                  defaults: defaults, useRegisteredCallbacks: useRegisteredCallbacks)
    }
}
