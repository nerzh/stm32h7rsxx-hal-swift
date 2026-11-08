// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  public func enableARPOffload() { modify(.maccr, set: 0x8000_0000) }
  public func disableARPOffload() { modify(.maccr, clear: 0x8000_0000) }
  public func setARPAddressMatch(_ address: UInt32) { registers.write(.macarpar, value: address) }
  public func enableLayer3Layer4Filtering() { modify(.macpfr, set: 0x100000) }
  public func disableLayer3Layer4Filtering() { modify(.macpfr, clear: 0x100000) }
  public func enableVLANProcessing() { modify(.macpfr, set: 0x10000) }
  public func disableVLANProcessing() { modify(.macpfr, clear: 0x10000) }
  public func setVLANHashTable(_ table: UInt32) { modify(.macvhtr, clear: 0xFFFF, set: table) }
  public func setTransmitVLANIdentifier(tag: UInt32, identifier: UInt32) {
    modify(tag == 0x1 ? .macivir : .macvir, clear: 0xFFFF, set: identifier)
  }
  public func enterLPIMode(transmitAutomate: UInt32, transmitClockStop: UInt32) {
    enableMACInterrupts(0x20)
    modify(
      .maclcsr, clear: 0x10000 | 0x80000 | 0x200000,
      set: (transmitAutomate << 19) | (transmitClockStop << 21) | 0x10000)
  }
  public func exitLPIMode() {
    modify(.maclcsr, clear: 0x10000 | 0x80000 | 0x200000)
    disableMACInterrupts(0x20)
  }
  public func setLayer3FilterConfiguration(
    _ configuration: UnsafePointer<ETHLayer3FilterConfiguration>?, filter: UInt32
  ) -> HALStatus {
    guard let configuration else { return .error }
    modify(
      filter == 0 ? .macl3l4c0r : .macl3l4c1r, clear: 0xFFFD,
      set: configuration.pointee.protocolSelection | configuration.pointee.srcAddrFilterMatch
        | configuration.pointee.destAddrFilterMatch
        | (configuration.pointee.srcAddrHigherBitsMatch << 6)
        | (configuration.pointee.destAddrHigherBitsMatch << 11))
    if filter == 0 {
      if configuration.pointee.protocolSelection != 0x0 {
        registers.write(.macl3a0r0r, value: configuration.pointee.ipv6Address[0])
        registers.write(.macl3a1r0r, value: configuration.pointee.ipv6Address[1])
        registers.write(.macl3a2r0r, value: configuration.pointee.ipv6Address[2])
        registers.write(.macl3a3r0r, value: configuration.pointee.ipv6Address[3])
      } else {
        registers.write(.macl3a0r0r, value: configuration.pointee.ipv4SourceAddress)
        registers.write(.macl3a1r0r, value: configuration.pointee.ipv4DestinationAddress)
      }
    } else {
      if configuration.pointee.protocolSelection != 0x0 {
        registers.write(.macl3a0r1r, value: configuration.pointee.ipv6Address[0])
        registers.write(.macl3a1r1r, value: configuration.pointee.ipv6Address[1])
        registers.write(.macl3a1r1r, value: configuration.pointee.ipv6Address[2])
        registers.write(.macl3a1r1r, value: configuration.pointee.ipv6Address[3])
      } else {
        registers.write(.macl3a0r1r, value: configuration.pointee.ipv4SourceAddress)
        registers.write(.macl3a0r1r, value: configuration.pointee.ipv4DestinationAddress)
      }
    }
    modify(.macpfr, set: 0x100000)
    return .ok
  }
  public func getLayer3FilterConfiguration(
    _ configuration: UnsafeMutablePointer<ETHLayer3FilterConfiguration>?, filter: UInt32
  ) -> HALStatus {
    guard let configuration else { return .error }
    configuration.pointee.protocolSelection =
      (registers.read(ETHRegister(rawValue: ETHRegister.macl3l4c0r.rawValue &+ (filter &* 4)))
        & (0x1))
    configuration.pointee.srcAddrFilterMatch =
      (registers.read(ETHRegister(rawValue: ETHRegister.macl3l4c0r.rawValue &+ (filter &* 4)))
        & (0x4 | 0x8))
    configuration.pointee.destAddrFilterMatch =
      (registers.read(ETHRegister(rawValue: ETHRegister.macl3l4c0r.rawValue &+ (filter &* 4)))
        & (0x10 | 0x20))
    configuration.pointee.srcAddrHigherBitsMatch =
      (registers.read(ETHRegister(rawValue: ETHRegister.macl3l4c0r.rawValue &+ (filter &* 4)))
        & (0x7C0)) >> 6
    configuration.pointee.destAddrHigherBitsMatch =
      (registers.read(ETHRegister(rawValue: ETHRegister.macl3l4c0r.rawValue &+ (filter &* 4)))
        & (0xF800)) >> 11
    if filter == 0 {
      if configuration.pointee.protocolSelection != 0x0 {
        configuration.pointee.ipv6Address[0] = registers.read(.macl3a0r0r)
        configuration.pointee.ipv6Address[1] = registers.read(.macl3a1r0r)
        configuration.pointee.ipv6Address[2] = registers.read(.macl3a2r0r)
        configuration.pointee.ipv6Address[3] = registers.read(.macl3a3r0r)
      } else {
        configuration.pointee.ipv4SourceAddress = registers.read(.macl3a0r0r)
        configuration.pointee.ipv4DestinationAddress = registers.read(.macl3a1r0r)
      }
    } else {
      if configuration.pointee.protocolSelection != 0x0 {
        configuration.pointee.ipv6Address[0] = registers.read(.macl3a0r1r)
        configuration.pointee.ipv6Address[1] = registers.read(.macl3a1r1r)
        configuration.pointee.ipv6Address[2] = registers.read(.macl3a2r1r)
        configuration.pointee.ipv6Address[3] = registers.read(.macl3a3r1r)
      } else {
        configuration.pointee.ipv4SourceAddress = registers.read(.macl3a0r1r)
        configuration.pointee.ipv4DestinationAddress = registers.read(.macl3a1r1r)
      }
    }
    return .ok
  }
  public func setLayer4FilterConfiguration(
    _ configuration: UnsafePointer<ETHLayer4FilterConfiguration>?, filter: UInt32
  ) -> HALStatus {
    guard let configuration else { return .error }
    modify(
      filter == 0 ? .macl3l4c0r : .macl3l4c1r, clear: 0x3D0000,
      set: configuration.pointee.protocolSelection | configuration.pointee.srcPortFilterMatch
        | configuration.pointee.destPortFilterMatch)
    registers.write(
      filter == 0 ? .macl4a0r : .macl4a1r,
      value: configuration.pointee.sourcePort | (configuration.pointee.destinationPort << 16))
    modify(.macpfr, set: 0x100000)
    return .ok
  }
  public func getLayer4FilterConfiguration(
    _ configuration: UnsafeMutablePointer<ETHLayer4FilterConfiguration>?, filter: UInt32
  ) -> HALStatus {
    guard let configuration else { return .error }
    configuration.pointee.protocolSelection =
      (registers.read((filter == 0 ? ETHRegister.macl3l4c0r : ETHRegister.macl3l4c1r)) & (0x10000))
    configuration.pointee.destPortFilterMatch =
      (registers.read((filter == 0 ? ETHRegister.macl3l4c0r : ETHRegister.macl3l4c1r))
        & (0x100000 | 0x200000))
    configuration.pointee.srcPortFilterMatch =
      (registers.read((filter == 0 ? ETHRegister.macl3l4c0r : ETHRegister.macl3l4c1r))
        & (0x40000 | 0x80000))
    configuration.pointee.destinationPort =
      (registers.read(filter == 0 ? .macl4a0r : .macl4a1r) & 0xFFFF_0000) >> 16
    configuration.pointee.sourcePort = registers.read(filter == 0 ? .macl4a0r : .macl4a1r) & 0xFFFF
    return .ok
  }
  public func getReceiveVLANConfiguration(
    _ configuration: UnsafeMutablePointer<ETHReceiveVLANConfiguration>?
  ) -> HALStatus {
    guard let configuration else { return .error }
    configuration.pointee.innerVLANTagInStatus =
      (registers.read(.macvtr) & (0x8000_0000)) >> 31 == 0 ? 0 : 1
    configuration.pointee.stripInnerVLANTag = (registers.read(.macvtr) & (0x3000_0000))
    configuration.pointee.innerVLANTag = (registers.read(.macvtr) & (0x8000000)) >> 27 == 0 ? 0 : 1
    configuration.pointee.doubleVLANProcessing =
      (registers.read(.macvtr) & (0x4000000)) >> 26 == 0 ? 0 : 1
    configuration.pointee.vlanTagHashTableMatch =
      (registers.read(.macvtr) & (0x2000000)) >> 25 == 0 ? 0 : 1
    configuration.pointee.vlanTagInStatus =
      (registers.read(.macvtr) & (0x1000000)) >> 24 == 0 ? 0 : 1
    configuration.pointee.stripVLANTag = (registers.read(.macvtr) & (0x600000))
    configuration.pointee.vlanTypeCheck = (registers.read(.macvtr) & (0x100000 | 0x80000 | 0x40000))
    configuration.pointee.vlanTagInverseMatch =
      (registers.read(.macvtr) & (0x20000)) >> 17 == 0 ? 0 : 1
    return .ok
  }
  public func setReceiveVLANConfiguration(
    _ configuration: UnsafePointer<ETHReceiveVLANConfiguration>?
  ) -> HALStatus {
    guard let configuration else { return .error }
    modify(
      .macvtr, clear: 0xBF7F_0000,
      set: (configuration.pointee.innerVLANTagInStatus << 31)
        | configuration.pointee.stripInnerVLANTag | (configuration.pointee.innerVLANTag << 27)
        | (configuration.pointee.doubleVLANProcessing << 26)
        | (configuration.pointee.vlanTagHashTableMatch << 25)
        | (configuration.pointee.vlanTagInStatus << 24) | configuration.pointee.stripVLANTag
        | configuration.pointee.vlanTypeCheck | (configuration.pointee.vlanTagInverseMatch << 17))
    return .ok
  }
  public func getTransmitVLANConfiguration(
    _ configuration: UnsafeMutablePointer<ETHTransmitVLANConfiguration>?, tag: UInt32
  ) -> HALStatus {
    guard let configuration else { return .error }
    configuration.pointee.sourceTxDesc =
      (registers.read(tag == 0x1 ? .macivir : .macvir) & (0x100000)) >> 20 == 0 ? 0 : 1
    configuration.pointee.svlanType =
      (registers.read(tag == 0x1 ? .macivir : .macvir) & (0x80000)) >> 19 == 0 ? 0 : 1
    configuration.pointee.vlanTagControl =
      (registers.read(tag == 0x1 ? .macivir : .macvir) & (0x40000 | 0x30000))
    return .ok
  }
  public func setTransmitVLANConfiguration(
    _ configuration: UnsafePointer<ETHTransmitVLANConfiguration>, tag: UInt32
  ) -> HALStatus {
    modify(
      tag == 0x1 ? .macivir : .macvir, clear: 0x1F0000,
      set: (configuration.pointee.sourceTxDesc << 20) | (configuration.pointee.svlanType << 19)
        | configuration.pointee.vlanTagControl)
    if tag == 0x1 { modify(.macvtr, set: 0x4000000) }
    return .ok
  }
}
