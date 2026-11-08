import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class I3CRegisterLayoutTests: XCTestCase {
  func testPinnedCMSISOffsetsAtSharedSVDBase() {
    let io = STM32I3CRegisters()
    XCTAssertEqual(io.address(of: .cr), 0x4000_5400)
    XCTAssertEqual(io.address(of: .cfgr), 0x4000_5404)
    XCTAssertEqual(io.address(of: .rdr), 0x4000_5410)
    XCTAssertEqual(io.address(of: .rdwr), 0x4000_5414)
    XCTAssertEqual(io.address(of: .tdr), 0x4000_5418)
    XCTAssertEqual(io.address(of: .tdwr), 0x4000_541c)
    XCTAssertEqual(io.address(of: .ibidr), 0x4000_5420)
    XCTAssertEqual(io.address(of: .tgttdr), 0x4000_5424)
    XCTAssertEqual(io.address(of: .sr), 0x4000_5430)
    XCTAssertEqual(io.address(of: .ser), 0x4000_5434)
    XCTAssertEqual(io.address(of: .rmr), 0x4000_5440)
    XCTAssertEqual(io.address(of: .evr), 0x4000_5450)
    XCTAssertEqual(io.address(of: .ier), 0x4000_5454)
    XCTAssertEqual(io.address(of: .cevr), 0x4000_5458)
    XCTAssertEqual(io.address(of: .devr0), 0x4000_5460)
    XCTAssertEqual(io.address(of: .devrx1), 0x4000_5464)
    XCTAssertEqual(io.address(of: .devrx2), 0x4000_5468)
    XCTAssertEqual(io.address(of: .devrx3), 0x4000_546c)
    XCTAssertEqual(io.address(of: .devrx4), 0x4000_5470)
    XCTAssertEqual(io.address(of: .maxrlr), 0x4000_5490)
    XCTAssertEqual(io.address(of: .maxwlr), 0x4000_5494)
    XCTAssertEqual(io.address(of: .timingr0), 0x4000_54a0)
    XCTAssertEqual(io.address(of: .timingr1), 0x4000_54a4)
    XCTAssertEqual(io.address(of: .timingr2), 0x4000_54a8)
    XCTAssertEqual(io.address(of: .bcr), 0x4000_54c0)
    XCTAssertEqual(io.address(of: .dcr), 0x4000_54c4)
    XCTAssertEqual(io.address(of: .getcapr), 0x4000_54c8)
    XCTAssertEqual(io.address(of: .crcapr), 0x4000_54cc)
    XCTAssertEqual(io.address(of: .getmxdsr), 0x4000_54d0)
    XCTAssertEqual(io.address(of: .epidr), 0x4000_54d4)
  }

  func testSharedHandleStorageWidthsAndPointers() {
    withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 22) { words in
      withUnsafeTemporaryAllocation(of: UInt.self, capacity: 5) { pointers in
        words.initialize(repeating: 0xA55A_A55A)
        pointers.initialize(repeating: 0x1234)
        let io = STM32I3CHandleRegisters(
          words: .init(start: words.baseAddress! + 1, count: 20),
          pointers: .init(start: pointers.baseAddress! + 1, count: 3))
        let copy = io
        for field in I3CConfigurationWord.allCases {
          let value: UInt32 = 0x1234_5600 | UInt32(field.rawValue)
          io.write(field, value: value)
          XCTAssertEqual(copy.read(field), field.rawValue < 2 ? value : value & 0xFF)
          XCTAssertEqual(
            words[1 + field.rawValue], field.rawValue < 2 ? value : 0xA55A_A500 | (value & 0xFF))
        }
        for field in I3CHandleWord.allCases {
          let value: UInt32 = 0x8000_0000 | UInt32(field.rawValue)
          io.write(field, value: value)
          XCTAssertEqual(copy.read(field), value)
          XCTAssertEqual(words[10 + field.rawValue], value)
        }
        let bits: UInt = MemoryLayout<UInt>.size == 8 ? 0x1234_5678_ABC0_0000 : 0x2403_8000
        io.writeTransfer(UnsafeMutablePointer<I3CTransfer>(bitPattern: bits))
        XCTAssertEqual(UInt(bitPattern: copy.readTransfer()), bits)
        io.writeCCCDescriptors(UnsafePointer<I3CCCCDescriptor>(bitPattern: bits + 16))
        XCTAssertEqual(UInt(bitPattern: copy.readCCCDescriptors()), bits + 16)
        io.writePrivateDescriptors(UnsafePointer<I3CPrivateDescriptor>(bitPattern: bits + 32))
        XCTAssertEqual(UInt(bitPattern: copy.readPrivateDescriptors()), bits + 32)
        XCTAssertEqual(pointers[1], bits)
        XCTAssertEqual(pointers[2], bits + 16)
        XCTAssertEqual(pointers[3], bits + 32)
        copy.writeTransfer(nil)
        copy.writeCCCDescriptors(nil)
        copy.writePrivateDescriptors(nil)
        XCTAssertNil(io.readTransfer())
        XCTAssertNil(io.readCCCDescriptors())
        XCTAssertNil(io.readPrivateDescriptors())
        XCTAssertEqual(words[0], 0xA55A_A55A)
        XCTAssertEqual(words[21], 0xA55A_A55A)
        XCTAssertEqual(pointers[0], 0x1234)
        XCTAssertEqual(pointers[4], 0x1234)
      }
    }
  }

  func testCallbackSignaturesAndSlots() {
    withUnsafeTemporaryAllocation(of: UInt.self, capacity: 15) { storage in
      withUnsafeTemporaryAllocation(of: UInt64.self, capacity: 1) { context in
        storage.initialize(repeating: 0)
        context.initialize(repeating: 0)
        storage[0] = 0x1234
        storage[14] = 0x5678
        let io = STM32I3CCallbackRegisters(
          storage: .init(start: storage.baseAddress! + 1, count: 13),
          context: UnsafeMutableRawPointer(context.baseAddress!))
        let copy = io
        let basic: I3CCallback = { $0!.assumingMemoryBound(to: UInt64.self).pointee &+= 1 }
        for id in I3CCallbackID.allCases {
          XCTAssertNil(io.read(id))
          io.write(id, value: basic)
          copy.read(id)!(copy.context)
          XCTAssertNotEqual(storage[1 + Int(id.rawValue)], 0)
          copy.write(id, value: nil)
          XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context[0], 10)
        io.writeTargetRequestDynamicAddress {
          $0!.assumingMemoryBound(to: UInt64.self).pointee = $1
        }
        copy.readTargetRequestDynamicAddress()!(copy.context, 0xFEDC_BA98_7654_3210)
        XCTAssertEqual(context[0], 0xFEDC_BA98_7654_3210)
        XCTAssertNotEqual(storage[5], 0)
        io.writeTargetHotJoin { $0!.assumingMemoryBound(to: UInt64.self).pointee = UInt64($1) }
        copy.readTargetHotJoin()!(copy.context, 0xA5)
        XCTAssertEqual(context[0], 0xA5)
        XCTAssertNotEqual(storage[8], 0)
        io.writeNotify { $0!.assumingMemoryBound(to: UInt64.self).pointee = UInt64($1) }
        copy.readNotify()!(copy.context, 0xFEDC_BA98)
        XCTAssertEqual(context[0], 0xFEDC_BA98)
        XCTAssertNotEqual(storage[9], 0)
        copy.writeTargetRequestDynamicAddress(nil)
        copy.writeTargetHotJoin(nil)
        copy.writeNotify(nil)
        XCTAssertNil(io.readTargetRequestDynamicAddress())
        XCTAssertNil(io.readTargetHotJoin())
        XCTAssertNil(io.readNotify())
        XCTAssertEqual(storage[0], 0x1234)
        XCTAssertEqual(storage[14], 0x5678)
      }
    }
  }
}
