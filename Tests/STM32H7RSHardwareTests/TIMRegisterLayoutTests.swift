import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class TIMRegisterLayoutTests: XCTestCase {
  func testEveryCMSISOffsetAndInstance() {
    for (instance, base): (TIMInstance, UInt32) in [
      (.tim1, 0x4200_0000), (.tim2, 0x4000_0000), (.tim3, 0x4000_0400), (.tim4, 0x4000_0800),
      (.tim5, 0x4000_0c00), (.tim6, 0x4000_1000), (.tim7, 0x4000_1400), (.tim9, 0x4200_4c00),
      (.tim12, 0x4000_1800), (.tim13, 0x4000_1c00), (.tim14, 0x4000_2000), (.tim15, 0x4200_4000),
      (.tim16, 0x4200_4400), (.tim17, 0x4200_4800),
    ] {
      let io = STM32TIMRegisters(instance)
      XCTAssertEqual(io.address(of: .cr1), base + 0)
      XCTAssertEqual(io.address(of: .cr2), base + 4)
      XCTAssertEqual(io.address(of: .smcr), base + 8)
      XCTAssertEqual(io.address(of: .dier), base + 12)
      XCTAssertEqual(io.address(of: .sr), base + 16)
      XCTAssertEqual(io.address(of: .egr), base + 20)
      XCTAssertEqual(io.address(of: .ccmr1), base + 24)
      XCTAssertEqual(io.address(of: .ccmr2), base + 28)
      XCTAssertEqual(io.address(of: .ccer), base + 32)
      XCTAssertEqual(io.address(of: .cnt), base + 36)
      XCTAssertEqual(io.address(of: .psc), base + 40)
      XCTAssertEqual(io.address(of: .arr), base + 44)
      XCTAssertEqual(io.address(of: .rcr), base + 48)
      XCTAssertEqual(io.address(of: .ccr1), base + 52)
      XCTAssertEqual(io.address(of: .ccr2), base + 56)
      XCTAssertEqual(io.address(of: .ccr3), base + 60)
      XCTAssertEqual(io.address(of: .ccr4), base + 64)
      XCTAssertEqual(io.address(of: .bdtr), base + 68)
      XCTAssertEqual(io.address(of: .ccr5), base + 72)
      XCTAssertEqual(io.address(of: .ccr6), base + 76)
      XCTAssertEqual(io.address(of: .ccmr3), base + 80)
      XCTAssertEqual(io.address(of: .dtr2), base + 84)
      XCTAssertEqual(io.address(of: .ecr), base + 88)
      XCTAssertEqual(io.address(of: .tisel), base + 92)
      XCTAssertEqual(io.address(of: .af1), base + 96)
      XCTAssertEqual(io.address(of: .af2), base + 100)
      XCTAssertEqual(io.address(of: .dcr), base + 988)
      XCTAssertEqual(io.address(of: .dmar), base + 992)
    }
  }
  func testSharedHandleStorageAndChannelBoundaries() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 22) { words in
      words.initialize(repeating: 0xA55A_A55A)
      let io = STM32TIMHandleRegisters(words: .init(start: words.baseAddress! + 1, count: 20))
      let copy = io
      for item in TIMConfigurationWord.allCases {
        io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
        XCTAssertEqual(copy.read(item), words[1 + item.rawValue])
      }
      for item in TIMHandleWord.allCases {
        io.write(item, value: 0xC000_0000 | UInt32(item.rawValue))
        XCTAssertEqual(copy.read(item), words[7 + item.rawValue])
      }
      for complementary in [false, true] {
        for i in 0..<(complementary ? 4 : 6) {
          copy.writeChannelState(i, complementary: complementary, value: 0xDEAD_0000 | UInt32(i))
          XCTAssertEqual(
            io.readChannelState(i, complementary: complementary),
            words[(complementary ? 17 : 11) + i])
        }
      }
      XCTAssertEqual(words[0], 0xA55A_A55A)
      XCTAssertEqual(words[21], 0xA55A_A55A)
    }
  }
  func testCallbacksAndNativePointerSlots() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 34) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 1) { context in
        storage.initialize(repeating: 0)
        context.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[33] = 0x5678
        let io = STM32TIMCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 32),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: TIMCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in TIMCallbackID.allCases {
          XCTAssertNil(io.read(id))
          io.write(id, value: callback)
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 32)
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[33], 0x5678)
      }
    }
  }
}
