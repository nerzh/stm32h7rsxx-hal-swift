import CETHReference
import XCTest

@testable import STM32H7RSHAL

// This fixture exercises register-only operations. A descriptor access on the
// 64-bit host is an error; the original C stores descriptor pointers in UInt32.
struct ETHRegisterModel: ETHRegisterIO, ETHHandleIO, ETHCallbackIO, ETHMemoryIO, ETHPlatformIO {
  let state: OpaquePointer
  var control: UnsafeMutablePointer<UInt32> { CETH_Control(state)! }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
  func read(_ register: ETHRegister) -> UInt32 { CETH_GetRegister(state, register.rawValue) }
  func write(_ register: ETHRegister, value: UInt32) {
    CETH_SetRegister(state, register.rawValue, value)
  }
  func read(_ word: ETHHandleWord) -> UInt32 { CETH_GetWord(state, UInt32(word.rawValue)) }
  func write(_ word: ETHHandleWord, value: UInt32) {
    CETH_SetWord(state, UInt32(word.rawValue), value)
  }
  func readPointer(_ pointer: ETHHandlePointer) -> UnsafeMutableRawPointer? {
    CETH_GetPointer(state, UInt32(pointer.rawValue))
  }
  func writePointer(_ pointer: ETHHandlePointer, value: UnsafeMutableRawPointer?) {
    CETH_SetPointer(state, UInt32(pointer.rawValue), value)
  }
  func pointerStorage(_ pointer: ETHHandlePointer) -> UnsafeMutablePointer<UnsafeMutableRawPointer?>
  { CETH_PointerStorage(state, UInt32(pointer.rawValue))! }
  func descriptorAddress(_ ring: ETHDescriptorRing, index: UInt32) -> UInt32 {
    CETH_GetDescriptorAddress(state, ring.rawValue, index)
  }
  func writeDescriptorAddress(_ ring: ETHDescriptorRing, index: UInt32, value: UInt32) {
    CETH_SetDescriptorAddress(state, ring.rawValue, index, value)
  }
  func transmitPacket(index: UInt32) -> UnsafeMutablePointer<UInt32>? {
    CETH_GetTransmitPacket(state, index)
  }
  func writeTransmitPacket(index: UInt32, value: UnsafeMutablePointer<UInt32>?) {
    CETH_SetTransmitPacket(state, index, value)
  }
  func transmitTimestampWords() -> UnsafeMutablePointer<UInt32> { CETH_TransmitTimestamp(state)! }
  func read32(at address: UInt32) -> UInt32 {
    preconditionFailure("Descriptor access requires the target-width fixture")
  }
  func write32(at address: UInt32, value: UInt32) {
    preconditionFailure("Descriptor access requires the target-width fixture")
  }
  static func callback<T>(_ id: UInt32, _ token: UInt32, as: T.Type) -> T? {
    guard let address = CETH_Callback(id, token) else { return nil }
    return unsafeBitCast(address, to: T.self)
  }
  func read(_ id: ETHCallbackID) -> ETHCallback? {
    CETH_GetCallback(state, id.rawValue).map { unsafeBitCast($0, to: ETHCallback.self) }
  }
  func write(_ id: ETHCallbackID, value: ETHCallback?) {
    CETH_SetCallback(
      state, id.rawValue, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func readReceiveAllocate() -> ETHReceiveAllocateCallback? {
    CETH_GetCallback(state, 9).map { unsafeBitCast($0, to: ETHReceiveAllocateCallback.self) }
  }
  func writeReceiveAllocate(_ value: ETHReceiveAllocateCallback?) {
    CETH_SetCallback(state, 9, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func readReceiveLink() -> ETHReceiveLinkCallback? {
    CETH_GetCallback(state, 10).map { unsafeBitCast($0, to: ETHReceiveLinkCallback.self) }
  }
  func writeReceiveLink(_ value: ETHReceiveLinkCallback?) {
    CETH_SetCallback(state, 10, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func readTransmitFree() -> ETHTransmitFreeCallback? {
    CETH_GetCallback(state, 11).map { unsafeBitCast($0, to: ETHTransmitFreeCallback.self) }
  }
  func writeTransmitFree(_ value: ETHTransmitFreeCallback?) {
    CETH_SetCallback(state, 11, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func readTransmitPTP() -> ETHTransmitPTPCallback? {
    CETH_GetCallback(state, 12).map { unsafeBitCast($0, to: ETHTransmitPTPCallback.self) }
  }
  func writeTransmitPTP(_ value: ETHTransmitPTPCallback?) {
    CETH_SetCallback(state, 12, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func writeGlobalETH(_ register: ETHRegister, value: UInt32) {
    CETH_WriteGlobal(state, register.rawValue, value)
  }
  func enableSBSClock() { _ = CETH_Platform(state, 0, 0) }
  func configureEthernetPHY(_ configuration: UInt32) { _ = CETH_Platform(state, 1, configuration) }
  func readSBSPeripheralMode() -> UInt32 { CETH_Platform(state, 2, 0) }
  func dataMemoryBarrier() { _ = CETH_Platform(state, 3, 0) }
  func dataSynchronizationBarrier() { _ = CETH_Platform(state, 4, 0) }
  func readInterruptMask() -> UInt32 { CETH_Platform(state, 5, 0) }
  func writeInterruptMask(_ value: UInt32) { _ = CETH_Platform(state, 6, value) }
  var driver: ETH<Self, Self, Self, Self, Self> {
    .init(
      registers: self, handle: self, callbacks: self, memory: self, platform: self,
      defaults: .init(
        mspInitialize: Self.callback(0, 1, as: ETHCallback.self)!,
        mspDeinitialize: Self.callback(1, 1, as: ETHCallback.self)!,
        transmitComplete: Self.callback(2, 1, as: ETHCallback.self)!,
        receiveComplete: Self.callback(3, 1, as: ETHCallback.self)!,
        error: Self.callback(4, 1, as: ETHCallback.self)!,
        powerManagement: Self.callback(6, 1, as: ETHCallback.self)!,
        energyEfficientEthernet: Self.callback(7, 1, as: ETHCallback.self)!,
        wakeUp: Self.callback(8, 1, as: ETHCallback.self)!,
        receiveAllocate: Self.callback(9, 1, as: ETHReceiveAllocateCallback.self)!,
        receiveLink: Self.callback(10, 1, as: ETHReceiveLinkCallback.self)!,
        transmitFree: Self.callback(11, 1, as: ETHTransmitFreeCallback.self)!,
        transmitPTP: Self.callback(12, 1, as: ETHTransmitPTPCallback.self)!
      ), useRegisteredCallbacks: control[0] != 0, usePTP: control[1] != 0,
      transmitDescriptorCount: control[2], receiveDescriptorCount: control[2])
  }
  func packetConfiguration() -> ETHTransmitPacketConfiguration {
    .init(
      attributes: CETH_GetPacketWord(state, 0), length: CETH_GetPacketWord(state, 1),
      buffer: CETH_PacketBuffer(state)?.assumingMemoryBound(to: ETHBuffer.self),
      sourceAddressControl: CETH_GetPacketWord(state, 2),
      crcPadControl: CETH_GetPacketWord(state, 3), checksumControl: CETH_GetPacketWord(state, 4),
      maximumSegmentSize: CETH_GetPacketWord(state, 5), payloadLength: CETH_GetPacketWord(state, 6),
      tcpHeaderLength: CETH_GetPacketWord(state, 7), vlanTag: CETH_GetPacketWord(state, 8),
      vlanControl: CETH_GetPacketWord(state, 9), innerVLANTag: CETH_GetPacketWord(state, 10),
      innerVLANControl: CETH_GetPacketWord(state, 11), applicationData: CETH_PacketData(state))
  }
  func configuration0() -> ETHMACConfiguration {
    var result = ETHMACConfiguration()
    result.sourceAddrControl = CETH_GetConfiguration(state, 0, 0)
    result.checksumOffload = CETH_GetConfiguration(state, 0, 1)
    result.interPacketGapVal = CETH_GetConfiguration(state, 0, 2)
    result.giantPacketSizeLimitControl = CETH_GetConfiguration(state, 0, 3)
    result.support2KPacket = CETH_GetConfiguration(state, 0, 4)
    result.crcStripTypePacket = CETH_GetConfiguration(state, 0, 5)
    result.automaticPadCRCStrip = CETH_GetConfiguration(state, 0, 6)
    result.watchdog = CETH_GetConfiguration(state, 0, 7)
    result.jabber = CETH_GetConfiguration(state, 0, 8)
    result.jumboPacket = CETH_GetConfiguration(state, 0, 9)
    result.speed = CETH_GetConfiguration(state, 0, 10)
    result.duplexMode = CETH_GetConfiguration(state, 0, 11)
    result.loopbackMode = CETH_GetConfiguration(state, 0, 12)
    result.carrierSenseBeforeTransmit = CETH_GetConfiguration(state, 0, 13)
    result.receiveOwn = CETH_GetConfiguration(state, 0, 14)
    result.carrierSenseDuringTransmit = CETH_GetConfiguration(state, 0, 15)
    result.retryTransmission = CETH_GetConfiguration(state, 0, 16)
    result.backOffLimit = CETH_GetConfiguration(state, 0, 17)
    result.deferralCheck = CETH_GetConfiguration(state, 0, 18)
    result.preambleLength = CETH_GetConfiguration(state, 0, 19)
    result.unicastSlowProtocolPacketDetect = CETH_GetConfiguration(state, 0, 20)
    result.slowProtocolDetect = CETH_GetConfiguration(state, 0, 21)
    result.crcCheckingRxPackets = CETH_GetConfiguration(state, 0, 22)
    result.giantPacketSizeLimit = CETH_GetConfiguration(state, 0, 23)
    result.extendedInterPacketGap = CETH_GetConfiguration(state, 0, 24)
    result.extendedInterPacketGapVal = CETH_GetConfiguration(state, 0, 25)
    result.programmableWatchdog = CETH_GetConfiguration(state, 0, 26)
    result.watchdogTimeout = CETH_GetConfiguration(state, 0, 27)
    result.pauseTime = CETH_GetConfiguration(state, 0, 28)
    result.zeroQuantaPause = CETH_GetConfiguration(state, 0, 29)
    result.pauseLowThreshold = CETH_GetConfiguration(state, 0, 30)
    result.transmitFlowControl = CETH_GetConfiguration(state, 0, 31)
    result.unicastPausePacketDetect = CETH_GetConfiguration(state, 0, 32)
    result.receiveFlowControl = CETH_GetConfiguration(state, 0, 33)
    result.transmitQueueMode = CETH_GetConfiguration(state, 0, 34)
    result.receiveQueueMode = CETH_GetConfiguration(state, 0, 35)
    result.dropTCPIPChecksumErrorPacket = CETH_GetConfiguration(state, 0, 36)
    result.forwardRxErrorPacket = CETH_GetConfiguration(state, 0, 37)
    result.forwardRxUndersizedGoodPacket = CETH_GetConfiguration(state, 0, 38)
    return result
  }
  func save(_ value: ETHMACConfiguration) {
    CETH_SetConfiguration(state, 0, 0, value.sourceAddrControl)
    CETH_SetConfiguration(state, 0, 1, value.checksumOffload)
    CETH_SetConfiguration(state, 0, 2, value.interPacketGapVal)
    CETH_SetConfiguration(state, 0, 3, value.giantPacketSizeLimitControl)
    CETH_SetConfiguration(state, 0, 4, value.support2KPacket)
    CETH_SetConfiguration(state, 0, 5, value.crcStripTypePacket)
    CETH_SetConfiguration(state, 0, 6, value.automaticPadCRCStrip)
    CETH_SetConfiguration(state, 0, 7, value.watchdog)
    CETH_SetConfiguration(state, 0, 8, value.jabber)
    CETH_SetConfiguration(state, 0, 9, value.jumboPacket)
    CETH_SetConfiguration(state, 0, 10, value.speed)
    CETH_SetConfiguration(state, 0, 11, value.duplexMode)
    CETH_SetConfiguration(state, 0, 12, value.loopbackMode)
    CETH_SetConfiguration(state, 0, 13, value.carrierSenseBeforeTransmit)
    CETH_SetConfiguration(state, 0, 14, value.receiveOwn)
    CETH_SetConfiguration(state, 0, 15, value.carrierSenseDuringTransmit)
    CETH_SetConfiguration(state, 0, 16, value.retryTransmission)
    CETH_SetConfiguration(state, 0, 17, value.backOffLimit)
    CETH_SetConfiguration(state, 0, 18, value.deferralCheck)
    CETH_SetConfiguration(state, 0, 19, value.preambleLength)
    CETH_SetConfiguration(state, 0, 20, value.unicastSlowProtocolPacketDetect)
    CETH_SetConfiguration(state, 0, 21, value.slowProtocolDetect)
    CETH_SetConfiguration(state, 0, 22, value.crcCheckingRxPackets)
    CETH_SetConfiguration(state, 0, 23, value.giantPacketSizeLimit)
    CETH_SetConfiguration(state, 0, 24, value.extendedInterPacketGap)
    CETH_SetConfiguration(state, 0, 25, value.extendedInterPacketGapVal)
    CETH_SetConfiguration(state, 0, 26, value.programmableWatchdog)
    CETH_SetConfiguration(state, 0, 27, value.watchdogTimeout)
    CETH_SetConfiguration(state, 0, 28, value.pauseTime)
    CETH_SetConfiguration(state, 0, 29, value.zeroQuantaPause)
    CETH_SetConfiguration(state, 0, 30, value.pauseLowThreshold)
    CETH_SetConfiguration(state, 0, 31, value.transmitFlowControl)
    CETH_SetConfiguration(state, 0, 32, value.unicastPausePacketDetect)
    CETH_SetConfiguration(state, 0, 33, value.receiveFlowControl)
    CETH_SetConfiguration(state, 0, 34, value.transmitQueueMode)
    CETH_SetConfiguration(state, 0, 35, value.receiveQueueMode)
    CETH_SetConfiguration(state, 0, 36, value.dropTCPIPChecksumErrorPacket)
    CETH_SetConfiguration(state, 0, 37, value.forwardRxErrorPacket)
    CETH_SetConfiguration(state, 0, 38, value.forwardRxUndersizedGoodPacket)
  }
  func configuration1() -> ETHDMAConfiguration {
    var result = ETHDMAConfiguration()
    result.dmaArbitration = CETH_GetConfiguration(state, 1, 0)
    result.addressAlignedBeats = CETH_GetConfiguration(state, 1, 1)
    result.burstMode = CETH_GetConfiguration(state, 1, 2)
    result.rebuildINCRxBurst = CETH_GetConfiguration(state, 1, 3)
    result.pbLx8Mode = CETH_GetConfiguration(state, 1, 4)
    result.txDMABurstLength = CETH_GetConfiguration(state, 1, 5)
    result.secondPacketOperate = CETH_GetConfiguration(state, 1, 6)
    result.rxDMABurstLength = CETH_GetConfiguration(state, 1, 7)
    result.flushRxPacket = CETH_GetConfiguration(state, 1, 8)
    result.tcpSegmentation = CETH_GetConfiguration(state, 1, 9)
    result.maximumSegmentSize = CETH_GetConfiguration(state, 1, 10)
    return result
  }
  func save(_ value: ETHDMAConfiguration) {
    CETH_SetConfiguration(state, 1, 0, value.dmaArbitration)
    CETH_SetConfiguration(state, 1, 1, value.addressAlignedBeats)
    CETH_SetConfiguration(state, 1, 2, value.burstMode)
    CETH_SetConfiguration(state, 1, 3, value.rebuildINCRxBurst)
    CETH_SetConfiguration(state, 1, 4, value.pbLx8Mode)
    CETH_SetConfiguration(state, 1, 5, value.txDMABurstLength)
    CETH_SetConfiguration(state, 1, 6, value.secondPacketOperate)
    CETH_SetConfiguration(state, 1, 7, value.rxDMABurstLength)
    CETH_SetConfiguration(state, 1, 8, value.flushRxPacket)
    CETH_SetConfiguration(state, 1, 9, value.tcpSegmentation)
    CETH_SetConfiguration(state, 1, 10, value.maximumSegmentSize)
  }
  func configuration2() -> ETHPTPConfiguration {
    var result = ETHPTPConfiguration()
    result.timestamp = CETH_GetConfiguration(state, 2, 0)
    result.timestampUpdateMode = CETH_GetConfiguration(state, 2, 1)
    result.timestampInitialize = CETH_GetConfiguration(state, 2, 2)
    result.timestampUpdate = CETH_GetConfiguration(state, 2, 3)
    result.timestampAddendUpdate = CETH_GetConfiguration(state, 2, 4)
    result.timestampAll = CETH_GetConfiguration(state, 2, 5)
    result.timestampRolloverMode = CETH_GetConfiguration(state, 2, 6)
    result.timestampV2 = CETH_GetConfiguration(state, 2, 7)
    result.timestampEthernet = CETH_GetConfiguration(state, 2, 8)
    result.timestampIPv6 = CETH_GetConfiguration(state, 2, 9)
    result.timestampIPv4 = CETH_GetConfiguration(state, 2, 10)
    result.timestampEvent = CETH_GetConfiguration(state, 2, 11)
    result.timestampMaster = CETH_GetConfiguration(state, 2, 12)
    result.timestampSnapshots = CETH_GetConfiguration(state, 2, 13)
    result.timestampFilter = CETH_GetConfiguration(state, 2, 14)
    result.timestampChecksumCorrection = CETH_GetConfiguration(state, 2, 15)
    result.timestampStatusMode = CETH_GetConfiguration(state, 2, 16)
    result.timestampAddend = CETH_GetConfiguration(state, 2, 17)
    result.timestampSubsecondInc = CETH_GetConfiguration(state, 2, 18)
    return result
  }
  func save(_ value: ETHPTPConfiguration) {
    CETH_SetConfiguration(state, 2, 0, value.timestamp)
    CETH_SetConfiguration(state, 2, 1, value.timestampUpdateMode)
    CETH_SetConfiguration(state, 2, 2, value.timestampInitialize)
    CETH_SetConfiguration(state, 2, 3, value.timestampUpdate)
    CETH_SetConfiguration(state, 2, 4, value.timestampAddendUpdate)
    CETH_SetConfiguration(state, 2, 5, value.timestampAll)
    CETH_SetConfiguration(state, 2, 6, value.timestampRolloverMode)
    CETH_SetConfiguration(state, 2, 7, value.timestampV2)
    CETH_SetConfiguration(state, 2, 8, value.timestampEthernet)
    CETH_SetConfiguration(state, 2, 9, value.timestampIPv6)
    CETH_SetConfiguration(state, 2, 10, value.timestampIPv4)
    CETH_SetConfiguration(state, 2, 11, value.timestampEvent)
    CETH_SetConfiguration(state, 2, 12, value.timestampMaster)
    CETH_SetConfiguration(state, 2, 13, value.timestampSnapshots)
    CETH_SetConfiguration(state, 2, 14, value.timestampFilter)
    CETH_SetConfiguration(state, 2, 15, value.timestampChecksumCorrection)
    CETH_SetConfiguration(state, 2, 16, value.timestampStatusMode)
    CETH_SetConfiguration(state, 2, 17, value.timestampAddend)
    CETH_SetConfiguration(state, 2, 18, value.timestampSubsecondInc)
  }
  func configuration3() -> ETHMACFilterConfiguration {
    var result = ETHMACFilterConfiguration()
    result.promiscuousMode = CETH_GetConfiguration(state, 3, 0)
    result.receiveAllMode = CETH_GetConfiguration(state, 3, 1)
    result.hashOrPerfectFilter = CETH_GetConfiguration(state, 3, 2)
    result.hashUnicast = CETH_GetConfiguration(state, 3, 3)
    result.hashMulticast = CETH_GetConfiguration(state, 3, 4)
    result.passAllMulticast = CETH_GetConfiguration(state, 3, 5)
    result.srcAddrFiltering = CETH_GetConfiguration(state, 3, 6)
    result.srcAddrInverseFiltering = CETH_GetConfiguration(state, 3, 7)
    result.destAddrInverseFiltering = CETH_GetConfiguration(state, 3, 8)
    result.broadcastFilter = CETH_GetConfiguration(state, 3, 9)
    result.controlPacketsFilter = CETH_GetConfiguration(state, 3, 10)
    return result
  }
  func save(_ value: ETHMACFilterConfiguration) {
    CETH_SetConfiguration(state, 3, 0, value.promiscuousMode)
    CETH_SetConfiguration(state, 3, 1, value.receiveAllMode)
    CETH_SetConfiguration(state, 3, 2, value.hashOrPerfectFilter)
    CETH_SetConfiguration(state, 3, 3, value.hashUnicast)
    CETH_SetConfiguration(state, 3, 4, value.hashMulticast)
    CETH_SetConfiguration(state, 3, 5, value.passAllMulticast)
    CETH_SetConfiguration(state, 3, 6, value.srcAddrFiltering)
    CETH_SetConfiguration(state, 3, 7, value.srcAddrInverseFiltering)
    CETH_SetConfiguration(state, 3, 8, value.destAddrInverseFiltering)
    CETH_SetConfiguration(state, 3, 9, value.broadcastFilter)
    CETH_SetConfiguration(state, 3, 10, value.controlPacketsFilter)
  }
  func configuration4() -> ETHPowerDownConfiguration {
    var result = ETHPowerDownConfiguration()
    result.wakeUpPacket = CETH_GetConfiguration(state, 4, 0)
    result.magicPacket = CETH_GetConfiguration(state, 4, 1)
    result.globalUnicast = CETH_GetConfiguration(state, 4, 2)
    result.wakeUpForward = CETH_GetConfiguration(state, 4, 3)
    return result
  }
  func save(_ value: ETHPowerDownConfiguration) {
    CETH_SetConfiguration(state, 4, 0, value.wakeUpPacket)
    CETH_SetConfiguration(state, 4, 1, value.magicPacket)
    CETH_SetConfiguration(state, 4, 2, value.globalUnicast)
    CETH_SetConfiguration(state, 4, 3, value.wakeUpForward)
  }
  func configuration5() -> ETHReceiveVLANConfiguration {
    var result = ETHReceiveVLANConfiguration()
    result.innerVLANTagInStatus = CETH_GetConfiguration(state, 5, 0)
    result.stripInnerVLANTag = CETH_GetConfiguration(state, 5, 1)
    result.innerVLANTag = CETH_GetConfiguration(state, 5, 2)
    result.doubleVLANProcessing = CETH_GetConfiguration(state, 5, 3)
    result.vlanTagHashTableMatch = CETH_GetConfiguration(state, 5, 4)
    result.vlanTagInStatus = CETH_GetConfiguration(state, 5, 5)
    result.stripVLANTag = CETH_GetConfiguration(state, 5, 6)
    result.vlanTypeCheck = CETH_GetConfiguration(state, 5, 7)
    result.vlanTagInverseMatch = CETH_GetConfiguration(state, 5, 8)
    return result
  }
  func save(_ value: ETHReceiveVLANConfiguration) {
    CETH_SetConfiguration(state, 5, 0, value.innerVLANTagInStatus)
    CETH_SetConfiguration(state, 5, 1, value.stripInnerVLANTag)
    CETH_SetConfiguration(state, 5, 2, value.innerVLANTag)
    CETH_SetConfiguration(state, 5, 3, value.doubleVLANProcessing)
    CETH_SetConfiguration(state, 5, 4, value.vlanTagHashTableMatch)
    CETH_SetConfiguration(state, 5, 5, value.vlanTagInStatus)
    CETH_SetConfiguration(state, 5, 6, value.stripVLANTag)
    CETH_SetConfiguration(state, 5, 7, value.vlanTypeCheck)
    CETH_SetConfiguration(state, 5, 8, value.vlanTagInverseMatch)
  }
  func configuration6() -> ETHTransmitVLANConfiguration {
    var result = ETHTransmitVLANConfiguration()
    result.sourceTxDesc = CETH_GetConfiguration(state, 6, 0)
    result.svlanType = CETH_GetConfiguration(state, 6, 1)
    result.vlanTagControl = CETH_GetConfiguration(state, 6, 2)
    return result
  }
  func save(_ value: ETHTransmitVLANConfiguration) {
    CETH_SetConfiguration(state, 6, 0, value.sourceTxDesc)
    CETH_SetConfiguration(state, 6, 1, value.svlanType)
    CETH_SetConfiguration(state, 6, 2, value.vlanTagControl)
  }
  func configuration7() -> ETHLayer3FilterConfiguration {
    var result = ETHLayer3FilterConfiguration()
    result.protocolSelection = CETH_GetConfiguration(state, 7, 0)
    result.srcAddrFilterMatch = CETH_GetConfiguration(state, 7, 1)
    result.destAddrFilterMatch = CETH_GetConfiguration(state, 7, 2)
    result.srcAddrHigherBitsMatch = CETH_GetConfiguration(state, 7, 3)
    result.destAddrHigherBitsMatch = CETH_GetConfiguration(state, 7, 4)
    result.ipv4SourceAddress = CETH_GetConfiguration(state, 7, 5)
    result.ipv4DestinationAddress = CETH_GetConfiguration(state, 7, 6)
    result.ipv6Address[0] = CETH_GetConfiguration(state, 7, 7)
    result.ipv6Address[1] = CETH_GetConfiguration(state, 7, 8)
    result.ipv6Address[2] = CETH_GetConfiguration(state, 7, 9)
    result.ipv6Address[3] = CETH_GetConfiguration(state, 7, 10)
    return result
  }
  func save(_ value: ETHLayer3FilterConfiguration) {
    CETH_SetConfiguration(state, 7, 0, value.protocolSelection)
    CETH_SetConfiguration(state, 7, 1, value.srcAddrFilterMatch)
    CETH_SetConfiguration(state, 7, 2, value.destAddrFilterMatch)
    CETH_SetConfiguration(state, 7, 3, value.srcAddrHigherBitsMatch)
    CETH_SetConfiguration(state, 7, 4, value.destAddrHigherBitsMatch)
    CETH_SetConfiguration(state, 7, 5, value.ipv4SourceAddress)
    CETH_SetConfiguration(state, 7, 6, value.ipv4DestinationAddress)
    CETH_SetConfiguration(state, 7, 7, value.ipv6Address[0])
    CETH_SetConfiguration(state, 7, 8, value.ipv6Address[1])
    CETH_SetConfiguration(state, 7, 9, value.ipv6Address[2])
    CETH_SetConfiguration(state, 7, 10, value.ipv6Address[3])
  }
  func configuration8() -> ETHLayer4FilterConfiguration {
    var result = ETHLayer4FilterConfiguration()
    result.protocolSelection = CETH_GetConfiguration(state, 8, 0)
    result.srcPortFilterMatch = CETH_GetConfiguration(state, 8, 1)
    result.destPortFilterMatch = CETH_GetConfiguration(state, 8, 2)
    result.sourcePort = CETH_GetConfiguration(state, 8, 3)
    result.destinationPort = CETH_GetConfiguration(state, 8, 4)
    return result
  }
  func save(_ value: ETHLayer4FilterConfiguration) {
    CETH_SetConfiguration(state, 8, 0, value.protocolSelection)
    CETH_SetConfiguration(state, 8, 1, value.srcPortFilterMatch)
    CETH_SetConfiguration(state, 8, 2, value.destPortFilterMatch)
    CETH_SetConfiguration(state, 8, 3, value.sourcePort)
    CETH_SetConfiguration(state, 8, 4, value.destinationPort)
  }
  func configuration9() -> ETHTimestamp {
    var result = ETHTimestamp()
    result.low = CETH_GetConfiguration(state, 9, 0)
    result.high = CETH_GetConfiguration(state, 9, 1)
    return result
  }
  func save(_ value: ETHTimestamp) {
    CETH_SetConfiguration(state, 9, 0, value.low)
    CETH_SetConfiguration(state, 9, 1, value.high)
  }
  func configuration10() -> ETHTime {
    var result = ETHTime()
    result.seconds = CETH_GetConfiguration(state, 10, 0)
    result.nanoSeconds = CETH_GetConfiguration(state, 10, 1)
    return result
  }
  func save(_ value: ETHTime) {
    CETH_SetConfiguration(state, 10, 0, value.seconds)
    CETH_SetConfiguration(state, 10, 1, value.nanoSeconds)
  }
  func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CETH_Activate(state)
    switch op {
    case 1: return driver.deinitialize().rawValue
    case 2:
      return driver.registerCallback(id: a, callback: Self.callback(4, b, as: ETHCallback.self))
        .rawValue
    case 3: return driver.unregisterCallback(id: a).rawValue
    case 59:
      driver.initializeCallbacksToDefault()
      return 0
    case 31:
      var exti = ETHEXTIFixture(state: state)
      driver.irqHandler(exti: &exti)
      return 0
    case 12:
      return driver.registerReceiveAllocateCallback(
        Self.callback(9, b, as: ETHReceiveAllocateCallback.self)
      ).rawValue
    case 13: return driver.unregisterReceiveAllocateCallback().rawValue
    case 14:
      return driver.registerReceiveLinkCallback(
        Self.callback(10, b, as: ETHReceiveLinkCallback.self)
      ).rawValue
    case 15: return driver.unregisterReceiveLinkCallback().rawValue
    case 17:
      return driver.registerTransmitFreeCallback(
        Self.callback(11, b, as: ETHTransmitFreeCallback.self)
      ).rawValue
    case 18: return driver.unregisterTransmitFreeCallback().rawValue
    case 29:
      return driver.registerTransmitPTPCallback(
        Self.callback(12, b, as: ETHTransmitPTPCallback.self)
      ).rawValue
    case 30: return driver.unregisterTransmitPTPCallback().rawValue
    case 0:
      return driver.initialize(
        getTick: { CETH_TickFor(state) }, getHCLKFrequency: { CETH_HCLKFor(state) }
      ).rawValue
    case 4: return driver.start().rawValue
    case 5: return driver.startInterrupt().rawValue
    case 6: return driver.stop().rawValue
    case 7: return driver.stopInterrupt().rawValue
    case 8:
      var config = packetConfiguration()
      return withUnsafePointer(to: &config) {
        driver.transmit(c == 0 ? $0 : nil, timeout: a, getTick: { CETH_TickFor(state) }).rawValue
      }
    case 9:
      var config = packetConfiguration()
      return withUnsafePointer(to: &config) { driver.transmitInterrupt(c == 0 ? $0 : nil).rawValue }
    case 10:
      var output = CETH_PacketData(state)
      let status = withUnsafeMutablePointer(to: &output) { driver.readData(c == 0 ? $0 : nil) }
      CETH_SetPacketData(state, output)
      return status.rawValue
    case 11:
      driver.updateReceiveDescriptors()
      return 0
    case 16: return driver.getReceiveDataErrorCode(CETH_Buffer(state, 0)!).rawValue
    case 19: return driver.releaseTransmitPacket().rawValue
    case 56:
      driver.initializeTransmitDescriptors()
      return 0
    case 57:
      driver.initializeReceiveDescriptors()
      return 0
    case 58:
      var config = packetConfiguration()
      return withUnsafePointer(to: &config) {
        driver.prepareTransmitDescriptors($0, interruptMode: a)
      }
    case 20:
      var v = configuration2()
      let status = withUnsafePointer(to: &v) { driver.setPTPConfiguration(c == 0 ? $0 : nil) }
      save(v)
      return status.rawValue
    case 21:
      var v = configuration2()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.getPTPConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 22:
      var v = configuration10()
      let status = withUnsafePointer(to: &v) { driver.setPTPTime($0) }
      save(v)
      return status.rawValue
    case 23:
      var v = configuration10()
      let status = withUnsafeMutablePointer(to: &v) { driver.getPTPTime($0) }
      save(v)
      return status.rawValue
    case 24:
      var v = configuration10()
      let status = withUnsafePointer(to: &v) { driver.addPTPTimeOffset($0, negative: a == 1) }
      save(v)
      return status.rawValue
    case 25: return driver.updatePTPAddend(Int32(bitPattern: a)).rawValue
    case 26: return driver.insertTransmitPTPTimestamp().rawValue
    case 27:
      var v = configuration9()
      let status = withUnsafeMutablePointer(to: &v) { driver.getTransmitPTPTimestamp($0) }
      save(v)
      return status.rawValue
    case 28:
      var v = configuration9()
      let status = withUnsafeMutablePointer(to: &v) { driver.getReceivePTPTimestamp($0) }
      save(v)
      return status.rawValue
    case 32:
      return driver.readPHYRegister(
        address: a, register: b, value: CETH_Buffer(state, 0)!, getTick: { CETH_TickFor(state) }
      ).rawValue
    case 33:
      return driver.writePHYRegister(
        address: a, register: b, value: c, getTick: { CETH_TickFor(state) }
      ).rawValue
    case 34:
      var v = configuration0()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.getMACConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 35:
      var v = configuration1()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.getDMAConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 36:
      var v = configuration0()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.setMACConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 37:
      var v = configuration1()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.setDMAConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 39:
      var v = configuration3()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.setMACFilterConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 40:
      var v = configuration3()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.getMACFilterConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 38:
      driver.setMDIOClockRange(getHCLKFrequency: { CETH_HCLKFor(state) })
      return 0
    case 41:
      return driver.setSourceMACAddressMatch(
        c == 0 ? readPointer(.macAddress)?.assumingMemoryBound(to: UInt8.self) : nil, number: a
      ).rawValue
    case 42: return driver.setHashTable(c == 0 ? CETH_Buffer(state, 0) : nil).rawValue
    case 43:
      driver.setReceiveVLANIdentifier(comparisonBits: a, identifier: b)
      return 0
    case 44:
      var v = configuration4()
      withUnsafePointer(to: &v) { driver.enterPowerDownMode($0) }
      return 0
    case 45:
      driver.exitPowerDownMode()
      return 0
    case 46: return driver.setWakeUpFilter(c == 0 ? CETH_Buffer(state, 0) : nil, count: a).rawValue
    case 53:
      var v = configuration0()
      withUnsafePointer(to: &v) { driver.applyMACConfiguration($0) }
      return 0
    case 54:
      var v = configuration1()
      withUnsafePointer(to: &v) { driver.applyDMAConfiguration($0) }
      return 0
    case 55:
      driver.applyDefaultMACDMAConfiguration()
      return 0
    case 47: return driver.getState()
    case 48: return driver.getError()
    case 49: return driver.getDMAError()
    case 50: return driver.getMACError()
    case 51: return driver.getMACWakeUpSource()
    case 52: return driver.getTransmitBuffersNumber()
    case 79: return driver.getMACLPIEvent()
    case 63:
      var v = configuration8()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.setLayer4FilterConfiguration(c == 0 ? $0 : nil, filter: a)
      }
      save(v)
      return status.rawValue
    case 64:
      var v = configuration8()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.getLayer4FilterConfiguration(c == 0 ? $0 : nil, filter: a)
      }
      save(v)
      return status.rawValue
    case 65:
      var v = configuration7()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.setLayer3FilterConfiguration(c == 0 ? $0 : nil, filter: a)
      }
      save(v)
      return status.rawValue
    case 66:
      var v = configuration7()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.getLayer3FilterConfiguration(c == 0 ? $0 : nil, filter: a)
      }
      save(v)
      return status.rawValue
    case 69:
      var v = configuration5()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.getReceiveVLANConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 70:
      var v = configuration5()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.setReceiveVLANConfiguration(c == 0 ? $0 : nil)
      }
      save(v)
      return status.rawValue
    case 72:
      var v = configuration6()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.getTransmitVLANConfiguration(c == 0 ? $0 : nil, tag: a)
      }
      save(v)
      return status.rawValue
    case 73:
      var v = configuration6()
      let status = withUnsafeMutablePointer(to: &v) {
        driver.setTransmitVLANConfiguration($0, tag: a)
      }
      save(v)
      return status.rawValue
    case 60:
      driver.enableARPOffload()
      return 0
    case 61:
      driver.disableARPOffload()
      return 0
    case 62:
      driver.setARPAddressMatch(a)
      return 0
    case 67:
      driver.enableLayer3Layer4Filtering()
      return 0
    case 68:
      driver.disableLayer3Layer4Filtering()
      return 0
    case 71:
      driver.setVLANHashTable(a)
      return 0
    case 74:
      driver.setTransmitVLANIdentifier(tag: a, identifier: b)
      return 0
    case 75:
      driver.enableVLANProcessing()
      return 0
    case 76:
      driver.disableVLANProcessing()
      return 0
    case 77:
      driver.enterLPIMode(transmitAutomate: a, transmitClockStop: b)
      return 0
    case 78:
      driver.exitLPIMode()
      return 0
    case 80:
      driver.enableDMAInterrupts(a)
      return 0
    case 81:
      driver.disableDMAInterrupts(a)
      return 0
    case 82: return driver.getDMAInterruptSource(a) ? 1 : 0
    case 83: return driver.getDMAInterrupt(a) ? 1 : 0
    case 84:
      driver.clearDMAInterrupt(a)
      return 0
    case 85: return driver.getDMAFlag(a) ? 1 : 0
    case 86:
      driver.clearDMAFlag(a)
      return 0
    case 87:
      driver.enableMACInterrupts(a)
      return 0
    case 88:
      driver.disableMACInterrupts(a)
      return 0
    case 89: return driver.getMACInterrupt(a) ? 1 : 0
    case 91: return driver.getPTPControl(a) ? 1 : 0
    case 92:
      driver.setPTPControl(a)
      return 0
    case 90:
      driver.resetHandleState()
      return 0
    case 93:
      var wake = ETHWakeup(registers: ETHEXTIFixture(state: state))
      wake.enableInterrupt(a)
      return 0
    case 94:
      var wake = ETHWakeup(registers: ETHEXTIFixture(state: state))
      return wake.getFlag(a)
    case 95:
      var wake = ETHWakeup(registers: ETHEXTIFixture(state: state))
      wake.clearFlag(a)
      return 0
    case 96:
      var wake = ETHWakeup(registers: ETHEXTIFixture(state: state))
      wake.enableRisingEdge(a)
      return 0
    case 97:
      var wake = ETHWakeup(registers: ETHEXTIFixture(state: state))
      wake.enableFallingEdge(a)
      return 0
    case 98:
      var wake = ETHWakeup(registers: ETHEXTIFixture(state: state))
      wake.enableRisingFallingEdge(a)
      return 0
    case 99:
      var wake = ETHWakeup(registers: ETHEXTIFixture(state: state))
      wake.generateSoftwareInterrupt(a)
      return 0
    case 100: return driver.incrementTransmitDescriptor(a, by: b)
    case 101: return driver.incrementReceiveDescriptor(a, by: b)
    default: preconditionFailure("Unsupported register operation")
    }
  }
}
final class ETHRegisterPair {
  let c: OpaquePointer
  let swift: ETHRegisterModel
  init(callbacks: UInt32 = 0, ptp: UInt32 = 0, rings: UInt32 = 4) {
    c = OpaquePointer(UnsafeMutableRawPointer.allocate(byteCount: CETH_Size(), alignment: 16))
    swift = ETHRegisterModel(
      state: OpaquePointer(UnsafeMutableRawPointer.allocate(byteCount: CETH_Size(), alignment: 16)))
    CETH_Reset(c, callbacks, ptp, rings)
    CETH_Reset(swift.state, callbacks, ptp, rings)
  }
  deinit {
    UnsafeMutableRawPointer(c).deallocate()
    UnsafeMutableRawPointer(swift.state).deallocate()
  }
  func register(_ r: ETHRegister, _ value: UInt32) {
    CETH_SetRegister(c, r.rawValue, value)
    swift.write(r, value: value)
  }
  func word(_ w: ETHHandleWord, _ value: UInt32) {
    CETH_SetWord(c, UInt32(w.rawValue), value)
    swift.write(w, value: value)
  }
  func configuration(_ kind: UInt32, _ field: UInt32, _ value: UInt32) {
    CETH_SetConfiguration(c, kind, field, value)
    CETH_SetConfiguration(swift.state, kind, field, value)
  }
  func seed(_ value: UInt32) {
    for o in stride(from: UInt32(0), to: CETH_RegisterSize(), by: 4) {
      let v = value &+ o &* 0x10203
      CETH_SetRegister(c, o, v)
      CETH_SetRegister(swift.state, o, v)
    }
  }
  @discardableResult func run(
    _ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0, file: StaticString = #filePath,
    line: UInt = #line
  ) -> UInt32 {
    let expected = CETH_Run(c, op, a, b, d)
    let actual = swift.run(op, a, b, d)
    XCTAssertEqual(actual, expected, "operation \(op)", file: file, line: line)
    for o in stride(from: UInt32(0), to: CETH_RegisterSize(), by: 4) {
      XCTAssertEqual(
        CETH_GetRegister(swift.state, o), CETH_GetRegister(c, o),
        "operation \(op), register \(String(o,radix:16))", file: file, line: line)
    }
    for w in ETHHandleWord.allCases {
      XCTAssertEqual(
        swift.read(w), CETH_GetWord(c, UInt32(w.rawValue)), "operation \(op), word \(w)",
        file: file, line: line)
    }
    for i: UInt32 in 0..<39 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 0, i), CETH_GetConfiguration(c, 0, i),
        "operation \(op), configuration 0 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<11 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 1, i), CETH_GetConfiguration(c, 1, i),
        "operation \(op), configuration 1 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<19 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 2, i), CETH_GetConfiguration(c, 2, i),
        "operation \(op), configuration 2 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<11 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 3, i), CETH_GetConfiguration(c, 3, i),
        "operation \(op), configuration 3 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<4 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 4, i), CETH_GetConfiguration(c, 4, i),
        "operation \(op), configuration 4 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<9 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 5, i), CETH_GetConfiguration(c, 5, i),
        "operation \(op), configuration 5 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<3 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 6, i), CETH_GetConfiguration(c, 6, i),
        "operation \(op), configuration 6 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<11 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 7, i), CETH_GetConfiguration(c, 7, i),
        "operation \(op), configuration 7 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<5 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 8, i), CETH_GetConfiguration(c, 8, i),
        "operation \(op), configuration 8 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<2 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 9, i), CETH_GetConfiguration(c, 9, i),
        "operation \(op), configuration 9 field \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<2 {
      XCTAssertEqual(
        CETH_GetConfiguration(swift.state, 10, i), CETH_GetConfiguration(c, 10, i),
        "operation \(op), configuration 10 field \(i)", file: file, line: line)
    }
    for index in 0..<64 {
      XCTAssertEqual(
        CETH_Control(c)![index], swift.control[index], "operation \(op), control \(index)",
        file: file, line: line)
    }
    for index in 0..<Int(swift.control[8]) {
      XCTAssertEqual(
        CETH_Trace(c)![index], CETH_Trace(swift.state)![index], "operation \(op), trace \(index)",
        file: file, line: line)
    }
    for o in stride(from: UInt32(0), to: CETH_RegisterSize(), by: 4) {
      XCTAssertEqual(
        CETH_ReadGlobal(c, o), CETH_ReadGlobal(swift.state, o),
        "operation \(op), global register \(o)", file: file, line: line)
    }
    for i in 0..<64 {
      XCTAssertEqual(
        CETH_Buffer(c, 0)![i], CETH_Buffer(swift.state, 0)![i], "operation \(op), buffer \(i)",
        file: file, line: line)
    }
    for i: UInt32 in 0...12 where i != 5 {
      XCTAssertEqual(
        CETH_GetCallback(c, i), CETH_GetCallback(swift.state, i), "callback \(i)", file: file,
        line: line)
    }
    for i: UInt32 in 0..<5 {
      XCTAssertEqual(
        CETH_GetEXTI(c, i), CETH_GetEXTI(swift.state, i), "EXTI \(i)", file: file, line: line)
    }
    return actual
  }
}

struct ETHEXTIFixture: EXTIRegisterIO {
  let state: OpaquePointer
  func index(_ r: EXTIRegister) -> UInt32 {
    switch r {
    case .interruptMask(bank: 1): return 0
    case .pending(bank: 1): return 1
    case .fallingTrigger(bank: 1): return 2
    case .risingTrigger(bank: 1): return 3
    case .softwareInterrupt(bank: 1): return 4
    default: preconditionFailure("Unexpected EXTI register")
    }
  }
  func read(_ r: EXTIRegister) -> UInt32 { CETH_GetEXTI(state, index(r)) }
  func write(_ r: EXTIRegister, value: UInt32) { CETH_SetEXTI(state, index(r), value) }
}
