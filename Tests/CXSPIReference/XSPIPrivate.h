// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI/XSPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define XSPI_FUNCTIONAL_MODE_INDIRECT_WRITE ((uint32_t)0x00000000)
#define XSPI_FUNCTIONAL_MODE_INDIRECT_READ  ((uint32_t)XSPI_CR_FMODE_0)
#define XSPI_FUNCTIONAL_MODE_AUTO_POLLING   ((uint32_t)XSPI_CR_FMODE_1)
#define XSPI_FUNCTIONAL_MODE_MEMORY_MAPPED  ((uint32_t)XSPI_CR_FMODE)
#define XSPI_CFG_STATE_MASK  0x00000004U
#define XSPI_BUSY_STATE_MASK 0x00000008U
#define XSPI_NB_INSTANCE   2U
#define XSPI_IOM_NB_PORTS  2U
#define XSPI_IOM_PORT_MASK 0x1U
#define IS_XSPI_FUNCTIONAL_MODE(MODE) (((MODE) == XSPI_FUNCTIONAL_MODE_INDIRECT_WRITE) || \
                                       ((MODE) == XSPI_FUNCTIONAL_MODE_INDIRECT_READ)  || \
                                       ((MODE) == XSPI_FUNCTIONAL_MODE_AUTO_POLLING)   || \
                                       ((MODE) == XSPI_FUNCTIONAL_MODE_MEMORY_MAPPED))
