// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#if defined (VDD_VALUE) && (VDD_VALUE <= 1950U)
#define MMC_VOLTAGE_RANGE               EMMC_LOW_VOLTAGE_RANGE

#define MMC_EXT_CSD_PWR_CL_26_INDEX     201
#define MMC_EXT_CSD_PWR_CL_52_INDEX     200
#define MMC_EXT_CSD_PWR_CL_DDR_52_INDEX 238

#define MMC_EXT_CSD_PWR_CL_26_POS       8
#define MMC_EXT_CSD_PWR_CL_52_POS       0
#define MMC_EXT_CSD_PWR_CL_DDR_52_POS   16
#else
#define MMC_VOLTAGE_RANGE               EMMC_HIGH_VOLTAGE_RANGE

#define MMC_EXT_CSD_PWR_CL_26_INDEX     203
#define MMC_EXT_CSD_PWR_CL_52_INDEX     202
#define MMC_EXT_CSD_PWR_CL_DDR_52_INDEX 239

#define MMC_EXT_CSD_PWR_CL_26_POS       24
#define MMC_EXT_CSD_PWR_CL_52_POS       16
#define MMC_EXT_CSD_PWR_CL_DDR_52_POS   24
#endif /* (VDD_VALUE) && (VDD_VALUE <= 1950U)*/

#define MMC_EXT_CSD_SLEEP_NOTIFICATION_TIME_INDEX 216
#define MMC_EXT_CSD_SLEEP_NOTIFICATION_TIME_POS   0
#define MMC_EXT_CSD_S_A_TIMEOUT_INDEX             217
#define MMC_EXT_CSD_S_A_TIMEOUT_POS               8

/* Frequencies used in the driver for clock divider calculation */
#define MMC_INIT_FREQ                   400000U   /* Initialization phase : 400 kHz max */
#define MMC_HIGH_SPEED_FREQ             52000000U /* High speed phase : 52 MHz max */

/* The Data elements' postitions in the frame Frame for RPMB area */
#define MMC_RPMB_KEYMAC_POSITION         196U
#define MMC_RPMB_DATA_POSITION           228U
#define MMC_RPMB_NONCE_POSITION          484U
#define MMC_RPMB_WRITE_COUNTER_POSITION  500U
/**
  * @}
  */
