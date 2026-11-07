import XCTest
@testable import STM32H7RSHAL

enum UARTDMAOperation: Hashable { case start, startLinkedList, abort, abortInterrupt, suspend, resume }
enum UARTDMAAccess: Equatable {
  case read(UARTRegister), write(UARTRegister, UInt32), atomic(UARTRegister, UInt32, UInt32)
  case word(UARTHandleWord, UInt32), half(UARTHandleHalfWord, UInt16)
  case pointer(UARTBufferPointer, UInt)
  case dmaRead(UARTDMADirection, DMAHandleWord), counter(UARTDMADirection)
  case memoryRead(UARTDMADirection, UInt32), memoryWrite(UARTDMADirection, UInt32, UInt32)
  case dmaCallbackRead(UARTDMADirection, DMACallbackID)
  case dmaCallbackWrite(UARTDMADirection, DMACallbackID, UARTDMACallbackKind?)
  case operation(UARTDMADirection, UARTDMAOperation, UInt32, UInt32, UInt32)
  case dmaInvoke(UARTDMADirection, DMACallbackID)
  case callback(UARTCallbackID), rxEvent(UInt16)
}
struct UARTDMACallbackSnapshot: Equatable {
  let callback: UARTCallbackID?
  let size: UInt16?
  let globalState, receiveState, error, receptionType, eventType, rxISR, txISR: UInt32
  let txCount, rxCount: UInt16
  let cr1, cr3: UInt32
}

private func uartFixtureParent(_ pointer: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<UARTDMAFixtureChannel>.fromOpaque(pointer!).takeUnretainedValue().parent
}
private func uartFixtureDispatch(_ parent: UnsafeMutableRawPointer?, _ originalDMA: UnsafeMutableRawPointer?, _ event: UInt32) {
  let source = Unmanaged<UARTDMAFixtureChannel>.fromOpaque(originalDMA!).takeUnretainedValue()
  Unmanaged<UARTDMAFixture>.fromOpaque(parent!).takeUnretainedValue()
    .uart.handleDMAEvent(UARTDMACallbackKind(rawValue: event)!, source: source)
}
private func uartFixtureObject(_ pointer: UnsafeMutableRawPointer?) -> UARTDMAFixture {
  Unmanaged<UARTDMAFixture>.fromOpaque(pointer!).takeUnretainedValue()
}
private func uartFixtureTxHalf(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.transmitHalfComplete) }
private func uartFixtureTx(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.transmitComplete) }
private func uartFixtureRxHalf(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.receiveHalfComplete) }
private func uartFixtureRx(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.receiveComplete) }
private func uartFixtureError(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.error) }
private func uartFixtureAbort(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.abortComplete) }
private func uartFixtureAbortTx(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.abortTransmitComplete) }
private func uartFixtureAbortRx(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.abortReceiveComplete) }
private func uartFixtureWakeup(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.wakeup) }
private func uartFixtureRxFIFO(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.receiveFIFOFull) }
private func uartFixtureTxFIFO(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.transmitFIFOEmpty) }
private func uartFixtureMSPInit(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.mspInitialize) }
private func uartFixtureMSPDeinit(_ pointer: UnsafeMutableRawPointer?) { uartFixtureObject(pointer).record(.mspDeinitialize) }
private func uartFixtureRxEvent(_ pointer: UnsafeMutableRawPointer?, _ size: UInt16) {
  uartFixtureObject(pointer).recordRxEvent(size)
}

final class UARTDMAFixtureChannel: UARTDMAEventSourceIO {
  let direction: UARTDMADirection
  weak var owner: UARTDMAFixture?
  var present = true
  var mode: UInt32 = 0
  var errorCode: UInt32 = 0
  var queueAddress: UInt32 = 0
  var counter: UInt32 = 0
  var state: UInt32 = 1
  var lock: UInt32 = 0
  var statuses: [UARTDMAOperation: HALStatus] = [:]
  var callbacks: [DMACallbackID: DMACallback] = [:]
  var parent: UnsafeMutableRawPointer?
  let descriptor = UnsafeMutablePointer<UARTDMACallbackContext>.allocate(capacity: 1)
  init(direction: UARTDMADirection) {
    self.direction = direction
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: uartFixtureParent, dispatch: uartFixtureDispatch))
  }
  func readMode() -> UInt32 { owner?.trace.append(.dmaRead(direction, .mode)); return mode }
  func getCounter() -> UInt32 { owner?.trace.append(.counter(direction)); return counter }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
}

