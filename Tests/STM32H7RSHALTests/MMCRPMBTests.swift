import STM32H7RSHAL
import XCTest

func prepareMMCRPMB(_ f: MMCFixture, operation: UInt32 = 42) {
  prepareMMCCard(f)
  f.set(2, 24, 1)
  for i: UInt32 in 0..<512 { f.set(17, i, (i &* 29 &+ 7) & 255) }
  for i: UInt32 in 0..<16 { f.set(17, 484 + i, UInt32(f.buffer(2)[Int(i)])) }
  for (index, value): (UInt32, UInt32) in [
    (500, 0x12), (501, 0x34), (502, 0x56), (503, 0x78), (508, 0), (509, 0),
    (510, operation == 41 ? 1 : operation == 44 ? 4 : 2), (511, 0),
  ] {
    f.set(17, index, value)
  }
}
func mmcTransmittedByte(_ f: MMCFixture, _ index: UInt32) -> UInt32 {
  (f.get(18, index / 4) >> ((index & 3) * 8)) & 255
}

func prepareMMCRPMBWrite(_ f: MMCFixture, result: UInt32 = 0, response: UInt32 = 3) {
  prepareMMCRPMB(f)
  for i: UInt32 in 0..<1024 { f.set(17, i, 0) }
  let nonce: [UInt32] = [0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 8]
  for i in 0..<16 { f.set(17, 484 + UInt32(i), nonce[i]) }
  f.set(17, 500, 0x12)
  f.set(17, 501, 0x34)
  f.set(17, 502, 0x56)
  f.set(17, 503, 0x78)
  f.set(17, 510, 2)
  f.set(17, 512 + 509, result)
  f.set(17, 512 + 510, response)
}

func prepareMMCRPMBRead(_ f: MMCFixture, count: UInt32, mismatch: Bool = false) {
  prepareMMCRPMB(f, operation: 44)
  for frame: UInt32 in 0..<count {
    for i: UInt32 in 0..<512 { f.set(17, frame * 512 + i, (i * 29 + frame * 17 + 7) & 255) }
    for i: UInt32 in 0..<16 { f.set(17, frame * 512 + 484 + i, UInt32(f.buffer(2)[Int(i)])) }
    f.set(17, frame * 512 + 509, 0)
    f.set(17, frame * 512 + 510, 4)
  }
  if mismatch { f.set(17, count * 512 - 13, f.get(17, count * 512 - 13) ^ 1) }
}

final class MMCRPMBTests: XCTestCase {
  func testAuthenticationKeyFrameAndResponseStatus() {
    for result: UInt32 in [0, 1, 2, 7, 0x80, 0xFF] {
      for response: UInt32 in [0, 1, 2, 0xFF] {
        checkMMC(
          { f in
            prepareMMCRPMB(f, operation: 41)
            f.set(17, 509, result)
            f.set(17, 510, response)
            f.writeRPMBErrorCode(0x4000)
          }, operation: 41, 1000)
      }
    }
    let f = MMCFixture()
    prepareMMCRPMB(f, operation: 41)
    XCTAssertEqual(f.run(41, 1000), 0)
    XCTAssertEqual(f.get(2, 27), 128)
    for i: UInt32 in 0..<512 {
      let expected: UInt32 =
        (196..<228).contains(i) ? UInt32(f.buffer(2)[Int(i - 196)]) : i == 511 ? 1 : 0
      XCTAssertEqual(mmcTransmittedByte(f, i), expected)
    }
  }

  func testCounterByteOrderNonceMismatchAndRetainedStatusBehavior() {
    for mismatch: UInt32 in 0...16 {
      for result: UInt32 in [0, 0xFF] {
        checkMMC(
          { f in
            prepareMMCRPMB(f)
            if mismatch < 16 { f.set(17, 484 + mismatch, f.get(17, 484 + mismatch) ^ 1) }
            f.set(17, 509, result)
            f.writeRPMBErrorCode(0x4000)
          }, operation: 42, 1000)
      }
    }
    let f = MMCFixture()
    prepareMMCRPMB(f)
    XCTAssertEqual(f.run(42, 1000), 0x1234_5678)
    for i: UInt32 in 0..<512 {
      let expected: UInt32 =
        (484..<500).contains(i) ? UInt32(f.buffer(2)[Int(i - 484)]) : i == 511 ? 2 : 0
      XCTAssertEqual(mmcTransmittedByte(f, i), expected)
    }
  }

  func testSingleBlockReadDataMACNonceAndAddressBytes() {
    for address: UInt32 in [0, 1, 0x1234, 0xFFFF] {
      for mismatch: UInt32 in [0, 8, 15, 16] {
        checkMMC(
          { f in
            prepareMMCRPMB(f, operation: 44)
            if mismatch < 16 { f.set(17, 484 + mismatch, f.get(17, 484 + mismatch) ^ 1) }
          }, operation: 44, address, 1, 1000)
      }
    }
    let f = MMCFixture()
    prepareMMCRPMB(f, operation: 44)
    XCTAssertEqual(f.run(44, 0x1234, 1, 1000), 0)
    for i: UInt32 in 0..<256 { XCTAssertEqual(UInt32(f.buffer(1)[Int(i)]), f.get(17, 228 + i)) }
    for i: UInt32 in 0..<32 { XCTAssertEqual(UInt32(f.buffer(3)[Int(i)]), f.get(17, 196 + i)) }
    XCTAssertEqual(mmcTransmittedByte(f, 504), 0x12)
    XCTAssertEqual(mmcTransmittedByte(f, 505), 0x34)
    XCTAssertEqual(mmcTransmittedByte(f, 511), 4)
  }

