// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public protocol LLDMARegisterIO: LLBusRegisterIO {
    var controller: DMAController { get }
    func read(_ register: DMARegister, channel: UInt32) -> UInt32
    func write(_ register: DMARegister, channel: UInt32, value: UInt32)
}

// A view over eight caller-owned, aligned words. The memory implementation must
// preserve volatile accesses, lifetime and DMA/cache visibility, as in the HAL.
public struct LL_DMA_LinkNodeTypeDef<Memory: DMAMemoryIO> {
    public let memory: Memory
    public let address: UInt32
    public init(memory: Memory, address: UInt32) {
        precondition(address & 3 == 0)
        self.memory = memory
        self.address = address
    }
    public var LinkRegisters: LLDMALinkRegisters<Memory> { .init(memory: memory, address: address) }
}

public struct LLDMALinkRegisters<Memory: DMAMemoryIO> {
    let memory: Memory
    let address: UInt32
    public subscript(_ index: Int) -> UInt32 {
        get {
            precondition(index >= 0 && index < 8)
            return memory.read32(at: address &+ UInt32(index) &* 4)
        }
        nonmutating set {
            precondition(index >= 0 && index < 8)
            memory.write32(at: address &+ UInt32(index) &* 4, value: newValue)
        }
    }
}

public struct LL_DMA_InitTypeDef: Equatable, Sendable {
    public var SrcAddress: UInt32
    public var DestAddress: UInt32
    public var Direction: UInt32
    public var BlkHWRequest: UInt32
    public var DataAlignment: UInt32
    public var SrcBurstLength: UInt32
    public var DestBurstLength: UInt32
    public var SrcDataWidth: UInt32
    public var DestDataWidth: UInt32
    public var SrcIncMode: UInt32
    public var DestIncMode: UInt32
    public var Priority: UInt32
    public var BlkDataLength: UInt32
    public var BlkRptCount: UInt32
    public var TriggerMode: UInt32
    public var TriggerPolarity: UInt32
    public var TriggerSelection: UInt32
    public var Request: UInt32
    public var TransferEventMode: UInt32
    public var DestWordExchange: UInt32
    public var DestHWordExchange: UInt32
    public var DestByteExchange: UInt32
    public var SrcByteExchange: UInt32
    public var SrcAllocatedPort: UInt32
    public var DestAllocatedPort: UInt32
    public var LinkAllocatedPort: UInt32
    public var LinkStepMode: UInt32
    public var SrcAddrUpdateMode: UInt32
    public var DestAddrUpdateMode: UInt32
    public var SrcAddrOffset: UInt32
    public var DestAddrOffset: UInt32
    public var BlkRptSrcAddrUpdateMode: UInt32
    public var BlkRptDestAddrUpdateMode: UInt32
    public var BlkRptSrcAddrOffset: UInt32
    public var BlkRptDestAddrOffset: UInt32
    public var LinkedListBaseAddr: UInt32
    public var LinkedListAddrOffset: UInt32
    public var Mode: UInt32
    public init(
        SrcAddress: UInt32 = 0, DestAddress: UInt32 = 0, Direction: UInt32 = 0, BlkHWRequest: UInt32 = 0,
        DataAlignment: UInt32 = 0, SrcBurstLength: UInt32 = 0, DestBurstLength: UInt32 = 0, SrcDataWidth: UInt32 = 0,
        DestDataWidth: UInt32 = 0, SrcIncMode: UInt32 = 0, DestIncMode: UInt32 = 0, Priority: UInt32 = 0,
        BlkDataLength: UInt32 = 0, BlkRptCount: UInt32 = 0, TriggerMode: UInt32 = 0, TriggerPolarity: UInt32 = 0,
        TriggerSelection: UInt32 = 0, Request: UInt32 = 0, TransferEventMode: UInt32 = 0, DestWordExchange: UInt32 = 0,
        DestHWordExchange: UInt32 = 0, DestByteExchange: UInt32 = 0, SrcByteExchange: UInt32 = 0,
        SrcAllocatedPort: UInt32 = 0, DestAllocatedPort: UInt32 = 0, LinkAllocatedPort: UInt32 = 0,
        LinkStepMode: UInt32 = 0, SrcAddrUpdateMode: UInt32 = 0, DestAddrUpdateMode: UInt32 = 0,
        SrcAddrOffset: UInt32 = 0, DestAddrOffset: UInt32 = 0, BlkRptSrcAddrUpdateMode: UInt32 = 0,
        BlkRptDestAddrUpdateMode: UInt32 = 0, BlkRptSrcAddrOffset: UInt32 = 0, BlkRptDestAddrOffset: UInt32 = 0,
        LinkedListBaseAddr: UInt32 = 0, LinkedListAddrOffset: UInt32 = 0, Mode: UInt32 = 0
    ) {
        self.SrcAddress = SrcAddress
        self.DestAddress = DestAddress
        self.Direction = Direction
        self.BlkHWRequest = BlkHWRequest
        self.DataAlignment = DataAlignment
        self.SrcBurstLength = SrcBurstLength
        self.DestBurstLength = DestBurstLength
        self.SrcDataWidth = SrcDataWidth
        self.DestDataWidth = DestDataWidth
        self.SrcIncMode = SrcIncMode
        self.DestIncMode = DestIncMode
        self.Priority = Priority
        self.BlkDataLength = BlkDataLength
        self.BlkRptCount = BlkRptCount
        self.TriggerMode = TriggerMode
        self.TriggerPolarity = TriggerPolarity
        self.TriggerSelection = TriggerSelection
        self.Request = Request
        self.TransferEventMode = TransferEventMode
        self.DestWordExchange = DestWordExchange
        self.DestHWordExchange = DestHWordExchange
        self.DestByteExchange = DestByteExchange
        self.SrcByteExchange = SrcByteExchange
        self.SrcAllocatedPort = SrcAllocatedPort
        self.DestAllocatedPort = DestAllocatedPort
        self.LinkAllocatedPort = LinkAllocatedPort
        self.LinkStepMode = LinkStepMode
        self.SrcAddrUpdateMode = SrcAddrUpdateMode
        self.DestAddrUpdateMode = DestAddrUpdateMode
        self.SrcAddrOffset = SrcAddrOffset
        self.DestAddrOffset = DestAddrOffset
        self.BlkRptSrcAddrUpdateMode = BlkRptSrcAddrUpdateMode
        self.BlkRptDestAddrUpdateMode = BlkRptDestAddrUpdateMode
        self.BlkRptSrcAddrOffset = BlkRptSrcAddrOffset
        self.BlkRptDestAddrOffset = BlkRptDestAddrOffset
        self.LinkedListBaseAddr = LinkedListBaseAddr
        self.LinkedListAddrOffset = LinkedListAddrOffset
        self.Mode = Mode
    }
}

