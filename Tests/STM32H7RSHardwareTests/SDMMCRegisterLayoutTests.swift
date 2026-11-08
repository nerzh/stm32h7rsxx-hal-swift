import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class SDMMCRegisterLayoutTests: XCTestCase {
  func testAllCMSISAndSVDOffsets() {
    for (instance, base, delay): (SDMMCInstance, UInt32, UInt32) in [
      (.sdmmc1, 0x5200_7000, 0x5200_8000), (.sdmmc2, 0x4800_2400, 0x4800_2800),
    ] {
      let io = STM32SDMMCRegisters(instance)
      XCTAssertEqual(io.address(of: .power), base + 0x0)
      XCTAssertEqual(io.address(of: .clkcr), base + 0x4)
      XCTAssertEqual(io.address(of: .arg), base + 0x8)
      XCTAssertEqual(io.address(of: .cmd), base + 0xc)
      XCTAssertEqual(io.address(of: .respcmd), base + 0x10)
      XCTAssertEqual(io.address(of: .resp1), base + 0x14)
      XCTAssertEqual(io.address(of: .resp2), base + 0x18)
      XCTAssertEqual(io.address(of: .resp3), base + 0x1c)
      XCTAssertEqual(io.address(of: .resp4), base + 0x20)
      XCTAssertEqual(io.address(of: .dtimer), base + 0x24)
      XCTAssertEqual(io.address(of: .dlen), base + 0x28)
      XCTAssertEqual(io.address(of: .dctrl), base + 0x2c)
      XCTAssertEqual(io.address(of: .dcount), base + 0x30)
      XCTAssertEqual(io.address(of: .sta), base + 0x34)
      XCTAssertEqual(io.address(of: .icr), base + 0x38)
      XCTAssertEqual(io.address(of: .mask), base + 0x3c)
      XCTAssertEqual(io.address(of: .acktime), base + 0x40)
      XCTAssertEqual(io.address(of: .idmactrl), base + 0x50)
      XCTAssertEqual(io.address(of: .idmabsize), base + 0x54)
      XCTAssertEqual(io.address(of: .idmabaser), base + 0x58)
      XCTAssertEqual(io.address(of: .idmalar), base + 0x64)
      XCTAssertEqual(io.address(of: .idmabar), base + 0x68)
      XCTAssertEqual(io.address(of: .fifo), base + 0x80)
      XCTAssertEqual(io.delayControlAddress, delay)
    }
  }
  func testSharedHandleStorageAndPointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 31) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 4) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0xC001_C0DE)
        let io = STM32SDHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 29),
          pointers: .init(start: pointers.baseAddress! + 1, count: 2))
        let copy = io
        for item in SDConfigurationWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[1 + item.rawValue], copy.read(item))
        }
        for item in SDHandleWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[7 + item.rawValue], copy.read(item))
        }
        for item in SDCardWord.allCases {
          io.write(item, value: 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(copy.read(item), 0x8000_0000 | UInt32(item.rawValue))
          XCTAssertEqual(words[13 + item.rawValue], copy.read(item))
        }
        for register in SDCardRegister.allCases {
          for i in 0..<4 {
            io.writeCardRegister(
              register, index: i, value: 0x1234_0000 | UInt32(register.rawValue * 4 + i))
            XCTAssertEqual(
              copy.readCardRegister(register, index: i),
              0x1234_0000 | UInt32(register.rawValue * 4 + i))
            XCTAssertEqual(
              words[22 + register.rawValue * 4 + i], copy.readCardRegister(register, index: i))
          }
        }
        let bits: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_ABC0_0000 : 0x2403_8000
        io.writeTransmitBuffer(.init(bitPattern: bits))
        io.writeReceiveBuffer(.init(bitPattern: bits + 4))
        XCTAssertEqual(UInt(bitPattern: copy.readTransmitBuffer()), bits)
        XCTAssertEqual(UInt(bitPattern: copy.readReceiveBuffer()), bits + 4)
        XCTAssertEqual(pointers[1], bits)
        XCTAssertEqual(pointers[2], bits + 4)
        copy.writeTransmitBuffer(nil)
        copy.writeReceiveBuffer(nil)
        XCTAssertNil(io.readTransmitBuffer())
        XCTAssertNil(io.readReceiveBuffer())
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[30], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0xC001_C0DE)
        XCTAssertEqual(pointers[3], 0xC001_C0DE)
      }
    }
  }
  func testCallbackSlotsAndTransceiverSignature() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 11) { storage in
      withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 1) { context in
        storage.initialize(repeating: 0)
        context.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[10] = 0x5678
        let io = STM32SDCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 9),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let callback: SDCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for (slot, id) in SDCallbackID.allCases.enumerated() {
          XCTAssertNil(io.read(id))
          io.write(id, value: callback)
          XCTAssertEqual(storage[slot + 1], unsafeBitCast(callback, to: UInt.self))
          copy.read(id)!(copy.context)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 8)
        let transceiver: SDTransceiverCallback = { _ in }
        io.writeTransceiver(transceiver)
        XCTAssertEqual(storage[9], unsafeBitCast(transceiver, to: UInt.self))
        XCTAssertEqual(
          unsafeBitCast(copy.readTransceiver()!, to: UInt.self),
          unsafeBitCast(transceiver, to: UInt.self))
        copy.readTransceiver()!(1)
        copy.writeTransceiver(nil)
        XCTAssertNil(io.readTransceiver())
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[10], 0x5678)
      }
    }
  }
}
