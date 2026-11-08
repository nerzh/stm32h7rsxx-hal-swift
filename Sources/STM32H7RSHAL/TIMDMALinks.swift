// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct TIMDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: TIMDMAIO {
  public let update: DMA<Registers, Handle, Callbacks, Memory>?
  public let captureCompare1: DMA<Registers, Handle, Callbacks, Memory>?
  public let captureCompare2: DMA<Registers, Handle, Callbacks, Memory>?
  public let captureCompare3: DMA<Registers, Handle, Callbacks, Memory>?
  public let captureCompare4: DMA<Registers, Handle, Callbacks, Memory>?
  public let commutation: DMA<Registers, Handle, Callbacks, Memory>?
  public let trigger: DMA<Registers, Handle, Callbacks, Memory>?
  public let getSourceDataWidth: (TIMDMAChannel) -> UInt32
  public init(
    update: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    captureCompare1: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    captureCompare2: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    captureCompare3: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    captureCompare4: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    commutation: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    trigger: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    getSourceDataWidth: @escaping (TIMDMAChannel) -> UInt32
  ) {
    self.update = update
    self.captureCompare1 = captureCompare1
    self.captureCompare2 = captureCompare2
    self.captureCompare3 = captureCompare3
    self.captureCompare4 = captureCompare4
    self.commutation = commutation
    self.trigger = trigger
    self.getSourceDataWidth = getSourceDataWidth
  }
  private func channel(_ channel: TIMDMAChannel) -> DMA<Registers, Handle, Callbacks, Memory>? {
    switch channel {
    case .update: return update
    case .captureCompare1: return captureCompare1
    case .captureCompare2: return captureCompare2
    case .captureCompare3: return captureCompare3
    case .captureCompare4: return captureCompare4
    case .commutation: return commutation
    case .trigger: return trigger
    }
  }
  public func isPresent(_ channel: TIMDMAChannel) -> Bool { self.channel(channel) != nil }
  public func matches(_ channel: TIMDMAChannel, context: UnsafeMutableRawPointer?) -> Bool {
    guard let dma = self.channel(channel) else { return false }
    return dma.callbacks.context!.assumingMemoryBound(to: TIMDMACallbackContext.self).pointee
      .dmaContext == context
  }
  public func read(_ channel: TIMDMAChannel, word: DMAHandleWord) -> UInt32 {
    self.channel(channel)!.handle.read(word)
  }
  public func readSourceDataWidth(_ channel: TIMDMAChannel) -> UInt32 {
    getSourceDataWidth(channel)
  }
  public func readMemory32(_ channel: TIMDMAChannel, at address: UInt32) -> UInt32 {
    self.channel(channel)!.memory.read32(at: address)
  }
  public func writeMemory32(_ channel: TIMDMAChannel, at address: UInt32, value: UInt32) {
    self.channel(channel)!.memory.write32(at: address, value: value)
  }
  public func writeCallback(_ channel: TIMDMAChannel, id: DMACallbackID, value: DMACallback?) {
    self.channel(channel)!.callbacks.write(id, value: value)
  }
  public func callback(_ kind: TIMDMACallbackKind) -> DMACallback { timDMAThunk(kind) }
  public func startInterrupt(
    _ channel: TIMDMAChannel, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus {
    self.channel(channel)!.startInterrupt(
      sourceAddress: sourceAddress, destinationAddress: destinationAddress,
      sourceDataSize: sourceDataSize)
  }
  public func startLinkedListInterrupt(_ channel: TIMDMAChannel) -> HALStatus {
    self.channel(channel)!.startLinkedListInterrupt()
  }
  public func abortInterrupt(_ channel: TIMDMAChannel) -> HALStatus {
    self.channel(channel)!.abortInterrupt()
  }
}
public struct TIMNoDMA: TIMDMAIO {
  public init() {}
  public func isPresent(_ channel: TIMDMAChannel) -> Bool { false }
  public func matches(_ channel: TIMDMAChannel, context: UnsafeMutableRawPointer?) -> Bool { false }
  public func read(_ channel: TIMDMAChannel, word: DMAHandleWord) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readSourceDataWidth(_ channel: TIMDMAChannel) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readMemory32(_ channel: TIMDMAChannel, at address: UInt32) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func writeMemory32(_ channel: TIMDMAChannel, at address: UInt32, value: UInt32) {
    preconditionFailure("DMA handle is absent")
  }
  public func writeCallback(_ channel: TIMDMAChannel, id: DMACallbackID, value: DMACallback?) {
    preconditionFailure("DMA handle is absent")
  }
  public func callback(_ kind: TIMDMACallbackKind) -> DMACallback { timDMAThunk(kind) }
  public func startInterrupt(
    _ channel: TIMDMAChannel, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus { preconditionFailure("DMA handle is absent") }
  public func startLinkedListInterrupt(_ channel: TIMDMAChannel) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func abortInterrupt(_ channel: TIMDMAChannel) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
}
private func timDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: TIMDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: TIMDMACallbackContext.self).pointee
  descriptor.dispatch(
    descriptor.readParent(descriptor.dmaContext), descriptor.dmaContext, kind.rawValue)
}
private func timDMA_error(_ context: UnsafeMutableRawPointer?) { timDMADispatch(context, .error) }
private func timDMA_delayPulseComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .delayPulseComplete)
}
private func timDMA_delayPulseHalfComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .delayPulseHalfComplete)
}
private func timDMA_captureComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .captureComplete)
}
private func timDMA_captureHalfComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .captureHalfComplete)
}
private func timDMA_periodElapsedComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .periodElapsedComplete)
}
private func timDMA_periodElapsedHalfComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .periodElapsedHalfComplete)
}
private func timDMA_triggerComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .triggerComplete)
}
private func timDMA_triggerHalfComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .triggerHalfComplete)
}
private func timDMA_commutationComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .commutationComplete)
}
private func timDMA_commutationHalfComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .commutationHalfComplete)
}
private func timDMA_delayPulseNComplete(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .delayPulseNComplete)
}
private func timDMA_errorCCxN(_ context: UnsafeMutableRawPointer?) {
  timDMADispatch(context, .errorCCxN)
}
func timDMAThunk(_ kind: TIMDMACallbackKind) -> DMACallback {
  switch kind {
  case .error: return timDMA_error
  case .delayPulseComplete: return timDMA_delayPulseComplete
  case .delayPulseHalfComplete: return timDMA_delayPulseHalfComplete
  case .captureComplete: return timDMA_captureComplete
  case .captureHalfComplete: return timDMA_captureHalfComplete
  case .periodElapsedComplete: return timDMA_periodElapsedComplete
  case .periodElapsedHalfComplete: return timDMA_periodElapsedHalfComplete
  case .triggerComplete: return timDMA_triggerComplete
  case .triggerHalfComplete: return timDMA_triggerHalfComplete
  case .commutationComplete: return timDMA_commutationComplete
  case .commutationHalfComplete: return timDMA_commutationHalfComplete
  case .delayPulseNComplete: return timDMA_delayPulseNComplete
  case .errorCCxN: return timDMA_errorCCxN
  }
}
