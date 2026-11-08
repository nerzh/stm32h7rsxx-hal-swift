// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USB {
  public func initializeHost(_ configuration: USBConfiguration) -> HALStatus {
    var result = HALStatus.ok
    if registers.read(.gusbcfg) & 0x40 == 0 { modify(.gccfg, set: 0x2000000) }
    registers.write(.pcgcctl, value: 0)
    if registers.read(.gusbcfg) & 0x40 == 0 { modify(.gccfg, clear: 0x800000 | 0x1000000) }
    modify(.gccfg, clear: 0x200000)
    if registers.read(.gusbcfg) & 0x40 != 0 {
      modify(.gccfg, clear: 0x20000)
    } else {
      modify(.gccfg, clear: 0x80000)
      modify(.gccfg, clear: 0x100000)
    }
    if registers.read(.gusbcfg) & 0x40 == 0 {
      if configuration.speed == 0x1 { modify(.hcfg, set: 0x4) } else { modify(.hcfg, clear: 0x4) }
    } else {
      modify(.hcfg, clear: 0x4)
    }
    if flushTransmitFIFO(0x10) != .ok { result = .error }
    if flushReceiveFIFO() != .ok { result = .error }
    var i: UInt32 = 0
    while i < configuration.hostChannels {
      registers.write(.hcint(i), value: 0xffff_ffff)
      registers.write(.hcintmsk(i), value: 0)
      i &+= 1
    }
    registers.write(.gintmsk, value: 0)
    registers.write(.gintsts, value: 0xffff_ffff)
    if registers.isHighSpeedInstance {
      registers.write(.grxfsiz, value: 0x200)
      registers.write(.dieptxf0_hnptxfsiz, value: ((0x100 << 16) & 0xffff_0000) | 0x200)
      registers.write(.hptxfsiz, value: ((0xE0 << 16) & 0xffff_0000) | 0x300)
    } else {
      registers.write(.grxfsiz, value: 0x80)
      registers.write(.dieptxf0_hnptxfsiz, value: ((0x60 << 16) & 0xffff_0000) | 0x80)
      registers.write(.hptxfsiz, value: ((0x40 << 16) & 0xffff_0000) | 0xE0)
    }
    if configuration.dmaEnable == 0 { modify(.gintmsk, set: 0x10) }
    modify(.gintmsk, set: 0x1000000 | 0x2000000 | 0x8 | 0x2000_0000 | 0x200000 | 0x8000_0000)
    return result
  }
  public func initializeFullLowSpeedClock(_ frequency: UInt8) -> HALStatus {
    modify(.hcfg, clear: 0x3)
    modify(.hcfg, set: UInt32(frequency) & 0x3)
    if frequency == 0x1 {
      registers.write(.hfir, value: 0xbb80)
    } else if frequency == 0x2 {
      registers.write(.hfir, value: 0x1770)
    } else {
      return .error
    }
    return .ok
  }
  public func resetPort(delay: (UInt32) -> Void) -> HALStatus {
    var value = registers.read(.hprt0)
    value &= ~(0x4 | 0x2 | 0x8 | 0x20)
    registers.write(.hprt0, value: 0x100 | value)
    delay(100)
    registers.write(.hprt0, value: ~0x100 & value)
    delay(10)
    return .ok
  }
  public func driveVBUS(_ state: UInt8) -> HALStatus {
    var value = registers.read(.hprt0)
    value &= ~(0x4 | 0x2 | 0x8 | 0x20)
    if value & 0x1000 == 0 && state == 1 { registers.write(.hprt0, value: 0x1000 | value) }
    if value & 0x1000 == 0x1000 && state == 0 { registers.write(.hprt0, value: ~0x1000 & value) }
    return .ok
  }
  public func getHostSpeed() -> UInt32 { (registers.read(.hprt0) & 0x60000) >> 17 }
  public func getCurrentFrame() -> UInt32 { registers.read(.hfnum) & 0xffff }
  public func initializeHostChannel(
    _ channel: UInt8, endpoint: UInt8, deviceAddress: UInt8, speed: UInt8, type: UInt8,
    maximumPacketSize: UInt16
  ) -> HALStatus {
    var result = HALStatus.ok
    let index = UInt32(channel)
    registers.write(.hcint(index), value: 0xffff_ffff)
    switch type {
    case 0x0, 0x2:
      registers.write(.hcintmsk(index), value: 0x1 | 0x8 | 0x80 | 0x400 | 0x4 | 0x10)
      if endpoint & 0x80 == 0x80 {
        modify(.hcintmsk(index), set: 0x100)
      } else {
        if registers.isHighSpeedInstance { modify(.hcintmsk(index), set: 0x40 | 0x20) }
      }
    case 0x3:
      registers.write(.hcintmsk(index), value: 0x1 | 0x8 | 0x80 | 0x400 | 0x10 | 0x4 | 0x200)
      if endpoint & 0x80 == 0x80 { modify(.hcintmsk(index), set: 0x100) }
    case 0x1:
      registers.write(.hcintmsk(index), value: 0x1 | 0x20 | 0x4 | 0x200)
      if endpoint & 0x80 == 0x80 { modify(.hcintmsk(index), set: 0x80 | 0x100) }
    default: result = .error
    }
    registers.write(.hcsplt(index), value: 0)
    modify(.hcintmsk(index), set: 0x2)
    modify(.haintmsk, set: 1 << (channel & 0xF))
    modify(.gintmsk, set: 0x2000000)
    let direction: UInt32 = endpoint & 0x80 == 0x80 ? (1 << 15) & 0x8000 : 0
    let coreSpeed = getHostSpeed()
    let lowSpeed: UInt32 = speed == 0x2 && coreSpeed != 0x2 ? (1 << 17) & 0x20000 : 0
    registers.write(
      .hcchar(index),
      value: ((UInt32(deviceAddress) << 22) & 0x1fc0_0000)
        | (((UInt32(endpoint) & 0x7F) << 11) & 0x7800) | ((UInt32(type) << 18) & 0xc0000)
        | (UInt32(maximumPacketSize) & 0x7ff) | 0x100000 | direction | lowSpeed)
    if type == 0x3 || type == 0x1 { modify(.hcchar(index), set: 0x2000_0000) }
    return result
  }
  public func readHostChannelInterrupts() -> UInt32 { registers.read(.haint) & 0xFFFF }
  public func haltHostChannel(_ channel: UInt8) -> HALStatus {
    let index = UInt32(channel)
    var count: UInt32 = 0
    let type = (registers.read(.hcchar(index)) & 0xc0000) >> 18
    let enabled = (registers.read(.hcchar(index)) & 0x8000_0000) >> 31
    let split = (registers.read(.hcsplt(index)) & 0x8000_0000) >> 31
    if registers.read(.gahbcfg) & 0x20 == 0x20 && split == 0
      && (enabled == 0 || type == 0x1 || type == 0x3)
    {
      return .ok
    }
    if type == 0x0 || type == 0x2 {
      modify(.hcchar(index), set: 0x4000_0000)
      if registers.read(.gahbcfg) & 0x20 == 0 {
        if registers.read(.hnptxsts) & (0xFF << 16) == 0 {
          modify(.hcchar(index), clear: 0x8000_0000)
          modify(.hcchar(index), set: 0x8000_0000)
          repeat {
            count &+= 1
            if count > 1000 { break }
          } while registers.read(.hcchar(index)) & 0x8000_0000 == 0x8000_0000
        } else {
          modify(.hcchar(index), set: 0x8000_0000)
        }
      } else {
        modify(.hcchar(index), set: 0x8000_0000)
      }
    } else {
      modify(.hcchar(index), set: 0x4000_0000)
      if registers.read(.hptxsts) & (0xFF << 16) == 0 {
        modify(.hcchar(index), clear: 0x8000_0000)
        modify(.hcchar(index), set: 0x8000_0000)
        repeat {
          count &+= 1
          if count > 1000 { break }
        } while registers.read(.hcchar(index)) & 0x8000_0000 == 0x8000_0000
      } else {
        modify(.hcchar(index), set: 0x8000_0000)
      }
    }
    return .ok
  }
  public func activateHostChannel(_ channel: UInt8, direction: UInt8) -> HALStatus {
    var value = registers.read(.hcchar(UInt32(channel)))
    if value & 0x4000_0000 == 0 {
      value |= 0x8000_0000
      registers.write(.hcchar(UInt32(channel)), value: value)
    }
    return .ok
  }
  public func doPing(_ channel: UInt8) -> HALStatus {
    let index = UInt32(channel)
    let packetCount: UInt32 = 1
    registers.write(.hctsiz(index), value: ((packetCount << 19) & 0x1ff8_0000) | 0x8000_0000)
    var value = registers.read(.hcchar(index))
    value &= ~0x4000_0000
    value |= 0x8000_0000
    registers.write(.hcchar(index), value: value)
    return .ok
  }
  public func stopHost() -> HALStatus {
    var result = HALStatus.ok
    var count: UInt32 = 0
    _ = disableGlobalInterrupt()
    if flushTransmitFIFO(0x10) != .ok { result = .error }
    if flushReceiveFIFO() != .ok { result = .error }
    var i: UInt32 = 0
    while i <= 15 {
      var value = registers.read(.hcchar(i))
      value |= 0x4000_0000
      value &= ~0x8000_0000
      value &= ~0x8000
      registers.write(.hcchar(i), value: value)
      i &+= 1
    }
    i = 0
    while i <= 15 {
      var value = registers.read(.hcchar(i))
      value |= 0x4000_0000
      value |= 0x8000_0000
      value &= ~0x8000
      registers.write(.hcchar(i), value: value)
      repeat {
        count &+= 1
        if count > 1000 { break }
      } while registers.read(.hcchar(i)) & 0x8000_0000 == 0x8000_0000
      i &+= 1
    }
    registers.write(.haint, value: 0xffff_ffff)
    registers.write(.gintsts, value: 0xffff_ffff)
    _ = enableGlobalInterrupt()
    return result
  }
}
