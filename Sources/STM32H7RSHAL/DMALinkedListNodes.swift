// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DMA node construction/readback from stm32h7rsxx_hal_dma_ex.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DMALinkedList {
    @discardableResult
    public func buildNode(_ configuration: DMANodeConfiguration?, at address: UInt32) -> HALStatus {
        guard let configuration, address != 0 else { return .error }
        validateNode(configuration)
        let c = configuration.configuration
        let r = configuration.repeatBlock
        setNode(address, 0, c.destinationIncrement | c.destinationDataWidth | configuration.dataHandling.alignment |
                c.sourceIncrement | c.sourceDataWidth)
        if configuration.nodeType & 0x60 != 0 {
            setNode(address, 0, node(address, 0) | c.transferAllocatedPort | configuration.dataHandling.exchange |
                    (((c.destinationBurstLength &- 1) << 20) & 0x03F0_0000) |
                    (((c.sourceBurstLength &- 1) << 4) & 0x3F0))
        }
        setNode(address, 1, c.transferEventMode | (c.request & 0x27F))
        if c.direction == 0x400 {
            if configuration.nodeType & 0x60 != 0 { setNode(address, 1, node(address, 1) | 0x400) }
        } else if c.direction == 0x200 {
            setNode(address, 1, node(address, 1) | 0x200)
        }
        // The original builder does not apply BlkHWRequest to CTR2.
        setNode(address, 1, node(address, 1) | c.mode)
        if configuration.trigger.polarity != 0 {
            setNode(address, 1, node(address, 1) | configuration.trigger.mode | configuration.trigger.polarity |
                    ((configuration.trigger.selection << 16) & 0x003F_0000))
        }
        setNode(address, 2, configuration.dataSize & 0xFFFF)
        if configuration.nodeType & 2 == 2 {
            setNode(address, 2, node(address, 2) | (((r.repeatCount &- 1) << 16) & 0x07FF_0000))
            if r.sourceAddressOffset < 0 { setNode(address, 2, node(address, 2) | 0x1000_0000) }
            else { setNode(address, 2, node(address, 2) & ~UInt32(0x1000_0000)) }
            if r.destinationAddressOffset < 0 { setNode(address, 2, node(address, 2) | 0x2000_0000) }
            else { setNode(address, 2, node(address, 2) & ~UInt32(0x2000_0000)) }
            if r.blockSourceAddressOffset < 0 { setNode(address, 2, node(address, 2) | 0x4000_0000) }
            else { setNode(address, 2, node(address, 2) & ~UInt32(0x4000_0000)) }
            if r.blockDestinationAddressOffset < 0 { setNode(address, 2, node(address, 2) | 0x8000_0000) }
            else { setNode(address, 2, node(address, 2) & ~UInt32(0x8000_0000)) }
        }
        setNode(address, 3, configuration.sourceAddress)
        setNode(address, 4, configuration.destinationAddress)
        if configuration.nodeType & 2 == 2 {
            if r.sourceAddressOffset < 0 { setNode(address, 5, UInt32(-r.sourceAddressOffset) & 0x1FFF) }
            else { setNode(address, 5, UInt32(r.sourceAddressOffset) & 0x1FFF) }
            if r.destinationAddressOffset < 0 {
                setNode(address, 5, node(address, 5) | ((UInt32(-r.destinationAddressOffset) << 16) & 0x1FFF_0000))
            } else {
                setNode(address, 5, node(address, 5) | ((UInt32(r.destinationAddressOffset) << 16) & 0x1FFF_0000))
            }
            if r.blockSourceAddressOffset < 0 { setNode(address, 6, UInt32(-r.blockSourceAddressOffset) & 0xFFFF) }
            else { setNode(address, 6, UInt32(r.blockSourceAddressOffset) & 0xFFFF) }
            if r.blockDestinationAddressOffset < 0 {
                setNode(address, 6, node(address, 6) | ((UInt32(-r.blockDestinationAddressOffset) & 0xFFFF) << 16))
            } else {
                setNode(address, 6, node(address, 6) | ((UInt32(r.blockDestinationAddressOffset) << 16) & 0xFFFF_0000))
            }
            setNode(address, 7, 0)
        } else {
            setNode(address, 5, 0)
        }
        setNode(address, 8, configuration.nodeType)
        if configuration.nodeType & 2 == 2 { setNode(address, 8, node(address, 8) | (7 << 8)) }
        else { setNode(address, 8, node(address, 8) | (5 << 8)) }
        return .ok
    }

    @discardableResult
    public func getNodeConfiguration(at address: UInt32, configuration: inout DMANodeConfiguration?) -> HALStatus {
        guard var result = configuration, address != 0 else { return .error }
        result.nodeType = node(address, 8) & 0xFF
        result.configuration.sourceIncrement = node(address, 0) & 8
        result.configuration.destinationIncrement = node(address, 0) & 0x80000
        result.configuration.sourceDataWidth = node(address, 0) & 3
        result.configuration.destinationDataWidth = node(address, 0) & 0x30000
        result.configuration.sourceBurstLength = ((node(address, 0) & 0x3F0) >> 4) &+ 1
        result.configuration.destinationBurstLength = ((node(address, 0) & 0x03F0_0000) >> 20) &+ 1
        result.configuration.transferAllocatedPort = node(address, 0) & 0x4000_4000
        result.dataHandling.exchange = node(address, 0) & 0x1C00_2000
        result.dataHandling.alignment = node(address, 0) & 0x1800
        if node(address, 1) & 0x200 != 0 {
            result.configuration.request = 0x200
            result.configuration.direction = 0x200
        } else {
            result.configuration.request = node(address, 1) & 0x7F
            if node(address, 1) & 0x400 != 0 { result.configuration.direction = 0x400 }
            else { result.configuration.direction = 0 }
        }
        result.configuration.blockHardwareRequest = node(address, 1) & 0x800
        result.trigger.mode = node(address, 1) & 0xC000
        result.trigger.polarity = node(address, 1) & 0x0300_0000
        result.trigger.selection = (node(address, 1) & 0x003F_0000) >> 16
        result.configuration.transferEventMode = node(address, 1) & 0xC000_0000
        result.dataSize = node(address, 2) & 0xFFFF
        if result.nodeType & 2 == 2 {
            result.repeatBlock.repeatCount = ((node(address, 2) & 0x07FF_0000) >> 16) &+ 1
        } else { result.repeatBlock.repeatCount = 1 }
        result.sourceAddress = node(address, 3)
        result.destinationAddress = node(address, 4)
        if result.nodeType & 2 == 2 {
            result.repeatBlock.sourceAddressOffset = Int32(node(address, 5) & 0x1FFF)
            result.repeatBlock.destinationAddressOffset = Int32((node(address, 5) & 0x1FFF_0000) >> 16)
            if node(address, 2) & 0x1000_0000 != 0 { result.repeatBlock.sourceAddressOffset *= -1 }
            if node(address, 2) & 0x2000_0000 != 0 { result.repeatBlock.destinationAddressOffset *= -1 }
            result.repeatBlock.blockSourceAddressOffset = Int32(node(address, 6) & 0xFFFF)
            result.repeatBlock.blockDestinationAddressOffset = Int32((node(address, 6) & 0xFFFF_0000) >> 16)
            if node(address, 2) & 0x4000_0000 != 0 { result.repeatBlock.blockSourceAddressOffset *= -1 }
            if node(address, 2) & 0x8000_0000 != 0 { result.repeatBlock.blockDestinationAddressOffset *= -1 }
        } else {
            result.repeatBlock.sourceAddressOffset = 0
            result.repeatBlock.destinationAddressOffset = 0
            result.repeatBlock.blockSourceAddressOffset = 0
            result.repeatBlock.blockDestinationAddressOffset = 0
        }
        // Init.Priority and Init.Mode are intentionally not assigned by C.
        configuration = result
        return .ok
    }

    private func validateNode(_ c: DMANodeConfiguration) {
        precondition(c.nodeType == 0x21 || c.nodeType == 0x22 || c.nodeType == 0x41 || c.nodeType == 0x42)
        precondition(c.configuration.sourceIncrement == 0 || c.configuration.sourceIncrement == 8)
        precondition(c.configuration.destinationIncrement == 0 || c.configuration.destinationIncrement == 0x80000)
        precondition(c.configuration.sourceDataWidth <= 3)
        precondition(c.configuration.destinationDataWidth & ~UInt32(0x30000) == 0)
        precondition(c.dataHandling.alignment == 0 || c.dataHandling.alignment == 0x800 || c.dataHandling.alignment == 0x1000)
        precondition(c.configuration.request == 0x200 || c.configuration.request <= 109)
        precondition(c.configuration.direction == 0 || c.configuration.direction == 0x400 || c.configuration.direction == 0x200)
        precondition(c.configuration.transferEventMode & ~UInt32(0xC000_0000) == 0)
        precondition(c.configuration.blockHardwareRequest == 0 || c.configuration.blockHardwareRequest == 0x800)
        precondition(c.configuration.mode == 0 || c.configuration.mode == 0x1000)
        if c.nodeType & 0x60 != 0 {
            precondition(c.configuration.sourceBurstLength >= 1 && c.configuration.sourceBurstLength <= 64)
            precondition(c.configuration.destinationBurstLength >= 1 && c.configuration.destinationBurstLength <= 64)
            precondition(c.dataHandling.exchange & ~UInt32(0x1C00_2000) == 0)
            precondition(c.configuration.transferAllocatedPort & ~UInt32(0x4000_4000) == 0)
        }
        precondition(c.trigger.polarity == 0 || c.trigger.polarity == 0x0100_0000 || c.trigger.polarity == 0x0200_0000)
        if c.trigger.polarity != 0 {
            precondition(c.trigger.mode == 0 || c.trigger.mode == 0x4000 || c.trigger.mode == 0x8000 || c.trigger.mode == 0xC000)
            precondition(c.trigger.selection <= 55)
        }
        if c.nodeType & 2 == 2 {
            precondition(c.repeatBlock.repeatCount > 0 && c.repeatBlock.repeatCount <= 0x7FF)
            precondition(c.repeatBlock.sourceAddressOffset > -8192 && c.repeatBlock.sourceAddressOffset < 8192)
            precondition(c.repeatBlock.destinationAddressOffset > -8192 && c.repeatBlock.destinationAddressOffset < 8192)
            precondition(c.repeatBlock.blockSourceAddressOffset > -65536 && c.repeatBlock.blockSourceAddressOffset < 65536)
            precondition(c.repeatBlock.blockDestinationAddressOffset > -65536 && c.repeatBlock.blockDestinationAddressOffset < 65536)
        }
    }
}
