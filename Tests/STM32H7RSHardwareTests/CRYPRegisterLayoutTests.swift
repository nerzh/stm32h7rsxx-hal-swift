import STM32H7RSHAL
import XCTest

@testable import STM32H7RSHardware

#if STM32H7S
  import STM32H7S
#endif

final class CRYPRegisterLayoutTests: XCTestCase {
  #if STM32H7S
    func testRegisterAddressesAndIntentionalLayoutAliases() {
      let normal = STM32CRYPRegisters(.cryp)
      let secure = STM32CRYPRegisters(.saes)
      XCTAssertEqual(normal.address(of: .cr), 0x4802_0800)
      XCTAssertEqual(secure.address(of: .cr), 0x4802_1000)
      for (r, address): (CRYPRegister, UInt) in [
        (.cr, cryp.cr.unsafeAddress), (.sr, cryp.sr.unsafeAddress), (.din, cryp.dinr.unsafeAddress),
        (.dout, cryp.doutr.unsafeAddress),
        (.dmacr, cryp.dmacr.unsafeAddress), (.imscr, cryp.imscr.unsafeAddress),
        (.risr, cryp.risr.unsafeAddress), (.misr, cryp.misr.unsafeAddress),
        (.k0lr, cryp.key[0].klr.unsafeAddress), (.k0rr, cryp.key[0].krr.unsafeAddress),
        (.k3lr, cryp.key[3].klr.unsafeAddress), (.k3rr, cryp.key[3].krr.unsafeAddress),
        (.iv0lr, cryp.`init`[0].ivlr.unsafeAddress), (.iv1rr, cryp.`init`[1].ivrr.unsafeAddress),
        (.csgcmccm0r, cryp.csgcmccmr[0].unsafeAddress),
        (.csgcmccm7r, cryp.csgcmccmr[7].unsafeAddress),
        (.csgcm0r, cryp.csgcmr[0].unsafeAddress), (.csgcm7r, cryp.csgcmr[7].unsafeAddress),
      ] { XCTAssertEqual(normal.nativeAddress(of: r), address) }
      for (r, address): (CRYPRegister, UInt) in [
        (.cr, saes.cr.unsafeAddress), (.sr, saes.sr.unsafeAddress),
        (.dinr, saes.dinr.unsafeAddress), (.doutr, saes.doutr.unsafeAddress),
        (.keyr0, saes.keyr0.unsafeAddress), (.keyr3, saes.keyr3.unsafeAddress),
        (.keyr4, saes.keyr4.unsafeAddress), (.keyr7, saes.keyr7.unsafeAddress),
        (.ivr0, saes.ivr0.unsafeAddress), (.ivr3, saes.ivr3.unsafeAddress),
        (.ier, saes.ier.unsafeAddress), (.isr, saes.isr.unsafeAddress),
        (.icr, saes.icr.unsafeAddress),
      ] { XCTAssertEqual(secure.nativeAddress(of: r), address) }
      XCTAssertEqual(secure.nativeAddress(of: .dmacr), saes.keyr0.unsafeAddress)
      XCTAssertEqual(secure.address(of: .csgcm7r), 0x4802_108C)
    }
  #endif
  func testHandleFieldWidthsPointersAndSavedArrays() {
    let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 42)
    let pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 14)
    let saved = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 30)
    words.initialize(repeating: 0xDEAD_BEEF)
    pointers.initialize(repeating: 0)
    saved.initialize(repeating: 0xA5A5_A5A5)
    pointers[0] = 17
    pointers[13] = 19
    defer {
      words.deallocate()
      pointers.deallocate()
      saved.deallocate()
    }
    let h = STM32CRYPHandleRegisters(
      words: .init(rebasing: words[1..<41]), pointers: .init(rebasing: pointers[1..<13]),
      saved: .init(rebasing: saved[1..<29]))
    for original in [false, true] {
      for field in CRYPConfigurationWord.allCases {
        let value = UInt32(field.rawValue) + 0x1234_0000
        h.write(field, saved: original, value: value)
        XCTAssertEqual(h.read(field, saved: original), value)
        XCTAssertEqual(words[1 + (original ? 9 : 0) + field.rawValue], value)
      }
    }
    for field in CRYPHandleWord.allCases {
      let value = UInt32(field.rawValue) + 0x5678_0000
      h.write(field, value: value)
      XCTAssertEqual(h.read(field), value)
      XCTAssertEqual(words[19 + field.rawValue], value)
    }
    for field in CRYPHandleHalfWord.allCases {
      let value = UInt16(field.rawValue) + 0x4321
      h.write(field, value: value)
      XCTAssertEqual(h.read(field), value)
      XCTAssertEqual(words[35 + field.rawValue], 0xDEAD_0000 | UInt32(value))
    }
    for field in CRYPPointer.allCases {
      let pointer = saved.baseAddress!.advanced(by: field.rawValue + 1)
      h.writePointer(field, value: pointer)
      XCTAssertEqual(h.readPointer(field), pointer)
      XCTAssertEqual(pointers[field.rawValue + 1], UInt(bitPattern: pointer))
      h.writePointer(field, value: nil)
      XCTAssertNil(h.readPointer(field))
    }
    XCTAssertEqual(h.savedWords(.initialVector), saved.baseAddress!.advanced(by: 1))
    XCTAssertEqual(h.savedWords(.context), saved.baseAddress!.advanced(by: 5))
    XCTAssertEqual(h.savedWords(.key), saved.baseAddress!.advanced(by: 21))
    XCTAssertEqual(words[0], 0xDEAD_BEEF)
    XCTAssertEqual(words[41], 0xDEAD_BEEF)
    XCTAssertEqual(saved[0], 0xA5A5_A5A5)
    XCTAssertEqual(saved[29], 0xA5A5_A5A5)
    XCTAssertEqual(pointers[0], 17)
    XCTAssertEqual(pointers[13], 19)
  }
  func testOneBasedCallbackIDsUseFiveSlots() {
    let slots = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 7)
    slots.initialize(repeating: 0)
    slots[0] = 17
    slots[6] = 19
    defer { slots.deallocate() }
    var calls: UInt32 = 0
    withUnsafeMutablePointer(to: &calls) { context in
      let io = STM32CRYPCallbackRegisters(storage: .init(rebasing: slots[1..<6]), context: context)
      let callback: CRYPCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee += 1 }
      for id in CRYPCallbackID.allCases {
        XCTAssertNil(io.read(id))
        io.write(id, value: callback)
        XCTAssertEqual(slots[Int(id.rawValue)], unsafeBitCast(callback, to: UInt.self))
        io.read(id)!(io.context)
        io.write(id, value: nil)
        XCTAssertNil(io.read(id))
      }
    }
    XCTAssertEqual(calls, 5)
    XCTAssertEqual(slots[0], 17)
    XCTAssertEqual(slots[6], 19)
  }
}