public struct LL_DMA_InitLinkedListTypeDef: Equatable, Sendable {
    public var Priority: UInt32
    public var LinkStepMode: UInt32
    public var LinkAllocatedPort: UInt32
    public var TransferEventMode: UInt32
    public init(
        Priority: UInt32 = 0, LinkStepMode: UInt32 = 0, LinkAllocatedPort: UInt32 = 0, TransferEventMode: UInt32 = 0
    ) {
        self.Priority = Priority
        self.LinkStepMode = LinkStepMode
        self.LinkAllocatedPort = LinkAllocatedPort
        self.TransferEventMode = TransferEventMode
    }
}

public struct LL_DMA_InitNodeTypeDef: Equatable, Sendable {
    public var DestAllocatedPort: UInt32
    public var DestWordExchange: UInt32
    public var DestHWordExchange: UInt32
    public var DestByteExchange: UInt32
    public var DestBurstLength: UInt32
    public var DestIncMode: UInt32
    public var DestDataWidth: UInt32
    public var SrcAllocatedPort: UInt32
    public var SrcByteExchange: UInt32
    public var DataAlignment: UInt32
    public var SrcBurstLength: UInt32
    public var SrcIncMode: UInt32
    public var SrcDataWidth: UInt32
    public var TransferEventMode: UInt32
    public var TriggerPolarity: UInt32
    public var TriggerSelection: UInt32
    public var TriggerMode: UInt32
    public var BlkHWRequest: UInt32
    public var Direction: UInt32
    public var Request: UInt32
    public var Mode: UInt32
    public var BlkRptDestAddrUpdateMode: UInt32
    public var BlkRptSrcAddrUpdateMode: UInt32
    public var DestAddrUpdateMode: UInt32
    public var SrcAddrUpdateMode: UInt32
    public var BlkRptCount: UInt32
    public var BlkDataLength: UInt32
    public var SrcAddress: UInt32
    public var DestAddress: UInt32
    public var DestAddrOffset: UInt32
    public var SrcAddrOffset: UInt32
    public var BlkRptDestAddrOffset: UInt32
    public var BlkRptSrcAddrOffset: UInt32
    public var UpdateRegisters: UInt32
    public var NodeType: UInt32
    public init(
        DestAllocatedPort: UInt32 = 0, DestWordExchange: UInt32 = 0, DestHWordExchange: UInt32 = 0,
        DestByteExchange: UInt32 = 0, DestBurstLength: UInt32 = 0, DestIncMode: UInt32 = 0, DestDataWidth: UInt32 = 0,
        SrcAllocatedPort: UInt32 = 0, SrcByteExchange: UInt32 = 0, DataAlignment: UInt32 = 0,
        SrcBurstLength: UInt32 = 0, SrcIncMode: UInt32 = 0, SrcDataWidth: UInt32 = 0, TransferEventMode: UInt32 = 0,
        TriggerPolarity: UInt32 = 0, TriggerSelection: UInt32 = 0, TriggerMode: UInt32 = 0, BlkHWRequest: UInt32 = 0,
        Direction: UInt32 = 0, Request: UInt32 = 0, Mode: UInt32 = 0, BlkRptDestAddrUpdateMode: UInt32 = 0,
        BlkRptSrcAddrUpdateMode: UInt32 = 0, DestAddrUpdateMode: UInt32 = 0, SrcAddrUpdateMode: UInt32 = 0,
        BlkRptCount: UInt32 = 0, BlkDataLength: UInt32 = 0, SrcAddress: UInt32 = 0, DestAddress: UInt32 = 0,
        DestAddrOffset: UInt32 = 0, SrcAddrOffset: UInt32 = 0, BlkRptDestAddrOffset: UInt32 = 0,
        BlkRptSrcAddrOffset: UInt32 = 0, UpdateRegisters: UInt32 = 0, NodeType: UInt32 = 0
    ) {
        self.DestAllocatedPort = DestAllocatedPort
        self.DestWordExchange = DestWordExchange
        self.DestHWordExchange = DestHWordExchange
        self.DestByteExchange = DestByteExchange
        self.DestBurstLength = DestBurstLength
        self.DestIncMode = DestIncMode
        self.DestDataWidth = DestDataWidth
        self.SrcAllocatedPort = SrcAllocatedPort
        self.SrcByteExchange = SrcByteExchange
        self.DataAlignment = DataAlignment
        self.SrcBurstLength = SrcBurstLength
        self.SrcIncMode = SrcIncMode
        self.SrcDataWidth = SrcDataWidth
        self.TransferEventMode = TransferEventMode
        self.TriggerPolarity = TriggerPolarity
        self.TriggerSelection = TriggerSelection
        self.TriggerMode = TriggerMode
        self.BlkHWRequest = BlkHWRequest
        self.Direction = Direction
        self.Request = Request
        self.Mode = Mode
        self.BlkRptDestAddrUpdateMode = BlkRptDestAddrUpdateMode
        self.BlkRptSrcAddrUpdateMode = BlkRptSrcAddrUpdateMode
        self.DestAddrUpdateMode = DestAddrUpdateMode
        self.SrcAddrUpdateMode = SrcAddrUpdateMode
        self.BlkRptCount = BlkRptCount
        self.BlkDataLength = BlkDataLength
        self.SrcAddress = SrcAddress
        self.DestAddress = DestAddress
        self.DestAddrOffset = DestAddrOffset
        self.SrcAddrOffset = SrcAddrOffset
        self.BlkRptDestAddrOffset = BlkRptDestAddrOffset
        self.BlkRptSrcAddrOffset = BlkRptSrcAddrOffset
        self.UpdateRegisters = UpdateRegisters
        self.NodeType = NodeType
    }
}

