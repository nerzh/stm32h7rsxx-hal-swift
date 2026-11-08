// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func transmit(_ pData: UnsafePointer<UInt8>?, _ Timeout: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {

    var status: HALStatus
    let tickstart: UInt32 = getTick()

    if pData == nil {
      status = .error
      handle.write(.errorCode, value: 0x8)
    } else {
      if handle.read(.state) == 0x4 {
        handle.write(.transferCount, value: registers.read(.dlr) &+ 1)
        handle.write(.transferSize, value: handle.read(.transferCount))
        handle.writeBuffer(UnsafeMutablePointer(mutating: pData))

        registers.write(.cr, value: (registers.read(.cr) & ~(0x3000_0000)) | (0x0))
        repeat {
          status = waitOnFlag(0x4, 1, tickstart, Timeout, getTick: getTick)
          if status != .ok {
            break
          }
          registers.write8(
            .dr, value: UInt8(truncatingIfNeeded: UInt32(handle.readBuffer()!.pointee)))
          handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
          handle.write(.transferCount, value: handle.read(.transferCount) &- (1))
        } while handle.read(.transferCount) > 0
        if status == .ok {
          status = waitOnFlag(0x2, 1, tickstart, Timeout, getTick: getTick)
          if status == .ok {
            clearFlags(0x2)
            handle.write(.state, value: 0x2)
          }
        }
      } else {
        status = .error
        handle.write(.errorCode, value: 0x10)
      }
    }
    return status

  }
  public func receive(
    _ pData: UnsafeMutablePointer<UInt8>?, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var status: HALStatus
    let tickstart: UInt32 = getTick()
    let addr_reg: UInt32 = registers.read(.ar)
    let ir_reg: UInt32 = registers.read(.ir)

    if pData == nil {
      status = .error
      handle.write(.errorCode, value: 0x8)
    } else {
      if handle.read(.state) == 0x4 {
        handle.write(.transferCount, value: registers.read(.dlr) &+ 1)
        handle.write(.transferSize, value: handle.read(.transferCount))
        handle.writeBuffer(pData)

        registers.write(.cr, value: (registers.read(.cr) & ~(0x3000_0000)) | (0x1000_0000))

        if handle.read(.memoryType) == 0x4000000 {
          registers.write(.ar, value: addr_reg)
        } else {
          if (registers.read(.ccr) & 0x700) != 0x0 {
            registers.write(.ar, value: addr_reg)
          } else {
            registers.write(.ir, value: ir_reg)
          }
        }
        repeat {
          status = waitOnFlag((0x4 | 0x2), 1, tickstart, Timeout, getTick: getTick)
          if status != .ok {
            break
          }
          handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: UInt32(registers.read8(.dr)))
          handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
          handle.write(.transferCount, value: handle.read(.transferCount) &- (1))
        } while handle.read(.transferCount) > 0
        if status == .ok {
          status = waitOnFlag(0x2, 1, tickstart, Timeout, getTick: getTick)
          if status == .ok {
            clearFlags(0x2)
            handle.write(.state, value: 0x2)
          }
        }
      } else {
        status = .error
        handle.write(.errorCode, value: 0x10)
      }
    }
    return status

  }
  public func transmitInterrupt(_ pData: UnsafePointer<UInt8>?) -> HALStatus {

    var status: HALStatus = .ok

    if pData == nil {
      status = .error
      handle.write(.errorCode, value: 0x8)
    } else {
      if handle.read(.state) == 0x4 {
        handle.write(.transferCount, value: registers.read(.dlr) &+ 1)
        handle.write(.transferSize, value: handle.read(.transferCount))
        handle.writeBuffer(UnsafeMutablePointer(mutating: pData))

        registers.write(.cr, value: (registers.read(.cr) & ~(0x3000_0000)) | (0x0))

        clearFlags(0x1 | 0x2)

        handle.write(.state, value: 0x18)

        enableInterrupts(0x20000 | 0x40000 | 0x10000)
      } else {
        status = .error
        handle.write(.errorCode, value: 0x10)
      }
    }
    return status

  }
  public func receiveInterrupt(_ pData: UnsafeMutablePointer<UInt8>?) -> HALStatus {

    var status: HALStatus = .ok
    let addr_reg: UInt32 = registers.read(.ar)
    let ir_reg: UInt32 = registers.read(.ir)

    if pData == nil {
      status = .error
      handle.write(.errorCode, value: 0x8)
    } else {
      if handle.read(.state) == 0x4 {
        handle.write(.transferCount, value: registers.read(.dlr) &+ 1)
        handle.write(.transferSize, value: handle.read(.transferCount))
        handle.writeBuffer(pData)

        registers.write(.cr, value: (registers.read(.cr) & ~(0x3000_0000)) | (0x1000_0000))

        clearFlags(0x1 | 0x2)

        handle.write(.state, value: 0x28)

        enableInterrupts(0x20000 | 0x40000 | 0x10000)

        if handle.read(.memoryType) == 0x4000000 {
          registers.write(.ar, value: addr_reg)
        } else {
          if (registers.read(.ccr) & 0x700) != 0x0 {
            registers.write(.ar, value: addr_reg)
          } else {
            registers.write(.ir, value: ir_reg)
          }
        }
      } else {
        status = .error
        handle.write(.errorCode, value: 0x10)
      }
    }
    return status

  }
}
