// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CORDIC DMA linkage for the STM32H7RS HAL port. DMA transfer algorithms are
// provided by DMA; CORDIC callback bodies are provided by CORDIC.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// Each attached DMA's callback context points to a caller-owned
// CORDICDMACallbackContext that outlives the transfer and its interrupts.
// The descriptor reads the DMA's current Parent when a callback occurs.
public struct CORDICDMALinks<
  Registers: DMARegisterIO, Handle: DMAHandleIO, Callbacks: DMACallbackIO, Memory: DMAMemoryIO
>: CORDICDMAIO {
  public let input: DMA<Registers, Handle, Callbacks, Memory>?
  public let output: DMA<Registers, Handle, Callbacks, Memory>?

  public init(
    input: DMA<Registers, Handle, Callbacks, Memory>? = nil,
    output: DMA<Registers, Handle, Callbacks, Memory>? = nil
  ) {
    self.input = input
    self.output = output
  }

  public func writeCallback(_ direction: CORDICDMADirection, id: DMACallbackID, value: DMACallback?) {
    channel(direction).callbacks.write(id, value: value)
  }

  public func callback(_ kind: CORDICDMACallbackKind) -> DMACallback { cordicDMAThunk(kind) }

  public func startInterrupt(
    _ direction: CORDICDMADirection, sourceAddress: UInt32,
    destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    channel(direction).startInterrupt(sourceAddress: sourceAddress,
      destinationAddress: destinationAddress, sourceDataSize: sourceDataSize)
  }

  private func channel(_ direction: CORDICDMADirection) -> DMA<Registers, Handle, Callbacks, Memory> {
    switch direction { case .input: return input!; case .output: return output! }
  }
}

// Calling a DMA operation with no attached channel violates the same handle
// precondition as the C HAL. Polling and interrupt CORDIC operations need none.
public struct CORDICNoDMA: CORDICDMAIO {
  public init() {}

  public func writeCallback(_ direction: CORDICDMADirection, id: DMACallbackID, value: DMACallback?) {
    preconditionFailure("DMA handle is absent")
  }

  public func callback(_ kind: CORDICDMACallbackKind) -> DMACallback { cordicDMAThunk(kind) }

  public func startInterrupt(
    _ direction: CORDICDMADirection, sourceAddress: UInt32,
    destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus { preconditionFailure("DMA handle is absent") }
}

private func cordicDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: CORDICDMACallbackKind) {
  let descriptor = context!.assumingMemoryBound(to: CORDICDMACallbackContext.self).pointee
  let parent = descriptor.readParent(descriptor.dmaContext)
  descriptor.dispatch(parent, kind.rawValue)
}

private func cordicDMAInputComplete(_ context: UnsafeMutableRawPointer?) {
  cordicDMADispatch(context, .inputComplete)
}

private func cordicDMAOutputComplete(_ context: UnsafeMutableRawPointer?) {
  cordicDMADispatch(context, .outputComplete)
}

private func cordicDMAError(_ context: UnsafeMutableRawPointer?) { cordicDMADispatch(context, .error) }

func cordicDMAThunk(_ kind: CORDICDMACallbackKind) -> DMACallback {
  switch kind {
  case .inputComplete: return cordicDMAInputComplete
  case .outputComplete: return cordicDMAOutputComplete
  case .error: return cordicDMAError
  }
}
