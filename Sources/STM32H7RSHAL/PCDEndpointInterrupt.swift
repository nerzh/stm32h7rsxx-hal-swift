// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PCD {
  func advanceBuffer(_ endpoint: Handle.Endpoint, by count: UInt32) {
    endpoint.writeBuffer(
      UnsafeMutablePointer<UInt8>(
        bitPattern: UInt(bitPattern: endpoint.readBuffer()) &+ UInt(count)))
  }
  func writeEmptyTransmitFIFO(_ number: UInt32) -> HALStatus {
    let ep = handle.endpoint(number, isIn: true)
    if ep.read(.transferCount) > ep.read(.transferLength) { return .error }
    var length = ep.read(.transferLength) &- ep.read(.transferCount)
    if length > ep.read(.maximumPacketSize) { length = ep.read(.maximumPacketSize) }
    var words = (length &+ 3) / 4
    while usb.registers.read(.dtxfsts(number)) & 0xffff >= words
      && ep.read(.transferCount) < ep.read(.transferLength) && ep.read(.transferLength) != 0
    {
      length = ep.read(.transferLength) &- ep.read(.transferCount)
      if length > ep.read(.maximumPacketSize) { length = ep.read(.maximumPacketSize) }
      words = (length &+ 3) / 4
      _ = usb.writePacket(
        ep.readBuffer().map { UnsafePointer($0) },
        channelOrEndpoint: UInt8(truncatingIfNeeded: number),
        length: UInt16(truncatingIfNeeded: length), dma: handle.readConfiguration(.dmaEnable))
      advanceBuffer(ep, by: length)
      ep.write(.transferCount, value: ep.read(.transferCount) &+ length)
    }
    if ep.read(.transferLength) <= ep.read(.transferCount) {
      usb.modify(.diepempmsk, clear: 1 << (number & 15))
    }
    return .ok
  }
  func outTransferComplete(_ number: UInt32) -> HALStatus {
    let coreID = usb.registers.read(.gsnpsid)
    let interrupt = usb.registers.read(.doepint(number))
    if handle.readConfiguration(.dmaEnable) == 1 {
      if interrupt & 0x8 == 0x8 {
        if coreID > 0x4f54_300a && interrupt & 0x8000 == 0x8000 {
          usb.registers.write(.doepint(number), value: 0x8000)
        }
      } else if interrupt & 0x20 == 0x20 {
        usb.registers.write(.doepint(number), value: 0x20)
      } else if interrupt & (0x8 | 0x20) == 0 {
        if coreID > 0x4f54_300a && interrupt & 0x8000 == 0x8000 {
          usb.registers.write(.doepint(number), value: 0x8000)
        } else {
          let ep = handle.endpoint(number, isIn: false)
          ep.write(
            .transferCount,
            value: ep.read(.transferSize) &- (usb.registers.read(.doeptsiz(number)) & 0x7ffff))
          if number == 0 {
            if ep.read(.transferLength) == 0 {
              _ = usb.startEndpoint0Out(dma: 1, setup: handle.setupBuffer())
            } else {
              advanceBuffer(ep, by: ep.read(.transferCount))
            }
          }
          invoke(.dataOut, UInt8(truncatingIfNeeded: number))
        }
      }
    } else {
      if coreID == 0x4f54_310a {
        if interrupt & 0x8000 == 0x8000 {
          usb.registers.write(.doepint(number), value: 0x8000)
        } else {
          if interrupt & 0x20 == 0x20 { usb.registers.write(.doepint(number), value: 0x20) }
          invoke(.dataOut, UInt8(truncatingIfNeeded: number))
        }
      } else {
        if number == 0 && handle.endpoint(number, isIn: false).read(.transferLength) == 0 {
          _ = usb.startEndpoint0Out(dma: 0, setup: handle.setupBuffer())
        }
        invoke(.dataOut, UInt8(truncatingIfNeeded: number))
      }
    }
    return .ok
  }
  func outSetupPacket(_ number: UInt32) -> HALStatus {
    let coreID = usb.registers.read(.gsnpsid)
    let interrupt = usb.registers.read(.doepint(number))
    if coreID > 0x4f54_300a && interrupt & 0x8000 == 0x8000 {
      usb.registers.write(.doepint(number), value: 0x8000)
    }
    invoke(.setupStage)
    if coreID > 0x4f54_300a && handle.readConfiguration(.dmaEnable) == 1 {
      _ = usb.startEndpoint0Out(dma: 1, setup: handle.setupBuffer())
    }
    return .ok
  }
}
