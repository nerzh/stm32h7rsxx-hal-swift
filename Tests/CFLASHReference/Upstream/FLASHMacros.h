/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define FLASH_KEY_DATA_NB_REG (8U)  /*!< 8 Key data registers  */

#define FLASH_FLAG_EOP               FLASH_ISR_EOPF        /*!< FLASH End of program flag */

#define FLASH_FLAG_WRPERR            FLASH_ISR_WRPERRF     /*!< FLASH Write protection error flag */

#define FLASH_FLAG_PGSERR            FLASH_ISR_PGSERRF     /*!< FLASH Programming sequence error flag */

#define FLASH_FLAG_STRBERR           FLASH_ISR_STRBERRF    /*!< FLASH Strobe error flag */

#define FLASH_FLAG_OBLERR            FLASH_ISR_OBLERRF     /*!< FLASH Option byte loading error flag */

#define FLASH_FLAG_INCERR            FLASH_ISR_INCERRF     /*!< FLASH Inconsistency error flag */

#define FLASH_FLAG_RDSERR            FLASH_ISR_RDSERRF     /*!< FLASH Read security error flag */

#define FLASH_FLAG_SNECCERR          FLASH_ISR_SNECCERRF   /*!< FLASH ECC single error flag */

#define FLASH_FLAG_DBECCERR          FLASH_ISR_DBECCERRF   /*!< FLASH ECC double error flag */

#define FLASH_FLAG_CRCEND            FLASH_ISR_CRCENDF     /*!< FLASH CRC end of calculation flag */

#define FLASH_FLAG_CRCERR            FLASH_ISR_CRCRDERRF   /*!< FLASH CRC error flag  */

#define FLASH_FLAG_KVERR             FLASH_OPTISR_KVEF     /*!< FLASH Key valid error flag */

#define FLASH_FLAG_KTERR             FLASH_OPTISR_KTEF     /*!< FLASH Key transfer error flag */

#define FLASH_FLAG_OPTERR            FLASH_OPTISR_OPTERRF  /*!< FLASH Options byte change error flag */

#define FLASH_FLAG_ISR_ERRORS        (FLASH_FLAG_WRPERR     | FLASH_FLAG_PGSERR   | FLASH_FLAG_STRBERR | \
                                      FLASH_FLAG_OBLERR     | FLASH_FLAG_INCERR   | FLASH_FLAG_RDSERR  | \
                                      FLASH_FLAG_CRCERR)

#define FLASH_FLAG_ECC_ERRORS        (FLASH_FLAG_SNECCERR   | FLASH_FLAG_DBECCERR)

#define FLASH_FLAG_OPTISR_ERRORS     (FLASH_FLAG_KVERR      | FLASH_FLAG_KTERR      | FLASH_FLAG_OPTERR)

#define FLASH_FLAG_ALL_ERRORS        (FLASH_FLAG_ISR_ERRORS | FLASH_FLAG_ECC_ERRORS | FLASH_FLAG_OPTISR_ERRORS)

#define FLASH_FLAG_ISR_FLAGS         (FLASH_FLAG_ISR_ERRORS | FLASH_FLAG_ECC_ERRORS | FLASH_FLAG_EOP)

#define FLASH_IT_EOP                 FLASH_IER_EOPIE       /*!< End of program interrupt source */

#define FLASH_IT_WRPERR              FLASH_IER_WRPERRIE    /*!< FLASH Write protection error interrupt source */

#define FLASH_IT_PGSERR              FLASH_IER_PGSERRIE    /*!< FLASH Programming sequence error interrupt source */

#define FLASH_IT_STRBERR             FLASH_IER_STRBERRIE   /*!< FLASH Strobe error interrupt source */

#define FLASH_IT_OBLERR              FLASH_IER_OBLERRIE    /*!< FLASH Option byte loading error interrupt source */

#define FLASH_IT_INCERR              FLASH_IER_INCERRIE    /*!< FLASH Inconsistency error interrupt source */

#define FLASH_IT_RDSERR              FLASH_IER_RDSERRIE    /*!< FLASH Read security error interrupt source */

#define FLASH_IT_SNECCERR            FLASH_IER_SNECCERRIE  /*!< FLASH ECC single error interrupt source */

#define FLASH_IT_DBECCERR            FLASH_IER_DBECCERRIE  /*!< FLASH ECC double error interrupt source */

