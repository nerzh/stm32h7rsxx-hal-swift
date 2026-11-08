// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define SD_INIT_FREQ                   400000U   /* Initialization phase : 400 kHz max */
#define SD_NORMAL_SPEED_FREQ           25000000U /* Normal speed phase : 25 MHz max */
#define SD_HIGH_SPEED_FREQ             50000000U /* High speed phase : 50 MHz max */
/* Private macro -------------------------------------------------------------*/
#if defined (DLYB_SDMMC1) && defined (DLYB_SDMMC2)
#define SD_GET_DLYB_INSTANCE(SDMMC_INSTANCE) (((SDMMC_INSTANCE) == SDMMC1)?  \
                                              DLYB_SDMMC1 : DLYB_SDMMC2 )
#elif defined (DLYB_SDMMC1)
#define SD_GET_DLYB_INSTANCE(SDMMC_INSTANCE) ( DLYB_SDMMC1 )
#endif /* (DLYB_SDMMC1) && defined (DLYB_SDMMC2) */
