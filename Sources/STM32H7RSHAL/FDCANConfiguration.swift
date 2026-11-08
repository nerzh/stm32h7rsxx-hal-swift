// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct FDCANConfiguration: Equatable, Sendable {
    public var clockDivider: UInt32
    public var frameFormat: UInt32
    public var mode: UInt32
    public var autoRetransmission: UInt32
    public var transmitPause: UInt32
    public var protocolException: UInt32
    public var nominalPrescaler: UInt32
    public var nominalSyncJumpWidth: UInt32
    public var nominalTimeSeg1: UInt32
    public var nominalTimeSeg2: UInt32
    public var dataPrescaler: UInt32
    public var dataSyncJumpWidth: UInt32
    public var dataTimeSeg1: UInt32
    public var dataTimeSeg2: UInt32
    public var stdFiltersNbr: UInt32
    public var extFiltersNbr: UInt32
    public var txFifoQueueMode: UInt32
    public init(clockDivider: UInt32 = 0, frameFormat: UInt32 = 0, mode: UInt32 = 0, autoRetransmission: UInt32 = 0, transmitPause: UInt32 = 0, protocolException: UInt32 = 0, nominalPrescaler: UInt32 = 0, nominalSyncJumpWidth: UInt32 = 0, nominalTimeSeg1: UInt32 = 0, nominalTimeSeg2: UInt32 = 0, dataPrescaler: UInt32 = 0, dataSyncJumpWidth: UInt32 = 0, dataTimeSeg1: UInt32 = 0, dataTimeSeg2: UInt32 = 0, stdFiltersNbr: UInt32 = 0, extFiltersNbr: UInt32 = 0, txFifoQueueMode: UInt32 = 0) {
        self.clockDivider = clockDivider
        self.frameFormat = frameFormat
        self.mode = mode
        self.autoRetransmission = autoRetransmission
        self.transmitPause = transmitPause
        self.protocolException = protocolException
        self.nominalPrescaler = nominalPrescaler
        self.nominalSyncJumpWidth = nominalSyncJumpWidth
        self.nominalTimeSeg1 = nominalTimeSeg1
        self.nominalTimeSeg2 = nominalTimeSeg2
        self.dataPrescaler = dataPrescaler
        self.dataSyncJumpWidth = dataSyncJumpWidth
        self.dataTimeSeg1 = dataTimeSeg1
        self.dataTimeSeg2 = dataTimeSeg2
        self.stdFiltersNbr = stdFiltersNbr
        self.extFiltersNbr = extFiltersNbr
        self.txFifoQueueMode = txFifoQueueMode
    }
}
public struct FDCANFilter: Equatable, Sendable {
    public var idType: UInt32
    public var filterIndex: UInt32
    public var filterType: UInt32
    public var filterConfig: UInt32
    public var filterID1: UInt32
    public var filterID2: UInt32
    public init(idType: UInt32 = 0, filterIndex: UInt32 = 0, filterType: UInt32 = 0, filterConfig: UInt32 = 0, filterID1: UInt32 = 0, filterID2: UInt32 = 0) {
        self.idType = idType
        self.filterIndex = filterIndex
        self.filterType = filterType
        self.filterConfig = filterConfig
        self.filterID1 = filterID1
        self.filterID2 = filterID2
    }
}
public struct FDCANTxHeader: Equatable, Sendable {
    public var identifier: UInt32
    public var idType: UInt32
    public var txFrameType: UInt32
    public var dataLength: UInt32
    public var errorStateIndicator: UInt32
    public var bitRateSwitch: UInt32
    public var fdFormat: UInt32
    public var txEventFifoControl: UInt32
    public var messageMarker: UInt32
    public init(identifier: UInt32 = 0, idType: UInt32 = 0, txFrameType: UInt32 = 0, dataLength: UInt32 = 0, errorStateIndicator: UInt32 = 0, bitRateSwitch: UInt32 = 0, fdFormat: UInt32 = 0, txEventFifoControl: UInt32 = 0, messageMarker: UInt32 = 0) {
        self.identifier = identifier
        self.idType = idType
        self.txFrameType = txFrameType
        self.dataLength = dataLength
        self.errorStateIndicator = errorStateIndicator
        self.bitRateSwitch = bitRateSwitch
        self.fdFormat = fdFormat
        self.txEventFifoControl = txEventFifoControl
        self.messageMarker = messageMarker
    }
}
public struct FDCANRxHeader: Equatable, Sendable {
    public var identifier: UInt32
    public var idType: UInt32
    public var rxFrameType: UInt32
    public var dataLength: UInt32
    public var errorStateIndicator: UInt32
    public var bitRateSwitch: UInt32
    public var fdFormat: UInt32
    public var rxTimestamp: UInt32
    public var filterIndex: UInt32
    public var isFilterMatchingFrame: UInt32
    public init(identifier: UInt32 = 0, idType: UInt32 = 0, rxFrameType: UInt32 = 0, dataLength: UInt32 = 0, errorStateIndicator: UInt32 = 0, bitRateSwitch: UInt32 = 0, fdFormat: UInt32 = 0, rxTimestamp: UInt32 = 0, filterIndex: UInt32 = 0, isFilterMatchingFrame: UInt32 = 0) {
        self.identifier = identifier
        self.idType = idType
        self.rxFrameType = rxFrameType
        self.dataLength = dataLength
        self.errorStateIndicator = errorStateIndicator
        self.bitRateSwitch = bitRateSwitch
        self.fdFormat = fdFormat
        self.rxTimestamp = rxTimestamp
        self.filterIndex = filterIndex
        self.isFilterMatchingFrame = isFilterMatchingFrame
    }
}
public struct FDCANTxEvent: Equatable, Sendable {
    public var identifier: UInt32
    public var idType: UInt32
    public var txFrameType: UInt32
    public var dataLength: UInt32
    public var errorStateIndicator: UInt32
    public var bitRateSwitch: UInt32
    public var fdFormat: UInt32
    public var txTimestamp: UInt32
    public var messageMarker: UInt32
    public var eventType: UInt32
    public init(identifier: UInt32 = 0, idType: UInt32 = 0, txFrameType: UInt32 = 0, dataLength: UInt32 = 0, errorStateIndicator: UInt32 = 0, bitRateSwitch: UInt32 = 0, fdFormat: UInt32 = 0, txTimestamp: UInt32 = 0, messageMarker: UInt32 = 0, eventType: UInt32 = 0) {
        self.identifier = identifier
        self.idType = idType
        self.txFrameType = txFrameType
        self.dataLength = dataLength
        self.errorStateIndicator = errorStateIndicator
        self.bitRateSwitch = bitRateSwitch
        self.fdFormat = fdFormat
        self.txTimestamp = txTimestamp
        self.messageMarker = messageMarker
        self.eventType = eventType
    }
}
public struct FDCANHighPriorityMessageStatus: Equatable, Sendable {
    public var filterList: UInt32
    public var filterIndex: UInt32
    public var messageStorage: UInt32
    public var messageIndex: UInt32
    public init(filterList: UInt32 = 0, filterIndex: UInt32 = 0, messageStorage: UInt32 = 0, messageIndex: UInt32 = 0) {
        self.filterList = filterList
        self.filterIndex = filterIndex
        self.messageStorage = messageStorage
        self.messageIndex = messageIndex
    }
}
public struct FDCANProtocolStatus: Equatable, Sendable {
    public var lastErrorCode: UInt32
    public var dataLastErrorCode: UInt32
    public var activity: UInt32
    public var errorPassive: UInt32
    public var warning: UInt32
    public var busOff: UInt32
    public var rxESIFlag: UInt32
    public var rxBRSFlag: UInt32
    public var rxFDFFlag: UInt32
    public var protocolException: UInt32
    public var tdcValue: UInt32
    public init(lastErrorCode: UInt32 = 0, dataLastErrorCode: UInt32 = 0, activity: UInt32 = 0, errorPassive: UInt32 = 0, warning: UInt32 = 0, busOff: UInt32 = 0, rxESIFlag: UInt32 = 0, rxBRSFlag: UInt32 = 0, rxFDFFlag: UInt32 = 0, protocolException: UInt32 = 0, tdcValue: UInt32 = 0) {
        self.lastErrorCode = lastErrorCode
        self.dataLastErrorCode = dataLastErrorCode
        self.activity = activity
        self.errorPassive = errorPassive
        self.warning = warning
        self.busOff = busOff
        self.rxESIFlag = rxESIFlag
        self.rxBRSFlag = rxBRSFlag
        self.rxFDFFlag = rxFDFFlag
        self.protocolException = protocolException
        self.tdcValue = tdcValue
    }
}
public struct FDCANErrorCounters: Equatable, Sendable {
    public var txErrorCnt: UInt32
    public var rxErrorCnt: UInt32
    public var rxErrorPassive: UInt32
    public var errorLogging: UInt32
    public init(txErrorCnt: UInt32 = 0, rxErrorCnt: UInt32 = 0, rxErrorPassive: UInt32 = 0, errorLogging: UInt32 = 0) {
        self.txErrorCnt = txErrorCnt
        self.rxErrorCnt = rxErrorCnt
        self.rxErrorPassive = rxErrorPassive
        self.errorLogging = errorLogging
    }
}
public struct FDCANMessageRAMAddresses: Equatable, Sendable {
    public var standardFilterSA: UInt32
    public var extendedFilterSA: UInt32
    public var rxFIFO0SA: UInt32
    public var rxFIFO1SA: UInt32
    public var txEventFIFOSA: UInt32
    public var txFIFOQSA: UInt32
    public init(standardFilterSA: UInt32 = 0, extendedFilterSA: UInt32 = 0, rxFIFO0SA: UInt32 = 0, rxFIFO1SA: UInt32 = 0, txEventFIFOSA: UInt32 = 0, txFIFOQSA: UInt32 = 0) {
        self.standardFilterSA = standardFilterSA
        self.extendedFilterSA = extendedFilterSA
        self.rxFIFO0SA = rxFIFO0SA
        self.rxFIFO1SA = rxFIFO1SA
        self.txEventFIFOSA = txEventFIFOSA
        self.txFIFOQSA = txFIFOQSA
    }
}
