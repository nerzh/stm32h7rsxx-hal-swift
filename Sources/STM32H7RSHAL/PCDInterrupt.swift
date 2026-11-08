// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PCD {
  public func getFlag(_ flag: UInt32) -> Bool { usb.readInterrupts() & flag == flag }
  public func clearFlag(_ flag: UInt32) { usb.clearInterrupts(flag) }
  public func isInvalidInterrupt() -> Bool { usb.readInterrupts() == 0 }
  public func enable() { _ = usb.enableGlobalInterrupt() }
  public func disable() { _ = usb.disableGlobalInterrupt() }
  public func ungatePHYClock() { usb.modify(.pcgcctl, clear: 0x1) }
  public func gatePHYClock() { usb.modify(.pcgcctl, set: 0x1) }
  public func isPHYSuspended() -> UInt32 { usb.registers.read(.pcgcctl) & 0x10 }
  public func handleInterrupt(getHCLKFrequency: () -> UInt32) {
    if usb.getMode() != 0x0 { return }
    if isInvalidInterrupt() { return }
    handle.write(.frameNumber, value: (usb.registers.read(.dsts) & 0x3fff00) >> 0x8)
    if getFlag(0x2) { clearFlag(0x2) }
    if getFlag(0x10) {
      usb.maskInterrupts(0x10)
      let value = usb.registers.read(.grxstsp)
      let ep = handle.endpoint(value & 0xf, isIn: false)
      if (value & 0x1e0000) >> 17 == 0x2 {
        if value & 0x7ff0 != 0 {
          _ = usb.readPacket(
            ep.readBuffer(), length: UInt16(truncatingIfNeeded: (value & 0x7ff0) >> 4))
          advanceBuffer(ep, by: (value & 0x7ff0) >> 4)
          ep.write(.transferCount, value: ep.read(.transferCount) &+ ((value & 0x7ff0) >> 4))
        }
      } else if (value & 0x1e0000) >> 17 == 0x6 {
        _ = usb.readPacket(handle.setupBuffer(), length: 8)
        ep.write(.transferCount, value: ep.read(.transferCount) &+ ((value & 0x7ff0) >> 4))
      }
      usb.unmaskInterrupts(0x10)
    }
    if getFlag(0x80000) {
      var number: UInt32 = 0
      var endpoints = usb.readAllOutEndpointInterrupts()
      while endpoints != 0 {
        if endpoints & 1 != 0 {
          let flags = usb.readOutEndpointInterrupts(UInt8(truncatingIfNeeded: number))
          if flags & 0x1 == 0x1 {
            usb.registers.write(.doepint(number), value: 0x1)
            _ = outTransferComplete(number)
          }
          if flags & 0x8 == 0x8 {
            usb.registers.write(.doepint(number), value: 0x8)
            _ = outSetupPacket(number)
          }
          if flags & 0x10 == 0x10 { usb.registers.write(.doepint(number), value: 0x10) }
          if flags & 0x2 == 0x2 {
            if usb.registers.read(.gintsts) & 0x80 == 0x80 { usb.modify(.dctl, set: 0x400) }
            let ep = handle.endpoint(number, isIn: false)
            if ep.read(.isIsochronousIncomplete) == 1 {
              ep.write(.isIsochronousIncomplete, value: 0)
              invoke(.isochronousOutIncomplete, UInt8(truncatingIfNeeded: number))
            }
            usb.registers.write(.doepint(number), value: 0x2)
          }
          if flags & 0x20 == 0x20 { usb.registers.write(.doepint(number), value: 0x20) }
          if flags & 0x2000 == 0x2000 { usb.registers.write(.doepint(number), value: 0x2000) }
        }
        number &+= 1
        endpoints >>= 1
      }
    }
    if getFlag(0x40000) {
      var endpoints = usb.readAllInEndpointInterrupts()
      var number: UInt32 = 0
      while endpoints != 0 {
        if endpoints & 1 != 0 {
          let flags = usb.readInEndpointInterrupts(UInt8(truncatingIfNeeded: number))
          if flags & 0x1 == 0x1 {
            usb.modify(.diepempmsk, clear: 1 << (number & 15))
            usb.registers.write(.diepint(number), value: 0x1)
            if handle.readConfiguration(.dmaEnable) == 1 {
              let ep = handle.endpoint(number, isIn: true)
              advanceBuffer(ep, by: ep.read(.maximumPacketSize))
              if number == 0 && handle.endpoint(number, isIn: true).read(.transferLength) == 0 {
                _ = usb.startEndpoint0Out(dma: 1, setup: handle.setupBuffer())
              }
            }
            invoke(.dataIn, UInt8(truncatingIfNeeded: number))
          }
          if flags & 0x8 == 0x8 { usb.registers.write(.diepint(number), value: 0x8) }
          if flags & 0x10 == 0x10 { usb.registers.write(.diepint(number), value: 0x10) }
          if flags & 0x40 == 0x40 { usb.registers.write(.diepint(number), value: 0x40) }
          if flags & 0x2 == 0x2 {
            _ = usb.flushTransmitFIFO(number)
            let ep = handle.endpoint(number, isIn: true)
            if ep.read(.isIsochronousIncomplete) == 1 {
              ep.write(.isIsochronousIncomplete, value: 0)
              invoke(.isochronousInIncomplete, UInt8(truncatingIfNeeded: number))
            }
            usb.registers.write(.diepint(number), value: 0x2)
          }
          if flags & 0x80 == 0x80 { _ = writeEmptyTransmitFIFO(number) }
        }
        number &+= 1
        endpoints >>= 1
      }
    }
    if getFlag(0x8000_0000) {
      usb.modify(.dctl, clear: 0x1)
      if handle.read(.lpmState) == 1 {
        handle.write(.lpmState, value: 0)
        invoke(.linkPowerManagement, 0x0)
      } else {
        invoke(.resume)
      }
      clearFlag(0x8000_0000)
    }
    if getFlag(0x800) {
      if usb.registers.read(.dsts) & 0x1 == 0x1 { invoke(.suspend) }
      clearFlag(0x800)
    }
    if getFlag(0x8000000) {
      clearFlag(0x8000000)
      if handle.read(.lpmState) == 0 {
        handle.write(.lpmState, value: 1)
        handle.write(.besl, value: (usb.registers.read(.glpmcfg) & 0x3c) >> 2)
        invoke(.linkPowerManagement, 0x1)
      } else {
        invoke(.suspend)
      }
    }
    if getFlag(0x1000) {
      usb.modify(.dctl, clear: 0x1)
      _ = usb.flushTransmitFIFO(0x10)
      var i: UInt32 = 0
      while i < handle.readConfiguration(.deviceEndpoints) {
        usb.registers.write(.diepint(i), value: 0xFB7F)
        usb.modify(.diepctl(i), clear: 0x200000)
        usb.registers.write(.doepint(i), value: 0xFB7F)
        usb.modify(.doepctl(i), clear: 0x200000)
        usb.modify(.doepctl(i), set: 0x8000000)
        i &+= 1
      }
      usb.modify(.daintmsk, set: 0x10001)
      if handle.readConfiguration(.useDedicatedEndpoint1) != 0 {
        usb.modify(.doutep1msk, set: 0x8 | 0x1 | 0x2)
        usb.modify(.dinep1msk, set: 0x8 | 0x1 | 0x2)
      } else {
        usb.modify(.doepmsk, set: 0x8 | 0x1 | 0x2 | 0x20 | 0x2000)
        usb.modify(.diepmsk, set: 0x8 | 0x1 | 0x2)
      }
      usb.modify(.dcfg, clear: 0x7f0)
      _ = usb.startEndpoint0Out(
        dma: handle.readConfiguration(.dmaEnable), setup: handle.setupBuffer())
      clearFlag(0x1000)
    }
    if getFlag(0x2000) {
      _ = usb.activateSetup()
      handle.writeConfiguration(.speed, value: usb.getDeviceSpeed())
      _ = usb.setTurnaroundTime(hclk: getHCLKFrequency(), speed: handle.readConfiguration(.speed))
      invoke(.reset)
      clearFlag(0x2000)
    }
    if getFlag(0x8) {
      invoke(.startOfFrame)
      clearFlag(0x8)
    }
    if getFlag(0x80) {
      usb.modify(.gintmsk, clear: 0x80)
      var number: UInt32 = 1
      while number < handle.readConfiguration(.deviceEndpoints) {
        if handle.endpoint(number, isIn: false).read(.isIsochronousIncomplete) == 1 {
          usb.modify(.doepctl(number), set: 0x8000000)
          usb.modify(.doepctl(number), set: 0x4000_0000)
        }
        number &+= 1
      }
    }
    if getFlag(0x100000) {
      var number: UInt32 = 1
      while number < handle.readConfiguration(.deviceEndpoints) {
        let value = usb.registers.read(.diepctl(number))
        if handle.endpoint(number, isIn: true).read(.type) == 0x1
          && value & 0x8000_0000 == 0x8000_0000
        {
          handle.endpoint(number, isIn: true).write(.isIsochronousIncomplete, value: 1)
          _ = abortEndpoint(UInt8(truncatingIfNeeded: number | 0x80))
        }
        number &+= 1
      }
      clearFlag(0x100000)
    }
    if getFlag(0x200000) {
      var number: UInt32 = 1
      while number < handle.readConfiguration(.deviceEndpoints) {
        let value = usb.registers.read(.doepctl(number))
        if handle.endpoint(number, isIn: false).read(.type) == 0x1
          && value & 0x8000_0000 == 0x8000_0000
          && (value & (1 << 16)) >> 16 == handle.read(.frameNumber) & 1
        {
          handle.endpoint(number, isIn: false).write(.isIsochronousIncomplete, value: 1)
          usb.modify(.gintmsk, set: 0x80)
          if usb.registers.read(.gintsts) & 0x80 == 0 {
            usb.modify(.dctl, set: 0x200)
            break
          }
        }
        number &+= 1
      }
      clearFlag(0x200000)
    }
    if getFlag(0x4000_0000) {
      invoke(.connect)
      clearFlag(0x4000_0000)
    }
    if getFlag(0x4) {
      let value = usb.registers.read(.gotgint)
      if value & 0x4 == 0x4 { invoke(.disconnect) }
      usb.modify(.gotgint, set: value)
    }
  }
}
