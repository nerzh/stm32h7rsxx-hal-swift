// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func addDescriptorsToFrame(
    _ pCCCDesc: UnsafePointer<I3CCCCDescriptor>?,
    _ pPrivateDesc: UnsafePointer<I3CPrivateDescriptor>?,
    _ pXferData: UnsafeMutablePointer<I3CTransfer>?, _ nbFrame: UInt8, _ option: UInt32
  ) -> HALStatus {
    let nbFrame = UInt32(nbFrame)

    var handle_state: UInt32
    var status: HALStatus = .ok

    do {
      handle_state = handle.read(.state)

      handle.write(.errorCode, value: 0x0)
      handle.writeCCCDescriptors(pCCCDesc)
      handle.writePrivateDescriptors(pPrivateDesc)
      handle.writeTransfer(pXferData)
      handle.write(.receiveTransferCount, value: 0)
      handle.write(.transmitTransferCount, value: 0)

      if ((option & 0x7800_0000) == 0x3000_0000) || ((option & 0x7800_0000) == 0x1800_0000) {
        if (pCCCDesc == nil) || (pXferData == nil) || (nbFrame < 1)
          || (((option & (0x7800_0000 | 0x1)) == (0x1800_0000 | 0x1))
            && (pCCCDesc!.pointee.cccBuffer.size == 0))
        {
          handle.write(.errorCode, value: 0x80000)
          status = .error
        }
      } else {
        if (pPrivateDesc == nil) || (pXferData == nil) || (nbFrame <= 0) {
          handle.write(.errorCode, value: 0x80000)
          status = .error
        }
      }
      if status == .ok {
        if (handle_state == 0x10) || (handle_state == 0x30) {
          if prepareControlBuffer(UInt8(truncatingIfNeeded: nbFrame), option) != .ok {
            handle.write(.errorCode, value: 0x80000)
            status = .error
          }

          if prepareTransfer(UInt8(truncatingIfNeeded: nbFrame), option) != .ok {
            status = .error
          }
        } else {
          status = .busy
        }
      }
    }
    return status

  }
  func prepareTransfer(_ counter: UInt8, _ option: UInt32) -> HALStatus {
    let counter = UInt32(counter)

    var status: HALStatus = .ok
    var current_tx_index: UInt32 = 0
    var global_tx_size: UInt32 = 0
    var global_rx_size: UInt32 = 0
    var nb_tx_frame: UInt32 = 0
    var direction: UInt32
    do {
      var descr_index: UInt32 = 0
      while descr_index < counter {

        if (option & 0x7800_0000) == 0x1800_0000 {
          direction = handle.readCCCDescriptors()![Int(descr_index)].direction

          if ((option & 0x1) != 0) && (direction == 0x10000) {
            nb_tx_frame &+= 1
            global_tx_size &+= 1
            global_rx_size &+= handle.readCCCDescriptors()![Int(descr_index)].cccBuffer.size &- 1

            if (global_tx_size > handle.readTransfer()!.pointee.transmitBuffer.size)
              || (current_tx_index > handle.readTransfer()!.pointee.transmitBuffer.size)
              || (handle.readTransfer()!.pointee.transmitBuffer.buffer == nil)
            {
              handle.write(.errorCode, value: 0x80000)
              status = .error
            } else {
              current_tx_index = fillCCCTransmitBuffer(descr_index, 1, current_tx_index)
            }
          } else if direction == 0x0 {
            nb_tx_frame &+= 1
            global_tx_size &+= handle.readCCCDescriptors()![Int(descr_index)].cccBuffer.size

            if (global_tx_size > handle.readTransfer()!.pointee.transmitBuffer.size)
              || (current_tx_index > handle.readTransfer()!.pointee.transmitBuffer.size)
              || (handle.readTransfer()!.pointee.transmitBuffer.buffer == nil)
            {
              handle.write(.errorCode, value: 0x80000)
              status = .error
            } else {
              current_tx_index = fillCCCTransmitBuffer(
                descr_index, handle.readCCCDescriptors()![Int(descr_index)].cccBuffer.size,
                current_tx_index)
            }
          } else {
            global_rx_size &+= handle.readCCCDescriptors()![Int(descr_index)].cccBuffer.size
          }
        } else if (option & 0x7800_0000) == 0x3000_0000 {
          direction = handle.readCCCDescriptors()![Int(descr_index)].direction
          if direction == 0x0 {
            nb_tx_frame &+= 1
            global_tx_size &+= handle.readCCCDescriptors()![Int(descr_index)].cccBuffer.size

            if (global_tx_size > handle.readTransfer()!.pointee.transmitBuffer.size)
              || (current_tx_index > handle.readTransfer()!.pointee.transmitBuffer.size)
              || (handle.readTransfer()!.pointee.transmitBuffer.buffer == nil)
            {
              handle.write(.errorCode, value: 0x80000)
              status = .error
            } else {
              current_tx_index = fillCCCTransmitBuffer(
                descr_index, handle.readCCCDescriptors()![Int(descr_index)].cccBuffer.size,
                current_tx_index)
            }
          } else {
            status = .error
          }
        } else {
          direction = handle.readPrivateDescriptors()![Int(descr_index)].direction
          if direction == 0x0 {
            nb_tx_frame &+= 1
            global_tx_size &+=
              handle.readPrivateDescriptors()![Int(descr_index)].transmitBuffer.size

            if (global_tx_size > handle.readTransfer()!.pointee.transmitBuffer.size)
              || (current_tx_index > handle.readTransfer()!.pointee.transmitBuffer.size)
              || (handle.readTransfer()!.pointee.transmitBuffer.buffer == nil)
            {
              handle.write(.errorCode, value: 0x80000)
              status = .error
            } else {
              current_tx_index = fillPrivateTransmitBuffer(
                descr_index, handle.readPrivateDescriptors()![Int(descr_index)].transmitBuffer.size,
                current_tx_index)
            }
          } else {
            global_rx_size &+= handle.readPrivateDescriptors()![Int(descr_index)].receiveBuffer.size
          }
        }

        if status == .error {
          break
        }
        descr_index &+= 1
      }
    }
    if status == .ok {
      if llGetTxFIFOThreshold() == 0x4000 {
        if nb_tx_frame > 1 {
          handle.write(.errorCode, value: 0x200000)
          status = .error
        }
      }
    }
    if status == .ok {
      if global_rx_size > handle.readTransfer()!.pointee.receiveBuffer.size {
        handle.write(.errorCode, value: 0x80000)
        status = .error
      } else {
        handle.write(.receiveTransferCount, value: global_rx_size)
      }

      handle.write(.transmitTransferCount, value: global_tx_size)
    }
    return status

  }
  func fillCCCTransmitBuffer(_ indexDesc: UInt32, _ txSize: UInt32, _ txCurrentIndex: UInt32)
    -> UInt32
  {

    var index_tx: UInt32 = txCurrentIndex
    do {
      var index: UInt32 = 0
      while index < txSize {
        handle.readTransfer()!.pointee.transmitBuffer.buffer![Int(index_tx)] = UInt8(
          truncatingIfNeeded: UInt32(
            handle.readCCCDescriptors()![Int(indexDesc)].cccBuffer.buffer![Int(index)]))
        index_tx = index_tx &+ (1)
        index &+= 1
      }
    }
    return index_tx

  }
  func fillPrivateTransmitBuffer(_ indexDesc: UInt32, _ txSize: UInt32, _ txCurrentIndex: UInt32)
    -> UInt32
  {

    var index_tx: UInt32 = txCurrentIndex
    do {
      var index: UInt32 = 0
      while index < txSize {
        handle.readTransfer()!.pointee.transmitBuffer.buffer![Int(index_tx)] = UInt8(
          truncatingIfNeeded: UInt32(
            handle.readPrivateDescriptors()![Int(indexDesc)].transmitBuffer.buffer![Int(index)]))
        index_tx = index_tx &+ (1)
        index &+= 1
      }
    }
    return index_tx

  }
  func prepareControlBuffer(_ counter: UInt8, _ option: UInt32) -> HALStatus {
    let counter = UInt32(counter)

    var status: HALStatus = .ok
    var nb_define_bytes: UInt32
    var stop_condition: UInt32
    var nb_data_bytes: UInt32
    var index: UInt32

    if handle.readTransfer()!.pointee.controlBuffer.buffer == nil {
      handle.write(.errorCode, value: 0x80000)
      status = .error
    } else {
      nb_define_bytes = (option & 0x1)
      stop_condition = (option & 0x8000_0000)

      if (option & 0x4) == 0x4 {
        llDisableArbitrationHeader()
      } else {
        llEnableArbitrationHeader()
      }

      if (option & 0x7800_0000) == 0x3000_0000 {

        if handle.readTransfer()!.pointee.controlBuffer.size < UInt32(truncatingIfNeeded: counter) {
          handle.write(.errorCode, value: 0x80000)
          status = .error
        } else {
          handle.write(.controlTransferCount, value: UInt32(truncatingIfNeeded: counter))

          do {
            index = 0
            while index < (UInt32(truncatingIfNeeded: counter) &- 1) {

              handle.readTransfer()!.pointee.controlBuffer.buffer![Int(index)] =
                (UInt32(truncatingIfNeeded: handle.readCCCDescriptors()![Int(index)].cccBuffer.size)
                  | (UInt32(
                    truncatingIfNeeded: UInt32(handle.readCCCDescriptors()![Int(index)].ccc))
                    << 0x10) | 0x3000_0000 | stop_condition)
              index &+= 1
            }
          }

          handle.readTransfer()!.pointee.controlBuffer.buffer![Int(index)] =
            (UInt32(truncatingIfNeeded: handle.readCCCDescriptors()![Int(index)].cccBuffer.size)
              | (UInt32(truncatingIfNeeded: UInt32(handle.readCCCDescriptors()![Int(index)].ccc))
                << 0x10) | 0x3000_0000 | 0x8000_0000)
        }
      } else if (option & 0x7800_0000) == 0x1800_0000 {

        if handle.readTransfer()!.pointee.controlBuffer.size
          < (UInt32(truncatingIfNeeded: counter) &* 2)
        {
          handle.write(.errorCode, value: 0x80000)
          status = .error
        } else {
          handle.write(.controlTransferCount, value: (UInt32(truncatingIfNeeded: counter) &* 2))

          do {
            index = 0
            while index < ((UInt32(truncatingIfNeeded: counter) &* 2) &- 2) {

              handle.readTransfer()!.pointee.controlBuffer.buffer![Int(index)] =
                (nb_define_bytes
                  | (UInt32(
                    truncatingIfNeeded: UInt32(handle.readCCCDescriptors()![Int(index / 2)].ccc))
                    << 0x10) | 0x3000_0000 | 0x0)

              handle.readTransfer()!.pointee.controlBuffer.buffer![Int(index &+ 1)] =
                ((UInt32(
                  truncatingIfNeeded: handle.readCCCDescriptors()![Int(index / 2)].cccBuffer.size)
                  &- nb_define_bytes) | handle.readCCCDescriptors()![Int(index / 2)].direction
                  | (UInt32(
                    truncatingIfNeeded: UInt32(
                      handle.readCCCDescriptors()![Int(index / 2)].targetAddr)) << 0x11)
                  | 0x1800_0000 | stop_condition)
              index &+= 2
            }
          }

          handle.readTransfer()!.pointee.controlBuffer.buffer![Int(index)] =
            (nb_define_bytes
              | (UInt32(
                truncatingIfNeeded: UInt32(handle.readCCCDescriptors()![Int(index / 2)].ccc))
                << 0x10) | 0x3000_0000 | 0x0)

          handle.readTransfer()!.pointee.controlBuffer.buffer![Int(index &+ 1)] =
            ((UInt32(
              truncatingIfNeeded: handle.readCCCDescriptors()![Int(index / 2)].cccBuffer.size)
              &- nb_define_bytes) | handle.readCCCDescriptors()![Int(index / 2)].direction
              | (UInt32(
                truncatingIfNeeded: UInt32(handle.readCCCDescriptors()![Int(index / 2)].targetAddr))
                << 0x11) | 0x1800_0000 | 0x8000_0000)
        }
      } else {

        if handle.readTransfer()!.pointee.controlBuffer.size < UInt32(truncatingIfNeeded: counter) {
          handle.write(.errorCode, value: 0x80000)
          status = .error
        } else {
          handle.write(.controlTransferCount, value: UInt32(truncatingIfNeeded: counter))

          do {
            index = 0
            while index < (UInt32(truncatingIfNeeded: counter) &- 1) {

              if handle.readPrivateDescriptors()![Int(index)].direction == 0x10000 {
                nb_data_bytes = handle.readPrivateDescriptors()![Int(index)].receiveBuffer.size
              } else {
                nb_data_bytes = handle.readPrivateDescriptors()![Int(index)].transmitBuffer.size
              }

              handle.readTransfer()!.pointee.controlBuffer.buffer![Int(index)] =
                (nb_data_bytes | handle.readPrivateDescriptors()![Int(index)].direction
                  | (UInt32(
                    truncatingIfNeeded: UInt32(
                      handle.readPrivateDescriptors()![Int(index)].targetAddr)) << 0x11)
                  | (option & 0x7800_0000) | stop_condition)
              index &+= 1
            }
          }

          if handle.readPrivateDescriptors()![Int(index)].direction == 0x10000 {
            nb_data_bytes = handle.readPrivateDescriptors()![Int(index)].receiveBuffer.size
          } else {
            nb_data_bytes = handle.readPrivateDescriptors()![Int(index)].transmitBuffer.size
          }

          handle.readTransfer()!.pointee.controlBuffer.buffer![Int(index)] =
            (nb_data_bytes | handle.readPrivateDescriptors()![Int(index)].direction
              | (UInt32(
                truncatingIfNeeded: UInt32(handle.readPrivateDescriptors()![Int(index)].targetAddr))
                << 0x11) | (option & 0x7800_0000) | 0x8000_0000)
        }
      }
    }
    return status

  }
}
