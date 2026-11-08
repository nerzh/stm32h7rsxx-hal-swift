// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct ETHMACConfiguration {
  public var sourceAddrControl: UInt32
  public var checksumOffload: UInt32
  public var interPacketGapVal: UInt32
  public var giantPacketSizeLimitControl: UInt32
  public var support2KPacket: UInt32
  public var crcStripTypePacket: UInt32
  public var automaticPadCRCStrip: UInt32
  public var watchdog: UInt32
  public var jabber: UInt32
  public var jumboPacket: UInt32
  public var speed: UInt32
  public var duplexMode: UInt32
  public var loopbackMode: UInt32
  public var carrierSenseBeforeTransmit: UInt32
  public var receiveOwn: UInt32
  public var carrierSenseDuringTransmit: UInt32
  public var retryTransmission: UInt32
  public var backOffLimit: UInt32
  public var deferralCheck: UInt32
  public var preambleLength: UInt32
  public var unicastSlowProtocolPacketDetect: UInt32
  public var slowProtocolDetect: UInt32
  public var crcCheckingRxPackets: UInt32
  public var giantPacketSizeLimit: UInt32
  public var extendedInterPacketGap: UInt32
  public var extendedInterPacketGapVal: UInt32
  public var programmableWatchdog: UInt32
  public var watchdogTimeout: UInt32
  public var pauseTime: UInt32
  public var zeroQuantaPause: UInt32
  public var pauseLowThreshold: UInt32
  public var transmitFlowControl: UInt32
  public var unicastPausePacketDetect: UInt32
  public var receiveFlowControl: UInt32
  public var transmitQueueMode: UInt32
  public var receiveQueueMode: UInt32
  public var dropTCPIPChecksumErrorPacket: UInt32
  public var forwardRxErrorPacket: UInt32
  public var forwardRxUndersizedGoodPacket: UInt32
  public init(
    sourceAddrControl: UInt32 = 0, checksumOffload: UInt32 = 0, interPacketGapVal: UInt32 = 0,
    giantPacketSizeLimitControl: UInt32 = 0, support2KPacket: UInt32 = 0,
    crcStripTypePacket: UInt32 = 0, automaticPadCRCStrip: UInt32 = 0, watchdog: UInt32 = 0,
    jabber: UInt32 = 0, jumboPacket: UInt32 = 0, speed: UInt32 = 0, duplexMode: UInt32 = 0,
    loopbackMode: UInt32 = 0, carrierSenseBeforeTransmit: UInt32 = 0, receiveOwn: UInt32 = 0,
    carrierSenseDuringTransmit: UInt32 = 0, retryTransmission: UInt32 = 0, backOffLimit: UInt32 = 0,
    deferralCheck: UInt32 = 0, preambleLength: UInt32 = 0,
    unicastSlowProtocolPacketDetect: UInt32 = 0, slowProtocolDetect: UInt32 = 0,
    crcCheckingRxPackets: UInt32 = 0, giantPacketSizeLimit: UInt32 = 0,
    extendedInterPacketGap: UInt32 = 0, extendedInterPacketGapVal: UInt32 = 0,
    programmableWatchdog: UInt32 = 0, watchdogTimeout: UInt32 = 0, pauseTime: UInt32 = 0,
    zeroQuantaPause: UInt32 = 0, pauseLowThreshold: UInt32 = 0, transmitFlowControl: UInt32 = 0,
    unicastPausePacketDetect: UInt32 = 0, receiveFlowControl: UInt32 = 0,
    transmitQueueMode: UInt32 = 0, receiveQueueMode: UInt32 = 0,
    dropTCPIPChecksumErrorPacket: UInt32 = 0, forwardRxErrorPacket: UInt32 = 0,
    forwardRxUndersizedGoodPacket: UInt32 = 0
  ) {
    self.sourceAddrControl = sourceAddrControl
    self.checksumOffload = checksumOffload
    self.interPacketGapVal = interPacketGapVal
    self.giantPacketSizeLimitControl = giantPacketSizeLimitControl
    self.support2KPacket = support2KPacket
    self.crcStripTypePacket = crcStripTypePacket
    self.automaticPadCRCStrip = automaticPadCRCStrip
    self.watchdog = watchdog
    self.jabber = jabber
    self.jumboPacket = jumboPacket
    self.speed = speed
    self.duplexMode = duplexMode
    self.loopbackMode = loopbackMode
    self.carrierSenseBeforeTransmit = carrierSenseBeforeTransmit
    self.receiveOwn = receiveOwn
    self.carrierSenseDuringTransmit = carrierSenseDuringTransmit
    self.retryTransmission = retryTransmission
    self.backOffLimit = backOffLimit
    self.deferralCheck = deferralCheck
    self.preambleLength = preambleLength
    self.unicastSlowProtocolPacketDetect = unicastSlowProtocolPacketDetect
    self.slowProtocolDetect = slowProtocolDetect
    self.crcCheckingRxPackets = crcCheckingRxPackets
    self.giantPacketSizeLimit = giantPacketSizeLimit
    self.extendedInterPacketGap = extendedInterPacketGap
    self.extendedInterPacketGapVal = extendedInterPacketGapVal
    self.programmableWatchdog = programmableWatchdog
    self.watchdogTimeout = watchdogTimeout
    self.pauseTime = pauseTime
    self.zeroQuantaPause = zeroQuantaPause
    self.pauseLowThreshold = pauseLowThreshold
    self.transmitFlowControl = transmitFlowControl
    self.unicastPausePacketDetect = unicastPausePacketDetect
    self.receiveFlowControl = receiveFlowControl
    self.transmitQueueMode = transmitQueueMode
    self.receiveQueueMode = receiveQueueMode
    self.dropTCPIPChecksumErrorPacket = dropTCPIPChecksumErrorPacket
    self.forwardRxErrorPacket = forwardRxErrorPacket
    self.forwardRxUndersizedGoodPacket = forwardRxUndersizedGoodPacket
  }
}
public struct ETHDMAConfiguration {
  public var dmaArbitration: UInt32
  public var addressAlignedBeats: UInt32
  public var burstMode: UInt32
  public var rebuildINCRxBurst: UInt32
  public var pbLx8Mode: UInt32
  public var txDMABurstLength: UInt32
  public var secondPacketOperate: UInt32
  public var rxDMABurstLength: UInt32
  public var flushRxPacket: UInt32
  public var tcpSegmentation: UInt32
  public var maximumSegmentSize: UInt32
  public init(
    dmaArbitration: UInt32 = 0, addressAlignedBeats: UInt32 = 0, burstMode: UInt32 = 0,
    rebuildINCRxBurst: UInt32 = 0, pbLx8Mode: UInt32 = 0, txDMABurstLength: UInt32 = 0,
    secondPacketOperate: UInt32 = 0, rxDMABurstLength: UInt32 = 0, flushRxPacket: UInt32 = 0,
    tcpSegmentation: UInt32 = 0, maximumSegmentSize: UInt32 = 0
  ) {
    self.dmaArbitration = dmaArbitration
    self.addressAlignedBeats = addressAlignedBeats
    self.burstMode = burstMode
    self.rebuildINCRxBurst = rebuildINCRxBurst
    self.pbLx8Mode = pbLx8Mode
    self.txDMABurstLength = txDMABurstLength
    self.secondPacketOperate = secondPacketOperate
    self.rxDMABurstLength = rxDMABurstLength
    self.flushRxPacket = flushRxPacket
    self.tcpSegmentation = tcpSegmentation
    self.maximumSegmentSize = maximumSegmentSize
  }
}
public struct ETHPTPConfiguration {
  public var timestamp: UInt32
  public var timestampUpdateMode: UInt32
  public var timestampInitialize: UInt32
  public var timestampUpdate: UInt32
  public var timestampAddendUpdate: UInt32
  public var timestampAll: UInt32
  public var timestampRolloverMode: UInt32
  public var timestampV2: UInt32
  public var timestampEthernet: UInt32
  public var timestampIPv6: UInt32
  public var timestampIPv4: UInt32
  public var timestampEvent: UInt32
  public var timestampMaster: UInt32
  public var timestampSnapshots: UInt32
  public var timestampFilter: UInt32
  public var timestampChecksumCorrection: UInt32
  public var timestampStatusMode: UInt32
  public var timestampAddend: UInt32
  public var timestampSubsecondInc: UInt32
  public init(
    timestamp: UInt32 = 0, timestampUpdateMode: UInt32 = 0, timestampInitialize: UInt32 = 0,
    timestampUpdate: UInt32 = 0, timestampAddendUpdate: UInt32 = 0, timestampAll: UInt32 = 0,
    timestampRolloverMode: UInt32 = 0, timestampV2: UInt32 = 0, timestampEthernet: UInt32 = 0,
    timestampIPv6: UInt32 = 0, timestampIPv4: UInt32 = 0, timestampEvent: UInt32 = 0,
    timestampMaster: UInt32 = 0, timestampSnapshots: UInt32 = 0, timestampFilter: UInt32 = 0,
    timestampChecksumCorrection: UInt32 = 0, timestampStatusMode: UInt32 = 0,
    timestampAddend: UInt32 = 0, timestampSubsecondInc: UInt32 = 0
  ) {
    self.timestamp = timestamp
    self.timestampUpdateMode = timestampUpdateMode
    self.timestampInitialize = timestampInitialize
    self.timestampUpdate = timestampUpdate
    self.timestampAddendUpdate = timestampAddendUpdate
    self.timestampAll = timestampAll
    self.timestampRolloverMode = timestampRolloverMode
    self.timestampV2 = timestampV2
    self.timestampEthernet = timestampEthernet
    self.timestampIPv6 = timestampIPv6
    self.timestampIPv4 = timestampIPv4
    self.timestampEvent = timestampEvent
    self.timestampMaster = timestampMaster
    self.timestampSnapshots = timestampSnapshots
    self.timestampFilter = timestampFilter
    self.timestampChecksumCorrection = timestampChecksumCorrection
    self.timestampStatusMode = timestampStatusMode
    self.timestampAddend = timestampAddend
    self.timestampSubsecondInc = timestampSubsecondInc
  }
}
public struct ETHMACFilterConfiguration {
  public var promiscuousMode: UInt32
  public var receiveAllMode: UInt32
  public var hashOrPerfectFilter: UInt32
  public var hashUnicast: UInt32
  public var hashMulticast: UInt32
  public var passAllMulticast: UInt32
  public var srcAddrFiltering: UInt32
  public var srcAddrInverseFiltering: UInt32
  public var destAddrInverseFiltering: UInt32
  public var broadcastFilter: UInt32
  public var controlPacketsFilter: UInt32
  public init(
    promiscuousMode: UInt32 = 0, receiveAllMode: UInt32 = 0, hashOrPerfectFilter: UInt32 = 0,
    hashUnicast: UInt32 = 0, hashMulticast: UInt32 = 0, passAllMulticast: UInt32 = 0,
    srcAddrFiltering: UInt32 = 0, srcAddrInverseFiltering: UInt32 = 0,
    destAddrInverseFiltering: UInt32 = 0, broadcastFilter: UInt32 = 0,
    controlPacketsFilter: UInt32 = 0
  ) {
    self.promiscuousMode = promiscuousMode
    self.receiveAllMode = receiveAllMode
    self.hashOrPerfectFilter = hashOrPerfectFilter
    self.hashUnicast = hashUnicast
    self.hashMulticast = hashMulticast
    self.passAllMulticast = passAllMulticast
    self.srcAddrFiltering = srcAddrFiltering
    self.srcAddrInverseFiltering = srcAddrInverseFiltering
    self.destAddrInverseFiltering = destAddrInverseFiltering
    self.broadcastFilter = broadcastFilter
    self.controlPacketsFilter = controlPacketsFilter
  }
}
public struct ETHPowerDownConfiguration {
  public var wakeUpPacket: UInt32
  public var magicPacket: UInt32
  public var globalUnicast: UInt32
  public var wakeUpForward: UInt32
  public init(
    wakeUpPacket: UInt32 = 0, magicPacket: UInt32 = 0, globalUnicast: UInt32 = 0,
    wakeUpForward: UInt32 = 0
  ) {
    self.wakeUpPacket = wakeUpPacket
    self.magicPacket = magicPacket
    self.globalUnicast = globalUnicast
    self.wakeUpForward = wakeUpForward
  }
}
public struct ETHReceiveVLANConfiguration {
  public var innerVLANTagInStatus: UInt32
  public var stripInnerVLANTag: UInt32
  public var innerVLANTag: UInt32
  public var doubleVLANProcessing: UInt32
  public var vlanTagHashTableMatch: UInt32
  public var vlanTagInStatus: UInt32
  public var stripVLANTag: UInt32
  public var vlanTypeCheck: UInt32
  public var vlanTagInverseMatch: UInt32
  public init(
    innerVLANTagInStatus: UInt32 = 0, stripInnerVLANTag: UInt32 = 0, innerVLANTag: UInt32 = 0,
    doubleVLANProcessing: UInt32 = 0, vlanTagHashTableMatch: UInt32 = 0,
    vlanTagInStatus: UInt32 = 0, stripVLANTag: UInt32 = 0, vlanTypeCheck: UInt32 = 0,
    vlanTagInverseMatch: UInt32 = 0
  ) {
    self.innerVLANTagInStatus = innerVLANTagInStatus
    self.stripInnerVLANTag = stripInnerVLANTag
    self.innerVLANTag = innerVLANTag
    self.doubleVLANProcessing = doubleVLANProcessing
    self.vlanTagHashTableMatch = vlanTagHashTableMatch
    self.vlanTagInStatus = vlanTagInStatus
    self.stripVLANTag = stripVLANTag
    self.vlanTypeCheck = vlanTypeCheck
    self.vlanTagInverseMatch = vlanTagInverseMatch
  }
}
public struct ETHTransmitVLANConfiguration {
  public var sourceTxDesc: UInt32
  public var svlanType: UInt32
  public var vlanTagControl: UInt32
  public init(sourceTxDesc: UInt32 = 0, svlanType: UInt32 = 0, vlanTagControl: UInt32 = 0) {
    self.sourceTxDesc = sourceTxDesc
    self.svlanType = svlanType
    self.vlanTagControl = vlanTagControl
  }
}
public struct ETHLayer3FilterConfiguration {
  public var protocolSelection: UInt32
  public var srcAddrFilterMatch: UInt32
  public var destAddrFilterMatch: UInt32
  public var srcAddrHigherBitsMatch: UInt32
  public var destAddrHigherBitsMatch: UInt32
  public var ipv4SourceAddress: UInt32
  public var ipv4DestinationAddress: UInt32
  public var ipv6Address: InlineArray<4, UInt32>
  public init(
    protocolSelection: UInt32 = 0, srcAddrFilterMatch: UInt32 = 0, destAddrFilterMatch: UInt32 = 0,
    srcAddrHigherBitsMatch: UInt32 = 0, destAddrHigherBitsMatch: UInt32 = 0,
    ipv4SourceAddress: UInt32 = 0, ipv4DestinationAddress: UInt32 = 0,
    ipv6Address: InlineArray<4, UInt32> = .init(repeating: 0)
  ) {
    self.protocolSelection = protocolSelection
    self.srcAddrFilterMatch = srcAddrFilterMatch
    self.destAddrFilterMatch = destAddrFilterMatch
    self.srcAddrHigherBitsMatch = srcAddrHigherBitsMatch
    self.destAddrHigherBitsMatch = destAddrHigherBitsMatch
    self.ipv4SourceAddress = ipv4SourceAddress
    self.ipv4DestinationAddress = ipv4DestinationAddress
    self.ipv6Address = ipv6Address
  }
}
public struct ETHLayer4FilterConfiguration {
  public var protocolSelection: UInt32
  public var srcPortFilterMatch: UInt32
  public var destPortFilterMatch: UInt32
  public var sourcePort: UInt32
  public var destinationPort: UInt32
  public init(
    protocolSelection: UInt32 = 0, srcPortFilterMatch: UInt32 = 0, destPortFilterMatch: UInt32 = 0,
    sourcePort: UInt32 = 0, destinationPort: UInt32 = 0
  ) {
    self.protocolSelection = protocolSelection
    self.srcPortFilterMatch = srcPortFilterMatch
    self.destPortFilterMatch = destPortFilterMatch
    self.sourcePort = sourcePort
    self.destinationPort = destinationPort
  }
}
public struct ETHTimestamp {
  public var low: UInt32
  public var high: UInt32
  public init(low: UInt32 = 0, high: UInt32 = 0) {
    self.low = low
    self.high = high
  }
}
public struct ETHTime {
  public var seconds: UInt32
  public var nanoSeconds: UInt32
  public init(seconds: UInt32 = 0, nanoSeconds: UInt32 = 0) {
    self.seconds = seconds
    self.nanoSeconds = nanoSeconds
  }
}
