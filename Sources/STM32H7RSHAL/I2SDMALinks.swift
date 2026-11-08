// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct I2SDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: I2SDMAIO {
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
  public func callback(_ kind: I2SDMACallbackKind) -> DMACallback { i2sDMAThunk(kind) }
}
public struct I2SNoDMA: I2SDMAIO {
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
  public func callback(_ kind: I2SDMACallbackKind) -> DMACallback { i2sDMAThunk(kind) }
}
private func i2sDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: I2SDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: I2SDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, descriptor.dmaContext, kind.rawValue)
}
private func i2sDMA_transmitComplete(_ context: UnsafeMutableRawPointer?) {
  i2sDMADispatch(context, .transmitComplete)
}
private func i2sDMA_transmitHalfComplete(_ context: UnsafeMutableRawPointer?) {
  i2sDMADispatch(context, .transmitHalfComplete)
}
private func i2sDMA_receiveComplete(_ context: UnsafeMutableRawPointer?) {
  i2sDMADispatch(context, .receiveComplete)
}
private func i2sDMA_receiveHalfComplete(_ context: UnsafeMutableRawPointer?) {
  i2sDMADispatch(context, .receiveHalfComplete)
}
private func i2sDMA_transmitReceiveComplete(_ context: UnsafeMutableRawPointer?) {
  i2sDMADispatch(context, .transmitReceiveComplete)
}
private func i2sDMA_transmitReceiveHalfComplete(_ context: UnsafeMutableRawPointer?) {
  i2sDMADispatch(context, .transmitReceiveHalfComplete)
}
private func i2sDMA_error(_ context: UnsafeMutableRawPointer?) { i2sDMADispatch(context, .error) }
func i2sDMAThunk(_ kind: I2SDMACallbackKind) -> DMACallback {
  switch kind {
  case .transmitComplete: return i2sDMA_transmitComplete
  case .transmitHalfComplete: return i2sDMA_transmitHalfComplete
  case .receiveComplete: return i2sDMA_receiveComplete
  case .receiveHalfComplete: return i2sDMA_receiveHalfComplete
  case .transmitReceiveComplete: return i2sDMA_transmitReceiveComplete
  case .transmitReceiveHalfComplete: return i2sDMA_transmitReceiveHalfComplete
  case .error: return i2sDMA_error
  }
}

// Supply the DMA's current Init configuration at callback dispatch time.
// I2S tests Init.Mode, whereas DMA.handle.mode describes linked-list operation.
extension DMAConfiguration: I2SDMAEventSourceIO {
  public func readConfigurationMode() -> UInt32 { mode }
}
