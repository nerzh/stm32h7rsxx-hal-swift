import CTIMReference
import STM32H7RSHAL
import XCTest

final class TIMConfigurationTests: XCTestCase {
  func testInitializationForEveryInstanceAndMode() {
    for registered in [false, true] {
      for instance: UInt32 in 0..<14 {
        for op: UInt32 in [0, 8, 16, 24, 32, 38, 103] {
          for state: UInt32 in [0, 1, 2, 4] {
            let p = TIMPair(callbacks: registered)
            p.setup { f in
              f.control(0, instance)
              f.write(.state, value: state)
              f.write(.lock, value: 1)
              f.setConfiguration(
                .init(
                  prescaler: 65535, counterMode: 0x70, period: 0xFEDC_BA98, clockDivision: 0x200,
                  repetitionCounter: 0x1234, autoReloadPreload: 0x80))
              for r in TIMRegister.allCases { f.raw(r, 0xA5A5_5A5A) }
              for i: UInt32 in 0..<16 { f.set(3, i, i &* 3) }
              for id in TIMCallbackID.allCases { f.write(id, value: nil) }
            }
            p.verify(op, 8)
          }
        }
      }
    }
  }
  func testDeinitializationPreservesEnabledOtherChannels() {
    for registered in [false, true] {
      for op: UInt32 in [1, 9, 17, 25, 33, 39, 104] {
        for ccer: UInt32 in [0, 1, 4, 0x1000, 0x4000, 0x10000, 0x40000, 0x5555] {
          let p = TIMPair(callbacks: registered)
          p.setup { f in
            f.raw(.cr1, 0xFFFF_FFFF)
            f.raw(.bdtr, 0xFFFF_FFFF)
            f.raw(.ccer, ccer)
            f.write(.lock, value: 1)
            for id in TIMCallbackID.allCases { f.write(id, value: nil) }
          }
          p.verify(op)
        }
      }
    }
  }
  func testChannelConfigurationOrderAndPartialInvalidInputs() {
    for registered in [false, true] {
      for instance: UInt32 in [0, 1, 5, 11, 12] {
        for op: UInt32 in [47, 48, 49, 50] {
          for channel: UInt32 in [0, 4, 8, 12, 16, 20, 24, 60] {
            for locked: UInt32 in [0, 1] {
              let p = TIMPair(callbacks: registered)
              p.setup { f in
                f.control(0, instance)
                f.write(.lock, value: locked)
                for r in TIMRegister.allCases { f.raw(r, 0xA5A5_5A5A) }
                for i: UInt32 in 0..<16 { f.set(3, i, 0xF0F0_0000 | i &* 0x11) }
              }
              p.verify(op, channel, channel == 0 ? 4 : 0)
            }
          }
        }
      }
    }
  }
  func testClockSourceAndSlaveTriggerBranches() {
    for op: UInt32 in [59, 61, 62, 92] {
      for source: UInt32 in [
        0x1000, 0x4000, 0x8000, 0, 0x10, 0x100070, 0x200020, 0x40, 0x50, 0x60, 0x70, 0x1234,
      ] {
        for mode: UInt32 in [0, 5, 6, 0x10000, 0x10001] {
          let p = TIMPair()
          p.setup { f in
            for r in TIMRegister.allCases { f.raw(r, 0xFFFF_FFFF) }
            f.set(3, 0, op == 59 ? source : mode)
            f.set(3, 1, op == 59 ? 0x8000 : source)
            f.set(3, 2, op == 59 ? 0x3000 : 0xA)
            f.set(3, 3, op == 59 ? 15 : 0x3000)
            f.set(3, 4, 15)
          }
          p.verify(op)
        }
      }
    }
  }
  func testClearInputAndTI1Selection() {
    for channel: UInt32 in [0, 4, 8, 12, 16, 20, 24] {
      for source: UInt32 in [0, 1, 2] {
        for enabled: UInt32 in [0, 1] {
          for prescaler: UInt32 in [0, 0x1000] {
            let p = TIMPair()
            p.setup { f in
              for r in TIMRegister.allCases { f.raw(r, 0xFFFF_FFFF) }
              f.set(3, 0, enabled)
              f.set(3, 1, source)
              f.set(3, 2, 0x8000)
              f.set(3, 3, prescaler)
              f.set(3, 4, 15)
            }
            p.verify(58, channel)
          }
        }
      }
    }
    for selection: UInt32 in [0, 0x80, 0xFFFF_FFFF] {
      let p = TIMPair()
      p.verify(60, selection)
    }
  }
  func testPrivateConfigurationHelpersAcrossCapabilities() {
    for instance: UInt32 in 0..<14 {
      for op: UInt32 in Array(85...91) + Array(93...101) + [161] {
        for channel: UInt32 in [0, 4, 8, 12, 16, 20] {
          let p = TIMPair()
          p.setup { f in
            f.control(0, instance)
            for r in TIMRegister.allCases { f.raw(r, 0x5A5A_A5A5) }
            for i: UInt32 in 0..<16 { f.set(3, i, 0x1234 | i) }
          }
          p.verify(op, channel, 3, 15)
        }
      }
    }
  }
  func testRegisterUnregisterAndCallbackResetStates() {
    for op: UInt32 in [65, 66] {
      for state: UInt32 in [0, 1, 2, 3, 4] {
        for id: UInt32 in 0...33 {
          for callback: UInt32 in [0, 1, 2] {
            let p = TIMPair()
            p.setup { f in
              f.write(.state, value: state)
              f.write(.lock, value: 1)
            }
            p.verify(op, id, callback)
          }
        }
      }
    }
    let p = TIMPair()
    p.setup { f in
      for id in TIMCallbackID.allCases {
        f.write(id, value: unsafeBitCast(CTIM_Callback(id.rawValue, 2), to: TIMCallback.self))
      }
    }
    p.verify(102)
  }
  func testCallbackMutationsAndAllStateQueries() {
    for registered in [false, true] {
      let p = TIMPair(callbacks: registered)
      p.setup { f in
        f.control(20, 1)
        f.control(21, 2)
        f.control(22, 0xDEAD_BEEF)
      }
      p.verify(0)
      for op: UInt32 in Array(67...75) + [155, 156] {
        for channel: UInt32 in [0, 4, 8, 12, 16, 20, 24, 60] { p.verify(op, channel) }
      }
    }
  }
}
