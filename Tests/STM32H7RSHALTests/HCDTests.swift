import CUSBReference
import STM32H7RSHAL
import XCTest

final class HCDTests: XCTestCase {
  func testLifecycleAndCallbacks() {
    for callbacks in [false, true] {
      for hs in [false, true] {
        for state: UInt32 in [0, 1, 2, 3, 4] {
          for lock: UInt32 in [0, 1] {
            for op: UInt32 in [95, 97, 98, 105, 106, 107, 108, 109, 110, 111, 112, 113, 116] {
              let p = HCDPair(highSpeed: hs, callbacks: callbacks)
              p.setup { f in
                f.hcdHandle.write(.state, value: state)
                f.hcdHandle.write(.lock, value: lock)
                f.hcdHandle.writeConfiguration(.dmaEnable, value: 1)
                f.write(.gahbcfg, value: .max)
                f.write(.hcchar(3), value: 0x8000_0000)
                f.write(.hprt0, value: .max)
              }
              p.verify(op, 3)
            }
          }
        }
      }
    }
  }
  func testCallbackRegistration() {
    for callbacks in [false, true] {
      for state: UInt32 in [0, 1, 2, 3] {
        for lock: UInt32 in [0, 1] {
          for id: UInt32 in 0...9 {
            for op: UInt32 in 101...104 {
              for present: UInt32 in [0, 1] {
                let p = HCDPair(callbacks: callbacks)
                p.setup {
                  $0.hcdHandle.write(.state, value: state)
                  $0.hcdHandle.write(.lock, value: lock)
                  $0.hcdHandle.write(.errorCode, value: 0x80)
                }
                p.verify(op, id, present)
              }
            }
          }
        }
      }
    }
  }
  func testChannelInitializationAndHubState() {
    for lock: UInt32 in [0, 1] {
      for type: UInt32 in [0, 1, 2, 3, 4] {
        for speed: UInt32 in [0, 1, 2] {
          for coreSpeed: UInt32 in [0, 1, 2] {
            for endpoint: UInt32 in [3, 0x83] {
              for mps: UInt32 in [0, 64, 188, 189, 512, 0xFFFF] {
                let p = HCDPair()
                p.setup { f in
                  f.hcdHandle.write(.lock, value: lock)
                  f.control[5] = speed
                  f.control[6] = type
                  f.control[7] = mps
                  f.write(.hprt0, value: coreSpeed << 17)
                  let h = f.hcdHandle.channel(3)
                  h.write(.doStartSplit, value: 1)
                  h.write(.doCompleteSplit, value: 1)
                  h.write(.hubAddress, value: 8)
                  h.write(.toggleIn, value: 0)
                }
                p.verify(96, 3, endpoint, 0xFA)
                p.verify(114, 3, 0xE1, 0xD2)
                p.verify(115, 3)
              }
            }
          }
        }
      }
    }
  }
  func testSubmitRequestPIDDirectionSplitAndPing() {
    for hs in [false, true] {
      for type: UInt32 in [0, 1, 2, 3, 4] {
        for direction: UInt32 in [0, 1] {
          for token: UInt32 in [0, 1, 2] {
            for toggle: UInt32 in [0, 1] {
              for split: UInt32 in [0, 1] {
                for length: UInt32 in [0, 65, 189] {
                  for dma: UInt8 in [0, 1, 2] {
                    let p = HCDPair(highSpeed: hs)
                    p.setup { f in
                      f.hcdHandle.writeConfiguration(.dmaEnable, value: dma)
                      f.control[15] = token
                      f.control[16] = length
                      f.control[17] = toggle
                      let h = f.hcdHandle.channel(3)
                      h.write(.toggleIn, value: toggle)
                      h.write(.toggleOut, value: toggle)
                      h.write(.doStartSplit, value: split)
                      h.write(.hubAddress, value: 7)
                      h.write(.hubPortNumber, value: 2)
                    }
                    p.verify(99, 3, direction, type)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  func testChannelInterruptFlagsPriorityAndDMA() {
    for callbacks in [false, true] {
      for direction: UInt32 in [0, 1] {
        for type: UInt32 in [0, 1, 2, 3] {
          for dma: UInt8 in [0, 1, 2] {
            for flag: UInt32 in [0, 1, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200, 0x400, 0xFFFF] {
              for split: UInt32 in [0, 1] {
                let p = HCDPair(callbacks: callbacks)
                p.setup { f in
                  f.hcdHandle.writeConfiguration(.dmaEnable, value: dma)
                  f.write(.gintsts, value: 0x2000001)
                  f.write(.gintmsk, value: .max)
                  f.write(.haint, value: 8)
                  f.write(.hcint(3), value: flag)
                  f.write(.hcintmsk(3), value: .max)
                  f.write(.hcchar(3), value: direction << 15)
                  f.write(.hctsiz(3), value: 7)
                  let h = f.hcdHandle.channel(3)
                  h.write(.endpointType, value: type)
                  h.write(.doStartSplit, value: split)
                  h.write(.doCompleteSplit, value: split)
                  h.write(.doPing, value: split)
                  h.write(.transferSize, value: 128)
                  h.write(.transferLength, value: 65)
                  h.write(.errorCount, value: 2)
                }
                p.verify(100)
              }
            }
          }
        }
      }
    }
  }
  func testHaltedChannelStatesErrorCountsAndNAKAutoActivation() {
    for callbacks in [false, true] {
      for nak in [false, true] {
        for direction: UInt32 in [0, 1] {
          for type: UInt32 in [0, 1, 2, 3] {
            for dma: UInt8 in [0, 1] {
              for state: UInt32 in 0...10 {
                for count: UInt32 in [0, 1, 2, 3, 0xFFFF_FFFF] {
                  for split: UInt32 in [0, 1] {
                    let p = HCDPair(callbacks: callbacks, disableNAKAutoActivate: nak)
                    p.setup { f in
                      f.hcdHandle.writeConfiguration(.dmaEnable, value: dma)
                      f.write(.gintsts, value: 0x2000001)
                      f.write(.gintmsk, value: .max)
                      f.write(.haint, value: 8)
                      f.write(.hcint(3), value: 2)
                      f.write(.hcintmsk(3), value: .max)
                      f.write(.hcchar(3), value: direction << 15)
                      let h = f.hcdHandle.channel(3)
                      h.write(.state, value: state)
                      h.write(.endpointType, value: type)
                      h.write(.errorCount, value: count)
                      h.write(.nyetErrorCount, value: count)
                      h.write(.nakCount, value: count)
                      h.write(.doStartSplit, value: split)
                      h.write(.doCompleteSplit, value: split)
                      h.write(.transferLength, value: 65)
                    }
                    p.verify(100)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  func testPortSpeedConnectionAndEnableChanges() {
    for callbacks in [false, true] {
      for phy: UInt8 in [1, 2, 3] {
        for speed: UInt8 in [0, 1, 3] {
          for status: UInt32 in [0, 1, 2, 3, 4, 8, 12, 15, 0x20, 0x2F, 0x4000F] {
            let p = HCDPair(callbacks: callbacks)
            p.setup { f in
              f.hcdHandle.writeConfiguration(.phyInterface, value: phy)
              f.hcdHandle.writeConfiguration(.speed, value: speed)
              f.write(.gintsts, value: 0x1000001)
              f.write(.gintmsk, value: .max)
              f.write(.hprt0, value: status)
            }
            p.verify(100)
          }
        }
      }
    }
  }
  func testReceiveQueueBoundsAndPacketToggle() {
    for status: UInt32 in [0, 2, 3, 5, 7] {
      for size: UInt32 in [0, 1, 3, 64, 65] {
        for transferred: UInt32 in [0, 1, 64, 0xFFFF_FFF0] {
          for hasBuffer in [false, true] {
            let p = HCDPair()
            p.setup { f in
              f.write(.gintsts, value: 0x11)
              f.write(.gintmsk, value: .max)
              f.write(.grxstsp, value: 3 | (size << 4) | (status << 17))
              f.write(.dfifo(0), value: 0x1234_5678)
              f.write(.hctsiz(3), value: 1 << 19)
              let h = f.hcdHandle.channel(3)
              h.write(.transferLength, value: 65)
              h.write(.transferCount, value: transferred)
              if !hasBuffer { h.writeBuffer(nil) }
            }
            p.verify(100)
          }
        }
      }
    }
  }
  func testGlobalInterruptsAndCallbackDrivenChanges() {
    for callbacks in [false, true] {
      for flag: UInt32 in [1, 3, 9, 0x20, 0x100001, 0x200001, 0x4000001, 0x1000001] {
        for connected: UInt32 in [0, 1] {
          let p = HCDPair(callbacks: callbacks)
          p.setup { f in
            f.write(.gintsts, value: flag)
            f.write(.gintmsk, value: .max)
            f.write(.hprt0, value: connected | 0xE)
            f.hcdHandle.writeConfiguration(.phyInterface, value: 2)
            f.control[20] = 2
            f.control[21] = 0x14
            f.control[22] = 9
            f.control[23] = 4
            f.control[24] = 1
          }
          p.verify(100)
        }
      }
    }
  }
}
