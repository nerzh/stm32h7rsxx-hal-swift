@testable import STM32H7RSHAL
import CJPEGReference

struct JPEGEventSource: JPEGDMAEventSourceIO {
    let model: JPEGModel
    let stream: UInt32
    func getCounter() -> UInt32 { model.get(4, stream * 16 + 9) }
    func getFIFOLevel() -> UInt32 { model.get(4, stream * 16 + 10) }
    func getError() -> DMAError { .init(rawValue: model.get(4, stream * 16 + 15)) }
}
struct JPEGModel: JPEGRegisterIO, JPEGHandleIO, JPEGCallbackIO, JPEGDMAIO {
    let state: OpaquePointer
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CJPEG_Get(state, area, index) }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CJPEG_Set(state, area, index, value) }
    func read(_ register: JPEGRegister) -> UInt32 { get(0, register.rawValue / 4) }
    func write(_ register: JPEGRegister, value: UInt32) { set(0, register.rawValue / 4, value) }
    func readTable(_ table: JPEGTable, index: Int) -> UInt32 { get(0, table.rawValue / 4 + UInt32(index)) }
    func writeTable(_ table: JPEGTable, index: Int, value: UInt32) { set(0, table.rawValue / 4 + UInt32(index), value) }
    func dataAddress(_ stream: JPEGStream) -> UInt32 { stream == .input ? 0x52003040 : 0x52003044 }
    func read(_ word: JPEGHandleWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
    func write(_ word: JPEGHandleWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
    func readBuffer(_ stream: JPEGStream) -> UnsafeMutablePointer<UInt8>? { CJPEG_GetBuffer(state, stream.rawValue) }
    func writeBuffer(_ stream: JPEGStream, value: UnsafeMutablePointer<UInt8>?) { CJPEG_SetBuffer(state, stream.rawValue, value) }
    func readQuantizationTable(_ index: Int) -> UnsafePointer<UInt8>? { CJPEG_GetQuantization(state, UInt32(index)) }
    func writeQuantizationTable(_ index: Int, value: UnsafePointer<UInt8>?) { CJPEG_SetQuantization(state, UInt32(index), value) }
    var configurationPointer: UnsafeMutablePointer<UInt32> { CJPEG_Configuration(state)! }
    func callback(_ id: JPEGCallbackID, _ token: UInt32) -> JPEGCallback? {
        if token == 0 { return nil }
        switch id {
        case .encodeComplete: return token == 1 ? { CJPEG_Callback(OpaquePointer($0!), 1, 1, 0, 0) } : { CJPEG_Callback(OpaquePointer($0!), 1, 2, 0, 0) }
        case .decodeComplete: return token == 1 ? { CJPEG_Callback(OpaquePointer($0!), 2, 1, 0, 0) } : { CJPEG_Callback(OpaquePointer($0!), 2, 2, 0, 0) }
        case .error: return token == 1 ? { CJPEG_Callback(OpaquePointer($0!), 3, 1, 0, 0) } : { CJPEG_Callback(OpaquePointer($0!), 3, 2, 0, 0) }
        case .mspInitialize: return token == 1 ? { CJPEG_Callback(OpaquePointer($0!), 4, 1, 0, 0) } : { CJPEG_Callback(OpaquePointer($0!), 4, 2, 0, 0) }
        case .mspDeinitialize: return token == 1 ? { CJPEG_Callback(OpaquePointer($0!), 5, 1, 0, 0) } : { CJPEG_Callback(OpaquePointer($0!), 5, 2, 0, 0) }
        }
    }
    func read(_ id: JPEGCallbackID) -> JPEGCallback? { callback(id, CJPEG_GetCallback(state, id.rawValue)) }
    func write(_ id: JPEGCallbackID, value: JPEGCallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(callback(id, 1)!, to: UInt.self) ? 1 : 2
        CJPEG_SetCallback(state, id.rawValue, token)
    }
    func infoReadyCallback(_ token: UInt32) -> JPEGInfoReadyCallback? {
        if token == 0 { return nil }
        return token == 1 ? { CJPEG_Callback(OpaquePointer($0!), 6, 1, $1 == CJPEG_Configuration(OpaquePointer($0!)) ? 1 : 0, 0) } : { CJPEG_Callback(OpaquePointer($0!), 6, 2, $1 == CJPEG_Configuration(OpaquePointer($0!)) ? 1 : 0, 0) }
    }
    func readInfoReady() -> JPEGInfoReadyCallback? { infoReadyCallback(CJPEG_GetCallback(state, 6)) }
    func writeInfoReady(_ value: JPEGInfoReadyCallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(infoReadyCallback(1)!, to: UInt.self) ? 1 : 2
        CJPEG_SetCallback(state, 6, token)
    }
    func getDataCallback(_ token: UInt32) -> JPEGGetDataCallback? {
        if token == 0 { return nil }
        return token == 1 ? { CJPEG_Callback(OpaquePointer($0!), 7, 1, $1, 0) } : { CJPEG_Callback(OpaquePointer($0!), 7, 2, $1, 0) }
    }
    func readGetData() -> JPEGGetDataCallback? { getDataCallback(CJPEG_GetCallback(state, 7)) }
    func writeGetData(_ value: JPEGGetDataCallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(getDataCallback(1)!, to: UInt.self) ? 1 : 2
        CJPEG_SetCallback(state, 7, token)
    }
    func dataReadyCallback(_ token: UInt32) -> JPEGDataReadyCallback? {
        if token == 0 { return nil }
        return token == 1 ? { let state = OpaquePointer($0!); CJPEG_Callback(state, 8, 1, $1.map { UInt32(CJPEG_Buffer(state, 0)!.distance(to: $0)) + 1 } ?? 0, $2) } : { let state = OpaquePointer($0!); CJPEG_Callback(state, 8, 2, $1.map { UInt32(CJPEG_Buffer(state, 0)!.distance(to: $0)) + 1 } ?? 0, $2) }
    }
    func readDataReady() -> JPEGDataReadyCallback? { dataReadyCallback(CJPEG_GetCallback(state, 8)) }
    func writeDataReady(_ value: JPEGDataReadyCallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(dataReadyCallback(1)!, to: UInt.self) ? 1 : 2
        CJPEG_SetCallback(state, 8, token)
    }
    var driver: JPEG<JPEGModel, JPEGModel, JPEGModel, JPEGModel> {
        .init(registers: self, handle: self, callbacks: self, dma: self,
              defaults: .init(encodeComplete: callback(.encodeComplete, 1)!, decodeComplete: callback(.decodeComplete, 1)!, error: callback(.error, 1)!,
                              mspInitialize: callback(.mspInitialize, 1)!, mspDeinitialize: callback(.mspDeinitialize, 1)!,
                              infoReady: infoReadyCallback(1)!, getData: getDataCallback(1)!, dataReady: dataReadyCallback(1)!),
              useRegisteredCallbacks: get(13, 0) != 0)
    }
    func read(_ stream: JPEGStream, word: DMAHandleWord) -> UInt32 {
        let base = stream.rawValue * 16
        switch word {
        case .mode: return get(4, base)
        case .queueAddress: return get(4, base + 1) == 0 ? 0 : 0x1000 + stream.rawValue * 0x100
        case .state: return get(4, base + 14)
        case .errorCode: return get(4, base + 15)
        default: preconditionFailure()
        }
    }
    func readMemory32(_ stream: JPEGStream, at address: UInt32) -> UInt32 {
        precondition(address == 0x1000 + stream.rawValue * 0x100)
        return get(4, stream.rawValue * 16 + 2) == 0 ? 0 : 0x2000 + stream.rawValue * 0x100
    }
    func writeMemory32(_ stream: JPEGStream, at address: UInt32, value: UInt32) {
        let offset = address - (0x2000 + stream.rawValue * 0x100)
        precondition(offset == 8 || offset == 12 || offset == 16)
        set(4, stream.rawValue * 16 + 1 + offset / 4, value)
    }
    func writeCallback(_ stream: JPEGStream, id: DMACallbackID, value: DMACallback?) {
        var token: UInt32 = 0
        if let value {
            for kind in JPEGDMACallbackKind.allCases where unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) { token = kind.rawValue + 1 }
            precondition(token != 0)
        }
        let i: UInt32
        switch id { case .transferComplete: i = 6; case .error: i = 7; case .abort: i = 8; default: preconditionFailure() }
        set(4, stream.rawValue * 16 + i, token)
    }
    func callback(_ kind: JPEGDMACallbackKind) -> DMACallback {
        switch kind {
        case .inputComplete: return { let m = JPEGModel(state: OpaquePointer($0!)); m.driver.handleDMAEvent(.inputComplete, source: JPEGEventSource(model: m, stream: 0)) }
        case .outputComplete: return { let m = JPEGModel(state: OpaquePointer($0!)); m.driver.handleDMAEvent(.outputComplete, source: JPEGEventSource(model: m, stream: 1)) }
        case .error: return { let m = JPEGModel(state: OpaquePointer($0!)); m.driver.handleDMAEvent(.error, source: JPEGEventSource(model: m, stream: 0)) }
        case .outputAbort: return { let m = JPEGModel(state: OpaquePointer($0!)); m.driver.handleDMAEvent(.outputAbort, source: JPEGEventSource(model: m, stream: 1)) }
        }
    }
    func startInterrupt(_ stream: JPEGStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        HALStatus(rawValue: CJPEG_Start(state, stream.rawValue, 0, sourceAddress, destinationAddress, sourceDataSize))!
    }
    func startLinkedListInterrupt(_ stream: JPEGStream) -> HALStatus {
        HALStatus(rawValue: CJPEG_Start(state, stream.rawValue, 1, get(4, stream.rawValue * 16 + 4), get(4, stream.rawValue * 16 + 5), get(4, stream.rawValue * 16 + 3)))!
    }
    func abort(_ stream: JPEGStream, getTick: () -> UInt32) -> HALStatus { HALStatus(rawValue: CJPEG_Abort(state, stream.rawValue, 0))! }
    func abortInterrupt(_ stream: JPEGStream) -> HALStatus { HALStatus(rawValue: CJPEG_Abort(state, stream.rawValue, 1))! }
    func getCounter(_ stream: JPEGStream) -> UInt32 { get(4, stream.rawValue * 16 + 9) }
    func getFIFOLevel(_ stream: JPEGStream) -> UInt32 { get(4, stream.rawValue * 16 + 10) }
    func configuration(_ area: UInt32) -> JPEGConfiguration {
        .init(colorSpace: get(area, 0), chromaSubsampling: get(area, 1), imageHeight: get(area, 2), imageWidth: get(area, 3), imageQuality: get(area, 4))
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        let d = driver, input = get(5, 0) == 0 ? nil : CJPEG_Buffer(state, 0), output = get(5, 1) == 0 ? nil : CJPEG_Buffer(state, 128)
        let tick = { CJPEG_Tick(state) }
        switch op {
        case 0: return d.initialize().rawValue
        case 1: return d.deinitialize().rawValue
        case 2: return d.configureEncoding(get(5, 2) == 0 ? nil : configuration(2)).rawValue
        case 3:
            var info = configuration(3)
            let result = a == 0 ? d.getInfo(nil) : d.getInfo(&info)
            set(3, 0, info.colorSpace); set(3, 1, info.chromaSubsampling); set(3, 2, info.imageHeight); set(3, 3, info.imageWidth); set(3, 4, info.imageQuality)
            return result.rawValue
        case 4: return d.setHeaderParsing(enabled: true).rawValue
        case 5: return d.setHeaderParsing(enabled: false).rawValue
        case 6: return d.setUserQuantizationTables(a & 1 == 0 ? nil : CJPEG_CustomQuantization(state, 0), a & 2 == 0 ? nil : CJPEG_CustomQuantization(state, 1), a & 4 == 0 ? nil : CJPEG_CustomQuantization(state, 2), a & 8 == 0 ? nil : CJPEG_CustomQuantization(state, 3)).rawValue
        case 7: return d.encode(input: input, inputLength: a, output: output, outputLength: b, timeout: c, getTick: tick).rawValue
        case 8: return d.decode(input: input, inputLength: a, output: output, outputLength: b, timeout: c, getTick: tick).rawValue
        case 9: return d.encodeInterrupt(input: input, inputLength: a, output: output, outputLength: b).rawValue
        case 10: return d.decodeInterrupt(input: input, inputLength: a, output: output, outputLength: b).rawValue
        case 11: return d.encodeDMA(input: input, inputLength: a, output: output, outputLength: b).rawValue
        case 12: return d.decodeDMA(input: input, inputLength: a, output: output, outputLength: b).rawValue
        case 13: return d.pause(a).rawValue
        case 14: return d.resume(a).rawValue
        case 15: d.configureInputBuffer(a == 0 ? nil : CJPEG_Buffer(state, a - 1), length: b)
        case 16: d.configureOutputBuffer(a == 0 ? nil : CJPEG_Buffer(state, a - 1), length: b)
        case 17: return d.abort(getTick: tick).rawValue
        case 18: d.handleInterrupt()
        case 19: return d.getState()
        case 20: return d.getError()
        case 21: return d.registerCallback(id: a, callback: callback(.init(rawValue: a) ?? .encodeComplete, b)).rawValue
        case 22: return d.unregisterCallback(id: a).rawValue
        case 23: return d.registerInfoReadyCallback(infoReadyCallback(a)).rawValue
        case 24: return d.unregisterInfoReadyCallback().rawValue
        case 25: return d.registerGetDataCallback(getDataCallback(a)).rawValue
        case 26: return d.unregisterGetDataCallback().rawValue
        case 27: return d.registerDataReadyCallback(dataReadyCallback(a)).rawValue
        case 28: return d.unregisterDataReadyCallback().rawValue
        case 29: d.resetHandleState()
        case 30...33: d.handleDMAEvent(.init(rawValue: op - 30)!, source: JPEGEventSource(model: self, stream: a))
        case 34: d.readInputData(words: a)
        case 35: d.storeOutputData(words: a)
        case 36: return d.setQuantizationMemory(CJPEG_CustomQuantization(state, a)!, table: .quantization0)
        case 37: return d.getQuality()
        case 38: d.enable()
        case 39: d.disable()
        case 40: return d.getFlag(a)
        case 41: d.clearFlags(a)
        case 42: d.enableInterrupts(a)
        case 43: d.disableInterrupts(a)
        case 44: return d.getInterruptSource(a)
        default: preconditionFailure()
        }
        return 0
    }
}
