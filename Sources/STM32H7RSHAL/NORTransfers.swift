// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NOR operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension NOR {
  public func read(_ pAddress: UInt32, _ pData: UnsafeMutablePointer<UInt16>?) -> HALStatus {
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
            value: UInt16(truncatingIfNeeded: 0xf0))
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
            value: UInt16(truncatingIfNeeded: 0xf0))
          memory.dataSynchronizationBarrier()
        }
      } else if handle.read(.commandSet) == 0x1 {
        memory.write16(at: pAddress, value: UInt16(truncatingIfNeeded: 0xff))
        memory.dataSynchronizationBarrier()
      } else {
        status = .error
      }
      if status != .error {
        pData!.pointee = UInt16(
          truncatingIfNeeded: UInt32(UInt16(truncatingIfNeeded: (memory.read32(at: pAddress)))))
      }

      handle.write(.state, value: state)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return status

  }
  public func program(_ pAddress: UInt32, _ pData: UnsafeMutablePointer<UInt16>?) -> HALStatus {
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
            value: UInt16(truncatingIfNeeded: 0xa0))
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
            value: UInt16(truncatingIfNeeded: 0xa0))
          memory.dataSynchronizationBarrier()
        }
      } else if handle.read(.commandSet) == 0x1 {
        memory.write16(at: pAddress, value: UInt16(truncatingIfNeeded: 0x40))
        memory.dataSynchronizationBarrier()
      } else {
        status = .error
      }
      if status != .error {
        memory.write16(at: pAddress, value: UInt16(truncatingIfNeeded: UInt32(pData!.pointee)))
        memory.dataSynchronizationBarrier()
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return status

  }
  public func readBuffer(
    _ uwAddress: UInt32, _ pData: UnsafeMutablePointer<UInt16>?, _ uwBufferSize: UInt32
  ) -> HALStatus {
    var deviceaddress: UInt32 = 0
    var size: UInt32 = 0
    var address: UInt32 = 0
    var data: UnsafeMutablePointer<UInt16>? = nil
    var state: UInt32 = 0
    var status: HALStatus = .ok

    size = uwBufferSize
    address = uwAddress
    data = pData

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
            value: UInt16(truncatingIfNeeded: 0xf0))
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
            value: UInt16(truncatingIfNeeded: 0xf0))
          memory.dataSynchronizationBarrier()
        }
      } else if handle.read(.commandSet) == 0x1 {
        memory.write16(at: deviceaddress, value: UInt16(truncatingIfNeeded: 0xff))
        memory.dataSynchronizationBarrier()
      } else {
        status = .error
      }
      if status != .error {
        while size > 0 {
          data!.pointee = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: address)))
          data = data!.advanced(by: Int(1))
          address = address &+ (2)
          size = size &- (1)
        }
      }

      handle.write(.state, value: state)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return status

  }
  public func programBuffer(
    _ uwAddress: UInt32, _ pData: UnsafeMutablePointer<UInt16>?, _ uwBufferSize: UInt32
  ) -> HALStatus {
    var p_currentaddress: UInt32 = 0
    var p_endaddress: UInt32 = 0
    var data: UnsafeMutablePointer<UInt16>? = nil
    var deviceaddress: UInt32 = 0
    var status: HALStatus = .ok

    data = pData

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

      p_currentaddress = (deviceaddress &+ uwAddress)
      p_endaddress = (deviceaddress &+ uwAddress &+ (2 &* (uwBufferSize &- 1)))
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
        }
        memory.write16(at: (deviceaddress &+ uwAddress), value: UInt16(truncatingIfNeeded: 0x25))
        memory.dataSynchronizationBarrier()
        memory.write16(
          at: (deviceaddress &+ uwAddress),
          value: UInt16(truncatingIfNeeded: UInt32(UInt16(truncatingIfNeeded: (uwBufferSize &- 1))))
        )
        memory.dataSynchronizationBarrier()
      } else if handle.read(.commandSet) == 0x1 {
        memory.write16(at: (deviceaddress &+ uwAddress), value: UInt16(truncatingIfNeeded: 0xe8))
        memory.dataSynchronizationBarrier()
        memory.write16(
          at: (deviceaddress &+ uwAddress),
          value: UInt16(truncatingIfNeeded: UInt32(UInt16(truncatingIfNeeded: (uwBufferSize &- 1))))
        )
        memory.dataSynchronizationBarrier()
      } else {
        status = .error
      }
      if status != .error {
        while p_currentaddress <= p_endaddress {
          memory.write16(
            at: p_currentaddress, value: UInt16(truncatingIfNeeded: UInt32(data!.pointee)))
          memory.dataSynchronizationBarrier()
          data = data!.advanced(by: Int(1))
          p_currentaddress = p_currentaddress &+ ((1) &* 2)
        }
        if handle.read(.commandSet) == 0x2 {
          memory.write16(at: (deviceaddress &+ uwAddress), value: UInt16(truncatingIfNeeded: 0x29))
          memory.dataSynchronizationBarrier()
        } else {
          memory.write16(at: (deviceaddress &+ uwAddress), value: UInt16(truncatingIfNeeded: 0xd0))
          memory.dataSynchronizationBarrier()
        }
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return status

  }
}
