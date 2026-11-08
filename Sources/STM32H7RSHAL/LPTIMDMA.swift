// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LPTIM operations and definitions from stm32h7rsxx_hal_lptim.c/.h and
// stm32h7rsxx_ll_lptim.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum LPTIMDMACallbackKind: UInt32, CaseIterable, Sendable {
    case error = 0, captureComplete, captureHalfComplete, updateComplete, updateHalfComplete
}
public protocol LPTIMDMAIO {
    func read(_ channel: LPTIMChannel, word: DMAHandleWord) -> UInt32
    func readMemory32(_ channel: LPTIMChannel, at address: UInt32) -> UInt32
    func writeMemory32(_ channel: LPTIMChannel, at address: UInt32, value: UInt32)
    func writeCallback(_ channel: LPTIMChannel, id: DMACallbackID, value: DMACallback?)
    func callback(_ kind: LPTIMDMACallbackKind) -> DMACallback
    func matches(_ channel: LPTIMChannel, context: UnsafeMutableRawPointer?) -> Bool
    func startInterrupt(_ channel: LPTIMChannel, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus
    func startLinkedListInterrupt(_ channel: LPTIMChannel) -> HALStatus
    func abortInterrupt(_ channel: LPTIMChannel) -> HALStatus
}
public typealias LPTIMDMAParentReader = @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
public typealias LPTIMDMADispatcher = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UInt32) -> Void
// The descriptor and its DMA context must outlive every pending transfer/IRQ.
// dmaContext identifies the linked handle; Parent is read at callback time.
public struct LPTIMDMACallbackContext {
    public let dmaContext: UnsafeMutableRawPointer?
    public let readParent: LPTIMDMAParentReader
    public let dispatch: LPTIMDMADispatcher
    public init(dmaContext: UnsafeMutableRawPointer?, readParent: @escaping LPTIMDMAParentReader,
                dispatch: @escaping LPTIMDMADispatcher) {
        self.dmaContext = dmaContext; self.readParent = readParent; self.dispatch = dispatch
    }
}
extension LPTIM {
    @discardableResult
    public func startPWMDMA<D: LPTIMDMAIO>(channel: LPTIMChannel, data: UnsafePointer<UInt32>?, length: UInt32, dma: D) -> HALStatus {
        precondition(registers.instance.supportsCaptureAndDMA)
        guard let data, length != 0 else { return .error }
        guard handle.read(channelWord(channel)) == 1 else { return .error }
        handle.write(.state, value: 2); handle.write(channelWord(channel), value: 2)
        modify(.cfgr, clear: 0x100000); enable(); enableDMARequests(.update)
        if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
        dma.writeCallback(channel, id: .transferComplete, value: dma.callback(.updateComplete))
        dma.writeCallback(channel, id: .halfTransfer, value: dma.callback(.updateHalfComplete))
        dma.writeCallback(channel, id: .error, value: dma.callback(.error))
        if startDMA(dma, channel: channel, source: UInt32(truncatingIfNeeded: UInt(bitPattern: data)),
                    destination: registers.address(of: channel == .channel1 ? .ccr1 : .ccr2), length: length) != .ok { return .error }
        enableCaptureCompare(channel: channel); startContinuous()
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func stopPWMDMA<D: LPTIMDMAIO>(channel: LPTIMChannel, dma: D) -> HALStatus {
        precondition(registers.instance.supportsCaptureAndDMA)
        handle.write(.state, value: 2); disableDMARequests(.update)
        _ = dma.abortInterrupt(channel)
        disableCaptureCompare(channel: channel); disable()
        handle.write(channelWord(channel), value: 1); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func startInputCaptureDMA<D: LPTIMDMAIO>(channel: LPTIMChannel, data: UnsafeMutablePointer<UInt32>?, length: UInt32, dma: D) -> HALStatus {
        precondition(registers.instance.supportsCaptureAndDMA)
        guard let data, length != 0 else { return .error }
        guard handle.read(channelWord(channel)) == 1 else { return .error }
        handle.write(.state, value: 2); handle.write(channelWord(channel), value: 2)
        enable()
        dma.writeCallback(channel, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(channel, id: .halfTransfer, value: dma.callback(.captureHalfComplete))
        dma.writeCallback(channel, id: .error, value: dma.callback(.error))
        if startDMA(dma, channel: channel, source: registers.address(of: channel == .channel1 ? .ccr1 : .ccr2),
                    destination: UInt32(truncatingIfNeeded: UInt(bitPattern: data)), length: length) != .ok { return .error }
        enableDMARequests(channel == .channel1 ? .captureCompare1 : .captureCompare2)
        if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
        startContinuous(); enableCaptureCompare(channel: channel)
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func stopInputCaptureDMA<D: LPTIMDMAIO>(channel: LPTIMChannel, dma: D) -> HALStatus {
        precondition(registers.instance.supportsCaptureAndDMA)
        handle.write(.state, value: 2)
        disableDMARequests(channel == .channel1 ? .captureCompare1 : .captureCompare2)
        _ = dma.abortInterrupt(channel)
        disableCaptureCompare(channel: channel); disable()
        handle.write(channelWord(channel), value: 1); handle.write(.state, value: 1)
        return .ok
    }
    func startDMA<D: LPTIMDMAIO>(_ dma: D, channel: LPTIMChannel, source: UInt32, destination: UInt32, length: UInt32) -> HALStatus {
        if dma.read(channel, word: .mode) & 0x80 == 0x80 {
            if dma.read(channel, word: .queueAddress) != 0 && dma.readMemory32(channel, at: dma.read(channel, word: .queueAddress)) != 0 {
                dma.writeMemory32(channel, at: dma.readMemory32(channel, at: dma.read(channel, word: .queueAddress)) &+ 8, value: length)
                dma.writeMemory32(channel, at: dma.readMemory32(channel, at: dma.read(channel, word: .queueAddress)) &+ 12, value: source)
                dma.writeMemory32(channel, at: dma.readMemory32(channel, at: dma.read(channel, word: .queueAddress)) &+ 16, value: destination)
                return dma.startLinkedListInterrupt(channel)
            }
            return .error
        }
        return dma.startInterrupt(channel, sourceAddress: source, destinationAddress: destination, sourceDataSize: length)
    }
    public func handleDMAEvent<D: LPTIMDMAIO>(_ kind: LPTIMDMACallbackKind, sourceContext: UnsafeMutableRawPointer?, dma: D) {
        handle.write(.state, value: 1)
        if kind == .error { invoke(.error); return }
        if dma.matches(.channel1, context: sourceContext) { handle.write(.activeChannel, value: 1) }
        else if dma.matches(.channel2, context: sourceContext) { handle.write(.activeChannel, value: 2) }
        switch kind {
        case .captureComplete: invoke(.inputCapture)
        case .captureHalfComplete: invoke(.inputCaptureHalfComplete)
        case .updateComplete: invoke(.updateEvent)
        case .updateHalfComplete: invoke(.updateHalfComplete)
        case .error: break
        }
        handle.write(.activeChannel, value: 0)
    }
}
