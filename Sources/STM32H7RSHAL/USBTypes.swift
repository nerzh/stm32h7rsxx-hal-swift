// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct USBConfiguration {
  public var deviceEndpoints: UInt8
  public var hostChannels: UInt8
  public var dmaEnable: UInt8
  public var speed: UInt8
  public var endpoint0MaximumPacketSize: UInt8
  public var phyInterface: UInt8
  public var sofEnable: UInt8
  public var lowPowerEnable: UInt8
  public var lpmEnable: UInt8
  public var batteryChargingEnable: UInt8
  public var vbusSensingEnable: UInt8
  public var useDedicatedEndpoint1: UInt8
  public var useExternalVBUS: UInt8
  public init(
    deviceEndpoints: UInt8 = 0, hostChannels: UInt8 = 0, dmaEnable: UInt8 = 0, speed: UInt8 = 0,
    endpoint0MaximumPacketSize: UInt8 = 0, phyInterface: UInt8 = 0, sofEnable: UInt8 = 0,
    lowPowerEnable: UInt8 = 0, lpmEnable: UInt8 = 0, batteryChargingEnable: UInt8 = 0,
    vbusSensingEnable: UInt8 = 0, useDedicatedEndpoint1: UInt8 = 0, useExternalVBUS: UInt8 = 0
  ) {
    self.deviceEndpoints = deviceEndpoints
    self.hostChannels = hostChannels
    self.dmaEnable = dmaEnable
    self.speed = speed
    self.endpoint0MaximumPacketSize = endpoint0MaximumPacketSize
    self.phyInterface = phyInterface
    self.sofEnable = sofEnable
    self.lowPowerEnable = lowPowerEnable
    self.lpmEnable = lpmEnable
    self.batteryChargingEnable = batteryChargingEnable
    self.vbusSensingEnable = vbusSensingEnable
    self.useDedicatedEndpoint1 = useDedicatedEndpoint1
    self.useExternalVBUS = useExternalVBUS
  }
}
public enum USBEndpointField: Int, CaseIterable {
  case number = 0
  case isIn = 1
  case isStall = 2
  case isIsochronousIncomplete = 3
  case type = 4
  case dataPIDStart = 5
  case maximumPacketSize = 6
  case transferLength = 7
  case transferCount = 8
  case evenOddFrame = 9
  case transmitFIFONumber = 10
  case dmaAddress = 11
  case transferSize = 12
}
public protocol USBEndpointIO {
  func read(_ field: USBEndpointField) -> UInt32
  func write(_ field: USBEndpointField, value: UInt32)
  func readBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
public enum USBHostChannelField: Int, CaseIterable {
  case deviceAddress = 0
  case channelNumber = 1
  case endpointNumber = 2
  case endpointIsIn = 3
  case channelDirection = 4
  case speed = 5
  case doPing = 6
  case doStartSplit = 7
  case doCompleteSplit = 8
  case endpointStartSplitSchedule = 9
  case isochronousSplitTransactionPosition = 10
  case hubPortNumber = 11
  case hubAddress = 12
  case endpointType = 13
  case maximumPacketSize = 14
  case dataPID = 15
  case transferSize = 16
  case transferLength = 17
  case transferCount = 18
  case toggleIn = 19
  case toggleOut = 20
  case dmaAddress = 21
  case nakCount = 22
  case errorCount = 23
  case nyetErrorCount = 24
  case urbState = 25
  case state = 26
}
public protocol USBHostChannelIO {
  func read(_ field: USBHostChannelField) -> UInt32
  func write(_ field: USBHostChannelField, value: UInt32)
  func readBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
public struct USB<Registers: USBRegisterIO> {
  public let registers: Registers
  public let pollingTimeout: UInt32
  public let currentModeMaximumDelay: UInt32
  public let highSpeedTurnaround: UInt32
  public let defaultTurnaround: UInt32
  public init(
    registers: Registers, pollingTimeout: UInt32 = 0xF000000,
    currentModeMaximumDelay: UInt32 = 200, highSpeedTurnaround: UInt32 = 9,
    defaultTurnaround: UInt32 = 9
  ) {
    self.registers = registers
    self.pollingTimeout = pollingTimeout
    self.currentModeMaximumDelay = currentModeMaximumDelay
    self.highSpeedTurnaround = highSpeedTurnaround
    self.defaultTurnaround = defaultTurnaround
  }
  func modify(_ register: USBRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
