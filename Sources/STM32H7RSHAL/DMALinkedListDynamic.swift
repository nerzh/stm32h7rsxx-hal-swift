// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Dynamic node conversion from stm32h7rsxx_hal_dma_ex.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// Scratch values only: this type is not an image placed in DMA memory.
private struct DMAListNodeImage {
    private var values: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32) =
        (0, 0, 0, 0, 0, 0, 0, 0, 0)
    subscript(index: UInt32) -> UInt32 {
        get {
            switch index {
            case 0: return values.0
            case 1: return values.1
            case 2: return values.2
            case 3: return values.3
            case 4: return values.4
            case 5: return values.5
            case 6: return values.6
            case 7: return values.7
            case 8: return values.8
            default: preconditionFailure("Invalid DMA scratch node word")
            }
        }
        set {
            switch index {
            case 0: values.0 = newValue
            case 1: values.1 = newValue
            case 2: values.2 = newValue
            case 3: values.3 = newValue
            case 4: values.4 = newValue
            case 5: values.5 = newValue
            case 6: values.6 = newValue
            case 7: values.7 = newValue
            case 8: values.8 = newValue
            default: preconditionFailure("Invalid DMA scratch node word")
            }
        }
    }
}

extension DMALinkedList {
    @discardableResult
    public func convertToDynamic(in queueAddress: UInt32) -> HALStatus {
        guard queueAddress != 0 else { return .error }
        if queue(queueAddress, .head) == 0 {
            setQueue(queueAddress, .errorCode, DMAQueueError.empty.rawValue)
            return .error
        }
        if queue(queueAddress, .type) == 1 { return .ok }
        setQueue(queueAddress, .state, 2)
        setQueue(queueAddress, .errorCode, 0)
        let offset = cllrInfo(queue(queueAddress, .head)).offset
        var info = DMAListNodeInfo()
        if queue(queueAddress, .firstCircularNode) != 0 {
            info.linkOffset = offset
            findNode(queueAddress, 0, &info)
        }
        var current = queue(queueAddress, .head)
        var context = DMAListNodeImage()
        fillNode(queue(queueAddress, .head), &context)
        var count: UInt32 = 1
        while count < queue(queueAddress, .nodeCount) {
            current = (current & ~UInt32(0xFFFC)) | (context[offset] & 0xFFFC)
            if queue(queueAddress, .firstCircularNode) != 0 &&
                queue(queueAddress, .firstCircularNode) != info.currentAddress &&
                queue(queueAddress, .firstCircularNode) == current {
                fillNode(queue(queueAddress, .firstCircularNode), &context)
            } else {
                convertNodeToDynamic(&context, current, offset &+ 1)
            }
            count &+= 1
        }
        if queue(queueAddress, .firstCircularNode) != 0 &&
            queue(queueAddress, .firstCircularNode) != info.currentAddress {
            updateDynamicQueueLinks(queueAddress, lastIsCircular: 0)
        } else {
            updateDynamicQueueLinks(queueAddress, lastIsCircular: 1)
        }
        setQueue(queueAddress, .type, 1)
        setQueue(queueAddress, .errorCode, 0)
        setQueue(queueAddress, .state, 1)
        return .ok
    }

    @discardableResult
    public func convertToStatic(in queueAddress: UInt32) -> HALStatus {
        guard queueAddress != 0 else { return .error }
        if queue(queueAddress, .head) == 0 {
            setQueue(queueAddress, .errorCode, DMAQueueError.empty.rawValue)
            return .error
        }
        if queue(queueAddress, .type) == 0 { return .ok }
        var current = queue(queueAddress, .head)
        setQueue(queueAddress, .state, 2)
        setQueue(queueAddress, .errorCode, 0)
        let offset = cllrInfo(queue(queueAddress, .head)).offset
        updateStaticQueueLinks(queueAddress, operation: 0)
        var context = DMAListNodeImage()
        var count: UInt32 = 1
        while count < queue(queueAddress, .nodeCount) {
            fillNode(current, &context)
            current = (current & ~UInt32(0xFFFC)) | (context[offset] & 0xFFFC)
            convertNodeToStatic(context, current, offset &+ 1)
            count &+= 1
        }
        updateStaticQueueLinks(queueAddress, operation: 1)
        setQueue(queueAddress, .type, 0)
        setQueue(queueAddress, .errorCode, 0)
        setQueue(queueAddress, .state, 1)
        return .ok
    }

    private func fillNode(_ address: UInt32, _ context: inout DMAListNodeImage) {
        var index: UInt32 = 0
        while index < 8 {
            context[index] = node(address, index)
            index &+= 1
        }
        context[8] = node(address, 8)
    }

