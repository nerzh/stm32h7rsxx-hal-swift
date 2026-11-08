// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  public func getMACConfiguration(_ configuration: UnsafeMutablePointer<ETHMACConfiguration>?)
    -> HALStatus
  {
    guard let configuration else { return .error }
    configuration.pointee.preambleLength = (registers.read(.maccr) & (0xc))
    configuration.pointee.deferralCheck = (((registers.read(.maccr) & (0x10)) >> 4) > 0) ? 1 : 0
    configuration.pointee.backOffLimit = (registers.read(.maccr) & (0x60))
    configuration.pointee.retryTransmission =
      (((registers.read(.maccr) & (0x100)) >> 8) == 0) ? 1 : 0
    configuration.pointee.carrierSenseDuringTransmit =
      (((registers.read(.maccr) & (0x200)) >> 9) > 0) ? 1 : 0
    configuration.pointee.receiveOwn = (((registers.read(.maccr) & (0x400)) >> 10) == 0) ? 1 : 0
    configuration.pointee.carrierSenseBeforeTransmit =
      (((registers.read(.maccr) & (0x800)) >> 11) > 0) ? 1 : 0
    configuration.pointee.loopbackMode = (((registers.read(.maccr) & (0x1000)) >> 12) > 0) ? 1 : 0
    configuration.pointee.duplexMode = (registers.read(.maccr) & (0x2000))
    configuration.pointee.speed = (registers.read(.maccr) & (0x4000))
    configuration.pointee.jumboPacket = (((registers.read(.maccr) & (0x10000)) >> 16) > 0) ? 1 : 0
    configuration.pointee.jabber = (((registers.read(.maccr) & (0x20000)) >> 17) == 0) ? 1 : 0
    configuration.pointee.watchdog = (((registers.read(.maccr) & (0x80000)) >> 19) == 0) ? 1 : 0
    configuration.pointee.automaticPadCRCStrip =
      (((registers.read(.maccr) & (0x100000)) >> 20) > 0) ? 1 : 0
    configuration.pointee.crcStripTypePacket =
      (((registers.read(.maccr) & (0x200000)) >> 21) > 0) ? 1 : 0
    configuration.pointee.support2KPacket =
      (((registers.read(.maccr) & (0x400000)) >> 22) > 0) ? 1 : 0
    configuration.pointee.giantPacketSizeLimitControl =
      (((registers.read(.maccr) & (0x800000)) >> 23) > 0) ? 1 : 0
    configuration.pointee.interPacketGapVal = (registers.read(.maccr) & (0x7000000))
    configuration.pointee.checksumOffload =
      (((registers.read(.maccr) & (0x8000000)) >> 27) > 0) ? 1 : 0
    configuration.pointee.sourceAddrControl = (registers.read(.maccr) & (0x7000_0000))
    configuration.pointee.giantPacketSizeLimit = (registers.read(.macecr) & (0x3fff))
    configuration.pointee.crcCheckingRxPackets =
      (((registers.read(.macecr) & (0x10000)) >> 16) == 0) ? 1 : 0
    configuration.pointee.slowProtocolDetect =
      (((registers.read(.macecr) & (0x20000)) >> 17) > 0) ? 1 : 0
    configuration.pointee.unicastSlowProtocolPacketDetect =
      (((registers.read(.macecr) & (0x40000)) >> 18) > 0) ? 1 : 0
    configuration.pointee.extendedInterPacketGap =
      (((registers.read(.macecr) & (0x1000000)) >> 24) > 0) ? 1 : 0
    configuration.pointee.extendedInterPacketGapVal =
      (registers.read(.macecr) & (0x3e00_0000)) >> 25
    configuration.pointee.programmableWatchdog =
      (((registers.read(.macwtr) & (0x100)) >> 8) > 0) ? 1 : 0
    configuration.pointee.watchdogTimeout = (registers.read(.macwtr) & (0xf))
    configuration.pointee.transmitFlowControl =
      (((registers.read(.mactfcr) & (0x2)) >> 1) > 0) ? 1 : 0
    configuration.pointee.zeroQuantaPause =
      (((registers.read(.mactfcr) & (0x80)) >> 7) == 0) ? 1 : 0
    configuration.pointee.pauseLowThreshold = (registers.read(.mactfcr) & (0x70))
    configuration.pointee.pauseTime = ((registers.read(.mactfcr) & (0xffff_0000)) >> 16)
    configuration.pointee.receiveFlowControl = ((registers.read(.macrfcr) & (0x1)) > 0) ? 1 : 0
    configuration.pointee.unicastPausePacketDetect =
      (((registers.read(.macrfcr) & (0x2)) >> 1) > 0) ? 1 : 0
    configuration.pointee.transmitQueueMode = (registers.read(.mtltqomr) & ((0x70 | 0x2)))
    configuration.pointee.receiveQueueMode = (registers.read(.mtlrqomr) & ((0x3 | 0x20)))
    configuration.pointee.forwardRxUndersizedGoodPacket =
      (((registers.read(.mtlrqomr) & (0x8)) >> 3) > 0) ? 1 : 0
    configuration.pointee.forwardRxErrorPacket =
      (((registers.read(.mtlrqomr) & (0x10)) >> 4) > 0) ? 1 : 0
    configuration.pointee.dropTCPIPChecksumErrorPacket =
      (((registers.read(.mtlrqomr) & (0x40)) >> 6) == 0) ? 1 : 0
    return .ok
  }
  public func getDMAConfiguration(_ configuration: UnsafeMutablePointer<ETHDMAConfiguration>?)
    -> HALStatus
  {
    guard let configuration else { return .error }
    configuration.pointee.addressAlignedBeats =
      (((registers.read(.dmasbmr) & (0x1000)) >> 12) > 0) ? 1 : 0
    configuration.pointee.burstMode = (registers.read(.dmasbmr) & (0x1 | 0x4000))
    configuration.pointee.rebuildINCRxBurst =
      (((registers.read(.dmasbmr) & (0x8000)) >> 15) > 0) ? 1 : 0
    configuration.pointee.dmaArbitration = (registers.read(.dmamr) & ((0x800 | 0x7000 | 0x2)))
    configuration.pointee.pbLx8Mode = (((registers.read(.dmaccr) & (0x10000)) >> 16) > 0) ? 1 : 0
    configuration.pointee.maximumSegmentSize = (registers.read(.dmaccr) & (0x3fff))
    configuration.pointee.flushRxPacket =
      (((registers.read(.dmacrcr) & (0x8000_0000)) >> 31) > 0) ? 1 : 0
    configuration.pointee.rxDMABurstLength = (registers.read(.dmacrcr) & (0x3f0000))
    configuration.pointee.secondPacketOperate =
      (((registers.read(.dmactcr) & (0x10)) >> 4) > 0) ? 1 : 0
    configuration.pointee.tcpSegmentation =
      (((registers.read(.dmactcr) & (0x1000)) >> 12) > 0) ? 1 : 0
    configuration.pointee.txDMABurstLength = (registers.read(.dmactcr) & (0x3f0000))
    return .ok
  }
  public func getMACFilterConfiguration(
    _ configuration: UnsafeMutablePointer<ETHMACFilterConfiguration>?
  ) -> HALStatus {
    guard let configuration else { return .error }
    configuration.pointee.promiscuousMode = (((registers.read(.macpfr) & (0x1))) > 0) ? 1 : 0
    configuration.pointee.hashUnicast = (((registers.read(.macpfr) & (0x2)) >> 1) > 0) ? 1 : 0
    configuration.pointee.hashMulticast = (((registers.read(.macpfr) & (0x4)) >> 2) > 0) ? 1 : 0
    configuration.pointee.destAddrInverseFiltering =
      (((registers.read(.macpfr) & (0x8)) >> 3) > 0) ? 1 : 0
    configuration.pointee.passAllMulticast = (((registers.read(.macpfr) & (0x10)) >> 4) > 0) ? 1 : 0
    configuration.pointee.broadcastFilter = (((registers.read(.macpfr) & (0x20)) >> 5) > 0) ? 1 : 0
    configuration.pointee.controlPacketsFilter = (registers.read(.macpfr) & (0xc0))
    configuration.pointee.srcAddrInverseFiltering =
      (((registers.read(.macpfr) & (0x100)) >> 8) > 0) ? 1 : 0
    configuration.pointee.srcAddrFiltering =
      (((registers.read(.macpfr) & (0x200)) >> 9) > 0) ? 1 : 0
    configuration.pointee.hashOrPerfectFilter =
      (((registers.read(.macpfr) & (0x400)) >> 10) > 0) ? 1 : 0
    configuration.pointee.receiveAllMode =
      (((registers.read(.macpfr) & (0x8000_0000)) >> 31) > 0) ? 1 : 0
    return .ok
  }
  public func setMACConfiguration(_ configuration: UnsafePointer<ETHMACConfiguration>?) -> HALStatus
  {
    guard let configuration else { return .error }
    guard handle.read(.state) == 0x10 else { return .error }
    applyMACConfiguration(configuration)
    return .ok
  }
  func applyMACConfiguration(_ configuration: UnsafePointer<ETHMACConfiguration>) {
    var value: UInt32
    value =
      (configuration.pointee.interPacketGapVal | configuration.pointee.sourceAddrControl
        | (configuration.pointee.checksumOffload << 27)
        | (configuration.pointee.giantPacketSizeLimitControl << 23)
        | (configuration.pointee.support2KPacket << 22)
        | (configuration.pointee.crcStripTypePacket << 21)
        | (configuration.pointee.automaticPadCRCStrip << 20)
        | (((configuration.pointee.watchdog == 0) ? 1 : 0) << 19)
        | (((configuration.pointee.jabber == 0) ? 1 : 0) << 17)
        | (configuration.pointee.jumboPacket << 16) | configuration.pointee.speed
        | configuration.pointee.duplexMode | (configuration.pointee.loopbackMode << 12)
        | (configuration.pointee.carrierSenseBeforeTransmit << 11)
        | (((configuration.pointee.receiveOwn == 0) ? 1 : 0) << 10)
        | (configuration.pointee.carrierSenseDuringTransmit << 9)
        | (((configuration.pointee.retryTransmission == 0) ? 1 : 0) << 8)
        | configuration.pointee.backOffLimit | (configuration.pointee.deferralCheck << 4)
        | configuration.pointee.preambleLength)
    modify(.maccr, clear: 0xfffb_7f7c, set: value)
    value =
      ((configuration.pointee.extendedInterPacketGapVal << 25)
        | (configuration.pointee.extendedInterPacketGap << 24)
        | (configuration.pointee.unicastSlowProtocolPacketDetect << 18)
        | (configuration.pointee.slowProtocolDetect << 17)
        | (((configuration.pointee.crcCheckingRxPackets == 0) ? 1 : 0) << 16)
        | configuration.pointee.giantPacketSizeLimit)
    modify(.macecr, clear: 0x3f07_7fff, set: value)
    value =
      ((configuration.pointee.programmableWatchdog << 8) | configuration.pointee.watchdogTimeout)
    modify(.macwtr, clear: 0x10f, set: value)
    value =
      ((configuration.pointee.transmitFlowControl << 1) | configuration.pointee.pauseLowThreshold
        | (((configuration.pointee.zeroQuantaPause == 0) ? 1 : 0) << 7)
        | (configuration.pointee.pauseTime << 16))
    modify(.mactfcr, clear: 0xffff_00f2, set: value)
    value =
      (configuration.pointee.receiveFlowControl
        | (configuration.pointee.unicastPausePacketDetect << 1))
    modify(.macrfcr, clear: 0x3, set: value)
    modify(.mtltqomr, clear: 0x72, set: configuration.pointee.transmitQueueMode)
    value =
      (configuration.pointee.receiveQueueMode
        | (((configuration.pointee.dropTCPIPChecksumErrorPacket == 0) ? 1 : 0) << 6)
        | (configuration.pointee.forwardRxErrorPacket << 4)
        | (configuration.pointee.forwardRxUndersizedGoodPacket << 3))
    modify(.mtlrqomr, clear: 0x7b, set: value)
  }
  public func setDMAConfiguration(_ configuration: UnsafePointer<ETHDMAConfiguration>?) -> HALStatus
  {
    guard let configuration else { return .error }
    guard handle.read(.state) == 0x10 else { return .error }
    applyDMAConfiguration(configuration)
    return .ok
  }
  func applyDMAConfiguration(_ configuration: UnsafePointer<ETHDMAConfiguration>) {
    var value: UInt32
    modify(.dmamr, clear: 0x7802, set: configuration.pointee.dmaArbitration)
    value =
      ((configuration.pointee.addressAlignedBeats << 12) | configuration.pointee.burstMode
        | (configuration.pointee.rebuildINCRxBurst << 15))
    modify(.dmasbmr, clear: 0xd001, set: value)
    value = ((configuration.pointee.pbLx8Mode << 16) | configuration.pointee.maximumSegmentSize)
    modify(.dmaccr, clear: 0x13fff, set: value)
    value =
      (configuration.pointee.txDMABurstLength | (configuration.pointee.secondPacketOperate << 4)
        | (configuration.pointee.tcpSegmentation << 12))
    modify(.dmactcr, clear: 0x3f1010, set: value)
    value = ((configuration.pointee.flushRxPacket << 31) | configuration.pointee.rxDMABurstLength)
    modify(.dmacrcr, clear: 0x803f_0000, set: value)
  }
  func applyDefaultMACDMAConfiguration() {
    var macDefaultConf = ETHMACConfiguration()
    macDefaultConf.automaticPadCRCStrip = 1
    macDefaultConf.backOffLimit = 0x0
    macDefaultConf.carrierSenseBeforeTransmit = 0
    macDefaultConf.carrierSenseDuringTransmit = 0
    macDefaultConf.checksumOffload = 1
    macDefaultConf.crcCheckingRxPackets = 1
    macDefaultConf.crcStripTypePacket = 1
    macDefaultConf.deferralCheck = 0
    macDefaultConf.dropTCPIPChecksumErrorPacket = 1
    macDefaultConf.duplexMode = 0x2000
    macDefaultConf.extendedInterPacketGap = 0
    macDefaultConf.extendedInterPacketGapVal = 0x0
    macDefaultConf.forwardRxErrorPacket = 0
    macDefaultConf.forwardRxUndersizedGoodPacket = 0
    macDefaultConf.giantPacketSizeLimit = 0x618
    macDefaultConf.giantPacketSizeLimitControl = 0
    macDefaultConf.interPacketGapVal = 0x0
    macDefaultConf.jabber = 1
    macDefaultConf.jumboPacket = 0
    macDefaultConf.loopbackMode = 0
    macDefaultConf.pauseLowThreshold = 0x0
    macDefaultConf.pauseTime = 0x0
    macDefaultConf.preambleLength = 0x0
    macDefaultConf.programmableWatchdog = 0
    macDefaultConf.receiveFlowControl = 0
    macDefaultConf.receiveOwn = 1
    macDefaultConf.receiveQueueMode = 0x20
    macDefaultConf.retryTransmission = 1
    macDefaultConf.slowProtocolDetect = 0
    macDefaultConf.sourceAddrControl = 0x3000_0000
    macDefaultConf.speed = 0x4000
    macDefaultConf.support2KPacket = 0
    macDefaultConf.transmitQueueMode = 0x2
    macDefaultConf.transmitFlowControl = 0
    macDefaultConf.unicastPausePacketDetect = 0
    macDefaultConf.unicastSlowProtocolPacketDetect = 0
    macDefaultConf.watchdog = 1
    macDefaultConf.watchdogTimeout = 0x0
    macDefaultConf.zeroQuantaPause = 1
    withUnsafePointer(to: &macDefaultConf) { applyMACConfiguration($0) }
    var dmaDefaultConf = ETHDMAConfiguration()
    dmaDefaultConf.addressAlignedBeats = 1
    dmaDefaultConf.burstMode = 0x1
    dmaDefaultConf.dmaArbitration = 0x0
    dmaDefaultConf.flushRxPacket = 0
    dmaDefaultConf.pbLx8Mode = 0
    dmaDefaultConf.rebuildINCRxBurst = 0
    dmaDefaultConf.rxDMABurstLength = 0x200000
    dmaDefaultConf.secondPacketOperate = 0
    dmaDefaultConf.txDMABurstLength = 0x200000
    dmaDefaultConf.tcpSegmentation = 0
    dmaDefaultConf.maximumSegmentSize = 0x218
    withUnsafePointer(to: &dmaDefaultConf) { applyDMAConfiguration($0) }
  }
  public func setMACFilterConfiguration(_ configuration: UnsafePointer<ETHMACFilterConfiguration>?)
    -> HALStatus
  {
    guard let configuration else { return .error }
    let value: UInt32 =
      (configuration.pointee.promiscuousMode | (configuration.pointee.hashUnicast << 1)
        | (configuration.pointee.hashMulticast << 2)
        | (configuration.pointee.destAddrInverseFiltering << 3)
        | (configuration.pointee.passAllMulticast << 4)
        | (((configuration.pointee.broadcastFilter == 1) ? 1 : 0) << 5)
        | (configuration.pointee.srcAddrInverseFiltering << 8)
        | (configuration.pointee.srcAddrFiltering << 9)
        | (configuration.pointee.hashOrPerfectFilter << 10)
        | (configuration.pointee.receiveAllMode << 31) | configuration.pointee.controlPacketsFilter)
    modify(.macpfr, clear: 0x8000_07ff, set: value)
    return .ok
  }
  public func setMDIOClockRange(getHCLKFrequency: () -> UInt32) {
    var value = registers.read(.macmdioar) & ~0xf00
    let hclk = getHCLKFrequency()
    if hclk < 35_000_000 {
      value |= 0x200
    } else if hclk < 60_000_000 {
      value |= 0x300
    } else if hclk < 100_000_000 {
      value |= 0x0
    } else if hclk < 150_000_000 {
      value |= 0x100
    } else if hclk < 250_000_000 {
      value |= 0x400
    } else {
      value |= 0x500
    }
    registers.write(.macmdioar, value: value)
  }
  public func setHashTable(_ table: UnsafePointer<UInt32>?) -> HALStatus {
    guard let table else { return .error }
    registers.write(.macht0r, value: table[0])
    registers.write(.macht1r, value: table[1])
    return .ok
  }
  public func setSourceMACAddressMatch(_ address: UnsafePointer<UInt8>?, number: UInt32)
    -> HALStatus
  {
    guard let address else { return .error }
    let high = ETHRegister(rawValue: ETHRegister.maca0hr.rawValue &+ number)
    let low = ETHRegister(rawValue: ETHRegister.maca0lr.rawValue &+ number)
    registers.write(high, value: (UInt32(address[5]) << 8) | UInt32(address[4]))
    registers.write(
      low,
      value: (UInt32(address[3]) << 24) | (UInt32(address[2]) << 16) | (UInt32(address[1]) << 8)
        | UInt32(address[0]))
    modify(high, set: 0x4000_0000 | 0x8000_0000)
    return .ok
  }
  public func setReceiveVLANIdentifier(comparisonBits: UInt32, identifier: UInt32) {
    if comparisonBits == 0x0 {
      modify(.macvtr, clear: 0xffff, set: identifier)
      modify(.macvtr, clear: 0x10000)
    } else {
      modify(.macvtr, clear: 0xfff, set: identifier)
      modify(.macvtr, set: 0x10000)
    }
  }
  public func enterPowerDownMode(_ configuration: UnsafePointer<ETHPowerDownConfiguration>) {
    let value =
      (configuration.pointee.magicPacket << 1) | (configuration.pointee.wakeUpPacket << 2)
      | (configuration.pointee.globalUnicast << 9) | (configuration.pointee.wakeUpForward << 10)
      | 0x1
    enableMACInterrupts(0x10)
    modify(.macpcsr, clear: 0x607, set: value)
  }
  public func exitPowerDownMode() {
    modify(.macpcsr, clear: 0x4 | 0x2 | 0x200 | 0x400)
    if registers.read(.macpcsr) & 0x1 != 0 { modify(.macpcsr, clear: 0x1) }
    disableMACInterrupts(0x10)
  }
  public func setWakeUpFilter(_ filter: UnsafePointer<UInt32>?, count: UInt32) -> HALStatus {
    guard let filter else { return .error }
    modify(.macpcsr, set: 0x8000_0000)
    var index: UInt32 = 0
    while index < count {
      registers.write(.macrwkpfr, value: filter[Int(index)])
      index &+= 1
    }
    return .ok
  }
}
