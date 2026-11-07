import XCTest
import STM32H7RSHAL
import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class DMARegisterLayoutTests: XCTestCase {
    func testAll32ChannelsAndGlobalAddressesMatchFourCMSISLayoutsAndBothSVDs() {
        XCTAssertEqual(gpdma.unsafeAddress, 0x4002_1000)
        XCTAssertEqual(hpdma.unsafeAddress, 0x5200_0000)
        XCTAssertEqual([gpdma.privcfgr.unsafeAddress, gpdma.rcfglockr.unsafeAddress, gpdma.misr.unsafeAddress],
                       [0x4002_1004, 0x4002_1008, 0x4002_100C])
        XCTAssertEqual([hpdma.privcfgr.unsafeAddress, hpdma.rcfglockr.unsafeAddress, hpdma.misr.unsafeAddress],
                       [0x5200_0004, 0x5200_0008, 0x5200_000C])
        let linear: [UInt] = [0, 0xC, 0x10, 0x14, 0x40, 0x44, 0x48, 0x4C, 0x50, 0x7C]
        let extended: [UInt] = [0, 0xC, 0x10, 0x14, 0x40, 0x44, 0x48, 0x4C, 0x50, 0x54, 0x58, 0x7C]
        for channel in 0..<16 {
            let offset = UInt(0x50 + channel * 0x80)
            if channel < 12 {
                XCTAssertEqual(addresses(gpdma.ch[channel]), linear.map { 0x4002_1000 + offset + $0 })
                XCTAssertEqual(addresses(hpdma.ch[channel]), linear.map { 0x5200_0000 + offset + $0 })
            } else {
                XCTAssertEqual(addresses(gpdma.ch2d[channel - 12]), extended.map { 0x4002_1000 + offset + $0 })
                XCTAssertEqual(addresses(hpdma.ch2d[channel - 12]), extended.map { 0x5200_0000 + offset + $0 })
            }
            for controller in [DMAController.gpdma1, .hpdma1] {
                let descriptor = DMAChannel(controller: controller, index: channel)
                let registers = STM32DMARegisters(channel: descriptor)
                XCTAssertEqual(registers.channel, descriptor)
                XCTAssertEqual(descriptor.supports2DAddressing, channel >= 12)
                XCTAssertEqual(descriptor.supportsPeripheralFlowControl,
                               channel == 15 || (controller == .gpdma1 && channel == 0))
            }
        }
    }

    func testHandleCopiesShareExactlyFiveVolatileWordsWithoutTouchingGuards() {
        var words: [UInt32] = [0xAABBCCDD, 0, 0, 0, 0, 0, 0xDDCCBBAA]
        words.withUnsafeMutableBufferPointer { buffer in
            let handle = STM32DMAHandleRegisters(storage: .init(start: buffer.baseAddress! + 1, count: 5))
            let copy = handle
            for (index, word) in DMAHandleWord.allCases.enumerated() {
                handle.write(word, value: UInt32(index + 1) * 0x11111111)
                XCTAssertEqual(copy.read(word), UInt32(index + 1) * 0x11111111)
            }
            copy.write(.queueAddress, value: 0x24001234)
            XCTAssertEqual(handle.read(.queueAddress), 0x24001234)
        }
        XCTAssertEqual(words, [0xAABBCCDD, 0x11111111, 0x22222222, 0x33333333, 0x44444444, 0x24001234, 0xDDCCBBAA])
    }

    func testFiveThinCallbackSlotsAndParentShareStorageWithIndependentContext() {
        var storage: [UInt] = [0xA5A5, 0, 0, 0, 0, 0, 0, 0x5A5A]
        var count: UInt32 = 0
        var parentValue: UInt32 = 99
        let increment: DMACallback = { context in context!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        let addTen: DMACallback = { context in context!.assumingMemoryBound(to: UInt32.self).pointee &+= 10 }
        withUnsafeMutablePointer(to: &count) { context in
            withUnsafeMutablePointer(to: &parentValue) { parent in
                storage.withUnsafeMutableBufferPointer { buffer in
                    let callbacks = STM32DMACallbackRegisters(
                        storage: .init(start: buffer.baseAddress! + 1, count: 6), context: context)
                    let copy = callbacks
                    XCTAssertNil(callbacks.readParent())
                    copy.writeParent(parent)
                    XCTAssertEqual(callbacks.readParent(), UnsafeMutableRawPointer(parent))
                    XCTAssertEqual(callbacks.context, UnsafeMutableRawPointer(context))
                    for id in [DMACallbackID.transferComplete, .halfTransfer, .error, .abort, .suspend] {
                        XCTAssertNil(callbacks.read(id))
                        callbacks.write(id, value: increment)
                        copy.read(id)?(copy.context)
                    }
                    copy.write(.error, value: addTen)
                    callbacks.read(.error)?(callbacks.context)
                    callbacks.writeParent(nil)
                    XCTAssertNil(copy.readParent())
                    XCTAssertEqual(copy.context, UnsafeMutableRawPointer(context))
                    for id in [DMACallbackID.transferComplete, .halfTransfer, .error, .abort, .suspend] {
                        copy.write(id, value: nil)
                        XCTAssertNil(callbacks.read(id))
                    }
                }
            }
        }
        XCTAssertEqual(count, 15)
        XCTAssertEqual(parentValue, 99)
        XCTAssertEqual(storage, [0xA5A5, 0, 0, 0, 0, 0, 0, 0x5A5A])
    }

    func testExplicitNodeAndQueueABIIsIndependentOfNativePointerWidth() {
        XCTAssertEqual(DMAQueueWord.allCases.map(\.rawValue), [0, 4, 8, 12, 16, 20])
        XCTAssertEqual(DMAQueueWord.byteCount, 24)
        XCTAssertEqual(DMANodeLayout.registerCount, 8)
        XCTAssertEqual(DMANodeLayout.wordCount, 9)
        XCTAssertEqual(DMANodeLayout.byteCount, 36)
        XCTAssertEqual(DMANodeLayout.informationOffset, 32)
        XCTAssertEqual(DMANodeLayout.linearLinkRegisterIndex, 5)
        XCTAssertEqual(DMANodeLayout.twoDimensionalLinkRegisterIndex, 7)
    }

    private func addresses(_ block: GPDMA.CH) -> [UInt] {
        [block.lbar.unsafeAddress, block.fcr.unsafeAddress, block.sr.unsafeAddress, block.cr.unsafeAddress,
         block.tr1.unsafeAddress, block.tr2.unsafeAddress, block.br1.unsafeAddress,
         block.sar.unsafeAddress, block.dar.unsafeAddress, block.llr.unsafeAddress]
    }
    private func addresses(_ block: HPDMA.CH) -> [UInt] {
        [block.lbar.unsafeAddress, block.fcr.unsafeAddress, block.sr.unsafeAddress, block.cr.unsafeAddress,
         block.tr1.unsafeAddress, block.tr2.unsafeAddress, block.br1.unsafeAddress,
         block.sar.unsafeAddress, block.dar.unsafeAddress, block.llr.unsafeAddress]
    }
    private func addresses(_ block: GPDMA.CH2D) -> [UInt] {
        [block.lbar.unsafeAddress, block.fcr.unsafeAddress, block.sr.unsafeAddress, block.cr.unsafeAddress,
         block.tr1.unsafeAddress, block.tr2.unsafeAddress, block.br1.unsafeAddress,
         block.sar.unsafeAddress, block.dar.unsafeAddress, block.tr3.unsafeAddress, block.br2.unsafeAddress, block.llr.unsafeAddress]
    }
    private func addresses(_ block: HPDMA.CH2D) -> [UInt] {
        [block.lbar.unsafeAddress, block.fcr.unsafeAddress, block.sr.unsafeAddress, block.cr.unsafeAddress,
         block.tr1.unsafeAddress, block.tr2.unsafeAddress, block.br1.unsafeAddress,
         block.sar.unsafeAddress, block.dar.unsafeAddress, block.tr3.unsafeAddress, block.br2.unsafeAddress, block.llr.unsafeAddress]
    }
}
