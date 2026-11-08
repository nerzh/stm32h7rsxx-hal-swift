// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USB {
  public func initializeCore(_ configuration: USBConfiguration) -> HALStatus {
    let result: HALStatus
    if registers.isHighSpeedInstance {
      if configuration.phyInterface == 0x3 { modify(.gusbcfg, clear: 0x400000) }
      result = resetCore()
      if configuration.dmaEnable == 1 {
        modify(.gdfifocfg, clear: 0xFFFF << 16)
        modify(.gdfifocfg, set: 0x3EE << 16)
        modify(.gahbcfg, clear: 0x1e)
        modify(.gahbcfg, set: 0x6)
        modify(.gahbcfg, set: 0x20)
      }
    } else {
      modify(.gusbcfg, set: 0x40)
      result = resetCore()
      if configuration.batteryChargingEnable == 0 {
        modify(.gccfg, set: 0x10000)
      } else {
        modify(.gccfg, clear: 0x10000)
      }
    }
    return result
  }
  public func setTurnaroundTime(hclk: UInt32, speed: UInt8) -> HALStatus {
    let turnaround: UInt32
    if speed == 0x2 {
      if hclk >= 14_200_000 && hclk < 15_000_000 {
        turnaround = 15
      } else if hclk >= 15_000_000 && hclk < 16_000_000 {
        turnaround = 14
      } else if hclk >= 16_000_000 && hclk < 17_200_000 {
        turnaround = 13
      } else if hclk >= 17_200_000 && hclk < 18_500_000 {
        turnaround = 12
      } else if hclk >= 18_500_000 && hclk < 20_000_000 {
        turnaround = 11
      } else if hclk >= 20_000_000 && hclk < 21_800_000 {
        turnaround = 10
      } else if hclk >= 21_800_000 && hclk < 24_000_000 {
        turnaround = 9
      } else if hclk >= 24_000_000 && hclk < 27_700_000 {
        turnaround = 8
      } else if hclk >= 27_700_000 && hclk < 32_000_000 {
        turnaround = 7
      } else {
        turnaround = 6
      }
    } else if speed == 0x0 {
      turnaround = highSpeedTurnaround
    } else {
      turnaround = defaultTurnaround
    }
    modify(.gusbcfg, clear: 0x3c00)
    modify(.gusbcfg, set: (turnaround << 10) & 0x3c00)
    return .ok
  }
  public func enableGlobalInterrupt() -> HALStatus {
    modify(.gahbcfg, set: 0x1)
    return .ok
  }
  public func disableGlobalInterrupt() -> HALStatus {
    modify(.gahbcfg, clear: 0x1)
    return .ok
  }
  public func setCurrentMode(_ mode: UInt32, delay: (UInt32) -> Void) -> HALStatus {
    var milliseconds: UInt32 = 0
    modify(.gusbcfg, clear: 0x2000_0000 | 0x4000_0000)
    if mode == 1 {
      modify(.gusbcfg, set: 0x2000_0000)
      repeat {
        delay(10)
        milliseconds &+= 10
      } while getMode() != 1 && milliseconds < currentModeMaximumDelay
    } else if mode == 0 {
      modify(.gusbcfg, set: 0x4000_0000)
      repeat {
        delay(10)
        milliseconds &+= 10
      } while getMode() != 0 && milliseconds < currentModeMaximumDelay
    } else {
      return .error
    }
    if milliseconds == currentModeMaximumDelay { return .error }
    return .ok
  }
  public func flushTransmitFIFO(_ number: UInt32) -> HALStatus {
    var count: UInt32 = 0
    repeat {
      count &+= 1
      if count > pollingTimeout { return .timeout }
    } while registers.read(.grstctl) & 0x8000_0000 == 0
    count = 0
    registers.write(.grstctl, value: 0x20 | (number << 6))
    repeat {
      count &+= 1
      if count > pollingTimeout { return .timeout }
    } while registers.read(.grstctl) & 0x20 == 0x20
    return .ok
  }
  public func flushReceiveFIFO() -> HALStatus {
    var count: UInt32 = 0
    repeat {
      count &+= 1
      if count > pollingTimeout { return .timeout }
    } while registers.read(.grstctl) & 0x8000_0000 == 0
    count = 0
    registers.write(.grstctl, value: 0x10)
    repeat {
      count &+= 1
      if count > pollingTimeout { return .timeout }
    } while registers.read(.grstctl) & 0x10 == 0x10
    return .ok
  }
  func resetCore() -> HALStatus {
    var count: UInt32 = 0
    repeat {
      count &+= 1
      if count > pollingTimeout { return .timeout }
    } while registers.read(.grstctl) & 0x8000_0000 == 0
    registers.delayAfterAHBIdle()
    count = 0
    modify(.grstctl, set: 0x1)
    repeat {
      count &+= 1
      if count > pollingTimeout { return .timeout }
    } while registers.read(.grstctl) & 0x1 == 0x1
    return .ok
  }
  public func readInterrupts() -> UInt32 {
    var value = registers.read(.gintsts)
    value &= registers.read(.gintmsk)
    return value
  }
  public func readChannelInterrupts(_ channel: UInt8) -> UInt32 {
    var value = registers.read(.hcint(UInt32(channel)))
    value &= registers.read(.hcintmsk(UInt32(channel)))
    return value
  }
  public func clearInterrupts(_ interrupts: UInt32) {
    registers.write(.gintsts, value: registers.read(.gintsts) & interrupts)
  }
  public func maskInterrupts(_ interrupts: UInt32) { modify(.gintmsk, clear: interrupts) }
  public func unmaskInterrupts(_ interrupts: UInt32) { modify(.gintmsk, set: interrupts) }
  public func getMode() -> UInt32 { registers.read(.gintsts) & 1 }
  public func writePacket(
    _ source: UnsafePointer<UInt8>?, channelOrEndpoint: UInt8, length: UInt16, dma: UInt8
  ) -> HALStatus {
    if dma == 0 {
      let count = (UInt32(length) &+ 3) / 4
      var i: UInt32 = 0
      var cursor = source
      while i < count {
        registers.write(
          .dfifo(UInt32(channelOrEndpoint)),
          value: UnsafeRawPointer(cursor!).loadUnaligned(as: UInt32.self))
        cursor = cursor! + 1
        cursor = cursor! + 1
        cursor = cursor! + 1
        cursor = cursor! + 1
        i &+= 1
      }
    }
    return .ok
  }
  public func readPacket(_ destination: UnsafeMutablePointer<UInt8>?, length: UInt16)
    -> UnsafeMutablePointer<UInt8>?
  {
    var cursor = destination
    let count = UInt32(length) >> 2
    var remaining = length % 4
    var i: UInt32 = 0
    while i < count {
      UnsafeMutableRawPointer(cursor!).storeBytes(of: registers.read(.dfifo(0)), as: UInt32.self)
      cursor = cursor! + 1
      cursor = cursor! + 1
      cursor = cursor! + 1
      cursor = cursor! + 1
      i &+= 1
    }
    if remaining != 0 {
      i = 0
      let data = registers.read(.dfifo(0))
      repeat {
        cursor!.pointee = UInt8(
          truncatingIfNeeded: data >> (8 &* UInt32(UInt8(truncatingIfNeeded: i))))
        i &+= 1
        cursor = cursor! + 1
        remaining &-= 1
      } while remaining != 0
    }
    return cursor
  }
}
