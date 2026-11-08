// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HCD {
  func handleInChannelInterrupt(_ channelNumber: UInt8) {
    let chnum = UInt32(channelNumber)
    let h = handle.channel(chnum)

    var tmpreg: UInt32
    if getChannelFlag(channelNumber, 0x4) {
      clearChannelInterrupt(channelNumber, 0x4)
      h.write(.state, value: 0x7)
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x100) {
      clearChannelInterrupt(channelNumber, 0x100)
      h.write(.state, value: 0x8)
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x8) {
      clearChannelInterrupt(channelNumber, 0x8)
      h.write(.state, value: 0x6)
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x400) {
      clearChannelInterrupt(channelNumber, 0x400)
      h.write(.state, value: 0x9)
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x80) {
      clearChannelInterrupt(channelNumber, 0x80)
      h.write(.state, value: 0x7)
      _ = usb.haltHostChannel(channelNumber)
    } else {
    }
    if getChannelFlag(channelNumber, 0x200) {
      _ = usb.haltHostChannel(channelNumber)
      clearChannelInterrupt(channelNumber, 0x200)
    } else if getChannelFlag(channelNumber, 0x1) {
      clearChannelInterrupt(channelNumber, 0x20)
      if h.read(.doCompleteSplit) == 1 {
        h.write(.doCompleteSplit, value: 0)
        clearCompleteSplit(channelNumber)
      }
      if handle.readConfiguration(.dmaEnable) != 0 {
        h.write(
          .transferCount,
          value: h.read(.transferSize) &- (usb.registers.read(.hctsiz(chnum)) & 0x7ffff))
      }
      h.write(.state, value: 0x1)
      h.write(.errorCount, value: 0)
      clearChannelInterrupt(channelNumber, 0x1)
      if (h.read(.endpointType) == 0x0) || (h.read(.endpointType) == 0x2) {
        _ = usb.haltHostChannel(channelNumber)
        clearChannelInterrupt(channelNumber, 0x10)
      } else if (h.read(.endpointType) == 0x3) || (h.read(.endpointType) == 0x1) {
        usb.modify(.hcchar(chnum), set: 0x2000_0000)
        h.write(.urbState, value: 0x1)
        invokeURB(channelNumber, h.read(.urbState))
      } else {
      }
      if handle.readConfiguration(.dmaEnable) == 1 {
        if (((h.read(.transferCount) &+ h.read(.maximumPacketSize) &- 1)
          / h.read(.maximumPacketSize)) & 1) != 0
        {
          h.write(.toggleIn, value: h.read(.toggleIn) ^ (1))
        }
      } else {
        h.write(.toggleIn, value: h.read(.toggleIn) ^ (1))
      }
    } else if getChannelFlag(channelNumber, 0x20) {
      clearChannelInterrupt(channelNumber, 0x20)
      h.write(.nakCount, value: 0)
      if h.read(.doStartSplit) == 1 {
        h.write(.doCompleteSplit, value: 1)
        h.write(.state, value: 0x3)
        _ = usb.haltHostChannel(channelNumber)
      }
    } else if getChannelFlag(channelNumber, 0x2) {
      clearChannelInterrupt(channelNumber, 0x2)
      tmpreg = usb.registers.read(.hcchar(chnum))
      if (tmpreg & 0x4000_0000) != 0 {
        return
      }
      if h.read(.state) == 0x1 {
        h.write(.state, value: 0x2)
        h.write(.urbState, value: 0x1)
      } else if h.read(.state) == 0x6 {
        h.write(.state, value: 0x2)
        h.write(.urbState, value: 0x5)
      } else if (h.read(.state) == 0x7) || (h.read(.state) == 0x9) {
        h.write(.state, value: 0x2)
        if handle.readConfiguration(.dmaEnable) == 0 {
          h.write(.errorCount, value: h.read(.errorCount) &+ 1)
          if h.read(.errorCount) > 2 {
            h.write(.errorCount, value: 0)
            if h.read(.doStartSplit) == 1 {
              h.write(.doCompleteSplit, value: 0)
              h.write(.endpointStartSplitSchedule, value: 0)
              clearCompleteSplit(channelNumber)
            }
            h.write(.urbState, value: 0x4)
          } else {
            h.write(.urbState, value: 0x2)
            if (h.read(.endpointType) == 0x0) || (h.read(.endpointType) == 0x2) {
              tmpreg = usb.registers.read(.hcchar(chnum))
              tmpreg &= ~0x4000_0000
              tmpreg |= 0x8000_0000
              usb.registers.write(.hcchar(chnum), value: tmpreg)
            }
          }
        } else {
          h.write(.urbState, value: 0x2)
          if (h.read(.endpointType) == 0x0) || (h.read(.endpointType) == 0x2) {
            tmpreg = usb.registers.read(.hcchar(chnum))
            tmpreg &= ~0x4000_0000
            tmpreg |= 0x8000_0000
            usb.registers.write(.hcchar(chnum), value: tmpreg)
          }
        }
      } else if h.read(.state) == 0x5 {
        h.write(.state, value: 0x2)
        if h.read(.doCompleteSplit) == 1 {
          if h.read(.endpointType) == 0x3 {
            h.write(.nyetErrorCount, value: h.read(.nyetErrorCount) &+ 1)
            if h.read(.nyetErrorCount) > 2 {
              h.write(.nyetErrorCount, value: 0)
              h.write(.doCompleteSplit, value: 0)
              if h.read(.errorCount) < 3 {
                h.write(.endpointStartSplitSchedule, value: 1)
              }
              clearCompleteSplit(channelNumber)
              h.write(.urbState, value: 0x4)
            } else {
              h.write(.urbState, value: 0x2)
            }
          } else {
            h.write(.urbState, value: 0x2)
          }
          if (h.read(.endpointType) == 0x0) || (h.read(.endpointType) == 0x2) {
            tmpreg = usb.registers.read(.hcchar(chnum))
            tmpreg &= ~0x4000_0000
            tmpreg |= 0x8000_0000
            usb.registers.write(.hcchar(chnum), value: tmpreg)
          }
        }
      } else if h.read(.state) == 0x3 {
        h.write(.state, value: 0x2)
        if h.read(.doCompleteSplit) == 1 {
          h.write(.urbState, value: 0x2)
          usb.modify(.hcsplt(chnum), set: 0x10000)
          usb.modify(.hcintmsk(chnum), set: 0x40)
          usb.modify(.hcintmsk(chnum), clear: 0x20)
          if (h.read(.endpointType) == 0x0) || (h.read(.endpointType) == 0x2) {
            tmpreg = usb.registers.read(.hcchar(chnum))
            tmpreg &= ~0x4000_0000
            tmpreg |= 0x8000_0000
            usb.registers.write(.hcchar(chnum), value: tmpreg)
          }
        }
      } else if h.read(.state) == 0x4 {
        h.write(.state, value: 0x2)
        h.write(.urbState, value: 0x2)
        if (h.read(.endpointType) == 0x0) || (h.read(.endpointType) == 0x2) {
          if inNAKAutoActivateDisabled { h.write(.nakCount, value: h.read(.nakCount) &+ 1) }
          if inNAKAutoActivateDisabled && h.read(.nakCount) >= channelNAKCount {
            h.write(.state, value: 0x0)
            h.write(.urbState, value: 0x6)
            h.write(.nakCount, value: 0)
          } else {
            tmpreg = usb.registers.read(.hcchar(chnum))
            tmpreg &= ~0x4000_0000
            tmpreg |= 0x8000_0000
            usb.registers.write(.hcchar(chnum), value: tmpreg)
          }
        }
      } else if h.read(.state) == 0x8 {
        h.write(.state, value: 0x2)
        h.write(.errorCount, value: h.read(.errorCount) &+ 1)
        h.write(.urbState, value: 0x4)
      } else {
        if h.read(.state) == 0x2 {
          return
        }
      }
      invokeURB(channelNumber, h.read(.urbState))
    } else if getChannelFlag(channelNumber, 0x40) {
      clearChannelInterrupt(channelNumber, 0x40)
      h.write(.state, value: 0x5)
      if h.read(.doStartSplit) == 0 {
        h.write(.errorCount, value: 0)
      }
      _ = usb.haltHostChannel(channelNumber)
    } else if getChannelFlag(channelNumber, 0x10) {
      if h.read(.endpointType) == 0x3 {
        h.write(.errorCount, value: 0)
        h.write(.state, value: 0x4)
        _ = usb.haltHostChannel(channelNumber)
      } else if (h.read(.endpointType) == 0x0) || (h.read(.endpointType) == 0x2) {
        h.write(.errorCount, value: 0)
        if (handle.readConfiguration(.dmaEnable) == 0) || (h.read(.doCompleteSplit) == 1) {
          h.write(.state, value: 0x4)
          _ = usb.haltHostChannel(channelNumber)
        }
      } else {
      }
      if h.read(.doCompleteSplit) == 1 {
        h.write(.doCompleteSplit, value: 0)
        clearCompleteSplit(channelNumber)
        unmaskAcknowledgeInterrupt(channelNumber)
      }
      clearChannelInterrupt(channelNumber, 0x10)
    } else {
    }

  }
}
