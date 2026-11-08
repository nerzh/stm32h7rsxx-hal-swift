import CI3CReference
import STM32H7RSHAL
import XCTest

final class I3CFixture: I3CRegisterIO, I3CHandleIO, I3CCallbackIO, I3CDMAIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  let controllerBus: UnsafeMutablePointer<I3CControllerBusConfiguration>
  let targetBus: UnsafeMutablePointer<I3CTargetBusConfiguration>
  let fifo: UnsafeMutablePointer<I3CFIFOConfiguration>
  let controller: UnsafeMutablePointer<I3CControllerConfiguration>
  let target: UnsafeMutablePointer<I3CTargetConfiguration>
  let devices: UnsafeMutablePointer<I3CDeviceConfiguration>
  let cccInfo: UnsafeMutablePointer<I3CCCCInfo>
  let payload: UnsafeMutablePointer<I3CENTDAAPayload>
  let ccc: UnsafeMutablePointer<I3CCCCDescriptor>
  let privateDescriptors: UnsafeMutablePointer<I3CPrivateDescriptor>
  let transfer: UnsafeMutablePointer<I3CTransfer>
  let outputPayload: UnsafeMutablePointer<UInt64>
  let outputReset: UnsafeMutablePointer<UInt32>
  let outputAddress: UnsafeMutablePointer<UInt8>
  init(callbacks: Bool = true) {
    allocation = .allocate(byteCount: CI3C_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CI3C_Reset(state, callbacks ? 1 : 0)
    controllerBus = .allocate(capacity: 1)
    controllerBus.initialize(repeating: .init(), count: 1)
    targetBus = .allocate(capacity: 1)
    targetBus.initialize(repeating: .init(), count: 1)
    fifo = .allocate(capacity: 1)
    fifo.initialize(repeating: .init(), count: 1)
    controller = .allocate(capacity: 1)
    controller.initialize(repeating: .init(), count: 1)
    target = .allocate(capacity: 1)
    target.initialize(repeating: .init(), count: 1)
    devices = .allocate(capacity: 4)
    devices.initialize(repeating: .init(), count: 4)
    cccInfo = .allocate(capacity: 1)
    cccInfo.initialize(repeating: .init(), count: 1)
    payload = .allocate(capacity: 1)
    payload.initialize(repeating: .init(), count: 1)
    ccc = .allocate(capacity: 8)
    ccc.initialize(repeating: .init(), count: 8)
    privateDescriptors = .allocate(capacity: 8)
    privateDescriptors.initialize(repeating: .init(), count: 8)
    transfer = .allocate(capacity: 1)
    transfer.initialize(repeating: .init(), count: 1)
    outputPayload = .allocate(capacity: 1)
    outputPayload.initialize(to: 0)
    outputReset = .allocate(capacity: 1)
    outputReset.initialize(to: 0)
    outputAddress = .allocate(capacity: 1)
    outputAddress.initialize(to: 0)
  }
  deinit {
    controllerBus.deinitialize(count: 1)
    controllerBus.deallocate()
    targetBus.deinitialize(count: 1)
    targetBus.deallocate()
    fifo.deinitialize(count: 1)
    fifo.deallocate()
    controller.deinitialize(count: 1)
    controller.deallocate()
    target.deinitialize(count: 1)
    target.deallocate()
    devices.deinitialize(count: 4)
    devices.deallocate()
    cccInfo.deinitialize(count: 1)
    cccInfo.deallocate()
    payload.deinitialize(count: 1)
    payload.deallocate()
    ccc.deinitialize(count: 8)
    ccc.deallocate()
    privateDescriptors.deinitialize(count: 8)
    privateDescriptors.deallocate()
    transfer.deinitialize(count: 1)
    transfer.deallocate()
    outputPayload.deinitialize(count: 1)
    outputPayload.deallocate()
    outputReset.deinitialize(count: 1)
    outputReset.deallocate()
    outputAddress.deinitialize(count: 1)
    outputAddress.deallocate()
    allocation.deallocate()
  }
  var context: UnsafeMutableRawPointer? { allocation }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CI3C_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CI3C_Set(state, group, index, value)
  }
  func control(_ index: UInt32) -> UInt32 { get(2, index) }
  func control(_ index: UInt32, _ value: UInt32) { set(2, index, value) }
  func buffer(_ index: UInt32) -> UnsafeMutablePointer<UInt8> { CI3C_Buffer(state, index)! }
  func normalize<T>(_ pointer: UnsafeMutablePointer<T>?) -> UInt32 {
    CI3C_Normalize(state, UInt(bitPattern: pointer))
  }
  func decode<T>(_ value: UInt32, _: T.Type) -> UnsafeMutablePointer<T>? {
    UnsafeMutablePointer<T>(bitPattern: CI3C_Decode(state, value))
  }
  func read(_ register: I3CRegister) -> UInt32 { CI3C_Read(state, register.rawValue) }
  func write(_ register: I3CRegister, value: UInt32) { CI3C_Write(state, register.rawValue, value) }
  func address(of register: I3CRegister) -> UInt32 { 0x4000_5400 &+ register.rawValue }
  func read(_ word: I3CConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: I3CConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: I3CHandleWord) -> UInt32 { get(1, 9 + UInt32(word.rawValue)) }
  func write(_ word: I3CHandleWord, value: UInt32) { set(1, 9 + UInt32(word.rawValue), value) }
  func readTransfer() -> UnsafeMutablePointer<I3CTransfer>? {
    CI3C_GetPointer(state, 0) == 0 ? nil : transfer
  }
  func writeTransfer(_ value: UnsafeMutablePointer<I3CTransfer>?) {
    precondition(value == nil || value == transfer)
    CI3C_SetPointer(state, 0, value == nil ? 0 : 1)
  }
  func readCCCDescriptors() -> UnsafePointer<I3CCCCDescriptor>? {
    CI3C_GetPointer(state, 1) == 0 ? nil : UnsafePointer(ccc)
  }
  func writeCCCDescriptors(_ value: UnsafePointer<I3CCCCDescriptor>?) {
    precondition(value == nil || value == UnsafePointer(ccc))
    CI3C_SetPointer(state, 1, value == nil ? 0 : 1)
  }
  func readPrivateDescriptors() -> UnsafePointer<I3CPrivateDescriptor>? {
    CI3C_GetPointer(state, 2) == 0 ? nil : UnsafePointer(privateDescriptors)
  }
  func writePrivateDescriptors(_ value: UnsafePointer<I3CPrivateDescriptor>?) {
    precondition(value == nil || value == UnsafePointer(privateDescriptors))
    CI3C_SetPointer(state, 2, value == nil ? 0 : 1)
  }
  func read(_ id: I3CCallbackID) -> I3CCallback? {
    let bits = CI3C_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I3CCallback.self)
  }
  func write(_ id: I3CCallbackID, value: I3CCallback?) {
    CI3C_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readTargetRequestDynamicAddress() -> I3CDynamicAddressCallback? {
    let bits = CI3C_GetCallback(state, 4)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I3CDynamicAddressCallback.self)
  }
  func writeTargetRequestDynamicAddress(_ value: I3CDynamicAddressCallback?) {
    CI3C_SetCallback(state, 4, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readTargetHotJoin() -> I3CHotJoinCallback? {
    let bits = CI3C_GetCallback(state, 7)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I3CHotJoinCallback.self)
  }
  func writeTargetHotJoin(_ value: I3CHotJoinCallback?) {
    CI3C_SetCallback(state, 7, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readNotify() -> I3CNotifyCallback? {
    let bits = CI3C_GetCallback(state, 8)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I3CNotifyCallback.self)
  }
  func writeNotify(_ value: I3CNotifyCallback?) {
    CI3C_SetCallback(state, 8, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: I3CCallbackDefaults {
    .init(
      controllerTransmitComplete: unsafeBitCast(CI3C_Callback(0, 1), to: I3CCallback.self),
      controllerReceiveComplete: unsafeBitCast(CI3C_Callback(1, 1), to: I3CCallback.self),
      controllerMultipleTransferComplete: unsafeBitCast(CI3C_Callback(2, 1), to: I3CCallback.self),
      controllerDynamicAddressComplete: unsafeBitCast(CI3C_Callback(3, 1), to: I3CCallback.self),
      targetRequestDynamicAddress: unsafeBitCast(
        CI3C_Callback(4, 1), to: I3CDynamicAddressCallback.self),
      targetTransmitComplete: unsafeBitCast(CI3C_Callback(5, 1), to: I3CCallback.self),
      targetReceiveComplete: unsafeBitCast(CI3C_Callback(6, 1), to: I3CCallback.self),
      targetHotJoin: unsafeBitCast(CI3C_Callback(7, 1), to: I3CHotJoinCallback.self),
      notify: unsafeBitCast(CI3C_Callback(8, 1), to: I3CNotifyCallback.self),
      error: unsafeBitCast(CI3C_Callback(9, 1), to: I3CCallback.self),
      abortComplete: unsafeBitCast(CI3C_Callback(10, 1), to: I3CCallback.self),
      mspInitialize: unsafeBitCast(CI3C_Callback(11, 1), to: I3CCallback.self),
      mspDeinitialize: unsafeBitCast(CI3C_Callback(12, 1), to: I3CCallback.self))
  }
  var driver: I3C<I3CFixture, I3CFixture, I3CFixture, I3CFixture> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: control(0) != 0)
  }
  func loadStructures() {
    for i in 0..<1 {
      controllerBus[i].sdaHoldTime = get(20, UInt32(i * 8 + 0))
      controllerBus[i].waitTime = get(20, UInt32(i * 8 + 1))
      controllerBus[i].sclppLowDuration = UInt8(truncatingIfNeeded: get(20, UInt32(i * 8 + 2)))
      controllerBus[i].sclI3CHighDuration = UInt8(truncatingIfNeeded: get(20, UInt32(i * 8 + 3)))
      controllerBus[i].sclodLowDuration = UInt8(truncatingIfNeeded: get(20, UInt32(i * 8 + 4)))
      controllerBus[i].sclI2CHighDuration = UInt8(truncatingIfNeeded: get(20, UInt32(i * 8 + 5)))
      controllerBus[i].busFreeDuration = UInt8(truncatingIfNeeded: get(20, UInt32(i * 8 + 6)))
      controllerBus[i].busIdleDuration = UInt8(truncatingIfNeeded: get(20, UInt32(i * 8 + 7)))
    }
    for i in 0..<1 {
      targetBus[i].busAvailableDuration = UInt8(truncatingIfNeeded: get(21, UInt32(i * 1 + 0)))
    }
    for i in 0..<1 {
      fifo[i].rxFifoThreshold = get(22, UInt32(i * 4 + 0))
      fifo[i].txFifoThreshold = get(22, UInt32(i * 4 + 1))
      fifo[i].controlFifo = get(22, UInt32(i * 4 + 2))
      fifo[i].statusFifo = get(22, UInt32(i * 4 + 3))
    }
    for i in 0..<1 {
      controller[i].dynamicAddr = UInt8(truncatingIfNeeded: get(23, UInt32(i * 8 + 0)))
      controller[i].stallTime = UInt8(truncatingIfNeeded: get(23, UInt32(i * 8 + 1)))
      controller[i].hotJoinAllowed = get(23, UInt32(i * 8 + 2))
      controller[i].ackStallState = get(23, UInt32(i * 8 + 3))
      controller[i].cccStallState = get(23, UInt32(i * 8 + 4))
      controller[i].txStallState = get(23, UInt32(i * 8 + 5))
      controller[i].rxStallState = get(23, UInt32(i * 8 + 6))
      controller[i].highKeeperSDA = get(23, UInt32(i * 8 + 7))
    }
    for i in 0..<1 {
      target[i].identifier = UInt8(truncatingIfNeeded: get(24, UInt32(i * 18 + 0)))
      target[i].mipiIdentifier = UInt8(truncatingIfNeeded: get(24, UInt32(i * 18 + 1)))
      target[i].ctrlRoleRequest = get(24, UInt32(i * 18 + 2))
      target[i].hotJoinRequest = get(24, UInt32(i * 18 + 3))
      target[i].ibiRequest = get(24, UInt32(i * 18 + 4))
      target[i].ibiPayload = get(24, UInt32(i * 18 + 5))
      target[i].ibiPayloadSize = get(24, UInt32(i * 18 + 6))
      target[i].maxReadDataSize = UInt16(truncatingIfNeeded: get(24, UInt32(i * 18 + 7)))
      target[i].maxWriteDataSize = UInt16(truncatingIfNeeded: get(24, UInt32(i * 18 + 8)))
      target[i].ctrlCapability = get(24, UInt32(i * 18 + 9))
      target[i].groupAddrCapability = get(24, UInt32(i * 18 + 10))
      target[i].dataTurnAroundDuration = get(24, UInt32(i * 18 + 11))
      target[i].maxReadTurnAround = UInt8(truncatingIfNeeded: get(24, UInt32(i * 18 + 12)))
      target[i].maxDataSpeed = get(24, UInt32(i * 18 + 13))
      target[i].maxSpeedLimitation = get(24, UInt32(i * 18 + 14))
      target[i].handOffActivityState = get(24, UInt32(i * 18 + 15))
      target[i].handOffDelay = get(24, UInt32(i * 18 + 16))
      target[i].pendingReadMDB = get(24, UInt32(i * 18 + 17))
    }
    for i in 0..<4 {
      devices[i].deviceIndex = UInt8(truncatingIfNeeded: get(25, UInt32(i * 6 + 0)))
      devices[i].targetDynamicAddr = UInt8(truncatingIfNeeded: get(25, UInt32(i * 6 + 1)))
      devices[i].ibiAck = get(25, UInt32(i * 6 + 2))
      devices[i].ibiPayload = get(25, UInt32(i * 6 + 3))
      devices[i].ctrlRoleReqAck = get(25, UInt32(i * 6 + 4))
      devices[i].ctrlStopTransfer = get(25, UInt32(i * 6 + 5))
    }
    for i in 0..<1 {
      cccInfo[i].dynamicAddrValid = get(26, UInt32(i * 12 + 0))
      cccInfo[i].dynamicAddr = get(26, UInt32(i * 12 + 1))
      cccInfo[i].maxWriteLength = get(26, UInt32(i * 12 + 2))
      cccInfo[i].maxReadLength = get(26, UInt32(i * 12 + 3))
      cccInfo[i].resetAction = get(26, UInt32(i * 12 + 4))
      cccInfo[i].activityState = get(26, UInt32(i * 12 + 5))
      cccInfo[i].hotJoinAllowed = get(26, UInt32(i * 12 + 6))
      cccInfo[i].inBandAllowed = get(26, UInt32(i * 12 + 7))
      cccInfo[i].ctrlRoleAllowed = get(26, UInt32(i * 12 + 8))
      cccInfo[i].ibicrTgtAddr = get(26, UInt32(i * 12 + 9))
      cccInfo[i].ibiTgtNbPayload = get(26, UInt32(i * 12 + 10))
      cccInfo[i].ibiTgtPayload = get(26, UInt32(i * 12 + 11))
    }
    for i in 0..<1 {
      payload[i].bcr.maxDataSpeedLimitation = get(27, UInt32(i * 12 + 0))
      payload[i].bcr.ibiRequestCapable = get(27, UInt32(i * 12 + 1))
      payload[i].bcr.ibiPayload = get(27, UInt32(i * 12 + 2))
      payload[i].bcr.offlineCapable = get(27, UInt32(i * 12 + 3))
      payload[i].bcr.virtualTargetSupport = get(27, UInt32(i * 12 + 4))
      payload[i].bcr.advancedCapabilities = get(27, UInt32(i * 12 + 5))
      payload[i].bcr.deviceRole = get(27, UInt32(i * 12 + 6))
      payload[i].dcr = get(27, UInt32(i * 12 + 7))
      payload[i].pid.mipimid = UInt16(truncatingIfNeeded: get(27, UInt32(i * 12 + 8)))
      payload[i].pid.idtsel = UInt8(truncatingIfNeeded: get(27, UInt32(i * 12 + 9)))
      payload[i].pid.partID = UInt16(truncatingIfNeeded: get(27, UInt32(i * 12 + 10)))
      payload[i].pid.mipiid = UInt8(truncatingIfNeeded: get(27, UInt32(i * 12 + 11)))
    }
    for i in 0..<8 {
      ccc[i].targetAddr = UInt8(truncatingIfNeeded: get(28, UInt32(i * 5 + 0)))
      ccc[i].ccc = UInt8(truncatingIfNeeded: get(28, UInt32(i * 5 + 1)))
      ccc[i].cccBuffer.buffer = decode(get(28, UInt32(i * 5 + 2)), UInt8.self)
      ccc[i].cccBuffer.size = get(28, UInt32(i * 5 + 3))
      ccc[i].direction = get(28, UInt32(i * 5 + 4))
    }
    for i in 0..<8 {
      privateDescriptors[i].targetAddr = UInt8(truncatingIfNeeded: get(29, UInt32(i * 6 + 0)))
      privateDescriptors[i].transmitBuffer.buffer = decode(get(29, UInt32(i * 6 + 1)), UInt8.self)
      privateDescriptors[i].transmitBuffer.size = get(29, UInt32(i * 6 + 2))
      privateDescriptors[i].receiveBuffer.buffer = decode(get(29, UInt32(i * 6 + 3)), UInt8.self)
      privateDescriptors[i].receiveBuffer.size = get(29, UInt32(i * 6 + 4))
      privateDescriptors[i].direction = get(29, UInt32(i * 6 + 5))
    }
    for i in 0..<1 {
      transfer[i].controlBuffer.buffer = decode(get(30, UInt32(i * 8 + 0)), UInt32.self)
      transfer[i].controlBuffer.size = get(30, UInt32(i * 8 + 1))
      transfer[i].statusBuffer.buffer = decode(get(30, UInt32(i * 8 + 2)), UInt32.self)
      transfer[i].statusBuffer.size = get(30, UInt32(i * 8 + 3))
      transfer[i].transmitBuffer.buffer = decode(get(30, UInt32(i * 8 + 4)), UInt8.self)
      transfer[i].transmitBuffer.size = get(30, UInt32(i * 8 + 5))
      transfer[i].receiveBuffer.buffer = decode(get(30, UInt32(i * 8 + 6)), UInt8.self)
      transfer[i].receiveBuffer.size = get(30, UInt32(i * 8 + 7))
    }
    outputPayload.pointee = UInt64(get(12, 0)) | (UInt64(get(12, 1)) << 32)
    outputReset.pointee = get(12, 2)
    outputAddress.pointee = UInt8(truncatingIfNeeded: get(12, 3))
  }
  func saveStructures() {
    for i in 0..<1 {
      set(20, UInt32(i * 8 + 0), UInt32(controllerBus[i].sdaHoldTime))
      set(20, UInt32(i * 8 + 1), UInt32(controllerBus[i].waitTime))
      set(20, UInt32(i * 8 + 2), UInt32(controllerBus[i].sclppLowDuration))
      set(20, UInt32(i * 8 + 3), UInt32(controllerBus[i].sclI3CHighDuration))
      set(20, UInt32(i * 8 + 4), UInt32(controllerBus[i].sclodLowDuration))
      set(20, UInt32(i * 8 + 5), UInt32(controllerBus[i].sclI2CHighDuration))
      set(20, UInt32(i * 8 + 6), UInt32(controllerBus[i].busFreeDuration))
      set(20, UInt32(i * 8 + 7), UInt32(controllerBus[i].busIdleDuration))
    }
    for i in 0..<1 {
      set(21, UInt32(i * 1 + 0), UInt32(targetBus[i].busAvailableDuration))
    }
    for i in 0..<1 {
      set(22, UInt32(i * 4 + 0), UInt32(fifo[i].rxFifoThreshold))
      set(22, UInt32(i * 4 + 1), UInt32(fifo[i].txFifoThreshold))
      set(22, UInt32(i * 4 + 2), UInt32(fifo[i].controlFifo))
      set(22, UInt32(i * 4 + 3), UInt32(fifo[i].statusFifo))
    }
    for i in 0..<1 {
      set(23, UInt32(i * 8 + 0), UInt32(controller[i].dynamicAddr))
      set(23, UInt32(i * 8 + 1), UInt32(controller[i].stallTime))
      set(23, UInt32(i * 8 + 2), UInt32(controller[i].hotJoinAllowed))
      set(23, UInt32(i * 8 + 3), UInt32(controller[i].ackStallState))
      set(23, UInt32(i * 8 + 4), UInt32(controller[i].cccStallState))
      set(23, UInt32(i * 8 + 5), UInt32(controller[i].txStallState))
      set(23, UInt32(i * 8 + 6), UInt32(controller[i].rxStallState))
      set(23, UInt32(i * 8 + 7), UInt32(controller[i].highKeeperSDA))
    }
    for i in 0..<1 {
      set(24, UInt32(i * 18 + 0), UInt32(target[i].identifier))
      set(24, UInt32(i * 18 + 1), UInt32(target[i].mipiIdentifier))
      set(24, UInt32(i * 18 + 2), UInt32(target[i].ctrlRoleRequest))
      set(24, UInt32(i * 18 + 3), UInt32(target[i].hotJoinRequest))
      set(24, UInt32(i * 18 + 4), UInt32(target[i].ibiRequest))
      set(24, UInt32(i * 18 + 5), UInt32(target[i].ibiPayload))
      set(24, UInt32(i * 18 + 6), UInt32(target[i].ibiPayloadSize))
      set(24, UInt32(i * 18 + 7), UInt32(target[i].maxReadDataSize))
      set(24, UInt32(i * 18 + 8), UInt32(target[i].maxWriteDataSize))
      set(24, UInt32(i * 18 + 9), UInt32(target[i].ctrlCapability))
      set(24, UInt32(i * 18 + 10), UInt32(target[i].groupAddrCapability))
      set(24, UInt32(i * 18 + 11), UInt32(target[i].dataTurnAroundDuration))
      set(24, UInt32(i * 18 + 12), UInt32(target[i].maxReadTurnAround))
      set(24, UInt32(i * 18 + 13), UInt32(target[i].maxDataSpeed))
      set(24, UInt32(i * 18 + 14), UInt32(target[i].maxSpeedLimitation))
      set(24, UInt32(i * 18 + 15), UInt32(target[i].handOffActivityState))
      set(24, UInt32(i * 18 + 16), UInt32(target[i].handOffDelay))
      set(24, UInt32(i * 18 + 17), UInt32(target[i].pendingReadMDB))
    }
    for i in 0..<4 {
      set(25, UInt32(i * 6 + 0), UInt32(devices[i].deviceIndex))
      set(25, UInt32(i * 6 + 1), UInt32(devices[i].targetDynamicAddr))
      set(25, UInt32(i * 6 + 2), UInt32(devices[i].ibiAck))
      set(25, UInt32(i * 6 + 3), UInt32(devices[i].ibiPayload))
      set(25, UInt32(i * 6 + 4), UInt32(devices[i].ctrlRoleReqAck))
      set(25, UInt32(i * 6 + 5), UInt32(devices[i].ctrlStopTransfer))
    }
    for i in 0..<1 {
      set(26, UInt32(i * 12 + 0), UInt32(cccInfo[i].dynamicAddrValid))
      set(26, UInt32(i * 12 + 1), UInt32(cccInfo[i].dynamicAddr))
      set(26, UInt32(i * 12 + 2), UInt32(cccInfo[i].maxWriteLength))
      set(26, UInt32(i * 12 + 3), UInt32(cccInfo[i].maxReadLength))
      set(26, UInt32(i * 12 + 4), UInt32(cccInfo[i].resetAction))
      set(26, UInt32(i * 12 + 5), UInt32(cccInfo[i].activityState))
      set(26, UInt32(i * 12 + 6), UInt32(cccInfo[i].hotJoinAllowed))
      set(26, UInt32(i * 12 + 7), UInt32(cccInfo[i].inBandAllowed))
      set(26, UInt32(i * 12 + 8), UInt32(cccInfo[i].ctrlRoleAllowed))
      set(26, UInt32(i * 12 + 9), UInt32(cccInfo[i].ibicrTgtAddr))
      set(26, UInt32(i * 12 + 10), UInt32(cccInfo[i].ibiTgtNbPayload))
      set(26, UInt32(i * 12 + 11), UInt32(cccInfo[i].ibiTgtPayload))
    }
    for i in 0..<1 {
      set(27, UInt32(i * 12 + 0), UInt32(payload[i].bcr.maxDataSpeedLimitation))
      set(27, UInt32(i * 12 + 1), UInt32(payload[i].bcr.ibiRequestCapable))
      set(27, UInt32(i * 12 + 2), UInt32(payload[i].bcr.ibiPayload))
      set(27, UInt32(i * 12 + 3), UInt32(payload[i].bcr.offlineCapable))
      set(27, UInt32(i * 12 + 4), UInt32(payload[i].bcr.virtualTargetSupport))
      set(27, UInt32(i * 12 + 5), UInt32(payload[i].bcr.advancedCapabilities))
      set(27, UInt32(i * 12 + 6), UInt32(payload[i].bcr.deviceRole))
      set(27, UInt32(i * 12 + 7), UInt32(payload[i].dcr))
      set(27, UInt32(i * 12 + 8), UInt32(payload[i].pid.mipimid))
      set(27, UInt32(i * 12 + 9), UInt32(payload[i].pid.idtsel))
      set(27, UInt32(i * 12 + 10), UInt32(payload[i].pid.partID))
      set(27, UInt32(i * 12 + 11), UInt32(payload[i].pid.mipiid))
    }
    for i in 0..<8 {
      set(28, UInt32(i * 5 + 0), UInt32(ccc[i].targetAddr))
      set(28, UInt32(i * 5 + 1), UInt32(ccc[i].ccc))
      set(28, UInt32(i * 5 + 2), normalize(ccc[i].cccBuffer.buffer))
      set(28, UInt32(i * 5 + 3), UInt32(ccc[i].cccBuffer.size))
      set(28, UInt32(i * 5 + 4), UInt32(ccc[i].direction))
    }
    for i in 0..<8 {
      set(29, UInt32(i * 6 + 0), UInt32(privateDescriptors[i].targetAddr))
      set(29, UInt32(i * 6 + 1), normalize(privateDescriptors[i].transmitBuffer.buffer))
      set(29, UInt32(i * 6 + 2), UInt32(privateDescriptors[i].transmitBuffer.size))
      set(29, UInt32(i * 6 + 3), normalize(privateDescriptors[i].receiveBuffer.buffer))
      set(29, UInt32(i * 6 + 4), UInt32(privateDescriptors[i].receiveBuffer.size))
      set(29, UInt32(i * 6 + 5), UInt32(privateDescriptors[i].direction))
    }
    for i in 0..<1 {
      set(30, UInt32(i * 8 + 0), normalize(transfer[i].controlBuffer.buffer))
      set(30, UInt32(i * 8 + 1), UInt32(transfer[i].controlBuffer.size))
      set(30, UInt32(i * 8 + 2), normalize(transfer[i].statusBuffer.buffer))
      set(30, UInt32(i * 8 + 3), UInt32(transfer[i].statusBuffer.size))
      set(30, UInt32(i * 8 + 4), normalize(transfer[i].transmitBuffer.buffer))
      set(30, UInt32(i * 8 + 5), UInt32(transfer[i].transmitBuffer.size))
      set(30, UInt32(i * 8 + 6), normalize(transfer[i].receiveBuffer.buffer))
      set(30, UInt32(i * 8 + 7), UInt32(transfer[i].receiveBuffer.size))
    }
    set(12, 0, UInt32(truncatingIfNeeded: outputPayload.pointee))
    set(12, 1, UInt32(truncatingIfNeeded: outputPayload.pointee >> 32))
    set(12, 2, outputReset.pointee)
    set(12, 3, UInt32(outputAddress.pointee))
  }
  func isPresent(_ channel: I3CDMAChannel) -> Bool { get(3 + channel.rawValue, 0) != 0 }
  func readState(_ channel: I3CDMAChannel) -> UInt32 { get(3 + channel.rawValue, 1) }
  func getCounter(_ channel: I3CDMAChannel) -> UInt32 { get(3 + channel.rawValue, 2) }
  func getFIFOLevel(_ channel: I3CDMAChannel) -> UInt32 { get(3 + channel.rawValue, 3) }
  func writeCallback(_ channel: I3CDMAChannel, id: DMACallbackID, value: DMACallback?) {
    let bits = value.map { unsafeBitCast($0, to: UInt.self) } ?? 0
    var number: UInt32 = 0
    if bits != 0 {
      for kind in I3CDMACallbackKind.allCases {
        if unsafeBitCast(callback(kind), to: UInt.self) == bits { number = kind.rawValue + 1 }
      }
      precondition(number != 0)
    }
    set(6 + channel.rawValue, id.rawValue, number)
  }
  func invokeCallback(_ channel: I3CDMAChannel, id: DMACallbackID) {
    let number = get(6 + channel.rawValue, id.rawValue)
    precondition(number != 0)
    callback(I3CDMACallbackKind(rawValue: number - 1)!)(Unmanaged.passUnretained(self).toOpaque())
  }
  func callback(_ kind: I3CDMACallbackKind) -> DMACallback {
    switch kind {
    case .controlTransmitComplete: return i3cFixtureDMA0
    case .dataTransmitComplete: return i3cFixtureDMA1
    case .dataReceiveComplete: return i3cFixtureDMA2
    case .error: return i3cFixtureDMA3
    case .abort: return i3cFixtureDMA4
    }
  }
  func startInterrupt(
    _ channel: I3CDMAChannel, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CI3C_RecordDMA(
        state, channel.rawValue, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func abort(_ channel: I3CDMAChannel, getTick: () -> UInt32) -> HALStatus {
    HALStatus(rawValue: CI3C_RecordDMA(state, channel.rawValue, 1, 0, 0, 0))!
  }
  func abortInterrupt(_ channel: I3CDMAChannel) -> HALStatus {
    let result = HALStatus(rawValue: CI3C_RecordDMA(state, channel.rawValue, 2, 0, 0, 0))!
    if get(3 + channel.rawValue, 7) != 0 && get(6 + channel.rawValue, 3) != 0 {
      invokeCallback(channel, id: .abort)
    }
    return result
  }
  func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, _ e: UInt32 = 0)
    -> UInt32
  {
    CI3C_Activate(state)
    loadStructures()
    defer { saveStructures() }
    let d = driver
    switch op {
    case 0: return d.initialize().rawValue
    case 1: return d.deinitialize().rawValue
    case 2:
      return d.registerCallback(
        a, b == 0 ? nil : unsafeBitCast(CI3C_Callback(a < 13 ? a : 0, b), to: I3CCallback.self)
      ).rawValue
    case 3:
      return d.registerNotifyCallback(
        b == 0 ? nil : unsafeBitCast(CI3C_Callback(8, b), to: I3CNotifyCallback.self)
      ).rawValue
    case 4:
      return d.registerTargetDynamicAddressCallback(
        b == 0 ? nil : unsafeBitCast(CI3C_Callback(4, b), to: I3CDynamicAddressCallback.self)
      ).rawValue
    case 5:
      return d.registerTargetHotJoinCallback(
        b == 0 ? nil : unsafeBitCast(CI3C_Callback(7, b), to: I3CHotJoinCallback.self)
      ).rawValue
    case 6: return d.unregisterCallback(a).rawValue
    case 7: return d.activateNotification(control(10) != 0 ? nil : transfer, a).rawValue
    case 8: return d.deactivateNotification(a).rawValue
    case 9:
      d.errorInterruptHandler()
      return 0
    case 10:
      d.eventInterruptHandler()
      return 0
    case 11:
      return d.configureControllerBus(control(13) != 0 ? nil : UnsafePointer(controllerBus))
        .rawValue
    case 12: return d.configureTargetBus(control(13) != 0 ? nil : UnsafePointer(targetBus)).rawValue
    case 13: return d.configureFIFO(control(13) != 0 ? nil : UnsafePointer(fifo)).rawValue
    case 14:
      return d.configureController(control(13) != 0 ? nil : UnsafePointer(controller)).rawValue
    case 15: return d.configureTarget(control(13) != 0 ? nil : UnsafePointer(target)).rawValue
    case 16:
      return d.configureBusDevices(
        control(13) != 0 ? nil : UnsafePointer(devices), UInt8(truncatingIfNeeded: a)
      ).rawValue
    case 17:
      return d.addDescriptorsToFrame(
        control(11) != 0 ? nil : UnsafePointer(ccc),
        control(12) != 0 ? nil : UnsafePointer(privateDescriptors),
        control(10) != 0 ? nil : transfer, UInt8(truncatingIfNeeded: a), b
      ).rawValue
    case 18: return d.setResetPattern(a).rawValue
    case 19: return d.getResetPattern(control(13) != 0 ? nil : outputReset).rawValue
    case 20: return d.flushAllFIFO().rawValue
    case 21: return d.flushTransmitFIFO().rawValue
    case 22: return d.flushReceiveFIFO().rawValue
    case 23: return d.flushControlFIFO().rawValue
    case 24: return d.flushStatusFIFO().rawValue
    case 25: return d.clearFIFOConfiguration().rawValue
    case 26: return d.getFIFOConfiguration(control(13) != 0 ? nil : fifo).rawValue
    case 27:
      return d.controllerTransmitCCC(
        control(10) != 0 ? nil : transfer, a, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 28: return d.controllerTransmitCCCInterrupt(control(10) != 0 ? nil : transfer).rawValue
    case 29:
      return d.controllerTransmitCCCDMA(
        control(10) != 0 ? nil : transfer, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 30:
      return d.controllerReceiveCCC(
        control(10) != 0 ? nil : transfer, a, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 31: return d.controllerReceiveCCCInterrupt(control(10) != 0 ? nil : transfer).rawValue
    case 32:
      return d.controllerReceiveCCCDMA(
        control(10) != 0 ? nil : transfer, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 33:
      return d.controllerTransmit(
        control(10) != 0 ? nil : transfer, a, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 34: return d.controllerTransmitInterrupt(control(10) != 0 ? nil : transfer).rawValue
    case 35:
      return d.controllerTransmitDMA(
        control(10) != 0 ? nil : transfer, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 36:
      return d.controllerReceive(
        control(10) != 0 ? nil : transfer, a, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 37: return d.controllerReceiveInterrupt(control(10) != 0 ? nil : transfer).rawValue
    case 38:
      return d.controllerReceiveDMA(
        control(10) != 0 ? nil : transfer, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 39:
      return d.controllerMultipleTransferInterrupt(control(10) != 0 ? nil : transfer).rawValue
    case 40:
      return d.controllerMultipleTransferDMA(
        control(10) != 0 ? nil : transfer, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 41:
      return d.controllerAssignDynamicAddress(
        control(13) != 0 ? nil : outputPayload, a, b, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 42: return d.controllerAssignDynamicAddressInterrupt(a).rawValue
    case 43: return d.controllerSetDynamicAddress(UInt8(truncatingIfNeeded: a)).rawValue
    case 44:
      return d.controllerIsI3CDeviceReady(
        UInt8(truncatingIfNeeded: a), b, c, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 45:
      return d.controllerIsI2CDeviceReady(
        UInt8(truncatingIfNeeded: a), b, c, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 46:
      return d.controllerGenerateArbitration(a, getTick: { CI3C_TickFor(self.state) }).rawValue
    case 47:
      return d.targetTransmit(
        control(10) != 0 ? nil : transfer, a, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 48: return d.targetTransmitInterrupt(control(10) != 0 ? nil : transfer).rawValue
    case 49: return d.targetTransmitDMA(control(10) != 0 ? nil : transfer).rawValue
    case 50:
      return d.targetReceive(
        control(10) != 0 ? nil : transfer, a, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 51: return d.targetReceiveInterrupt(control(10) != 0 ? nil : transfer).rawValue
    case 52: return d.targetReceiveDMA(control(10) != 0 ? nil : transfer).rawValue
    case 53: return d.targetRequestControlRole(a, getTick: { CI3C_TickFor(self.state) }).rawValue
    case 54: return d.targetRequestControlRoleInterrupt().rawValue
    case 55:
      return d.targetRequestHotJoin(
        control(13) != 0 ? nil : outputAddress, a, getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 56: return d.targetRequestHotJoinInterrupt().rawValue
    case 57:
      return d.targetRequestIBI(
        control(13) != 0 ? nil : UnsafePointer(buffer(7)), UInt8(truncatingIfNeeded: a), b,
        getTick: { CI3C_TickFor(self.state) }
      ).rawValue
    case 58:
      return d.targetRequestIBIInterrupt(
        control(13) != 0 ? nil : UnsafePointer(buffer(7)), UInt8(truncatingIfNeeded: a)
      ).rawValue
    case 59: return d.abortInterrupt().rawValue
    case 60: return d.getState()
    case 61: return d.getMode()
    case 62: return d.getError()
    case 63: return d.getCCCInfo(a, control(13) != 0 ? nil : cccInfo).rawValue
    case 64:
      return d.getDynamicAddressPayload(
        (UInt64(b) << 32) | UInt64(a), control(13) != 0 ? nil : payload
      ).rawValue
    case 85:
      d.dmaControlTransmitComplete()
      return 0
    case 86:
      d.dmaDataTransmitComplete()
      return 0
    case 87:
      d.dmaDataReceiveComplete()
      return 0
    case 88:
      d.dmaError()
      return 0
    case 89:
      d.dmaAbort()
      return 0
    default: preconditionFailure("Private helper is exercised through its public entry point")
    }
  }
}
private func i3cFixtureDMA0(_ context: UnsafeMutableRawPointer?) {
  let f = Unmanaged<I3CFixture>.fromOpaque(context!).takeUnretainedValue()
  f.driver.dmaControlTransmitComplete()
}
private func i3cFixtureDMA1(_ context: UnsafeMutableRawPointer?) {
  let f = Unmanaged<I3CFixture>.fromOpaque(context!).takeUnretainedValue()
  f.driver.dmaDataTransmitComplete()
}
private func i3cFixtureDMA2(_ context: UnsafeMutableRawPointer?) {
  let f = Unmanaged<I3CFixture>.fromOpaque(context!).takeUnretainedValue()
  f.driver.dmaDataReceiveComplete()
}
private func i3cFixtureDMA3(_ context: UnsafeMutableRawPointer?) {
  let f = Unmanaged<I3CFixture>.fromOpaque(context!).takeUnretainedValue()
  f.driver.dmaError()
}
private func i3cFixtureDMA4(_ context: UnsafeMutableRawPointer?) {
  let f = Unmanaged<I3CFixture>.fromOpaque(context!).takeUnretainedValue()
  f.driver.dmaAbort()
}
func checkI3C(
  _ setup: (I3CFixture) -> Void, operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0,
  _ c: UInt32 = 0, _ d: UInt32 = 0, callbacks: Bool = true, file: StaticString = #filePath,
  line: UInt = #line
) {
  let reference = I3CFixture(callbacks: callbacks)
  let swift = I3CFixture(callbacks: callbacks)
  setup(reference)
  setup(swift)
  let expected = CI3C_Run(reference.state, operation, a, b, c, d)
  let actual = swift.run(operation, a, b, c, d)
  XCTAssertEqual(actual, expected, "operation \(operation)", file: file, line: line)
  let difference = CI3C_Compare(reference.state, swift.state)
  if difference != 0 {
    let group = (difference >> 16) - 1
    let index = difference & 0xFFFF
    XCTFail(
      "operation \(operation), difference \(String(difference,radix:16)), C \(group<32 ? reference.get(group,index):0), Swift \(group<32 ? swift.get(group,index):0)",
      file: file, line: line)
  }
}
