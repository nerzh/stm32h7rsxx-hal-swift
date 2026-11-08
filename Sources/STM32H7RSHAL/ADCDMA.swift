// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    @discardableResult
    public func startDMA(destinationAddress: UInt32, length: UInt32, getTick: () -> UInt32) -> HALStatus {
        startDMA(destinationAddress: destinationAddress, length: length, multimode: false, getTick: getTick)
    }
    @discardableResult
    public func startMultimodeDMA(destinationAddress: UInt32, length: UInt32, getTick: () -> UInt32) -> HALStatus {
        startDMA(destinationAddress: destinationAddress, length: length, multimode: true, getTick: getTick)
    }
    private func startDMA(destinationAddress: UInt32, length: UInt32, multimode: Bool, getTick: () -> UInt32) -> HALStatus {
        let mode = multimode ? 0 : LL_ADC_GetMultimode()
        if LL_ADC_REG_IsConversionOngoing(instance) != 0 { return .busy }
        if !tryLock() { return .busy }
        if multimode {
            if instance != .adc1 { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); unlock(); return .error }
        } else if !regularIndependent(mode) { unlock(); return .error }
        var status = enable(getTick: getTick)
        if multimode && status == .ok { status = enable(instance: .adc2, getTick: getTick, recordError: false) }
        if status == .ok {
            modifyState(clear: ADCC.HAL_ADC_STATE_READY | ADCC.HAL_ADC_STATE_REG_EOC | ADCC.HAL_ADC_STATE_REG_OVR | ADCC.HAL_ADC_STATE_REG_EOSMP,
                        set: ADCC.HAL_ADC_STATE_REG_BUSY)
            if !multimode {
                if instance == .adc1 || mode == ADCC.LL_ADC_MULTI_INDEPENDENT { clearState(ADCC.HAL_ADC_STATE_MULTIMODE_SLAVE) }
            }
            if !multimode && handle.read(.state) & ADCC.HAL_ADC_STATE_INJ_BUSY != 0 { clearError(ADCC.HAL_ADC_ERROR_OVR | ADCC.HAL_ADC_ERROR_DMA) }
            else { handle.write(.errorCode, value: 0) }
            dma.writeCallback(.transferComplete, value: dma.callback(.complete))
            dma.writeCallback(.halfTransfer, value: dma.callback(.halfComplete))
            dma.writeCallback(.error, value: dma.callback(.error))
            clearFlag(ADCC.ADC_FLAG_EOC | ADCC.ADC_FLAG_EOS | ADCC.ADC_FLAG_OVR)
            unlock()
            enableInterrupts(ADCC.ADC_IT_OVR)
            if !multimode { setBits(.cfgr, ADCC.ADC_CFGR_DMAEN) }
            let bytes: UInt32
            if dma.read(.mode) & 0x80 == 0x80 {
                if dma.read(.queueAddress) == 0 { return .error }
                if dma.readMemory32(at: dma.read(.queueAddress)) == 0 { return .error }
                var width: UInt32 = 0
                if dma.getNodeSourceWidth(at: dma.readMemory32(at: dma.read(.queueAddress)), width: &width) != .ok { return .error }
                if width == 2 { bytes = length &* 4 } else if width == 1 { bytes = length &* 2 } else { bytes = length }
                dma.writeMemory32(at: dma.readMemory32(at: dma.read(.queueAddress)) &+ 8, value: bytes)
                dma.writeMemory32(at: dma.readMemory32(at: dma.read(.queueAddress)) &+ 12,
                                  value: multimode ? registers.commonDataAddress() : registers.dataAddress(instance: instance))
                dma.writeMemory32(at: dma.readMemory32(at: dma.read(.queueAddress)) &+ 16, value: destinationAddress)
                status = dma.startLinkedListInterrupt()
            } else {
                if dma.sourceDataWidth() == 2 { bytes = length &* 4 }
                else if dma.sourceDataWidth() == 1 { bytes = length &* 2 }
                else { bytes = length }
                status = dma.startInterrupt(sourceAddress: multimode ? registers.commonDataAddress() : registers.dataAddress(instance: instance),
                                            destinationAddress: destinationAddress, sourceDataSize: bytes)
            }
            // Even a DMA submission error is followed by the ADC start command in C.
            LL_ADC_REG_StartConversion(instance)
        } else { unlock() }
        return status
    }
    @discardableResult
    public func stopDMA(getTick: () -> UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        var status = conversionStop(group: ADCC.ADC_REGULAR_INJECTED_GROUP, getTick: getTick)
        if status == .ok {
            clearBits(.cfgr, ADCC.ADC_CFGR_DMAEN)
            if dma.read(.state) == DMAState.busy.rawValue {
                status = dma.abort(getTick: getTick)
                if status != .ok { addState(ADCC.HAL_ADC_STATE_ERROR_DMA) }
            }
            disableInterrupts(ADCC.ADC_IT_OVR)
            if status == .ok { status = disable(getTick: getTick) } else { _ = disable(getTick: getTick) }
            if status == .ok { modifyState(clear: ADCC.HAL_ADC_STATE_REG_BUSY | ADCC.HAL_ADC_STATE_INJ_BUSY, set: ADCC.HAL_ADC_STATE_READY) }
        }
        unlock(); return status
    }
    @discardableResult
    public func stopRegularDMA(getTick: () -> UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        var status = conversionStop(group: ADCC.ADC_REGULAR_GROUP, getTick: getTick)
        if status == .ok {
            clearState(ADCC.HAL_ADC_STATE_REG_BUSY)
            clearBits(.cfgr, ADCC.ADC_CFGR_DMAEN)
            if dma.read(.state) == DMAState.busy.rawValue {
                status = dma.abort(getTick: getTick)
                if status == .error { addState(ADCC.HAL_ADC_STATE_ERROR_DMA) }
            }
            disableInterrupts(ADCC.ADC_IT_OVR)
            if LL_ADC_INJ_IsConversionOngoing(instance) == 0 {
                if status == .ok { status = disable(getTick: getTick) } else { _ = disable(getTick: getTick) }
                if status == .ok { modifyState(clear: ADCC.HAL_ADC_STATE_INJ_BUSY, set: ADCC.HAL_ADC_STATE_READY) }
            } else { addState(ADCC.HAL_ADC_STATE_INJ_BUSY) }
        }
        unlock(); return status
    }
    func waitMultimodeRegularStop(getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        var slaveOngoing = LL_ADC_REG_IsConversionOngoing(.adc2)
        while LL_ADC_REG_IsConversionOngoing(instance) == 1 || slaveOngoing == 1 {
            if getTick() &- start > ADCC.ADC_STOP_CONVERSION_TIMEOUT {
                slaveOngoing = LL_ADC_REG_IsConversionOngoing(.adc2)
                if LL_ADC_REG_IsConversionOngoing(instance) == 1 || slaveOngoing == 1 {
                    addState(ADCC.HAL_ADC_STATE_ERROR_INTERNAL); unlock(); return .error
                }
            }
            slaveOngoing = LL_ADC_REG_IsConversionOngoing(.adc2)
        }
        return .ok
    }
    @discardableResult
    public func stopMultimodeDMA(getTick: () -> UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        var status = conversionStop(group: ADCC.ADC_REGULAR_INJECTED_GROUP, getTick: getTick)
        if status == .ok {
            if instance != .adc1 { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); unlock(); return .error }
            if waitMultimodeRegularStop(getTick: getTick) != .ok { return .error }
            if dma.read(.state) == DMAState.busy.rawValue {
                status = dma.abort(getTick: getTick)
                if status == .error { addState(ADCC.HAL_ADC_STATE_ERROR_DMA) }
            }
            disableInterrupts(ADCC.ADC_IT_OVR)
            if status == .ok {
                let slaveStatus = disable(instance: .adc2, getTick: getTick, recordError: false)
                if disable(getTick: getTick) == .ok && slaveStatus == .ok { status = .ok }
                // The original function leaves status at OK when either disable fails.
            } else {
                _ = disable(getTick: getTick)
                _ = disable(instance: .adc2, getTick: getTick, recordError: false)
            }
            modifyState(clear: ADCC.HAL_ADC_STATE_REG_BUSY | ADCC.HAL_ADC_STATE_INJ_BUSY, set: ADCC.HAL_ADC_STATE_READY)
        }
        unlock(); return status
    }
    @discardableResult
    public func stopRegularMultimodeDMA(getTick: () -> UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        var status = conversionStop(group: ADCC.ADC_REGULAR_GROUP, getTick: getTick)
        if status == .ok {
            clearState(ADCC.HAL_ADC_STATE_REG_BUSY)
            if instance != .adc1 { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); unlock(); return .error }
            if waitMultimodeRegularStop(getTick: getTick) != .ok { return .error }
            if dma.read(.state) == DMAState.busy.rawValue {
                status = dma.abort(getTick: getTick)
                if status == .error { addState(ADCC.HAL_ADC_STATE_ERROR_DMA) }
            }
            disableInterrupts(ADCC.ADC_IT_OVR)
            if status == .ok {
                if LL_ADC_INJ_IsConversionOngoing(instance) == 0 {
                    status = disable(getTick: getTick)
                    if status == .ok {
                        if LL_ADC_INJ_IsConversionOngoing(.adc2) == 0 { status = disable(instance: .adc2, getTick: getTick, recordError: false) }
                    }
                }
                if status == .ok { modifyState(clear: ADCC.HAL_ADC_STATE_INJ_BUSY, set: ADCC.HAL_ADC_STATE_READY) }
            }
        }
        unlock(); return status
    }
    public func getMultimodeValue() -> UInt32 { registers.readCommon(.cdr) }
}
