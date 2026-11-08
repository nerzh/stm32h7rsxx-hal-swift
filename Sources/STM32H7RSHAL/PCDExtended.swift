// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PCD {
  public func setTransmitFIFO(_ fifo: UInt8, size: UInt16) -> HALStatus {
    var offset = usb.registers.read(.grxfsiz)
    if fifo == 0 {
      usb.registers.write(.dieptxf0_hnptxfsiz, value: (UInt32(size) << 16) | offset)
    } else {
      offset &+= usb.registers.read(.dieptxf0_hnptxfsiz) >> 16
      var i: UInt8 = 0
      while UInt32(i) < UInt32(fifo) &- 1 {
        offset &+= usb.registers.read(.dieptxf(UInt32(i))) >> 16
        i &+= 1
      }
      usb.registers.write(.dieptxf(UInt32(fifo) &- 1), value: (UInt32(size) << 16) | offset)
    }
    return .ok
  }
  public func setReceiveFIFO(size: UInt16) -> HALStatus {
    usb.registers.write(.grxfsiz, value: UInt32(size))
    return .ok
  }
  public func activateLPM() -> HALStatus {
    handle.write(.lpmActive, value: 1)
    handle.write(.lpmState, value: 0)
    usb.modify(.gintmsk, set: 0x8000000)
    usb.modify(.glpmcfg, set: 0x1 | 0x2 | 0x1000_0000)
    return .ok
  }
  public func deactivateLPM() -> HALStatus {
    handle.write(.lpmActive, value: 0)
    usb.modify(.gintmsk, clear: 0x8000000)
    usb.modify(.glpmcfg, clear: 0x1 | 0x2 | 0x1000_0000)
    return .ok
  }
  public func detectBatteryChargingVBUS(getTick: () -> UInt32, delay: (UInt32) -> Void) {
    let start = getTick()
    var mask: UInt32
    if usb.registers.read(.gusbcfg) & 0x40 != 0 {
      usb.modify(.gccfg, set: 0x40000)
    } else {
      usb.modify(.gccfg, set: 0x80000)
    }
    delay(300)
    if usb.registers.read(.gusbcfg) & 0x40 != 0 {
      if usb.registers.read(.gccfg) & 0x1 == 0x1 { invoke(.batteryCharging, 0xfe) }
    }
    if usb.registers.read(.gusbcfg) & 0x40 != 0 {
      usb.modify(.gccfg, clear: 0x40000)
      delay(50)
      usb.modify(.gccfg, set: 0x80000)
    } else {
      usb.modify(.gccfg, clear: 0x80000)
      delay(50)
      usb.modify(.gccfg, set: 0x100000)
    }
    delay(50)
    if usb.registers.read(.gusbcfg) & 0x40 != 0 { mask = 0x2 } else { mask = 0x1 }
    if usb.registers.read(.gccfg) & mask == 0 {
      invoke(.batteryCharging, 0xfd)
    } else {
      if usb.registers.read(.gusbcfg) & 0x40 != 0 {
        usb.modify(.gccfg, clear: 0x80000)
        delay(50)
        usb.modify(.gccfg, set: 0x100000)
        delay(50)
        mask = 0x4
      } else {
        usb.modify(.gccfg, clear: 0x100000)
        delay(50)
        usb.modify(.gccfg, set: 0x400000)
        delay(50)
        mask = 0x2
      }
      if usb.registers.read(.gccfg) & mask == mask {
        invoke(.batteryCharging, 0xfb)
      } else {
        invoke(.batteryCharging, 0xfc)
      }
    }
    _ = deactivateBatteryCharging()
    if getTick() &- start > 1000 {
      invoke(.batteryCharging, 0xff)
    } else {
      invoke(.batteryCharging, 0x0)
    }
  }
  public func activateBatteryCharging() -> HALStatus {
    if usb.registers.read(.gusbcfg) & 0x40 != 0 {
      usb.modify(.gccfg, clear: 0x80000)
      usb.modify(.gccfg, clear: 0x100000)
      usb.modify(.gccfg, clear: 0x10000)
      usb.modify(.gccfg, set: 0x20000)
    } else {
      usb.modify(.gccfg, clear: 0x100000)
      usb.modify(.gccfg, clear: 0x400000)
    }
    handle.write(.batteryChargingActive, value: 1)
    return .ok
  }
  public func deactivateBatteryCharging() -> HALStatus {
    if usb.registers.read(.gusbcfg) & 0x40 != 0 {
      usb.modify(.gccfg, clear: 0x80000)
      usb.modify(.gccfg, clear: 0x100000)
      usb.modify(.gccfg, clear: 0x20000)
    } else {
      usb.modify(.gccfg, clear: 0x100000)
      usb.modify(.gccfg, clear: 0x400000)
    }
    handle.write(.batteryChargingActive, value: 0)
    return .ok
  }
}
