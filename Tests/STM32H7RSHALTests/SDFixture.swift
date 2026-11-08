import CSDReference
import STM32H7RSHAL
import XCTest

final class SDFixture: SDRegisterIO, SDHandleIO, SDCallbackIO, DMAMemoryIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(variant: UInt32 = 1) {
    allocation = .allocate(byteCount: CSD_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CSD_Reset(state, variant)
  }
  deinit { allocation.deallocate() }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CSD_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CSD_Set(state, group, index, value)
  }
  var instance: SDMMCInstance { SDMMCInstance(rawValue: get(2, 1))! }
  var context: UnsafeMutableRawPointer? { allocation }
  func buffer(_ index: UInt32) -> UnsafeMutablePointer<UInt8> { CSD_Buffer(state, index)! }
  func read(_ register: SDMMCRegister) -> UInt32 { CSD_Read(state, register.rawValue) }
  func write(_ register: SDMMCRegister, value: UInt32) {
    CSD_Write(state, register.rawValue, value)
  }
  func address(of register: SDMMCRegister) -> UInt32 {
    (instance == .sdmmc1 ? 0x5200_7000 : 0x4800_2400) &+ register.rawValue
  }
  func readDelayControl() -> UInt32 { get(15, (instance.rawValue - 1) * 2) }
  func writeDelayControl(_ value: UInt32) { set(15, (instance.rawValue - 1) * 2, value) }
  func read(_ word: SDConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: SDConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: SDHandleWord) -> UInt32 { get(1, 6 + UInt32(word.rawValue)) }
  func write(_ word: SDHandleWord, value: UInt32) { set(1, 6 + UInt32(word.rawValue), value) }
  func read(_ word: SDCardWord) -> UInt32 { get(1, 12 + UInt32(word.rawValue)) }
  func write(_ word: SDCardWord, value: UInt32) { set(1, 12 + UInt32(word.rawValue), value) }
  func readCardRegister(_ register: SDCardRegister, index: Int) -> UInt32 {
    get(1, 21 + UInt32(register.rawValue * 4 + index))
  }
  func writeCardRegister(_ register: SDCardRegister, index: Int, value: UInt32) {
    set(1, 21 + UInt32(register.rawValue * 4 + index), value)
  }
  func readTransmitBuffer() -> UnsafePointer<UInt8>? { .init(bitPattern: CSD_GetPointer(state, 0)) }
  func writeTransmitBuffer(_ value: UnsafePointer<UInt8>?) {
    CSD_SetPointer(state, 0, UInt(bitPattern: value))
  }
  func readReceiveBuffer() -> UnsafeMutablePointer<UInt8>? {
    .init(bitPattern: CSD_GetPointer(state, 1))
  }
  func writeReceiveBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    CSD_SetPointer(state, 1, UInt(bitPattern: value))
  }
  func read32(at address: UInt32) -> UInt32 { CSD_ReadMemory(state, address) }
  func write32(at address: UInt32, value: UInt32) { CSD_WriteMemory(state, address, value) }
  func read(_ id: SDCallbackID) -> SDCallback? {
    let bits = CSD_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDCallback.self)
  }
  func write(_ id: SDCallbackID, value: SDCallback?) {
    CSD_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readTransceiver() -> SDTransceiverCallback? {
    let bits = CSD_GetCallback(state, 18)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDTransceiverCallback.self)
  }
  func writeTransceiver(_ value: SDTransceiverCallback?) {
    CSD_SetCallback(state, 18, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: SDCallbackDefaults {
    .init(
      transmitComplete: unsafeBitCast(CSD_Callback(0, 1), to: SDCallback.self),
      receiveComplete: unsafeBitCast(CSD_Callback(1, 1), to: SDCallback.self),
      error: unsafeBitCast(CSD_Callback(2, 1), to: SDCallback.self),
      abortComplete: unsafeBitCast(CSD_Callback(3, 1), to: SDCallback.self),
      readDMALinkedListBufferComplete: unsafeBitCast(CSD_Callback(4, 1), to: SDCallback.self),
      writeDMALinkedListBufferComplete: unsafeBitCast(CSD_Callback(5, 1), to: SDCallback.self),
      mspInitialize: unsafeBitCast(CSD_Callback(16, 1), to: SDCallback.self),
      mspDeinitialize: unsafeBitCast(CSD_Callback(17, 1), to: SDCallback.self),
      transceiver: unsafeBitCast(CSD_Callback(18, 1), to: SDTransceiverCallback.self))
  }
  var driver: SD<SDFixture, SDFixture, SDFixture, SDFixture> {
    .init(
      registers: self, handle: self, callbacks: self, memory: self, defaults: defaults,
      useRegisteredCallbacks: get(2, 0) & 1 != 0, useTransceiver: get(2, 0) & 2 != 0,
      useDirectionPolarity: get(2, 0) & 4 != 0)
  }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CSD_Activate(state)
    var cardInfo = SDCardInfo(
      cardType: get(10, 0), cardVersion: get(10, 1), cardClass: get(10, 2),
      relativeCardAddress: get(10, 3), blockCount: get(10, 4), blockSize: get(10, 5),
      logicalBlockCount: get(10, 6), logicalBlockSize: get(10, 7), cardSpeed: get(10, 8))
    var cardCSD = SDCardCSD(
      csdStruct: UInt8(truncatingIfNeeded: get(11, 0)),
      sysSpecVersion: UInt8(truncatingIfNeeded: get(11, 1)),
      reserved1: UInt8(truncatingIfNeeded: get(11, 2)), taac: UInt8(truncatingIfNeeded: get(11, 3)),
      nsac: UInt8(truncatingIfNeeded: get(11, 4)),
      maximumBusClockFrequency: UInt8(truncatingIfNeeded: get(11, 5)),
      commandClasses: UInt16(truncatingIfNeeded: get(11, 6)),
      rdBlockLen: UInt8(truncatingIfNeeded: get(11, 7)),
      partBlockRead: UInt8(truncatingIfNeeded: get(11, 8)),
      wrBlockMisalign: UInt8(truncatingIfNeeded: get(11, 9)),
      rdBlockMisalign: UInt8(truncatingIfNeeded: get(11, 10)),
      dsrImpl: UInt8(truncatingIfNeeded: get(11, 11)),
      reserved2: UInt8(truncatingIfNeeded: get(11, 12)), deviceSize: get(11, 13),
      maxRdCurrentVDDMin: UInt8(truncatingIfNeeded: get(11, 14)),
      maxRdCurrentVDDMax: UInt8(truncatingIfNeeded: get(11, 15)),
      maxWrCurrentVDDMin: UInt8(truncatingIfNeeded: get(11, 16)),
      maxWrCurrentVDDMax: UInt8(truncatingIfNeeded: get(11, 17)),
      deviceSizeMul: UInt8(truncatingIfNeeded: get(11, 18)),
      eraseGrSize: UInt8(truncatingIfNeeded: get(11, 19)),
      eraseGrMul: UInt8(truncatingIfNeeded: get(11, 20)),
      wrProtectGrSize: UInt8(truncatingIfNeeded: get(11, 21)),
      wrProtectGrEnable: UInt8(truncatingIfNeeded: get(11, 22)),
      manDeflECC: UInt8(truncatingIfNeeded: get(11, 23)),
      wrSpeedFact: UInt8(truncatingIfNeeded: get(11, 24)),
      maxWrBlockLen: UInt8(truncatingIfNeeded: get(11, 25)),
      writeBlockPaPartial: UInt8(truncatingIfNeeded: get(11, 26)),
      reserved3: UInt8(truncatingIfNeeded: get(11, 27)),
      contentProtectAppli: UInt8(truncatingIfNeeded: get(11, 28)),
      fileFormatGroup: UInt8(truncatingIfNeeded: get(11, 29)),
      copyFlag: UInt8(truncatingIfNeeded: get(11, 30)),
      permWrProtect: UInt8(truncatingIfNeeded: get(11, 31)),
      tempWrProtect: UInt8(truncatingIfNeeded: get(11, 32)),
      fileFormat: UInt8(truncatingIfNeeded: get(11, 33)),
      ecc: UInt8(truncatingIfNeeded: get(11, 34)), csdCRC: UInt8(truncatingIfNeeded: get(11, 35)),
      reserved4: UInt8(truncatingIfNeeded: get(11, 36)))
    var cardCID = SDCardCID(
      manufacturerID: UInt8(truncatingIfNeeded: get(12, 0)),
      oemApplicationID: UInt16(truncatingIfNeeded: get(12, 1)), productName1: get(12, 2),
      productName2: UInt8(truncatingIfNeeded: get(12, 3)),
      productRevision: UInt8(truncatingIfNeeded: get(12, 4)), productSerialNumber: get(12, 5),
      reserved1: UInt8(truncatingIfNeeded: get(12, 6)),
      manufacturingDate: UInt16(truncatingIfNeeded: get(12, 7)),
      cidCRC: UInt8(truncatingIfNeeded: get(12, 8)),
      reserved2: UInt8(truncatingIfNeeded: get(12, 9)))
    var cardStatus = SDCardStatus(
      dataBusWidth: UInt8(truncatingIfNeeded: get(13, 0)),
      securedMode: UInt8(truncatingIfNeeded: get(13, 1)),
      cardType: UInt16(truncatingIfNeeded: get(13, 2)), protectedAreaSize: get(13, 3),
      speedClass: UInt8(truncatingIfNeeded: get(13, 4)),
      performanceMove: UInt8(truncatingIfNeeded: get(13, 5)),
      allocationUnitSize: UInt8(truncatingIfNeeded: get(13, 6)),
      eraseSize: UInt16(truncatingIfNeeded: get(13, 7)),
      eraseTimeout: UInt8(truncatingIfNeeded: get(13, 8)),
      eraseOffset: UInt8(truncatingIfNeeded: get(13, 9)),
      uhsSpeedGrade: UInt8(truncatingIfNeeded: get(13, 10)),
      uhsAllocationUnitSize: UInt8(truncatingIfNeeded: get(13, 11)),
      videoSpeedClass: UInt8(truncatingIfNeeded: get(13, 12)))
    defer {
      set(10, 0, UInt32(cardInfo.cardType))
      set(10, 1, UInt32(cardInfo.cardVersion))
      set(10, 2, UInt32(cardInfo.cardClass))
      set(10, 3, UInt32(cardInfo.relativeCardAddress))
      set(10, 4, UInt32(cardInfo.blockCount))
      set(10, 5, UInt32(cardInfo.blockSize))
      set(10, 6, UInt32(cardInfo.logicalBlockCount))
      set(10, 7, UInt32(cardInfo.logicalBlockSize))
      set(10, 8, UInt32(cardInfo.cardSpeed))
      set(11, 0, UInt32(cardCSD.csdStruct))
      set(11, 1, UInt32(cardCSD.sysSpecVersion))
      set(11, 2, UInt32(cardCSD.reserved1))
      set(11, 3, UInt32(cardCSD.taac))
      set(11, 4, UInt32(cardCSD.nsac))
      set(11, 5, UInt32(cardCSD.maximumBusClockFrequency))
      set(11, 6, UInt32(cardCSD.commandClasses))
      set(11, 7, UInt32(cardCSD.rdBlockLen))
      set(11, 8, UInt32(cardCSD.partBlockRead))
      set(11, 9, UInt32(cardCSD.wrBlockMisalign))
      set(11, 10, UInt32(cardCSD.rdBlockMisalign))
      set(11, 11, UInt32(cardCSD.dsrImpl))
      set(11, 12, UInt32(cardCSD.reserved2))
      set(11, 13, UInt32(cardCSD.deviceSize))
      set(11, 14, UInt32(cardCSD.maxRdCurrentVDDMin))
      set(11, 15, UInt32(cardCSD.maxRdCurrentVDDMax))
      set(11, 16, UInt32(cardCSD.maxWrCurrentVDDMin))
      set(11, 17, UInt32(cardCSD.maxWrCurrentVDDMax))
      set(11, 18, UInt32(cardCSD.deviceSizeMul))
      set(11, 19, UInt32(cardCSD.eraseGrSize))
      set(11, 20, UInt32(cardCSD.eraseGrMul))
      set(11, 21, UInt32(cardCSD.wrProtectGrSize))
      set(11, 22, UInt32(cardCSD.wrProtectGrEnable))
      set(11, 23, UInt32(cardCSD.manDeflECC))
      set(11, 24, UInt32(cardCSD.wrSpeedFact))
      set(11, 25, UInt32(cardCSD.maxWrBlockLen))
      set(11, 26, UInt32(cardCSD.writeBlockPaPartial))
      set(11, 27, UInt32(cardCSD.reserved3))
      set(11, 28, UInt32(cardCSD.contentProtectAppli))
      set(11, 29, UInt32(cardCSD.fileFormatGroup))
      set(11, 30, UInt32(cardCSD.copyFlag))
      set(11, 31, UInt32(cardCSD.permWrProtect))
      set(11, 32, UInt32(cardCSD.tempWrProtect))
      set(11, 33, UInt32(cardCSD.fileFormat))
      set(11, 34, UInt32(cardCSD.ecc))
      set(11, 35, UInt32(cardCSD.csdCRC))
      set(11, 36, UInt32(cardCSD.reserved4))
      set(12, 0, UInt32(cardCID.manufacturerID))
      set(12, 1, UInt32(cardCID.oemApplicationID))
      set(12, 2, UInt32(cardCID.productName1))
      set(12, 3, UInt32(cardCID.productName2))
      set(12, 4, UInt32(cardCID.productRevision))
      set(12, 5, UInt32(cardCID.productSerialNumber))
      set(12, 6, UInt32(cardCID.reserved1))
      set(12, 7, UInt32(cardCID.manufacturingDate))
      set(12, 8, UInt32(cardCID.cidCRC))
      set(12, 9, UInt32(cardCID.reserved2))
      set(13, 0, UInt32(cardStatus.dataBusWidth))
      set(13, 1, UInt32(cardStatus.securedMode))
      set(13, 2, UInt32(cardStatus.cardType))
      set(13, 3, UInt32(cardStatus.protectedAreaSize))
      set(13, 4, UInt32(cardStatus.speedClass))
      set(13, 5, UInt32(cardStatus.performanceMove))
      set(13, 6, UInt32(cardStatus.allocationUnitSize))
      set(13, 7, UInt32(cardStatus.eraseSize))
      set(13, 8, UInt32(cardStatus.eraseTimeout))
      set(13, 9, UInt32(cardStatus.eraseOffset))
      set(13, 10, UInt32(cardStatus.uhsSpeedGrade))
      set(13, 11, UInt32(cardStatus.uhsAllocationUnitSize))
      set(13, 12, UInt32(cardStatus.videoSpeedClass))
    }
    let d = driver
    switch operation {
    case 0:
      return d.initialize(
        getTick: { CSD_TickFor(self.state) }, getSystemCoreClock: { CSD_ClockFor(self.state) },
        getPeripheralClockFrequency: { CSD_FrequencyFor(self.state, $0) },
        delay: { CSD_DelayFor(self.state, $0) }
      ).rawValue
    case 1:
      return d.initializeCard(
        getTick: { CSD_TickFor(self.state) }, getSystemCoreClock: { CSD_ClockFor(self.state) },
        getPeripheralClockFrequency: { CSD_FrequencyFor(self.state, $0) },
        delay: { CSD_DelayFor(self.state, $0) }
      ).rawValue
    case 2: return d.deinitialize().rawValue
    case 3:
      return d.readBlocks(
        get(2, 9) != 0 ? nil : buffer(1), a, b, c, getTick: { CSD_TickFor(self.state) },
        getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 4:
      return d.writeBlocks(
        get(2, 9) != 0 ? nil : UnsafePointer(buffer(0)), a, b, c,
        getTick: { CSD_TickFor(self.state) }, getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 5:
      return d.readBlocksInterrupt(
        get(2, 9) != 0 ? nil : buffer(1), a, b, getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 6:
      return d.writeBlocksInterrupt(
        get(2, 9) != 0 ? nil : UnsafePointer(buffer(0)), a, b,
        getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 7:
      return d.readBlocksDMA(
        get(2, 9) != 0 ? nil : buffer(1), a, b, getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 8:
      return d.writeBlocksDMA(
        get(2, 9) != 0 ? nil : UnsafePointer(buffer(0)), a, b,
        getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 9: return d.erase(a, b, getSystemCoreClock: { CSD_ClockFor(self.state) }).rawValue
    case 10:
      d.interruptHandler(getSystemCoreClock: { CSD_ClockFor(self.state) })
      return 0
    case 11: return d.getState()
    case 12: return d.getError()
    case 13:
      return d.registerCallback(
        a, b == 0 ? nil : unsafeBitCast(CSD_Callback(a, b), to: SDCallback.self)
      ).rawValue
    case 14: return d.unregisterCallback(a).rawValue
    case 15:
      return d.registerTransceiverCallback(
        b == 0 ? nil : unsafeBitCast(CSD_Callback(18, b), to: SDTransceiverCallback.self)
      ).rawValue
    case 16: return d.unregisterTransceiverCallback().rawValue
    case 17:
      return withUnsafeMutablePointer(to: &cardCID) { pointer in
        let cardCIDPointer = get(2, 10) != 0 ? nil : pointer
        return d.getCardCID(cardCIDPointer).rawValue
      }
    case 18:
      return withUnsafeMutablePointer(to: &cardCSD) { pointer in
        let cardCSDPointer = get(2, 10) != 0 ? nil : pointer
        return d.getCardCSD(cardCSDPointer).rawValue
      }
    case 19:
      return withUnsafeMutablePointer(to: &cardStatus) { pointer in
        let cardStatusPointer = get(2, 10) != 0 ? nil : pointer
        return d.getCardStatus(
          cardStatusPointer, getTick: { CSD_TickFor(self.state) },
          getSystemCoreClock: { CSD_ClockFor(self.state) }
        ).rawValue
      }
    case 20:
      return withUnsafeMutablePointer(to: &cardInfo) { pointer in
        let cardInfoPointer = get(2, 10) != 0 ? nil : pointer
        return d.getCardInfo(cardInfoPointer).rawValue
      }
    case 21:
      return d.configureWideBus(
        a, getTick: { CSD_TickFor(self.state) }, getSystemCoreClock: { CSD_ClockFor(self.state) },
        getPeripheralClockFrequency: { CSD_FrequencyFor(self.state, $0) }
      ).rawValue
    case 22:
      return d.configureSpeedBus(
        a, getTick: { CSD_TickFor(self.state) }, getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 23: return d.getCardState(getSystemCoreClock: { CSD_ClockFor(self.state) })
    case 24:
      return d.abort(
        getTick: { CSD_TickFor(self.state) }, getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 25: return d.abortInterrupt(getSystemCoreClock: { CSD_ClockFor(self.state) }).rawValue
    case 39:
      return d.buildDMANode(
        a,
        configuration: get(2, 11) != 0
          ? nil : .init(bufferAddress: get(16, 0), bufferSize: get(16, 1))
      ).rawValue
    case 40: return d.insertDMANode(a, previousNode: b, node: c).rawValue
    case 41: return d.removeDMANode(a, node: b).rawValue
    case 42: return d.lockDMANode(a).rawValue
    case 43: return d.unlockDMANode(a).rawValue
    case 44: return d.enableDMACircularMode(a).rawValue
    case 45: return d.disableDMACircularMode(a).rawValue
    case 46:
      return d.readBlocksLinkedList(
        get(2, 12) != 0 ? 0 : 0x2403_0000, a, b, getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    case 47:
      return d.writeBlocksLinkedList(
        get(2, 12) != 0 ? 0 : 0x2403_0000, a, b, getSystemCoreClock: { CSD_ClockFor(self.state) }
      ).rawValue
    default: preconditionFailure("Private helper is exercised through its public entry point")
    }
  }
}
func checkSD(
  _ setup: (SDFixture) -> Void, operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0,
  _ c: UInt32 = 0, variant: UInt32 = 1, file: StaticString = #filePath, line: UInt = #line
) {
  let reference = SDFixture(variant: variant)
  let swift = SDFixture(variant: variant)
  setup(reference)
  setup(swift)
  let expected = CSD_Run(reference.state, operation, a, b, c)
  XCTAssertEqual(
    swift.run(operation, a, b, c), expected, "operation \(operation), variant \(variant)",
    file: file, line: line)
  let difference = CSD_Compare(reference.state, swift.state)
  if difference != 0 {
    let g = (difference >> 16) - 1
    let i = difference & 0xFFFF
    XCTFail(
      "operation \(operation), variant \(variant), difference \(String(difference,radix:16)), C \(g<17 ? reference.get(g,i):0), Swift \(g<17 ? swift.get(g,i):0)",
      file: file, line: line)
  }
}
