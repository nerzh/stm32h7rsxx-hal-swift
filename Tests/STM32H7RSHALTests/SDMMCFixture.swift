import CSDMMCReference
import STM32H7RSHAL
import XCTest

final class SDMMCFixture: SDMMCRegisterIO, DMAMemoryIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  let output: UnsafeMutablePointer<UInt32>
  init() {
    allocation = .allocate(byteCount: CSDMMC_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CSDMMC_Reset(state)
    output = .allocate(capacity: 1)
    output.initialize(to: 0)
  }
  deinit {
    output.deinitialize(count: 1)
    output.deallocate()
    allocation.deallocate()
  }
  var instance: SDMMCInstance { .sdmmc1 }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CSDMMC_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CSDMMC_Set(state, group, index, value)
  }
  func read(_ register: SDMMCRegister) -> UInt32 { CSDMMC_Read(state, register.rawValue) }
  func write(_ register: SDMMCRegister, value: UInt32) {
    CSDMMC_Write(state, register.rawValue, value)
  }
  func address(of register: SDMMCRegister) -> UInt32 { 0x5200_7000 &+ register.rawValue }
  func read32(at address: UInt32) -> UInt32 { CSDMMC_ReadMemory(state, address) }
  func write32(at address: UInt32, value: UInt32) { CSDMMC_WriteMemory(state, address, value) }
  var driver: SDMMC<SDMMCFixture> { .init(registers: self) }
  var list: SDMMCDMALinkedList<SDMMCFixture> { .init(memory: self) }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    output.pointee = get(8, 0)
    defer { set(8, 0, output.pointee) }
    let configuration = SDMMCConfiguration(
      clockEdge: get(2, 0), clockPowerSave: get(2, 1), busWide: get(2, 2),
      hardwareFlowControl: get(2, 3), clockDivider: get(2, 4), transceiverPresent: get(2, 5))
    var command = SDMMCCommand(
      argument: get(3, 0), commandIndex: get(3, 1), response: get(3, 2),
      waitForInterrupt: get(3, 3), cpsm: get(3, 4))
    var data = SDMMCDataConfiguration(
      dataTimeout: get(4, 0), dataLength: get(4, 1), dataBlockSize: get(4, 2),
      transferDirection: get(4, 3), transferMode: get(4, 4), dpsm: get(4, 5))
    let nodeConfiguration = SDMMCDMANodeConfiguration(
      bufferAddress: get(5, 0), bufferSize: get(5, 1))
    let d = driver
    switch operation {
    case 0: return d.initialize(configuration).rawValue
    case 1: return d.readFIFO()
    case 2: return d.writeFIFO(output).rawValue
    case 3: return d.powerOn().rawValue
    case 4: return d.powerCycle().rawValue
    case 5: return d.powerOff().rawValue
    case 6: return d.getPowerState()
    case 7: return d.sendCommand(&command).rawValue
    case 8: return UInt32(d.getCommandResponse())
    case 9: return d.getResponse(a)
    case 10: return d.configureData(&data).rawValue
    case 11: return d.getDataCounter()
    case 12: return d.getFIFOCount()
    case 13: return d.setReadWaitMode(a).rawValue
    case 14: return d.commandBlockLength(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 15: return d.commandBlockCount(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 16: return d.commandReadSingleBlock(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 17:
      return d.commandReadMultipleBlocks(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 18:
      return d.commandWriteSingleBlock(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 19:
      return d.commandWriteMultipleBlocks(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 20:
      return d.commandSDEraseStartAddress(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 21:
      return d.commandSDEraseEndAddress(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 22:
      return d.commandEraseStartAddress(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 23: return d.commandEraseEndAddress(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 24: return d.commandErase(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 25: return d.commandStopTransfer(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 26: return d.commandSelectDeselect(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 27: return d.commandGoIdle(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 28: return d.commandOperatingCondition(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 29: return d.commandApplication(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 30:
      return d.commandApplicationOperatingCondition(
        a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 31: return d.commandBusWidth(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 32: return d.commandSendSCR(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 33: return d.commandSendCID(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 34: return d.commandSendCSD(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 35:
      return d.commandSetRelativeAddress(
        UnsafeMutableRawPointer(output).assumingMemoryBound(to: UInt16.self),
        getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 36:
      return d.commandSetRelativeAddressMMC(
        UInt16(truncatingIfNeeded: a), getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 37: return d.commandSleepMMC(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 38: return d.commandSendStatus(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 39: return d.commandStatusRegister(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 40:
      return d.commandOperationCondition(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 41: return d.commandSwitch(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 42: return d.commandVoltageSwitch(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 43: return d.commandSendExtendedCSD(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 44:
      return d.commandSDIOReadWriteDirect(
        a,
        get(1, 15) != 0 ? nil : UnsafeMutableRawPointer(output).assumingMemoryBound(to: UInt8.self),
        getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 45:
      return d.commandSDIOReadWriteExtended(a, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 46:
      return d.commandSendOperationCondition(
        a, output, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 47:
      return d.getCommandResponse1(
        UInt8(truncatingIfNeeded: a), b, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 48: return d.getCommandResponse2(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 49: return d.getCommandResponse3(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 50:
      return d.getCommandResponse4(output, getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 51:
      return d.getCommandResponse5(
        UInt8(truncatingIfNeeded: a),
        get(1, 15) != 0 ? nil : UnsafeMutableRawPointer(output).assumingMemoryBound(to: UInt8.self),
        getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 52:
      return d.getCommandResponse6(
        UInt8(truncatingIfNeeded: a),
        UnsafeMutableRawPointer(output).assumingMemoryBound(to: UInt16.self),
        getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 53: return d.getCommandResponse7(getSystemCoreClock: { CSDMMC_ClockFor(self.state) })
    case 54: return list.buildNode(a, configuration: get(1, 15) != 0 ? nil : nodeConfiguration)
    case 55: return list.insertNode(a, previousNode: b, node: c)
    case 56: return list.removeNode(a, node: b)
    case 57: return list.lockNode(a)
    case 58: return list.unlockNode(a)
    case 59: return list.enableCircularMode(a)
    case 60: return list.disableCircularMode(a)
    default: preconditionFailure("Private helper is exercised through commandGoIdle")
    }
  }
}
func checkSDMMC(
  _ setup: (SDMMCFixture) -> Void, operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0,
  _ c: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line
) {
  let reference = SDMMCFixture()
  let swift = SDMMCFixture()
  setup(reference)
  setup(swift)
  let expected = CSDMMC_Run(reference.state, operation, a, b, c)
  XCTAssertEqual(
    swift.run(operation, a, b, c), expected, "operation \(operation)", file: file, line: line)
  let difference = CSDMMC_Compare(reference.state, swift.state)
  if difference != 0 {
    let g = (difference >> 16) - 1
    let i = difference & 0xFFFF
    XCTFail(
      "operation \(operation), group \(g), index \(i), C \(reference.get(g,i)), Swift \(swift.get(g,i))",
      file: file, line: line)
  }
}
