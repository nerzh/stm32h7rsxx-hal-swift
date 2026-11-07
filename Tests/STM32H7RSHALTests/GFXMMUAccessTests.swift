import XCTest
import STM32H7RSHAL
import CGraphicsReference

private final class GFXMMUTrace: GFXMMURegisterIO, GFXMMUMemoryIO {
    enum Event: Equatable {
        case read(GFXMMURegister), write(GFXMMURegister, UInt32)
        case load(UInt32), store(UInt32, UInt32)
    }
    let storage = UnsafeMutableRawPointer.allocate(byteCount: CGraphics_Size(), alignment: 16)
    let io: GraphicsReferenceIO
    var events: [Event] = []
    init() {
        io = .init(state: OpaquePointer(storage), mode: 0)
        CGraphics_Reset(io.state, 0)
    }
    deinit { storage.deallocate() }
    var hal: GFXMMU<GFXMMUTrace, GraphicsReferenceIO, GraphicsReferenceIO, GFXMMUTrace> {
        .init(registers: self, handle: io, callbacks: io, memory: self, defaults: io.mmu.defaults)
    }
    func read(_ register: GFXMMURegister) -> UInt32 { events.append(.read(register)); return io.read(register) }
    func write(_ register: GFXMMURegister, value: UInt32) { events.append(.write(register, value)); io.write(register, value: value) }
    func address(of register: GFXMMURegister) -> UInt32 { io.address(of: register) }
    func read32(at address: UInt32) -> UInt32 { events.append(.load(address)); return io.read32(at: address) }
    func write32(at address: UInt32, value: UInt32) { events.append(.store(address, value)); io.write32(at: address, value: value) }
    func getPRIMASK() -> UInt32 { io.getPRIMASK() }
    func disableIRQ() { io.disableIRQ() }
    func setPRIMASK(_ value: UInt32) { io.setPRIMASK(value) }
}
final class GFXMMUAccessTests: XCTestCase {
    func testInitializeAndPackingRetainSeparateControlWrites() {
        let t = GFXMMUTrace()
        t.io.write(.blockSize, value: 0x40); t.io.write(.addressTranslation, value: 1)
        t.io.write(.interruptsEnabled, value: 1); t.io.write(.interrupts, value: 0x1F)
        XCTAssertEqual(t.hal.initialize(), .ok)
        XCTAssertEqual(t.events, [.write(.cr, 0), .read(.cr), .write(.cr, 0x40), .read(.cr), .write(.cr, 0x8040),
            .read(.cr), .write(.cr, 0x805F), .write(.dvr, 0), .write(.b0cr, 0), .write(.b1cr, 0), .write(.b2cr, 0), .write(.b3cr, 0)])
        t.io.write(.cr, value: 0xFF00_805F); t.events = []
        XCTAssertEqual(t.hal.configurePacking(.init(buffer0Enabled: 1, buffer0Mode: 1,
            buffer3Enabled: 1, buffer3Mode: 1, defaultAlpha: 0xAB)), .ok)
        XCTAssertEqual(t.events, [.read(.cr), .read(.cr), .write(.cr, 0x805F), .read(.cr),
                                  .write(.cr, 0xC300_805F), .write(.dar, 0xAB)])
    }
    func testLUTCopyEveryWordAndOverlappingSourceUsesForwardScalarOrder() {
        let t = GFXMMUTrace()
        t.io.write(GFXMMUHandleWord.state, value: 1); t.io.write(.cr, value: 0x8000)
        for index: UInt32 in 0..<2048 { CGraphics_Set(t.io.state, 4, index, index ^ 0xA5A5_0000) }
        let source = CGraphics_Address(t.io.state, 4, 0)
        XCTAssertEqual(t.hal.configureLUT(firstLine: 0, lineCount: 1024, sourceAddress: source), .ok)
        var expected: [GFXMMUTrace.Event] = [.read(.cr)]
        for index in 0..<2048 {
            let address = t.io.address(of: .lut(index: index)), value = UInt32(index) ^ 0xA5A5_0000
            expected += [.load(source + UInt32(index) * 4), .store(address, value)]
            XCTAssertEqual(t.io.read(.lut(index: index)), value)
        }
        XCTAssertEqual(t.events, expected)
        t.events = []
        let base = t.io.address(of: .lut(index: 0))
        XCTAssertEqual(t.hal.configureLUT(firstLine: 1, lineCount: 3, sourceAddress: base), .ok)
        for index in 0..<8 { XCTAssertEqual(t.io.read(.lut(index: index)), UInt32(index & 1) ^ 0xA5A5_0000) }
    }
    func testLUTLineSignedOffsetsAndDisabledLineClearBothWords() {
        let t = GFXMMUTrace()
        t.io.write(GFXMMUHandleWord.state, value: 1); t.io.write(.cr, value: 0x8000)
        for number: UInt32 in [0, 1, 511, 1023] {
            for offset: Int32 in [-255, -1, 0, 1, 261888] {
                t.events = []
                XCTAssertEqual(t.hal.configureLUTLine(.init(lineNumber: number, lineStatus: 1,
                    firstVisibleBlock: 255, lastVisibleBlock: 0, lineOffset: offset)), .ok)
                let low = t.io.address(of: .lut(index: Int(number * 2))), high = low + 4
                XCTAssertEqual(t.events, [.read(.cr), .store(low, 0xFF01), .store(high, UInt32(bitPattern: offset))])
                t.events = []
                XCTAssertEqual(t.hal.configureLUTLine(.init(lineNumber: number, lineStatus: 0,
                    firstVisibleBlock: 255, lastVisibleBlock: 255, lineOffset: offset)), .ok)
                XCTAssertEqual(t.events, [.read(.cr), .store(low, 0), .store(high, 0)])
            }
        }
    }
    func testDisableRangeKeepsAdjacentLinesAndInterruptClearsBeforeCallback() {
        let t = GFXMMUTrace()
        t.io.write(GFXMMUHandleWord.state, value: 1); t.io.write(.cr, value: 0x801F)
        for index: UInt32 in 0..<2048 { CGraphics_Set(t.io.state, 0, 1024 + index, .max) }
        XCTAssertEqual(t.hal.disableLUTLines(firstLine: 1, lineCount: 1022), .ok)
        for index in 0..<2048 { XCTAssertEqual(t.io.read(.lut(index: index)), (2..<2046).contains(index) ? 0 : .max) }
        t.io.write(.sr, value: 0x105); t.events = []
        t.hal.handleInterrupt()
        XCTAssertEqual(t.events, [.read(.sr), .read(.cr), .write(.fcr, 5)])
        XCTAssertEqual(t.io.read(GFXMMUHandleWord.errorCode), 5)
        XCTAssertEqual(CGraphics_TraceWord(t.io.state, 0, 0), 100)
    }
}
