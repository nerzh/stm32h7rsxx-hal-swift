// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// HASH DMA linkage for the STM32H7RS HAL port. Transfer algorithms are provided
// by DMA; HASH callback bodies are provided by HASH.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct HASHDMALink<Registers: DMARegisterIO, Handle: DMAHandleIO,
                          Callbacks: DMACallbackIO, Memory: DMAMemoryIO>: HASHDMAIO {
  public let input: DMA<Registers, Handle, Callbacks, Memory>?
  public init(input: DMA<Registers, Handle, Callbacks, Memory>? = nil) { self.input = input }
  public func read(_ word: DMAHandleWord) -> UInt32 { input!.handle.read(word) }
  public func getCounter() -> UInt32 { input!.getCounter() }
  public func getFIFOLevel() -> UInt32 { input!.getFIFOLevel() }
  public func readMemory32(at address: UInt32) -> UInt32 { input!.memory.read32(at: address) }
  public func writeMemory32(at address: UInt32, value: UInt32) { input!.memory.write32(at: address, value: value) }
  public func writeCallback(_ id: DMACallbackID, value: DMACallback?) { input!.callbacks.write(id, value: value) }
  public func callback(_ kind: HASHDMACallbackKind) -> DMACallback { hashDMAThunk(kind) }
  public func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    input!.startInterrupt(sourceAddress: sourceAddress, destinationAddress: destinationAddress,
                          sourceDataSize: sourceDataSize)
  }
  public func startLinkedListInterrupt() -> HALStatus { input!.startLinkedListInterrupt() }
  public func abort(getTick: () -> UInt32) -> HALStatus { input!.abort(getTick: getTick) }
}
public struct HASHNoDMA: HASHDMAIO {
  public init() {}
  public func read(_ word: DMAHandleWord) -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func getCounter() -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func getFIFOLevel() -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func readMemory32(at address: UInt32) -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func writeMemory32(at address: UInt32, value: UInt32) { preconditionFailure("DMA handle is absent") }
  public func writeCallback(_ id: DMACallbackID, value: DMACallback?) { preconditionFailure("DMA handle is absent") }
  public func callback(_ kind: HASHDMACallbackKind) -> DMACallback { hashDMAThunk(kind) }
  public func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func startLinkedListInterrupt() -> HALStatus { preconditionFailure("DMA handle is absent") }
  public func abort(getTick: () -> UInt32) -> HALStatus { preconditionFailure("DMA handle is absent") }
}
// Context points to a caller-owned immutable descriptor. Parent is read afresh
// from the original DMA handle on every callback, as in the C HAL.
private func hashDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: HASHDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: HASHDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, kind.rawValue)
}
private func hashDMAInputComplete(_ context: UnsafeMutableRawPointer?) { hashDMADispatch(context, .inputComplete) }
private func hashDMAError(_ context: UnsafeMutableRawPointer?) { hashDMADispatch(context, .error) }
func hashDMAThunk(_ kind: HASHDMACallbackKind) -> DMACallback {
  switch kind { case .inputComplete: return hashDMAInputComplete; case .error: return hashDMAError }
}
