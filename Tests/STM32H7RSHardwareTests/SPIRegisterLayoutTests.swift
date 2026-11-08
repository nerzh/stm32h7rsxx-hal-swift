import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class SPIRegisterLayoutTests: XCTestCase {
  func testAllCMSISAndSVDOffsets() {
    for (instance, base): (SPIInstance, UInt32) in [
      (.spi1, 0x4200_3000), (.spi2, 0x4000_3800), (.spi3, 0x4000_3c00), (.spi4, 0x4200_3400),
      (.spi5, 0x4200_5000), (.spi6, 0x5800_1400),
    ] {
      let io = STM32SPIRegisters(instance)
      XCTAssertEqual(io.address(of: .cr1), base + 0)
      XCTAssertEqual(io.address(of: .cr2), base + 4)
      XCTAssertEqual(io.address(of: .cfg1), base + 8)
      XCTAssertEqual(io.address(of: .cfg2), base + 12)
      XCTAssertEqual(io.address(of: .ier), base + 16)
      XCTAssertEqual(io.address(of: .sr), base + 20)
      XCTAssertEqual(io.address(of: .ifcr), base + 24)
      XCTAssertEqual(io.address(of: .txdr), base + 32)
      XCTAssertEqual(io.address(of: .rxdr), base + 48)
      XCTAssertEqual(io.address(of: .crcpoly), base + 64)
      XCTAssertEqual(io.address(of: .txcrc), base + 68)
      XCTAssertEqual(io.address(of: .rxcrc), base + 72)
      XCTAssertEqual(io.address(of: .udrdr), base + 76)
      XCTAssertEqual(io.address(of: .i2scfgr), base + 80)
    }
  }
  func testSharedStoragePaddingAndPointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 36) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 4) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32SPIHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 34),
          pointers: .init(start: pointers.baseAddress! + 1, count: 2))
        let copy = io
        for item in SPIConfigurationWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[1 + item.rawValue], copy.read(item))
        }
        for item in SPIHandleWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[29 + item.rawValue], copy.read(item))
        }
        for item in SPIHandleHalfWord.allCases {
          copy.write(item, value: 0xFFF0 | UInt16(item.rawValue))
          XCTAssertEqual(io.read(item), 0xFFF0 | UInt16(item.rawValue))
          XCTAssertEqual(words[25 + item.rawValue], 0xA55A_FFF0 | UInt32(item.rawValue))
        }
        let bits: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_ABC0_0000 : 0x2403_8000
        for pointer in [UARTBufferPointer.transmit, .receive] {
          io.writePointer(pointer, value: UnsafeMutableRawPointer(bitPattern: bits))
          XCTAssertEqual(UInt(bitPattern: copy.readPointer(pointer)), bits)
          XCTAssertEqual(pointers[1 + pointer.rawValue], bits)
          copy.writePointer(pointer, value: nil)
          XCTAssertNil(io.readPointer(pointer))
        }
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[35], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[3], 0xC001_C0DE)
      }
    }
  }
  func testCallbacksAndNativePointerSlots() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 13) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 1) { context in
        storage.initialize(repeating: 0)
        context.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[12] = 0x5678
        let io = STM32SPICallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 11),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: SPICallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in SPICallbackID.allCases {
          XCTAssertNil(io.read(id))
          io.write(id, value: callback)
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 11)
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[12], 0x5678)
      }
    }
  }
}
