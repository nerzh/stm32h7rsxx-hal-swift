// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func getDelayValue(_ pCfg: inout XSPICalibrationConfiguration) -> HALStatus {

    var status: HALStatus = .ok
    var reg: UInt32 = 0
    if registers.instance == .xspi1 || registers.instance == .xspi2 {

      switch pCfg.delayValueType
      {
      case 0x0:
        reg = registers.read(.calfcr)
        pCfg.maxCalibration = (reg & 0x8000_0000)
        break
      case 0x1:
        reg = registers.read(.calmr)
        break
      case 0x2:
        reg = registers.read(.calsor)
        break
      case 0x3:
        reg = registers.read(.calsir)
        break
      default:
        status = .error
        handle.write(.errorCode, value: 0x8)
        break
      }
      if status == .ok {
        pCfg.fineCalibrationUnit = (reg & 0x7f)
        pCfg.coarseCalibrationUnit = ((reg & 0x1f0000) >> 0x10)
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x8)
    }
    return status

  }
  public func setDelayValue(_ pCfg: XSPICalibrationConfiguration) -> HALStatus {

    var status: HALStatus = .ok
    if registers.instance == .xspi1 || registers.instance == .xspi2 {

      if (handle.read(.state) & 0x8) == 0 {
        switch pCfg.delayValueType
        {
        case 0x1:
          registers.write(
            .calmr,
            value: (registers.read(.calmr) & ~((0x1f0000 | 0x7f)))
              | ((pCfg.fineCalibrationUnit | (pCfg.coarseCalibrationUnit << 0x10))))
          break
        case 0x2:
          registers.write(
            .calsor,
            value: (registers.read(.calsor) & ~((0x1f0000 | 0x7f)))
              | ((pCfg.fineCalibrationUnit | (pCfg.coarseCalibrationUnit << 0x10))))
          break
        case 0x3:
          registers.write(
            .calsir,
            value: (registers.read(.calsir) & ~((0x1f0000 | 0x7f)))
              | ((pCfg.fineCalibrationUnit | (pCfg.coarseCalibrationUnit << 0x10))))
          break
        default:
          status = .error
          handle.write(.errorCode, value: 0x8)
          break
        }
      } else {
        status = .error
        handle.write(.errorCode, value: 0x10)
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x8)
    }
    return status

  }
}