#define FLASH_IT_CRCEND              FLASH_IER_CRCENDIE    /*!< FLASH CRC end of calculation interrupt source */

#define FLASH_IT_CRCERR              FLASH_IER_CRCRDERRIE  /*!< FLASH CRC error interrupt source  */

#define FLASH_IT_KVERR               FLASH_OPTCR_KVEIE     /*!< FLASH Key valid error interrupt source */

#define FLASH_IT_KTERR               FLASH_OPTCR_KTEIE     /*!< FLASH Key transfer error interrupt source */

#define FLASH_IT_OPTERR              FLASH_OPTCR_OPTERRIE  /*!< FLASH Options byte change error interrupt source */

#define FLASH_IT_IER                 (FLASH_IT_EOP    | FLASH_IT_WRPERR | FLASH_IT_PGSERR   | FLASH_IT_STRBERR  | \
                                      FLASH_IT_OBLERR | FLASH_IT_INCERR | FLASH_IT_RDSERR | FLASH_IT_SNECCERR | \
                                      FLASH_IT_DBECCERR | FLASH_IT_CRCEND | FLASH_IT_CRCERR)

#define FLASH_IT_OPTCR               (FLASH_IT_KVERR  | FLASH_IT_KTERR    | FLASH_IT_OPTERR)

#define HAL_FLASH_ERROR_NONE         0x00000000U

#define HAL_FLASH_ERROR_WRP          FLASH_FLAG_WRPERR

#define HAL_FLASH_ERROR_PGS          FLASH_FLAG_PGSERR

#define HAL_FLASH_ERROR_STRB         FLASH_FLAG_STRBERR

#define HAL_FLASH_ERROR_OBL          FLASH_FLAG_OBLERR

#define HAL_FLASH_ERROR_INC          FLASH_FLAG_INCERR

#define HAL_FLASH_ERROR_RDS          FLASH_FLAG_RDSERR

#define HAL_FLASH_ERROR_SNECC        FLASH_FLAG_SNECCERR

#define HAL_FLASH_ERROR_DBECC        FLASH_FLAG_DBECCERR

#define HAL_FLASH_ERROR_CRC          FLASH_FLAG_CRCERR

#define HAL_FLASH_ERROR_KV           FLASH_FLAG_KVERR

#define HAL_FLASH_ERROR_KT           FLASH_FLAG_KTERR

#define HAL_FLASH_ERROR_OPT          FLASH_FLAG_OPTERR

#define FLASH_TYPEERASE_SECTORS      FLASH_CR_SER  /*!< Sectors erase activation */

#define FLASH_TYPEERASE_MASSERASE    FLASH_CR_BER  /*!< Flash mass erase activation */

#define FLASH_TYPEPROGRAM_BYTE         (FLASH_CR_PG | FLASH_CR_FW)                             /*!< Program a byte (8-bit) at a specified address */

#define FLASH_TYPEPROGRAM_HALFWORD     (FLASH_HALFWORD_MASK   | FLASH_CR_PG | FLASH_CR_FW)     /*!< Program a half-word (16-bit) at a specified address */

#define FLASH_TYPEPROGRAM_WORD         (FLASH_WORD_MASK       | FLASH_CR_PG | FLASH_CR_FW)     /*!< Program a word (32-bit) at a specified address */

#define FLASH_TYPEPROGRAM_DOUBLEWORD   (FLASH_DOUBLEWORD_MASK | FLASH_CR_PG | FLASH_CR_FW)     /*!< Program a double-word (64-bit) at a specified address */

#define FLASH_TYPEPROGRAM_QUADWORD     (FLASH_CR_PG)                                           /*!< Program a quad-word (128-bit) at a specified address */

#define FLASH_TYPEPROGRAM_OTP_HALFWORD (FLASH_HALFWORD_MASK   | FLASH_CR_PG_OTP | FLASH_CR_FW) /*!< Program a half-word (16-bit) at a OTP address */

#define FLASH_TYPEPROGRAM_OTP_WORD     (FLASH_WORD_MASK       | FLASH_CR_PG_OTP | FLASH_CR_FW) /*!< Program a word (32-bit) at a OTP address */

#define OPTIONBYTE_WRP               0x00000001U   /*!< WRP option byte configuration */

#define OPTIONBYTE_USER              0x00000002U   /*!< User option byte configuration */

