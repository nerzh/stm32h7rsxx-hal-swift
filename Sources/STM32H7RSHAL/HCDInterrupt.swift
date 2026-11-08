// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HCD {
  public func enable() { _ = usb.enableGlobalInterrupt() }
  public func disable() { _ = usb.disableGlobalInterrupt() }
  public func getFlag(_ flag: UInt32) -> Bool { usb.readInterrupts() & flag == flag }
  public func getChannelFlag(_ channel: UInt8, _ flag: UInt32) -> Bool {
    usb.readChannelInterrupts(channel) & flag == flag
  }
  public func clearFlag(_ flag: UInt32) { usb.registers.write(.gintsts, value: flag) }
  public func isInvalidInterrupt() -> Bool { usb.readInterrupts() == 0 }
  public func clearChannelInterrupt(_ channel: UInt8, _ flag: UInt32) {
    usb.registers.write(.hcint(UInt32(channel)), value: flag)
  }
  public func maskHaltInterrupt(_ channel: UInt8) {
    usb.modify(.hcintmsk(UInt32(channel)), clear: 0x2)
  }
  public func unmaskHaltInterrupt(_ channel: UInt8) {
    usb.modify(.hcintmsk(UInt32(channel)), set: 0x2)
  }
  public func maskAcknowledgeInterrupt(_ channel: UInt8) {
    usb.modify(.hcintmsk(UInt32(channel)), clear: 0x20)
  }
  public func unmaskAcknowledgeInterrupt(_ channel: UInt8) {
    usb.modify(.hcintmsk(UInt32(channel)), set: 0x20)
  }
  public func setCompleteSplit(_ channel: UInt8) {
    usb.modify(.hcsplt(UInt32(channel)), set: 0x10000)
  }
  public func clearCompleteSplit(_ channel: UInt8) {
    usb.modify(.hcsplt(UInt32(channel)), clear: 0x10000)
  }
  public func clearStartSplit(_ channel: UInt8) {
    usb.modify(.hcsplt(UInt32(channel)), clear: 0x8000_0000)
  }
  public func handleInterrupt() {
    if usb.getMode() != 0x1 { return }
    if isInvalidInterrupt() { return }
    if getFlag(0x200000) { clearFlag(0x200000) }
    if getFlag(0x100000) { clearFlag(0x100000) }
    if getFlag(0x4000000) { clearFlag(0x4000000) }
    if getFlag(0x2) { clearFlag(0x2) }
    if getFlag(0x2000_0000) {
      clearFlag(0x2000_0000)
      if usb.registers.read(.hprt0) & 0x1 == 0 {
        _ = usb.flushTransmitFIFO(0x10)
        _ = usb.flushReceiveFIFO()
        if handle.readConfiguration(.phyInterface) == 0x2 {
          _ = usb.initializeFullLowSpeedClock(0x1)
        }
        invoke(.disconnect)
      }
    }
    if getFlag(0x1000000) { handlePortInterrupt() }
    if getFlag(0x8) {
      invoke(.startOfFrame)
      clearFlag(0x8)
    }
    if getFlag(0x2000000) {
      let interrupts = usb.readHostChannelInterrupts()
      var i: UInt32 = 0
      while i < handle.readConfiguration(.hostChannels) {
        if interrupts & (1 << (i & 15)) != 0 {
          if usb.registers.read(.hcchar(i)) & 0x8000 == 0x8000 {
            handleInChannelInterrupt(UInt8(truncatingIfNeeded: i))
          } else {
            handleOutChannelInterrupt(UInt8(truncatingIfNeeded: i))
          }
        }
        i &+= 1
      }
      clearFlag(0x2000000)
    }
    if getFlag(0x10) {
      usb.maskInterrupts(0x10)
      handleReceiveQueueInterrupt()
      usb.unmaskInterrupts(0x10)
    }
  }
  func handleReceiveQueueInterrupt() {
    let status = usb.registers.read(.grxstsp)
    let number = status & 0xf
    let packetStatus = (status & 0x1e0000) >> 17
    let count = (status & 0x7ff0) >> 4
    let h = handle.channel(number)
    switch packetStatus {
    case 0x2:
      if count > 0 && h.readBuffer() != nil {
        if h.read(.transferCount) &+ count <= h.read(.transferLength) {
          _ = usb.readPacket(h.readBuffer(), length: UInt16(truncatingIfNeeded: count))
          h.writeBuffer(
            UnsafeMutablePointer<UInt8>(bitPattern: UInt(bitPattern: h.readBuffer()) &+ UInt(count))
          )
          h.write(.transferCount, value: h.read(.transferCount) &+ count)
          let packets = (usb.registers.read(.hctsiz(number)) & 0x1ff8_0000) >> 19
          if h.read(.maximumPacketSize) == count && packets > 0 {
            var value = usb.registers.read(.hcchar(number))
            value &= ~0x4000_0000
            value |= 0x8000_0000
            usb.registers.write(.hcchar(number), value: value)
            h.write(.toggleIn, value: h.read(.toggleIn) ^ 1)
          }
        } else {
          h.write(.urbState, value: 0x4)
        }
      }
    default: break
    }
  }
  func handlePortInterrupt() {
    let value = usb.registers.read(.hprt0)
    var duplicate = usb.registers.read(.hprt0)
    duplicate &= ~(0x4 | 0x2 | 0x8 | 0x20)
    if value & 0x2 == 0x2 {
      if value & 0x1 == 0x1 { invoke(.connect) }
      duplicate |= 0x2
    }
    if value & 0x8 == 0x8 {
      duplicate |= 0x8
      if value & 0x4 == 0x4 {
        if handle.readConfiguration(.phyInterface) == 0x2 {
          if value & 0x60000 == 0x2 << 17 {
            _ = usb.initializeFullLowSpeedClock(0x2)
          } else {
            _ = usb.initializeFullLowSpeedClock(0x1)
          }
        } else {
          if handle.readConfiguration(.speed) == 0x1 { usb.registers.write(.hfir, value: 0xea60) }
        }
        invoke(.portEnabled)
      } else {
        invoke(.portDisabled)
      }
    }
    if value & 0x20 == 0x20 { duplicate |= 0x20 }
    usb.registers.write(.hprt0, value: duplicate)
  }
}
