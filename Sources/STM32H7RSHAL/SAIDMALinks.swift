// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct SAIDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: SAIDMAIO {
  public let channels: UARTDMALinks<Registers, Handle, Callbacks, Memory>
  public init(
    transmit: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    receive: DMA<Registers, Handle, Callbacks, Memory>? = nil
  ) { channels = UARTDMALinks(transmit: transmit, receive: receive) }
  public func isPresent(_ direction: UARTDMADirection) -> Bool { channels.isPresent(direction) }
  public func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    channels.read(direction, word: word)
  }
  public func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    channels.readMemory32(direction, at: address)
  }
  public func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    channels.writeMemory32(direction, at: address, value: value)
  }
  public func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    channels.writeCallback(direction, id: id, value: value)
  }
  public func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus {
    channels.startInterrupt(
      direction, sourceAddress: sourceAddress, destinationAddress: destinationAddress,
      sourceDataSize: sourceDataSize)
  }
  public func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    channels.startLinkedListInterrupt(direction)
  }
  public func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    channels.abort(direction, getTick: getTick)
  }
  public func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    channels.abortInterrupt(direction)
  }
  public func callback(_ kind: SAIDMACallbackKind) -> DMACallback { saiDMAThunk(kind) }
}
public struct SAINoDMA: SAIDMAIO {
  public init() {}
  public func isPresent(_ direction: UARTDMADirection) -> Bool { false }
  public func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    preconditionFailure("DMA handle is absent")
  }
  public func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    preconditionFailure("DMA handle is absent")
  }
  public func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus { preconditionFailure("DMA handle is absent") }
  public func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func callback(_ kind: SAIDMACallbackKind) -> DMACallback { saiDMAThunk(kind) }
}
private func saiDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: SAIDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: SAIDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, descriptor.dmaContext, kind.rawValue)
}
private func saiDMA_transmitComplete(_ context: UnsafeMutableRawPointer?) {
  saiDMADispatch(context, .transmitComplete)
}
private func saiDMA_transmitHalfComplete(_ context: UnsafeMutableRawPointer?) {
  saiDMADispatch(context, .transmitHalfComplete)
}
private func saiDMA_receiveComplete(_ context: UnsafeMutableRawPointer?) {
  saiDMADispatch(context, .receiveComplete)
}
private func saiDMA_receiveHalfComplete(_ context: UnsafeMutableRawPointer?) {
  saiDMADispatch(context, .receiveHalfComplete)
}
private func saiDMA_error(_ context: UnsafeMutableRawPointer?) { saiDMADispatch(context, .error) }
private func saiDMA_abort(_ context: UnsafeMutableRawPointer?) { saiDMADispatch(context, .abort) }
func saiDMAThunk(_ kind: SAIDMACallbackKind) -> DMACallback {
  switch kind {
  case .transmitComplete: return saiDMA_transmitComplete
  case .transmitHalfComplete: return saiDMA_transmitHalfComplete
  case .receiveComplete: return saiDMA_receiveComplete
  case .receiveHalfComplete: return saiDMA_receiveHalfComplete
  case .error: return saiDMA_error
  case .abort: return saiDMA_abort
  }
}
