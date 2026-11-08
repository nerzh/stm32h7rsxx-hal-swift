import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class SAIRegisterLayoutTests: XCTestCase {
  func testAllCMSISAndSVDOffsets() {
    for (instance, base): (SAIInstance, UInt32) in [
      (.sai1A, 0x4200_5804), (.sai1B, 0x4200_5824), (.sai2A, 0x4200_5c04), (.sai2B, 0x4200_5c24),
    ] {
      let io = STM32SAIRegisters(instance)
      XCTAssertEqual(io.address(of: .cr1), base + 0)
      XCTAssertEqual(io.address(of: .cr2), base + 4)
      XCTAssertEqual(io.address(of: .frcr), base + 8)
      XCTAssertEqual(io.address(of: .slotr), base + 12)
      XCTAssertEqual(io.address(of: .imr), base + 16)
      XCTAssertEqual(io.address(of: .sr), base + 20)
      XCTAssertEqual(io.address(of: .clrfr), base + 24)
      XCTAssertEqual(io.address(of: .dr), base + 28)
      XCTAssertEqual(io.address(of: .gcr, peripheral: .sai1), 0x4200_5800)
      XCTAssertEqual(io.address(of: .pdmcr, peripheral: .sai1), 0x4200_5844)
      XCTAssertEqual(io.address(of: .pdmdly, peripheral: .sai1), 0x4200_5848)
      XCTAssertEqual(io.address(of: .gcr, peripheral: .sai2), 0x4200_5c00)
      XCTAssertEqual(io.address(of: .pdmcr, peripheral: .sai2), 0x4200_5c44)
      XCTAssertEqual(io.address(of: .pdmdly, peripheral: .sai2), 0x4200_5c48)
    }
  }
  func testSharedStoragePaddingAndPointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 37) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 3) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32SAIHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 35),
          pointers: .init(start: pointers.baseAddress! + 1, count: 1))
        let copy = io
        for item in SAIConfigurationWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[1 + item.rawValue], copy.read(item))
        }
        for item in SAIFrameWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[21 + item.rawValue], copy.read(item))
        }
        for item in SAISlotWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[26 + item.rawValue], copy.read(item))
        }
        for item in SAIHandleWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[32 + item.rawValue], copy.read(item))
        }
        for item in SAIHandleHalfWord.allCases {
          copy.write(item, value: 0xFFF0 | UInt16(item.rawValue))
          XCTAssertEqual(io.read(item), 0xFFF0 | UInt16(item.rawValue))
          XCTAssertEqual(words[30 + item.rawValue], 0xA55A_FFF0 | UInt32(item.rawValue))
        }
        let bits: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_ABC0_0000 : 0x2403_8000
        io.writeBuffer(UnsafeMutablePointer<UInt8>(bitPattern: bits))
        XCTAssertEqual(UInt(bitPattern: copy.readBuffer()), bits)
        XCTAssertEqual(pointers[1], bits)
        copy.writeBuffer(nil)
        XCTAssertNil(io.readBuffer())
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[36], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[2], 0xC001_C0DE)
      }
    }
  }
  func testCallbacksAndNativePointerSlots() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 10) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 1) { context in
        storage.initialize(repeating: 0)
        context.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[9] = 0x5678
        let io = STM32SAICallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 8),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: SAICallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in SAICallbackID.allCases {
          XCTAssertNil(io.read(id))
          io.write(id, value: callback)
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 7)
        let mute: SAIMuteCallback = {}
        io.writeMute(mute)
        XCTAssertEqual(
          unsafeBitCast(copy.readMute()!, to: UInt.self), unsafeBitCast(mute, to: UInt.self))
        copy.readMute()!()
        copy.writeMute(nil)
        XCTAssertNil(io.readMute())
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[9], 0x5678)
      }
    }
  }
}
