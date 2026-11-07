/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define FLASH_KEY_32_BITS           0x0000000U             /*!< Key size is 32 bits */

#define FLASH_KEY_64_BITS           FLASH_OBKCR_OBKSIZE_0  /*!< Key size is 64 bits */

#define FLASH_KEY_128_BITS          FLASH_OBKCR_OBKSIZE_1  /*!< Key size is 128 bits */

#define FLASH_KEY_256_BITS          FLASH_OBKCR_OBKSIZE    /*!< Key size is 256 bits */

#define FLASH_KEY_LEVEL_CURRENT  0x00000000U           /*!< Key stored for the HDPL indicated in SBS_HDPLSR */

#define FLASH_KEY_LEVEL_NEXT     FLASH_OBKCR_NEXTKL_0  /*!< Key stored for the HDPL indicated in SBS_HDPLSR + 1 */

#define FLASH_KEY_LEVEL_PLUS_TWO FLASH_OBKCR_NEXTKL_1  /*!< Key stored for the HDPL indicated in SBS_HDPLSR + 2 */

#define FLASH_CRC_ADDR         0x00000000U                                      /*!< CRC selection type by address  */

#define FLASH_CRC_SECTORS      FLASH_CRCCR_CRC_BY_SECT                          /*!< CRC selection type by sectors  */

#define FLASH_CRC_BANK         (FLASH_CRCCR_ALL_SECT | FLASH_CRCCR_CRC_BY_SECT) /*!< CRC selection type all bank */

#define FLASH_CRC_BURST_SIZE_4    0x00000000U              /*!< Every burst has a size of 4 Flash words (64 Bytes) */

#define FLASH_CRC_BURST_SIZE_16   FLASH_CRCCR_CRC_BURST_0  /*!< Every burst has a size of 16 Flash words (256 Bytes) */

#define FLASH_CRC_BURST_SIZE_64   FLASH_CRCCR_CRC_BURST_1  /*!< Every burst has a size of 64 Flash words (1 kByte) */

#define FLASH_CRC_BURST_SIZE_256  FLASH_CRCCR_CRC_BURST    /*!< Every burst has a size of 256 Flash words (4 kBytes) */

#define FLASH_ECC_AREA_USER_BANK1 0x00000000U  /*!< FLASH bank 1 area */

#define FLASH_ECC_AREA_SYSTEM     0x00000001U  /*!< System FLASH area */

#define FLASH_ECC_AREA_OTP        0x00000002U  /*!< FLASH OTP area */

#define FLASH_ECC_AREA_READ_ONLY  0x00000004U  /*!< FLASH Read-only area */

#define FLASH_ECC_MASTER_CPU1     0x00000000U  /*!< ECC error occurs on a CPU1 transaction */

#define IS_KEY_INDEX(VALUE)            ((VALUE) < 0x20U)

#define IS_KEY_SIZE(VALUE)             (((VALUE) == FLASH_KEY_32_BITS)  || ((VALUE) == FLASH_KEY_64_BITS) || \
                                        ((VALUE) == FLASH_KEY_128_BITS) || ((VALUE) == FLASH_KEY_256_BITS))

#define IS_KEY_HDPL_LEVEL(VALUE)       (((VALUE) == FLASH_KEY_LEVEL_CURRENT) || \
                                        ((VALUE) == FLASH_KEY_LEVEL_NEXT)    || \
                                        ((VALUE) == FLASH_KEY_LEVEL_PLUS_TWO))

#define IS_OB_OTP_BLOCK(VALUE)         ((VALUE) <= 0xFFFFU)

#define IS_FLASH_TYPE_CRC(VALUE)       (((VALUE) == FLASH_CRC_ADDR) || ((VALUE) == FLASH_CRC_SECTORS) ||\
                                        ((VALUE) == FLASH_CRC_BANK))

#define IS_FLASH_BURST_SIZE_CRC(VALUE) (((VALUE) == FLASH_CRC_BURST_SIZE_4) || ((VALUE) == FLASH_CRC_BURST_SIZE_16) ||\
                                        ((VALUE) == FLASH_CRC_BURST_SIZE_64) || ((VALUE) == FLASH_CRC_BURST_SIZE_256))
