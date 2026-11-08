// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP operations and definitions from stm32h7rsxx_hal_cryp.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// Each DMA callback context points to caller-owned CRYPDMACallbackContext.
public struct CRYPDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO,
  Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: CRYPDMAIO {
  public let input: DMA<Registers, Handle, Callbacks, Memory>?
  public let output: DMA<Registers, Handle, Callbacks, Memory>?
  public init(
    input: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    output: DMA<Registers, Handle, Callbacks, Memory>? = nil
  ) {
    self.input = input
    self.output = output
  }
  private func channel(_ stream: CRYPStream) -> DMA<Registers, Handle, Callbacks, Memory> {
    stream == .input ? input! : output!
  }
  public func read(_ stream: CRYPStream, word: DMAHandleWord) -> UInt32 {
    channel(stream).handle.read(word)
  }
  public func readMemory32(_ stream: CRYPStream, at address: UInt32) -> UInt32 {
    channel(stream).memory.read32(at: address)
  }
  public func writeMemory32(_ stream: CRYPStream, at address: UInt32, value: UInt32) {
    channel(stream).memory.write32(at: address, value: value)
  }
  public func writeCallback(_ stream: CRYPStream, id: DMACallbackID, value: DMACallback?) {
    channel(stream).callbacks.write(id, value: value)
  }
  public func callback(_ kind: CRYPDMACallbackKind) -> DMACallback { crypDMAThunk(kind) }
  public func startInterrupt(
    _ stream: CRYPStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    channel(stream).startInterrupt(
      sourceAddress: sourceAddress, destinationAddress: destinationAddress,
      sourceDataSize: sourceDataSize)
  }
  public func startLinkedListInterrupt(_ stream: CRYPStream) -> HALStatus {
    channel(stream).startLinkedListInterrupt()
  }
  public func abort(_ stream: CRYPStream, getTick: () -> UInt32) -> HALStatus {
    channel(stream).abort(getTick: getTick)
  }
  public func getCounter(_ stream: CRYPStream) -> UInt32 { channel(stream).getCounter() }
  public func getFIFOLevel(_ stream: CRYPStream) -> UInt32 { channel(stream).getFIFOLevel() }
}
public struct CRYPNoDMA: CRYPDMAIO {
  public init() {}
  public func read(_ stream: CRYPStream, word: DMAHandleWord) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func readMemory32(_ stream: CRYPStream, at address: UInt32) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func writeMemory32(_ stream: CRYPStream, at address: UInt32, value: UInt32) {
    preconditionFailure("DMA handle is absent")
  }
  public func writeCallback(_ stream: CRYPStream, id: DMACallbackID, value: DMACallback?) {
    preconditionFailure("DMA handle is absent")
  }
  public func callback(_ kind: CRYPDMACallbackKind) -> DMACallback { crypDMAThunk(kind) }
  public func startInterrupt(
    _ stream: CRYPStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus { preconditionFailure("DMA handle is absent") }
  public func startLinkedListInterrupt(_ stream: CRYPStream) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func abort(_ stream: CRYPStream, getTick: () -> UInt32) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func getCounter(_ stream: CRYPStream) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
  public func getFIFOLevel(_ stream: CRYPStream) -> UInt32 {
    preconditionFailure("DMA handle is absent")
  }
}
private func crypDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: CRYPDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: CRYPDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, kind.rawValue)
}
private func crypDMAInputComplete(_ context: UnsafeMutableRawPointer?) {
  crypDMADispatch(context, .inputComplete)
}
private func crypDMAOutputComplete(_ context: UnsafeMutableRawPointer?) {
  crypDMADispatch(context, .outputComplete)
}
private func crypDMAError(_ context: UnsafeMutableRawPointer?) { crypDMADispatch(context, .error) }
func crypDMAThunk(_ kind: CRYPDMACallbackKind) -> DMACallback {
  switch kind {
  case .inputComplete: return crypDMAInputComplete
  case .outputComplete: return crypDMAOutputComplete
  case .error: return crypDMAError
  }
}

public struct CRYPDMACallbackContext {
  public let dmaContext: UnsafeMutableRawPointer?
  public let readParent: @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
  public let dispatch: @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
  public init(
    dmaContext: UnsafeMutableRawPointer?,
    readParent: @escaping @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?,
    dispatch: @escaping @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
  ) {
    self.dmaContext = dmaContext
    self.readParent = readParent
    self.dispatch = dispatch
  }
}
