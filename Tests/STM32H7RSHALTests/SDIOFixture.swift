import CSDIOReference
import STM32H7RSHAL
import XCTest

final class SDIOFixture: SDMMCRegisterIO, SDIOHandleIO, SDIOCallbackIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(variant: UInt32 = 1) {
    allocation = .allocate(byteCount: CSDIO_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CSDIO_Reset(state, variant)
  }
  deinit { allocation.deallocate() }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CSDIO_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CSDIO_Set(state, group, index, value)
  }
  var instance: SDMMCInstance { SDMMCInstance(rawValue: get(2, 1))! }
  var context: UnsafeMutableRawPointer? { allocation }
  func buffer(_ index: UInt32) -> UnsafeMutablePointer<UInt8> { CSDIO_Buffer(state, index)! }
  func read(_ register: SDMMCRegister) -> UInt32 { CSDIO_Read(state, register.rawValue) }
  func write(_ register: SDMMCRegister, value: UInt32) {
    CSDIO_Write(state, register.rawValue, value)
  }
  func address(of register: SDMMCRegister) -> UInt32 {
    (instance == .sdmmc1 ? 0x5200_7000 : 0x4800_2400) &+ register.rawValue
  }
  func read(_ word: SDIOConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: SDIOConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: SDIOHandleWord) -> UInt32 {
    CSDIO_GetHandleRaw(state, 6 + UInt32(word.rawValue))
  }
  func write(_ word: SDIOHandleWord, value: UInt32) { set(1, 6 + UInt32(word.rawValue), value) }
  func read(_ word: SDIOHandleHalfWord) -> UInt16 {
    UInt16(truncatingIfNeeded: get(1, 15 + UInt32(word.rawValue)))
  }
  func write(_ word: SDIOHandleHalfWord, value: UInt16) {
    set(1, 15 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: SDIOHandleByte) -> UInt8 {
    UInt8(truncatingIfNeeded: get(1, 16 + UInt32(word.rawValue)))
  }
  func write(_ word: SDIOHandleByte, value: UInt8) {
    set(1, 16 + UInt32(word.rawValue), UInt32(value))
  }
  func readTransmitBuffer() -> UnsafeMutablePointer<UInt8>? {
    .init(bitPattern: CSDIO_GetPointer(state, 0))
  }
  func writeTransmitBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    CSDIO_SetPointer(state, 0, UInt(bitPattern: value))
  }
  func readReceiveBuffer() -> UnsafeMutablePointer<UInt8>? {
    .init(bitPattern: CSDIO_GetPointer(state, 1))
  }
  func writeReceiveBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    CSDIO_SetPointer(state, 1, UInt(bitPattern: value))
  }
  func read(_ id: SDIOCallbackID) -> SDIOCallback? {
    let bits = CSDIO_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDIOCallback.self)
  }
  func write(_ id: SDIOCallbackID, value: SDIOCallback?) {
    CSDIO_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readTransceiver() -> SDIOTransceiverCallback? {
    let bits = CSDIO_GetCallback(state, 18)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDIOTransceiverCallback.self)
  }
  func writeTransceiver(_ value: SDIOTransceiverCallback?) {
    CSDIO_SetCallback(state, 18, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readIdentify() -> SDIOIdentifyOperation {
    let bits = CSDIO_GetCallback(state, 19)
    if bits == 0 { return .none }
    if bits == CSDIO_DefaultIdentify(get(2, 0)) { return .initializeCard }
    return .custom(unsafeBitCast(bits, to: SDIOIdentifyCallback.self))
  }
  func writeIdentify(_ value: SDIOIdentifyOperation) {
    let bits: UInt
    switch value {
    case .none: bits = 0
    case .initializeCard: bits = CSDIO_DefaultIdentify(get(2, 0))
    case .custom(let callback): bits = unsafeBitCast(callback, to: UInt.self)
    }
    CSDIO_SetCallback(state, 19, bits)
  }
  func readIOFunction(_ index: UInt32) -> SDIOFunctionCallback? {
    let bits = CSDIO_GetCallback(state, 20 + index)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SDIOFunctionCallback.self)
  }
  func writeIOFunction(_ index: UInt32, value: SDIOFunctionCallback?) {
    CSDIO_SetCallback(state, 20 + index, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: SDIOCallbackDefaults {
    .init(
      transmitComplete: unsafeBitCast(CSDIO_Callback(0, 1), to: SDIOCallback.self),
      receiveComplete: unsafeBitCast(CSDIO_Callback(1, 1), to: SDIOCallback.self),
      error: unsafeBitCast(CSDIO_Callback(2, 1), to: SDIOCallback.self),
      mspInitialize: unsafeBitCast(CSDIO_Callback(16, 1), to: SDIOCallback.self),
      mspDeinitialize: unsafeBitCast(CSDIO_Callback(17, 1), to: SDIOCallback.self),
      transceiver: unsafeBitCast(CSDIO_Callback(18, 1), to: SDIOTransceiverCallback.self))
  }
  var driver: SDIO<SDIOFixture, SDIOFixture, SDIOFixture> {
    .init(
      registers: self, handle: self, callbacks: self, defaults: defaults,
      useRegisteredCallbacks: get(2, 0) & 1 != 0, useTransceiver: get(2, 0) & 2 != 0)
  }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CSDIO_Activate(state)
    return withUnsafeTemporaryAllocation(of: SDIOFunctionBasicRegister.self, capacity: 7) {
      functions in
      functions.initialize(repeating: .init())
      var commonControl = SDIOCommonControlRegister(
        sdioRevision: UInt8(truncatingIfNeeded: get(10, 0)),
        cccrRevision: UInt8(truncatingIfNeeded: get(10, 1)),
        sdSpecificationRevision: UInt8(truncatingIfNeeded: get(10, 2)),
        busWidth8Bit: UInt8(truncatingIfNeeded: get(10, 3)), cardCapability: get(10, 4),
        commonCISPointer: get(10, 5))
      for j in 0..<7 {
        functions[j] = SDIOFunctionBasicRegister(
          flags: UInt8(truncatingIfNeeded: get(11, UInt32(j * 5) + 0)),
          ioStdFunctionCode: UInt8(truncatingIfNeeded: get(11, UInt32(j * 5) + 1)),
          ioExtFunctionCode: UInt8(truncatingIfNeeded: get(11, UInt32(j * 5) + 2)),
          ioPointerToCIS: get(11, UInt32(j * 5) + 3), ioPointerToCSA: get(11, UInt32(j * 5) + 4))
      }
      var directCommand = SDIODirectCommand(
        registerAddress: get(12, 0), readAfterWrite: UInt8(truncatingIfNeeded: get(12, 1)),
        ioFunctionNumber: UInt8(truncatingIfNeeded: get(12, 2)))
      var extendedCommand = SDIOExtendedCommand(
        registerAddress: get(13, 0), operationCode: get(13, 1), blockMode: get(13, 2),
        ioFunctionNumber: get(13, 3))
      defer {
        set(10, 0, UInt32(commonControl.sdioRevision))
        set(10, 1, UInt32(commonControl.cccrRevision))
        set(10, 2, UInt32(commonControl.sdSpecificationRevision))
        set(10, 3, UInt32(commonControl.busWidth8Bit))
        set(10, 4, UInt32(commonControl.cardCapability))
        set(10, 5, UInt32(commonControl.commonCISPointer))
        for j in 0..<7 {
          set(11, UInt32(j * 5) + 0, UInt32(functions[j].flags))
          set(11, UInt32(j * 5) + 1, UInt32(functions[j].ioStdFunctionCode))
          set(11, UInt32(j * 5) + 2, UInt32(functions[j].ioExtFunctionCode))
          set(11, UInt32(j * 5) + 3, UInt32(functions[j].ioPointerToCIS))
          set(11, UInt32(j * 5) + 4, UInt32(functions[j].ioPointerToCSA))
        }
        set(12, 0, UInt32(directCommand.registerAddress))
        set(12, 1, UInt32(directCommand.readAfterWrite))
        set(12, 2, UInt32(directCommand.ioFunctionNumber))
        set(13, 0, UInt32(extendedCommand.registerAddress))
        set(13, 1, UInt32(extendedCommand.operationCode))
        set(13, 2, UInt32(extendedCommand.blockMode))
        set(13, 3, UInt32(extendedCommand.ioFunctionNumber))
      }
      let d = driver
      switch operation {
      case 0:
        return d.initialize(
          getSystemCoreClock: { CSDIO_ClockFor(self.state) },
          getPeripheralClockFrequency: { CSDIO_FrequencyFor(self.state, $0) },
          delay: { CSDIO_DelayFor(self.state, $0) }
        ).rawValue
      case 1: return d.deinitialize().rawValue
      case 2:
        return d.setDataBusWidth(a, getSystemCoreClock: { CSDIO_ClockFor(self.state) }).rawValue
      case 3:
        return d.configureFrequency(
          a, getPeripheralClockFrequency: { CSDIO_FrequencyFor(self.state, $0) }
        ).rawValue
      case 4:
        return d.setBlockSize(
          UInt8(truncatingIfNeeded: a), UInt16(truncatingIfNeeded: b),
          getTick: { CSDIO_TickFor(self.state) }, getSystemCoreClock: { CSDIO_ClockFor(self.state) }
        ).rawValue
      case 5: return d.setSpeedMode(a, getSystemCoreClock: { CSDIO_ClockFor(self.state) }).rawValue
      case 6: return d.resetCard(getSystemCoreClock: { CSDIO_ClockFor(self.state) }).rawValue
      case 7:
        return withUnsafeMutablePointer(to: &commonControl) { pointer in
          let commonControlPointer = get(2, 10) != 0 ? nil : pointer
          return d.getCommonControlRegister(
            commonControlPointer, getSystemCoreClock: { CSDIO_ClockFor(self.state) }
          ).rawValue
        }
      case 8:
        return d.getFunctionBasicRegister(
          get(2, 10) != 0 ? nil : functions.baseAddress,
          getSystemCoreClock: { CSDIO_ClockFor(self.state) }
        ).rawValue
      case 9:
        return withUnsafeMutablePointer(to: &directCommand) { pointer in
          let directCommandPointer = get(2, 10) != 0 ? nil : pointer
          return d.readDirect(
            directCommandPointer, get(2, 9) != 0 ? nil : buffer(1),
            getSystemCoreClock: { CSDIO_ClockFor(self.state) }
          ).rawValue
        }
      case 10:
        return withUnsafeMutablePointer(to: &directCommand) { pointer in
          let directCommandPointer = get(2, 10) != 0 ? nil : pointer
          return d.writeDirect(
            directCommandPointer, UInt8(truncatingIfNeeded: a),
            getSystemCoreClock: { CSDIO_ClockFor(self.state) }
          ).rawValue
        }
      case 11:
        return withUnsafeMutablePointer(to: &extendedCommand) { pointer in
          let extendedCommandPointer = get(2, 10) != 0 ? nil : pointer
          return d.readExtended(
            extendedCommandPointer, get(2, 9) != 0 ? nil : buffer(1), a, b,
            getTick: { CSDIO_TickFor(self.state) },
            getSystemCoreClock: { CSDIO_ClockFor(self.state) }
          ).rawValue
        }
      case 12:
        return withUnsafeMutablePointer(to: &extendedCommand) { pointer in
          let extendedCommandPointer = get(2, 10) != 0 ? nil : pointer
          return d.writeExtended(
            extendedCommandPointer, get(2, 9) != 0 ? nil : buffer(0), a, b,
            getTick: { CSDIO_TickFor(self.state) },
            getSystemCoreClock: { CSDIO_ClockFor(self.state) }
          ).rawValue
        }
      case 13:
        return withUnsafeMutablePointer(to: &extendedCommand) { pointer in
          let extendedCommandPointer = get(2, 10) != 0 ? nil : pointer
          return d.readExtendedDMA(
            extendedCommandPointer, get(2, 9) != 0 ? nil : buffer(1), a,
            getSystemCoreClock: { CSDIO_ClockFor(self.state) }
          ).rawValue
        }
      case 14:
        return withUnsafeMutablePointer(to: &extendedCommand) { pointer in
          let extendedCommandPointer = get(2, 10) != 0 ? nil : pointer
          return d.writeExtendedDMA(
            extendedCommandPointer, get(2, 9) != 0 ? nil : buffer(0), a,
            getSystemCoreClock: { CSDIO_ClockFor(self.state) }
          ).rawValue
        }
      case 15:
        d.interruptHandler(getSystemCoreClock: { CSDIO_ClockFor(self.state) })
        return 0
      case 16:
        return d.registerCallback(
          a, b == 0 ? nil : unsafeBitCast(CSDIO_Callback(a, b), to: SDIOCallback.self)
        ).rawValue
      case 17: return d.unregisterCallback(a).rawValue
      case 18:
        return d.registerTransceiverCallback(
          a == 0 ? nil : unsafeBitCast(CSDIO_Callback(18, a), to: SDIOTransceiverCallback.self)
        ).rawValue
      case 19: return d.unregisterTransceiverCallback().rawValue
      case 20:
        return d.registerIdentifyCardCallback(
          a == 0 ? nil : unsafeBitCast(CSDIO_Callback(19, a), to: SDIOIdentifyCallback.self)
        ).rawValue
      case 21: return d.getState()
      case 22: return d.getError()
      case 23:
        return d.enableIOFunctionInterrupt(a, getSystemCoreClock: { CSDIO_ClockFor(self.state) })
          .rawValue
      case 24:
        return d.disableIOFunctionInterrupt(a, getSystemCoreClock: { CSDIO_ClockFor(self.state) })
          .rawValue
      case 25:
        return d.enableIOFunction(a, getSystemCoreClock: { CSDIO_ClockFor(self.state) }).rawValue
      case 26:
        return d.disableIOFunction(a, getSystemCoreClock: { CSDIO_ClockFor(self.state) }).rawValue
      case 27:
        return d.selectIOFunction(a, getSystemCoreClock: { CSDIO_ClockFor(self.state) }).rawValue
      case 28:
        return d.abortIOFunction(a, getSystemCoreClock: { CSDIO_ClockFor(self.state) }).rawValue
      case 29:
        return d.enableIOAsynchronousInterrupt(getSystemCoreClock: { CSDIO_ClockFor(self.state) })
          .rawValue
      case 30:
        return d.disableIOAsynchronousInterrupt(getSystemCoreClock: { CSDIO_ClockFor(self.state) })
          .rawValue
      case 31:
        return d.registerIOFunctionCallback(
          a, b == 0 ? nil : unsafeBitCast(CSDIO_Callback(20, b), to: SDIOFunctionCallback.self)
        ).rawValue
      default: preconditionFailure("Private helper is exercised through its public entry point")
      }
    }
  }
}
func checkSDIO(
  _ setup: (SDIOFixture) -> Void, operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0,
  _ c: UInt32 = 0, variant: UInt32 = 1, file: StaticString = #filePath, line: UInt = #line
) {
  let reference = SDIOFixture(variant: variant)
  let swift = SDIOFixture(variant: variant)
  setup(reference)
  setup(swift)
  let expected = CSDIO_Run(reference.state, operation, a, b, c)
  XCTAssertEqual(
    swift.run(operation, a, b, c), expected, "operation \(operation), variant \(variant)",
    file: file, line: line)
  let difference = CSDIO_Compare(reference.state, swift.state)
  if difference != 0 {
    let g = (difference >> 16) - 1
    let i = difference & 0xFFFF
    XCTFail(
      "operation \(operation), variant \(variant), difference \(String(difference,radix:16)), C \(g<18 ? reference.get(g,i):0), Swift \(g<18 ? swift.get(g,i):0)",
      file: file, line: line)
  }
}
