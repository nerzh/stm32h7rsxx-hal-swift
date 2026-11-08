// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct SPIDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: SPIDMAIO {
  public let channels: UARTDMALinks<Registers, Handle, Callbacks, Memory>
  public let getSourceDataWidth: (UARTDMADirection) -> UInt32
  public let getDestinationDataWidth: (UARTDMADirection) -> UInt32
  // Read the attached channels' current Init fields, not their live CTR1 registers.
  public init(
    transmit: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    receive: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    getSourceDataWidth: @escaping (UARTDMADirection) -> UInt32,
    getDestinationDataWidth: @escaping (UARTDMADirection) -> UInt32
  ) {
    channels = UARTDMALinks(transmit: transmit, receive: receive)
    self.getSourceDataWidth = getSourceDataWidth
    self.getDestinationDataWidth = getDestinationDataWidth
  }
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
  public func readSourceDataWidth(_ direction: UARTDMADirection) -> UInt32 {
    getSourceDataWidth(direction)
  }
  public func readDestinationDataWidth(_ direction: UARTDMADirection) -> UInt32 {
    getDestinationDataWidth(direction)
  }
  public func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback? {
    channels.readCallback(direction, id: id)
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
  public func callback(_ kind: SPIDMACallbackKind) -> DMACallback { spiDMAThunk(kind) }
}
public struct SPINoDMA: SPIDMAIO {
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
  public func readSourceDataWidth(_ direction: UARTDMADirection) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readDestinationDataWidth(_ direction: UARTDMADirection) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback? {
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
  public func callback(_ kind: SPIDMACallbackKind) -> DMACallback { spiDMAThunk(kind) }
}
private func spiDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: SPIDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: SPIDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, descriptor.dmaContext, kind.rawValue)
}
private func spiDMA_transmitComplete(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .transmitComplete)
}
private func spiDMA_receiveComplete(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .receiveComplete)
}
private func spiDMA_transmitReceiveComplete(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .transmitReceiveComplete)
}
private func spiDMA_transmitHalfComplete(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .transmitHalfComplete)
}
private func spiDMA_receiveHalfComplete(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .receiveHalfComplete)
}
private func spiDMA_transmitReceiveHalfComplete(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .transmitReceiveHalfComplete)
}
private func spiDMA_error(_ context: UnsafeMutableRawPointer?) { spiDMADispatch(context, .error) }
private func spiDMA_abortOnError(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .abortOnError)
}
private func spiDMA_transmitAbort(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .transmitAbort)
}
private func spiDMA_receiveAbort(_ context: UnsafeMutableRawPointer?) {
  spiDMADispatch(context, .receiveAbort)
}
func spiDMAThunk(_ kind: SPIDMACallbackKind) -> DMACallback {
  switch kind {
  case .transmitComplete: return spiDMA_transmitComplete
  case .receiveComplete: return spiDMA_receiveComplete
  case .transmitReceiveComplete: return spiDMA_transmitReceiveComplete
  case .transmitHalfComplete: return spiDMA_transmitHalfComplete
  case .receiveHalfComplete: return spiDMA_receiveHalfComplete
  case .transmitReceiveHalfComplete: return spiDMA_transmitReceiveHalfComplete
  case .error: return spiDMA_error
  case .abortOnError: return spiDMA_abortOnError
  case .transmitAbort: return spiDMA_transmitAbort
  case .receiveAbort: return spiDMA_receiveAbort
  }
}
extension DMA: SPIDMAEventSourceIO { public func readErrorCode() -> UInt32 { getError().rawValue } }
