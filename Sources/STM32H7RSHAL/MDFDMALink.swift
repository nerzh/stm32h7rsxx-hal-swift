// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct MDFDMALink<Registers: DMARegisterIO, Handle: DMAHandleIO,
                          Callbacks: DMACallbackIO, Memory: DMAMemoryIO>: MDFDMAIO {
  public let input: DMA<Registers, Handle, Callbacks, Memory>?
  public init(input: DMA<Registers, Handle, Callbacks, Memory>? = nil) { self.input = input }
  public func read(_ word: DMAHandleWord) -> UInt32 { input!.handle.read(word) }
  public func readMemory32(at address: UInt32) -> UInt32 { input!.memory.read32(at: address) }
  public func writeMemory32(at address: UInt32, value: UInt32) { input!.memory.write32(at: address, value: value) }
  public func writeCallback(_ id: DMACallbackID, value: DMACallback?) { input!.callbacks.write(id, value: value) }
  public func callback(_ kind: MDFDMACallbackKind) -> DMACallback { mdfDMAThunk(kind) }
  public func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    input!.startInterrupt(sourceAddress: sourceAddress, destinationAddress: destinationAddress,
                          sourceDataSize: sourceDataSize)
  }
  public func startLinkedListInterrupt() -> HALStatus { input!.startLinkedListInterrupt() }
  public func abort(getTick: () -> UInt32) -> HALStatus { input!.abort(getTick: getTick) }
}
public struct MDFNoDMA: MDFDMAIO {
  public init() {}
  public func read(_ word: DMAHandleWord) -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func readMemory32(at address: UInt32) -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func writeMemory32(at address: UInt32, value: UInt32) { preconditionFailure("DMA handle is absent") }
  public func writeCallback(_ id: DMACallbackID, value: DMACallback?) { preconditionFailure("DMA handle is absent") }
  public func callback(_ kind: MDFDMACallbackKind) -> DMACallback { mdfDMAThunk(kind) }
  public func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func startLinkedListInterrupt() -> HALStatus { preconditionFailure("DMA handle is absent") }
  public func abort(getTick: () -> UInt32) -> HALStatus { preconditionFailure("DMA handle is absent") }
}
// Context points to caller-owned storage; read the current parent on each call.
private func mdfDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: MDFDMACallbackKind) {
    let descriptor = context!.assumingMemoryBound(to: MDFDMACallbackContext.self).pointee
    let parent = descriptor.readParent(descriptor.dmaContext)
    let mode = kind == .complete ? descriptor.readMode(descriptor.dmaContext) : 0
    descriptor.dispatch(parent, kind.rawValue, mode)
}
private func mdfDMAComplete(_ context: UnsafeMutableRawPointer?) { mdfDMADispatch(context, .complete) }
private func mdfDMAHalfComplete(_ context: UnsafeMutableRawPointer?) { mdfDMADispatch(context, .halfComplete) }
private func mdfDMAError(_ context: UnsafeMutableRawPointer?) { mdfDMADispatch(context, .error) }
func mdfDMAThunk(_ kind: MDFDMACallbackKind) -> DMACallback {
    switch kind { case .complete: return mdfDMAComplete; case .halfComplete: return mdfDMAHalfComplete; case .error: return mdfDMAError }
}