#define OPTIONBYTE_HDP               0x00000004U   /*!< HDP option byte configuration */

#define OPTIONBYTE_NV                0x00000008U   /*!< Non-Volatile State option byte configuration */

#define OB_WRPSTATE_DISABLE          0x00000000U  /*!< Disable the write protection of the desired sectors */

#define OB_WRPSTATE_ENABLE           0x00000001U  /*!< Enable the write protection of the desired sectors */

#define OB_USER_BOR_LEV              0x00000001U     /*!< Brownout level */

#define OB_USER_IWDG_SW              0x00000002U     /*!< IWDG control mode */

#define OB_USER_NRST_STOP            0x00000004U     /*!< Stop entry reset */

#define OB_USER_NRST_STDBY           0x00000008U     /*!< Standby entry reset */

#define OB_USER_XSPI1_HSLV           0x00000010U     /*!< XSPI1 High-speed at low voltage */

#define OB_USER_XSPI2_HSLV           0x00000020U     /*!< XSPI2 High-speed at low voltage */

#define OB_USER_IWDG_STOP            0x00000040U     /*!< IWDG Stop mode freeze */

#define OB_USER_IWDG_STDBY           0x00000080U     /*!< IWDG Standby mode freeze */

#define OB_USER_VDDIO_HSLV           0x00000100U     /*!< I/O High-speed at low voltage */

#define OB_USER_ITCM_AXI_SHARE       0x00000200U     /*!< ITCM AXI share */

#define OB_USER_DTCM_AXI_SHARE       0x00000400U     /*!< DTCM AXI share */

#define OB_USER_SRAM_ECC             0x00000800U     /*!< ECC on SRAM */

#define OB_USER_I2C_NI3C             0x00001000U     /*!< I2C Not I3C */

#define OB_BOR_LEVEL_0               0x00000000U                /*!< BOR OFF, POR/PDR reset threshold level is applied */

#define OB_BOR_LEVEL_1               FLASH_OBW1SRP_BOR_LEVEL_0  /*!< BOR Level 1, the threshold level is low (around 2.1 V) */

#define OB_BOR_LEVEL_2               FLASH_OBW1SRP_BOR_LEVEL_1  /*!< BOR Level 2, the threshold level is medium (around 2.4 V) */

#define OB_BOR_LEVEL_3               FLASH_OBW1SRP_BOR_LEVEL    /*!< BOR Level 3, the threshold level is high (around 2.7 V) */

#define OB_IWDG_HW                   0x00000000U             /*!< IWDG watchdog is controlled by hardware */

#define OB_IWDG_SW                   FLASH_OBW1SRP_IWDG_HW   /*!< IWDG watchdog is controlled by software */

#define OB_STOP_RST                  0x00000000U                 /*!< Reset generated when entering stop mode */

#define OB_STOP_NORST                FLASH_OBW1SRP_NRST_STOP     /*!< No reset generated when entering stop mode */

#define OB_STANDBY_RST               0x00000000U                 /*!< Reset generated when entering standby mode */

#define OB_STANDBY_NORST             FLASH_OBW1SRP_NRST_STBY     /*!< No reset generated when entering standby mode */

#define OB_XSPI1_HSLV_DISABLE        0x00000000U               /*!< I/O speed optimization at low-voltage disabled */

#define OB_XSPI1_HSLV_ENABLE         FLASH_OBW1SRP_XSPI1_HSLV  /*!< I/O speed optimization at low-voltage feature allowed */

#define OB_XSPI2_HSLV_DISABLE        0x00000000U               /*!< I/O speed optimization at low-voltage disabled */

#define OB_XSPI2_HSLV_ENABLE         FLASH_OBW1SRP_XSPI2_HSLV  /*!< I/O speed optimization at low-voltage feature allowed */

#define OB_IWDG_STOP_FREEZE          0x00000000U                 /*!< Independent watchdog frozen in Stop mode */

#define OB_IWDG_STOP_RUN             FLASH_OBW1SRP_IWDG_FZ_STOP  /*!< Independent watchdog running in Stop mode */

#define OB_IWDG_STDBY_FREEZE         0x00000000U                 /*!< Independent watchdog frozen in Standby mode */

#define OB_IWDG_STDBY_RUN            FLASH_OBW1SRP_IWDG_FZ_STBY  /*!< Independent watchdog running in Standby mode */

