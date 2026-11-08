// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct I3CControllerBusConfiguration: Equatable, Sendable {
  public var sdaHoldTime: UInt32
  public var waitTime: UInt32
  public var sclppLowDuration: UInt8
  public var sclI3CHighDuration: UInt8
  public var sclodLowDuration: UInt8
  public var sclI2CHighDuration: UInt8
  public var busFreeDuration: UInt8
  public var busIdleDuration: UInt8
  public init(
    sdaHoldTime: UInt32 = 0, waitTime: UInt32 = 0, sclppLowDuration: UInt8 = 0,
    sclI3CHighDuration: UInt8 = 0, sclodLowDuration: UInt8 = 0, sclI2CHighDuration: UInt8 = 0,
    busFreeDuration: UInt8 = 0, busIdleDuration: UInt8 = 0
  ) {
    self.sdaHoldTime = sdaHoldTime
    self.waitTime = waitTime
    self.sclppLowDuration = sclppLowDuration
    self.sclI3CHighDuration = sclI3CHighDuration
    self.sclodLowDuration = sclodLowDuration
    self.sclI2CHighDuration = sclI2CHighDuration
    self.busFreeDuration = busFreeDuration
    self.busIdleDuration = busIdleDuration
  }
}
public struct I3CTargetBusConfiguration: Equatable, Sendable {
  public var busAvailableDuration: UInt8
  public init(busAvailableDuration: UInt8 = 0) {
    self.busAvailableDuration = busAvailableDuration
  }
}
public struct I3CConfiguration: Equatable, Sendable {
  public var controllerBus: I3CControllerBusConfiguration
  public var targetBus: I3CTargetBusConfiguration
  public init(
    controllerBus: I3CControllerBusConfiguration = .init(),
    targetBus: I3CTargetBusConfiguration = .init()
  ) {
    self.controllerBus = controllerBus
    self.targetBus = targetBus
  }
}
public struct I3CFIFOConfiguration: Equatable, Sendable {
  public var rxFifoThreshold: UInt32
  public var txFifoThreshold: UInt32
  public var controlFifo: UInt32
  public var statusFifo: UInt32
  public init(
    rxFifoThreshold: UInt32 = 0, txFifoThreshold: UInt32 = 0, controlFifo: UInt32 = 0,
    statusFifo: UInt32 = 0
  ) {
    self.rxFifoThreshold = rxFifoThreshold
    self.txFifoThreshold = txFifoThreshold
    self.controlFifo = controlFifo
    self.statusFifo = statusFifo
  }
}
public struct I3CControllerConfiguration: Equatable, Sendable {
  public var dynamicAddr: UInt8
  public var stallTime: UInt8
  public var hotJoinAllowed: UInt32
  public var ackStallState: UInt32
  public var cccStallState: UInt32
  public var txStallState: UInt32
  public var rxStallState: UInt32
  public var highKeeperSDA: UInt32
  public init(
    dynamicAddr: UInt8 = 0, stallTime: UInt8 = 0, hotJoinAllowed: UInt32 = 0,
    ackStallState: UInt32 = 0, cccStallState: UInt32 = 0, txStallState: UInt32 = 0,
    rxStallState: UInt32 = 0, highKeeperSDA: UInt32 = 0
  ) {
    self.dynamicAddr = dynamicAddr
    self.stallTime = stallTime
    self.hotJoinAllowed = hotJoinAllowed
    self.ackStallState = ackStallState
    self.cccStallState = cccStallState
    self.txStallState = txStallState
    self.rxStallState = rxStallState
    self.highKeeperSDA = highKeeperSDA
  }
}
public struct I3CTargetConfiguration: Equatable, Sendable {
  public var identifier: UInt8
  public var mipiIdentifier: UInt8
  public var ctrlRoleRequest: UInt32
  public var hotJoinRequest: UInt32
  public var ibiRequest: UInt32
  public var ibiPayload: UInt32
  public var ibiPayloadSize: UInt32
  public var maxReadDataSize: UInt16
  public var maxWriteDataSize: UInt16
  public var ctrlCapability: UInt32
  public var groupAddrCapability: UInt32
  public var dataTurnAroundDuration: UInt32
  public var maxReadTurnAround: UInt8
  public var maxDataSpeed: UInt32
  public var maxSpeedLimitation: UInt32
  public var handOffActivityState: UInt32
  public var handOffDelay: UInt32
  public var pendingReadMDB: UInt32
  public init(
    identifier: UInt8 = 0, mipiIdentifier: UInt8 = 0, ctrlRoleRequest: UInt32 = 0,
    hotJoinRequest: UInt32 = 0, ibiRequest: UInt32 = 0, ibiPayload: UInt32 = 0,
    ibiPayloadSize: UInt32 = 0, maxReadDataSize: UInt16 = 0, maxWriteDataSize: UInt16 = 0,
    ctrlCapability: UInt32 = 0, groupAddrCapability: UInt32 = 0, dataTurnAroundDuration: UInt32 = 0,
    maxReadTurnAround: UInt8 = 0, maxDataSpeed: UInt32 = 0, maxSpeedLimitation: UInt32 = 0,
    handOffActivityState: UInt32 = 0, handOffDelay: UInt32 = 0, pendingReadMDB: UInt32 = 0
  ) {
    self.identifier = identifier
    self.mipiIdentifier = mipiIdentifier
    self.ctrlRoleRequest = ctrlRoleRequest
    self.hotJoinRequest = hotJoinRequest
    self.ibiRequest = ibiRequest
    self.ibiPayload = ibiPayload
    self.ibiPayloadSize = ibiPayloadSize
    self.maxReadDataSize = maxReadDataSize
    self.maxWriteDataSize = maxWriteDataSize
    self.ctrlCapability = ctrlCapability
    self.groupAddrCapability = groupAddrCapability
    self.dataTurnAroundDuration = dataTurnAroundDuration
    self.maxReadTurnAround = maxReadTurnAround
    self.maxDataSpeed = maxDataSpeed
    self.maxSpeedLimitation = maxSpeedLimitation
    self.handOffActivityState = handOffActivityState
    self.handOffDelay = handOffDelay
    self.pendingReadMDB = pendingReadMDB
  }
}
public struct I3CDeviceConfiguration: Equatable, Sendable {
  public var deviceIndex: UInt8
  public var targetDynamicAddr: UInt8
  public var ibiAck: UInt32
  public var ibiPayload: UInt32
  public var ctrlRoleReqAck: UInt32
  public var ctrlStopTransfer: UInt32
  public init(
    deviceIndex: UInt8 = 0, targetDynamicAddr: UInt8 = 0, ibiAck: UInt32 = 0,
    ibiPayload: UInt32 = 0, ctrlRoleReqAck: UInt32 = 0, ctrlStopTransfer: UInt32 = 0
  ) {
    self.deviceIndex = deviceIndex
    self.targetDynamicAddr = targetDynamicAddr
    self.ibiAck = ibiAck
    self.ibiPayload = ibiPayload
    self.ctrlRoleReqAck = ctrlRoleReqAck
    self.ctrlStopTransfer = ctrlStopTransfer
  }
}
public struct I3CCCCInfo: Equatable, Sendable {
  public var dynamicAddrValid: UInt32
  public var dynamicAddr: UInt32
  public var maxWriteLength: UInt32
  public var maxReadLength: UInt32
  public var resetAction: UInt32
  public var activityState: UInt32
  public var hotJoinAllowed: UInt32
  public var inBandAllowed: UInt32
  public var ctrlRoleAllowed: UInt32
  public var ibicrTgtAddr: UInt32
  public var ibiTgtNbPayload: UInt32
  public var ibiTgtPayload: UInt32
  public init(
    dynamicAddrValid: UInt32 = 0, dynamicAddr: UInt32 = 0, maxWriteLength: UInt32 = 0,
    maxReadLength: UInt32 = 0, resetAction: UInt32 = 0, activityState: UInt32 = 0,
    hotJoinAllowed: UInt32 = 0, inBandAllowed: UInt32 = 0, ctrlRoleAllowed: UInt32 = 0,
    ibicrTgtAddr: UInt32 = 0, ibiTgtNbPayload: UInt32 = 0, ibiTgtPayload: UInt32 = 0
  ) {
    self.dynamicAddrValid = dynamicAddrValid
    self.dynamicAddr = dynamicAddr
    self.maxWriteLength = maxWriteLength
    self.maxReadLength = maxReadLength
    self.resetAction = resetAction
    self.activityState = activityState
    self.hotJoinAllowed = hotJoinAllowed
    self.inBandAllowed = inBandAllowed
    self.ctrlRoleAllowed = ctrlRoleAllowed
    self.ibicrTgtAddr = ibicrTgtAddr
    self.ibiTgtNbPayload = ibiTgtNbPayload
    self.ibiTgtPayload = ibiTgtPayload
  }
}
public struct I3CControlBuffer {
  public var buffer: UnsafeMutablePointer<UInt32>?
  public var size: UInt32
  public init(buffer: UnsafeMutablePointer<UInt32>? = nil, size: UInt32 = 0) {
    self.buffer = buffer
    self.size = size
  }
}
public struct I3CDataBuffer {
  public var buffer: UnsafeMutablePointer<UInt8>?
  public var size: UInt32
  public init(buffer: UnsafeMutablePointer<UInt8>? = nil, size: UInt32 = 0) {
    self.buffer = buffer
    self.size = size
  }
}
public struct I3CCCCDescriptor {
  public var targetAddr: UInt8
  public var ccc: UInt8
  public var cccBuffer: I3CDataBuffer
  public var direction: UInt32
  public init(
    targetAddr: UInt8 = 0, ccc: UInt8 = 0, cccBuffer: I3CDataBuffer = .init(), direction: UInt32 = 0
  ) {
    self.targetAddr = targetAddr
    self.ccc = ccc
    self.cccBuffer = cccBuffer
    self.direction = direction
  }
}
public struct I3CBusCharacteristics: Equatable, Sendable {
  public var maxDataSpeedLimitation: UInt32
  public var ibiRequestCapable: UInt32
  public var ibiPayload: UInt32
  public var offlineCapable: UInt32
  public var virtualTargetSupport: UInt32
  public var advancedCapabilities: UInt32
  public var deviceRole: UInt32
  public init(
    maxDataSpeedLimitation: UInt32 = 0, ibiRequestCapable: UInt32 = 0, ibiPayload: UInt32 = 0,
    offlineCapable: UInt32 = 0, virtualTargetSupport: UInt32 = 0, advancedCapabilities: UInt32 = 0,
    deviceRole: UInt32 = 0
  ) {
    self.maxDataSpeedLimitation = maxDataSpeedLimitation
    self.ibiRequestCapable = ibiRequestCapable
    self.ibiPayload = ibiPayload
    self.offlineCapable = offlineCapable
    self.virtualTargetSupport = virtualTargetSupport
    self.advancedCapabilities = advancedCapabilities
    self.deviceRole = deviceRole
  }
}
public struct I3CProvisionedID: Equatable, Sendable {
  public var mipimid: UInt16
  public var idtsel: UInt8
  public var partID: UInt16
  public var mipiid: UInt8
  public init(mipimid: UInt16 = 0, idtsel: UInt8 = 0, partID: UInt16 = 0, mipiid: UInt8 = 0) {
    self.mipimid = mipimid
    self.idtsel = idtsel
    self.partID = partID
    self.mipiid = mipiid
  }
}
public struct I3CENTDAAPayload: Equatable, Sendable {
  public var bcr: I3CBusCharacteristics
  public var dcr: UInt32
  public var pid: I3CProvisionedID
  public init(
    bcr: I3CBusCharacteristics = .init(), dcr: UInt32 = 0, pid: I3CProvisionedID = .init()
  ) {
    self.bcr = bcr
    self.dcr = dcr
    self.pid = pid
  }
}
public struct I3CPrivateDescriptor {
  public var targetAddr: UInt8
  public var transmitBuffer: I3CDataBuffer
  public var receiveBuffer: I3CDataBuffer
  public var direction: UInt32
  public init(
    targetAddr: UInt8 = 0, transmitBuffer: I3CDataBuffer = .init(),
    receiveBuffer: I3CDataBuffer = .init(), direction: UInt32 = 0
  ) {
    self.targetAddr = targetAddr
    self.transmitBuffer = transmitBuffer
    self.receiveBuffer = receiveBuffer
    self.direction = direction
  }
}
public struct I3CTransfer {
  public var controlBuffer: I3CControlBuffer
  public var statusBuffer: I3CControlBuffer
  public var transmitBuffer: I3CDataBuffer
  public var receiveBuffer: I3CDataBuffer
  public init(
    controlBuffer: I3CControlBuffer = .init(), statusBuffer: I3CControlBuffer = .init(),
    transmitBuffer: I3CDataBuffer = .init(), receiveBuffer: I3CDataBuffer = .init()
  ) {
    self.controlBuffer = controlBuffer
    self.statusBuffer = statusBuffer
    self.transmitBuffer = transmitBuffer
    self.receiveBuffer = receiveBuffer
  }
}
