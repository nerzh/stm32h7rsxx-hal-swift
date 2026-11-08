// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SRAM {
  public func read8(
    _ pAddress: UInt32, _ pDstBuffer: UnsafeMutablePointer<UInt8>?, _ BufferSize: UInt32
  ) -> HALStatus {
    var size: UInt32 = 0
    var psramaddress: UInt32 = 0
    var pdestbuff: UnsafeMutablePointer<UInt8>? = nil
    var state: UInt32 = 0

    psramaddress = pAddress
    pdestbuff = pDstBuffer
    state = handle.read(.state)

    if (state == 0x1) || (state == 0x4) {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      size = BufferSize
      while size != 0 {
        pdestbuff!.pointee = UInt8(truncatingIfNeeded: UInt32(memory.read8(at: psramaddress)))
        pdestbuff = pdestbuff!.advanced(by: Int(1))
        psramaddress = psramaddress &+ ((1) &* 1)
        size = size &- (1)
      }

      handle.write(.state, value: state)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func write8(
    _ pAddress: UInt32, _ pSrcBuffer: UnsafeMutablePointer<UInt8>?, _ BufferSize: UInt32
  ) -> HALStatus {
    var size: UInt32 = 0
    var psramaddress: UInt32 = 0
    var psrcbuff: UnsafeMutablePointer<UInt8>? = nil

    psramaddress = pAddress
    psrcbuff = pSrcBuffer

    if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      size = BufferSize
      while size != 0 {
        memory.write8(at: psramaddress, value: UInt8(truncatingIfNeeded: UInt32(psrcbuff!.pointee)))
        psrcbuff = psrcbuff!.advanced(by: Int(1))
        psramaddress = psramaddress &+ ((1) &* 1)
        size = size &- (1)
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func read16(
    _ pAddress: UInt32, _ pDstBuffer: UnsafeMutablePointer<UInt16>?, _ BufferSize: UInt32
  ) -> HALStatus {
    var size: UInt32 = 0
    var psramaddress: UInt32 = 0
    var pdestbuff: UnsafeMutablePointer<UInt16>? = nil
    var limit: UInt32 = 0
    var state: UInt32 = 0

    psramaddress = pAddress
    pdestbuff = pDstBuffer

    state = handle.read(.state)

    if (state == 0x1) || (state == 0x4) {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      limit = UInt32(UInt8(truncatingIfNeeded: (((BufferSize % 2) != 0) ? 1 : 0)))

      size = BufferSize
      while size != limit {
        pdestbuff!.pointee = UInt16(
          truncatingIfNeeded: UInt32(
            UInt16(truncatingIfNeeded: ((memory.read32(at: psramaddress)) & 0x0000_FFFF))))
        pdestbuff = pdestbuff!.advanced(by: Int(1))
        pdestbuff!.pointee = UInt16(
          truncatingIfNeeded: UInt32(
            UInt16(truncatingIfNeeded: (((memory.read32(at: psramaddress)) & 0xFFFF_0000) >> 16))))
        pdestbuff = pdestbuff!.advanced(by: Int(1))
        psramaddress = psramaddress &+ ((1) &* 4)
        size = size &- (2)
      }

      if limit != 0 {
        pdestbuff!.pointee = UInt16(
          truncatingIfNeeded: UInt32(
            UInt16(truncatingIfNeeded: ((memory.read32(at: psramaddress)) & 0x0000_FFFF))))
      }

      handle.write(.state, value: state)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func write16(
    _ pAddress: UInt32, _ pSrcBuffer: UnsafeMutablePointer<UInt16>?, _ BufferSize: UInt32
  ) -> HALStatus {
    var size: UInt32 = 0
    var psramaddress: UInt32 = 0
    var psrcbuff: UnsafeMutablePointer<UInt16>? = nil
    var limit: UInt32 = 0

    psramaddress = pAddress
    psrcbuff = pSrcBuffer

    if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      limit = UInt32(UInt8(truncatingIfNeeded: (((BufferSize % 2) != 0) ? 1 : 0)))

      size = BufferSize
      while size != limit {
        memory.write32(
          at: psramaddress, value: UInt32(truncatingIfNeeded: (UInt32(psrcbuff!.pointee))))
        psrcbuff = psrcbuff!.advanced(by: Int(1))
        memory.write32(
          at: psramaddress,
          value: (memory.read32(at: psramaddress)
            | ((UInt32(truncatingIfNeeded: (UInt32(psrcbuff!.pointee))) << 16))))
        psrcbuff = psrcbuff!.advanced(by: Int(1))
        psramaddress = psramaddress &+ ((1) &* 4)
        size = size &- (2)
      }

      if limit != 0 {
        memory.write32(
          at: psramaddress,
          value: (UInt32(truncatingIfNeeded: (UInt32(psrcbuff!.pointee))) & 0x0000_FFFF)
            | ((memory.read32(at: psramaddress)) & 0xFFFF_0000))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func read32(
    _ pAddress: UInt32, _ pDstBuffer: UnsafeMutablePointer<UInt32>?, _ BufferSize: UInt32
  ) -> HALStatus {
    var size: UInt32 = 0
    var psramaddress: UInt32 = 0
    var pdestbuff: UnsafeMutablePointer<UInt32>? = nil
    var state: UInt32 = 0

    psramaddress = pAddress
    pdestbuff = pDstBuffer
    state = handle.read(.state)

    if (state == 0x1) || (state == 0x4) {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      size = BufferSize
      while size != 0 {
        pdestbuff!.pointee = memory.read32(at: psramaddress)
        pdestbuff = pdestbuff!.advanced(by: Int(1))
        psramaddress = psramaddress &+ ((1) &* 4)
        size = size &- (1)
      }

      handle.write(.state, value: state)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func write32(
    _ pAddress: UInt32, _ pSrcBuffer: UnsafeMutablePointer<UInt32>?, _ BufferSize: UInt32
  ) -> HALStatus {
    var size: UInt32 = 0
    var psramaddress: UInt32 = 0
    var psrcbuff: UnsafeMutablePointer<UInt32>? = nil

    psramaddress = pAddress
    psrcbuff = pSrcBuffer

    if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      size = BufferSize
      while size != 0 {
        memory.write32(at: psramaddress, value: psrcbuff!.pointee)
        psrcbuff = psrcbuff!.advanced(by: Int(1))
        psramaddress = psramaddress &+ ((1) &* 4)
        size = size &- (1)
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
}