public struct LL_DMA2D_InitTypeDef: Equatable, Sendable {
    public var Mode: UInt32
    public var ColorMode: UInt32
    public var OutputBlue: UInt32
    public var OutputGreen: UInt32
    public var OutputRed: UInt32
    public var OutputAlpha: UInt32
    public var OutputMemoryAddress: UInt32
    public var OutputSwapMode: UInt32
    public var LineOffsetMode: UInt32
    public var LineOffset: UInt32
    public var NbrOfLines: UInt32
    public var NbrOfPixelsPerLines: UInt32
    public var AlphaInversionMode: UInt32
    public var RBSwapMode: UInt32
    public init(
        Mode: UInt32 = 0, ColorMode: UInt32 = 0, OutputBlue: UInt32 = 0, OutputGreen: UInt32 = 0, OutputRed: UInt32 = 0,
        OutputAlpha: UInt32 = 0, OutputMemoryAddress: UInt32 = 0, OutputSwapMode: UInt32 = 0,
        LineOffsetMode: UInt32 = 0, LineOffset: UInt32 = 0, NbrOfLines: UInt32 = 0, NbrOfPixelsPerLines: UInt32 = 0,
        AlphaInversionMode: UInt32 = 0, RBSwapMode: UInt32 = 0
    ) {
        self.Mode = Mode
        self.ColorMode = ColorMode
        self.OutputBlue = OutputBlue
        self.OutputGreen = OutputGreen
        self.OutputRed = OutputRed
        self.OutputAlpha = OutputAlpha
        self.OutputMemoryAddress = OutputMemoryAddress
        self.OutputSwapMode = OutputSwapMode
        self.LineOffsetMode = LineOffsetMode
        self.LineOffset = LineOffset
        self.NbrOfLines = NbrOfLines
        self.NbrOfPixelsPerLines = NbrOfPixelsPerLines
        self.AlphaInversionMode = AlphaInversionMode
        self.RBSwapMode = RBSwapMode
    }
}

