// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NOR operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension NOR {
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }

  public func readID(_ pNOR_ID: UnsafeMutablePointer<NORID>?) -> HALStatus {
    var deviceaddress: UInt32 = 0
    var state: UInt32 = 0
    var status: HALStatus = .ok

    status = .ok

    state = handle.read(.state)
    if state == 0x2 {
      return .busy
    } else if state == 0x4 {
      return .error
    } else if state == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      if handle.read(.bank) == 0x0 {
        deviceaddress = 0x6000_0000
      } else if handle.read(.bank) == 0x2 {
        deviceaddress = 0x6400_0000
      } else if handle.read(.bank) == 0x4 {
        deviceaddress = 0x6800_0000
      } else {
        deviceaddress = 0x6c00_0000
      }

      if handle.read(.commandSet) == 0x2 {
        if shared.readMemoryDataWidth() == 0x0 {
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0xaaa))) : (deviceaddress &+ (0xaaa))),
            value: UInt16(truncatingIfNeeded: 0xaa))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0x55))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0xaaa))) : (deviceaddress &+ (0xaaa))),
            value: UInt16(truncatingIfNeeded: 0x90))
          memory.dataSynchronizationBarrier()
        } else {
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0xaa))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x2aa))) : (deviceaddress &+ (0x2aa))),
            value: UInt16(truncatingIfNeeded: 0x55))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0x90))
          memory.dataSynchronizationBarrier()
        }
      } else if handle.read(.commandSet) == 0x1 {
        memory.write16(at: deviceaddress, value: UInt16(truncatingIfNeeded: 0x90))
        memory.dataSynchronizationBarrier()
      } else {
        status = .error
      }
      if status != .error {
        pNOR_ID!.pointee.manufacturerCode = UInt16(
          truncatingIfNeeded: UInt32(
            memory.read16(
              at: ((shared.readMemoryDataWidth() == 0x1)
                ? (deviceaddress &+ (2 &* (0x0))) : (deviceaddress &+ (0x0))))))
        pNOR_ID!.pointee.deviceCode1 = UInt16(
          truncatingIfNeeded: UInt32(
            memory.read16(
              at: ((shared.readMemoryDataWidth() == 0x1)
                ? (deviceaddress &+ (2 &* (0x1))) : (deviceaddress &+ (0x1))))))
        pNOR_ID!.pointee.deviceCode2 = UInt16(
          truncatingIfNeeded: UInt32(
            memory.read16(
              at: ((shared.readMemoryDataWidth() == 0x1)
                ? (deviceaddress &+ (2 &* (0xe))) : (deviceaddress &+ (0xe))))))
        pNOR_ID!.pointee.deviceCode3 = UInt16(
          truncatingIfNeeded: UInt32(
            memory.read16(
              at: ((shared.readMemoryDataWidth() == 0x1)
                ? (deviceaddress &+ (2 &* (0xf))) : (deviceaddress &+ (0xf))))))
      }

      handle.write(.state, value: state)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return status

  }
  public func returnToReadMode() -> HALStatus {
    var deviceaddress: UInt32 = 0
    var state: UInt32 = 0
    var status: HALStatus = .ok

    status = .ok

    state = handle.read(.state)
    if state == 0x2 {
      return .busy
    } else if state == 0x4 {
      return .error
    } else if state == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      if handle.read(.bank) == 0x0 {
        deviceaddress = 0x6000_0000
      } else if handle.read(.bank) == 0x2 {
        deviceaddress = 0x6400_0000
      } else if handle.read(.bank) == 0x4 {
        deviceaddress = 0x6800_0000
      } else {
        deviceaddress = 0x6c00_0000
      }
      if handle.read(.commandSet) == 0x2 {
        memory.write16(at: deviceaddress, value: UInt16(truncatingIfNeeded: 0xf0))
        memory.dataSynchronizationBarrier()
      } else if handle.read(.commandSet) == 0x1 {
        memory.write16(at: deviceaddress, value: UInt16(truncatingIfNeeded: 0xff))
        memory.dataSynchronizationBarrier()
      } else {
        status = .error
      }

      handle.write(.state, value: state)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return status

  }
  public func eraseBlock(_ BlockAddress: UInt32, _ Address: UInt32) -> HALStatus {
    var deviceaddress: UInt32 = 0
    var status: HALStatus = .ok

    status = .ok

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      if handle.read(.bank) == 0x0 {
        deviceaddress = 0x6000_0000
      } else if handle.read(.bank) == 0x2 {
        deviceaddress = 0x6400_0000
      } else if handle.read(.bank) == 0x4 {
        deviceaddress = 0x6800_0000
      } else {
        deviceaddress = 0x6c00_0000
      }

      if handle.read(.commandSet) == 0x2 {
        if shared.readMemoryDataWidth() == 0x0 {
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0xaaa))) : (deviceaddress &+ (0xaaa))),
            value: UInt16(truncatingIfNeeded: 0xaa))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0x55))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0xaaa))) : (deviceaddress &+ (0xaaa))),
            value: UInt16(truncatingIfNeeded: 0x80))
          memory.dataSynchronizationBarrier()
        } else {
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0xaa))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x2aa))) : (deviceaddress &+ (0x2aa))),
            value: UInt16(truncatingIfNeeded: 0x55))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0x80))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0xaa))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x2aa))) : (deviceaddress &+ (0x2aa))),
            value: UInt16(truncatingIfNeeded: 0x55))
          memory.dataSynchronizationBarrier()
        }
        memory.write16(
          at: UInt32(truncatingIfNeeded: (BlockAddress &+ Address)),
          value: UInt16(truncatingIfNeeded: 0x30))
        memory.dataSynchronizationBarrier()
      } else if handle.read(.commandSet) == 0x1 {
        memory.write16(at: (BlockAddress &+ Address), value: UInt16(truncatingIfNeeded: 0x60))
        memory.dataSynchronizationBarrier()
        memory.write16(at: (BlockAddress &+ Address), value: UInt16(truncatingIfNeeded: 0xd0))
        memory.dataSynchronizationBarrier()
        memory.write16(at: (BlockAddress &+ Address), value: UInt16(truncatingIfNeeded: 0x20))
        memory.dataSynchronizationBarrier()
        memory.write16(at: (BlockAddress &+ Address), value: UInt16(truncatingIfNeeded: 0xd0))
        memory.dataSynchronizationBarrier()
      } else {
        status = .error
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return status

  }
  public func eraseChip(_ Address: UInt32) -> HALStatus {
    var deviceaddress: UInt32 = 0
    var status: HALStatus = .ok

    status = .ok
    _ = Address

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      if handle.read(.bank) == 0x0 {
        deviceaddress = 0x6000_0000
      } else if handle.read(.bank) == 0x2 {
        deviceaddress = 0x6400_0000
      } else if handle.read(.bank) == 0x4 {
        deviceaddress = 0x6800_0000
      } else {
        deviceaddress = 0x6c00_0000
      }

      if handle.read(.commandSet) == 0x2 {
        if shared.readMemoryDataWidth() == 0x0 {
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0xaaa))) : (deviceaddress &+ (0xaaa))),
            value: UInt16(truncatingIfNeeded: 0xaa))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0x55))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0xaaa))) : (deviceaddress &+ (0xaaa))),
            value: UInt16(truncatingIfNeeded: 0x80))
          memory.dataSynchronizationBarrier()
        } else {
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0xaa))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x2aa))) : (deviceaddress &+ (0x2aa))),
            value: UInt16(truncatingIfNeeded: 0x55))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0x80))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0xaa))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x2aa))) : (deviceaddress &+ (0x2aa))),
            value: UInt16(truncatingIfNeeded: 0x55))
          memory.dataSynchronizationBarrier()
          memory.write16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x555))) : (deviceaddress &+ (0x555))),
            value: UInt16(truncatingIfNeeded: 0x10))
          memory.dataSynchronizationBarrier()
        }
      } else {
        status = .error
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return status

  }
  public func readCFI(_ pNOR_CFI: UnsafeMutablePointer<NORCFI>?) -> HALStatus {
    var deviceaddress: UInt32 = 0
    var state: UInt32 = 0

    state = handle.read(.state)
    if state == 0x2 {
      return .busy
    } else if state == 0x4 {
      return .error
    } else if state == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      if handle.read(.bank) == 0x0 {
        deviceaddress = 0x6000_0000
      } else if handle.read(.bank) == 0x2 {
        deviceaddress = 0x6400_0000
      } else if handle.read(.bank) == 0x4 {
        deviceaddress = 0x6800_0000
      } else {
        deviceaddress = 0x6c00_0000
      }

      if shared.readMemoryDataWidth() == 0x0 {
        memory.write16(
          at: ((shared.readMemoryDataWidth() == 0x1)
            ? (deviceaddress &+ (2 &* (0xaa))) : (deviceaddress &+ (0xaa))),
          value: UInt16(truncatingIfNeeded: 0x98))
        memory.dataSynchronizationBarrier()
      } else {
        memory.write16(
          at: ((shared.readMemoryDataWidth() == 0x1)
            ? (deviceaddress &+ (2 &* (0x55))) : (deviceaddress &+ (0x55))),
          value: UInt16(truncatingIfNeeded: 0x98))
        memory.dataSynchronizationBarrier()
      }
      pNOR_CFI!.pointee.cfi1 = UInt16(
        truncatingIfNeeded: UInt32(
          memory.read16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x61))) : (deviceaddress &+ (0x61))))))
      pNOR_CFI!.pointee.cfi2 = UInt16(
        truncatingIfNeeded: UInt32(
          memory.read16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x62))) : (deviceaddress &+ (0x62))))))
      pNOR_CFI!.pointee.cfi3 = UInt16(
        truncatingIfNeeded: UInt32(
          memory.read16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x63))) : (deviceaddress &+ (0x63))))))
      pNOR_CFI!.pointee.cfi4 = UInt16(
        truncatingIfNeeded: UInt32(
          memory.read16(
            at: ((shared.readMemoryDataWidth() == 0x1)
              ? (deviceaddress &+ (2 &* (0x64))) : (deviceaddress &+ (0x64))))))

      handle.write(.state, value: state)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func enableWrite() -> HALStatus {

    if handle.read(.state) == 0x4 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      _ = fmc.enableNORSRAMWrite(handle.read(.bank))

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func disableWrite() -> HALStatus {

    if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      _ = fmc.disableNORSRAMWrite(handle.read(.bank))

      handle.write(.state, value: 0x4)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getStatus(_ Address: UInt32, _ Timeout: UInt32, getTick: () -> UInt32) -> UInt32 {
    var status: UInt32 = 0
    var tmpsr1: UInt16 = 0
    var tmpsr2: UInt16 = 0
    var tickstart: UInt32 = 0

    status = 0x1

    defaults.mspWait(callbacks.context, Timeout)

    tickstart = getTick()
    if handle.read(.commandSet) == 0x2 {
      while (status != 0x0) && (status != 0x3) {
        if Timeout != 0xffff_ffff {
          if ((getTick() &- tickstart) > Timeout) || (Timeout == 0) {
            status = 0x3
          }
        }

        tmpsr1 = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: Address)))
        tmpsr2 = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: Address)))

        if (tmpsr1 & 0x40) == (tmpsr2 & 0x40) {
          return 0x0
        }
        if (tmpsr1 & 0x20) == 0x20 {
          status = 0x1
        }
        tmpsr1 = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: Address)))
        tmpsr2 = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: Address)))

        if (tmpsr1 & 0x40) == (tmpsr2 & 0x40) {
          return 0x0
        }
        if (tmpsr1 & 0x20) == 0x20 {
          return 0x2
        }
      }
    } else if handle.read(.commandSet) == 0x1 {
      repeat {
        memory.write16(at: Address, value: UInt16(truncatingIfNeeded: 0x70))
        memory.dataSynchronizationBarrier()
        tmpsr2 = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: (Address))))

        if Timeout != 0xffff_ffff {
          if ((getTick() &- tickstart) > Timeout) || (Timeout == 0) {
            return 0x3
          }
        }
      } while (tmpsr2 & 0x80) == 0
      memory.write16(at: Address, value: UInt16(truncatingIfNeeded: 0x70))
      memory.dataSynchronizationBarrier()
      tmpsr1 = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: (Address))))
      if (tmpsr1 & (0x20 | 0x10)) != 0 {
        memory.write16(at: Address, value: UInt16(truncatingIfNeeded: 0x70))
        memory.dataSynchronizationBarrier()
        status = 0x2
      } else {
        status = 0x0
      }
    } else {
      status = 0x2
    }

    return status

  }
}
