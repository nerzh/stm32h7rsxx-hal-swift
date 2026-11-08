// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HCD {
  func handleOutChannelInterrupt(_ channelNumber: UInt8) {
    let chnum = UInt32(channelNumber)
    let h = handle.channel(chnum)

    var tmpreg: UInt32
    var num_packets: UInt32
    if getChannelFlag(channelNumber, 0x4) {
      clearChannelInterrupt(channelNumber, 0x4)
      h.write(.state, value: 0x7)
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x20) {
      clearChannelInterrupt(channelNumber, 0x20)
      if h.read(.doPing) == 1 {
        h.write(.doPing, value: 0)
        h.write(.urbState, value: 0x2)
        h.write(.state, value: 0x3)
        _ = usb.haltHostChannel(channelNumber)
      }
      if (h.read(.doStartSplit) == 1) && (h.read(.doCompleteSplit) == 0) {
        if h.read(.endpointType) != 0x1 {
          h.write(.doCompleteSplit, value: 1)
        }
        h.write(.state, value: 0x3)
        _ = usb.haltHostChannel(channelNumber)
        h.write(.errorCount, value: 0)
      }
    } else if getChannelFlag(channelNumber, 0x200) {
      clearChannelInterrupt(channelNumber, 0x200)
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x1) {
      h.write(.errorCount, value: 0)
      if getChannelFlag(channelNumber, 0x40) {
        h.write(.doPing, value: 1)
        clearChannelInterrupt(channelNumber, 0x40)
      }
      if h.read(.doCompleteSplit) != 0 {
        h.write(.doCompleteSplit, value: 0)
        clearCompleteSplit(channelNumber)
      }
      clearChannelInterrupt(channelNumber, 0x1)
      h.write(.state, value: 0x1)
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x40) {
      h.write(.state, value: 0x5)
      if h.read(.doStartSplit) == 0 {
        h.write(.doPing, value: 1)
      }
      h.write(.errorCount, value: 0)
      _ = usb.haltHostChannel(channelNumber)
      clearChannelInterrupt(channelNumber, 0x40)
    } else if getChannelFlag(channelNumber, 0x8) {
      clearChannelInterrupt(channelNumber, 0x8)
      h.write(.state, value: 0x6)
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x10) {
      h.write(.errorCount, value: 0)
      h.write(.state, value: 0x4)
      if h.read(.doPing) == 0 {
        if h.read(.speed) == 0x0 {
          h.write(.doPing, value: 1)
        }
      }
      _ = usb.haltHostChannel(channelNumber)
      clearChannelInterrupt(channelNumber, 0x10)
    } else if getChannelFlag(channelNumber, 0x80) {
      if handle.readConfiguration(.dmaEnable) == 0 {
        h.write(.state, value: 0x7)
        _ = usb.haltHostChannel(channelNumber)
      } else {
        h.write(.errorCount, value: h.read(.errorCount) &+ 1)
        if h.read(.errorCount) > 2 {
          h.write(.errorCount, value: 0)
          h.write(.urbState, value: 0x4)
          invokeURB(channelNumber, h.read(.urbState))
        } else {
          h.write(.urbState, value: 0x2)
          tmpreg = usb.registers.read(.hcchar(chnum))
          tmpreg &= ~0x4000_0000
          tmpreg |= 0x8000_0000
          usb.registers.write(.hcchar(chnum), value: tmpreg)
        }
      }
      clearChannelInterrupt(channelNumber, 0x80)
    } else if getChannelFlag(channelNumber, 0x400) {
      h.write(.state, value: 0x9)
      _ = usb.haltHostChannel(channelNumber)
      clearChannelInterrupt(channelNumber, 0x400)
    } else if getChannelFlag(channelNumber, 0x2) {
      clearChannelInterrupt(channelNumber, 0x2)
      if h.read(.state) == 0x1 {
        h.write(.state, value: 0x2)
        h.write(.urbState, value: 0x1)
        if h.read(.endpointType) != 0x1 {
          if handle.readConfiguration(.dmaEnable) == 0 {
            h.write(.toggleOut, value: h.read(.toggleOut) ^ (1))
          }
          if (handle.readConfiguration(.dmaEnable) == 1) && (h.read(.transferLength) > 0) {
            num_packets =
              (h.read(.transferLength) &+ h.read(.maximumPacketSize) &- 1)
              / h.read(.maximumPacketSize)
            if (num_packets & 1) != 0 {
              h.write(.toggleOut, value: h.read(.toggleOut) ^ (1))
            }
          }
        }
      } else if h.read(.state) == 0x3 {
        h.write(.state, value: 0x2)
        if h.read(.doCompleteSplit) == 1 {
          h.write(.urbState, value: 0x2)
        }
      } else if h.read(.state) == 0x4 {
        h.write(.state, value: 0x2)
        h.write(.urbState, value: 0x2)
        if h.read(.doCompleteSplit) == 1 {
          h.write(.doCompleteSplit, value: 0)
          clearCompleteSplit(channelNumber)
        }
      } else if h.read(.state) == 0x5 {
        h.write(.state, value: 0x2)
        h.write(.urbState, value: 0x2)
      } else if h.read(.state) == 0x6 {
        h.write(.state, value: 0x2)
        h.write(.urbState, value: 0x5)
      } else if (h.read(.state) == 0x7) || (h.read(.state) == 0x9) {
        h.write(.state, value: 0x2)
        h.write(.errorCount, value: h.read(.errorCount) &+ 1)
        if h.read(.errorCount) > 2 {
          h.write(.errorCount, value: 0)
          h.write(.urbState, value: 0x4)
        } else {
          h.write(.urbState, value: 0x2)
          tmpreg = usb.registers.read(.hcchar(chnum))
          tmpreg &= ~0x4000_0000
          tmpreg |= 0x8000_0000
          usb.registers.write(.hcchar(chnum), value: tmpreg)
        }
      } else {
        return
      }
      invokeURB(channelNumber, h.read(.urbState))
    } else {
      return
    }

  }
}
