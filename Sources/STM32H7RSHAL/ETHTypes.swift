// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum ETHDescriptorRing: UInt32, CaseIterable, Sendable {
  case transmit = 0
  case receive = 1
}
public enum ETHHandleWord: Int, CaseIterable {
  case mediaInterface = 0
  case receiveBufferLength = 1
  case state = 2
  case errorCode = 3
  case dmaErrorCode = 4
  case macErrorCode = 5
  case macWakeUpEvent = 6
  case macLPIEvent = 7
  case isPTPConfigured = 8
  case currentTransmitDescriptor = 9
  case transmitBuffersInUse = 10
  case transmitReleaseIndex = 11
  case receiveInterruptMode = 12
  case receiveDescriptorIndex = 13
  case receiveDescriptorCount = 14
  case receiveDataLength = 15
  case receiveBuildDescriptorIndex = 16
  case receiveBuildDescriptorCount = 17
  case lastReceiveDescriptor = 18
  case transmitTimestampLow = 19
  case transmitTimestampHigh = 20
  case receiveTimestampLow = 21
  case receiveTimestampHigh = 22
}
public enum ETHHandlePointer: Int, CaseIterable {
  case macAddress = 0
  case transmitDescriptors = 1
  case receiveDescriptors = 2
  case currentTransmitPacket = 3
  case receiveStart = 4
  case receiveEnd = 5
}
public protocol ETHHandleIO {
  func read(_ word: ETHHandleWord) -> UInt32
  func write(_ word: ETHHandleWord, value: UInt32)
  func readPointer(_ pointer: ETHHandlePointer) -> UnsafeMutableRawPointer?
  func writePointer(_ pointer: ETHHandlePointer, value: UnsafeMutableRawPointer?)
  func pointerStorage(_ pointer: ETHHandlePointer) -> UnsafeMutablePointer<UnsafeMutableRawPointer?>
  func descriptorAddress(_ ring: ETHDescriptorRing, index: UInt32) -> UInt32
  func writeDescriptorAddress(_ ring: ETHDescriptorRing, index: UInt32, value: UInt32)
  func transmitPacket(index: UInt32) -> UnsafeMutablePointer<UInt32>?
  func writeTransmitPacket(index: UInt32, value: UnsafeMutablePointer<UInt32>?)
  func transmitTimestampWords() -> UnsafeMutablePointer<UInt32>
}
public protocol ETHMemoryIO {
  func read32(at address: UInt32) -> UInt32
  func write32(at address: UInt32, value: UInt32)
}
public protocol ETHPlatformIO {
  func writeGlobalETH(_ register: ETHRegister, value: UInt32)
  func enableSBSClock()
  func configureEthernetPHY(_ configuration: UInt32)
  func readSBSPeripheralMode() -> UInt32
  func dataMemoryBarrier()
  func dataSynchronizationBarrier()
  func readInterruptMask() -> UInt32
  func writeInterruptMask(_ value: UInt32)
}
@frozen public struct ETHBuffer {
  public var buffer: UnsafeMutablePointer<UInt8>?
  public var length: UInt32
  public var next: UnsafeMutablePointer<ETHBuffer>?
  public init(
    buffer: UnsafeMutablePointer<UInt8>? = nil, length: UInt32 = 0,
    next: UnsafeMutablePointer<ETHBuffer>? = nil
  ) {
    self.buffer = buffer
    self.length = length
    self.next = next
  }
}
public struct ETHTransmitPacketConfiguration {
  public var attributes: UInt32
  public var length: UInt32
  public var buffer: UnsafeMutablePointer<ETHBuffer>?
  public var sourceAddressControl: UInt32
  public var crcPadControl: UInt32
  public var checksumControl: UInt32
  public var maximumSegmentSize: UInt32
  public var payloadLength: UInt32
  public var tcpHeaderLength: UInt32
  public var vlanTag: UInt32
  public var vlanControl: UInt32
  public var innerVLANTag: UInt32
  public var innerVLANControl: UInt32
  public var applicationData: UnsafeMutableRawPointer?
  public init(
    attributes: UInt32 = 0, length: UInt32 = 0, buffer: UnsafeMutablePointer<ETHBuffer>? = nil,
    sourceAddressControl: UInt32 = 0, crcPadControl: UInt32 = 0, checksumControl: UInt32 = 0,
    maximumSegmentSize: UInt32 = 0, payloadLength: UInt32 = 0, tcpHeaderLength: UInt32 = 0,
    vlanTag: UInt32 = 0, vlanControl: UInt32 = 0, innerVLANTag: UInt32 = 0,
    innerVLANControl: UInt32 = 0,
    applicationData: UnsafeMutableRawPointer? = nil
  ) {
    self.attributes = attributes
    self.length = length
    self.buffer = buffer
    self.sourceAddressControl = sourceAddressControl
    self.crcPadControl = crcPadControl
    self.checksumControl = checksumControl
    self.maximumSegmentSize = maximumSegmentSize
    self.payloadLength = payloadLength
    self.tcpHeaderLength = tcpHeaderLength
    self.vlanTag = vlanTag
    self.vlanControl = vlanControl
    self.innerVLANTag = innerVLANTag
    self.innerVLANControl = innerVLANControl
    self.applicationData = applicationData
  }
}
public typealias ETHCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias ETHReceiveAllocateCallback =
  @convention(c) (UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>?) -> Void
