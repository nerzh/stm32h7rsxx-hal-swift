import XCTest
@testable import STM32H7RSHAL

enum HASHTestAccess: Equatable {
  case read(HASHRegister), write(HASHRegister, UInt32)
  case handleRead(HASHHandleWord), handleWrite(HASHHandleWord, UInt32)
  case memoryRead(Int, UInt32), memoryWrite(UInt32, UInt32)
  case callbackRead(HASHCallbackID), callbackWrite(HASHCallbackID, Bool), callback(HASHCallbackID)
  case tick(UInt32), dmaWord(DMAHandleWord), dmaCounter, dmaFIFO
  case dmaCallback(DMACallbackID), dmaStart(UInt32, UInt32, UInt32), dmaListStart, dmaAbort
}
struct HASHTestSnapshot {
  let id: HASHCallbackID
  let words: [HASHHandleWord: UInt32]
  let registers: [HASHRegister: UInt32]
}
func hashTestObject(_ context: UnsafeMutableRawPointer?) -> HASHTestIO {
  Unmanaged<HASHTestIO>.fromOpaque(context!).takeUnretainedValue()
}
func hashTestInitialize(_ context: UnsafeMutableRawPointer?) { hashTestObject(context).record(.mspInitialize) }
func hashTestDeinitialize(_ context: UnsafeMutableRawPointer?) { hashTestObject(context).record(.mspDeinitialize) }
func hashTestInput(_ context: UnsafeMutableRawPointer?) { hashTestObject(context).record(.inputComplete) }
func hashTestDigest(_ context: UnsafeMutableRawPointer?) { hashTestObject(context).record(.digestComplete) }
func hashTestError(_ context: UnsafeMutableRawPointer?) { hashTestObject(context).record(.error) }
func hashTestCustom(_ context: UnsafeMutableRawPointer?) { hashTestObject(context).customCalls += 1 }
func hashTestDMAComplete(_ context: UnsafeMutableRawPointer?) {}
func hashTestDMAError(_ context: UnsafeMutableRawPointer?) {}

// The model records bus widths and stores raw register words. It deliberately
// implements neither HASH computation nor automatic hardware flag transitions.
final class HASHTestIO: HASHRegisterIO, HASHHandleIO, HASHCallbackIO, HASHDMAIO, HASHMemoryIO {
  var registers: [HASHRegister: UInt32] = [.sr: 3]
  var words: [HASHHandleWord: UInt32] = [
    .state: 1, .phase: 1, .dataType: 0x20, .keyAddress: 0x2000,
    .inputAddress: 0x1000, .outputAddress: 0x4000, .keyBufferAddress: 0x2000,
  ]
  var bytes: [UInt32: UInt8] = [:]
  var slots: [HASHCallbackID: HASHCallback] = [:]
  var dmaSlots: [DMACallbackID: DMACallback] = [:]
  var dmaWords: [DMAHandleWord: UInt32] = [:]
  var trace: [HASHTestAccess] = []
  var snapshots: [HASHTestSnapshot] = []
  var scriptedReads: [HASHRegister: [UInt32]] = [:]
  var tickValues: [UInt32] = []
  var tick: UInt32 = 0
  var tickStep: UInt32 = 1
  var counter: UInt32 = 0
  var fifoLevel: UInt32 = 0
  var startStatus: HALStatus = .ok
  var abortStatus: HALStatus = .ok
  var customCalls = 0
  var onRead: ((HASHRegister) -> Void)?
  var onWrite: ((HASHRegister, UInt32) -> Void)?
  var onHandleRead: ((HASHHandleWord) -> Void)?
  var onHandleWrite: ((HASHHandleWord, UInt32) -> Void)?
  var onCallback: ((HASHCallbackID) -> Void)?
  var onDMAStart: (() -> Void)?
  var onDMAAbort: (() -> Void)?
  var onTick: (() -> Void)?
  let registered: Bool
  let suspendEnabled: Bool

