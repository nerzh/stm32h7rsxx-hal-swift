import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class SRAMRegisterLayoutTests: XCTestCase {
  func testLiveHandleFieldsAndSharedStorage() {
    let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 19)
    storage.initialize(repeating: 0xC001_C0DE)
    defer { storage.deallocate() }
    let live = UnsafeMutableBufferPointer(start: storage.baseAddress! + 1, count: 17)
    let a = STM32SRAMHandleRegisters(storage: live)
    let b = STM32SRAMHandleRegisters(storage: live)
    for field in SRAMConfigurationWord.allCases {
      a.write(field, value: UInt32(field.rawValue) | 0x1000)
      XCTAssertEqual(b.read(field), UInt32(field.rawValue) | 0x1000)
      XCTAssertEqual(live[field.rawValue], UInt32(field.rawValue) | 0x1000)
    }
    for field in SRAMHandleWord.allCases {
      a.write(field, value: UInt32(field.rawValue) | 0x2000)
      XCTAssertEqual(b.read(field), UInt32(field.rawValue) | 0x2000)
      XCTAssertEqual(live[15 + field.rawValue], UInt32(field.rawValue) | 0x2000)
    }
    live[16] = 3
    XCTAssertEqual(a.read(SRAMHandleWord.state), 3)
    XCTAssertEqual(storage[0], 0xC001_C0DE)
    XCTAssertEqual(storage[18], 0xC001_C0DE)
  }

  func testCallbacksUseNativeWidthUnownedSharedStorage() {
    let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 6)
    storage.initialize(repeating: 0xA55A_A55A)
    defer { storage.deallocate() }
    let live = UnsafeMutableBufferPointer(start: storage.baseAddress! + 1, count: 4)
    live.update(repeating: 0)
    let counter = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
    counter.initialize(to: 0)
    defer { counter.deallocate() }
    let a = STM32SRAMCallbackRegisters(storage: live, context: counter)
    let b = STM32SRAMCallbackRegisters(storage: live, context: counter)
    let callback: SRAMCallback = { context in
      context!.assumingMemoryBound(to: UInt32.self).pointee &+= 1
    }
    for id in SRAMCallbackID.allCases {
      XCTAssertNil(a.read(id))
      a.write(id, value: callback)
      XCTAssertEqual(live[Int(id.rawValue)], unsafeBitCast(callback, to: UInt.self))
      b.read(id)!(b.context)
      b.write(id, value: nil)
      XCTAssertNil(a.read(id))
    }
    XCTAssertEqual(counter.pointee, 4)
    XCTAssertEqual(storage[0], 0xA55A_A55A)
    XCTAssertEqual(storage[5], 0xA55A_A55A)
  }
}
