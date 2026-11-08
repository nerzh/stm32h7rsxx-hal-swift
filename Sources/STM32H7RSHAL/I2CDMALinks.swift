// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct I2CDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: I2CDMAIO {
  public let channels: UARTDMALinks<Registers, Handle, Callbacks, Memory>
  public init(
    transmit: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    receive: DMA<Registers, Handle, Callbacks, Memory>? = nil
  ) {
    channels = UARTDMALinks(transmit: transmit, receive: receive)
  }
  public func isPresent(_ direction: UARTDMADirection) -> Bool { channels.isPresent(direction) }
  public func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID) {
    channels.invokeCallback(direction, id: id)
  }
  public func callback(_ kind: I2CDMACallbackKind) -> DMACallback { i2cDMAThunk(kind) }
  public func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    channels.read(direction, word: word)
  }
  public func getCounter(_ direction: UARTDMADirection) -> UInt32 { channels.getCounter(direction) }
  public func getFIFOLevel(_ direction: UARTDMADirection) -> UInt32 {
    (direction == .transmit ? channels.transmit! : channels.receive!).getFIFOLevel()
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
  public func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    channels.abortInterrupt(direction)
  }
}
public struct I2CNoDMA: I2CDMAIO {
  public init() {}
  public func isPresent(_ direction: UARTDMADirection) -> Bool { false }
  public func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID) {
    preconditionFailure("DMA handle is absent")
  }
  public func callback(_ kind: I2CDMACallbackKind) -> DMACallback { i2cDMAThunk(kind) }
  public func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func getCounter(_ direction: UARTDMADirection) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func getFIFOLevel(_ direction: UARTDMADirection) -> UInt32 {
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
  public func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
}
private func i2cDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: I2CDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: I2CDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, descriptor.dmaContext, kind.rawValue)
}
private func i2cDMAMasterTransmitComplete(_ context: UnsafeMutableRawPointer?) {
  i2cDMADispatch(context, .masterTransmitComplete)
}
private func i2cDMAMasterReceiveComplete(_ context: UnsafeMutableRawPointer?) {
  i2cDMADispatch(context, .masterReceiveComplete)
}
private func i2cDMASlaveTransmitComplete(_ context: UnsafeMutableRawPointer?) {
  i2cDMADispatch(context, .slaveTransmitComplete)
}
private func i2cDMASlaveReceiveComplete(_ context: UnsafeMutableRawPointer?) {
  i2cDMADispatch(context, .slaveReceiveComplete)
}
private func i2cDMAError(_ context: UnsafeMutableRawPointer?) { i2cDMADispatch(context, .error) }
private func i2cDMAAbort(_ context: UnsafeMutableRawPointer?) { i2cDMADispatch(context, .abort) }
func i2cDMAThunk(_ kind: I2CDMACallbackKind) -> DMACallback {
  switch kind {
  case .masterTransmitComplete: return i2cDMAMasterTransmitComplete
  case .masterReceiveComplete: return i2cDMAMasterReceiveComplete
  case .slaveTransmitComplete: return i2cDMASlaveTransmitComplete
  case .slaveReceiveComplete: return i2cDMASlaveReceiveComplete
  case .error: return i2cDMAError
  case .abort: return i2cDMAAbort
  }
}
