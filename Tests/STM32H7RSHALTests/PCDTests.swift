import CUSBReference
import STM32H7RSHAL
import XCTest

final class PCDTests: XCTestCase {
  func testLifecycleStateAndLockVariants() {
    for callbacks in [false, true] {
      for hs in [false, true] {
        for state: UInt32 in [0, 1, 2, 3] {
          for locked: UInt32 in [0, 1] {
            for op: UInt32 in [50, 51, 66, 67, 69, 70, 71, 81, 82, 83, 84] {
              let p = PCDPair(highSpeed: hs, callbacks: callbacks)
              p.setup { f in
                f.pcdHandle.write(.state, value: state)
                f.pcdHandle.write(.lock, value: locked)
                f.pcdHandle.writeConfiguration(.dmaEnable, value: 1)
                f.pcdHandle.writeConfiguration(.batteryChargingEnable, value: 1)
                f.write(.gusbcfg, value: 0x40)
                f.write(.gccfg, value: .max)
                f.write(.dsts, value: 1)
                f.write(.dctl, value: .max)
              }
              p.verify(op, 5)
            }
          }
        }
      }
    }
  }
  func testCallbackRegistrationNullInvalidStateAndBusy() {
    for state: UInt32 in [0, 1, 2, 3, 4] {
      for locked: UInt32 in [0, 1] {
        for op: UInt32 in 52...65 {
          for id: UInt32 in [0, 1, 5, 8, 9, 10, 255] {
            for present: UInt32 in [0, 1] {
              let p = PCDPair()
              p.setup { f in
                f.pcdHandle.write(.state, value: state)
                f.pcdHandle.write(.lock, value: locked)
                f.pcdHandle.write(.errorCode, value: 0x80)
              }
              p.verify(op, id, present)
            }
          }
        }
      }
    }
  }
  func testEndpointAPIsRetainPartialChangesWhenLocked() {
    for callbacks in [false, true] {
      for locked: UInt32 in [0, 1] {
        for op: UInt32 in [72, 73, 74, 75, 76, 77, 78, 80] {
          for address: UInt32 in [0, 1, 7, 8, 9, 15, 0x80, 0x81, 0x87, 0x88, 0x89, 0x8F] {
            for dma: UInt8 in [0, 1, 2] {
              let p = PCDPair(callbacks: callbacks)
              p.setup { f in
                f.pcdHandle.write(.lock, value: locked)
                f.pcdHandle.writeConfiguration(.dmaEnable, value: dma)
                f.write(.dieptxf0_hnptxfsiz, value: .max)
              }
              p.verify(op, address, 65, 2)
            }
          }
        }
      }
    }
  }
  func testExtendedFIFOsAndLPM() {
    for op: UInt32 in [88, 89, 90, 91, 93, 94] {
      for fifo: UInt32 in [0, 1, 7, 15] {
        for phy: UInt32 in [0, 0x40] {
          let p = PCDPair()
          p.setup { f in
            f.write(.gusbcfg, value: phy)
            f.write(.gccfg, value: .max)
            f.write(.glpmcfg, value: .max)
            f.write(.gintmsk, value: .max)
            f.write(.grxfsiz, value: 0x1234)
            f.write(.dieptxf0_hnptxfsiz, value: 0x2345_0000)
            for i: UInt32 in 0..<15 { f.write(.dieptxf(i), value: (i + 1) << 16) }
          }
          p.verify(op, fifo, 0xFEDC)
        }
      }
    }
  }
  func testBatteryChargingDetectionCallbacksAndTickWrap() {
    for callbacks in [false, true] {
      for phy: UInt32 in [0, 0x40] {
        for flags: UInt32 in [0, 1, 2, 3, 4, 7, 0x10000, 0x20000, 0x30000, 0xFFFF_FFFF] {
          for tick: UInt32 in [0, 0xFFFF_FF00] {
            for step: UInt32 in [1, 1001] {
              let p = PCDPair(callbacks: callbacks)
              p.setup { f in
                f.control[2] = tick
                f.control[10] = step
                f.write(.gusbcfg, value: phy)
                f.write(.gccfg, value: flags)
                f.pcdHandle.write(.state, value: 1)
              }
              p.verify(92)
            }
          }
        }
      }
    }
  }
  func testIRQPowerResetEnumerationAndConnectionBranches() {
    for callbacks in [false, true] {
      for flag: UInt32 in [
        0, 2, 4, 8, 0x80, 0x400, 0x800, 0x1000, 0x2000, 0x100000, 0x200000, 0x4000_0000,
        0x8000_0000,
      ] {
        for lpm: UInt32 in [0, 1, 2] {
          for dma: UInt8 in [0, 1] {
            let p = PCDPair(callbacks: callbacks)
            p.setup { f in
              f.write(.gintsts, value: flag)
              f.write(.gintmsk, value: .max)
              f.write(.dsts, value: 0x246801)
              f.write(.gotgint, value: 4)
              f.write(.glpmcfg, value: .max)
              f.write(.dctl, value: .max)
              f.pcdHandle.write(.lpmState, value: lpm)
              f.pcdHandle.writeConfiguration(.dmaEnable, value: dma)
              f.pcdHandle.writeConfiguration(.useDedicatedEndpoint1, value: dma)
              for i: UInt32 in 1..<8 {
                f.pcdHandle.endpoint(i, isIn: false).write(.type, value: 1)
                f.pcdHandle.endpoint(i, isIn: false).write(.isIsochronousIncomplete, value: 1)
                f.write(.doepctl(i), value: 0x8000_0000 | (i % 2) << 16)
              }
            }
            p.verify(68)
          }
        }
      }
    }
  }
  func testIRQReceiveFIFOAndSetupData() {
    for callbacks in [false, true] {
      for status: UInt32 in [0, 2, 3, 6] {
        for size: UInt32 in [0, 1, 3, 8, 63, 64] {
          let p = PCDPair(callbacks: callbacks)
          p.setup { f in
            f.write(.gintsts, value: 0x10)
            f.write(.gintmsk, value: .max)
            f.write(.grxstsp, value: 3 | (size << 4) | (status << 17))
            f.write(.dfifo(0), value: 0x1234_5678)
          }
          p.verify(68)
        }
      }
    }
  }
  func testIRQEndpointCompletionDisableAndFIFOEmpty() {
    for callbacks in [false, true] {
      for direction: UInt32 in [0, 1] {
        for dma: UInt8 in [0, 1] {
          for number: UInt32 in [0, 3] {
            for flags: UInt32 in [1, 2, 8, 0x10, 0x20, 0x40, 0x80, 0x1000, 0x2000, 0xFFFF] {
              for core: UInt32 in [0x4F54_300A, 0x4F54_310A, 0x4F54_320A] {
                let p = PCDPair(callbacks: callbacks)
                p.setup { f in
                  f.pcdHandle.writeConfiguration(.dmaEnable, value: dma)
                  f.write(.gintsts, value: direction == 1 ? 0x40000 : 0x80000)
                  f.write(.gintmsk, value: .max)
                  f.write(.daint, value: 1 << (number + (direction == 1 ? 0 : 16)))
                  f.write(.daintmsk, value: .max)
                  f.write(.diepmsk, value: .max)
                  f.write(.doepmsk, value: .max)
                  f.write(.diepempmsk, value: .max)
                  f.write(.gsnpsid, value: core)
                  f.write(.diepint(number), value: flags)
                  f.write(.doepint(number), value: flags)
                  f.write(.dtxfsts(number), value: 0xFFFF)
                  f.write(.doeptsiz(number), value: 7)
                  let ep = f.pcdHandle.endpoint(number, isIn: direction == 1)
                  ep.write(.transferLength, value: 65)
                  ep.write(.transferSize, value: 128)
                  ep.write(.isIsochronousIncomplete, value: 1)
                }
                p.verify(68)
              }
            }
          }
        }
      }
    }
  }
  func testCallbacksCanChangeFollowingInterruptFlagsAndDMA() {
    for callbacks in [false, true] {
      for callback: UInt32 in [2, 3, 5, 6, 10, 11, 14, 15] {
        let p = PCDPair(callbacks: callbacks)
        p.setup { f in
          f.control[20] = callback
          f.control[21] = 0x14
          f.control[22] = 0x4000_0000
          f.control[23] = callback
          f.control[24] = 1
          f.write(
            .gintsts,
            value: callback == 14
              ? 0
              : callback == 15
                ? 0x8000000
                : callback == 10
                  ? 0x80000
                  : callback == 11 || callback == 2
                    ? 0x40000 : callback == 3 ? 0x2000 : callback == 5 ? 0x8000_0000 : 0x4000_0000)
          f.write(.gintmsk, value: .max)
          f.write(.daint, value: 0x10001)
          f.write(.daintmsk, value: .max)
          f.write(.diepmsk, value: 1)
          f.write(.doepmsk, value: 1)
          f.write(.diepint(0), value: 1)
          f.write(.doepint(0), value: 1)
        }
        p.verify(callback == 14 ? 92 : 68)
      }
    }
  }
}
