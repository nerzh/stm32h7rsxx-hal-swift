// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum I3CDMAChannel: UInt32, CaseIterable {
  case control = 0
  case transmit, receive
}
public enum I3CDMACallbackKind: UInt32, CaseIterable {
  case controlTransmitComplete = 0
  case dataTransmitComplete, dataReceiveComplete, error, abort
}
public typealias I3CDMACallbackContext = UARTDMACallbackContext
public protocol I3CDMAIO {
  func isPresent(_ channel: I3CDMAChannel) -> Bool
  func readState(_ channel: I3CDMAChannel) -> UInt32
  func getCounter(_ channel: I3CDMAChannel) -> UInt32
  func getFIFOLevel(_ channel: I3CDMAChannel) -> UInt32
  func writeCallback(_ channel: I3CDMAChannel, id: DMACallbackID, value: DMACallback?)
  func invokeCallback(_ channel: I3CDMAChannel, id: DMACallbackID)
  func callback(_ kind: I3CDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ channel: I3CDMAChannel, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus
  func abort(_ channel: I3CDMAChannel, getTick: () -> UInt32) -> HALStatus
  func abortInterrupt(_ channel: I3CDMAChannel) -> HALStatus
}
public struct I3CDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: I3CDMAIO {
  public let control: DMA<Registers, Handle, Callbacks, Memory>?
  public let data: UARTDMALinks<Registers, Handle, Callbacks, Memory>
  public init(
    control: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    transmit: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    receive: DMA<Registers, Handle, Callbacks, Memory>? = nil
  ) {
    self.control = control
    self.data = UARTDMALinks(transmit: transmit, receive: receive)
  }
  private func channel(_ id: I3CDMAChannel) -> DMA<Registers, Handle, Callbacks, Memory>? {
    switch id {
    case .control: return control
    case .transmit: return data.transmit
    case .receive: return data.receive
    }
  }
  public func isPresent(_ id: I3CDMAChannel) -> Bool { channel(id) != nil }
  public func getCounter(_ id: I3CDMAChannel) -> UInt32 { channel(id)!.getCounter() }
  public func getFIFOLevel(_ id: I3CDMAChannel) -> UInt32 { channel(id)!.getFIFOLevel() }
  public func readState(_ id: I3CDMAChannel) -> UInt32 { channel(id)!.handle.read(.state) }
  public func writeCallback(_ id: I3CDMAChannel, id callbackID: DMACallbackID, value: DMACallback?)
  { channel(id)!.callbacks.write(callbackID, value: value) }
  public func invokeCallback(_ id: I3CDMAChannel, id callbackID: DMACallbackID) {
    let dma = channel(id)!
    dma.callbacks.read(callbackID)!(dma.callbacks.context)
  }
  public func callback(_ kind: I3CDMACallbackKind) -> DMACallback { i3cDMAThunk(kind) }
  public func startInterrupt(
    _ id: I3CDMAChannel, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    channel(id)!.startInterrupt(
      sourceAddress: sourceAddress, destinationAddress: destinationAddress,
      sourceDataSize: sourceDataSize)
  }
  public func abort(_ id: I3CDMAChannel, getTick: () -> UInt32) -> HALStatus {
    channel(id)!.abort(getTick: getTick)
  }
  public func abortInterrupt(_ id: I3CDMAChannel) -> HALStatus { channel(id)!.abortInterrupt() }
}
public struct I3CNoDMA: I3CDMAIO {
  public init() {}
  public func isPresent(_ channel: I3CDMAChannel) -> Bool { false }
  public func getCounter(_ channel: I3CDMAChannel) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func getFIFOLevel(_ channel: I3CDMAChannel) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readState(_ channel: I3CDMAChannel) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func writeCallback(_ channel: I3CDMAChannel, id: DMACallbackID, value: DMACallback?) {
    preconditionFailure("DMA handle is absent")
  }
  public func invokeCallback(_ channel: I3CDMAChannel, id: DMACallbackID) {
    preconditionFailure("DMA handle is absent")
  }
  public func callback(_ kind: I3CDMACallbackKind) -> DMACallback { i3cDMAThunk(kind) }
  public func startInterrupt(
    _ channel: I3CDMAChannel, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus { preconditionFailure("DMA handle is absent") }
  public func abort(_ channel: I3CDMAChannel, getTick: () -> UInt32) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func abortInterrupt(_ channel: I3CDMAChannel) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
}
private func i3cDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: I3CDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: I3CDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, descriptor.dmaContext, kind.rawValue)
}
private func i3cDMA_controlTransmitComplete(_ context: UnsafeMutableRawPointer?) {
  i3cDMADispatch(context, .controlTransmitComplete)
}
private func i3cDMA_dataTransmitComplete(_ context: UnsafeMutableRawPointer?) {
  i3cDMADispatch(context, .dataTransmitComplete)
}
private func i3cDMA_dataReceiveComplete(_ context: UnsafeMutableRawPointer?) {
  i3cDMADispatch(context, .dataReceiveComplete)
}
private func i3cDMA_error(_ context: UnsafeMutableRawPointer?) { i3cDMADispatch(context, .error) }
private func i3cDMA_abort(_ context: UnsafeMutableRawPointer?) { i3cDMADispatch(context, .abort) }
func i3cDMAThunk(_ kind: I3CDMACallbackKind) -> DMACallback {
  switch kind {
  case .controlTransmitComplete: return i3cDMA_controlTransmitComplete
  case .dataTransmitComplete: return i3cDMA_dataTransmitComplete
  case .dataReceiveComplete: return i3cDMA_dataReceiveComplete
  case .error: return i3cDMA_error
  case .abort: return i3cDMA_abort
  }
}
