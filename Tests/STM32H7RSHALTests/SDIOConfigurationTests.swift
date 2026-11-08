import CSDIOReference
import STM32H7RSHAL
import XCTest

func prepareSDIO(_ f: SDIOFixture) {
  f.write(.state, value: 1)
  f.write(.blockSize, value: 512)
  f.set(3, 4, 1)
  f.set(3, 8, 1)
  f.set(3, 14, 1)
  f.set(3, 12, 1)
  f.set(2, 24, 1)
  f.set(2, 25, 1)
  f.set(0, SDMMCRegister.fifo.rawValue / 4, 0x4433_2211)
  f.set(4, 0, 0x80)
  f.set(4, 3 * 6 + 2, 0x1234_0000)
  f.set(4, 5 * 6 + 2, 0x9010_0000)
  f.set(4, 53 * 6, 0xC040)
  f.set(15, 3, 0xFF)
}

final class SDIOConfigurationTests: XCTestCase {
  func testDefaultAndCustomCardIdentification() {
    for variant: UInt32 in 0..<4 {
      for present: UInt32 in [0, 1, 2] {
        for state: UInt32 in [0, 1, 2] {
          for kind: UInt32 in [0, 1, 2, 3] {
            checkSDIO(
              { f in
                prepareSDIO(f)
                f.write(.state, value: state)
                f.write(.transceiverPresent, value: present)
                f.write(.busWide, value: 1)
                f.write(.errorCode, value: 0x800)
                if kind != 0 { CSDIO_SetCallback(f.state, 19, CSDIO_Callback(19, 2)) }
                f.set(2, 30, kind == 1 ? 0 : kind)
              }, operation: 0, variant: variant)
          }
        }
      }
      let f = SDIOFixture(variant: variant)
      prepareSDIO(f)
      f.write(.state, value: 0)
      XCTAssertEqual(f.run(0), 0)
      XCTAssertEqual(f.read(.state), 1)
    }
  }

  func testEnumerationCommandFailuresAndIllegalCommandRetries() {
    for command: UInt32 in [0, 5, 11, 3, 7, 52] {
      for flags: UInt32 in [1, 4] {
        checkSDIO(
          { f in
            prepareSDIO(f)
            f.set(4, 5 * 6 + 2, 0x9110_0000)
            f.set(4, command * 6, flags)
          }, operation: 0)
      }
    }
    checkSDIO(
      { f in
        prepareSDIO(f)
        f.set(3, 12, 1)
        f.set(4, 3 * 6 + 2, 0x4000)
      }, operation: 0)
    for clock: UInt32 in [0, 1, 399999, 800000, 64_000_000] {
      checkSDIO(
        { f in
          prepareSDIO(f)
          f.set(2, 5, clock)
        }, operation: 0)
    }
  }

  func testConfigurationModesBlockSizesAndDeinitialization() {
    for state: UInt32 in [0, 1, 2, 255] {
      for operation: UInt32 in [1, 2, 5, 6, 21, 22] {
        for mode: UInt32 in [0, 1, 2, 3, 0x4000, UInt32.max] {
          checkSDIO(
            { f in
              prepareSDIO(f)
              f.write(.state, value: state)
              f.set(0, SDMMCRegister.clkcr.rawValue / 4, 0x1234_ABCD)
            }, operation: operation, mode)
        }
      }
      for speed: UInt32 in [1, 400000, 25_000_000, 64_000_000, 0x7FFF_FFFF] {
        checkSDIO(
          { f in
            prepareSDIO(f)
            f.write(.state, value: state)
          }, operation: 3, speed)
      }
    }
    for function: UInt32 in 0..<8 {
      for size: UInt32 in [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048] {
        checkSDIO(prepareSDIO, operation: 4, function, size)
      }
    }
  }

  func testCallbackRegistrationAndFeatureCombinations() {
    for variant: UInt32 in 0..<4 {
      for state: UInt32 in [0, 1, 2, 255] {
        for id: UInt32 in [0, 1, 2, 3, 16, 17, 18, UInt32.max] {
          for kind: UInt32 in [0, 1, 2] {
            for op: UInt32 in [16, 17] {
              checkSDIO(
                { f in
                  prepareSDIO(f)
                  f.write(.state, value: state)
                  f.write(.errorCode, value: 0x1234)
                }, operation: op, id, kind, variant: variant)
            }
          }
        }
        for op: UInt32 in [18, 19, 20] {
          for kind: UInt32 in [0, 1, 2] {
            checkSDIO(
              { f in
                prepareSDIO(f)
                f.write(.state, value: state)
              }, operation: op, kind, variant: variant)
          }
        }
      }
    }
  }

  func testCCCRAndFBRDecodingPreservesUnwrittenFields() {
    for fill: UInt32 in [0, 1, 0x40, 0x80, 0xFF] {
      for op: UInt32 in [7, 8] {
        checkSDIO(
          { f in
            prepareSDIO(f)
            for i: UInt32 in 0..<2048 { f.set(15, i, (i &* 37 &+ fill) & 255) }
            for i: UInt32 in 0..<35 { f.set(11, i, 0xAABB_CC55) }
            for i: UInt32 in 0..<6 { f.set(10, i, UInt32.max) }
          }, operation: op)
      }
    }
    for op: UInt32 in [7, 8] {
      checkSDIO(
        { f in
          prepareSDIO(f)
          f.set(2, 10, 1)
        }, operation: op)
      checkSDIO(
        { f in
          prepareSDIO(f)
          f.set(4, 52 * 6, 4)
        }, operation: op)
    }
  }
}
