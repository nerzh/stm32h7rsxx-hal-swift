import XCTest
import STM32H7RSHAL
import CLTDCReference

private final class LTDCTrace: LTDCRegisterIO {
    enum Event: Equatable {
        case read(LTDCRegister), write(LTDCRegister, UInt32)
        case readLayer(LTDCLayerRegister, UInt32), writeLayer(LTDCLayerRegister, UInt32, UInt32)
    }
    let storage = UnsafeMutableRawPointer.allocate(byteCount: CLTDC_Size(), alignment: 16)
    let io: LTDCReferenceIO
    var events: [Event] = []
    var changeFormatAfterFirstCLUTWrite = false
    init() {
        io = .init(state: OpaquePointer(storage), mode: 0)
        CLTDC_Reset(io.state, 0)
    }
    deinit { storage.deallocate() }
    var hal: LTDC<LTDCTrace, LTDCReferenceIO, LTDCReferenceIO> {
        .init(registers: self, handle: io, callbacks: io, defaults: io.ltdc.defaults)
    }
    func read(_ register: LTDCRegister) -> UInt32 { events.append(.read(register)); return io.read(register) }
    func write(_ register: LTDCRegister, value: UInt32) { events.append(.write(register, value)); io.write(register, value: value) }
    func read(_ register: LTDCLayerRegister, layer: UInt32) -> UInt32 {
        events.append(.readLayer(register, layer)); return io.read(register, layer: layer)
    }
    func write(_ register: LTDCLayerRegister, layer: UInt32, value: UInt32) {
        events.append(.writeLayer(register, layer, value)); io.write(register, layer: layer, value: value)
        if register == .clutwr && changeFormatAfterFirstCLUTWrite {
            changeFormatAfterFirstCLUTWrite = false
            io.write(layer == 0 ? .layer0PixelFormat : .layer1PixelFormat, value: 5)
        }
    }
}
final class LTDCAccessTests: XCTestCase {
    func testPitchPreservesBothReloadsAndBothReadModifyWrites() {
        for reload in [false, true] {
            let t = LTDCTrace()
            t.io.write(.layer1PixelFormat, value: 1)
            t.io.write(.cfblr, layer: 1, value: 0xFFFF1234); t.io.write(.srcr, value: 2)
            XCTAssertEqual(t.hal.setPitch(pixels: 17, layer: 1, reload: reload), .ok)
            var expected: [LTDCTrace.Event] = [.readLayer(.cfblr, 1), .writeLayer(.cfblr, 1, 0xE0001234)]
            if reload { expected += [.read(.srcr), .write(.srcr, 3)] }
            expected += [.readLayer(.cfblr, 1), .writeLayer(.cfblr, 1, 0xE0331234)]
            if reload { expected += [.read(.srcr), .write(.srcr, 3)] }
            XCTAssertEqual(t.events, expected)
        }
    }
    func testLayerConfigurationRetainsClearThenWriteAndLineLengthPlusSeven() {
        let t = LTDCTrace()
        let c = LTDCLayerConfiguration(windowX0: 2, windowX1: 5, windowY0: 1, windowY1: 3,
            pixelFormat: 1, alpha: 0x56, alpha0: 0x78, blendingFactor1: 0x600, blendingFactor2: 7,
            frameBufferAddress: 0x24000000, imageWidth: 8, imageHeight: 2, backgroundColor: 0xAB123456)
        t.io.write(.bpcr, value: 0xA0004)
        for r in LTDCLayerRegister.allCases { t.io.write(r, layer: 0, value: .max) }
        XCTAssertEqual(t.hal.configureLayer(c, layer: 0), .ok)
        XCTAssertEqual(t.events, [
            .read(.bpcr), .readLayer(.whpcr, 0), .writeLayer(.whpcr, 0, 0xF000F000),
            .read(.bpcr), .writeLayer(.whpcr, 0, 0x000F000D),
            .read(.bpcr), .readLayer(.wvpcr, 0), .writeLayer(.wvpcr, 0, 0xF800F800),
            .read(.bpcr), .writeLayer(.wvpcr, 0, 0x00070006),
            .readLayer(.pfcr, 0), .writeLayer(.pfcr, 0, 0xFFFFFFF8), .writeLayer(.pfcr, 0, 1),
            .writeLayer(.dccr, 0, 0x78123456),
            .readLayer(.cacr, 0), .writeLayer(.cacr, 0, 0xFFFFFF00), .writeLayer(.cacr, 0, 0x56),
            .readLayer(.bfcr, 0), .writeLayer(.bfcr, 0, 0xFFFFF8F8), .writeLayer(.bfcr, 0, 0x607),
            .writeLayer(.cfbar, 0, 0x24000000),
            .readLayer(.cfblr, 0), .writeLayer(.cfblr, 0, 0xE000E000), .writeLayer(.cfblr, 0, 0x00180010),
            .readLayer(.cfblnr, 0), .writeLayer(.cfblnr, 0, 0xFFFFF800), .writeLayer(.cfblnr, 0, 2),
            .readLayer(.cr, 0), .writeLayer(.cr, 0, .max), .write(.srcr, 1)])
    }
    func testCLUTWritesEveryEntryAndRereadsFormatOnEveryIteration() {
        let colors: [UInt32] = [0xFF123456, 0xAB789ABC, 0x00345678]
        for layer: UInt32 in 0...1 {
            for format: UInt32 in [5, 6] {
                for mutation in [false, true] {
                    let t = LTDCTrace()
                    t.io.write(layer == 0 ? .layer0PixelFormat : .layer1PixelFormat, value: format)
                    t.changeFormatAfterFirstCLUTWrite = mutation
                    XCTAssertEqual(colors.withUnsafeBufferPointer { t.hal.configureCLUT($0, layer: layer) }, .ok)
                    let stride: UInt32 = format == 6 && !mutation ? 17 : 1
                    XCTAssertEqual(t.events, [.writeLayer(.clutwr, layer, 0x123456),
                        .writeLayer(.clutwr, layer, (stride << 24) | 0x789ABC),
                        .writeLayer(.clutwr, layer, ((stride * 2) << 24) | 0x345678)])
                }
            }
        }
    }
    func testInterruptReadsFlagsOnceAndClearsEachFlagWithoutReadingICR() {
        let t = LTDCTrace()
        t.io.write(.isr, value: 15); t.io.write(.ier, value: 15)
        t.hal.handleInterrupt()
        XCTAssertEqual(t.events, [.read(.isr), .read(.ier),
            .read(.ier), .write(.ier, 11), .write(.icr, 4),
            .read(.ier), .write(.ier, 9), .write(.icr, 2),
            .read(.ier), .write(.ier, 8), .write(.icr, 1),
            .read(.ier), .write(.ier, 0), .write(.icr, 8)])
    }
    func testColorKeyUsesSeparateClearAndUnmaskedWrite() {
        for reload in [false, true] {
            let t = LTDCTrace()
            t.io.write(.ckcr, layer: 1, value: .max)
            XCTAssertEqual(t.hal.configureColorKeying(rgb: 0xFEDCBA98, layer: 1, reload: reload), .ok)
            var expected: [LTDCTrace.Event] = [.readLayer(.ckcr, 1), .writeLayer(.ckcr, 1, 0xFF000000), .writeLayer(.ckcr, 1, 0xFEDCBA98)]
            if reload { expected += [.write(.srcr, 1)] }
            XCTAssertEqual(t.events, expected)
        }
    }
}