#define OB_VDDIO_HSLV_DISABLE        0x00000000U               /*!< I/O speed optimization at low-voltage disabled */

#define OB_VDDIO_HSLV_ENABLE         FLASH_OBW1SRP_VDDIO_HSLV  /*!< I/O speed optimization at low-voltage feature allowed */

#define OB_ITCM_AXI_SHARE_0          0x00000000U

#define OB_ITCM_AXI_SHARE_1          FLASH_OBW2SRP_ITCM_AXI_SHARE_0

#define OB_ITCM_AXI_SHARE_2          FLASH_OBW2SRP_ITCM_AXI_SHARE_1

#define OB_ITCM_AXI_SHARE_3          (FLASH_OBW2SRP_ITCM_AXI_SHARE_0 | FLASH_OBW2SRP_ITCM_AXI_SHARE_1)

#define OB_ITCM_AXI_SHARE_4          FLASH_OBW2SRP_ITCM_AXI_SHARE_2

#define OB_ITCM_AXI_SHARE_5          (FLASH_OBW2SRP_ITCM_AXI_SHARE_2 | FLASH_OBW2SRP_ITCM_AXI_SHARE_0)

#define OB_ITCM_AXI_SHARE_6          (FLASH_OBW2SRP_ITCM_AXI_SHARE_2 | FLASH_OBW2SRP_ITCM_AXI_SHARE_1)

#define OB_ITCM_AXI_SHARE_7          FLASH_OBW2SRP_ITCM_AXI_SHARE

#define OB_DTCM_AXI_SHARE_0          0x00000000U

#define OB_DTCM_AXI_SHARE_1          FLASH_OBW2SRP_DTCM_AXI_SHARE_0

#define OB_DTCM_AXI_SHARE_2          FLASH_OBW2SRP_DTCM_AXI_SHARE_1

#define OB_DTCM_AXI_SHARE_3          (FLASH_OBW2SRP_DTCM_AXI_SHARE_0 | FLASH_OBW2SRP_DTCM_AXI_SHARE_1)

#define OB_DTCM_AXI_SHARE_4          FLASH_OBW2SRP_DTCM_AXI_SHARE_2

#define OB_DTCM_AXI_SHARE_5          (FLASH_OBW2SRP_DTCM_AXI_SHARE_2 | FLASH_OBW2SRP_DTCM_AXI_SHARE_0)

#define OB_DTCM_AXI_SHARE_6          (FLASH_OBW2SRP_DTCM_AXI_SHARE_2 | FLASH_OBW2SRP_DTCM_AXI_SHARE_1)

#define OB_DTCM_AXI_SHARE_7          FLASH_OBW2SRP_DTCM_AXI_SHARE

#define OB_AXISRAM_ECC_DISABLE       0x00000000U                /*!< AXISRAM ECC check disable */

#define OB_AXISRAM_ECC_ENABLE        FLASH_OBW2SRP_ECC_ON_SRAM  /*!< AXISRAM ECC check enable */

#define OB_I2C_NI3C_I2C              FLASH_OBW2SRP_I2C_NI3C

#define OB_I2C_NI3C_I3C              0x00000000U

#define OB_NVSTATE_OPEN              (uint8_t)0xB4

#define OB_NVSTATE_CLOSE             (uint8_t)0x51

#define OB_OEM_PROVD_ENABLE          (0xB4UL << FLASH_ROTSR_OEM_PROVD_Pos) /*!< Device is in OEM provisioned state */

#define OB_OEM_PROVD_DEFAULT         (0x6AUL << FLASH_ROTSR_OEM_PROVD_Pos) /*!< Device is not in OEM provisioned state (default value)*/

#define OB_DBG_AUTH_LOCKED           (0xB4UL << FLASH_ROTSR_DBG_AUTH_Pos) /*!< Locked device (no debug allowed) */

#define OB_DBG_AUTH_ECDSA_SIGN       (0x51UL << FLASH_ROTSR_DBG_AUTH_Pos) /*!< Authentication method using ECDSA signature (NISTP256) */

#define OB_DBG_AUTH_PASSWORD         (0x8AUL << FLASH_ROTSR_DBG_AUTH_Pos) /*!< Authentication method using password */

#define OB_DBG_AUTH_DEFAULT          (0xFFUL << FLASH_ROTSR_DBG_AUTH_Pos) /*!< No authentication method selected (default value) */

