// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Register configuration and suspend/resume functions from stm32h7rsxx_hal_dma_ex.c
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct DMADataHandlingConfiguration: Equatable, Sendable {
    public var alignment: UInt32
    public var exchange: UInt32
    public init(alignment: UInt32 = 0, exchange: UInt32 = 0) {
        self.alignment = alignment
        self.exchange = exchange
    }
}

public struct DMATriggerConfiguration: Equatable, Sendable {
    public var mode: UInt32
    public var polarity: UInt32
    public var selection: UInt32
    public init(mode: UInt32 = 0, polarity: UInt32 = 0, selection: UInt32 = 0) {
        self.mode = mode
        self.polarity = polarity
        self.selection = selection
    }
}

public struct DMARepeatBlockConfiguration: Equatable, Sendable {
    public var repeatCount: UInt32
    public var sourceAddressOffset: Int32
    public var destinationAddressOffset: Int32
    public var blockSourceAddressOffset: Int32
    public var blockDestinationAddressOffset: Int32
    public init(repeatCount: UInt32 = 1, sourceAddressOffset: Int32 = 0,
                destinationAddressOffset: Int32 = 0, blockSourceAddressOffset: Int32 = 0,
                blockDestinationAddressOffset: Int32 = 0) {
        self.repeatCount = repeatCount
        self.sourceAddressOffset = sourceAddressOffset
        self.destinationAddressOffset = destinationAddressOffset
        self.blockSourceAddressOffset = blockSourceAddressOffset
        self.blockDestinationAddressOffset = blockDestinationAddressOffset
    }
}

extension DMA {
    @discardableResult
    public func configureDataHandling(_ configuration: DMADataHandlingConfiguration?) -> HALStatus {
        guard let configuration else { return .error }
        precondition(configuration.alignment == 0 || configuration.alignment == 0x800 || configuration.alignment == 0x1000)
        precondition(configuration.exchange & ~UInt32(0x1C00_2000) == 0)
        if handle.read(.state) == DMAState.ready.rawValue {
            registers.write(.ctr1, value: (registers.read(.ctr1) & ~UInt32(0x1C00_3800)) |
                            configuration.alignment | configuration.exchange)
        } else {
            handle.write(.errorCode, value: DMAError.busy.rawValue)
            handle.write(.lock, value: 0)
            return .error
        }
        return .ok
    }

    @discardableResult
    public func configureTrigger(_ configuration: DMATriggerConfiguration?) -> HALStatus {
        guard let configuration else { return .error }
        precondition(configuration.polarity == 0 || configuration.polarity == 0x0100_0000 || configuration.polarity == 0x0200_0000)
        precondition(configuration.mode == 0 || configuration.mode == 0x4000 || configuration.mode == 0x8000 || configuration.mode == 0xC000)
        precondition(configuration.selection <= 55)
        if handle.read(.state) == DMAState.ready.rawValue {
            registers.write(.ctr2, value: (registers.read(.ctr2) & ~UInt32(0x033F_C000)) |
                            configuration.polarity | configuration.mode | (configuration.selection << 16))
        } else {
            handle.write(.errorCode, value: DMAError.busy.rawValue)
            handle.write(.lock, value: 0)
            return .error
        }
        return .ok
    }

    @discardableResult
    public func configureRepeatBlock(_ configuration: DMARepeatBlockConfiguration?) -> HALStatus {
        guard let configuration else { return .error }
        precondition(registers.channel.supports2DAddressing)
        // IS_DMA_REPEAT_COUNT accepts 1...2047, despite the C field comment.
        precondition(configuration.repeatCount > 0 && configuration.repeatCount <= 0x7FF)
        precondition(configuration.sourceAddressOffset > -8192 && configuration.sourceAddressOffset < 8192)
        precondition(configuration.destinationAddressOffset > -8192 && configuration.destinationAddressOffset < 8192)
        precondition(configuration.blockSourceAddressOffset > -65536 && configuration.blockSourceAddressOffset < 65536)
        precondition(configuration.blockDestinationAddressOffset > -65536 && configuration.blockDestinationAddressOffset < 65536)
        if handle.read(.state) == DMAState.ready.rawValue {
            var value1 = (configuration.repeatCount &- 1) << 16
            var value2: UInt32
            if configuration.destinationAddressOffset < 0 {
                value1 |= 0x2000_0000
                value2 = UInt32(-configuration.destinationAddressOffset)
                value2 = value2 << 16
            } else {
                value2 = UInt32(configuration.destinationAddressOffset) << 16
            }
            if configuration.sourceAddressOffset < 0 {
                value1 |= 0x1000_0000
                value2 |= UInt32(-configuration.sourceAddressOffset)
            } else {
                value2 |= UInt32(configuration.sourceAddressOffset)
            }
            registers.write(.ctr3, value: value2)
            if configuration.blockDestinationAddressOffset < 0 {
                value1 |= 0x8000_0000
                value2 = UInt32(-configuration.blockDestinationAddressOffset)
                value2 = value2 << 16
            } else {
                value2 = UInt32(configuration.blockDestinationAddressOffset) << 16
            }
            if configuration.blockSourceAddressOffset < 0 {
                value1 |= 0x4000_0000
                value2 |= UInt32(-configuration.blockSourceAddressOffset)
            } else {
                value2 |= UInt32(configuration.blockSourceAddressOffset)
            }
            registers.write(.cbr2, value: value2)
            // The C function overwrites CBR1, including its byte count.
            registers.write(.cbr1, value: value1)
        } else {
            handle.write(.errorCode, value: DMAError.busy.rawValue)
            handle.write(.lock, value: 0)
            return .error
        }
        return .ok
    }

    @discardableResult
    public func suspend(getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        if handle.read(.state) != DMAState.busy.rawValue {
            handle.write(.errorCode, value: DMAError.noTransfer.rawValue)
            handle.write(.lock, value: 0)
            return .error
        } else {
            registers.write(.ccr, value: registers.read(.ccr) | 4)
            while registers.read(.csr) & 0x2000 == 0 {
                if (getTick() &- start) > 5 {
                    handle.write(.errorCode, value: handle.read(.errorCode) | DMAError.timeout.rawValue)
                    handle.write(.state, value: DMAState.error.rawValue)
                    handle.write(.lock, value: 0)
                    return .error
                }
            }
            handle.write(.state, value: DMAState.suspend.rawValue)
        }
        return .ok
    }

    @discardableResult
    public func suspendInterrupt() -> HALStatus {
        if handle.read(.state) != DMAState.busy.rawValue {
            handle.write(.errorCode, value: DMAError.noTransfer.rawValue)
            handle.write(.lock, value: 0)
            return .error
        } else {
            registers.write(.ccr, value: registers.read(.ccr) | 0x2004)
        }
        return .ok
    }

    @discardableResult
    public func resume() -> HALStatus {
        if handle.read(.state) != DMAState.suspend.rawValue {
            handle.write(.errorCode, value: DMAError.noTransfer.rawValue)
            handle.write(.lock, value: 0)
            return .error
        } else {
            registers.write(.ccr, value: registers.read(.ccr) & ~UInt32(4))
            // Preserve upstream read/modify/write even for this clear register.
            registers.write(.cfcr, value: registers.read(.cfcr) | 0x2000)
            handle.write(.state, value: DMAState.busy.rawValue)
        }
        return .ok
    }

    public func getFIFOLevel() -> UInt32 {
        // The C mask is eight bits, including on HPDMA whose SVD field is wider.
        (registers.read(.csr) & 0x00FF_0000) >> 16
    }
}
