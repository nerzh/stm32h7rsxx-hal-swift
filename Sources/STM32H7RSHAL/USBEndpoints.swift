// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USB {
  public func activateEndpoint<Endpoint: USBEndpointIO>(_ endpoint: Endpoint) -> HALStatus {
    let number = endpoint.read(.number)
    if endpoint.read(.isIn) == 1 {
      modify(.daintmsk, set: 0xffff & (1 << (endpoint.read(.number) & 0xf)))
      if registers.read(.diepctl(number)) & 0x8000 == 0 {
        modify(
          .diepctl(number),
          set: (endpoint.read(.maximumPacketSize) & 0x7ff) | (endpoint.read(.type) << 18)
            | (number << 22) | 0x1000_0000 | 0x8000)
      }
    } else {
      modify(.daintmsk, set: 0xffff_0000 & ((1 << (endpoint.read(.number) & 0xf)) << 16))
      if registers.read(.doepctl(number)) & 0x8000 == 0 {
        modify(
          .doepctl(number),
          set: (endpoint.read(.maximumPacketSize) & 0x7ff) | (endpoint.read(.type) << 18)
            | 0x1000_0000 | 0x8000)
      }
    }
    return .ok
  }
  public func activateDedicatedEndpoint<Endpoint: USBEndpointIO>(_ endpoint: Endpoint) -> HALStatus
  {
    let number = endpoint.read(.number)
    if endpoint.read(.isIn) == 1 {
      if registers.read(.diepctl(number)) & 0x8000 == 0 {
        modify(
          .diepctl(number),
          set: (endpoint.read(.maximumPacketSize) & 0x7ff) | (endpoint.read(.type) << 18)
            | (number << 22) | 0x1000_0000 | 0x8000)
      }
      modify(.deachmsk, set: 0xffff & (1 << (endpoint.read(.number) & 0xf)))
    } else {
      if registers.read(.doepctl(number)) & 0x8000 == 0 {
        modify(
          .doepctl(number),
          set: (endpoint.read(.maximumPacketSize) & 0x7ff) | (endpoint.read(.type) << 18)
            | (number << 22) | 0x8000)
      }
      modify(.deachmsk, set: 0xffff_0000 & ((1 << (endpoint.read(.number) & 0xf)) << 16))
    }
    return .ok
  }
  public func deactivateEndpoint<Endpoint: USBEndpointIO>(_ endpoint: Endpoint) -> HALStatus {
    let number = endpoint.read(.number)
    if endpoint.read(.isIn) == 1 {
      if registers.read(.diepctl(number)) & 0x8000_0000 == 0x8000_0000 {
        modify(.diepctl(number), set: 0x8000000)
        modify(.diepctl(number), set: 0x4000_0000)
      }
      modify(.deachmsk, clear: 0xffff & (1 << (endpoint.read(.number) & 0xf)))
      modify(.daintmsk, clear: 0xffff & (1 << (endpoint.read(.number) & 0xf)))
      modify(.diepctl(number), clear: 0x8000 | 0x7ff | 0x3c00000 | 0x1000_0000 | 0xc0000)
    } else {
      if registers.read(.doepctl(number)) & 0x8000_0000 == 0x8000_0000 {
        modify(.doepctl(number), set: 0x8000000)
        modify(.doepctl(number), set: 0x4000_0000)
      }
      modify(.deachmsk, clear: 0xffff_0000 & ((1 << (endpoint.read(.number) & 0xf)) << 16))
      modify(.daintmsk, clear: 0xffff_0000 & ((1 << (endpoint.read(.number) & 0xf)) << 16))
      modify(.doepctl(number), clear: 0x8000 | 0x7ff | 0x1000_0000 | 0xc0000)
    }
    return .ok
  }
  public func deactivateDedicatedEndpoint<Endpoint: USBEndpointIO>(_ endpoint: Endpoint)
    -> HALStatus
  {
    let number = endpoint.read(.number)
    if endpoint.read(.isIn) == 1 {
      if registers.read(.diepctl(number)) & 0x8000_0000 == 0x8000_0000 {
        modify(.diepctl(number), set: 0x8000000)
        modify(.diepctl(number), set: 0x4000_0000)
      }
      modify(.diepctl(number), clear: 0x8000)
      modify(.daintmsk, clear: 0xffff & (1 << (endpoint.read(.number) & 0xf)))
    } else {
      if registers.read(.doepctl(number)) & 0x8000_0000 == 0x8000_0000 {
        modify(.doepctl(number), set: 0x8000000)
        modify(.doepctl(number), set: 0x4000_0000)
      }
      modify(.doepctl(number), clear: 0x8000)
      modify(.daintmsk, clear: 0xffff_0000 & ((1 << (endpoint.read(.number) & 0xf)) << 16))
    }
    return .ok
  }
  public func setEndpointStall<Endpoint: USBEndpointIO>(_ endpoint: Endpoint) -> HALStatus {
    let number = endpoint.read(.number)
    if endpoint.read(.isIn) == 1 {
      if registers.read(.diepctl(number)) & 0x8000_0000 == 0 && number != 0 {
        modify(.diepctl(number), clear: 0x4000_0000)
      }
      modify(.diepctl(number), set: 0x200000)
    } else {
      if registers.read(.doepctl(number)) & 0x8000_0000 == 0 && number != 0 {
        modify(.doepctl(number), clear: 0x4000_0000)
      }
      modify(.doepctl(number), set: 0x200000)
    }
    return .ok
  }
  public func clearEndpointStall<Endpoint: USBEndpointIO>(_ endpoint: Endpoint) -> HALStatus {
    let number = endpoint.read(.number)
    if endpoint.read(.isIn) == 1 {
      modify(.diepctl(number), clear: 0x200000)
      if endpoint.read(.type) == 0x3 || endpoint.read(.type) == 0x2 {
        modify(.diepctl(number), set: 0x1000_0000)
      }
    } else {
      modify(.doepctl(number), clear: 0x200000)
      if endpoint.read(.type) == 0x3 || endpoint.read(.type) == 0x2 {
        modify(.doepctl(number), set: 0x1000_0000)
      }
    }
    return .ok
  }
  public func startEndpointTransfer<Endpoint: USBEndpointIO>(_ endpoint: Endpoint, dma: UInt8)
    -> HALStatus
  {
    let number = endpoint.read(.number)
    var packetCount: UInt16
    if endpoint.read(.isIn) == 1 {
      if endpoint.read(.transferLength) == 0 {
        modify(.dieptsiz(number), clear: 0x1ff8_0000)
        modify(.dieptsiz(number), set: 0x1ff8_0000 & (1 << 19))
        modify(.dieptsiz(number), clear: 0x7ffff)
      } else {
        modify(.dieptsiz(number), clear: 0x7ffff)
        modify(.dieptsiz(number), clear: 0x1ff8_0000)
        if number == 0 {
          if endpoint.read(.transferLength) > endpoint.read(.maximumPacketSize) {
            endpoint.write(.transferLength, value: endpoint.read(.maximumPacketSize))
          }
          modify(.dieptsiz(number), set: 0x1ff8_0000 & (1 << 19))
        } else {
          packetCount = UInt16(
            truncatingIfNeeded: (endpoint.read(.transferLength) &+ endpoint.read(.maximumPacketSize)
              &- 1) / endpoint.read(.maximumPacketSize))
          modify(.dieptsiz(number), set: 0x1ff8_0000 & (UInt32(packetCount) << 19))
          if endpoint.read(.type) == 0x1 {
            modify(.dieptsiz(number), clear: 0x6000_0000)
            modify(.dieptsiz(number), set: 0x6000_0000 & (UInt32(packetCount) << 29))
          }
        }
        modify(.dieptsiz(number), set: 0x7ffff & endpoint.read(.transferLength))
      }
      if dma == 1 {
        if endpoint.read(.dmaAddress) != 0 {
          registers.write(.diepdma(number), value: endpoint.read(.dmaAddress))
        }
        if endpoint.read(.type) == 0x1 {
          if registers.read(.dsts) & (1 << 8) == 0 {
            modify(.diepctl(number), set: 0x2000_0000)
          } else {
            modify(.diepctl(number), set: 0x1000_0000)
          }
        }
        modify(.diepctl(number), set: 0x4000000 | 0x8000_0000)
      } else {
        modify(.diepctl(number), set: 0x4000000 | 0x8000_0000)
        if endpoint.read(.type) != 0x1 {
          if endpoint.read(.transferLength) > 0 {
            modify(.diepempmsk, set: 1 << (endpoint.read(.number) & 0xf))
          }
        } else {
          if registers.read(.dsts) & (1 << 8) == 0 {
            modify(.diepctl(number), set: 0x2000_0000)
          } else {
            modify(.diepctl(number), set: 0x1000_0000)
          }
          _ = writePacket(
            endpoint.readBuffer().map { UnsafePointer($0) },
            channelOrEndpoint: UInt8(truncatingIfNeeded: endpoint.read(.number)),
            length: UInt16(truncatingIfNeeded: endpoint.read(.transferLength)), dma: dma)
        }
      }
    } else {
      modify(.doeptsiz(number), clear: 0x7ffff)
      modify(.doeptsiz(number), clear: 0x1ff8_0000)
      if number == 0 {
        if endpoint.read(.transferLength) > 0 {
          endpoint.write(.transferLength, value: endpoint.read(.maximumPacketSize))
        }
        endpoint.write(.transferSize, value: endpoint.read(.maximumPacketSize))
        modify(.doeptsiz(number), set: 0x7ffff & endpoint.read(.transferSize))
        modify(.doeptsiz(number), set: 0x1ff8_0000 & (1 << 19))
      } else {
        if endpoint.read(.transferLength) == 0 {
          modify(.doeptsiz(number), set: 0x7ffff & endpoint.read(.maximumPacketSize))
          modify(.doeptsiz(number), set: 0x1ff8_0000 & (1 << 19))
        } else {
          packetCount = UInt16(
            truncatingIfNeeded: (endpoint.read(.transferLength) &+ endpoint.read(.maximumPacketSize)
              &- 1) / endpoint.read(.maximumPacketSize))
          endpoint.write(
            .transferSize, value: endpoint.read(.maximumPacketSize) &* UInt32(packetCount))
          modify(.doeptsiz(number), set: 0x1ff8_0000 & (UInt32(packetCount) << 19))
          modify(.doeptsiz(number), set: 0x7ffff & endpoint.read(.transferSize))
        }
      }
      if dma == 1 {
        if UInt32(truncatingIfNeeded: UInt(bitPattern: endpoint.readBuffer())) != 0 {
          registers.write(
            .doepdma(number),
            value: UInt32(truncatingIfNeeded: UInt(bitPattern: endpoint.readBuffer())))
        }
      }
      if endpoint.read(.type) == 0x1 {
        if registers.read(.dsts) & (1 << 8) == 0 {
          modify(.doepctl(number), set: 0x2000_0000)
        } else {
          modify(.doepctl(number), set: 0x1000_0000)
        }
      }
      modify(.doepctl(number), set: 0x4000000 | 0x8000_0000)
    }
    return .ok
  }
  public func stopEndpointTransfer<Endpoint: USBEndpointIO>(_ endpoint: Endpoint) -> HALStatus {
    var count: UInt32 = 0
    var result = HALStatus.ok
    let dma = (registers.read(.gahbcfg) & 0x20) >> 5
    if endpoint.read(.isIn) == 1 {
      if registers.read(.diepctl(endpoint.read(.number))) & 0x8000_0000 == 0x8000_0000 {
        modify(.diepctl(endpoint.read(.number)), set: 0x8000000)
        modify(.diepctl(endpoint.read(.number)), set: 0x4000_0000)
        repeat {
          count &+= 1
          if count > 0xF0000 {
            result = .error
            break
          }
        } while registers.read(.diepctl(endpoint.read(.number))) & 0x8000_0000 == 0x8000_0000
      }
    } else {
      modify(.gintmsk, clear: 0x80)
      if registers.read(.gintsts) & 0x80 == 0 { modify(.dctl, set: 0x200) }
      if dma == 0 {
        repeat {
          count &+= 1
          if count > 0xF0000 {
            result = .error
            break
          }
        } while (registers.read(.gintsts) & 0x10) & 0x10 != 0x10
        _ = registers.read(.grxstsp)
      }
      count = 0
      repeat {
        count &+= 1
        if count > 0xF0000 {
          result = .error
          break
        }
      } while (registers.read(.gintsts) & 0x80) & 0x80 != 0x80
      modify(.doepctl(endpoint.read(.number)), set: 0x8000000)
      modify(.doepctl(endpoint.read(.number)), set: 0x4000_0000)
      count = 0
      repeat {
        count &+= 1
        if count > 0xF0000 {
          result = .error
          break
        }
      } while (registers.read(.doepint(endpoint.read(.number))) & 0x2) & 0x2 != 0x2
      modify(.doepint(endpoint.read(.number)), set: 0x2)
      modify(.dctl, set: 0x400)
    }
    return result
  }
}