final class UARTDMAFixture: UARTRegisterIO, UARTHandleIO, UARTCallbackIO, UARTDMAIO {
  var instance: UARTInstance
  var registers: [UARTRegister: UInt32] = [:]
  var configuration: [UARTConfigurationWord: UInt32] = [:]
  var advanced: [UARTAdvancedConfigurationWord: UInt32] = [:]
  var halves: [UARTHandleHalfWord: UInt16] = [:]
  var words: [UARTHandleWord: UInt32] = [.globalState: 0x20, .receiveState: 0x20]
  var pointers: [UARTBufferPointer: UnsafeMutableRawPointer] = [:]
  var callbackSlots: [UARTCallbackID: UARTCallback] = [:]
  var rxEventCallback: UARTRxEventCallback?
  var useRegisteredCallbacks: Bool
  let tx = UARTDMAFixtureChannel(direction: .transmit)
  let rx = UARTDMAFixtureChannel(direction: .receive)
  var memory: [UInt32: UInt32] = [:]
  var trace: [UARTDMAAccess] = []
  var snapshots: [UARTDMACallbackSnapshot] = []
  var onOperation: ((UARTDMADirection, UARTDMAOperation) -> Void)?
  var onAtomic: ((UARTRegister, UInt32, UInt32) -> Void)?
  var onCallback: ((UARTCallbackID) -> Void)?
  var onRxEvent: ((UInt16) -> Void)?
  var onRead: ((UARTRegister) -> Void)?
  var scriptedReads: [UARTRegister: [UInt32]] = [:]
  var tick: UInt32 = 0
  var tickStep: UInt32 = 1
  var tickCalls = 0
  var onTick: ((UInt32) -> Void)?

