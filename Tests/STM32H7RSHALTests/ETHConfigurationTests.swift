import CETHReference
import STM32H7RSHAL
import XCTest

final class ETHConfigurationTests: XCTestCase {
  func testMACAndDMASettersGettersAndStateGates() {
    for seed: UInt32 in [0, 1, 0xFFFF_FFFF, 0xA55A_A55A] {
      for state: UInt32 in [0, 0x10, 0x20, 0x40, 0xE0] {
        let pair = ETHRegisterPair()
        pair.seed(seed)
        pair.word(.state, state)
        pair.configuration(0, 0, seed &+ 0 &* 0x10203)
        pair.configuration(0, 1, (seed >> 1) & 1)
        pair.configuration(0, 2, seed &+ 2 &* 0x10203)
        pair.configuration(0, 3, (seed >> 3) & 1)
        pair.configuration(0, 4, (seed >> 4) & 1)
        pair.configuration(0, 5, (seed >> 5) & 1)
        pair.configuration(0, 6, (seed >> 6) & 1)
        pair.configuration(0, 7, (seed >> 7) & 1)
        pair.configuration(0, 8, (seed >> 8) & 1)
        pair.configuration(0, 9, (seed >> 9) & 1)
        pair.configuration(0, 10, seed &+ 10 &* 0x10203)
        pair.configuration(0, 11, seed &+ 11 &* 0x10203)
        pair.configuration(0, 12, (seed >> 12) & 1)
        pair.configuration(0, 13, (seed >> 13) & 1)
        pair.configuration(0, 14, (seed >> 14) & 1)
        pair.configuration(0, 15, (seed >> 15) & 1)
        pair.configuration(0, 16, (seed >> 16) & 1)
        pair.configuration(0, 17, seed &+ 17 &* 0x10203)
        pair.configuration(0, 18, (seed >> 18) & 1)
        pair.configuration(0, 19, seed &+ 19 &* 0x10203)
        pair.configuration(0, 20, (seed >> 20) & 1)
        pair.configuration(0, 21, (seed >> 21) & 1)
        pair.configuration(0, 22, (seed >> 22) & 1)
        pair.configuration(0, 23, seed &+ 23 &* 0x10203)
        pair.configuration(0, 24, (seed >> 24) & 1)
        pair.configuration(0, 25, seed &+ 25 &* 0x10203)
        pair.configuration(0, 26, (seed >> 26) & 1)
        pair.configuration(0, 27, seed &+ 27 &* 0x10203)
        pair.configuration(0, 28, seed &+ 28 &* 0x10203)
        pair.configuration(0, 29, (seed >> 29) & 1)
        pair.configuration(0, 30, seed &+ 30 &* 0x10203)
        pair.configuration(0, 31, (seed >> 31) & 1)
        pair.configuration(0, 32, (seed >> 0) & 1)
        pair.configuration(0, 33, (seed >> 1) & 1)
        pair.configuration(0, 34, seed &+ 34 &* 0x10203)
        pair.configuration(0, 35, seed &+ 35 &* 0x10203)
        pair.configuration(0, 36, (seed >> 4) & 1)
        pair.configuration(0, 37, (seed >> 5) & 1)
        pair.configuration(0, 38, (seed >> 6) & 1)
        pair.run(36)
        pair.run(34)
        pair.run(53)
        pair.run(34)
      }
    }
    for seed: UInt32 in [0, 1, 0xFFFF_FFFF, 0xA55A_A55A] {
      for state: UInt32 in [0, 0x10, 0x20, 0x40, 0xE0] {
        let pair = ETHRegisterPair()
        pair.seed(seed)
        pair.word(.state, state)
        pair.configuration(1, 0, seed &+ 0 &* 0x10203)
        pair.configuration(1, 1, (seed >> 1) & 1)
        pair.configuration(1, 2, seed &+ 2 &* 0x10203)
        pair.configuration(1, 3, (seed >> 3) & 1)
        pair.configuration(1, 4, (seed >> 4) & 1)
        pair.configuration(1, 5, seed &+ 5 &* 0x10203)
        pair.configuration(1, 6, (seed >> 6) & 1)
        pair.configuration(1, 7, seed &+ 7 &* 0x10203)
        pair.configuration(1, 8, (seed >> 8) & 1)
        pair.configuration(1, 9, (seed >> 9) & 1)
        pair.configuration(1, 10, seed &+ 10 &* 0x10203)
        pair.run(37)
        pair.run(35)
        pair.run(54)
        pair.run(35)
      }
    }
  }
  func testDefaultConfigurationAcrossBuildOptions() {
    for callbacks: UInt32 in 0...1 {
      for ptp: UInt32 in 0...1 {
        for rings: UInt32 in [3, 4, 8] {
          let pair = ETHRegisterPair(callbacks: callbacks, ptp: ptp, rings: rings)
          pair.seed(0xA5A5_A5A5)
          pair.run(55)
          pair.run(34)
          pair.run(35)
        }
      }
    }
  }
  func testConfigurationNullPointers() {
    let pair = ETHRegisterPair()
    pair.seed(0x55AA_55AA)
    for op: UInt32 in [34, 35, 36, 37, 39, 40, 41, 42, 46] {
      XCTAssertEqual(pair.run(op, 0, 0, 1), HALStatus.error.rawValue)
    }
  }
  func testMDIOClockThresholds() {
    for hz: UInt32 in [
      0, 34_999_999, 35_000_000, 59_999_999, 60_000_000, 99_999_999, 100_000_000, 149_999_999,
      150_000_000, 249_999_999, 250_000_000, UInt32.max,
    ] {
      let pair = ETHRegisterPair()
      pair.seed(0x55AA_55AA)
      CETH_Control(pair.c)![7] = hz
      pair.swift.control[7] = hz
      pair.run(38)
    }
  }
  func testMACFilteringAndReceiveVLANIdentifier() {
    for seed: UInt32 in 0..<32 {
      let pair = ETHRegisterPair()
      pair.seed(0xFFFF_FFFF)
      for field: UInt32 in 0..<10 { pair.configuration(3, field, (seed >> (field % 5)) & 1) }
      pair.configuration(3, 10, (seed & 3) << 6)
      pair.run(39)
      pair.run(40)
      for bits: UInt32 in [0, 1, 0x10000] { pair.run(43, bits, seed &* 0x1001_0203) }
    }
  }
  func testHashTableWakeupFilterAndPowerDown() {
    for count: UInt32 in [0, 1, 4, 8] {
      let pair = ETHRegisterPair()
      pair.seed(0xA55A_A55A)
      for i in 0..<8 {
        CETH_Buffer(pair.c, 0)![i] = UInt32(i) &* 0x1020304
        CETH_Buffer(pair.swift.state, 0)![i] = UInt32(i) &* 0x1020304
      }
      pair.run(42)
      pair.run(46, count)
    }
    for bits: UInt32 in 0..<16 {
      let pair = ETHRegisterPair()
      pair.seed(0xA5A5_5A5A)
      for i: UInt32 in 0..<4 { pair.configuration(4, i, (bits >> i) & 1) }
      pair.run(44)
      pair.run(45)
      pair.run(45)
    }
  }
}
