// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USB {
  public func startHostChannelTransfer<Channel: USBHostChannelIO>(_ channel: Channel, dma: UInt8)
    -> HALStatus
  {
    let index = channel.read(.channelNumber)
    var packetCount: UInt16
    if registers.isHighSpeedInstance {
      if dma == 1 {
        if (channel.read(.endpointType) == 0x0 || channel.read(.endpointType) == 0x2)
          && channel.read(.doStartSplit) == 0
        {
          modify(.hcintmsk(index), clear: 0x40 | 0x20 | 0x10)
        }
      } else {
        if channel.read(.speed) == 0x0 && channel.read(.doPing) == 1 {
          _ = doPing(UInt8(truncatingIfNeeded: channel.read(.channelNumber)))
          return .ok
        }
      }
    }
    if channel.read(.doStartSplit) == 1 {
      packetCount = 1
      if channel.read(.endpointIsIn) != 0 {
        channel.write(.transferSize, value: UInt32(packetCount) &* channel.read(.maximumPacketSize))
      } else {
        if channel.read(.endpointType) == 0x1 {
          if channel.read(.transferLength) > 0xbc {
            channel.write(.transferSize, value: channel.read(.maximumPacketSize))
            channel.write(.transferLength, value: channel.read(.transferSize))
            if channel.read(.isochronousSplitTransactionPosition) == 0x1
              || channel.read(.isochronousSplitTransactionPosition) == 0x2
            {
              channel.write(.isochronousSplitTransactionPosition, value: 0x2)
            } else {
              channel.write(.isochronousSplitTransactionPosition, value: 0x1)
            }
          } else {
            channel.write(.transferSize, value: channel.read(.transferLength))
            if channel.read(.isochronousSplitTransactionPosition) != 0x1
              && channel.read(.isochronousSplitTransactionPosition) != 0x2
            {
              channel.write(.isochronousSplitTransactionPosition, value: 0x4)
            } else {
              channel.write(.isochronousSplitTransactionPosition, value: 0x3)
            }
          }
        } else {
          if dma == 1 && channel.read(.transferLength) > channel.read(.maximumPacketSize) {
            channel.write(
              .transferSize, value: UInt32(packetCount) &* channel.read(.maximumPacketSize))
          } else {
            channel.write(.transferSize, value: channel.read(.transferLength))
          }
        }
      }
    } else {
      if channel.read(.transferLength) > 0 {
        packetCount = UInt16(
          truncatingIfNeeded: (channel.read(.transferLength) &+ channel.read(.maximumPacketSize)
            &- 1) / channel.read(.maximumPacketSize))
        if packetCount > 0x100 {
          packetCount = 0x100
          channel.write(
            .transferSize, value: UInt32(packetCount) &* channel.read(.maximumPacketSize))
        }
      } else {
        packetCount = 1
      }
      if channel.read(.endpointIsIn) != 0 {
        channel.write(.transferSize, value: UInt32(packetCount) &* channel.read(.maximumPacketSize))
      } else {
        channel.write(.transferSize, value: channel.read(.transferLength))
      }
    }
    registers.write(
      .hctsiz(index),
      value: (channel.read(.transferSize) & 0x7ffff) | ((UInt32(packetCount) << 19) & 0x1ff8_0000)
        | ((channel.read(.dataPID) << 29) & 0x6000_0000))
    if dma != 0 {
      registers.write(
        .hcdma(index), value: UInt32(truncatingIfNeeded: UInt(bitPattern: channel.readBuffer())))
    }
    let oddFrame: UInt8 = registers.read(.hfnum) & 1 != 0 ? 0 : 1
    modify(.hcchar(index), clear: 0x2000_0000)
    modify(.hcchar(index), set: UInt32(oddFrame) << 29)
    if channel.read(.doStartSplit) == 1 {
      registers.write(
        .hcsplt(index),
        value: (channel.read(.hubAddress) << 0x7) | channel.read(.hubPortNumber) | 0x8000_0000)
      modify(.hcintmsk(index), set: 0x20 | 0x40)
      if channel.read(.doCompleteSplit) == 1 && channel.read(.endpointIsIn) == 0 {
        modify(.hcsplt(index), set: 0x10000)
        modify(.hcintmsk(index), set: 0x40)
      }
      if (channel.read(.endpointType) == 0x1 || channel.read(.endpointType) == 0x3)
        && channel.read(.doCompleteSplit) == 1 && channel.read(.endpointIsIn) == 1
      {
        modify(.hcsplt(index), set: 0x10000)
      }
      if channel.read(.endpointType) == 0x1 && channel.read(.endpointIsIn) == 0 {
        switch channel.read(.isochronousSplitTransactionPosition) {
        case 0x1: modify(.hcsplt(index), set: 0x8000)
        case 0x2: modify(.hcsplt(index), set: 0xe)
        case 0x3: modify(.hcsplt(index), set: 0x4000)
        case 0x4: modify(.hcsplt(index), set: 0xc000)
        default: break
        }
      }
    } else {
      registers.write(.hcsplt(index), value: 0)
    }
    var value = registers.read(.hcchar(index))
    value &= ~0x4000_0000
    if channel.read(.endpointIsIn) != 0 { value |= 0x8000 } else { value &= ~0x8000 }
    value |= 0x8000_0000
    registers.write(.hcchar(index), value: value)
    if dma != 0 { return .ok }
    if channel.read(.endpointIsIn) == 0 && channel.read(.transferLength) > 0
      && channel.read(.doCompleteSplit) == 0
    {
      switch channel.read(.endpointType) {
      case 0x0, 0x2:
        let length = UInt16(truncatingIfNeeded: (channel.read(.transferLength) &+ 3) / 4)
        if length > registers.read(.hnptxsts) & 0xFFFF { modify(.gintmsk, set: 0x20) }
      case 0x3, 0x1:
        let length = UInt16(truncatingIfNeeded: (channel.read(.transferLength) &+ 3) / 4)
        if length > registers.read(.hptxsts) & 0xFFFF { modify(.gintmsk, set: 0x4000000) }
      default: break
      }
      _ = writePacket(
        channel.readBuffer().map { UnsafePointer($0) },
        channelOrEndpoint: UInt8(truncatingIfNeeded: channel.read(.channelNumber)),
        length: UInt16(truncatingIfNeeded: channel.read(.transferLength)), dma: 0)
    }
    return .ok
  }
}
