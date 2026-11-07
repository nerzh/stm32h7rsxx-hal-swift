// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// UART DMA linkage for the STM32H7RS HAL port. The DMA algorithms are provided
// by DMA, and UART callback bodies are in UARTDMA.swift.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DMA: UARTDMAEventSourceIO {
  public func readMode() -> UInt32 { handle.read(.mode) }
}

// The linked DMA descriptors are immutable values backed by caller-owned
// volatile state. Their callback contexts must point to UARTDMACallbackContext
// descriptors that outlive every pending transfer and interrupt. Parent remains
// the DMA callback adapter's separate, mutable pointer slot.
public struct UARTDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: UARTDMAIO {
  public let transmit: DMA<Registers, Handle, Callbacks, Memory>?
  public let receive: DMA<Registers, Handle, Callbacks, Memory>?

  public init(
    transmit: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    receive: DMA<Registers, Handle, Callbacks, Memory>? = nil
  ) {
    self.transmit = transmit
    self.receive = receive
  }

  public func isPresent(_ direction: UARTDMADirection) -> Bool {
    switch direction { case .transmit: return transmit != nil; case .receive: return receive != nil }
  }
  public func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    channel(direction).handle.read(word)
  }
  public func getCounter(_ direction: UARTDMADirection) -> UInt32 { channel(direction).getCounter() }
  public func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    channel(direction).memory.read32(at: address)
  }
  public func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    channel(direction).memory.write32(at: address, value: value)
  }
  public func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback? {
    channel(direction).callbacks.read(id)
  }
  public func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    channel(direction).callbacks.write(id, value: value)
  }
  public func readParent(_ direction: UARTDMADirection) -> UnsafeMutableRawPointer? {
    channel(direction).callbacks.readParent()
  }
  public func writeParent(_ direction: UARTDMADirection, value: UnsafeMutableRawPointer?) {
    channel(direction).callbacks.writeParent(value)
  }
  public func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID) {
    let dma = channel(direction)
    dma.callbacks.read(id)!(dma.callbacks.context)
  }
  public func callback(_ kind: UARTDMACallbackKind) -> DMACallback { uartDMAThunk(kind) }
  public func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32,
    destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    channel(direction).startInterrupt(sourceAddress: sourceAddress,
      destinationAddress: destinationAddress, sourceDataSize: sourceDataSize)
  }
  public func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    channel(direction).startLinkedListInterrupt()
  }
  public func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    channel(direction).abort(getTick: getTick)
  }
  public func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    channel(direction).abortInterrupt()
  }
  public func suspend(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    channel(direction).suspend(getTick: getTick)
  }
  public func resume(_ direction: UARTDMADirection) -> HALStatus { channel(direction).resume() }

  private func channel(_ direction: UARTDMADirection) -> DMA<Registers, Handle, Callbacks, Memory> {
    switch direction { case .transmit: return transmit!; case .receive: return receive! }
  }
}

// Use when neither UART direction has an attached DMA handle. A DMA operation
// without an earlier presence check has the same invalid-handle precondition as C.
public struct UARTNoDMA: UARTDMAIO {
  public init() {}
  public func isPresent(_ direction: UARTDMADirection) -> Bool { false }
  public func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func getCounter(_ direction: UARTDMADirection) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    preconditionFailure("DMA handle is absent")
  }
  public func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback? {
    preconditionFailure("DMA handle is absent")
  }
  public func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    preconditionFailure("DMA handle is absent")
  }
  public func readParent(_ direction: UARTDMADirection) -> UnsafeMutableRawPointer? {
    preconditionFailure("DMA handle is absent")
  }
  public func writeParent(_ direction: UARTDMADirection, value: UnsafeMutableRawPointer?) {
    preconditionFailure("DMA handle is absent")
  }
  public func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID) {
    preconditionFailure("DMA handle is absent")
  }
  public func callback(_ kind: UARTDMACallbackKind) -> DMACallback { uartDMAThunk(kind) }
  public func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32,
    destinationAddress: UInt32, sourceDataSize: UInt32
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
  public func suspend(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func resume(_ direction: UARTDMADirection) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
}

private func uartDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: UARTDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: UARTDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, descriptor.dmaContext, kind.rawValue)
}
private func uartDMATransmitComplete(_ context: UnsafeMutableRawPointer?) {
  uartDMADispatch(context, .transmitComplete)
}
private func uartDMATransmitHalfComplete(_ context: UnsafeMutableRawPointer?) {
  uartDMADispatch(context, .transmitHalfComplete)
}
private func uartDMAReceiveComplete(_ context: UnsafeMutableRawPointer?) {
  uartDMADispatch(context, .receiveComplete)
}
private func uartDMAReceiveHalfComplete(_ context: UnsafeMutableRawPointer?) {
  uartDMADispatch(context, .receiveHalfComplete)
}
private func uartDMAError(_ context: UnsafeMutableRawPointer?) { uartDMADispatch(context, .error) }
private func uartDMAAbortOnError(_ context: UnsafeMutableRawPointer?) { uartDMADispatch(context, .abortOnError) }
private func uartDMATransmitAbort(_ context: UnsafeMutableRawPointer?) { uartDMADispatch(context, .transmitAbort) }
private func uartDMAReceiveAbort(_ context: UnsafeMutableRawPointer?) { uartDMADispatch(context, .receiveAbort) }
private func uartDMATransmitOnlyAbort(_ context: UnsafeMutableRawPointer?) {
  uartDMADispatch(context, .transmitOnlyAbort)
}
private func uartDMAReceiveOnlyAbort(_ context: UnsafeMutableRawPointer?) {
  uartDMADispatch(context, .receiveOnlyAbort)
}

func uartDMAThunk(_ kind: UARTDMACallbackKind) -> DMACallback {
  switch kind {
  case .transmitComplete: return uartDMATransmitComplete
  case .transmitHalfComplete: return uartDMATransmitHalfComplete
  case .receiveComplete: return uartDMAReceiveComplete
  case .receiveHalfComplete: return uartDMAReceiveHalfComplete
  case .error: return uartDMAError
  case .abortOnError: return uartDMAAbortOnError
  case .transmitAbort: return uartDMATransmitAbort
  case .receiveAbort: return uartDMAReceiveAbort
  case .transmitOnlyAbort: return uartDMATransmitOnlyAbort
  case .receiveOnlyAbort: return uartDMAReceiveOnlyAbort
  }
}
