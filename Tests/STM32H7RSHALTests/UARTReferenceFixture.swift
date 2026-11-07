import XCTest
import CUARTReference
@testable import STM32H7RSHAL

private func uartReferenceCallback(_ context: UnsafeMutableRawPointer?, _ id: UInt32,
                                   _ implementation: UInt32, _ position: UInt16) {
  let device = Unmanaged<UARTReferenceDeviceContext>.fromOpaque(context!).takeUnretainedValue()
  CUART_EmitCallback(device.owner.state, device.index, id, implementation, UInt32(position))
}
func uartReferenceCallbackValue(_ id: UInt32, _ implementation: UInt32) -> UARTCallback? {
  if implementation == 0 { return nil }
  switch (id, implementation) {
  case (0, 1): return { context in uartReferenceCallback(context, 0, 1, 0) }
  case (0, 2): return { context in uartReferenceCallback(context, 0, 2, 0) }
  case (0, 3): return { context in uartReferenceCallback(context, 0, 3, 0) }
  case (1, 1): return { context in uartReferenceCallback(context, 1, 1, 0) }
  case (1, 2): return { context in uartReferenceCallback(context, 1, 2, 0) }
  case (1, 3): return { context in uartReferenceCallback(context, 1, 3, 0) }
  case (2, 1): return { context in uartReferenceCallback(context, 2, 1, 0) }
  case (2, 2): return { context in uartReferenceCallback(context, 2, 2, 0) }
  case (2, 3): return { context in uartReferenceCallback(context, 2, 3, 0) }
  case (3, 1): return { context in uartReferenceCallback(context, 3, 1, 0) }
  case (3, 2): return { context in uartReferenceCallback(context, 3, 2, 0) }
  case (3, 3): return { context in uartReferenceCallback(context, 3, 3, 0) }
  case (4, 1): return { context in uartReferenceCallback(context, 4, 1, 0) }
  case (4, 2): return { context in uartReferenceCallback(context, 4, 2, 0) }
  case (4, 3): return { context in uartReferenceCallback(context, 4, 3, 0) }
  case (5, 1): return { context in uartReferenceCallback(context, 5, 1, 0) }
  case (5, 2): return { context in uartReferenceCallback(context, 5, 2, 0) }
  case (5, 3): return { context in uartReferenceCallback(context, 5, 3, 0) }
  case (6, 1): return { context in uartReferenceCallback(context, 6, 1, 0) }
  case (6, 2): return { context in uartReferenceCallback(context, 6, 2, 0) }
  case (6, 3): return { context in uartReferenceCallback(context, 6, 3, 0) }
  case (7, 1): return { context in uartReferenceCallback(context, 7, 1, 0) }
  case (7, 2): return { context in uartReferenceCallback(context, 7, 2, 0) }
  case (7, 3): return { context in uartReferenceCallback(context, 7, 3, 0) }
  case (8, 1): return { context in uartReferenceCallback(context, 8, 1, 0) }
  case (8, 2): return { context in uartReferenceCallback(context, 8, 2, 0) }
  case (8, 3): return { context in uartReferenceCallback(context, 8, 3, 0) }
  case (9, 1): return { context in uartReferenceCallback(context, 9, 1, 0) }
  case (9, 2): return { context in uartReferenceCallback(context, 9, 2, 0) }
  case (9, 3): return { context in uartReferenceCallback(context, 9, 3, 0) }
  case (10, 1): return { context in uartReferenceCallback(context, 10, 1, 0) }
  case (10, 2): return { context in uartReferenceCallback(context, 10, 2, 0) }
  case (10, 3): return { context in uartReferenceCallback(context, 10, 3, 0) }
  case (11, 1): return { context in uartReferenceCallback(context, 11, 1, 0) }
  case (11, 2): return { context in uartReferenceCallback(context, 11, 2, 0) }
  case (11, 3): return { context in uartReferenceCallback(context, 11, 3, 0) }
  case (12, 1): return { context in uartReferenceCallback(context, 12, 1, 0) }
  case (12, 2): return { context in uartReferenceCallback(context, 12, 2, 0) }
  case (12, 3): return { context in uartReferenceCallback(context, 12, 3, 0) }
  default: preconditionFailure("Invalid UART callback fixture selector")
  }
}
func uartReferenceRxCallbackValue(_ implementation: UInt32) -> UARTRxEventCallback? {
  switch implementation {
  case 0: return nil
  case 1: return { context, size in uartReferenceCallback(context, 13, 1, size) }
  case 2: return { context, size in uartReferenceCallback(context, 13, 2, size) }
  case 3: return { context, size in uartReferenceCallback(context, 13, 3, size) }
  default: preconditionFailure("Invalid UART Rx callback fixture selector")
  }
}
private func uartReferenceAction(_ context: UnsafeMutableRawPointer?, _ action: CUARTAction) {
  Unmanaged<UARTReferenceFixture>.fromOpaque(context!).takeUnretainedValue().apply(action)
}
private func uartReferenceDMAEvent(_ context: UnsafeMutableRawPointer?, _ channel: UInt32, _ event: UInt32) {
  Unmanaged<UARTReferenceFixture>.fromOpaque(context!).takeUnretainedValue().invokeDMAEvent(channel, event)
}
private func uartReferenceDMAParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  let source = Unmanaged<UARTReferenceDMASource>.fromOpaque(context!).takeUnretainedValue()
  let parent = CUART_GetDMAWord(source.owner.state, source.index, CUART_DMAParent)
  return parent < 2 ? source.owner.devices[Int(parent)].context : nil
}
private func uartReferenceDMADispatch(_ parent: UnsafeMutableRawPointer?, _ context: UnsafeMutableRawPointer?, _ kind: UInt32) {
  let device = Unmanaged<UARTReferenceDeviceContext>.fromOpaque(parent!).takeUnretainedValue()
  let source = Unmanaged<UARTReferenceDMASource>.fromOpaque(context!).takeUnretainedValue()
  device.owner.driver(device.index).handleDMAEvent(UARTDMACallbackKind(rawValue: kind)!, source: source)
}