#define OB_IROT_SELECTION_ST         (0xB4UL << FLASH_ROTSR_IROT_SELECT_Pos) /*!< ST iRoT is selected at boot */

#define OB_IROT_SELECTION_OEM        (0x6AUL << FLASH_ROTSR_IROT_SELECT_Pos) /*!< OEM iRoT is selected at boot */

#define FLASH_LATENCY_0        0U                                                                                       /*!< FLASH Zero wait state      */

#define FLASH_LATENCY_1        FLASH_ACR_LATENCY_0                                                                      /*!< FLASH One wait state       */

#define FLASH_LATENCY_2        (FLASH_ACR_LATENCY_1 | FLASH_ACR_WRHIGHFREQ_0)                                           /*!< FLASH Two wait states      */

#define FLASH_LATENCY_3        (FLASH_ACR_LATENCY_1 | FLASH_ACR_LATENCY_0 | FLASH_ACR_WRHIGHFREQ_0)                     /*!< FLASH Three wait states    */

#define FLASH_LATENCY_4        (FLASH_ACR_LATENCY_2 | FLASH_ACR_WRHIGHFREQ_1)                                           /*!< FLASH Four wait states     */

#define FLASH_LATENCY_5        (FLASH_ACR_LATENCY_2 | FLASH_ACR_LATENCY_0 | FLASH_ACR_WRHIGHFREQ_1)                     /*!< FLASH Five wait states     */

#define FLASH_LATENCY_6        (FLASH_ACR_LATENCY_2 | FLASH_ACR_LATENCY_1 | FLASH_ACR_WRHIGHFREQ)                       /*!< FLASH Six wait state       */

#define FLASH_LATENCY_7        (FLASH_ACR_LATENCY_2 | FLASH_ACR_LATENCY_1 | FLASH_ACR_LATENCY_0 | FLASH_ACR_WRHIGHFREQ) /*!< FLASH Seven wait states    */

#define FLASH_KEY1                   0x45670123U /*!< Flash key1 */

#define FLASH_KEY2                   0xCDEF89ABU /*!< Flash key2: used with FLASH_KEY1
                                                      to unlock the FLASH registers access */

#define FLASH_OPT_KEY1                0x08192A3BU /*!< Flash option byte key1 */

#define FLASH_OPT_KEY2                0x4C5D6E7FU /*!< Flash option byte key2: used with FLASH_OPT_KEY1
                                                      to allow option bytes operations */

#define __HAL_FLASH_SET_LATENCY(__LATENCY__) MODIFY_REG(FLASH->ACR, (FLASH_ACR_LATENCY |\
                                                                     FLASH_ACR_WRHIGHFREQ), (__LATENCY__))

#define __HAL_FLASH_GET_LATENCY() READ_BIT(FLASH->ACR, (FLASH_ACR_LATENCY | FLASH_ACR_WRHIGHFREQ))

#define __HAL_FLASH_ENABLE_IT(__INTERRUPT__) do { if(((__INTERRUPT__) & FLASH_IT_IER) != 0U)\
                                                  { SET_BIT(FLASH->IER, ((__INTERRUPT__) & FLASH_IT_IER)); }\
                                                  if(((__INTERRUPT__) & FLASH_IT_OPTCR) != 0U)\
                                                  { SET_BIT(FLASH->OPTCR, ((__INTERRUPT__) & FLASH_IT_OPTCR)); }\
                                                } while(0)

#define __HAL_FLASH_DISABLE_IT(__INTERRUPT__) do { if(((__INTERRUPT__) & FLASH_IT_IER) != 0U)\
                                                   { CLEAR_BIT(FLASH->IER, ((__INTERRUPT__) & FLASH_IT_IER)); }\
                                                   if(((__INTERRUPT__) & FLASH_IT_OPTCR) != 0U)\
                                                   { CLEAR_BIT(FLASH->OPTCR, ((__INTERRUPT__) & FLASH_IT_OPTCR)); }\
                                                 } while(0)

#define __HAL_FLASH_GET_FLAG(__FLAG__) ((((__FLAG__) & FLASH_FLAG_OPTISR_ERRORS) != 0U) ? \
                                        (READ_BIT(FLASH->OPTISR, (__FLAG__)) == (__FLAG__)) : \
                                        (READ_BIT(FLASH->ISR, (__FLAG__)) == (__FLAG__)))

