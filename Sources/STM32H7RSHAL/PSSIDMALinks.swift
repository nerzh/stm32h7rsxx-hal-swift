// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PSSI operations and definitions from stm32h7rsxx_hal_pssi.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// The callback context must point to a caller-owned PSSIDMACallbackContext.
// Read the original DMA Init width through the supplied closure; live CTR1 is
// not a substitute for Init when linked-list execution changes register state.
public struct PSSIDMALinks<Registers: DMARegisterIO, Handle: DMAHandleIO,
                          Callbacks: DMACallbackIO, Memory: DMAMemoryIO>: PSSIDMAIO {
    public let transmit: DMA<Registers, Handle, Callbacks, Memory>?
    public let receive: DMA<Registers, Handle, Callbacks, Memory>?
    public let getDataWidth: (PSSIDMADirection) -> UInt32
    public init(transmit: DMA<Registers, Handle, Callbacks, Memory>? = nil,
                receive: DMA<Registers, Handle, Callbacks, Memory>? = nil,
                getDataWidth: @escaping (PSSIDMADirection) -> UInt32) {
        self.transmit = transmit; self.receive = receive; self.getDataWidth = getDataWidth
    }
    private func channel(_ direction: PSSIDMADirection) -> DMA<Registers, Handle, Callbacks, Memory> {
        direction == .transmit ? transmit! : receive!
    }
    public func isPresent(_ direction: PSSIDMADirection) -> Bool { direction == .transmit ? transmit != nil : receive != nil }
    public func readDataWidth(_ direction: PSSIDMADirection) -> UInt32 { getDataWidth(direction) }
    public func read(_ direction: PSSIDMADirection, word: DMAHandleWord) -> UInt32 { channel(direction).handle.read(word) }
    public func readMemory32(_ direction: PSSIDMADirection, at address: UInt32) -> UInt32 { channel(direction).memory.read32(at: address) }
    public func writeMemory32(_ direction: PSSIDMADirection, at address: UInt32, value: UInt32) { channel(direction).memory.write32(at: address, value: value) }
    public func writeCallback(_ direction: PSSIDMADirection, id: DMACallbackID, value: DMACallback?) { channel(direction).callbacks.write(id, value: value) }
    public func invokeCallback(_ direction: PSSIDMADirection, id: DMACallbackID) {
        let dma = channel(direction); dma.callbacks.read(id)!(dma.callbacks.context)
    }
    public func callback(_ kind: PSSIDMACallbackKind) -> DMACallback { pssiDMAThunk(kind) }
    public func startInterrupt(_ direction: PSSIDMADirection, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        channel(direction).startInterrupt(sourceAddress: sourceAddress, destinationAddress: destinationAddress, sourceDataSize: sourceDataSize)
    }
    public func startLinkedListInterrupt(_ direction: PSSIDMADirection) -> HALStatus { channel(direction).startLinkedListInterrupt() }
    public func abortInterrupt(_ direction: PSSIDMADirection) -> HALStatus { channel(direction).abortInterrupt() }
}
public struct PSSINoDMA: PSSIDMAIO {
    public init() {}
    public func isPresent(_ direction: PSSIDMADirection) -> Bool { false }
    public func readDataWidth(_ direction: PSSIDMADirection) -> UInt32 { preconditionFailure("DMA handle is absent") }
    public func read(_ direction: PSSIDMADirection, word: DMAHandleWord) -> UInt32 { preconditionFailure("DMA handle is absent") }
    public func readMemory32(_ direction: PSSIDMADirection, at address: UInt32) -> UInt32 { preconditionFailure("DMA handle is absent") }
    public func writeMemory32(_ direction: PSSIDMADirection, at address: UInt32, value: UInt32) { preconditionFailure("DMA handle is absent") }
    public func writeCallback(_ direction: PSSIDMADirection, id: DMACallbackID, value: DMACallback?) { preconditionFailure("DMA handle is absent") }
    public func invokeCallback(_ direction: PSSIDMADirection, id: DMACallbackID) { preconditionFailure("DMA handle is absent") }
    public func callback(_ kind: PSSIDMACallbackKind) -> DMACallback { pssiDMAThunk(kind) }
    public func startInterrupt(_ direction: PSSIDMADirection, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus { preconditionFailure("DMA handle is absent") }
    public func startLinkedListInterrupt(_ direction: PSSIDMADirection) -> HALStatus { preconditionFailure("DMA handle is absent") }
    public func abortInterrupt(_ direction: PSSIDMADirection) -> HALStatus { preconditionFailure("DMA handle is absent") }
}
private func pssiDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: PSSIDMACallbackKind) {
    let descriptor = context!.assumingMemoryBound(to: PSSIDMACallbackContext.self).pointee
    descriptor.dispatch(descriptor.readParent(descriptor.dmaContext), kind.rawValue)
}
private func pssiDMATransmitComplete(_ context: UnsafeMutableRawPointer?) { pssiDMADispatch(context, .transmitComplete) }
private func pssiDMAReceiveComplete(_ context: UnsafeMutableRawPointer?) { pssiDMADispatch(context, .receiveComplete) }
private func pssiDMAError(_ context: UnsafeMutableRawPointer?) { pssiDMADispatch(context, .error) }
private func pssiDMAAbort(_ context: UnsafeMutableRawPointer?) { pssiDMADispatch(context, .abort) }
func pssiDMAThunk(_ kind: PSSIDMACallbackKind) -> DMACallback {
    switch kind {
    case .transmitComplete: return pssiDMATransmitComplete
    case .receiveComplete: return pssiDMAReceiveComplete
    case .error: return pssiDMAError
    case .abort: return pssiDMAAbort
    }
}
