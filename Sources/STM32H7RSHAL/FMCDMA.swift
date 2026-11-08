// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SRAM/SDRAM DMA operations from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum FMCDMACallbackKind: UInt32, CaseIterable, Sendable {
  case complete = 0
  case protectedComplete, error
}
public protocol FMCDMAIO {
  func read(_ word: DMAHandleWord) -> UInt32
  func readDestinationDataWidth() -> UInt32
  func readMemory32(at address: UInt32) -> UInt32
  func writeMemory32(at address: UInt32, value: UInt32)
  func writeCallback(_ id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: FMCDMACallbackKind) -> DMACallback
  func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32)
    -> HALStatus
  func startLinkedListInterrupt() -> HALStatus
}

// Completion disables the actual event source, which can differ from the DMA
// currently attached to the handle reached through the source's live Parent.
public protocol FMCDMAEventSourceIO {
  func disable()
}
extension DMA: FMCDMAEventSourceIO {}
public typealias FMCDMACallbackContext = LPTIMDMACallbackContext

public struct FMCDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: FMCDMAIO {
  public let dma: DMA<Registers, Handle, Callbacks, Memory>
  public let getDestinationDataWidth: () -> UInt32
  // Read Init.DestDataWidth through this closure. Live CTR1 is not equivalent
  // after linked-list execution changes the channel's register configuration.
  public init(
    dma: DMA<Registers, Handle, Callbacks, Memory>, getDestinationDataWidth: @escaping () -> UInt32
  ) {
    self.dma = dma
    self.getDestinationDataWidth = getDestinationDataWidth
  }
  public func read(_ word: DMAHandleWord) -> UInt32 { dma.handle.read(word) }
  public func readDestinationDataWidth() -> UInt32 { getDestinationDataWidth() }
  public func readMemory32(at address: UInt32) -> UInt32 { dma.memory.read32(at: address) }
  public func writeMemory32(at address: UInt32, value: UInt32) {
    dma.memory.write32(at: address, value: value)
  }
  public func writeCallback(_ id: DMACallbackID, value: DMACallback?) {
    dma.callbacks.write(id, value: value)
  }
  public func callback(_ kind: FMCDMACallbackKind) -> DMACallback { fmcDMAThunk(kind) }
  public func startInterrupt(
    sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    dma.startInterrupt(
      sourceAddress: sourceAddress, destinationAddress: destinationAddress,
      sourceDataSize: sourceDataSize)
  }
  public func startLinkedListInterrupt() -> HALStatus { dma.startLinkedListInterrupt() }
}
public struct FMCNoDMA: FMCDMAIO {
  public init() {}
  public func read(_ word: DMAHandleWord) -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func readDestinationDataWidth() -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func readMemory32(at address: UInt32) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func writeMemory32(at address: UInt32, value: UInt32) {
    preconditionFailure("DMA handle is absent")
  }
  public func writeCallback(_ id: DMACallbackID, value: DMACallback?) {
    preconditionFailure("DMA handle is absent")
  }
  public func callback(_ kind: FMCDMACallbackKind) -> DMACallback { fmcDMAThunk(kind) }
  public func startInterrupt(
    sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus { preconditionFailure("DMA handle is absent") }
  public func startLinkedListInterrupt() -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
}
private func fmcDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: FMCDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: FMCDMACallbackContext.self).pointee
  descriptor.dispatch(
    descriptor.readParent(descriptor.dmaContext), descriptor.dmaContext, kind.rawValue)
}
private func fmcDMAComplete(_ context: UnsafeMutableRawPointer?) {
  fmcDMADispatch(context, .complete)
}
private func fmcDMAProtectedComplete(_ context: UnsafeMutableRawPointer?) {
  fmcDMADispatch(context, .protectedComplete)
}
private func fmcDMAError(_ context: UnsafeMutableRawPointer?) { fmcDMADispatch(context, .error) }
func fmcDMAThunk(_ kind: FMCDMACallbackKind) -> DMACallback {
  switch kind {
  case .complete: return fmcDMAComplete
  case .protectedComplete: return fmcDMAProtectedComplete
  case .error: return fmcDMAError
  }
}
