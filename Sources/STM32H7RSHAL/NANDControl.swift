// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NAND operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension NAND {
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }

  public func interruptHandler() {

    if fmc.getNANDFlag(0x1) {
      if useRegisteredCallbacks {
        callbacks.read(.interrupt)!(callbacks.context)
      } else {
        defaults.interrupt(callbacks.context)
      }

      fmc.clearNANDFlag(0x1)
    }

    if fmc.getNANDFlag(0x2) {
      if useRegisteredCallbacks {
        callbacks.read(.interrupt)!(callbacks.context)
      } else {
        defaults.interrupt(callbacks.context)
      }

      fmc.clearNANDFlag(0x2)
    }

    if fmc.getNANDFlag(0x4) {
      if useRegisteredCallbacks {
        callbacks.read(.interrupt)!(callbacks.context)
      } else {
        defaults.interrupt(callbacks.context)
      }

      fmc.clearNANDFlag(0x4)
    }

    if fmc.getNANDFlag(0x40) {
      if useRegisteredCallbacks {
        callbacks.read(.interrupt)!(callbacks.context)
      } else {
        defaults.interrupt(callbacks.context)
      }

      fmc.clearNANDFlag(0x40)
    }

  }
  public func readID(_ pNAND_ID: UnsafeMutablePointer<NANDID>?) -> HALStatus {
    var data: UInt32 = 0
    var data1: UInt32 = 0
    var deviceaddress: UInt32 = 0

    data = 0
    data1 = 0

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      memory.write8(
        at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
        value: UInt8(truncatingIfNeeded: 0x90))
      memory.dataSynchronizationBarrier()
      memory.write8(
        at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
        value: UInt8(truncatingIfNeeded: 0x00))
      memory.dataSynchronizationBarrier()

      if handle.read(.memoryDataWidth) == 0x0 {
        data = memory.read32(at: deviceaddress)

        pNAND_ID!.pointee.makerID = UInt8(
          truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (data)))))
        pNAND_ID!.pointee.deviceID = UInt8(
          truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (data >> 8)))))
        pNAND_ID!.pointee.thirdID = UInt8(
          truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (data >> 16)))))
        pNAND_ID!.pointee.fourthID = UInt8(
          truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (data >> 24)))))
      } else {
        data = memory.read32(at: deviceaddress)
        data1 = memory.read32(at: deviceaddress &+ 16)

        pNAND_ID!.pointee.makerID = UInt8(
          truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (data)))))
        pNAND_ID!.pointee.deviceID = UInt8(
          truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (data >> 16)))))
        pNAND_ID!.pointee.thirdID = UInt8(
          truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (data1)))))
        pNAND_ID!.pointee.fourthID = UInt8(
          truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (data1 >> 16)))))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func reset() -> HALStatus {
    var deviceaddress: UInt32 = 0

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      memory.write8(
        at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
        value: UInt8(truncatingIfNeeded: 0xFF))

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func eraseBlock(_ pAddress: UnsafePointer<NANDAddress>?) -> HALStatus {
    var deviceaddress: UInt32 = 0

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      memory.write8(
        at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
        value: UInt8(truncatingIfNeeded: 0x60))
      memory.dataSynchronizationBarrier()
      memory.write8(
        at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
        value: UInt8(
          truncatingIfNeeded: (UInt32(
            UInt8(
              truncatingIfNeeded: ((UInt32(pAddress!.pointee.page)
                &+ ((UInt32(pAddress!.pointee.block)
                  &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
                  &* handle.read(.blockSize))))
            )))))
      memory.dataSynchronizationBarrier()
      memory.write8(
        at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
        value: UInt8(
          truncatingIfNeeded: (UInt32(
            UInt8(
              truncatingIfNeeded: ((UInt32(pAddress!.pointee.page)
                &+ ((UInt32(pAddress!.pointee.block)
                  &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
                  &* handle.read(.blockSize)))
                >> 8))))))
      memory.dataSynchronizationBarrier()
      memory.write8(
        at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
        value: UInt8(
          truncatingIfNeeded: (UInt32(
            UInt8(
              truncatingIfNeeded: ((UInt32(pAddress!.pointee.page)
                &+ ((UInt32(pAddress!.pointee.block)
                  &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
                  &* handle.read(.blockSize)))
                >> 16))))))
      memory.dataSynchronizationBarrier()
      memory.write8(
        at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
        value: UInt8(truncatingIfNeeded: 0xd0))
      memory.dataSynchronizationBarrier()

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func incrementAddress(_ pAddress: UnsafeMutablePointer<NANDAddress>?) -> UInt32 {
    var status: UInt32 = 0

    status = 0x100

    pAddress!.pointee.page = UInt16(truncatingIfNeeded: UInt32(pAddress!.pointee.page) &+ (1))

    if UInt32(pAddress!.pointee.page) == handle.read(.blockSize) {
      pAddress!.pointee.page = UInt16(truncatingIfNeeded: 0)
      pAddress!.pointee.block = UInt16(truncatingIfNeeded: UInt32(pAddress!.pointee.block) &+ (1))
      if UInt32(pAddress!.pointee.block) == handle.read(.planeSize) {
        pAddress!.pointee.block = UInt16(truncatingIfNeeded: 0)
        pAddress!.pointee.plane = UInt16(truncatingIfNeeded: UInt32(pAddress!.pointee.plane) &+ (1))
        if UInt32(pAddress!.pointee.plane) == (handle.read(.planeCount)) {
          status = 0x200
        }
      }
    }
    return (status)

  }
  public func enableECC() -> HALStatus {

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x2)

      _ = fmc.enableNANDECC(handle.read(.bank))

      handle.write(.state, value: 0x1)
    } else {
      return .error
    }
    return .ok

  }
  public func disableECC() -> HALStatus {

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x2)

      _ = fmc.disableNANDECC(handle.read(.bank))

      handle.write(.state, value: 0x1)
    } else {
      return .error
    }
    return .ok

  }
  public func getECC(
    _ ECCval: UnsafeMutablePointer<UInt32>?, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var status: HALStatus = .ok

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x2)

      status = fmc.getNANDECC(ECCval, handle.read(.bank), Timeout, getTick: getTick)

      handle.write(.state, value: 0x1)
    } else {
      return .error
    }
    return status

  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func readStatus() -> UInt32 {
    var data: UInt32 = 0
    var deviceaddress: UInt32 = 0

    _ = handle

    deviceaddress = 0x8000_0000

    memory.write8(
      at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
      value: UInt8(truncatingIfNeeded: 0x70))

    data = UInt32(memory.read8(at: deviceaddress))

    if (data & 0x1) == 0x1 {
      return 0x1
    } else if (data & 0x40) == 0x40 {
      return 0x40
    } else {
      return 0x0
    }

  }
}
