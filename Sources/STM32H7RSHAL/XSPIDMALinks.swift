// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct XSPIDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: XSPIDMAIO {
  public let channels: UARTDMALinks<Registers, Handle, Callbacks, Memory>
  // Read the attached handles' live Init fields, not their hardware registers.
  public let getConfiguration: (UARTDMADirection, XSPIDMAConfigurationWord) -> UInt32
  public init(
    transmit: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    receive: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    getConfiguration: @escaping (UARTDMADirection, XSPIDMAConfigurationWord) -> UInt32
  ) {
    channels = UARTDMALinks(transmit: transmit, receive: receive)
    self.getConfiguration = getConfiguration
  }
  public func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    channels.read(direction, word: word)
  }
  public func readConfiguration(_ direction: UARTDMADirection, word: XSPIDMAConfigurationWord)
    -> UInt32
  { getConfiguration(direction, word) }
  public func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    channels.readMemory32(direction, at: address)
  }
  public func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    channels.writeMemory32(direction, at: address, value: value)
  }
  public func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    channels.writeCallback(direction, id: id, value: value)
  }
  public func callback(_ kind: XSPIDMACallbackKind) -> DMACallback { xspiDMAThunk(kind) }
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
}
public struct XSPINoDMA: XSPIDMAIO {
  public init() {}
  public func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readConfiguration(_ direction: UARTDMADirection, word: XSPIDMAConfigurationWord)
    -> UInt32
  { preconditionFailure("DMA handle is absent") }
  public func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    preconditionFailure("DMA handle is absent")
  }
  public func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    preconditionFailure("DMA handle is absent")
  }
  public func callback(_ kind: XSPIDMACallbackKind) -> DMACallback { xspiDMAThunk(kind) }
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
}
private func xspiDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: XSPIDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: XSPIDMACallbackContext.self).pointee
  descriptor.dispatch(
    descriptor.readParent(descriptor.dmaContext), descriptor.dmaContext, kind.rawValue)
}
private func xspiDMA_complete(_ context: UnsafeMutableRawPointer?) {
  xspiDMADispatch(context, .complete)
}
private func xspiDMA_halfComplete(_ context: UnsafeMutableRawPointer?) {
  xspiDMADispatch(context, .halfComplete)
}
private func xspiDMA_error(_ context: UnsafeMutableRawPointer?) { xspiDMADispatch(context, .error) }
private func xspiDMA_abortComplete(_ context: UnsafeMutableRawPointer?) {
  xspiDMADispatch(context, .abortComplete)
}
func xspiDMAThunk(_ kind: XSPIDMACallbackKind) -> DMACallback {
  switch kind {
  case .complete: return xspiDMA_complete
  case .halfComplete: return xspiDMA_halfComplete
  case .error: return xspiDMA_error
  case .abortComplete: return xspiDMA_abortComplete
  }
}