    private func updateLink(_ index: UInt32, count: UInt32) -> UInt32 {
        if index == count &- 1 { return 0x10000 }
        switch index {
        case 0: return 0x8000_0000
        case 1: return 0x4000_0000
        case 2: return 0x2000_0000
        case 3: return 0x1000_0000
        case 4: return 0x0800_0000
        case 5: return 0x0400_0000
        case 6: return 0x0200_0000
        case 7: return 0x0001_0000
        default: preconditionFailure("Invalid DMA link field")
        }
    }

    private func convertNodeToDynamic(_ context: inout DMAListNodeImage, _ address: UInt32, _ count: UInt32) {
        var currentIndex: UInt32 = 0
        var contextIndex: UInt32 = 0
        var linkIndex = count &- 1
        while contextIndex != count {
            if context[contextIndex] == node(address, currentIndex) && contextIndex != 3 &&
                contextIndex != 4 && contextIndex != count &- 1 {
                formatNode(address, index: currentIndex, count: count, dynamic: true)
                linkIndex &-= 1
                setNode(address, linkIndex, node(address, linkIndex) & ~updateLink(contextIndex, count: count))
            } else {
                context[contextIndex] = node(address, currentIndex)
                setNode(address, linkIndex, node(address, linkIndex) | updateLink(contextIndex, count: count))
                currentIndex &+= 1
            }
            contextIndex &+= 1
        }
        setNode(address, 8, (node(address, 8) & ~UInt32(0x700)) | ((currentIndex &- 1) << 8))
        var index = currentIndex
        while index < 8 {
            setNode(address, index, 0)
            index &+= 1
        }
    }

    private func convertNodeToStatic(_ context: DMAListNodeImage, _ address: UInt32, _ count: UInt32) {
        var index: UInt32 = 0
        let linkIndex = (context[8] & 0x700) >> 8
        let mask = context[linkIndex]
        while index != count {
            if mask & updateLink(index, count: count) == 0 {
                formatNode(address, index: index, count: count, dynamic: false)
                setNode(address, index, context[index])
            }
            index &+= 1
        }
        setNode(address, 8, (node(address, 8) & ~UInt32(0x700)) | ((count &- 1) << 8))
    }

    private func formatNode(_ address: UInt32, index: UInt32, count: UInt32, dynamic: Bool) {
        if dynamic {
            var current = index
            while current < count &- 1 {
                setNode(address, current, node(address, current &+ 1))
                current &+= 1
            }
        } else {
            var current = count &- 2
            while current > index {
                setNode(address, current, node(address, current &- 1))
                current &-= 1
            }
        }
    }

    private func updateDynamicQueueLinks(_ queueAddress: UInt32, lastIsCircular: UInt32) {
        var offset: UInt32 = 0
        var current = queue(queueAddress, .head)
        var index: UInt32 = 0
        while index < queue(queueAddress, .nodeCount) {
            if index == 0 { offset = (node(current, 8) & 0x700) >> 8 }
            else {
                let previous = current
                let previousOffset = offset
                current = (node(previous, previousOffset) & 0xFFFC) &+ (queue(queueAddress, .head) & 0xFFFF_0000)
                offset = (node(current, 8) & 0x700) >> 8
                let mask = (node(current, offset) & ~UInt32(0xFFFC)) | (node(previous, previousOffset) & 0xFFFC)
                setNode(previous, previousOffset, mask)
            }
            index &+= 1
        }
        if queue(queueAddress, .firstCircularNode) != 0 {
            if lastIsCircular == 0 {
                let mask = cllrInfo(current).mask
                // Upstream links to Head here, even for a partial circular queue.
                setNode(current, offset, (queue(queueAddress, .head) & 0xFFFC) | mask)
            } else {
                setNode(current, offset, node(current, offset) & ~UInt32(0x10000))
            }
        } else { setNode(current, offset, 0) }
    }

    private func updateStaticQueueLinks(_ queueAddress: UInt32, operation: UInt32) {
        var current = queue(queueAddress, .head)
        var offset = (node(queue(queueAddress, .head), 8) & 0x700) >> 8
        let defaults = cllrInfo(queue(queueAddress, .head))
        var index: UInt32 = 0
        while index < queue(queueAddress, .nodeCount) {
            let mask: UInt32
            if operation == 0 { mask = node(current, offset) }
            else { mask = (node(current, offset) & 0xFFFC) | defaults.mask }
            if index == queue(queueAddress, .nodeCount) &- 1 && queue(queueAddress, .firstCircularNode) == 0 {
                setNode(current, defaults.offset, 0)
            } else { setNode(current, defaults.offset, mask) }
            current = (current & 0xFFFF_0000) | (mask & 0xFFFC)
            // C reads the following NodeInfo even on the final iteration.
            // A terminating zero link therefore reads the queue's base + 32.
            offset = (node(current, 8) & 0x700) >> 8
            index &+= 1
        }
    }
}
