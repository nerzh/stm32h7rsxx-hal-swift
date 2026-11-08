// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum FDCANInstance: UInt32, CaseIterable, Sendable { case fdcan1 = 0, fdcan2 = 1 }
public enum FDCANRegister: UInt32, CaseIterable, Sendable {
    case crel = 0x0
    case endn = 0x4
    case dbtp = 0xC
    case test = 0x10
    case rwd = 0x14
    case cccr = 0x18
    case nbtp = 0x1C
    case tscc = 0x20
    case tscv = 0x24
    case tocc = 0x28
    case tocv = 0x2C
    case ecr = 0x40
    case psr = 0x44
    case tdcr = 0x48
    case ir = 0x50
    case ie = 0x54
    case ils = 0x58
    case ile = 0x5C
    case rxgfc = 0x80
    case xidam = 0x84
    case hpms = 0x88
    case rxf0s = 0x90
    case rxf0a = 0x94
    case rxf1s = 0x98
    case rxf1a = 0x9C
    case txbc = 0xC0
    case txfqs = 0xC4
    case txbrp = 0xC8
    case txbar = 0xCC
    case txbcr = 0xD0
    case txbto = 0xD4
    case txbcf = 0xD8
    case txbtie = 0xDC
    case txbcie = 0xE0
    case txefs = 0xE4
    case txefa = 0xE8
}
public protocol FDCANRegisterIO {
    func read(_ register: FDCANRegister) -> UInt32
    func write(_ register: FDCANRegister, value: UInt32)
    func readClockDivider() -> UInt32
    func writeClockDivider(_ value: UInt32)
    func messageRAMBase() -> UInt32
    func readMemory32(at address: UInt32) -> UInt32
    func writeMemory32(at address: UInt32, value: UInt32)
    func readMemory8(at address: UInt32) -> UInt8
}
public enum FDCANHandleWord: Int, CaseIterable {
    case clockDivider = 0
    case frameFormat = 1
    case mode = 2
    case autoRetransmission = 3
    case transmitPause = 4
    case protocolException = 5
    case nominalPrescaler = 6
    case nominalSyncJumpWidth = 7
    case nominalTimeSeg1 = 8
    case nominalTimeSeg2 = 9
    case dataPrescaler = 10
    case dataSyncJumpWidth = 11
    case dataTimeSeg1 = 12
    case dataTimeSeg2 = 13
    case stdFiltersNbr = 14
    case extFiltersNbr = 15
    case txFifoQueueMode = 16
    case standardFilterSA = 17
    case extendedFilterSA = 18
    case rxFIFO0SA = 19
    case rxFIFO1SA = 20
    case txEventFIFOSA = 21
    case txFIFOQSA = 22
    case latestTxFifoQRequest = 23
    case state = 24
    case lock = 25
    case errorCode = 26
}
public protocol FDCANHandleIO {
    func read(_ word: FDCANHandleWord) -> UInt32
    func write(_ word: FDCANHandleWord, value: UInt32)
}
public struct FDCAN<Registers: FDCANRegisterIO, Handle: FDCANHandleIO, Callbacks: FDCANCallbackIO> {
    public let instance: FDCANInstance
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: FDCANDefaultCallbacks
    public let useRegisteredCallbacks: Bool
    public init(instance: FDCANInstance, registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: FDCANDefaultCallbacks = .init(), useRegisteredCallbacks: Bool = false) {
        self.instance = instance; self.registers = registers; self.handle = handle
        self.callbacks = callbacks; self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
    func read(_ r: FDCANRegister) -> UInt32 { registers.read(r) }
    func write(_ r: FDCANRegister, _ value: UInt32) { registers.write(r, value: value) }
    func modify(_ r: FDCANRegister, clear: UInt32, set: UInt32) { write(r, (read(r) & ~clear) | set) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func fail(_ error: UInt32) -> HALStatus { addError(error); return .error }
    func timeoutError() -> HALStatus { addError(FD.HAL_FDCAN_ERROR_TIMEOUT); handle.write(.state, value: FD.HAL_FDCAN_STATE_ERROR); return .error }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func getLatestTxFifoQRequestBuffer() -> UInt32 { handle.read(.latestTxFifoQRequest) }
    public func setConfiguration(_ c: FDCANConfiguration) {
        handle.write(.clockDivider, value: c.clockDivider)
        handle.write(.frameFormat, value: c.frameFormat)
        handle.write(.mode, value: c.mode)
        handle.write(.autoRetransmission, value: c.autoRetransmission)
        handle.write(.transmitPause, value: c.transmitPause)
        handle.write(.protocolException, value: c.protocolException)
        handle.write(.nominalPrescaler, value: c.nominalPrescaler)
        handle.write(.nominalSyncJumpWidth, value: c.nominalSyncJumpWidth)
        handle.write(.nominalTimeSeg1, value: c.nominalTimeSeg1)
        handle.write(.nominalTimeSeg2, value: c.nominalTimeSeg2)
        handle.write(.dataPrescaler, value: c.dataPrescaler)
        handle.write(.dataSyncJumpWidth, value: c.dataSyncJumpWidth)
        handle.write(.dataTimeSeg1, value: c.dataTimeSeg1)
        handle.write(.dataTimeSeg2, value: c.dataTimeSeg2)
        handle.write(.stdFiltersNbr, value: c.stdFiltersNbr)
        handle.write(.extFiltersNbr, value: c.extFiltersNbr)
        handle.write(.txFifoQueueMode, value: c.txFifoQueueMode)
    }
    public func enableInterrupts(_ mask: UInt32) { modify(.ie, clear: 0, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { modify(.ie, clear: mask, set: 0) }
    public func clearFlag(_ mask: UInt32) { write(.ir, mask) }
    public func getFlag(_ mask: UInt32) -> UInt32 { read(.ir) & mask }
    public func getInterruptSource(_ mask: UInt32) -> UInt32 { read(.ie) & mask }
}
