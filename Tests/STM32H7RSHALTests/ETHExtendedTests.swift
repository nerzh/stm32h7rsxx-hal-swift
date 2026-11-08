import CETHReference
import STM32H7RSHAL
import XCTest

final class ETHExtendedTests: XCTestCase {
  func testLayer3FiltersPreserveOriginalRegisterSelection() {
    for filter: UInt32 in [0, 12] {
      for protocolSelection: UInt32 in [0, 1] {
        for seed: UInt32 in [0, 0xFFFF_FFFF, 0xA5A5_5A5A, 0x1234_5678] {
          let pair = ETHRegisterPair()
          pair.seed(seed)
          for field: UInt32 in 0..<11 {
            pair.configuration(7, field, seed &+ field &* 0x1020_304)
          }
          pair.configuration(7, 0, protocolSelection)
          pair.configuration(7, 1, 0xC)
          pair.configuration(7, 2, 0x30)
          pair.configuration(7, 3, 0x1F)
          pair.configuration(7, 4, 0x1F)
          pair.run(65, filter)
          if filter == 12 {
            if protocolSelection == 0 {
              XCTAssertEqual(pair.swift.read(.macl3a0r1r), seed &+ 6 &* 0x1020_304)
              XCTAssertEqual(
                pair.swift.read(.macl3a1r1r), seed &+ ETHRegister.macl3a1r1r.rawValue &* 0x10203)
            } else {
              XCTAssertEqual(pair.swift.read(.macl3a1r1r), seed &+ 10 &* 0x1020_304)
              XCTAssertEqual(
                pair.swift.read(.macl3a2r1r), seed &+ ETHRegister.macl3a2r1r.rawValue &* 0x10203)
              XCTAssertEqual(
                pair.swift.read(.macl3a3r1r), seed &+ ETHRegister.macl3a3r1r.rawValue &* 0x10203)
            }
          }
          pair.run(66, filter)
        }
      }
    }
  }

  func testLayer4FiltersAndUnrelatedLayer3Bits() {
    for filter: UInt32 in [0, 12] {
      for protocolSelection: UInt32 in [0, 0x10000] {
        for ports: UInt32 in [0, 1, 0xFFFF, 0xFFFF_FFFF] {
          let pair = ETHRegisterPair()
          pair.seed(0x55AA_00FF)
          pair.configuration(8, 0, protocolSelection)
          pair.configuration(8, 1, 0xC0000)
          pair.configuration(8, 2, 0x300000)
          pair.configuration(8, 3, ports)
          pair.configuration(8, 4, ports ^ 0x1234)
          pair.run(63, filter)
          pair.run(64, filter)
        }
      }
    }
  }

  func testReceiveVLANConfiguration() {
    for mask: UInt32 in 0..<64 {
      let pair = ETHRegisterPair()
      pair.seed(0xA55A_F00F)
      let booleanFields: [UInt32] = [0, 2, 3, 4, 5, 8]
      for (index, field) in booleanFields.enumerated() {
        pair.configuration(5, field, (mask >> index) & 1)
      }
      pair.configuration(5, 1, (mask & 3) << 28)
      pair.configuration(5, 6, (mask & 3) << 21)
      pair.configuration(5, 7, (mask & 7) << 18)
      pair.run(70)
      pair.run(69)
    }
  }

  func testTransmitVLANConfigurationAndIdentifier() {
    for tag: UInt32 in [0, 1, 2] {
      for mask: UInt32 in 0..<16 {
        let pair = ETHRegisterPair()
        pair.seed(0xAA55_55AA)
        pair.configuration(6, 0, mask & 1)
        pair.configuration(6, 1, (mask >> 1) & 1)
        pair.configuration(6, 2, (mask & 7) << 16)
        pair.run(73, tag)
        pair.run(72, tag)
        pair.run(74, tag, mask &* 0x1234567)
      }
    }
  }

  func testNullConfigurationsDoNotWriteRegisters() {
    for op: UInt32 in [63, 64, 65, 66, 69, 70, 72] {
      let pair = ETHRegisterPair()
      pair.seed(0xDEAD_BEEF)
      XCTAssertEqual(pair.run(op, 12, 0, 1), HALStatus.error.rawValue)
    }
  }

  func testFeatureTogglesAndLPIModeAcrossBuildOptions() {
    for callbacks: UInt32 in 0...1 {
      for ptp: UInt32 in 0...1 {
        for rings: UInt32 in [3, 4, 8] {
          let pair = ETHRegisterPair(callbacks: callbacks, ptp: ptp, rings: rings)
          pair.seed(0x1234_5678)
          for op: UInt32 in [60, 61, 62, 67, 68, 71, 75, 76] {
            pair.run(op, 0x9876_5432)
          }
          for automate: UInt32 in 0...1 {
            for stop: UInt32 in 0...1 {
              pair.run(77, automate, stop)
              pair.run(78)
            }
          }
        }
      }
    }
  }

  func testHandleGetters() {
    let pair = ETHRegisterPair()
    for word in ETHHandleWord.allCases {
      pair.word(word, 0x1234_0000 | UInt32(word.rawValue))
    }
    for op: UInt32 in [47, 48, 49, 50, 51, 52, 79] { pair.run(op) }
  }
}
