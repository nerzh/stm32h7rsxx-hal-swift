// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func configureManager(_ pCfg: XSPIManagerConfiguration, _ Timeout: UInt32) -> HALStatus {

    let status: HALStatus = .ok
    var xspi_enabled: UInt32 = 0
    var iom0 = XSPIManagerConfiguration()
    var iom1 = XSPIManagerConfiguration()

    _ = Timeout

    getManagerConfiguration(1, &iom0)
    getManagerConfiguration(2, &iom1)

    if (registers.readControl(.xspi1) & 0x1) != 0 {
      registers.writeControl(.xspi1, value: registers.readControl(.xspi1) & (~(0x1)))
      xspi_enabled |= 0x1
    }
    if (registers.readControl(.xspi2) & 0x1) != 0 {
      registers.writeControl(.xspi2, value: registers.readControl(.xspi2) & (~(0x1)))
      xspi_enabled |= 0x2
    }

    if registers.instance == .xspi1 {
      iom0.ioPort = pCfg.ioPort
    } else if registers.instance == .xspi2 {
      iom1.ioPort = pCfg.ioPort
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      return .error
    }

    var reg: UInt32 = registers.readManagerControl()
    var ovr_xspi1: UInt32
    var ovr_xspi2: UInt32
    if (reg & 0x10) == 0x10 {
      if (reg & 0x20) == 0x20 {
        ovr_xspi1 = 0x70
      } else {
        ovr_xspi1 = 0x10
      }
      if (reg & 0x40) == 0x40 {
        ovr_xspi2 = 0x70
      } else {
        ovr_xspi2 = 0x10
      }
    } else {
      ovr_xspi1 = 0x0
      ovr_xspi2 = 0x0
    }

    registers.writeManagerControl(0)

    registers.writeManagerControl(
      (registers.readManagerControl() & ~(0xff0000)) | (((pCfg.req2AckTime &- 1) << 0x10)))

    if registers.instance == .xspi1 {
      ovr_xspi1 = pCfg.nCSOverride
    } else if registers.instance == .xspi2 {
      ovr_xspi2 = pCfg.nCSOverride
    } else {
    }
    var ovr_en: UInt32 = 0
    if (ovr_xspi1 != 0x0) || (ovr_xspi2 != 0x0) {
      ovr_en = 0x10
    } else {
      ovr_xspi1 = 0x10
      ovr_xspi2 = 0x10
    }
    reg &= ~(0x10 | 0x20 | 0x40)
    if ovr_en == 0x10 {
      reg |= 0x10
    }
    if ovr_xspi1 == 0x70 {
      reg |= 0x20
    }
    if ovr_xspi2 == 0x70 {
      reg |= 0x40
    }
    registers.writeManagerControl(
      (registers.readManagerControl() & ~((0x10 | 0x20 | 0x40))) | ((reg & (0x10 | 0x20 | 0x40))))

    do {
      if iom0.ioPort == iom1.ioPort {
        registers.writeManagerControl(registers.readManagerControl() | (0x1))
      } else {
      }
      if iom0.ioPort == 0x1 {
        registers.writeManagerControl(registers.readManagerControl() | (0x2))
      } else {
      }
    }

    if (xspi_enabled & 0x1) != 0 {
      registers.writeControl(.xspi1, value: registers.readControl(.xspi1) | (0x1))
    }
    if (xspi_enabled & 0x2) != 0 {
      registers.writeControl(.xspi2, value: registers.readControl(.xspi2) | (0x1))
    }
    return status

  }
  func getManagerConfiguration(_ instance_nb: UInt8, _ pCfg: inout XSPIManagerConfiguration) {
    let instance_nb = UInt32(instance_nb)

    var mux: UInt32
    var mode: UInt32
    if instance_nb == 1 {
      if (registers.readManagerControl() & 0x2) == 0 {
        pCfg.ioPort = 0x0
      } else {
        pCfg.ioPort = 0x1
      }
      if (registers.readManagerControl() & 0x10) != 0x10 {
        pCfg.nCSOverride = 0x0
      } else if (registers.readManagerControl() & 0x20) == 0x20 {
        pCfg.nCSOverride = 0x70
      } else {
        pCfg.nCSOverride = 0x10
      }
    } else {
      mux = (registers.readManagerControl() & 0x1)
      mode = ((registers.readManagerControl() & 0x2) >> 0x1)
      if mux != mode {
        pCfg.ioPort = 0x0
      } else {
        pCfg.ioPort = 0x1
      }
      if (registers.readManagerControl() & 0x10) != 0x10 {
        pCfg.nCSOverride = 0x0
      } else if (registers.readManagerControl() & 0x40) == 0x40 {
        pCfg.nCSOverride = 0x70
      } else {
        pCfg.nCSOverride = 0x10
      }
    }

  }
}