public struct LL_DMA2D_LayerCfgTypeDef: Equatable, Sendable {
    public var MemoryAddress: UInt32
    public var LineOffset: UInt32
    public var ColorMode: UInt32
    public var CLUTColorMode: UInt32
    public var CLUTSize: UInt32
    public var AlphaMode: UInt32
    public var Alpha: UInt32
    public var Blue: UInt32
    public var Green: UInt32
    public var Red: UInt32
    public var CLUTMemoryAddress: UInt32
    public var AlphaInversionMode: UInt32
    public var RBSwapMode: UInt32
    public var ChromaSubSampling: UInt32
    public init(
        MemoryAddress: UInt32 = 0, LineOffset: UInt32 = 0, ColorMode: UInt32 = 0, CLUTColorMode: UInt32 = 0,
        CLUTSize: UInt32 = 0, AlphaMode: UInt32 = 0, Alpha: UInt32 = 0, Blue: UInt32 = 0, Green: UInt32 = 0,
        Red: UInt32 = 0, CLUTMemoryAddress: UInt32 = 0, AlphaInversionMode: UInt32 = 0, RBSwapMode: UInt32 = 0,
        ChromaSubSampling: UInt32 = 0
    ) {
        self.MemoryAddress = MemoryAddress
        self.LineOffset = LineOffset
        self.ColorMode = ColorMode
        self.CLUTColorMode = CLUTColorMode
        self.CLUTSize = CLUTSize
        self.AlphaMode = AlphaMode
        self.Alpha = Alpha
        self.Blue = Blue
        self.Green = Green
        self.Red = Red
        self.CLUTMemoryAddress = CLUTMemoryAddress
        self.AlphaInversionMode = AlphaInversionMode
        self.RBSwapMode = RBSwapMode
        self.ChromaSubSampling = ChromaSubSampling
    }
}

public struct LL_DMA2D_ColorTypeDef: Equatable, Sendable {
    public var ColorMode: UInt32
    public var OutputBlue: UInt32
    public var OutputGreen: UInt32
    public var OutputRed: UInt32
    public var OutputAlpha: UInt32
    public init(
        ColorMode: UInt32 = 0, OutputBlue: UInt32 = 0, OutputGreen: UInt32 = 0, OutputRed: UInt32 = 0,
        OutputAlpha: UInt32 = 0
    ) {
        self.ColorMode = ColorMode
        self.OutputBlue = OutputBlue
        self.OutputGreen = OutputGreen
        self.OutputRed = OutputRed
        self.OutputAlpha = OutputAlpha
    }
}
