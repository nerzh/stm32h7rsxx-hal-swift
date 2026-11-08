// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NAND operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension NAND {
  public func readPages8(
    _ pAddress: UnsafePointer<NANDAddress>?, _ pBuffer: UnsafeMutablePointer<UInt8>?,
    _ NumPageToRead: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var index: UInt32 = 0
    var tickstart: UInt32 = 0
    var deviceaddress: UInt32 = 0
    var nandaddress: UInt32 = 0
    var nbpages: UInt32 = 0
    var buff: UnsafeMutablePointer<UInt8>? = nil

    nbpages = NumPageToRead
    buff = pBuffer

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      nandaddress =
        (UInt32(pAddress!.pointee.page)
          &+ ((UInt32(pAddress!.pointee.block)
            &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
            &* handle.read(.blockSize)))

      while (nbpages != 0)
        && (nandaddress < ((handle.read(.blockSize)) &* (handle.read(.blockCount))))
      {
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x0))
        memory.dataSynchronizationBarrier()

        if (handle.read(.pageSize)) <= 512 {
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        } else {
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        }
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x30))
        memory.dataSynchronizationBarrier()
        if handle.read(.extraCommandEnable) == 0x1 {
          tickstart = getTick()

          while readStatus() != 0x40 {
            if (getTick() &- tickstart) > 0x1000000 {
              handle.write(.state, value: 0x3)

              handle.write(.lock, value: 0)
              return .timeout
            }
          }

          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: 0x00)))))
          memory.dataSynchronizationBarrier()
        }

        index = 0
        while index < handle.read(.pageSize) {
          buff!.pointee = UInt8(truncatingIfNeeded: UInt32(memory.read8(at: deviceaddress)))
          buff = buff!.advanced(by: Int(1))
          index = index &+ (1)
        }

        nbpages = nbpages &- (1)

        nandaddress = UInt32(truncatingIfNeeded: (nandaddress &+ 1))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func readPages16(
    _ pAddress: UnsafePointer<NANDAddress>?, _ pBuffer: UnsafeMutablePointer<UInt16>?,
    _ NumPageToRead: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var index: UInt32 = 0
    var tickstart: UInt32 = 0
    var deviceaddress: UInt32 = 0
    var nandaddress: UInt32 = 0
    var nbpages: UInt32 = 0
    var buff: UnsafeMutablePointer<UInt16>? = nil

    nbpages = NumPageToRead
    buff = pBuffer

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      nandaddress =
        (UInt32(pAddress!.pointee.page)
          &+ ((UInt32(pAddress!.pointee.block)
            &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
            &* handle.read(.blockSize)))

      while (nbpages != 0)
        && (nandaddress < ((handle.read(.blockSize)) &* (handle.read(.blockCount))))
      {
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x0))
        memory.dataSynchronizationBarrier()

        if (handle.read(.pageSize)) <= 512 {
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        } else {
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        }
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x30))
        memory.dataSynchronizationBarrier()
        if handle.read(.extraCommandEnable) == 0x1 {
          tickstart = getTick()

          while readStatus() != 0x40 {
            if (getTick() &- tickstart) > 0x1000000 {
              handle.write(.state, value: 0x3)

              handle.write(.lock, value: 0)
              return .timeout
            }
          }

          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: 0x00)))))
          memory.dataSynchronizationBarrier()
        }

        if handle.read(.memoryDataWidth) == 0x0 {
          handle.write(.pageSize, value: handle.read(.pageSize) / 2)
        } else {

        }

        index = 0
        while index < handle.read(.pageSize) {
          buff!.pointee = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: deviceaddress)))
          buff = buff!.advanced(by: Int(1))
          index = index &+ (1)
        }

        nbpages = nbpages &- (1)

        nandaddress = UInt32(truncatingIfNeeded: (nandaddress &+ 1))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func writePages8(
    _ pAddress: UnsafePointer<NANDAddress>?, _ pBuffer: UnsafePointer<UInt8>?,
    _ NumPageToWrite: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var index: UInt32 = 0
    var tickstart: UInt32 = 0
    var deviceaddress: UInt32 = 0
    var nandaddress: UInt32 = 0
    var nbpages: UInt32 = 0
    var buff: UnsafePointer<UInt8>? = nil

    nbpages = NumPageToWrite
    buff = pBuffer

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      nandaddress =
        (UInt32(pAddress!.pointee.page)
          &+ ((UInt32(pAddress!.pointee.block)
            &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
            &* handle.read(.blockSize)))

      while (nbpages != 0)
        && (nandaddress < ((handle.read(.blockSize)) &* (handle.read(.blockCount))))
      {
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x0))
        memory.dataSynchronizationBarrier()
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x80))
        memory.dataSynchronizationBarrier()

        if (handle.read(.pageSize)) <= 512 {
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        } else {
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        }

        index = 0
        while index < handle.read(.pageSize) {
          memory.write8(at: deviceaddress, value: UInt8(truncatingIfNeeded: UInt32(buff!.pointee)))
          buff = buff!.advanced(by: Int(1))
          memory.dataSynchronizationBarrier()
          index = index &+ (1)
        }
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x10))
        memory.dataSynchronizationBarrier()

        tickstart = getTick()

        while readStatus() != 0x40 {
          if (getTick() &- tickstart) > 0x1000000 {
            handle.write(.state, value: 0x3)

            handle.write(.lock, value: 0)
            return .timeout
          }
        }

        nbpages = nbpages &- (1)

        nandaddress = UInt32(truncatingIfNeeded: (nandaddress &+ 1))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func writePages16(
    _ pAddress: UnsafePointer<NANDAddress>?, _ pBuffer: UnsafePointer<UInt16>?,
    _ NumPageToWrite: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var index: UInt32 = 0
    var tickstart: UInt32 = 0
    var deviceaddress: UInt32 = 0
    var nandaddress: UInt32 = 0
    var nbpages: UInt32 = 0
    var buff: UnsafePointer<UInt16>? = nil

    nbpages = NumPageToWrite
    buff = pBuffer

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      nandaddress =
        (UInt32(pAddress!.pointee.page)
          &+ ((UInt32(pAddress!.pointee.block)
            &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
            &* handle.read(.blockSize)))

      while (nbpages != 0)
        && (nandaddress < ((handle.read(.blockSize)) &* (handle.read(.blockCount))))
      {
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x0))
        memory.dataSynchronizationBarrier()
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x80))
        memory.dataSynchronizationBarrier()

        if (handle.read(.pageSize)) <= 512 {
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        } else {
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        }

        if handle.read(.memoryDataWidth) == 0x0 {
          handle.write(.pageSize, value: handle.read(.pageSize) / 2)
        } else {

        }

        index = 0
        while index < handle.read(.pageSize) {
          memory.write16(
            at: deviceaddress, value: UInt16(truncatingIfNeeded: UInt32(buff!.pointee)))
          buff = buff!.advanced(by: Int(1))
          memory.dataSynchronizationBarrier()
          index = index &+ (1)
        }
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x10))
        memory.dataSynchronizationBarrier()

        tickstart = getTick()

        while readStatus() != 0x40 {
          if (getTick() &- tickstart) > 0x1000000 {
            handle.write(.state, value: 0x3)

            handle.write(.lock, value: 0)
            return .timeout
          }
        }

        nbpages = nbpages &- (1)

        nandaddress = UInt32(truncatingIfNeeded: (nandaddress &+ 1))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func readSpareArea8(
    _ pAddress: UnsafePointer<NANDAddress>?, _ pBuffer: UnsafeMutablePointer<UInt8>?,
    _ NumSpareAreaToRead: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var index: UInt32 = 0
    var tickstart: UInt32 = 0
    var deviceaddress: UInt32 = 0
    var nandaddress: UInt32 = 0
    var columnaddress: UInt32 = 0
    var nbspare: UInt32 = 0
    var buff: UnsafeMutablePointer<UInt8>? = nil

    nbspare = NumSpareAreaToRead
    buff = pBuffer

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      nandaddress =
        (UInt32(pAddress!.pointee.page)
          &+ ((UInt32(pAddress!.pointee.block)
            &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
            &* handle.read(.blockSize)))

      columnaddress = handle.read(.pageSize)

      while (nbspare != 0)
        && (nandaddress < ((handle.read(.blockSize)) &* (handle.read(.blockCount))))
      {
        if (handle.read(.pageSize)) <= 512 {
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x50))
          memory.dataSynchronizationBarrier()
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        } else {
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x0))
          memory.dataSynchronizationBarrier()
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress & 0xFF))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress & 0xFF))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        }
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x30))
        memory.dataSynchronizationBarrier()
        if handle.read(.extraCommandEnable) == 0x1 {
          tickstart = getTick()

          while readStatus() != 0x40 {
            if (getTick() &- tickstart) > 0x1000000 {
              handle.write(.state, value: 0x3)

              handle.write(.lock, value: 0)
              return .timeout
            }
          }

          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: 0x00)))))
          memory.dataSynchronizationBarrier()
        }

        index = 0
        while index < handle.read(.spareAreaSize) {
          buff!.pointee = UInt8(truncatingIfNeeded: UInt32(memory.read8(at: deviceaddress)))
          buff = buff!.advanced(by: Int(1))
          index = index &+ (1)
        }

        nbspare = nbspare &- (1)

        nandaddress = UInt32(truncatingIfNeeded: (nandaddress &+ 1))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func readSpareArea16(
    _ pAddress: UnsafePointer<NANDAddress>?, _ pBuffer: UnsafeMutablePointer<UInt16>?,
    _ NumSpareAreaToRead: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var index: UInt32 = 0
    var tickstart: UInt32 = 0
    var deviceaddress: UInt32 = 0
    var nandaddress: UInt32 = 0
    var columnaddress: UInt32 = 0
    var nbspare: UInt32 = 0
    var buff: UnsafeMutablePointer<UInt16>? = nil

    nbspare = NumSpareAreaToRead
    buff = pBuffer

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      nandaddress =
        (UInt32(pAddress!.pointee.page)
          &+ ((UInt32(pAddress!.pointee.block)
            &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
            &* handle.read(.blockSize)))

      columnaddress = UInt32(truncatingIfNeeded: (handle.read(.pageSize)))

      while (nbspare != 0)
        && (nandaddress < ((handle.read(.blockSize)) &* (handle.read(.blockCount))))
      {
        if (handle.read(.pageSize)) <= 512 {
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x50))
          memory.dataSynchronizationBarrier()
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        } else {
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x0))
          memory.dataSynchronizationBarrier()
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress & 0xFF))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress & 0xFF))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        }
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x30))
        memory.dataSynchronizationBarrier()
        if handle.read(.extraCommandEnable) == 0x1 {
          tickstart = getTick()

          while readStatus() != 0x40 {
            if (getTick() &- tickstart) > 0x1000000 {
              handle.write(.state, value: 0x3)

              handle.write(.lock, value: 0)
              return .timeout
            }
          }

          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: 0x00)))))
          memory.dataSynchronizationBarrier()
        }

        index = 0
        while index < handle.read(.spareAreaSize) {
          buff!.pointee = UInt16(truncatingIfNeeded: UInt32(memory.read16(at: deviceaddress)))
          buff = buff!.advanced(by: Int(1))
          index = index &+ (1)
        }

        nbspare = nbspare &- (1)

        nandaddress = UInt32(truncatingIfNeeded: (nandaddress &+ 1))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func writeSpareArea8(
    _ pAddress: UnsafePointer<NANDAddress>?, _ pBuffer: UnsafePointer<UInt8>?,
    _ NumSpareAreaTowrite: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var index: UInt32 = 0
    var tickstart: UInt32 = 0
    var deviceaddress: UInt32 = 0
    var nandaddress: UInt32 = 0
    var columnaddress: UInt32 = 0
    var nbspare: UInt32 = 0
    var buff: UnsafePointer<UInt8>? = nil

    nbspare = NumSpareAreaTowrite
    buff = pBuffer

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      nandaddress =
        (UInt32(pAddress!.pointee.page)
          &+ ((UInt32(pAddress!.pointee.block)
            &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
            &* handle.read(.blockSize)))

      columnaddress = handle.read(.pageSize)

      while (nbspare != 0)
        && (nandaddress < ((handle.read(.blockSize)) &* (handle.read(.blockCount))))
      {
        if (handle.read(.pageSize)) <= 512 {
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x50))
          memory.dataSynchronizationBarrier()
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x80))
          memory.dataSynchronizationBarrier()
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        } else {
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x0))
          memory.dataSynchronizationBarrier()
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x80))
          memory.dataSynchronizationBarrier()
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress & 0xFF))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress & 0xFF))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        }

        index = 0
        while index < handle.read(.spareAreaSize) {
          memory.write8(at: deviceaddress, value: UInt8(truncatingIfNeeded: UInt32(buff!.pointee)))
          buff = buff!.advanced(by: Int(1))
          memory.dataSynchronizationBarrier()
          index = index &+ (1)
        }
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x10))
        memory.dataSynchronizationBarrier()

        tickstart = getTick()

        while readStatus() != 0x40 {
          if (getTick() &- tickstart) > 0x1000000 {
            handle.write(.state, value: 0x3)

            handle.write(.lock, value: 0)
            return .timeout
          }
        }

        nbspare = nbspare &- (1)

        nandaddress = UInt32(truncatingIfNeeded: (nandaddress &+ 1))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
  public func writeSpareArea16(
    _ pAddress: UnsafePointer<NANDAddress>?, _ pBuffer: UnsafePointer<UInt16>?,
    _ NumSpareAreaTowrite: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var index: UInt32 = 0
    var tickstart: UInt32 = 0
    var deviceaddress: UInt32 = 0
    var nandaddress: UInt32 = 0
    var columnaddress: UInt32 = 0
    var nbspare: UInt32 = 0
    var buff: UnsafePointer<UInt16>? = nil

    nbspare = NumSpareAreaTowrite
    buff = pBuffer

    if handle.read(.state) == 0x2 {
      return .busy
    } else if handle.read(.state) == 0x1 {
      if handle.read(.lock) == 1 { return .busy }
      handle.write(.lock, value: 1)

      handle.write(.state, value: 0x2)

      deviceaddress = 0x8000_0000

      nandaddress =
        (UInt32(pAddress!.pointee.page)
          &+ ((UInt32(pAddress!.pointee.block)
            &+ (UInt32(pAddress!.pointee.plane) &* handle.read(.planeSize)))
            &* handle.read(.blockSize)))

      columnaddress = UInt32(truncatingIfNeeded: (handle.read(.pageSize)))

      while (nbspare != 0)
        && (nandaddress < ((handle.read(.blockSize)) &* (handle.read(.blockCount))))
      {
        if (handle.read(.pageSize)) <= 512 {
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x50))
          memory.dataSynchronizationBarrier()
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x80))
          memory.dataSynchronizationBarrier()
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: 0x00))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        } else {
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x0))
          memory.dataSynchronizationBarrier()
          memory.write8(
            at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
            value: UInt8(truncatingIfNeeded: 0x80))
          memory.dataSynchronizationBarrier()
          if ((handle.read(.blockSize)) &* (handle.read(.blockCount))) <= 65535 {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress & 0xFF))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
          } else {
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress & 0xFF))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (columnaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 8))))))
            memory.dataSynchronizationBarrier()
            memory.write8(
              at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x20000))),
              value: UInt8(
                truncatingIfNeeded: (UInt32(UInt8(truncatingIfNeeded: (nandaddress >> 16))))))
            memory.dataSynchronizationBarrier()
          }
        }

        index = 0
        while index < handle.read(.spareAreaSize) {
          memory.write16(
            at: deviceaddress, value: UInt16(truncatingIfNeeded: UInt32(buff!.pointee)))
          buff = buff!.advanced(by: Int(1))
          memory.dataSynchronizationBarrier()
          index = index &+ (1)
        }
        memory.write8(
          at: (UInt32(truncatingIfNeeded: (deviceaddress | 0x10000))),
          value: UInt8(truncatingIfNeeded: 0x10))
        memory.dataSynchronizationBarrier()

        tickstart = getTick()

        while readStatus() != 0x40 {
          if (getTick() &- tickstart) > 0x1000000 {
            handle.write(.state, value: 0x3)

            handle.write(.lock, value: 0)
            return .timeout
          }
        }

        nbspare = nbspare &- (1)

        nandaddress = UInt32(truncatingIfNeeded: (nandaddress &+ 1))
      }

      handle.write(.state, value: 0x1)

      handle.write(.lock, value: 0)
    } else {
      return .error
    }
    return .ok

  }
}
