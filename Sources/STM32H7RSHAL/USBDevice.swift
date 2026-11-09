// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USB {
  public func initializeDevice(_ configuration: USBConfiguration) -> HALStatus {
    var result = HALStatus.ok
    var i: UInt32 = 0
    while i < 15 {
      registers.write(.dieptxf(i), value: 0)
      i &+= 1
    }
    if registers.read(.gusbcfg) & 0x40 == 0 { modify(.gccfg, clear: 0x2000000) }
    if configuration.vbusSensingEnable == 0 {
      modify(.dctl, set: 0x2)
      modify(.gccfg, clear: 0x200000)
      if registers.read(.gusbcfg) & 0x40 != 0 {
        modify(.gotgctl, set: 0x40)
        modify(.gotgctl, set: 0x80)
      } else {
        modify(.gccfg, set: 0x1000000)
        modify(.gccfg, set: 0x800000)
      }
    } else {
      if registers.read(.gusbcfg) & 0x40 != 0 {
        modify(.gotgctl, clear: 0x40)
        modify(.gotgctl, clear: 0x80)
      } else {
        modify(.gccfg, clear: 0x1000000)
        modify(.gccfg, clear: 0x800000)
      }
      modify(.gccfg, set: 0x200000)
    }
    registers.write(.pcgcctl, value: 0)
    if registers.read(.gusbcfg) & 0x40 == 0 {
      _ = setDeviceSpeed(configuration.speed == 0x0 ? 0x0 : 0x1)
    } else {
      _ = setDeviceSpeed(0x3)
    }
    if flushTransmitFIFO(0x10) != .ok { result = .error }
    if flushReceiveFIFO() != .ok { result = .error }
    registers.write(.diepmsk, value: 0)
    registers.write(.doepmsk, value: 0)
    registers.write(.daintmsk, value: 0)
    i = 0
    while i < configuration.deviceEndpoints {
      if registers.read(.diepctl(i)) & 0x8000_0000 == 0x8000_0000 {
        if i == 0 {
          registers.write(.diepctl(i), value: 0x8000000)
        } else {
          registers.write(.diepctl(i), value: 0x4000_0000 | 0x8000000)
        }
      } else {
        registers.write(.diepctl(i), value: 0)
      }
      registers.write(.dieptsiz(i), value: 0)
      registers.write(.diepint(i), value: 0xFB7F)
      i &+= 1
    }
    i = 0
    while i < configuration.deviceEndpoints {
      if registers.read(.doepctl(i)) & 0x8000_0000 == 0x8000_0000 {
        if i == 0 {
          registers.write(.doepctl(i), value: 0x8000000)
        } else {
          registers.write(.doepctl(i), value: 0x4000_0000 | 0x8000000)
        }
      } else {
        registers.write(.doepctl(i), value: 0)
      }
      registers.write(.doeptsiz(i), value: 0)
      registers.write(.doepint(i), value: 0xFB7F)
      i &+= 1
    }
    modify(.diepmsk, clear: 0x100)
    registers.write(.gintmsk, value: 0)
    registers.write(.gintsts, value: 0xBFFF_FFFF)
    if configuration.dmaEnable == 0 { modify(.gintmsk, set: 0x10) }
    modify(
      .gintmsk, set: 0x800 | 0x1000 | 0x2000 | 0x40000 | 0x80000 | 0x100000 | 0x200000 | 0x8000_0000
    )
    if configuration.sofEnable != 0 { modify(.gintmsk, set: 0x8) }
    if configuration.vbusSensingEnable == 1 { modify(.gintmsk, set: 0x4000_0000 | 0x4) }
    return result
  }
  public func setDeviceSpeed(_ speed: UInt8) -> HALStatus {
    modify(.dcfg, set: UInt32(speed))
    return .ok
  }
  public func getDeviceSpeed() -> UInt8 {
    let speed = registers.read(.dsts) & 0x6
    if speed == 0x0 { return 0x0 }
    if speed == 0x2 || speed == 0x6 { return 0x2 }
    return 15
  }
  public func stopDevice() -> HALStatus {
    var i: UInt32 = 0
    while i < 15 {
      registers.write(.diepint(i), value: 0xFB7F)
      registers.write(.doepint(i), value: 0xFB7F)
      i &+= 1
    }
    registers.write(.diepmsk, value: 0)
    registers.write(.doepmsk, value: 0)
    registers.write(.daintmsk, value: 0)
    let result = flushReceiveFIFO()
    if result != .ok { return result }
    return flushTransmitFIFO(0x10)
  }
  public func setDeviceAddress(_ address: UInt8) -> HALStatus {
    modify(.dcfg, clear: 0x7f0)
    modify(.dcfg, set: (UInt32(address) << 4) & 0x7f0)
    return .ok
  }
  public func connectDevice() -> HALStatus {
    modify(.pcgcctl, clear: 0x1 | 0x2)
    modify(.dctl, clear: 0x2)
    return .ok
  }
  public func disconnectDevice() -> HALStatus {
    modify(.pcgcctl, clear: 0x1 | 0x2)
    modify(.dctl, set: 0x2)
    return .ok
  }
  public func readAllOutEndpointInterrupts() -> UInt32 {
    var value = registers.read(.daint)
    value &= registers.read(.daintmsk)
    return (value & 0xFFFF_0000) >> 16
  }
  public func readAllInEndpointInterrupts() -> UInt32 {
    var value = registers.read(.daint)
    value &= registers.read(.daintmsk)
    return value & 0xFFFF
  }
  public func readOutEndpointInterrupts(_ endpoint: UInt8) -> UInt32 {
    var value = registers.read(.doepint(UInt32(endpoint)))
    value &= registers.read(.doepmsk)
    return value
  }
  public func readInEndpointInterrupts(_ endpoint: UInt8) -> UInt32 {
    var mask = registers.read(.diepmsk)
    let empty = registers.read(.diepempmsk)
    mask |= ((empty >> (endpoint & 0xf)) & 1) << 7
    return registers.read(.diepint(UInt32(endpoint))) & mask
  }
  public func activateSetup() -> HALStatus {
    modify(.diepctl(0), clear: 0x7ff)
    modify(.dctl, set: 0x100)
    return .ok
  }
  public func startEndpoint0Out(dma: UInt8, setup: UnsafePointer<UInt8>?) -> HALStatus {
    let coreID = registers.read(.gsnpsid)
    if coreID > 0x4f54_300a {
      if registers.read(.doepctl(0)) & 0x8000_0000 == 0x8000_0000 { return .ok }
    }
    registers.write(.doeptsiz(0), value: 0)
    modify(.doeptsiz(0), set: 0x1ff8_0000 & (1 << 19))
    modify(.doeptsiz(0), set: 3 * 8)
    modify(.doeptsiz(0), set: 0x6000_0000)
    if dma == 1 {
      registers.write(.doepdma(0), value: UInt32(truncatingIfNeeded: UInt(bitPattern: setup)))
      modify(.doepctl(0), set: 0x8000_0000 | 0x8000)
    }
    return .ok
  }
  public func activateRemoteWakeup() -> HALStatus {
    if registers.read(.dsts) & 0x1 == 0x1 { modify(.dctl, set: 0x1) }
    return .ok
  }
  public func deactivateRemoteWakeup() -> HALStatus {
    modify(.dctl, clear: 0x1)
    return .ok
  }
  public func clearInEndpointInterrupts(_ endpoint: UInt32, _ interrupts: UInt32) {
    registers.write(.diepint(endpoint), value: interrupts)
  }
  public func clearOutEndpointInterrupts(_ endpoint: UInt32, _ interrupts: UInt32) {
    registers.write(.doepint(endpoint), value: interrupts)
  }
}
