// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  public func getPTPConfiguration(_ configuration: UnsafeMutablePointer<ETHPTPConfiguration>?)
    -> HALStatus
  {
    guard let configuration else { return .error }
    configuration.pointee.timestamp = (registers.read(.mactscr) & (0x1))
    configuration.pointee.timestampUpdate =
      (((registers.read(.mactscr) & (0x2)) >> 3) > 0) ? 1 : 0
    configuration.pointee.timestampAll =
      (((registers.read(.mactscr) & (0x100)) >> 8) > 0) ? 1 : 0
    configuration.pointee.timestampRolloverMode =
      (((registers.read(.mactscr) & (0x200)) >> 9) > 0) ? 1 : 0
    configuration.pointee.timestampV2 =
      (((registers.read(.mactscr) & (0x400)) >> 10) > 0) ? 1 : 0
    configuration.pointee.timestampEthernet =
      (((registers.read(.mactscr) & (0x800)) >> 11) > 0) ? 1 : 0
    configuration.pointee.timestampIPv6 =
      (((registers.read(.mactscr) & (0x1000)) >> 12) > 0) ? 1 : 0
    configuration.pointee.timestampIPv4 =
      (((registers.read(.mactscr) & (0x2000)) >> 13) > 0) ? 1 : 0
    configuration.pointee.timestampEvent =
      (((registers.read(.mactscr) & (0x4000)) >> 14) > 0) ? 1 : 0
    configuration.pointee.timestampMaster =
      (((registers.read(.mactscr) & (0x8000)) >> 15) > 0) ? 1 : 0
    configuration.pointee.timestampSnapshots =
      (((registers.read(.mactscr) & (0x30000)) >> 16) > 0) ? 1 : 0
    configuration.pointee.timestampFilter =
      (((registers.read(.mactscr) & (0x40000)) >> 18) > 0) ? 1 : 0
    configuration.pointee.timestampChecksumCorrection =
      (((registers.read(.mactscr) & (0x80000)) >> 19) > 0) ? 1 : 0
    configuration.pointee.timestampStatusMode =
      (((registers.read(.mactscr) & (0x1000000)) >> 24) > 0) ? 1 : 0
    return .ok
  }
  public func setPTPConfiguration(_ configuration: UnsafePointer<ETHPTPConfiguration>?) -> HALStatus
  {
    guard let configuration else { return .error }
    modify(.macier, clear: 0x1000)
    let value: UInt32 =
      configuration.pointee.timestamp
      | (configuration.pointee.timestampUpdate << 3)
      | (configuration.pointee.timestampAll << 8)
      | (configuration.pointee.timestampRolloverMode << 9)
      | (configuration.pointee.timestampV2 << 10)
      | (configuration.pointee.timestampEthernet << 11)
      | (configuration.pointee.timestampIPv6 << 12)
      | (configuration.pointee.timestampIPv4 << 13)
      | (configuration.pointee.timestampEvent << 14)
      | (configuration.pointee.timestampMaster << 15)
      | (configuration.pointee.timestampSnapshots << 16)
      | (configuration.pointee.timestampFilter << 18)
      | (configuration.pointee.timestampStatusMode << 24)
    modify(.mactscr, clear: 0x87ff2f, set: value)
    modify(.mactscr, set: 0x1)
    registers.write(.macssir, value: configuration.pointee.timestampSubsecondInc)
    registers.write(.mactsar, value: configuration.pointee.timestampAddend)
    if configuration.pointee.timestampAddendUpdate == 1 {
      modify(.mactscr, set: 0x20)
      while registers.read(.mactscr) & 0x20 != 0 {}
    }
    if configuration.pointee.timestampUpdateMode == 1 { modify(.mactscr, set: 0x2) }
    handle.write(.isPTPConfigured, value: 0x1)
    var time = ETHTime()
    time.seconds = registers.read(.macstsr)
    time.nanoSeconds = registers.read(.macstnr)
    _ = withUnsafePointer(to: &time) { setPTPTime($0) }
    modify(.mactscr, set: 0x4)
    return .ok
  }
  public func setPTPTime(_ time: UnsafePointer<ETHTime>) -> HALStatus {
    guard handle.read(.isPTPConfigured) == 0x1 else { return .error }
    registers.write(.macstsur, value: time.pointee.seconds)
    registers.write(.macstnur, value: time.pointee.nanoSeconds)
    modify(.mactscr, set: 0x8)
    return .ok
  }
  public func getPTPTime(_ time: UnsafeMutablePointer<ETHTime>) -> HALStatus {
    guard handle.read(.isPTPConfigured) == 0x1 else { return .error }
    time.pointee.seconds = registers.read(.macstsr)
    time.pointee.nanoSeconds = registers.read(.macstnr)
    return .ok
  }
  public func addPTPTimeOffset(_ time: UnsafePointer<ETHTime>, negative: Bool) -> HALStatus {
    guard handle.read(.isPTPConfigured) == 0x1 else { return .error }
    let offset: Int32
    if negative {
      registers.write(.macstsur, value: 0xffff_ffff &- time.pointee.seconds &+ 1)
      if registers.read(.mactscr) & 0x200 == 0x200 {
        registers.write(.macstnur, value: 0xbb9a_ca00 &- time.pointee.nanoSeconds)
      } else {
        registers.write(.macstnur, value: 0xffff_ffff &- time.pointee.nanoSeconds &+ 1)
      }
      offset = Int32(bitPattern: 0 &- time.pointee.nanoSeconds)
      _ = updatePTPAddend(offset)
    } else {
      registers.write(.macstsur, value: time.pointee.seconds)
      registers.write(.macstnur, value: time.pointee.nanoSeconds)
      offset = Int32(bitPattern: time.pointee.nanoSeconds)
      _ = updatePTPAddend(offset)
    }
    modify(.mactscr, set: 0x8)
    return .ok
  }
  func updatePTPAddend(_ timeOffset: Int32) -> HALStatus {
    guard handle.read(.isPTPConfigured) == 0x1 else { return .error }
    let value = registers.read(.mactsar) &+ UInt32(bitPattern: timeOffset)
    registers.write(.mactsar, value: value)
    modify(.mactscr, set: 0x20)
    while registers.read(.mactscr) & 0x20 != 0 {}
    return .ok
  }
  public func insertTransmitPTPTimestamp() -> HALStatus {
    let index = handle.read(.currentTransmitDescriptor)
    let descriptor = handle.descriptorAddress(.transmit, index: index)
    guard handle.read(.isPTPConfigured) == 0x1 else { return .error }
    memory.write32(at: descriptor &+ 8, value: memory.read32(at: descriptor &+ 8) | 0x4000_0000)
    return .ok
  }
  public func getTransmitPTPTimestamp(_ timestamp: UnsafeMutablePointer<ETHTimestamp>) -> HALStatus
  {
    let index = handle.read(.transmitReleaseIndex)
    let descriptor = handle.descriptorAddress(.transmit, index: index)
    guard handle.read(.isPTPConfigured) == 0x1 else { return .error }
    timestamp.pointee.low = memory.read32(at: descriptor)
    timestamp.pointee.high = memory.read32(at: descriptor &+ 4)
    return .ok
  }
  public func getReceivePTPTimestamp(_ timestamp: UnsafeMutablePointer<ETHTimestamp>) -> HALStatus {
    guard handle.read(.isPTPConfigured) == 0x1 else { return .error }
    timestamp.pointee.low = handle.read(.receiveTimestampLow)
    timestamp.pointee.high = handle.read(.receiveTimestampHigh)
    return .ok
  }
}
