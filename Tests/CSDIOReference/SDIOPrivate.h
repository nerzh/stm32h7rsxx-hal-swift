// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

/* Private define ----------------------------------------------------------------------------------------------------*/
/** @addtogroup SDIO_Private_Defines
  * @{
  */
#define SDIO_INIT_FREQ         400000U /*!< Initialization phase : 400 kHz max */
#define SDIO_TIMEOUT           1000U   /*!< SDIO timeout millisecond           */

#define SDIO_FUNCTION_0        0x00UL  /*!< SDIO_Functions 0                   */
#define SDIO_FUNCTION_1        0x01UL  /*!< SDIO_Functions 1                   */

#define SDIO_READ              0x0UL   /*!< Read flag for cmd52 and cmd53      */
#define SDIO_WRITE             0x1UL   /*!< Write flag for cmd52 and cmd53     */

#define SDIO_BUS_SPEED_SDR12   0x00U   /*!< SDIO bus speed mode SDR12          */
#define SDIO_BUS_SPEED_SDR25   0x02U   /*!< SDIO bus speed mode SDR25          */
#define SDIO_BUS_SPEED_SDR50   0x04U   /*!< SDIO bus speed mode SDR50          */
#define SDIO_BUS_SPEED_DDR50   0x08U   /*!< SDIO bus speed mode DDR50          */

#define SDIO_CCCR_REG_NUMBER   0x16U   /*!< SDIO card cccr register number     */

#define SDIO_OCR_VDD_32_33     (1UL << 20U)
#define SDIO_OCR_SDIO_S18R     (1UL << 24U)
/**
  * @}
  */
