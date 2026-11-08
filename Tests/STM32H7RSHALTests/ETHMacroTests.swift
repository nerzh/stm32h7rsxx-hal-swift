import CETHReference
import STM32H7RSHAL
import XCTest

final class ETHMacroTests: XCTestCase {
  func testRegisterAndWakeupMacros() {
    for cb: UInt32 in 0...1 {
      for seed: UInt32 in [0, 0xFFFF_FFFF, 0xA55A_5AA5] {
        for mask: UInt32 in [0, 1, 0x4000, 0xFFFF_FFFF] {
          let p = ETHRegisterPair(callbacks: cb, ptp: 1)
          p.seed(seed)
          for i: UInt32 in 0..<5 {
            CETH_SetEXTI(p.c, i, seed)
            CETH_SetEXTI(p.swift.state, i, seed)
          }
          for op: UInt32 in 80...99 { p.run(op, mask) }
        }
      }
    }
  }
  func testDescriptorIndexMacroUsesSingleSubtraction() {
    for ring: UInt32 in [3, 4, 8] {
      let p = ETHRegisterPair(rings: ring)
      for index: UInt32 in [0, ring - 1, ring, UInt32.max] {
        for offset: UInt32 in [0, 1, ring, ring * 3, UInt32.max] {
          p.run(100, index, offset)
          p.run(101, index, offset)
        }
      }
    }
  }
}