#define __HAL_FLASH_CLEAR_FLAG(__FLAG__) do { if(((__FLAG__) & FLASH_FLAG_OPTISR_ERRORS) != 0U)\
                                              { WRITE_REG(FLASH->OPTICR, ((__FLAG__) & FLASH_FLAG_OPTISR_ERRORS)); }\
                                              if(((__FLAG__) & FLASH_FLAG_ISR_FLAGS) != 0U)\
                                              { WRITE_REG(FLASH->ICR, ((__FLAG__) & FLASH_FLAG_ISR_FLAGS)); }\
                                            } while(0)

#define FLASH_BANK_SIZE                 FLASH_SIZE

#define FLASH_SECTOR_NB                 8U

#define FLASH_SECTOR_SIZE               0x2000UL  /* 8 KB */

#define FLASH_HDP_BLOCK_NB              0x100U

#define FLASH_TIMEOUT_VALUE             1000U   /* 1 s */

#define FLASH_BYTE_MASK                 0x00000000U

#define FLASH_HALFWORD_MASK             0x40000000U

#define FLASH_WORD_MASK                 0x80000000U

#define FLASH_DOUBLEWORD_MASK           0xC0000000U

#define FLASH_WORD_SIZE_MASK            FLASH_DOUBLEWORD_MASK

#define IS_FLASH_TYPEERASE(VALUE)          (((VALUE) == FLASH_TYPEERASE_SECTORS) ||\
                                            ((VALUE) == FLASH_TYPEERASE_MASSERASE))

#define IS_FLASH_TYPEPROGRAM(VALUE)        (((VALUE) == FLASH_TYPEPROGRAM_BYTE)         ||\
                                            ((VALUE) == FLASH_TYPEPROGRAM_HALFWORD)     ||\
                                            ((VALUE) == FLASH_TYPEPROGRAM_WORD)         ||\
                                            ((VALUE) == FLASH_TYPEPROGRAM_DOUBLEWORD)   ||\
                                            ((VALUE) == FLASH_TYPEPROGRAM_QUADWORD)     ||\
                                            ((VALUE) == FLASH_TYPEPROGRAM_OTP_HALFWORD) ||\
                                            ((VALUE) == FLASH_TYPEPROGRAM_OTP_WORD))

#define IS_FLASH_MAIN_MEM_ADDRESS(ADDRESS) (((ADDRESS) >= FLASH_BASE) && ((ADDRESS) < (FLASH_BASE+FLASH_SIZE)))

#define IS_FLASH_OTP_ADDRESS(ADDRESS)      (((ADDRESS) >= OTP_AREA_BASE) && ((ADDRESS) < (OTP_AREA_BASE + OTP_SIZE)))

#define IS_FLASH_PROGRAM_ADDRESS(ADDRESS)  ((IS_FLASH_MAIN_MEM_ADDRESS(ADDRESS)) || (IS_FLASH_OTP_ADDRESS(ADDRESS)))

#define IS_FLASH_SECTOR(SECTOR)            ((SECTOR) < FLASH_SECTOR_NB)

#define IS_OPTIONBYTE(VALUE)               (((VALUE) <= (OPTIONBYTE_WRP |\
                                                         OPTIONBYTE_USER | OPTIONBYTE_HDP | OPTIONBYTE_NV)))

#define IS_OB_WRPSTATE(VALUE)              (((VALUE) == OB_WRPSTATE_DISABLE) || ((VALUE) == OB_WRPSTATE_ENABLE))

#define IS_OB_USER_TYPE(TYPE)              (((TYPE) <= 0x1FFFU) && ((TYPE) != 0U))

#define IS_OB_USER_BOR_LEVEL(LEVEL)        (((LEVEL) == OB_BOR_LEVEL_0) || ((LEVEL) == OB_BOR_LEVEL_1) || \
                                            ((LEVEL) == OB_BOR_LEVEL_2) || ((LEVEL) == OB_BOR_LEVEL_3))

#define IS_OB_USER_IWDG(VALUE)             (((VALUE) == OB_IWDG_HW) || ((VALUE) == OB_IWDG_SW))

#define IS_OB_USER_STOP(VALUE)             (((VALUE) == OB_STOP_RST) || ((VALUE) == OB_STOP_NORST))

