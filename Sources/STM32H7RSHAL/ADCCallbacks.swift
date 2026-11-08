// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias ADCCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum ADCCallbackID: UInt32, CaseIterable, Sendable {
    case conversionComplete = 0
    case conversionHalfComplete = 1
    case analogWatchdog1 = 2
    case error = 3
    case injectedComplete = 4
    case injectedQueueOverflow = 5
    case analogWatchdog2 = 6
    case analogWatchdog3 = 7
    case endSampling = 8
    case mspInitialize = 9
    case mspDeinitialize = 10
}
public protocol ADCCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: ADCCallbackID) -> ADCCallback?
    func write(_ id: ADCCallbackID, value: ADCCallback?)
}
public struct ADCCallbackDefaults {
    public var conversionComplete: ADCCallback
    public var conversionHalfComplete: ADCCallback
    public var analogWatchdog1: ADCCallback
    public var error: ADCCallback
    public var injectedComplete: ADCCallback
    public var injectedQueueOverflow: ADCCallback
    public var analogWatchdog2: ADCCallback
    public var analogWatchdog3: ADCCallback
    public var endSampling: ADCCallback
    public var mspInitialize: ADCCallback
    public var mspDeinitialize: ADCCallback
    public init(conversionComplete: @escaping ADCCallback = { _ in }, conversionHalfComplete: @escaping ADCCallback = { _ in }, analogWatchdog1: @escaping ADCCallback = { _ in }, error: @escaping ADCCallback = { _ in }, injectedComplete: @escaping ADCCallback = { _ in }, injectedQueueOverflow: @escaping ADCCallback = { _ in }, analogWatchdog2: @escaping ADCCallback = { _ in }, analogWatchdog3: @escaping ADCCallback = { _ in }, endSampling: @escaping ADCCallback = { _ in }, mspInitialize: @escaping ADCCallback = { _ in }, mspDeinitialize: @escaping ADCCallback = { _ in }) {
        self.conversionComplete = conversionComplete
        self.conversionHalfComplete = conversionHalfComplete
        self.analogWatchdog1 = analogWatchdog1
        self.error = error
        self.injectedComplete = injectedComplete
        self.injectedQueueOverflow = injectedQueueOverflow
        self.analogWatchdog2 = analogWatchdog2
        self.analogWatchdog3 = analogWatchdog3
        self.endSampling = endSampling
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
    }
    public func callback(_ id: ADCCallbackID) -> ADCCallback {
        switch id {
        case .conversionComplete: return conversionComplete
        case .conversionHalfComplete: return conversionHalfComplete
        case .analogWatchdog1: return analogWatchdog1
        case .error: return error
        case .injectedComplete: return injectedComplete
        case .injectedQueueOverflow: return injectedQueueOverflow
        case .analogWatchdog2: return analogWatchdog2
        case .analogWatchdog3: return analogWatchdog3
        case .endSampling: return endSampling
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        }
    }
}
extension ADC {
    @discardableResult
    public func registerCallback(id: UInt32, callback: ADCCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(16); return .error }
        if handle.read(.state) & 1 != 0 || (handle.read(.state) == 0 && (id == 9 || id == 10)),
           let id = ADCCallbackID(rawValue: id) {
            callbacks.write(id, value: callback); return .ok
        }
        addError(16); return .error
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        if handle.read(.state) & 1 != 0 || (handle.read(.state) == 0 && (id == 9 || id == 10)),
           let id = ADCCallbackID(rawValue: id) {
            callbacks.write(id, value: defaults.callback(id)); return .ok
        }
        addError(16); return .error
    }
    func invoke(_ id: ADCCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func prepareMSPCallback(_ id: ADCCallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks {
            callbacks.write(.mspInitialize, value: nil)
            callbacks.write(.mspDeinitialize, value: nil)
        }
    }
}
