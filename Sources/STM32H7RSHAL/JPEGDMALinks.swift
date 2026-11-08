// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// JPEG operations and definitions from stm32h7rsxx_hal_jpeg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// Each DMA callback context points to caller-owned JPEGDMACallbackContext.
public struct JPEGDMALinks<Registers: DMARegisterIO, Handle: DMAHandleIO,
                          Callbacks: DMACallbackIO, Memory: DMAMemoryIO>: JPEGDMAIO {
    public let input: DMA<Registers, Handle, Callbacks, Memory>?
    public let output: DMA<Registers, Handle, Callbacks, Memory>?
    public init(input: DMA<Registers, Handle, Callbacks, Memory>? = nil, output: DMA<Registers, Handle, Callbacks, Memory>? = nil) {
        self.input = input; self.output = output
    }
    private func channel(_ stream: JPEGStream) -> DMA<Registers, Handle, Callbacks, Memory> { stream == .input ? input! : output! }
    public func read(_ stream: JPEGStream, word: DMAHandleWord) -> UInt32 { channel(stream).handle.read(word) }
    public func readMemory32(_ stream: JPEGStream, at address: UInt32) -> UInt32 { channel(stream).memory.read32(at: address) }
    public func writeMemory32(_ stream: JPEGStream, at address: UInt32, value: UInt32) { channel(stream).memory.write32(at: address, value: value) }
    public func writeCallback(_ stream: JPEGStream, id: DMACallbackID, value: DMACallback?) { channel(stream).callbacks.write(id, value: value) }
    public func callback(_ kind: JPEGDMACallbackKind) -> DMACallback { jpegDMAThunk(kind) }
    public func startInterrupt(_ stream: JPEGStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus { channel(stream).startInterrupt(sourceAddress: sourceAddress, destinationAddress: destinationAddress, sourceDataSize: sourceDataSize) }
    public func startLinkedListInterrupt(_ stream: JPEGStream) -> HALStatus { channel(stream).startLinkedListInterrupt() }
    public func abort(_ stream: JPEGStream, getTick: () -> UInt32) -> HALStatus { channel(stream).abort(getTick: getTick) }
    public func abortInterrupt(_ stream: JPEGStream) -> HALStatus { channel(stream).abortInterrupt() }
    public func getCounter(_ stream: JPEGStream) -> UInt32 { channel(stream).getCounter() }
    public func getFIFOLevel(_ stream: JPEGStream) -> UInt32 { channel(stream).getFIFOLevel() }
}
public struct JPEGNoDMA: JPEGDMAIO {
    public init() {}
    public func read(_ stream: JPEGStream, word: DMAHandleWord) -> UInt32 { preconditionFailure("DMA handle is absent") }
    public func readMemory32(_ stream: JPEGStream, at address: UInt32) -> UInt32 { preconditionFailure("DMA handle is absent") }
    public func writeMemory32(_ stream: JPEGStream, at address: UInt32, value: UInt32) { preconditionFailure("DMA handle is absent") }
    public func writeCallback(_ stream: JPEGStream, id: DMACallbackID, value: DMACallback?) { preconditionFailure("DMA handle is absent") }
    public func callback(_ kind: JPEGDMACallbackKind) -> DMACallback { jpegDMAThunk(kind) }
    public func startInterrupt(_ stream: JPEGStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus { preconditionFailure("DMA handle is absent") }
    public func startLinkedListInterrupt(_ stream: JPEGStream) -> HALStatus { preconditionFailure("DMA handle is absent") }
    public func abort(_ stream: JPEGStream, getTick: () -> UInt32) -> HALStatus { preconditionFailure("DMA handle is absent") }
    public func abortInterrupt(_ stream: JPEGStream) -> HALStatus { preconditionFailure("DMA handle is absent") }
    public func getCounter(_ stream: JPEGStream) -> UInt32 { preconditionFailure("DMA handle is absent") }
    public func getFIFOLevel(_ stream: JPEGStream) -> UInt32 { preconditionFailure("DMA handle is absent") }
}
private func jpegDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: JPEGDMACallbackKind) {
    let descriptor = context!.assumingMemoryBound(to: JPEGDMACallbackContext.self).pointee
    let parent = descriptor.readParent(descriptor.dmaContext)
    descriptor.dispatch(parent, descriptor.dmaContext, kind.rawValue)
}
private func jpegDMAInputComplete(_ context: UnsafeMutableRawPointer?) { jpegDMADispatch(context, .inputComplete) }
private func jpegDMAOutputComplete(_ context: UnsafeMutableRawPointer?) { jpegDMADispatch(context, .outputComplete) }
private func jpegDMAError(_ context: UnsafeMutableRawPointer?) { jpegDMADispatch(context, .error) }
private func jpegDMAOutputAbort(_ context: UnsafeMutableRawPointer?) { jpegDMADispatch(context, .outputAbort) }
func jpegDMAThunk(_ kind: JPEGDMACallbackKind) -> DMACallback {
    switch kind {
    case .inputComplete: return jpegDMAInputComplete
    case .outputComplete: return jpegDMAOutputComplete
    case .error: return jpegDMAError
    case .outputAbort: return jpegDMAOutputAbort
    }
}