#define IS_OB_USER_STANDBY(VALUE)          (((VALUE) == OB_STANDBY_RST) || ((VALUE) == OB_STANDBY_NORST))

#define IS_OB_USER_XSPI1_HSLV(VALUE)       (((VALUE) == OB_XSPI1_HSLV_DISABLE) || ((VALUE) == OB_XSPI1_HSLV_ENABLE))

#define IS_OB_USER_XSPI2_HSLV(VALUE)       (((VALUE) == OB_XSPI2_HSLV_DISABLE) || ((VALUE) == OB_XSPI2_HSLV_ENABLE))

#define IS_OB_USER_IWDG_STOP(VALUE)        (((VALUE) == OB_IWDG_STOP_FREEZE) || ((VALUE) == OB_IWDG_STOP_RUN))

#define IS_OB_USER_IWDG_STDBY(VALUE)       (((VALUE) == OB_IWDG_STDBY_FREEZE) || ((VALUE) == OB_IWDG_STDBY_RUN))

#define IS_OB_USER_VDDIO_HSLV(VALUE)       (((VALUE) == OB_VDDIO_HSLV_DISABLE) || ((VALUE) == OB_VDDIO_HSLV_ENABLE))

#define IS_OB_USER_ITCM_AXI_SHARE(VALUE)   (((VALUE) == OB_ITCM_AXI_SHARE_0) || ((VALUE) == OB_ITCM_AXI_SHARE_1) || \
                                            ((VALUE) == OB_ITCM_AXI_SHARE_2) || ((VALUE) == OB_ITCM_AXI_SHARE_3) || \
                                            ((VALUE) == OB_ITCM_AXI_SHARE_4) || ((VALUE) == OB_ITCM_AXI_SHARE_5) || \
                                            ((VALUE) == OB_ITCM_AXI_SHARE_6) || ((VALUE) == OB_ITCM_AXI_SHARE_7))

#define IS_OB_USER_DTCM_AXI_SHARE(VALUE)   (((VALUE) == OB_DTCM_AXI_SHARE_0) || ((VALUE) == OB_DTCM_AXI_SHARE_1) || \
                                            ((VALUE) == OB_DTCM_AXI_SHARE_2) || ((VALUE) == OB_DTCM_AXI_SHARE_3) || \
                                            ((VALUE) == OB_DTCM_AXI_SHARE_4) || ((VALUE) == OB_DTCM_AXI_SHARE_5) || \
                                            ((VALUE) == OB_DTCM_AXI_SHARE_6) || ((VALUE) == OB_DTCM_AXI_SHARE_7))

#define IS_OB_USER_AXISRAM_ECC(VALUE)      (((VALUE) == OB_AXISRAM_ECC_ENABLE) || ((VALUE) == OB_AXISRAM_ECC_DISABLE))

#define IS_OB_USER_I2C_NI3C(VALUE)         (((VALUE) == OB_I2C_NI3C_I2C) || ((VALUE) == OB_I2C_NI3C_I3C))

#define IS_OB_HDP_PAGE(PAGE)               ((PAGE) < FLASH_HDP_BLOCK_NB)

#define IS_OB_NVSTATE(VALUE)               (((VALUE) == OB_NVSTATE_OPEN) || ((VALUE) ==OB_NVSTATE_CLOSE))

#define IS_OB_ROT_TYPE(VALUE)              ((VALUE) <= 0x7U)

#define IS_OB_OEM_PROVD(VALUE)             ((VALUE) <= 0x000000FFU)

#define IS_OB_DBG_AUTH(VALUE)              ((VALUE) <= 0x0000FF00U)

#define IS_OB_IROT_SELECT(VALUE)           ((VALUE) <= 0xFF000000U)

#define IS_OB_EPOCH(VALUE)                 ((VALUE) <= 0xFFFFFFU)

#define IS_FLASH_LATENCY(LATENCY)          (((LATENCY) == FLASH_LATENCY_0)  || ((LATENCY) == FLASH_LATENCY_1) || \
                                            ((LATENCY) == FLASH_LATENCY_2)  || ((LATENCY) == FLASH_LATENCY_3) || \
                                            ((LATENCY) == FLASH_LATENCY_4)  || ((LATENCY) == FLASH_LATENCY_5) || \
                                            ((LATENCY) == FLASH_LATENCY_6)  || ((LATENCY) == FLASH_LATENCY_7))
