// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPDIFRX operations and definitions from stm32h7rsxx_hal_spdifrx.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// Each DMA callback context points to caller-owned SPDIFRXDMACallbackContext.
public struct SPDIFRXDMALinks<Registers: DMARegisterIO, Handle: DMAHandleIO,
                             Callbacks: DMACallbackIO, Memory: DMAMemoryIO>: SPDIFRXDMAIO {
    public let data: DMA<Registers, Handle, Callbacks, Memory>?
    public let control: DMA<Registers, Handle, Callbacks, Memory>?
    public init(data: DMA<Registers, Handle, Callbacks, Memory>? = nil, control: DMA<Registers, Handle, Callbacks, Memory>? = nil) {
        self.data = data; self.control = control
    }
    private func channel(_ stream: SPDIFRXStream) -> DMA<Registers, Handle, Callbacks, Memory> { stream == .data ? data! : control! }
    public func isPresent(_ stream: SPDIFRXStream) -> Bool { stream == .data ? data != nil : control != nil }
    public func read(_ stream: SPDIFRXStream, word: DMAHandleWord) -> UInt32 { channel(stream).handle.read(word) }
    public func readMemory32(_ stream: SPDIFRXStream, at address: UInt32) -> UInt32 { channel(stream).memory.read32(at: address) }
    public func writeMemory32(_ stream: SPDIFRXStream, at address: UInt32, value: UInt32) { channel(stream).memory.write32(at: address, value: value) }
    public func writeCallback(_ stream: SPDIFRXStream, id: DMACallbackID, value: DMACallback?) { channel(stream).callbacks.write(id, value: value) }
    public func callback(_ kind: SPDIFRXDMACallbackKind) -> DMACallback { spdifrxDMAThunk(kind) }
    public func startInterrupt(_ stream: SPDIFRXStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        channel(stream).startInterrupt(sourceAddress: sourceAddress, destinationAddress: destinationAddress, sourceDataSize: sourceDataSize)
    }
    public func startLinkedListInterrupt(_ stream: SPDIFRXStream) -> HALStatus { channel(stream).startLinkedListInterrupt() }
    public func disable(_ stream: SPDIFRXStream) { channel(stream).disable() }
}
public struct SPDIFRXNoDMA: SPDIFRXDMAIO {
    public init() {}
    public func isPresent(_ stream: SPDIFRXStream) -> Bool { false }
    public func read(_ stream: SPDIFRXStream, word: DMAHandleWord) -> UInt32 { preconditionFailure("DMA handle is absent") }
    public func readMemory32(_ stream: SPDIFRXStream, at address: UInt32) -> UInt32 { preconditionFailure("DMA handle is absent") }
    public func writeMemory32(_ stream: SPDIFRXStream, at address: UInt32, value: UInt32) { preconditionFailure("DMA handle is absent") }
    public func writeCallback(_ stream: SPDIFRXStream, id: DMACallbackID, value: DMACallback?) { preconditionFailure("DMA handle is absent") }
    public func callback(_ kind: SPDIFRXDMACallbackKind) -> DMACallback { spdifrxDMAThunk(kind) }
    public func startInterrupt(_ stream: SPDIFRXStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus { preconditionFailure("DMA handle is absent") }
    public func startLinkedListInterrupt(_ stream: SPDIFRXStream) -> HALStatus { preconditionFailure("DMA handle is absent") }
    public func disable(_ stream: SPDIFRXStream) { preconditionFailure("DMA handle is absent") }
}
private func spdifrxDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: SPDIFRXDMACallbackKind) {
    let descriptor = context!.assumingMemoryBound(to: SPDIFRXDMACallbackContext.self).pointee
    let parent = descriptor.readParent(descriptor.dmaContext)
    let mode = kind == .receiveComplete ? descriptor.readMode(descriptor.dmaContext) : 0
    descriptor.dispatch(parent, kind.rawValue, mode)
}
private func spdifrxDMAReceiveComplete(_ context: UnsafeMutableRawPointer?) { spdifrxDMADispatch(context, .receiveComplete) }
private func spdifrxDMAReceiveHalf(_ context: UnsafeMutableRawPointer?) { spdifrxDMADispatch(context, .receiveHalf) }
private func spdifrxDMAControlComplete(_ context: UnsafeMutableRawPointer?) { spdifrxDMADispatch(context, .controlComplete) }
private func spdifrxDMAControlHalf(_ context: UnsafeMutableRawPointer?) { spdifrxDMADispatch(context, .controlHalf) }
private func spdifrxDMAError(_ context: UnsafeMutableRawPointer?) { spdifrxDMADispatch(context, .error) }
func spdifrxDMAThunk(_ kind: SPDIFRXDMACallbackKind) -> DMACallback {
    switch kind {
    case .receiveComplete: return spdifrxDMAReceiveComplete
    case .receiveHalf: return spdifrxDMAReceiveHalf
    case .controlComplete: return spdifrxDMAControlComplete
    case .controlHalf: return spdifrxDMAControlHalf
    case .error: return spdifrxDMAError
    }
}
