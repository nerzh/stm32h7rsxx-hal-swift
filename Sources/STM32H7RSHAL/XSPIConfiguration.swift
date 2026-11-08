// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func initialize(getTick: () -> UInt32) -> HALStatus {

    var status: HALStatus = .ok
    let tickstart: UInt32 = getTick()

    do {

      handle.write(.errorCode, value: 0x0)

      if handle.read(.state) == 0x0 {
        if useRegisteredCallbacks {
          callbacks.write(.error, value: defaults.error)
          callbacks.write(.abortComplete, value: defaults.abortComplete)
          callbacks.write(.fifoThreshold, value: defaults.fifoThreshold)
          callbacks.write(.commandComplete, value: defaults.commandComplete)
          callbacks.write(.receiveComplete, value: defaults.receiveComplete)
          callbacks.write(.transmitComplete, value: defaults.transmitComplete)
          callbacks.write(.receiveHalfComplete, value: defaults.receiveHalfComplete)
          callbacks.write(.transmitHalfComplete, value: defaults.transmitHalfComplete)
          callbacks.write(.statusMatch, value: defaults.statusMatch)
          callbacks.write(.timeout, value: defaults.timeout)
          if callbacks.read(.mspInitialize) == nil {
            callbacks.write(.mspInitialize, value: defaults.mspInitialize)
          }

          callbacks.read(.mspInitialize)!(callbacks.context)
        } else {
          defaults.mspInitialize(callbacks.context)
        }

        _ = setTimeout(0x1388)

        registers.write(
          .dcr1,
          value: (registers.read(.dcr1) & ~((0x7000000 | 0x1f0000 | 0x3f00 | 0x2 | 0x1)))
            | ((handle.read(.memoryType) | ((handle.read(.memorySize)) << 0x10)
              | ((handle.read(.chipSelectHighTimeCycle) &- 1) << 0x8) | handle.read(.clockMode))))

        registers.write(
          .dcr2, value: (registers.read(.dcr2) & ~(0x70000)) | (handle.read(.wrapSize)))

        registers.write(
          .dcr3,
          value: (registers.read(.dcr3) & ~(0x1f0000))
            | ((handle.read(.chipSelectBoundary) << 0x10)))

        registers.write(
          .dcr3, value: (registers.read(.dcr3) & ~(0xff)) | ((handle.read(.maxTran) << 0x0)))

        registers.write(.dcr4, value: handle.read(.refresh))

        registers.write(
          .cr,
          value: (registers.read(.cr) & ~(0x1f00))
            | (((handle.read(.fifoThresholdByte) &- 1) << 0x8)))

        status = waitOnFlag(0x20, 0, tickstart, handle.read(.timeout), getTick: getTick)
        if status == .ok {
          registers.write(
            .dcr2,
            value: (registers.read(.dcr2) & ~(0xff)) | (((handle.read(.clockPrescaler)) << 0x0)))
          if registers.instance == .xspi1 || registers.instance == .xspi2 {
            status = waitOnFlag(0x20, 0, tickstart, handle.read(.timeout), getTick: getTick)
            if status != .ok {
              return status
            }
          }
          registers.write(
            .cr,
            value: (registers.read(.cr) & ~((0x40 | 0x1000000)))
              | ((handle.read(.memoryMode) | handle.read(.memorySelect))))

          registers.write(
            .tcr, value: (registers.read(.tcr) & ~((0x4000_0000))) | (handle.read(.sampleShifting)))

          enable()

          if handle.read(.freeRunningClock) == 0x2 {
            registers.write(.dcr1, value: registers.read(.dcr1) | (0x2))
          }

          if handle.read(.memoryType) == 0x4000000 {
            handle.write(.state, value: 0x1)
          } else {
            handle.write(.state, value: 0x2)
          }
        }
      }
    }
    return status

  }
  public func deinitialize() -> HALStatus {

    let status: HALStatus = .ok

    do {
      disable()

      registers.write(.dcr1, value: registers.read(.dcr1) & (~(0x2)))
      if useRegisteredCallbacks {
        if callbacks.read(.mspDeinitialize) == nil {
          callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        }

        callbacks.read(.mspDeinitialize)!(callbacks.context)
      } else {
        defaults.mspDeinitialize(callbacks.context)
      }

      handle.write(.state, value: 0x0)
    }
    return status

  }
  public func registerCallback(_ CallbackID: UInt32, _ pCallback: XSPICallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
      return .error
    }
    if handle.read(.state) == 0x2 {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.error, value: pCallback)
        break
      case 0x1:
        callbacks.write(.abortComplete, value: pCallback)
        break
      case 0x2:
        callbacks.write(.fifoThreshold, value: pCallback)
        break
      case 0x3:
        callbacks.write(.commandComplete, value: pCallback)
        break
      case 0x4:
        callbacks.write(.receiveComplete, value: pCallback)
        break
      case 0x5:
        callbacks.write(.transmitComplete, value: pCallback)
        break
      case 0x6:
        callbacks.write(.receiveHalfComplete, value: pCallback)
        break
      case 0x7:
        callbacks.write(.transmitHalfComplete, value: pCallback)
        break
      case 0x8:
        callbacks.write(.statusMatch, value: pCallback)
        break
      case 0x9:
        callbacks.write(.timeout, value: pCallback)
        break
      case 0xa:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0xb:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        status = .error
        break
      }
    } else if handle.read(.state) == 0x0 {
      switch CallbackID
      {
      case 0xa:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0xb:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        status = .error
        break
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
      status = .error
    }
    return status

  }
  public func unregisterCallback(_ CallbackID: UInt32) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if handle.read(.state) == 0x2 {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.error, value: defaults.error)
        break
      case 0x1:
        callbacks.write(.abortComplete, value: defaults.abortComplete)
        break
      case 0x2:
        callbacks.write(.fifoThreshold, value: defaults.fifoThreshold)
        break
      case 0x3:
        callbacks.write(.commandComplete, value: defaults.commandComplete)
        break
      case 0x4:
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        break
      case 0x5:
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        break
      case 0x6:
        callbacks.write(.receiveHalfComplete, value: defaults.receiveHalfComplete)
        break
      case 0x7:
        callbacks.write(.transmitHalfComplete, value: defaults.transmitHalfComplete)
        break
      case 0x8:
        callbacks.write(.statusMatch, value: defaults.statusMatch)
        break
      case 0x9:
        callbacks.write(.timeout, value: defaults.timeout)
        break
      case 0xa:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0xb:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        status = .error
        break
      }
    } else if handle.read(.state) == 0x0 {
      switch CallbackID
      {
      case 0xa:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0xb:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        status = .error
        break
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
      status = .error
    }
    return status

  }
}
