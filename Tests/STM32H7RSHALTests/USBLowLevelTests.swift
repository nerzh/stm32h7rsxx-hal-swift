import CUSBReference
import STM32H7RSHAL
import XCTest

final class USBLowLevelTests: XCTestCase {
  func testTurnaroundThresholdsAndSpeedValues() {
    for frequency: UInt32 in [
      0, 14_199_999, 14_200_000, 14_999_999, 15_000_000, 15_999_999, 16_000_000, 17_199_999,
      17_200_000, 18_499_999, 18_500_000, 19_999_999, 20_000_000, 21_799_999, 21_800_000,
      23_999_999, 24_000_000, 27_699_999, 27_700_000, 31_999_999, 32_000_000, .max,
    ] {
      for speed: UInt32 in [0, 1, 2, 3, 15, 255] {
        let p = USBPair()
        p.setup { $0.write(.gusbcfg, value: 0xA5A5_A5A5) }
        p.verify(1, frequency, speed)
      }
    }
  }
  func testCoreInitializationKeepsWritesAfterResetTimeout() {
    for hs in [false, true] {
      for phy: UInt32 in [1, 2, 3] {
        for dma: UInt32 in [0, 1, 2] {
          for battery: UInt32 in [0, 1] {
            for reset: UInt32 in [0, 0x8000_0000] {
              let p = USBPair(highSpeed: hs)
              p.setup { f in
                CUSB_SetConfiguration(f.state, 5, phy)
                CUSB_SetConfiguration(f.state, 2, dma)
                CUSB_SetConfiguration(f.state, 9, battery)
                f.write(.grstctl, value: reset)
                f.write(.gusbcfg, value: .max)
                f.write(.gdfifocfg, value: .max)
                f.write(.gahbcfg, value: .max)
                f.write(.gccfg, value: .max)
              }
              p.verify(0)
            }
          }
        }
      }
    }
  }
  func testDeviceAndHostInitializationBothPHYsDMAAndSensing() {
    for op: UInt32 in [5, 35] {
      for hs in [false, true] {
        for phy: UInt32 in [0, 0x40] {
          for dma: UInt32 in [0, 1] {
            for sense: UInt32 in [0, 1, 2] {
              for speed: UInt32 in [0, 1, 3] {
                let p = USBPair(highSpeed: hs)
                p.setup { f in
                  CUSB_SetConfiguration(f.state, 2, dma)
                  CUSB_SetConfiguration(f.state, 3, speed)
                  CUSB_SetConfiguration(f.state, 6, 1)
                  CUSB_SetConfiguration(f.state, 10, sense)
                  f.write(.gusbcfg, value: phy)
                  f.write(.gccfg, value: .max)
                  f.write(.grstctl, value: 0x8000_0000)
                  for i: UInt32 in 0..<16 {
                    f.write(.diepctl(i), value: i % 2 == 0 ? 0x8000_0000 : 0)
                    f.write(.doepctl(i), value: i % 2 == 0 ? 0x8000_0000 : 0)
                  }
                }
                p.verify(op)
              }
            }
          }
        }
      }
    }
  }
  func testModeDelayBoundariesAndInvalidModePartialWrite() {
    for mode: UInt32 in [0, 1, 2, 255] {
      for initial: UInt32 in [0, 1] {
        for transition: UInt32 in [0, 1, 19, 20] {
          let p = USBPair()
          p.setup { f in
            f.write(.gusbcfg, value: .max)
            f.write(.gintsts, value: initial)
            f.control[3] = transition
            f.control[4] = mode
          }
          p.verify(4, mode)
        }
      }
    }
  }
  func testEndpointConfigurationActivationStallAndDeactivation() {
    for op: UInt32 in [10, 11, 12, 13, 16, 17] {
      for direction: UInt32 in [0, 1, 2] {
        for number: UInt32 in [0, 1, 7, 15] {
          for type: UInt32 in [0, 1, 2, 3] {
            let p = USBPair()
            p.setup { f in
              f.endpoint.write(.number, value: number)
              f.endpoint.write(.isIn, value: direction)
              f.endpoint.write(.type, value: type)
              f.endpoint.write(.maximumPacketSize, value: 0xFEDC)
              f.write(.diepctl(number), value: number % 2 == 0 ? 0xA5A5_A5A5 : 0)
              f.write(.doepctl(number), value: number % 2 == 0 ? 0xA5A5_A5A5 : 0)
              f.write(.daintmsk, value: .max)
              f.write(.deachmsk, value: .max)
            }
            p.verify(op)
          }
        }
      }
    }
  }
  func testEndpointTransfersZeroShortMultipleAndTruncatingPacketCounts() {
    for direction: UInt32 in [0, 1] {
      for number: UInt32 in [0, 1, 7] {
        for type: UInt32 in [0, 1, 2, 3] {
          for dma: UInt32 in [0, 1, 2] {
            for length: UInt32 in [0, 1, 63, 64, 65, 129, 0xFFFF_FFE0] {
              // Non-DMA isochronous writes require a readable source buffer.
              if direction == 1 && type == 1 && dma != 1 && length > 4096 { continue }
              let p = USBPair()
              p.setup { f in
                f.endpoint.write(.number, value: number)
                f.endpoint.write(.isIn, value: direction)
                f.endpoint.write(.type, value: type)
                f.endpoint.write(.transferLength, value: length)
                f.endpoint.write(.transferSize, value: 0xA5A5)
                f.endpoint.write(.dmaAddress, value: 0x2400_3000)
                f.write(.dieptsiz(number), value: .max)
                f.write(.doeptsiz(number), value: .max)
                f.write(.dsts, value: length & 1 == 0 ? 0x100 : 0)
                for i in 0..<4096 { f.buffer[i] = UInt8(truncatingIfNeeded: i) }
              }
              p.verify(14, dma)
            }
          }
        }
      }
    }
  }
  func testUnalignedFIFOPacketsAndTailBytes() {
    for op: UInt32 in [18, 19] {
      for offset: UInt32 in [0, 1, 2, 3] {
        for length: UInt32 in [0, 1, 2, 3, 4, 5, 7, 8, 9, 63, 64, 65] {
          let p = USBPair()
          p.setup { f in
            f.write(.dfifo(0), value: 0xA1B2_C3D4)
            for i in 0..<4096 { f.buffer[i] = UInt8(truncatingIfNeeded: i &* 7 &+ 11) }
          }
          p.verify(op, 7, length, offset)
        }
      }
    }
  }
  func testEndpointStopSuccessAndTimeoutContinuation() {
    for direction: UInt32 in [0, 1] {
      for dma: UInt32 in [0, 1] {
        for ready in [false, true] {
          let p = USBPair()
          p.setup { f in
            f.endpoint.write(.number, value: 2)
            f.endpoint.write(.isIn, value: direction)
            f.write(.gahbcfg, value: dma << 5)
            f.write(.gintmsk, value: .max)
            f.write(.gintsts, value: ready ? 0xA0 : 0)
            f.write(.doepint(2), value: ready ? 2 : 0)
            f.write(.diepctl(2), value: ready ? 0 : 0x8000_0000)
          }
          p.verify(15)
        }
      }
    }
  }
  func testSimpleHelpersMasksAndReservedBits() {
    for op: UInt32 in [
      2, 3, 6, 7, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 36, 37, 38, 39, 40,
      43, 45, 46, 47, 48, 49,
    ] {
      for value: UInt32 in [0, 1, 2, 3, 0xFFFF_FFFF] {
        let p = USBPair()
        p.setup { f in
          for i in 0..<0x400 { CUSB_Registers(f.state)![i] = value }
          f.write(.grstctl, value: value & 0x8000_0000)
          f.write(.gsnpsid, value: value == 0 ? 0x4F54_300A : 0x4F54_310A)
        }
        p.verify(op, op == 8 || op == 21 || op == 30 || op == 36 || op == 38 ? value : 1, 2, 4)
      }
    }
  }
  func testHostChannelInitializationTypesSpeedsDirections() {
    for hs in [false, true] {
      for type: UInt32 in [0, 1, 2, 3, 4, 255] {
        for speed: UInt32 in [0, 1, 2, 3] {
          for endpoint: UInt32 in [0, 3, 0x83, 0xFF] {
            let p = USBPair(highSpeed: hs)
            p.setup { f in
              f.control[5] = speed
              f.control[6] = type
              f.control[7] = 0xFEDC
              f.write(.hcintmsk(7), value: 0xA5A5_A5A5)
              f.write(.hprt0, value: 0x20000)
            }
            p.verify(41, 7, endpoint, 0xFF)
          }
        }
      }
    }
  }
  func testHostChannelSplitPingDMAAndTransferLength() {
    for hs in [false, true] {
      for type: UInt32 in [0, 1, 2, 3] {
        for direction: UInt32 in [0, 1] {
          for dma: UInt32 in [0, 1, 2] {
            for split: UInt32 in [0, 1] {
              for complete: UInt32 in [0, 1] {
                for length: UInt32 in [0, 65, 189, 513, 0x10001] {
                  if dma == 0 && direction == 0 && complete == 0 && length > 4096 { continue }
                  let p = USBPair(highSpeed: hs)
                  p.setup { f in
                    let h = f.channel
                    h.write(.channelNumber, value: 3)
                    h.write(.endpointType, value: type)
                    h.write(.endpointIsIn, value: direction)
                    h.write(.doStartSplit, value: split)
                    h.write(.doCompleteSplit, value: complete)
                    h.write(.transferLength, value: length)
                    h.write(.isochronousSplitTransactionPosition, value: length % 5)
                    h.write(.hubAddress, value: 4)
                    h.write(.hubPortNumber, value: 7)
                    h.write(.dataPID, value: 2)
                    f.write(.hcintmsk(3), value: .max)
                    f.write(.hcchar(3), value: .max)
                    f.write(.hfnum, value: length & 1)
                  }
                  p.verify(42, dma)
                }
              }
            }
          }
        }
      }
    }
    for dma: UInt32 in [0, 1, 2] {
      let p = USBPair()
      p.setup { $0.channel.write(.doPing, value: 1) }
      p.verify(42, dma)
    }
  }
  func testHostHaltDMAEarlyReturnAndQueueAvailability() {
    for type: UInt32 in [0, 1, 2, 3] {
      for dma: UInt32 in [0, 1] {
        for split: UInt32 in [0, 1] {
          for enabled: UInt32 in [0, 1] {
            for queue: UInt32 in [0, 0x10000] {
              let p = USBPair()
              p.setup { f in
                f.write(.gahbcfg, value: dma << 5)
                f.write(.hcchar(3), value: (type << 18) | (enabled << 31))
                f.write(.hcsplt(3), value: split << 31)
                f.write(.hnptxsts, value: queue)
                f.write(.hptxsts, value: queue)
              }
              p.verify(44, 3)
            }
          }
        }
      }
    }
  }
}
