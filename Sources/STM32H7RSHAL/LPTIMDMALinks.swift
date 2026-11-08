// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LPTIM operations and definitions from stm32h7rsxx_hal_lptim.c/.h and
// stm32h7rsxx_ll_lptim.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct LPTIMDMALinks<Registers: DMARegisterIO, Handle: DMAHandleIO,
                             Callbacks: DMACallbackIO, Memory: DMAMemoryIO>: LPTIMDMAIO {
    public let channel1: DMA<Registers, Handle, Callbacks, Memory>?
    public let channel2: DMA<Registers, Handle, Callbacks, Memory>?
    public init(channel1: DMA<Registers, Handle, Callbacks, Memory>? = nil,
                channel2: DMA<Registers, Handle, Callbacks, Memory>? = nil) {
        self.channel1 = channel1; self.channel2 = channel2
    }
    private func channel(_ channel: LPTIMChannel) -> DMA<Registers, Handle, Callbacks, Memory> {
        channel == .channel1 ? channel1! : channel2!
    }
    public func read(_ channel: LPTIMChannel, word: DMAHandleWord) -> UInt32 { self.channel(channel).handle.read(word) }
    public func readMemory32(_ channel: LPTIMChannel, at address: UInt32) -> UInt32 { self.channel(channel).memory.read32(at: address) }
    public func writeMemory32(_ channel: LPTIMChannel, at address: UInt32, value: UInt32) { self.channel(channel).memory.write32(at: address, value: value) }
    public func writeCallback(_ channel: LPTIMChannel, id: DMACallbackID, value: DMACallback?) { self.channel(channel).callbacks.write(id, value: value) }
    public func callback(_ kind: LPTIMDMACallbackKind) -> DMACallback { lptimDMAThunk(kind) }
    public func matches(_ channel: LPTIMChannel, context: UnsafeMutableRawPointer?) -> Bool {
        guard let dma = channel == .channel1 ? channel1 : channel2 else { return false }
        return dma.callbacks.context!.assumingMemoryBound(to: LPTIMDMACallbackContext.self).pointee.dmaContext == context
    }
    public func startInterrupt(_ channel: LPTIMChannel, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        self.channel(channel).startInterrupt(sourceAddress: sourceAddress, destinationAddress: destinationAddress, sourceDataSize: sourceDataSize)
    }
    public func startLinkedListInterrupt(_ channel: LPTIMChannel) -> HALStatus { self.channel(channel).startLinkedListInterrupt() }
    public func abortInterrupt(_ channel: LPTIMChannel) -> HALStatus { self.channel(channel).abortInterrupt() }
}
private func lptimDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: LPTIMDMACallbackKind) {
    let descriptor = context!.assumingMemoryBound(to: LPTIMDMACallbackContext.self).pointee
    descriptor.dispatch(descriptor.readParent(descriptor.dmaContext), descriptor.dmaContext, kind.rawValue)
}
private func lptimDMAError(_ context: UnsafeMutableRawPointer?) { lptimDMADispatch(context, .error) }
private func lptimDMACaptureComplete(_ context: UnsafeMutableRawPointer?) { lptimDMADispatch(context, .captureComplete) }
private func lptimDMACaptureHalfComplete(_ context: UnsafeMutableRawPointer?) { lptimDMADispatch(context, .captureHalfComplete) }
private func lptimDMAUpdateComplete(_ context: UnsafeMutableRawPointer?) { lptimDMADispatch(context, .updateComplete) }
private func lptimDMAUpdateHalfComplete(_ context: UnsafeMutableRawPointer?) { lptimDMADispatch(context, .updateHalfComplete) }
func lptimDMAThunk(_ kind: LPTIMDMACallbackKind) -> DMACallback {
    switch kind {
    case .error: return lptimDMAError
    case .captureComplete: return lptimDMACaptureComplete
    case .captureHalfComplete: return lptimDMACaptureHalfComplete
    case .updateComplete: return lptimDMAUpdateComplete
    case .updateHalfComplete: return lptimDMAUpdateHalfComplete
    }
}