  init(registered: Bool = false, suspendEnabled: Bool = false) {
    self.registered = registered; self.suspendEnabled = suspendEnabled
    slots = [.mspInitialize: hashTestInitialize, .mspDeinitialize: hashTestDeinitialize,
      .inputComplete: hashTestInput, .digestComplete: hashTestDigest, .error: hashTestError]
    for offset in 0..<1024 {
      bytes[0x1000 + UInt32(offset)] = UInt8(truncatingIfNeeded: offset + 1)
      bytes[0x2000 + UInt32(offset)] = UInt8(truncatingIfNeeded: 0xA0 + offset)
    }
    for index in 0..<16 {
      registers[index < 5 ? .hr(index: index) : .digest(index: index)] = 0x1234_5600 + UInt32(index)
    }
  }
  var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
  var defaults: HASHCallbackDefaults {
    .init(mspInitialize: hashTestInitialize, mspDeinitialize: hashTestDeinitialize,
      inputComplete: hashTestInput, digestComplete: hashTestDigest, error: hashTestError)
  }
  var driver: HASH<HASHTestIO, HASHTestIO, HASHTestIO, HASHTestIO, HASHTestIO> {
    .init(registers: self, handle: self, callbacks: self, dma: self, memory: self,
      defaults: defaults, useRegisteredCallbacks: registered, useSuspendResume: suspendEnabled)
  }
  var mmio: [HASHTestAccess] {
    trace.filter { switch $0 { case .read, .write: return true; default: return false } }
  }
  var memoryReads: [HASHTestAccess] {
    trace.filter { if case .memoryRead = $0 { return true }; return false }
  }
  var inputWrites: [UInt32] {
    trace.compactMap { if case let .write(.din, value) = $0 { return value }; return nil }
  }
  var events: [HASHCallbackID] { snapshots.map(\.id) }
  var ticks: [UInt32] {
    trace.compactMap { if case let .tick(value) = $0 { return value }; return nil }
  }
  func read(_ register: HASHRegister) -> UInt32 {
    trace.append(.read(register)); onRead?(register)
    if scriptedReads[register]?.isEmpty == false { return scriptedReads[register]!.removeFirst() }
    return registers[register, default: 0]
  }
  func write(_ register: HASHRegister, value: UInt32) {
    trace.append(.write(register, value)); registers[register] = value; onWrite?(register, value)
  }
  func address(of register: HASHRegister) -> UInt32 {
    switch register {
    case .cr: return 0x4802_0400
    case .din: return 0x4802_0404
    case .str: return 0x4802_0408
    case .imr: return 0x4802_0420
    case .sr: return 0x4802_0424
    case .hr(let index): return 0x4802_040C + UInt32(index * 4)
    case .csr(let index): return 0x4802_04F8 + UInt32(index * 4)
    case .digest(let index): return 0x4802_0710 + UInt32(index * 4)
    }
  }
  func read(_ word: HASHHandleWord) -> UInt32 {
    trace.append(.handleRead(word)); onHandleRead?(word); return words[word, default: 0]
  }
  func write(_ word: HASHHandleWord, value: UInt32) {
    trace.append(.handleWrite(word, value)); words[word] = value; onHandleWrite?(word, value)
  }
  func read(_ id: HASHCallbackID) -> HASHCallback? { trace.append(.callbackRead(id)); return slots[id] }
  func write(_ id: HASHCallbackID, value: HASHCallback?) {
    trace.append(.callbackWrite(id, value != nil)); slots[id] = value
  }
  func record(_ id: HASHCallbackID) {
    trace.append(.callback(id)); snapshots.append(.init(id: id, words: words, registers: registers))
    onCallback?(id)
  }
  func rawRead(_ address: UInt32, width: Int = 4) -> UInt32 {
    (0..<width).reduce(UInt32(0)) { $0 | (UInt32(bytes[address &+ UInt32($1), default: 0]) << (8 * $1)) }
  }
  func rawWrite(_ address: UInt32, value: UInt32) {
    for index in 0..<4 { bytes[address &+ UInt32(index)] = UInt8(truncatingIfNeeded: value >> (8 * index)) }
  }
  func read8(at address: UInt32) -> UInt8 {
    trace.append(.memoryRead(1, address)); return UInt8(truncatingIfNeeded: rawRead(address, width: 1))
  }
  func read16(at address: UInt32) -> UInt16 {
    trace.append(.memoryRead(2, address)); return UInt16(truncatingIfNeeded: rawRead(address, width: 2))
  }
  func read32(at address: UInt32) -> UInt32 {
    trace.append(.memoryRead(4, address)); return rawRead(address)
  }
  func write32(at address: UInt32, value: UInt32) {
    trace.append(.memoryWrite(address, value)); rawWrite(address, value: value)
  }
  func getTick() -> UInt32 {
    let value: UInt32
    if tickValues.isEmpty { value = tick; tick &+= tickStep } else { value = tickValues.removeFirst() }
    trace.append(.tick(value)); onTick?(); return value
  }
  func read(_ word: DMAHandleWord) -> UInt32 { trace.append(.dmaWord(word)); return dmaWords[word, default: 0] }
  func getCounter() -> UInt32 { trace.append(.dmaCounter); return counter }
  func getFIFOLevel() -> UInt32 { trace.append(.dmaFIFO); return fifoLevel }
  func readMemory32(at address: UInt32) -> UInt32 { read32(at: address) }
  func writeMemory32(at address: UInt32, value: UInt32) { write32(at: address, value: value) }
  func writeCallback(_ id: DMACallbackID, value: DMACallback?) {
    trace.append(.dmaCallback(id)); dmaSlots[id] = value
  }
  func callback(_ kind: HASHDMACallbackKind) -> DMACallback {
    kind == .inputComplete ? hashTestDMAComplete : hashTestDMAError
  }
  func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    trace.append(.dmaStart(sourceAddress, destinationAddress, sourceDataSize)); onDMAStart?(); return startStatus
  }
  func startLinkedListInterrupt() -> HALStatus {
    trace.append(.dmaListStart); onDMAStart?(); return startStatus
  }
  func abort(getTick: () -> UInt32) -> HALStatus {
    trace.append(.dmaAbort); onDMAAbort?(); return abortStatus
  }
}