public typealias ETHReceiveLinkCallback =
  @convention(c) (
    UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
    UnsafeMutablePointer<UnsafeMutableRawPointer?>?, UnsafeMutablePointer<UInt8>?, UInt16
  ) -> Void
public typealias ETHTransmitFreeCallback = @convention(c) (UnsafeMutablePointer<UInt32>?) -> Void
public typealias ETHTransmitPTPCallback =
  @convention(c) (UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<UInt32>?) -> Void
public enum ETHCallbackID: UInt32, CaseIterable {
  case mspInitialize = 0
  case mspDeinitialize = 1
  case transmitComplete = 2
  case receiveComplete = 3
  case error = 4
  case powerManagement = 6
  case energyEfficientEthernet = 7
  case wakeUp = 8
}
public protocol ETHCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: ETHCallbackID) -> ETHCallback?
  func write(_ id: ETHCallbackID, value: ETHCallback?)
  func readReceiveAllocate() -> ETHReceiveAllocateCallback?
  func writeReceiveAllocate(_ value: ETHReceiveAllocateCallback?)
  func readReceiveLink() -> ETHReceiveLinkCallback?
  func writeReceiveLink(_ value: ETHReceiveLinkCallback?)
  func readTransmitFree() -> ETHTransmitFreeCallback?
  func writeTransmitFree(_ value: ETHTransmitFreeCallback?)
  func readTransmitPTP() -> ETHTransmitPTPCallback?
  func writeTransmitPTP(_ value: ETHTransmitPTPCallback?)
}
public struct ETHCallbackDefaults {
  public let mspInitialize: ETHCallback
  public let mspDeinitialize: ETHCallback
  public let transmitComplete: ETHCallback
  public let receiveComplete: ETHCallback
  public let error: ETHCallback
  public let powerManagement: ETHCallback
  public let energyEfficientEthernet: ETHCallback
  public let wakeUp: ETHCallback
  public let receiveAllocate: ETHReceiveAllocateCallback
  public let receiveLink: ETHReceiveLinkCallback
  public let transmitFree: ETHTransmitFreeCallback
  public let transmitPTP: ETHTransmitPTPCallback
  public init(
    mspInitialize: @escaping ETHCallback, mspDeinitialize: @escaping ETHCallback,
    transmitComplete: @escaping ETHCallback, receiveComplete: @escaping ETHCallback,
    error: @escaping ETHCallback, powerManagement: @escaping ETHCallback,
    energyEfficientEthernet: @escaping ETHCallback, wakeUp: @escaping ETHCallback,
    receiveAllocate: @escaping ETHReceiveAllocateCallback,
    receiveLink: @escaping ETHReceiveLinkCallback, transmitFree: @escaping ETHTransmitFreeCallback,
    transmitPTP: @escaping ETHTransmitPTPCallback
  ) {
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.transmitComplete = transmitComplete
    self.receiveComplete = receiveComplete
    self.error = error
    self.powerManagement = powerManagement
    self.energyEfficientEthernet = energyEfficientEthernet
    self.wakeUp = wakeUp
    self.receiveAllocate = receiveAllocate
    self.receiveLink = receiveLink
    self.transmitFree = transmitFree
    self.transmitPTP = transmitPTP
  }
  func callback(_ id: ETHCallbackID) -> ETHCallback {
    switch id {
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    case .transmitComplete: return transmitComplete
    case .receiveComplete: return receiveComplete
    case .error: return error
    case .powerManagement: return powerManagement
    case .energyEfficientEthernet: return energyEfficientEthernet
    case .wakeUp: return wakeUp
    }
  }
}
public struct ETH<
  Registers: ETHRegisterIO, Handle: ETHHandleIO, Callbacks: ETHCallbackIO,
  Memory: ETHMemoryIO, Platform: ETHPlatformIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let memory: Memory
  public let platform: Platform
  public let defaults: ETHCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public let usePTP: Bool
  public let transmitDescriptorCount: UInt32
  public let receiveDescriptorCount: UInt32
  public let softwareResetTimeout: UInt32
  public let mdioBusTimeout: UInt32
  public let macMicrosecondTick: UInt32
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, memory: Memory, platform: Platform,
    defaults: ETHCallbackDefaults, useRegisteredCallbacks: Bool = false, usePTP: Bool = false,
    transmitDescriptorCount: UInt32 = 4, receiveDescriptorCount: UInt32 = 4,
    softwareResetTimeout: UInt32 = 500, mdioBusTimeout: UInt32 = 1000,
    macMicrosecondTick: UInt32 = 1_000_000
  ) {
    precondition(
      transmitDescriptorCount > 0 && receiveDescriptorCount > 0 && macMicrosecondTick > 0)
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.memory = memory
    self.platform = platform
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
    self.usePTP = usePTP
    self.transmitDescriptorCount = transmitDescriptorCount
    self.receiveDescriptorCount = receiveDescriptorCount
    self.softwareResetTimeout = softwareResetTimeout
    self.mdioBusTimeout = mdioBusTimeout
    self.macMicrosecondTick = macMicrosecondTick
  }
}
