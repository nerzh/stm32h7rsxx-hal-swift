// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// GFXTIM definitions from stm32h7rsxx_hal_gfxtim.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias GFXTIMCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum GFXTIMCallbackID: UInt32, CaseIterable, Sendable {
    case absoluteFrameCompare1 = 1
    case absoluteFrameOverflow = 2
    case absoluteLineCompare1 = 3
    case absoluteLineCompare2 = 4
    case absoluteLineOverflow = 5
    case relativeFrame1Reload = 6
    case relativeFrame2Reload = 7
    case tearingEffect = 8
    case event1 = 9
    case event2 = 10
    case event3 = 11
    case event4 = 12
    case watchdogAlarm = 13
    case watchdogPreAlarm = 14
    case error = 15
    case mspInitialize = 16
    case mspDeinitialize = 17
}
public protocol GFXTIMCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: GFXTIMCallbackID) -> GFXTIMCallback?
    func write(_ id: GFXTIMCallbackID, value: GFXTIMCallback?)
}
public struct GFXTIMCallbackDefaults {
    public var absoluteFrameCompare1: GFXTIMCallback
    public var absoluteFrameOverflow: GFXTIMCallback
    public var absoluteLineCompare1: GFXTIMCallback
    public var absoluteLineCompare2: GFXTIMCallback
    public var absoluteLineOverflow: GFXTIMCallback
    public var relativeFrame1Reload: GFXTIMCallback
    public var relativeFrame2Reload: GFXTIMCallback
    public var tearingEffect: GFXTIMCallback
    public var event1: GFXTIMCallback
    public var event2: GFXTIMCallback
    public var event3: GFXTIMCallback
    public var event4: GFXTIMCallback
    public var watchdogAlarm: GFXTIMCallback
    public var watchdogPreAlarm: GFXTIMCallback
    public var error: GFXTIMCallback
    public var mspInitialize: GFXTIMCallback
    public var mspDeinitialize: GFXTIMCallback
    public init(absoluteFrameCompare1: @escaping GFXTIMCallback = { _ in },
                absoluteFrameOverflow: @escaping GFXTIMCallback = { _ in },
                absoluteLineCompare1: @escaping GFXTIMCallback = { _ in },
                absoluteLineCompare2: @escaping GFXTIMCallback = { _ in },
                absoluteLineOverflow: @escaping GFXTIMCallback = { _ in },
                relativeFrame1Reload: @escaping GFXTIMCallback = { _ in },
                relativeFrame2Reload: @escaping GFXTIMCallback = { _ in },
                tearingEffect: @escaping GFXTIMCallback = { _ in },
                event1: @escaping GFXTIMCallback = { _ in },
                event2: @escaping GFXTIMCallback = { _ in },
                event3: @escaping GFXTIMCallback = { _ in },
                event4: @escaping GFXTIMCallback = { _ in },
                watchdogAlarm: @escaping GFXTIMCallback = { _ in },
                watchdogPreAlarm: @escaping GFXTIMCallback = { _ in },
                error: @escaping GFXTIMCallback = { _ in },
                mspInitialize: @escaping GFXTIMCallback = { _ in },
                mspDeinitialize: @escaping GFXTIMCallback = { _ in }) {
        self.absoluteFrameCompare1 = absoluteFrameCompare1
        self.absoluteFrameOverflow = absoluteFrameOverflow
        self.absoluteLineCompare1 = absoluteLineCompare1
        self.absoluteLineCompare2 = absoluteLineCompare2
        self.absoluteLineOverflow = absoluteLineOverflow
        self.relativeFrame1Reload = relativeFrame1Reload
        self.relativeFrame2Reload = relativeFrame2Reload
        self.tearingEffect = tearingEffect
        self.event1 = event1
        self.event2 = event2
        self.event3 = event3
        self.event4 = event4
        self.watchdogAlarm = watchdogAlarm
        self.watchdogPreAlarm = watchdogPreAlarm
        self.error = error
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
    }
    public func callback(_ id: GFXTIMCallbackID) -> GFXTIMCallback {
        switch id {
        case .absoluteFrameCompare1: return absoluteFrameCompare1
        case .absoluteFrameOverflow: return absoluteFrameOverflow
        case .absoluteLineCompare1: return absoluteLineCompare1
        case .absoluteLineCompare2: return absoluteLineCompare2
        case .absoluteLineOverflow: return absoluteLineOverflow
        case .relativeFrame1Reload: return relativeFrame1Reload
        case .relativeFrame2Reload: return relativeFrame2Reload
        case .tearingEffect: return tearingEffect
        case .event1: return event1
        case .event2: return event2
        case .event3: return event3
        case .event4: return event4
        case .watchdogAlarm: return watchdogAlarm
        case .watchdogPreAlarm: return watchdogPreAlarm
        case .error: return error
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        }
    }
}
public struct GFXTIMUnregisteredCallbacks: GFXTIMCallbackIO {
    public let context: UnsafeMutableRawPointer?
    public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
    public func read(_ id: GFXTIMCallbackID) -> GFXTIMCallback? { nil }
    public func write(_ id: GFXTIMCallbackID, value: GFXTIMCallback?) { preconditionFailure("GFXTIM callback storage is absent") }
}
