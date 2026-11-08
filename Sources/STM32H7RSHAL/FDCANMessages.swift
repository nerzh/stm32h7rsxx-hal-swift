// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension FDCAN {
    public static func payloadByteCount(dataLength: UInt32) -> UInt32 {
        switch dataLength {
        case 0...8: return dataLength
        case 9: return 12
        case 10: return 16
        case 11: return 20
        case 12: return 24
        case 13: return 32
        case 14: return 48
        case 15: return 64
        default: preconditionFailure("Invalid FDCAN data length code")
        }
    }
    @discardableResult
    public func addMessageToTxFifoQ(header: FDCANTxHeader, data: UnsafePointer<UInt8>) -> HALStatus {
        if getState() == FD.HAL_FDCAN_STATE_BUSY {
            if read(.txfqs) & FD.FDCAN_TXFQS_TFQF != 0 { return fail(FD.HAL_FDCAN_ERROR_FIFO_FULL) }
            let index = (read(.txfqs) & FD.FDCAN_TXFQS_TFQPI) >> FD.FDCAN_TXFQS_TFQPI_Pos
            copyMessageToRAM(header: header, data: data, bufferIndex: index)
            write(.txbar, 1 << index)
            handle.write(.latestTxFifoQRequest, value: 1 << index)
            return .ok
        }
        return fail(FD.HAL_FDCAN_ERROR_NOT_STARTED)
    }
    func copyMessageToRAM(header h: FDCANTxHeader, data: UnsafePointer<UInt8>, bufferIndex: UInt32) {
        let first: UInt32
        if h.idType == FD.FDCAN_STANDARD_ID { first = h.errorStateIndicator | FD.FDCAN_STANDARD_ID | h.txFrameType | (h.identifier << 18) }
        else { first = h.errorStateIndicator | FD.FDCAN_EXTENDED_ID | h.txFrameType | h.identifier }
        let second = (h.messageMarker << 24) | h.txEventFifoControl | h.fdFormat | h.bitRateSwitch | (h.dataLength << 16)
        var address = handle.read(.txFIFOQSA) &+ (bufferIndex &* FD.SRAMCAN_TFQ_SIZE)
        registers.writeMemory32(at: address, value: first); address &+= 4
        registers.writeMemory32(at: address, value: second); address &+= 4
        var counter: UInt32 = 0
        // C reads a complete word even for a short final payload: the input must include that padding.
        while counter < Self.payloadByteCount(dataLength: h.dataLength) {
            registers.writeMemory32(at: address, value: (UInt32(data[Int(counter &+ 3)]) << 24) |
                (UInt32(data[Int(counter &+ 2)]) << 16) | (UInt32(data[Int(counter &+ 1)]) << 8) | UInt32(data[Int(counter)]))
            address &+= 4; counter &+= 4
        }
    }
    @discardableResult
    public func getRxMessage(location: UInt32, header: inout FDCANRxHeader, data: UnsafeMutablePointer<UInt8>) -> HALStatus {
        let state = getState()
        if state != FD.HAL_FDCAN_STATE_BUSY { return fail(FD.HAL_FDCAN_ERROR_NOT_STARTED) }
        var index: UInt32
        var address: UInt32
        if location == FD.FDCAN_RX_FIFO0 {
            if read(.rxf0s) & FD.FDCAN_RXF0S_F0FL == 0 { return fail(FD.HAL_FDCAN_ERROR_FIFO_EMPTY) }
            index = (read(.rxf0s) & FD.FDCAN_RXF0S_F0GI) >> FD.FDCAN_RXF0S_F0GI_Pos
            if (read(.rxf0s) & FD.FDCAN_RXF0S_F0F) >> FD.FDCAN_RXF0S_F0F_Pos == 1 {
                if (read(.rxgfc) & FD.FDCAN_RXGFC_F0OM) >> FD.FDCAN_RXGFC_F0OM_Pos == FD.FDCAN_RX_FIFO_OVERWRITE {
                    index = (index &+ 1) & FD.SRAMCAN_RF0_NBR
                }
            }
            address = handle.read(.rxFIFO0SA) &+ (index &* FD.SRAMCAN_RF0_SIZE)
        } else {
            if read(.rxf1s) & FD.FDCAN_RXF1S_F1FL == 0 { return fail(FD.HAL_FDCAN_ERROR_FIFO_EMPTY) }
            index = (read(.rxf1s) & FD.FDCAN_RXF1S_F1GI) >> FD.FDCAN_RXF1S_F1GI_Pos
            if (read(.rxf1s) & FD.FDCAN_RXF1S_F1F) >> FD.FDCAN_RXF1S_F1F_Pos == 1 {
                if (read(.rxgfc) & FD.FDCAN_RXGFC_F1OM) >> FD.FDCAN_RXGFC_F1OM_Pos == FD.FDCAN_RX_FIFO_OVERWRITE {
                    index = (index &+ 1) & FD.SRAMCAN_RF1_NBR
                }
            }
            address = handle.read(.rxFIFO1SA) &+ (index &* FD.SRAMCAN_RF1_SIZE)
        }
        header.idType = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_XTD
        if header.idType == FD.FDCAN_STANDARD_ID { header.identifier = (registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_STDID) >> 18 }
        else { header.identifier = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_EXTID }
        header.rxFrameType = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_RTR
        header.errorStateIndicator = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_ESI
        address &+= 4
        header.rxTimestamp = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_TS
        header.dataLength = (registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_DLC) >> 16
        header.bitRateSwitch = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_BRS
        header.fdFormat = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_FDF
        header.filterIndex = (registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_FIDX) >> 24
        header.isFilterMatchingFrame = (registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_ANMF) >> 31
        address &+= 4
        var counter: UInt32 = 0
        while counter < Self.payloadByteCount(dataLength: header.dataLength) {
            data[Int(counter)] = registers.readMemory8(at: address &+ counter); counter &+= 1
        }
        if location == FD.FDCAN_RX_FIFO0 { write(.rxf0a, index) } else { write(.rxf1a, index) }
        return .ok
    }
    @discardableResult
    public func getTxEvent(_ event: inout FDCANTxEvent) -> HALStatus {
        let state = getState()
        if state != FD.HAL_FDCAN_STATE_BUSY { return fail(FD.HAL_FDCAN_ERROR_NOT_STARTED) }
        if read(.txefs) & FD.FDCAN_TXEFS_EFFL == 0 { return fail(FD.HAL_FDCAN_ERROR_FIFO_EMPTY) }
        let index = (read(.txefs) & FD.FDCAN_TXEFS_EFGI) >> FD.FDCAN_TXEFS_EFGI_Pos
        var address = handle.read(.txEventFIFOSA) &+ (index &* FD.SRAMCAN_TEF_SIZE)
        event.idType = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_XTD
        if event.idType == FD.FDCAN_STANDARD_ID { event.identifier = (registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_STDID) >> 18 }
        else { event.identifier = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_EXTID }
        event.txFrameType = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_RTR
        event.errorStateIndicator = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_ESI
        address &+= 4
        event.txTimestamp = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_TS
        event.dataLength = (registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_DLC) >> 16
        event.bitRateSwitch = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_BRS
        event.fdFormat = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_FDF
        event.eventType = registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_ET
        event.messageMarker = (registers.readMemory32(at: address) & FD.FDCAN_ELEMENT_MASK_MM) >> 24
        write(.txefa, index)
        return .ok
    }
}