  func testEntryChecksCommandErrorsAndTimeouts() {
    for operation: UInt32 in [41, 42, 43, 44] {
      for state: UInt32 in [0, 1, 3] {
        for timeout: UInt32 in [0, 1, 16, 17, 31, 1000] {
          checkMMC(
            { f in
              prepareMMCRPMB(f, operation: operation)
              f.write(.state, value: state)
              f.set(2, 2, UInt32.max - 5)
              // WriteBlocks stops at its fixed nonce mismatch before the upstream unsafe write phase.
            }, operation: operation, operation < 43 ? timeout : 0x1234, 1, timeout)
        }
      }
      for command: UInt32 in [23, 25, 18] {
        for flag: UInt32 in [1, 4, 0x42, 0x48, 0x50, 0x60] {
          checkMMC(
            { f in
              prepareMMCRPMB(f, operation: operation)
              f.set(4, command * 6, flag)
            }, operation: operation, operation < 43 ? 1000 : 7, 1, 1000)
        }
      }
      if operation != 44 {
        checkMMC(
          { f in
            prepareMMCRPMB(f, operation: operation)
            f.set(2, 9, 1)
          }, operation: operation, 1000, 1, 1000)
      }
    }
    for count: UInt32 in [0, 1, 2, 3, 31, 32, 33, 65535] {
      checkMMC({ f in prepareMMCRPMB(f) }, operation: 43, 0xFFFF, count, 1000)
    }
  }
  func testCorrectedWritePaddingFrameBoundariesAndPayloadBytes() {
    for count: UInt32 in [1, 2] {
      for address: UInt32 in [0, 0x1234, 0xFFFF] {
        checkMMC({ prepareMMCRPMBWrite($0) }, operation: 54, address, count, 1000)
        let f = MMCFixture()
        prepareMMCRPMBWrite(f)
        XCTAssertEqual(f.run(54, address, count, 1000), 0)
        XCTAssertEqual(f.get(2, 27), (count + 1) * 128)
        for frame: UInt32 in 0..<count {
          for i: UInt32 in 0..<512 {
            var expected: UInt32 = 0
            if i >= 196 && i < 228 { expected = UInt32(f.buffer(3)[Int(i - 196)]) }
            if i >= 228 && i < 484 { expected = UInt32(f.buffer(0)[Int(frame * 256 + i - 228)]) }
            if i >= 500 && i < 504 { expected = (0x1234_5678 >> ((503 - i) * 8)) & 255 }
            if i == 504 { expected = address >> 8 }
            if i == 505 { expected = address & 255 }
            if i == 507 { expected = count }
            if i == 511 { expected = 3 }
            XCTAssertEqual(mmcTransmittedByte(f, (frame + 1) * 512 + i), expected)
          }
        }
      }
    }
  }

  func testCorrectedWriteResponseErrorsAndMidFrameTimeouts() {
    for count: UInt32 in [1, 2] {
      for result: UInt32 in [0, 1, 2, 7, 0x80, 0xFF] {
        for response: UInt32 in [0, 2, 3, 4] {
          checkMMC(
            { prepareMMCRPMBWrite($0, result: result, response: response) },
            operation: 54, 7, count, 1000)
        }
      }
    }
    for count: UInt32 in [1, 2, 32] {
      for timeout: UInt32 in [32, 33, 34, 47, 48, 49, 63] {
        checkMMC({ prepareMMCRPMBWrite($0) }, operation: 54, 7, count, timeout)
      }
    }
  }

  func testCorrectedMultiBlockReadBoundariesAndLastFrameMAC() {
    for count: UInt32 in [2, 3, 7] {
      for mismatch in [false, true] {
        checkMMC(
          { prepareMMCRPMBRead($0, count: count, mismatch: mismatch) },
          operation: 55, 0x1234, count, 1000)
      }
      let f = MMCFixture()
      prepareMMCRPMBRead(f, count: count)
      XCTAssertEqual(f.run(55, 0x1234, count, 1000), 0)
      for frame: UInt32 in 0..<count {
        for i: UInt32 in 0..<256 {
          XCTAssertEqual(
            UInt32(f.buffer(1)[Int(frame * 256 + i)]), f.get(17, frame * 512 + 228 + i))
        }
      }
      for i: UInt32 in 0..<32 {
        XCTAssertEqual(UInt32(f.buffer(3)[Int(i)]), f.get(17, (count - 1) * 512 + 196 + i))
      }
      // The next byte belongs to caller storage and must remain untouched.
      XCTAssertEqual(UInt32(f.buffer(1)[Int(count * 256)]), 11)
    }
  }

}
