import CTIMReference
import STM32H7RSHAL
import XCTest

final class TIMControlTests: XCTestCase {
  func testAllExportedRegisterMacrosAndResetStates() {
    for registered in [false, true] {
      for op: UInt32 in 200...235 {
        for channel: UInt32 in [0, 4, 8, 12, 16, 20, 24, 60] {
          for seed: UInt32 in [0, 0xAAAA_AAAA, 0xFFFF_FFFF] {
            let p = TIMPair(callbacks: registered)
            p.setup { f in
              for r in TIMRegister.allCases { f.raw(r, seed) }
              for i: UInt32 in 0..<20 { f.set(1, i, seed) }
            }
            p.verify(op, channel, 0x1234)
          }
        }
      }
    }
  }
  func testCalculationMacrosRoundingDitheringAndOverflow() {
    for clock: UInt32 in [1, 1000, 1_000_000, 64_000_000, 600_000_000, UInt32.max] {
      for prescaler: UInt32 in [0, 1, 15, 65535] {
        for value: UInt32 in [1, 1000, 123456, UInt32.max] {
          let p = TIMPair()
          p.verify(301, clock, value)
          if value &* (prescaler &+ 1) != 0 {
            p.verify(302, clock, prescaler, value)
            p.verify(303, clock, prescaler, value)
          }
          p.verify(304, clock, prescaler, value)
          p.verify(305, clock, prescaler, value)
          p.verify(306, clock, prescaler, value, 654321)
          p.verify(307, clock, prescaler, value, 654321)
        }
      }
    }
    for counter: UInt32 in [0, 0x7FFF_FFFF, 0x8000_0000, 0xFFFF_FFFF] {
      let p = TIMPair()
      p.verify(300, counter)
    }
  }
}