final class UARTReferenceDeviceContext {
  unowned let owner: UARTReferenceFixture
  let index: UInt32
  init(owner: UARTReferenceFixture, index: UInt32) { self.owner = owner; self.index = index }
  var context: UnsafeMutableRawPointer { Unmanaged.passUnretained(self).toOpaque() }
}
final class UARTReferenceDMASource: UARTDMAEventSourceIO {
  unowned let owner: UARTReferenceFixture
  let index: UInt32
  let descriptor = UnsafeMutablePointer<UARTDMACallbackContext>.allocate(capacity: 1)
  init(owner: UARTReferenceFixture, index: UInt32) {
    self.owner = owner; self.index = index
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: uartReferenceDMAParent, dispatch: uartReferenceDMADispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  func readMode() -> UInt32 { CUART_GetDMAWord(owner.state, index, CUART_DMAMode) }
  func getCounter() -> UInt32 { CUART_GetDMAWord(owner.state, index, CUART_DMACounter) & 0xFFFF }
}

final class UARTReferenceFixture {
  let state = UnsafeMutablePointer<CUARTState>.allocate(capacity: 1)
  let registered: Bool
  var devices: [UARTReferenceDeviceContext] = []
  var sources: [UARTReferenceDMASource] = []
  // Only enable model READ_REG events for call sites known to use READ_REG in C.
  // Direct C flag, RDR and TDR accesses do not provide a complete read trace.
  var scriptedRegisters: Set<UARTRegister> = []
  init(registered: Bool, swift: Bool) {
    self.registered = registered
    CUART_Reset(state, registered ? 1 : 0)
    for index in UInt32(0)..<2 { devices.append(.init(owner: self, index: index)) }
    for index in UInt32(0)..<4 { sources.append(.init(owner: self, index: index)) }
    if swift {
      CUART_SetExecutionHooks(state, Unmanaged.passUnretained(self).toOpaque(),
        uartReferenceAction, uartReferenceDMAEvent)
    }
  }
  deinit { state.deallocate() }
  func io(_ index: UInt32 = 0) -> UARTReferenceIO { .init(owner: self, index: index) }
  func driver(_ index: UInt32 = 0) -> UART<UARTReferenceIO, UARTReferenceIO, UARTReferenceIO, UARTReferenceIO> {
    let io = self.io(index)
    return .init(registers: io, handle: io, callbacks: io, dma: io,
      defaults: .init(transmitHalfComplete: uartReferenceCallbackValue(0, 1)!,
        transmitComplete: uartReferenceCallbackValue(1, 1)!,
        receiveHalfComplete: uartReferenceCallbackValue(2, 1)!,
        receiveComplete: uartReferenceCallbackValue(3, 1)!,
        error: uartReferenceCallbackValue(4, 1)!,
        abortComplete: uartReferenceCallbackValue(5, 1)!,
        abortTransmitComplete: uartReferenceCallbackValue(6, 1)!,
        abortReceiveComplete: uartReferenceCallbackValue(7, 1)!,
        wakeup: uartReferenceCallbackValue(8, 1)!,
        receiveFIFOFull: uartReferenceCallbackValue(9, 1)!,
        transmitFIFOEmpty: uartReferenceCallbackValue(10, 1)!,
        mspInitialize: uartReferenceCallbackValue(11, 1)!,
        mspDeinitialize: uartReferenceCallbackValue(12, 1)!,
        rxEvent: uartReferenceRxCallbackValue(1)!), useRegisteredCallbacks: registered)
  }
  func getTick() -> UInt32 { CUART_Tick(state) }
  func apply(_ action: CUARTAction) {
    switch action.kind {
    case CUART_ActionNone: break
    case CUART_ActionRegister:
      CUART_SetRegister(state, action.target, CUARTRegister(rawValue: action.index), action.value)
    case CUART_ActionWord: CUART_SetWord(state, action.target, action.index, action.value)
    case CUART_ActionPointer: CUART_SetPointer(state, action.target, action.index, action.value)
    case CUART_ActionCall:
      _ = call(CUARTOperation(rawValue: action.index), uart: action.target,
        a: action.args.0, b: action.args.1, c: action.args.2, d: action.args.3)
    case CUART_ActionDMAWord:
      CUART_SetDMAWord(state, action.target, CUARTDMAWord(rawValue: action.index), action.value)
    case CUART_ActionDMAEvent: invokeDMAEvent(action.target, action.index)
    default: preconditionFailure("Unknown UART fixture action")
    }
  }
  func invokeDMAEvent(_ channel: UInt32, _ kind: UInt32) {
    let parent = CUART_GetDMAWord(state, channel, CUART_DMAParent)
    driver(parent).handleDMAEvent(UARTDMACallbackKind(rawValue: kind)!, source: sources[Int(channel)])
  }
  func call(_ operation: CUARTOperation, uart index: UInt32 = 0,
            a: UInt32 = 0, b: UInt32 = 0, c: UInt32 = 0, d: UInt32 = 0) -> UInt32 {
    let uart = driver(index)
    let io = self.io(index)
    let tx = d != 0 ? nil : CUART_Buffer(state, index, 0)?.advanced(by: Int(c))
    let rx = d != 0 ? nil : CUART_Buffer(state, index, 1)?.advanced(by: Int(c))
    let size = UInt16(truncatingIfNeeded: a)
    switch operation {
    case CUART_Initialize: return uart.initialize(clocks: io, getTick: getTick).rawValue
    case CUART_InitializeHalfDuplex: return uart.initializeHalfDuplex(clocks: io, getTick: getTick).rawValue
    case CUART_InitializeLIN: return uart.initializeLIN(breakDetectLength: a, clocks: io, getTick: getTick).rawValue
    case CUART_InitializeMultiProcessor:
      return uart.initializeMultiProcessor(address: UInt8(truncatingIfNeeded: a), wakeupMethod: b, clocks: io, getTick: getTick).rawValue
    case CUART_InitializeRS485:
      return uart.initializeRS485(polarity: a, assertionTime: b, deassertionTime: c, clocks: io, getTick: getTick).rawValue
    case CUART_Deinitialize: return uart.deinitialize().rawValue
    case CUART_Transmit: return uart.transmit(tx.map(UnsafeRawPointer.init), size: size, timeout: b, getTick: getTick).rawValue
    case CUART_Receive: return uart.receive(rx, size: size, timeout: b, getTick: getTick).rawValue
    case CUART_TransmitInterrupt: return uart.transmitInterrupt(tx.map(UnsafeRawPointer.init), size: size).rawValue
    case CUART_ReceiveInterrupt: return uart.receiveInterrupt(rx, size: size).rawValue
    case CUART_HandleInterrupt: uart.handleInterrupt(getTick: getTick); return 0
    case CUART_TransmitDMA: return uart.transmitDMA(tx.map(UnsafeRawPointer.init), size: size).rawValue
    case CUART_ReceiveDMA: return uart.receiveDMA(rx, size: size).rawValue
    case CUART_PauseDMA: return uart.pauseDMA(getTick: getTick).rawValue
    case CUART_ResumeDMA: return uart.resumeDMA().rawValue
    case CUART_StopDMA: return uart.stopDMA(getTick: getTick).rawValue
    case CUART_Abort: return uart.abort(getTick: getTick).rawValue
    case CUART_AbortTransmit: return uart.abortTransmit(getTick: getTick).rawValue
    case CUART_AbortReceive: return uart.abortReceive(getTick: getTick).rawValue
    case CUART_AbortInterrupt: return uart.abortInterrupt().rawValue
    case CUART_AbortTransmitInterrupt: return uart.abortTransmitInterrupt().rawValue
    case CUART_AbortReceiveInterrupt: return uart.abortReceiveInterrupt().rawValue
    case CUART_ConfigureReceiverTimeout: uart.configureReceiverTimeout(a); return 0
    case CUART_EnableReceiverTimeout: return uart.enableReceiverTimeout().rawValue
    case CUART_DisableReceiverTimeout: return uart.disableReceiverTimeout().rawValue
    case CUART_EnableMuteMode: return uart.enableMuteMode(getTick: getTick).rawValue
    case CUART_DisableMuteMode: return uart.disableMuteMode(getTick: getTick).rawValue
    case CUART_EnterMuteMode: uart.enterMuteMode(); return 0
    case CUART_EnableTransmitter: return uart.enableTransmitter().rawValue
    case CUART_EnableReceiver: return uart.enableReceiver().rawValue
    case CUART_SendBreak: return uart.sendBreak().rawValue
    case CUART_GetState: return uart.getState()
    case CUART_GetError: return uart.getError()
    case CUART_SetAddressLength: return uart.setAddressLength(a, getTick: getTick).rawValue
    case CUART_ConfigureStopModeWakeup:
      return uart.configureStopModeWakeup(.init(event: a, addressLength: UInt16(truncatingIfNeeded: b),
        address: UInt8(truncatingIfNeeded: c)), getTick: getTick).rawValue
    case CUART_EnableStopMode: return uart.enableStopMode().rawValue
    case CUART_DisableStopMode: return uart.disableStopMode().rawValue
    case CUART_EnableFIFOMode: return uart.enableFIFOMode().rawValue
    case CUART_DisableFIFOMode: return uart.disableFIFOMode().rawValue
    case CUART_SetTransmitFIFOThreshold: return uart.setTransmitFIFOThreshold(a).rawValue
    case CUART_SetReceiveFIFOThreshold: return uart.setReceiveFIFOThreshold(a).rawValue
    case CUART_ReceiveToIdle:
      return uart.receiveToIdle(rx, size: size, receivedCount: CUART_ReceivedCount(state, index)!,
        timeout: b, getTick: getTick).rawValue
    case CUART_ReceiveToIdleInterrupt: return uart.receiveToIdleInterrupt(rx, size: size).rawValue
    case CUART_ReceiveToIdleDMA: return uart.receiveToIdleDMA(rx, size: size).rawValue
    case CUART_GetRxEventType: return uart.getRxEventType()
    case CUART_RegisterCallback:
      return uart.registerCallback(id: a, callback: uartReferenceCallbackValue(a <= 12 ? a : 0, b)).rawValue
    case CUART_UnregisterCallback: return uart.unregisterCallback(id: a).rawValue
    case CUART_RegisterRxEventCallback: return uart.registerRxEventCallback(uartReferenceRxCallbackValue(a)).rawValue
    case CUART_UnregisterRxEventCallback: return uart.unregisterRxEventCallback().rawValue
    case CUART_SetConfiguration: return uart.setConfiguration(clocks: io).rawValue
    case CUART_CheckIdleState: return uart.checkIdleState(getTick: getTick).rawValue
    case CUART_WaitOnFlag:
      return uart.waitOnFlagUntilTimeout(flag: a, status: b != 0, tickStart: c, timeout: d, getTick: getTick).rawValue
    default: preconditionFailure("Unknown UART reference operation")
    }
  }
}

struct UARTReferenceIO: UARTRegisterIO, UARTHandleIO, UARTCallbackIO, UARTDMAIO, UARTClockIO {
  let owner: UARTReferenceFixture
  let index: UInt32
  var state: UnsafeMutablePointer<CUARTState> { owner.state }
  var context: UnsafeMutableRawPointer? { owner.devices[Int(index)].context }
  var instance: UARTInstance {
    UARTInstance(rawValue: index == 0 ? state.pointee.uart.0.instance : state.pointee.uart.1.instance)!
  }
  func register(_ register: UARTRegister) -> CUARTRegister {
    CUARTRegister(rawValue: UInt32(UARTRegister.allCases.firstIndex(of: register)!))
  }
  func read(_ register: UARTRegister) -> UInt32 {
    owner.scriptedRegisters.contains(register) ? CUART_Read(state, index, self.register(register))
      : CUART_GetRegister(state, index, self.register(register))
  }
  func write(_ register: UARTRegister, value: UInt32) { CUART_Write(state, index, self.register(register), value) }
  func atomicModify(_ register: UARTRegister, clear: UInt32, set: UInt32) {
    CUART_AtomicModify(state, index, self.register(register), clear, set)
  }
  func read(_ word: UARTConfigurationWord) -> UInt32 { CUART_GetWord(state, index, UInt32(word.rawValue)) }
  func write(_ word: UARTConfigurationWord, value: UInt32) { CUART_SetWord(state, index, UInt32(word.rawValue), value) }
  func read(_ word: UARTAdvancedConfigurationWord) -> UInt32 { CUART_GetWord(state, index, 9 + UInt32(word.rawValue)) }
  func write(_ word: UARTAdvancedConfigurationWord, value: UInt32) { CUART_SetWord(state, index, 9 + UInt32(word.rawValue), value) }
  func read(_ word: UARTHandleHalfWord) -> UInt16 { UInt16(truncatingIfNeeded: CUART_GetWord(state, index, 19 + UInt32(word.rawValue))) }
  func write(_ word: UARTHandleHalfWord, value: UInt16) { CUART_SetWord(state, index, 19 + UInt32(word.rawValue), UInt32(value)) }
  func read(_ word: UARTHandleWord) -> UInt32 { CUART_GetWord(state, index, 26 + UInt32(word.rawValue)) }
  func write(_ word: UARTHandleWord, value: UInt32) { CUART_SetWord(state, index, 26 + UInt32(word.rawValue), value) }
  func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer? {
    nativePointer(CUART_GetPointer(state, index, UInt32(pointer.rawValue)))
  }
  func nativePointer(_ address: UInt32) -> UnsafeMutableRawPointer? {
    if address == 0 { return nil }
    for uart in UInt32(0)..<2 {
      for direction in UInt32(0)..<2 {
        let base = CUART_BufferAddress(uart, direction)
        if address >= base && address <= base + 512 {
          return CUART_Buffer(state, uart, direction)!.advanced(by: Int(address - base))
        }
      }
    }
    return UnsafeMutableRawPointer(bitPattern: UInt(address))
  }
  func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?) {
    let direction = UInt32(pointer.rawValue)
    let address = value.map { UInt(bitPattern: $0) } ?? 0
    let base = UInt(bitPattern: CUART_Buffer(state, index, direction)!)
    // Native TX end coincides with RX start. Preserve the field's one-past-end
    // pointer before generic normalization chooses the adjacent buffer.
    let logical = address >= base && address - base <= 512
      ? CUART_BufferAddress(index, direction) + UInt32(address - base)
      : CUART_NormalizeAddress(state, address)
    CUART_SetPointer(state, index, direction, logical)
  }
  func read(_ id: UARTCallbackID) -> UARTCallback? {
    uartReferenceCallbackValue(id.rawValue, CUART_GetCallback(state, index, id.rawValue))
  }
  func write(_ id: UARTCallbackID, value: UARTCallback?) {
    let selector: UInt32
    if let value {
      let bits = unsafeBitCast(value, to: UInt.self)
      selector = (UInt32(1)...3).first {
        unsafeBitCast(uartReferenceCallbackValue(id.rawValue, $0)!, to: UInt.self) == bits
      }!
    } else { selector = 0 }
    CUART_SetCallback(state, index, id.rawValue, selector)
  }
  func readRxEventCallback() -> UARTRxEventCallback? {
    uartReferenceRxCallbackValue(CUART_GetCallback(state, index, 13))
  }
  func writeRxEventCallback(_ value: UARTRxEventCallback?) {
    let selector: UInt32
    if let value {
      let bits = unsafeBitCast(value, to: UInt.self)
      selector = (UInt32(1)...3).first {
        unsafeBitCast(uartReferenceRxCallbackValue($0)!, to: UInt.self) == bits
      }!
    } else { selector = 0 }
    CUART_SetCallback(state, index, 13, selector)
  }
  func dmaIndex(_ direction: UARTDMADirection) -> UInt32 {
    let channel = CUART_GetLinkedDMA(state, index, direction.rawValue)
    precondition(channel >= 0)
    return UInt32(channel)
  }
  func isPresent(_ direction: UARTDMADirection) -> Bool { CUART_GetLinkedDMA(state, index, direction.rawValue) >= 0 }
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    let channel = dmaIndex(direction)
    switch word {
    case .lock: return CUART_GetDMAWord(state, channel, CUART_DMALock)
    case .mode: return CUART_GetDMAWord(state, channel, CUART_DMAMode)
    case .state: return CUART_GetDMAWord(state, channel, CUART_DMAState)
    case .errorCode: return CUART_GetDMAWord(state, channel, CUART_DMAError)
    case .queueAddress:
      return CUART_GetDMAWord(state, channel, CUART_DMAQueuePresent) == 0 ? 0 : 0x2403_0000 + channel * 0x100
    }
  }
  func getCounter(_ direction: UARTDMADirection) -> UInt32 {
    CUART_GetDMAWord(state, dmaIndex(direction), CUART_DMACounter) & 0xFFFF
  }
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    CUART_DMAReadMemory32(state, dmaIndex(direction), address)
  }
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    CUART_DMAWriteMemory32(state, dmaIndex(direction), address, value)
  }
  func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback? {
    let value = CUART_GetDMACallback(state, dmaIndex(direction), id.rawValue)
    return value == 0 ? nil : uartDMAThunk(UARTDMACallbackKind(rawValue: value - 1)!)
  }
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    let selector: UInt32
    if let value {
      let bits = unsafeBitCast(value, to: UInt.self)
      selector = UARTDMACallbackKind.allCases.first {
        unsafeBitCast(uartDMAThunk($0), to: UInt.self) == bits
      }!.rawValue + 1
    } else { selector = 0 }
    CUART_SetDMACallback(state, dmaIndex(direction), id.rawValue, selector)
  }
  func readParent(_ direction: UARTDMADirection) -> UnsafeMutableRawPointer? {
    let value = CUART_GetDMAWord(state, dmaIndex(direction), CUART_DMAParent)
    return value < 2 ? owner.devices[Int(value)].context : nil
  }
  func writeParent(_ direction: UARTDMADirection, value: UnsafeMutableRawPointer?) {
    let parent = value.map { Unmanaged<UARTReferenceDeviceContext>.fromOpaque($0).takeUnretainedValue().index } ?? .max
    CUART_SetDMAWord(state, dmaIndex(direction), CUART_DMAParent, parent)
  }
  func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID) {
    readCallback(direction, id: id)!(UnsafeMutableRawPointer(owner.sources[Int(dmaIndex(direction))].descriptor))
  }
  func callback(_ kind: UARTDMACallbackKind) -> DMACallback { uartDMAThunk(kind) }
  func startInterrupt(_ direction: UARTDMADirection, sourceAddress: UInt32,
                      destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    HALStatus(rawValue: CUART_PerformDMA(state, dmaIndex(direction), CUART_DMAStartInterrupt,
      sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    HALStatus(rawValue: CUART_PerformDMA(state, dmaIndex(direction), CUART_DMAStartLinkedListInterrupt, 0, 0, 0))!
  }
  func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    HALStatus(rawValue: CUART_PerformDMA(state, dmaIndex(direction), CUART_DMAAbort, 0, 0, 0))!
  }
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    HALStatus(rawValue: CUART_PerformDMA(state, dmaIndex(direction), CUART_DMAAbortInterrupt, 0, 0, 0))!
  }
  func suspend(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    HALStatus(rawValue: CUART_PerformDMA(state, dmaIndex(direction), CUART_DMASuspend, 0, 0, 0))!
  }
  func resume(_ direction: UARTDMADirection) -> HALStatus {
    HALStatus(rawValue: CUART_PerformDMA(state, dmaIndex(direction), CUART_DMAResume, 0, 0, 0))!
  }
  func source(for instance: UARTInstance) -> UARTClockSource {
    UARTClockSource(rawValue: CUART_GetClockSource(state, index))!
  }
  func frequency(_ source: UARTClockSource) -> UInt32 { CUART_GetClockFrequency(state, source.rawValue) }
}

