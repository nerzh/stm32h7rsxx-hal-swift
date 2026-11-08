// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum ADCDMACallbackKind: UInt32, CaseIterable { case complete = 0, halfComplete = 1, error = 2 }
public protocol ADCDMAIO {
    func sourceDataWidth() -> UInt32
    func read(_ word: DMAHandleWord) -> UInt32
    func readMemory32(at address: UInt32) -> UInt32
    func writeMemory32(at address: UInt32, value: UInt32)
    func writeCallback(_ id: DMACallbackID, value: DMACallback?)
    func callback(_ kind: ADCDMACallbackKind) -> DMACallback
    func getNodeSourceWidth(at address: UInt32, width: inout UInt32) -> HALStatus
    func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus
    func startLinkedListInterrupt() -> HALStatus
    func abort(getTick: () -> UInt32) -> HALStatus
    // The C completion path calls the current error slot with the incoming DMA context.
    func invokeErrorCallback(context: UnsafeMutableRawPointer?)
}
public struct ADCDMACallbackContext {
    public let dmaContext: UnsafeMutableRawPointer?
    public let readParent: @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
    public let dispatch: @convention(c) (UnsafeMutableRawPointer?, UInt32, UnsafeMutableRawPointer?) -> Void
    public init(dmaContext: UnsafeMutableRawPointer?,
                readParent: @escaping @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?,
                dispatch: @escaping @convention(c) (UnsafeMutableRawPointer?, UInt32, UnsafeMutableRawPointer?) -> Void) {
        self.dmaContext = dmaContext; self.readParent = readParent; self.dispatch = dispatch
    }
}
public struct ADCDMALink<Registers: DMARegisterIO, Handle: DMAHandleIO,
                          Callbacks: DMACallbackIO, Memory: DMAMemoryIO>: ADCDMAIO {
  public let input: DMA<Registers, Handle, Callbacks, Memory>?
  public let configurationContext: UnsafeMutableRawPointer?
  private let readSourceWidth: @convention(c) (UnsafeMutableRawPointer?) -> UInt32
  public init(input: DMA<Registers, Handle, Callbacks, Memory>?, configurationContext: UnsafeMutableRawPointer? = nil,
              readSourceWidth: @escaping @convention(c) (UnsafeMutableRawPointer?) -> UInt32) {
    self.input = input; self.configurationContext = configurationContext; self.readSourceWidth = readSourceWidth
  }
  // DMA's existing handle stores runtime state, so the application supplies its live Init width.
  public func sourceDataWidth() -> UInt32 { readSourceWidth(configurationContext) }
  public func read(_ word: DMAHandleWord) -> UInt32 { input!.handle.read(word) }
  public func readMemory32(at address: UInt32) -> UInt32 { input!.memory.read32(at: address) }
  public func writeMemory32(at address: UInt32, value: UInt32) { input!.memory.write32(at: address, value: value) }
  public func writeCallback(_ id: DMACallbackID, value: DMACallback?) { input!.callbacks.write(id, value: value) }
  public func callback(_ kind: ADCDMACallbackKind) -> DMACallback { adcDMAThunk(kind) }
  public func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    input!.startInterrupt(sourceAddress: sourceAddress, destinationAddress: destinationAddress,
                          sourceDataSize: sourceDataSize)
  }
  public func startLinkedListInterrupt() -> HALStatus { input!.startLinkedListInterrupt() }
  public func getNodeSourceWidth(at address: UInt32, width: inout UInt32) -> HALStatus {
    var configuration: DMANodeConfiguration? = .init()
    let status = DMALinkedList(memory: input!.memory).getNodeConfiguration(at: address, configuration: &configuration)
    if status == .ok { width = configuration!.configuration.sourceDataWidth }
    return status
  }
  public func invokeErrorCallback(context: UnsafeMutableRawPointer?) { input!.callbacks.read(.error)!(context) }
  public func abort(getTick: () -> UInt32) -> HALStatus { input!.abort(getTick: getTick) }
}
public struct ADCNoDMA: ADCDMAIO {
  public func sourceDataWidth() -> UInt32 { preconditionFailure("DMA handle is absent") }
  public init() {}
  public func read(_ word: DMAHandleWord) -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func readMemory32(at address: UInt32) -> UInt32 { preconditionFailure("DMA handle is absent") }
  public func writeMemory32(at address: UInt32, value: UInt32) { preconditionFailure("DMA handle is absent") }
  public func writeCallback(_ id: DMACallbackID, value: DMACallback?) { preconditionFailure("DMA handle is absent") }
  public func callback(_ kind: ADCDMACallbackKind) -> DMACallback { adcDMAThunk(kind) }
  public func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func startLinkedListInterrupt() -> HALStatus { preconditionFailure("DMA handle is absent") }
  public func getNodeSourceWidth(at address: UInt32, width: inout UInt32) -> HALStatus {
    preconditionFailure("DMA handle is absent")
  }
  public func invokeErrorCallback(context: UnsafeMutableRawPointer?) { preconditionFailure("DMA handle is absent") }
  public func abort(getTick: () -> UInt32) -> HALStatus { preconditionFailure("DMA handle is absent") }
}
// Context points to caller-owned storage; read the current parent on each call.
private func adcDMADispatch(_ context: UnsafeMutableRawPointer?, _ kind: ADCDMACallbackKind) {
    let descriptor = context!.assumingMemoryBound(to: ADCDMACallbackContext.self).pointee
    let parent = descriptor.readParent(descriptor.dmaContext)
    descriptor.dispatch(parent, kind.rawValue, context)
}
private func adcDMAComplete(_ context: UnsafeMutableRawPointer?) { adcDMADispatch(context, .complete) }
private func adcDMAHalfComplete(_ context: UnsafeMutableRawPointer?) { adcDMADispatch(context, .halfComplete) }
private func adcDMAError(_ context: UnsafeMutableRawPointer?) { adcDMADispatch(context, .error) }
func adcDMAThunk(_ kind: ADCDMACallbackKind) -> DMACallback {
    switch kind { case .complete: return adcDMAComplete; case .halfComplete: return adcDMAHalfComplete; case .error: return adcDMAError }
}