  init(instance: UARTInstance = .usart2, registered: Bool = false) {
    self.instance = instance
    useRegisteredCallbacks = registered
    tx.parent = context
    rx.parent = context
    tx.owner = self
    rx.owner = self
    let defaults = self.defaults
    for id in UARTCallbackID.allCases { callbackSlots[id] = defaults.callback(id) }
    rxEventCallback = defaults.rxEvent
  }
  var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
  var uart: UART<UARTDMAFixture, UARTDMAFixture, UARTDMAFixture, UARTDMAFixture> {
    .init(registers: self, handle: self, callbacks: self, dma: self,
      defaults: defaults, useRegisteredCallbacks: useRegisteredCallbacks)
  }
  var defaults: UARTCallbackDefaults {
    .init(transmitHalfComplete: uartFixtureTxHalf, transmitComplete: uartFixtureTx,
      receiveHalfComplete: uartFixtureRxHalf, receiveComplete: uartFixtureRx,
      error: uartFixtureError, abortComplete: uartFixtureAbort,
      abortTransmitComplete: uartFixtureAbortTx, abortReceiveComplete: uartFixtureAbortRx,
      wakeup: uartFixtureWakeup, receiveFIFOFull: uartFixtureRxFIFO,
      transmitFIFOEmpty: uartFixtureTxFIFO, mspInitialize: uartFixtureMSPInit,
      mspDeinitialize: uartFixtureMSPDeinit, rxEvent: uartFixtureRxEvent)
  }
  var registerEffects: [UARTDMAAccess] {
    trace.filter {
      switch $0 { case .read, .write, .atomic: return true; default: return false }
    }
  }
  var registerWrites: [UARTDMAAccess] {
    trace.filter { switch $0 { case .write, .atomic: return true; default: return false } }
  }
  var events: [UARTDMAAccess] {
    trace.filter { switch $0 { case .callback, .rxEvent: return true; default: return false } }
  }
  var operations: [UARTDMAAccess] {
    trace.filter { if case .operation = $0 { return true }; return false }
  }
  func channel(_ direction: UARTDMADirection) -> UARTDMAFixtureChannel {
    direction == .transmit ? tx : rx
  }
  func read(_ register: UARTRegister) -> UInt32 {
    trace.append(.read(register))
    onRead?(register)
    if scriptedReads[register]?.isEmpty == false { return scriptedReads[register]!.removeFirst() }
    return registers[register, default: 0]
  }
  func write(_ register: UARTRegister, value: UInt32) {
    trace.append(.write(register, value))
    registers[register] = value
    if register == .icr { registers[.isr, default: 0] &= ~value }
  }
  func atomicModify(_ register: UARTRegister, clear: UInt32, set: UInt32) {
    trace.append(.atomic(register, clear, set))
    registers[register] = (registers[register, default: 0] & ~clear) | set
    onAtomic?(register, clear, set)
  }
  func read(_ word: UARTConfigurationWord) -> UInt32 { configuration[word, default: 0] }
  func write(_ word: UARTConfigurationWord, value: UInt32) { configuration[word] = value }
  func read(_ word: UARTAdvancedConfigurationWord) -> UInt32 { advanced[word, default: 0] }
  func write(_ word: UARTAdvancedConfigurationWord, value: UInt32) { advanced[word] = value }
  func read(_ word: UARTHandleHalfWord) -> UInt16 { halves[word, default: 0] }
  func write(_ word: UARTHandleHalfWord, value: UInt16) {
    trace.append(.half(word, value)); halves[word] = value
  }
  func read(_ word: UARTHandleWord) -> UInt32 { words[word, default: 0] }
  func write(_ word: UARTHandleWord, value: UInt32) {
    trace.append(.word(word, value)); words[word] = value
  }
  func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer? { pointers[pointer] }
  func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?) {
    trace.append(.pointer(pointer, value.map { UInt(bitPattern: $0) } ?? 0)); pointers[pointer] = value
  }
  func read(_ id: UARTCallbackID) -> UARTCallback? { callbackSlots[id] }
  func write(_ id: UARTCallbackID, value: UARTCallback?) { callbackSlots[id] = value }
  func readRxEventCallback() -> UARTRxEventCallback? { rxEventCallback }
  func writeRxEventCallback(_ value: UARTRxEventCallback?) { rxEventCallback = value }
  func isPresent(_ direction: UARTDMADirection) -> Bool { channel(direction).present }
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    trace.append(.dmaRead(direction, word))
    let dma = channel(direction)
    switch word {
    case .lock: return dma.lock
    case .mode: return dma.mode
    case .state: return dma.state
    case .errorCode: return dma.errorCode
    case .queueAddress: return dma.queueAddress
    }
  }
  func getCounter(_ direction: UARTDMADirection) -> UInt32 {
    trace.append(.counter(direction)); return channel(direction).counter
  }
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    trace.append(.memoryRead(direction, address)); return memory[address, default: 0]
  }
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    trace.append(.memoryWrite(direction, address, value)); memory[address] = value
  }
  func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback? {
    trace.append(.dmaCallbackRead(direction, id)); return channel(direction).callbacks[id]
  }
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    let kind = value.map { value in
      UARTDMACallbackKind.allCases.first {
        unsafeBitCast(uartDMAThunk($0), to: UInt.self) == unsafeBitCast(value, to: UInt.self)
      }!
    }
    trace.append(.dmaCallbackWrite(direction, id, kind)); channel(direction).callbacks[id] = value
  }
  func readParent(_ direction: UARTDMADirection) -> UnsafeMutableRawPointer? { channel(direction).parent }
  func writeParent(_ direction: UARTDMADirection, value: UnsafeMutableRawPointer?) { channel(direction).parent = value }
  func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID) {
    trace.append(.dmaInvoke(direction, id))
    readCallback(direction, id: id)!(UnsafeMutableRawPointer(channel(direction).descriptor))
  }
  func callback(_ kind: UARTDMACallbackKind) -> DMACallback { uartDMAThunk(kind) }
  func startInterrupt(_ direction: UARTDMADirection, sourceAddress: UInt32,
                      destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    operation(direction, .start, source: sourceAddress, destination: destinationAddress, count: sourceDataSize)
  }
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus { operation(direction, .startLinkedList) }
  func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus { operation(direction, .abort) }
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus { operation(direction, .abortInterrupt) }
  func suspend(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus { operation(direction, .suspend) }
  func resume(_ direction: UARTDMADirection) -> HALStatus { operation(direction, .resume) }
  func operation(_ direction: UARTDMADirection, _ operation: UARTDMAOperation,
                 source: UInt32 = 0, destination: UInt32 = 0, count: UInt32 = 0) -> HALStatus {
    trace.append(.operation(direction, operation, source, destination, count))
    onOperation?(direction, operation)
    return channel(direction).statuses[operation, default: .ok]
  }
  func record(_ id: UARTCallbackID) {
    trace.append(.callback(id)); snapshot(id, size: nil); onCallback?(id)
  }
  func recordRxEvent(_ size: UInt16) {
    trace.append(.rxEvent(size)); snapshot(nil, size: size); onRxEvent?(size)
  }
  func snapshot(_ id: UARTCallbackID?, size: UInt16?) {
    snapshots.append(.init(callback: id, size: size, globalState: words[.globalState, default: 0],
      receiveState: words[.receiveState, default: 0], error: words[.errorCode, default: 0],
      receptionType: words[.receptionType, default: 0], eventType: words[.rxEventType, default: 0],
      rxISR: words[.rxISR, default: 0], txISR: words[.txISR, default: 0],
      txCount: halves[.transmitCount, default: 0], rxCount: halves[.receiveCount, default: 0],
      cr1: registers[.cr1, default: 0], cr3: registers[.cr3, default: 0]))
  }
  func getTick() -> UInt32 {
    let value = tick; tick &+= tickStep; tickCalls += 1; onTick?(value); return value
  }
  func prepareBusy() {
    words[.globalState] = 0x21; words[.receiveState] = 0x22
    words[.receptionType] = 1; words[.fifoMode] = 0x2000_0000
    words[.rxISR] = 3; words[.txISR] = 4; words[.errorCode] = 8
    halves[.transmitSize] = 16; halves[.transmitCount] = 9
    halves[.receiveSize] = 16; halves[.receiveCount] = 7
    pointers[.transmit] = UnsafeMutableRawPointer(bitPattern: 0x2400_1000)
    pointers[.receive] = UnsafeMutableRawPointer(bitPattern: 0x2400_2000)
    registers[.cr1] = .max; registers[.cr3] = .max
  }
}