final class UARTReferencePair {
  private let cModel: UARTReferenceFixture
  private let swiftModel: UARTReferenceFixture
  var reference: UnsafeMutablePointer<CUARTState> { cModel.state }
  var actual: UnsafeMutablePointer<CUARTState> { swiftModel.state }
  var scriptedRegisters: Set<UARTRegister> {
    get { swiftModel.scriptedRegisters }
    set { swiftModel.scriptedRegisters = newValue }
  }
  init(registered: Bool, setup: (UnsafeMutablePointer<CUARTState>) -> Void = { _ in }) {
    cModel = UARTReferenceFixture(registered: registered, swift: false)
    swiftModel = UARTReferenceFixture(registered: registered, swift: true)
    setup(reference); setup(actual)
  }
  func configureBoth(_ configure: (UnsafeMutablePointer<CUARTState>) -> Void) {
    configure(reference); configure(actual)
  }
  func run(_ operation: CUARTOperation, uart: UInt32 = 0,
           a: UInt32 = 0, b: UInt32 = 0, c: UInt32 = 0, d: UInt32 = 0,
           file: StaticString = #filePath, line: UInt = #line) {
    let expected = CUART_Call(reference, uart, operation, a, b, c, d)
    let result = swiftModel.call(operation, uart: uart, a: a, b: b, c: c, d: d)
    XCTAssertEqual(result, expected, "UART operation \(operation.rawValue), uart \(uart)", file: file, line: line)
    compare(file: file, line: line)
  }
  func runDMAEvent(originalChannel: UInt32, kind: UARTDMACallbackKind,
                   file: StaticString = #filePath, line: UInt = #line) {
    CUART_InvokeDMAEvent(reference, originalChannel, kind.rawValue)
    swiftModel.invokeDMAEvent(originalChannel, kind.rawValue)
    compare(file: file, line: line)
  }
  func compare(file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(snapshotWords(CUART_GetSnapshot(actual)), snapshotWords(CUART_GetSnapshot(reference)),
      "Final UART/DMA state", file: file, line: line)
    XCTAssertEqual(actual.pointee.tick, reference.pointee.tick, "tick", file: file, line: line)
    XCTAssertEqual(actual.pointee.tickCalls, reference.pointee.tickCalls, "tick calls", file: file, line: line)
    XCTAssertEqual(actual.pointee.callbackCount, reference.pointee.callbackCount, "callback count", file: file, line: line)
    XCTAssertEqual(actual.pointee.dmaCallCount, reference.pointee.dmaCallCount, "DMA call count", file: file, line: line)
    for uart in UInt32(0)..<2 {
      XCTAssertEqual(CUART_ReceivedCount(actual, uart)!.pointee, CUART_ReceivedCount(reference, uart)!.pointee,
        "ReceiveToIdle count", file: file, line: line)
      for direction in UInt32(0)..<2 {
        let actualBytes = (UInt32(0)..<512).map { CUART_GetBufferByte(actual, uart, direction, $0) }
        let referenceBytes = (UInt32(0)..<512).map { CUART_GetBufferByte(reference, uart, direction, $0) }
        XCTAssertEqual(actualBytes, referenceBytes, "Buffer \(uart)/\(direction)", file: file, line: line)
      }
    }
    for index in UInt32(0)..<min(actual.pointee.callbackCount, reference.pointee.callbackCount) {
      let a = CUART_GetCallbackEvent(actual, index), b = CUART_GetCallbackEvent(reference, index)
      XCTAssertEqual([a.uart, a.callbackID, a.implementation, a.position, a.tickCall, a.dmaCallCount],
        [b.uart, b.callbackID, b.implementation, b.position, b.tickCall, b.dmaCallCount],
        "Callback \(index)", file: file, line: line)
      XCTAssertEqual(snapshotWords(a.snapshot), snapshotWords(b.snapshot), "Callback snapshot \(index)", file: file, line: line)
    }
    for index in UInt32(0)..<min(actual.pointee.dmaCallCount, reference.pointee.dmaCallCount) {
      let a = CUART_GetDMAEvent(actual, index), b = CUART_GetDMAEvent(reference, index)
      XCTAssertEqual([a.channel, a.operation, a.args.0, a.args.1, a.args.2, a.tickCall, a.callbackCount],
        [b.channel, b.operation, b.args.0, b.args.1, b.args.2, b.tickCall, b.callbackCount],
        "DMA operation \(index)", file: file, line: line)
      XCTAssertEqual(snapshotWords(a.snapshot), snapshotWords(b.snapshot), "DMA snapshot \(index)", file: file, line: line)
    }
    // accessCount/readCounts are intentionally omitted: unmodified C includes
    // direct volatile accesses that the macro-only oracle does not instrument.
  }
  private func snapshotWords(_ snapshot: CUARTSnapshot) -> [UInt32] {
    withUnsafeBytes(of: snapshot) { Array($0.bindMemory(to: UInt32.self)) }
  }
}
