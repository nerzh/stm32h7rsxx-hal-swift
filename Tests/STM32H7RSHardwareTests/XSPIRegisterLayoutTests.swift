import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class XSPIRegisterLayoutTests: XCTestCase {
  func testAllCMSISAndSVDOffsets() {
    for (instance, base): (XSPIInstance, UInt32) in [(.xspi1, 0x5200_5000), (.xspi2, 0x5200_A000)] {
      let io = STM32XSPIRegisters(instance)
      XCTAssertEqual(io.address(of: .cr), base + 0)
      XCTAssertEqual(io.address(of: .dcr1), base + 8)
      XCTAssertEqual(io.address(of: .dcr2), base + 12)
      XCTAssertEqual(io.address(of: .dcr3), base + 16)
      XCTAssertEqual(io.address(of: .dcr4), base + 20)
      XCTAssertEqual(io.address(of: .sr), base + 32)
      XCTAssertEqual(io.address(of: .fcr), base + 36)
      XCTAssertEqual(io.address(of: .dlr), base + 64)
      XCTAssertEqual(io.address(of: .ar), base + 72)
      XCTAssertEqual(io.address(of: .dr), base + 80)
      XCTAssertEqual(io.address(of: .psmkr), base + 128)
      XCTAssertEqual(io.address(of: .psmar), base + 136)
      XCTAssertEqual(io.address(of: .pir), base + 144)
      XCTAssertEqual(io.address(of: .ccr), base + 256)
      XCTAssertEqual(io.address(of: .tcr), base + 264)
      XCTAssertEqual(io.address(of: .ir), base + 272)
      XCTAssertEqual(io.address(of: .abr), base + 288)
      XCTAssertEqual(io.address(of: .lptr), base + 304)
      XCTAssertEqual(io.address(of: .wpccr), base + 320)
      XCTAssertEqual(io.address(of: .wptcr), base + 328)
      XCTAssertEqual(io.address(of: .wpir), base + 336)
      XCTAssertEqual(io.address(of: .wpabr), base + 352)
      XCTAssertEqual(io.address(of: .wccr), base + 384)
      XCTAssertEqual(io.address(of: .wtcr), base + 392)
      XCTAssertEqual(io.address(of: .wir), base + 400)
      XCTAssertEqual(io.address(of: .wabr), base + 416)
      XCTAssertEqual(io.address(of: .hlcr), base + 512)
      XCTAssertEqual(io.address(of: .calfcr), base + 528)
      XCTAssertEqual(io.address(of: .calmr), base + 536)
      XCTAssertEqual(io.address(of: .calsor), base + 544)
      XCTAssertEqual(io.address(of: .calsir), base + 552)
      XCTAssertEqual(io.managerAddress(), 0x5200_B400)
    }
  }
  func testSharedStoragePaddingAndPointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 22) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 3) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32XSPIHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 20),
          pointers: .init(start: pointers.baseAddress! + 1, count: 1))
        let copy = io
        for item in XSPIConfigurationWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[1 + item.rawValue], copy.read(item))
        }
        for item in XSPIHandleWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[16 + item.rawValue], copy.read(item))
        }
        let bits: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_ABC0_0000 : 0x2403_8000
        io.writeBuffer(UnsafeMutablePointer<UInt8>(bitPattern: bits))
        XCTAssertEqual(UInt(bitPattern: copy.readBuffer()), bits)
        XCTAssertEqual(pointers[1], bits)
        copy.writeBuffer(nil)
        XCTAssertNil(io.readBuffer())
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[21], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[2], 0xC001_C0DE)
      }
    }
  }
  func testCallbacksAndNativePointerSlots() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 14) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 1) { context in
        storage.initialize(repeating: 0)
        context.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[13] = 0x5678
        let io = STM32XSPICallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 12),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: XSPICallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in XSPICallbackID.allCases {
          XCTAssertNil(io.read(id))
          io.write(id, value: callback)
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 12)
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[13], 0x5678)
      }
    }
  }
}
