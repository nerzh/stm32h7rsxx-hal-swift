/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Extracted unchanged from CMSIS device 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define FLASH_BASE                      0x08000000UL  /*!< User Flash address */

#define OTP_AREA_BASE                   0x08FFF000UL  /*!< OTP Area base address */

#define SYSTEM_FLASH_BASE               0x1FF00000UL  /*!< System Flash base address */

#define PERIPH_BASE                     0x40000000UL  /*!< AHB and APB Peripherals base address */

#define FLASH_SIZE                      0x00010000UL  /*!< 64 KB */

#define OTP_SIZE               0x400U /* 1 KB */

#define AHB5PERIPH_BASE                 (PERIPH_BASE + 0x12000000UL)

#define APB4PERIPH_BASE                 (PERIPH_BASE + 0x18000000UL)

#define AHB4PERIPH_BASE                 (PERIPH_BASE + 0x18020000UL)

#define XSPI1_R_BASE                    (AHB5PERIPH_BASE + 0x5000UL)

#define XSPI2_R_BASE                    (AHB5PERIPH_BASE + 0xA000UL)

#define IWDG_BASE                       (APB4PERIPH_BASE + 0x4800UL)

#define CRC_BASE                        (AHB4PERIPH_BASE + 0x4C00UL)

#define CRC                    ((CRC_TypeDef *) CRC_BASE)

#define IWDG                   ((IWDG_TypeDef *) IWDG_BASE)

#define XSPI1                  ((XSPI_TypeDef *) XSPI1_R_BASE)

#define XSPI2                  ((XSPI_TypeDef *) XSPI2_R_BASE)

#define FLASH_ACR_LATENCY_Pos                (0U)

#define FLASH_ACR_LATENCY_Msk                (0xFUL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x0000000F */

#define FLASH_ACR_LATENCY                    FLASH_ACR_LATENCY_Msk                               /*!< Read Latency */

#define FLASH_ACR_LATENCY_0                  (0x1UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000001 */

#define FLASH_ACR_LATENCY_1                  (0x2UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000002 */

#define FLASH_ACR_LATENCY_2                  (0x4UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000004 */

#define FLASH_ACR_WRHIGHFREQ_Pos             (4U)

#define FLASH_ACR_WRHIGHFREQ_Msk             (0x3UL << FLASH_ACR_WRHIGHFREQ_Pos)                 /*!< 0x00000030 */

#define FLASH_ACR_WRHIGHFREQ                 FLASH_ACR_WRHIGHFREQ_Msk                            /*!< Flash signal delay */

#define FLASH_ACR_WRHIGHFREQ_0               (0x1UL << FLASH_ACR_WRHIGHFREQ_Pos)                 /*!< 0x00000010 */

#define FLASH_ACR_WRHIGHFREQ_1               (0x2UL << FLASH_ACR_WRHIGHFREQ_Pos)                 /*!< 0x00000020 */

#define FLASH_CR_LOCK_Pos                    (0U)

#define FLASH_CR_LOCK_Msk                    (0x1UL << FLASH_CR_LOCK_Pos)                        /*!< 0x00000001 */

#define FLASH_CR_LOCK                        FLASH_CR_LOCK_Msk                                   /*!< Configuration lock bit */

#define FLASH_CR_PG_Pos                      (1U)

#define FLASH_CR_PG_Msk                      (0x1UL << FLASH_CR_PG_Pos)                          /*!< 0x00000002 */

#define FLASH_CR_PG                          FLASH_CR_PG_Msk                                     /*!< Internal buffer control bit */

#define FLASH_CR_SER_Pos                     (2U)

#define FLASH_CR_SER_Msk                     (0x1UL << FLASH_CR_SER_Pos)                         /*!< 0x00000004 */

#define FLASH_CR_SER                         FLASH_CR_SER_Msk                                    /*!< Sector erase request */

#define FLASH_CR_BER_Pos                     (3U)

#define FLASH_CR_BER_Msk                     (0x1UL << FLASH_CR_BER_Pos)                         /*!< 0x00000008 */

#define FLASH_CR_BER                         FLASH_CR_BER_Msk                                    /*!< Bank erase request */

#define FLASH_CR_FW_Pos                      (4U)

#define FLASH_CR_FW_Msk                      (0x1UL << FLASH_CR_FW_Pos)                          /*!< 0x00000010 */

#define FLASH_CR_FW                          FLASH_CR_FW_Msk                                     /*!< Force write */

#define FLASH_CR_START_Pos                   (5U)

#define FLASH_CR_START_Msk                   (0x1UL << FLASH_CR_START_Pos)                       /*!< 0x00000020 */

#define FLASH_CR_START                       FLASH_CR_START_Msk                                  /*!< Erase start control bit */

#define FLASH_CR_SSN_Pos                     (6U)

#define FLASH_CR_SSN_Msk                     (0x7UL << FLASH_CR_SSN_Pos)                         /*!< 0x000001C0 */

#define FLASH_CR_SSN                         FLASH_CR_SSN_Msk                                    /*!< Sector erase selection number */

#define FLASH_CR_PG_OTP_Pos                  (16U)

#define FLASH_CR_PG_OTP_Msk                  (0x1UL << FLASH_CR_PG_OTP_Pos)                      /*!< 0x00010000 */

#define FLASH_CR_PG_OTP                      FLASH_CR_PG_OTP_Msk                                 /*!< Program Enable for OTP Area */

#define FLASH_CR_CRC_EN_Pos                  (17U)

#define FLASH_CR_CRC_EN_Msk                  (0x1UL << FLASH_CR_CRC_EN_Pos)                      /*!< 0x00020000 */

#define FLASH_CR_CRC_EN                      FLASH_CR_CRC_EN_Msk                                 /*!< CRC enable */

#define FLASH_SR_QW_Pos                      (2U)

#define FLASH_SR_QW_Msk                      (0x1UL << FLASH_SR_QW_Pos)                          /*!< 0x00000004 */

#define FLASH_SR_QW                          FLASH_SR_QW_Msk                                     /*!< Wait queue flag */

#define FLASH_SR_CRC_BUSY_Pos                (3U)

#define FLASH_SR_CRC_BUSY_Msk                (0x1UL << FLASH_SR_CRC_BUSY_Pos)                    /*!< 0x00000008 */

#define FLASH_SR_CRC_BUSY                    FLASH_SR_CRC_BUSY_Msk                               /*!< CRC busy flag */

#define FLASH_IER_EOPIE_Pos                  (16U)

#define FLASH_IER_EOPIE_Msk                  (0x1UL << FLASH_IER_EOPIE_Pos)                      /*!< 0x00010000 */

#define FLASH_IER_EOPIE                      FLASH_IER_EOPIE_Msk                                 /*!< End of program interrupt enable bit */

#define FLASH_IER_WRPERRIE_Pos               (17U)

#define FLASH_IER_WRPERRIE_Msk               (0x1UL << FLASH_IER_WRPERRIE_Pos)                   /*!< 0x00020000 */

#define FLASH_IER_WRPERRIE                   FLASH_IER_WRPERRIE_Msk                              /*!< Write protection error interrupt enable bit */

#define FLASH_IER_PGSERRIE_Pos               (18U)

#define FLASH_IER_PGSERRIE_Msk               (0x1UL << FLASH_IER_PGSERRIE_Pos)                   /*!< 0x00040000 */

#define FLASH_IER_PGSERRIE                   FLASH_IER_PGSERRIE_Msk                              /*!< Programming sequence error interrupt enable bit */

#define FLASH_IER_STRBERRIE_Pos              (19U)

#define FLASH_IER_STRBERRIE_Msk              (0x1UL << FLASH_IER_STRBERRIE_Pos)                  /*!< 0x00080000 */

#define FLASH_IER_STRBERRIE                  FLASH_IER_STRBERRIE_Msk                             /*!< Strobe error interrupt enable bit */

#define FLASH_IER_OBLERRIE_Pos               (20U)

#define FLASH_IER_OBLERRIE_Msk               (0x1UL << FLASH_IER_OBLERRIE_Pos)                   /*!< 0x00100000 */

#define FLASH_IER_OBLERRIE                   FLASH_IER_OBLERRIE_Msk                              /*!< Option byte loading error interrupt enable bit */

#define FLASH_IER_INCERRIE_Pos               (21U)

#define FLASH_IER_INCERRIE_Msk               (0x1UL << FLASH_IER_INCERRIE_Pos)                   /*!< 0x00200000 */

#define FLASH_IER_INCERRIE                   FLASH_IER_INCERRIE_Msk                              /*!< Inconsistency error interrupt enable bit */

#define FLASH_IER_RDSERRIE_Pos               (24U)

#define FLASH_IER_RDSERRIE_Msk               (0x1UL << FLASH_IER_RDSERRIE_Pos)                   /*!< 0x01000000 */

#define FLASH_IER_RDSERRIE                   FLASH_IER_RDSERRIE_Msk                              /*!< Read security error interrupt enable bit */

#define FLASH_IER_SNECCERRIE_Pos             (25U)

#define FLASH_IER_SNECCERRIE_Msk             (0x1UL << FLASH_IER_SNECCERRIE_Pos)                 /*!< 0x02000000 */

#define FLASH_IER_SNECCERRIE                 FLASH_IER_SNECCERRIE_Msk                            /*!< ECC single correction error interrupt enable bit */

#define FLASH_IER_DBECCERRIE_Pos             (26U)

#define FLASH_IER_DBECCERRIE_Msk             (0x1UL << FLASH_IER_DBECCERRIE_Pos)                 /*!< 0x04000000 */

#define FLASH_IER_DBECCERRIE                 FLASH_IER_DBECCERRIE_Msk                            /*!< ECC double detection error interrupt enable bit */

#define FLASH_IER_CRCENDIE_Pos               (27U)

#define FLASH_IER_CRCENDIE_Msk               (0x1UL << FLASH_IER_CRCENDIE_Pos)                   /*!< 0x08000000 */

#define FLASH_IER_CRCENDIE                   FLASH_IER_CRCENDIE_Msk                              /*!< CRC end of calculation interrupt enable bit */

#define FLASH_IER_CRCRDERRIE_Pos             (28U)

#define FLASH_IER_CRCRDERRIE_Msk             (0x1UL << FLASH_IER_CRCRDERRIE_Pos)                 /*!< 0x10000000 */

#define FLASH_IER_CRCRDERRIE                 FLASH_IER_CRCRDERRIE_Msk                            /*!< CRC read error interrupt enable bit */

#define FLASH_ISR_EOPF_Pos                   (16U)

#define FLASH_ISR_EOPF_Msk                   (0x1UL << FLASH_ISR_EOPF_Pos)                       /*!< 0x00010000 */

#define FLASH_ISR_EOPF                       FLASH_ISR_EOPF_Msk                                  /*!< End of program flag */

#define FLASH_ISR_WRPERRF_Pos                (17U)

#define FLASH_ISR_WRPERRF_Msk                (0x1UL << FLASH_ISR_WRPERRF_Pos)                    /*!< 0x00020000 */

#define FLASH_ISR_WRPERRF                    FLASH_ISR_WRPERRF_Msk                               /*!< Write protection error flag */

#define FLASH_ISR_PGSERRF_Pos                (18U)

#define FLASH_ISR_PGSERRF_Msk                (0x1UL << FLASH_ISR_PGSERRF_Pos)                    /*!< 0x00040000 */

#define FLASH_ISR_PGSERRF                    FLASH_ISR_PGSERRF_Msk                               /*!< Programming sequence error flag */

#define FLASH_ISR_STRBERRF_Pos               (19U)

#define FLASH_ISR_STRBERRF_Msk               (0x1UL << FLASH_ISR_STRBERRF_Pos)                   /*!< 0x00080000 */

#define FLASH_ISR_STRBERRF                   FLASH_ISR_STRBERRF_Msk                              /*!< Strobe error flag */

#define FLASH_ISR_OBLERRF_Pos                (20U)

#define FLASH_ISR_OBLERRF_Msk                (0x1UL << FLASH_ISR_OBLERRF_Pos)                    /*!< 0x00100000 */

#define FLASH_ISR_OBLERRF                    FLASH_ISR_OBLERRF_Msk                               /*!< Option byte loading error flag */

#define FLASH_ISR_INCERRF_Pos                (21U)

#define FLASH_ISR_INCERRF_Msk                (0x1UL << FLASH_ISR_INCERRF_Pos)                    /*!< 0x00200000 */

#define FLASH_ISR_INCERRF                    FLASH_ISR_INCERRF_Msk                               /*!< Inconsistency error flag */

#define FLASH_ISR_RDSERRF_Pos                (24U)

#define FLASH_ISR_RDSERRF_Msk                (0x1UL << FLASH_ISR_RDSERRF_Pos)                    /*!< 0x01000000 */

#define FLASH_ISR_RDSERRF                    FLASH_ISR_RDSERRF_Msk                               /*!< Read security error flag */

#define FLASH_ISR_SNECCERRF_Pos              (25U)

#define FLASH_ISR_SNECCERRF_Msk              (0x1UL << FLASH_ISR_SNECCERRF_Pos)                  /*!< 0x02000000 */

#define FLASH_ISR_SNECCERRF                  FLASH_ISR_SNECCERRF_Msk                             /*!< ECC single error flag */

#define FLASH_ISR_DBECCERRF_Pos              (26U)

#define FLASH_ISR_DBECCERRF_Msk              (0x1UL << FLASH_ISR_DBECCERRF_Pos)                  /*!< 0x04000000 */

#define FLASH_ISR_DBECCERRF                  FLASH_ISR_DBECCERRF_Msk                             /*!< ECC double error flag */

#define FLASH_ISR_CRCENDF_Pos                (27U)

#define FLASH_ISR_CRCENDF_Msk                (0x1UL << FLASH_ISR_CRCENDF_Pos)                    /*!< 0x08000000 */

#define FLASH_ISR_CRCENDF                    FLASH_ISR_CRCENDF_Msk                               /*!< CRC end of calculation flag */

#define FLASH_ISR_CRCRDERRF_Pos              (28U)

#define FLASH_ISR_CRCRDERRF_Msk              (0x1UL << FLASH_ISR_CRCRDERRF_Pos)                  /*!< 0x10000000 */

#define FLASH_ISR_CRCRDERRF                  FLASH_ISR_CRCRDERRF_Msk                             /*!< CRC read error flag */

#define FLASH_ICR_CRCENDF_Pos                (27U)

#define FLASH_ICR_CRCENDF_Msk                (0x1UL << FLASH_ICR_CRCENDF_Pos)                    /*!< 0x08000000 */

#define FLASH_ICR_CRCENDF                    FLASH_ICR_CRCENDF_Msk                               /*!< CRC end flag clear */

#define FLASH_ICR_CRCRDERRF_Pos              (28U)

#define FLASH_ICR_CRCRDERRF_Msk              (0x1UL << FLASH_ICR_CRCRDERRF_Pos)                  /*!< 0x10000000 */

#define FLASH_ICR_CRCRDERRF                  FLASH_ICR_CRCRDERRF_Msk                             /*!< CRC read error flag clear */

#define FLASH_CRCCR_CRC_SECT_Pos             (0U)

#define FLASH_CRCCR_CRC_SECT_Msk             (0x7UL << FLASH_CRCCR_CRC_SECT_Pos)                 /*!< 0x00000007 */

#define FLASH_CRCCR_CRC_SECT                 FLASH_CRCCR_CRC_SECT_Msk                            /*!< CRC sector number */

#define FLASH_CRCCR_CRC_BY_SECT_Pos          (9U)

#define FLASH_CRCCR_CRC_BY_SECT_Msk          (0x1UL << FLASH_CRCCR_CRC_BY_SECT_Pos)              /*!< 0x00000200 */

#define FLASH_CRCCR_CRC_BY_SECT              FLASH_CRCCR_CRC_BY_SECT_Msk                         /*!< CRC sector mode select bit */

#define FLASH_CRCCR_ADD_SECT_Pos             (10U)

#define FLASH_CRCCR_ADD_SECT_Msk             (0x1UL << FLASH_CRCCR_ADD_SECT_Pos)                 /*!< 0x00000400 */

#define FLASH_CRCCR_ADD_SECT                 FLASH_CRCCR_ADD_SECT_Msk                            /*!< CRC sector select bit */

#define FLASH_CRCCR_CLEAN_SECT_Pos           (11U)

#define FLASH_CRCCR_CLEAN_SECT_Msk           (0x1UL << FLASH_CRCCR_CLEAN_SECT_Pos)               /*!< 0x00000800 */

#define FLASH_CRCCR_CLEAN_SECT               FLASH_CRCCR_CLEAN_SECT_Msk                          /*!< CRC sector list clear bit */

#define FLASH_CRCCR_START_CRC_Pos            (16U)

#define FLASH_CRCCR_START_CRC_Msk            (0x1UL << FLASH_CRCCR_START_CRC_Pos)                /*!< 0x00010000 */

#define FLASH_CRCCR_START_CRC                FLASH_CRCCR_START_CRC_Msk                           /*!< CRC start bit */

#define FLASH_CRCCR_CLEAN_CRC_Pos            (17U)

#define FLASH_CRCCR_CLEAN_CRC_Msk            (0x1UL << FLASH_CRCCR_CLEAN_CRC_Pos)                /*!< 0x00020000 */

#define FLASH_CRCCR_CLEAN_CRC                FLASH_CRCCR_CLEAN_CRC_Msk                           /*!< CRC clear bit */

#define FLASH_CRCCR_CRC_BURST_Pos            (20U)

#define FLASH_CRCCR_CRC_BURST_Msk            (0x3UL << FLASH_CRCCR_CRC_BURST_Pos)                /*!< 0x00300000 */

#define FLASH_CRCCR_CRC_BURST                FLASH_CRCCR_CRC_BURST_Msk                           /*!< CRC burst size */

#define FLASH_CRCCR_CRC_BURST_0              (0x1UL << FLASH_CRCCR_CRC_BURST_Pos)                /*!< 0x00100000 */

#define FLASH_CRCCR_CRC_BURST_1              (0x2UL << FLASH_CRCCR_CRC_BURST_Pos)                /*!< 0x00200000 */

#define FLASH_CRCCR_ALL_SECT_Pos             (24U)

#define FLASH_CRCCR_ALL_SECT_Msk             (0x1UL << FLASH_CRCCR_ALL_SECT_Pos)                 /*!< 0x01000000 */

#define FLASH_CRCCR_ALL_SECT                 FLASH_CRCCR_ALL_SECT_Msk                            /*!< All sectors selection */

#define FLASH_OPTCR_OPTLOCK_Pos              (0U)

#define FLASH_OPTCR_OPTLOCK_Msk              (0x1UL << FLASH_OPTCR_OPTLOCK_Pos)                  /*!< 0x00000001 */

#define FLASH_OPTCR_OPTLOCK                  FLASH_OPTCR_OPTLOCK_Msk                             /*!< Options lock */

#define FLASH_OPTCR_PG_OPT_Pos               (1U)

#define FLASH_OPTCR_PG_OPT_Msk               (0x1UL << FLASH_OPTCR_PG_OPT_Pos)                   /*!< 0x00000002 */

#define FLASH_OPTCR_PG_OPT                   FLASH_OPTCR_PG_OPT_Msk                              /*!< Program options */

#define FLASH_OPTCR_KVEIE_Pos                (27U)

#define FLASH_OPTCR_KVEIE_Msk                (0x1UL << FLASH_OPTCR_KVEIE_Pos)                    /*!< 0x08000000 */

#define FLASH_OPTCR_KVEIE                    FLASH_OPTCR_KVEIE_Msk                               /*!< Key valid error interrupt enable bit */

#define FLASH_OPTCR_KTEIE_Pos                (28U)

#define FLASH_OPTCR_KTEIE_Msk                (0x1UL << FLASH_OPTCR_KTEIE_Pos)                    /*!< 0x10000000 */

#define FLASH_OPTCR_KTEIE                    FLASH_OPTCR_KTEIE_Msk                               /*!< Key transfer error interrupt enable bit */

#define FLASH_OPTCR_OPTERRIE_Pos             (30U)

#define FLASH_OPTCR_OPTERRIE_Msk             (0x1UL << FLASH_OPTCR_OPTERRIE_Pos)                 /*!< 0x40000000 */

#define FLASH_OPTCR_OPTERRIE                 FLASH_OPTCR_OPTERRIE_Msk                            /*!< Options byte change error interrupt enable bit */

#define FLASH_OPTISR_KVEF_Pos                (27U)

#define FLASH_OPTISR_KVEF_Msk                (0x1UL << FLASH_OPTISR_KVEF_Pos)                    /*!< 0x08000000 */

#define FLASH_OPTISR_KVEF                    FLASH_OPTISR_KVEF_Msk                               /*!< Key valid error flag */

#define FLASH_OPTISR_KTEF_Pos                (28U)

#define FLASH_OPTISR_KTEF_Msk                (0x1UL << FLASH_OPTISR_KTEF_Pos)                    /*!< 0x10000000 */

#define FLASH_OPTISR_KTEF                    FLASH_OPTISR_KTEF_Msk                               /*!< Key transfer error flag */

#define FLASH_OPTISR_OPTERRF_Pos             (30U)

#define FLASH_OPTISR_OPTERRF_Msk             (0x1UL << FLASH_OPTISR_OPTERRF_Pos)                 /*!< 0x40000000 */

#define FLASH_OPTISR_OPTERRF                 FLASH_OPTISR_OPTERRF_Msk                            /*!< Options byte change error flag */

#define FLASH_OBKCR_OBKINDEX_Pos             (0U)

#define FLASH_OBKCR_OBKINDEX_Msk             (0x1FUL << FLASH_OBKCR_OBKINDEX_Pos)               /*!< 0x0000001F */

#define FLASH_OBKCR_OBKINDEX                 FLASH_OBKCR_OBKINDEX_Msk                           /*!< Option byte key index */

#define FLASH_OBKCR_NEXTKL_Pos               (8U)

#define FLASH_OBKCR_NEXTKL_Msk               (0x3UL << FLASH_OBKCR_NEXTKL_Pos)                  /*!< 0x00000300 */

#define FLASH_OBKCR_NEXTKL                   FLASH_OBKCR_NEXTKL_Msk                             /*!< Next key level */

#define FLASH_OBKCR_NEXTKL_0                 (0x1UL << FLASH_OBKCR_NEXTKL_Pos)                  /*!< 0x00000100 */

#define FLASH_OBKCR_NEXTKL_1                 (0x2UL << FLASH_OBKCR_NEXTKL_Pos)                  /*!< 0x00000200 */

#define FLASH_OBKCR_OBKSIZE_Pos              (10U)

#define FLASH_OBKCR_OBKSIZE_Msk              (0x3UL << FLASH_OBKCR_OBKSIZE_Pos)                 /*!< 0x00000C00 */

#define FLASH_OBKCR_OBKSIZE                  FLASH_OBKCR_OBKSIZE_Msk                            /*!< Option byte key size */

#define FLASH_OBKCR_OBKSIZE_0                (0x1UL << FLASH_OBKCR_OBKSIZE_Pos)                 /*!< 0x00000400 */

#define FLASH_OBKCR_OBKSIZE_1                (0x2UL << FLASH_OBKCR_OBKSIZE_Pos)                 /*!< 0x00000800 */

#define FLASH_OBKCR_KEYPROG_Pos              (14U)

#define FLASH_OBKCR_KEYPROG_Msk              (0x1UL << FLASH_OBKCR_KEYPROG_Pos)                 /*!< 0x00004000 */

#define FLASH_OBKCR_KEYPROG                  FLASH_OBKCR_KEYPROG_Msk                            /*!< Key program */

#define FLASH_OBKCR_KEYSTART_Pos             (15U)

#define FLASH_OBKCR_KEYSTART_Msk             (0x1UL << FLASH_OBKCR_KEYSTART_Pos)                /*!< 0x00008000 */

#define FLASH_OBKCR_KEYSTART                 FLASH_OBKCR_KEYSTART_Msk                           /*!< Key option start */

#define FLASH_NVSR_NVSTATE_Pos               (0U)

#define FLASH_NVSR_NVSTATE_Msk               (0xFFUL << FLASH_NVSR_NVSTATE_Pos)                  /*!< 0x000000FF */

#define FLASH_NVSR_NVSTATE                   FLASH_NVSR_NVSTATE_Msk                              /*!< Non-volatile state */

#define FLASH_NVSRP_NVSTATE_Pos              (0U)

#define FLASH_NVSRP_NVSTATE_Msk              (0xFFUL << FLASH_NVSRP_NVSTATE_Pos)                 /*!< 0x000000FF */

#define FLASH_NVSRP_NVSTATE                  FLASH_NVSRP_NVSTATE_Msk                             /*!< Non-volatile state */

#define FLASH_ROTSR_OEM_PROVD_Pos            (0U)

#define FLASH_ROTSR_OEM_PROVD_Msk            (0xFFUL << FLASH_ROTSR_OEM_PROVD_Pos)               /*!< 0x000000FF */

#define FLASH_ROTSR_OEM_PROVD                FLASH_ROTSR_OEM_PROVD_Msk                           /*!< OEM provisioned state */

#define FLASH_ROTSR_DBG_AUTH_Pos             (8U)

#define FLASH_ROTSR_DBG_AUTH_Msk             (0xFFUL << FLASH_ROTSR_DBG_AUTH_Pos)                /*!< 0x0000FF00 */

#define FLASH_ROTSR_DBG_AUTH                 FLASH_ROTSR_DBG_AUTH_Msk                            /*!< Debug authentication method */

#define FLASH_ROTSR_IROT_SELECT_Pos          (24U)

#define FLASH_ROTSR_IROT_SELECT_Msk          (0xFFUL << FLASH_ROTSR_IROT_SELECT_Pos)             /*!< 0xFF000000 */

#define FLASH_ROTSR_IROT_SELECT              FLASH_ROTSR_IROT_SELECT_Msk                         /*!< iRoT selection */

#define FLASH_OTPLSR_OTPL_Pos                (0U)

#define FLASH_OTPLSR_OTPL_Msk                (0xFFFFUL << FLASH_OTPLSR_OTPL_Pos)                 /*!< 0x0000FFFF */

#define FLASH_OTPLSR_OTPL                    FLASH_OTPLSR_OTPL_Msk                               /*!< OTP lock n (n=0 to 15) */

#define FLASH_OTPLSRP_OTPL_Pos               (0U)

#define FLASH_OTPLSRP_OTPL_Msk               (0xFFFFUL << FLASH_OTPLSRP_OTPL_Pos)                /*!< 0x0000FFFF */

#define FLASH_OTPLSRP_OTPL                   FLASH_OTPLSRP_OTPL_Msk                              /*!< OTP lock n (n=0 to 15) */

#define FLASH_WRPSR_WRPS_Pos                 (0U)

#define FLASH_WRPSR_WRPS_Msk                 (0xFFUL << FLASH_WRPSR_WRPS_Pos)                    /*!< 0x000000FF */

#define FLASH_WRPSR_WRPS                     FLASH_WRPSR_WRPS_Msk                                /*!< Write protection for sector n (n=0 to 7) */

#define FLASH_WRPSRP_WRPS_Pos                (0U)

#define FLASH_WRPSRP_WRPS_Msk                (0xFFUL << FLASH_WRPSRP_WRPS_Pos)                   /*!< 0x000000FF */

#define FLASH_WRPSRP_WRPS                    FLASH_WRPSRP_WRPS_Msk                               /*!< Write protection for sector n (n=0 to 7) */

#define FLASH_HDPSR_HDP_AREA_START_Pos       (0U)

#define FLASH_HDPSR_HDP_AREA_START_Msk       (0xFFUL << FLASH_HDPSR_HDP_AREA_START_Pos)          /*!< 0x000000FF */

#define FLASH_HDPSR_HDP_AREA_START           FLASH_HDPSR_HDP_AREA_START_Msk                      /*!< Hide protection user flash area start */

#define FLASH_HDPSR_HDP_AREA_END_Pos         (16U)

#define FLASH_HDPSR_HDP_AREA_END_Msk         (0xFFUL << FLASH_HDPSR_HDP_AREA_END_Pos)            /*!< 0x00FF0000 */

#define FLASH_HDPSR_HDP_AREA_END             FLASH_HDPSR_HDP_AREA_END_Msk                        /*!< Hide protection user flash area end */

#define FLASH_HDPSRP_HDP_AREA_START_Pos      (0U)

#define FLASH_HDPSRP_HDP_AREA_START_Msk      (0xFFUL << FLASH_HDPSRP_HDP_AREA_START_Pos)         /*!< 0x000000FF */

#define FLASH_HDPSRP_HDP_AREA_START          FLASH_HDPSRP_HDP_AREA_START_Msk                     /*!< Hide protection user flash area start */

#define FLASH_HDPSRP_HDP_AREA_END_Pos        (16U)

#define FLASH_HDPSRP_HDP_AREA_END_Msk        (0xFFUL << FLASH_HDPSRP_HDP_AREA_END_Pos)           /*!< 0x00FF0000 */

#define FLASH_HDPSRP_HDP_AREA_END            FLASH_HDPSRP_HDP_AREA_END_Msk                       /*!< Hide protection user flash area end */

#define FLASH_EPOCHSR_EPOCH_Pos              (0U)

#define FLASH_EPOCHSR_EPOCH_Msk              (0xFFFFFFUL << FLASH_EPOCHSR_EPOCH_Pos)             /*!< 0x00FFFFFF */

#define FLASH_EPOCHSR_EPOCH                  FLASH_EPOCHSR_EPOCH_Msk                             /*!< Epoch */

#define FLASH_OBW1SR_BOR_LEVEL_Pos           (2U)

#define FLASH_OBW1SR_BOR_LEVEL_Msk           (0x3UL << FLASH_OBW1SR_BOR_LEVEL_Pos)               /*!< 0x0000000C */

#define FLASH_OBW1SR_BOR_LEVEL               FLASH_OBW1SR_BOR_LEVEL_Msk                          /*!< Brownout level */

#define FLASH_OBW1SR_IWDG_HW_Pos             (4U)

#define FLASH_OBW1SR_IWDG_HW_Msk             (0x1UL << FLASH_OBW1SR_IWDG_HW_Pos)                 /*!< 0x00000010 */

#define FLASH_OBW1SR_IWDG_HW                 FLASH_OBW1SR_IWDG_HW_Msk                            /*!< Independent watchdog HW control */

#define FLASH_OBW1SR_NRST_STOP_Pos           (6U)

#define FLASH_OBW1SR_NRST_STOP_Msk           (0x1UL << FLASH_OBW1SR_NRST_STOP_Pos)               /*!< 0x00000040 */

#define FLASH_OBW1SR_NRST_STOP               FLASH_OBW1SR_NRST_STOP_Msk                          /*!< Reset on stop mode */

#define FLASH_OBW1SR_NRST_STBY_Pos           (7U)

#define FLASH_OBW1SR_NRST_STBY_Msk           (0x1UL << FLASH_OBW1SR_NRST_STBY_Pos)               /*!< 0x00000080 */

#define FLASH_OBW1SR_NRST_STBY               FLASH_OBW1SR_NRST_STBY_Msk                          /*!< Reset on standby mode */

#define FLASH_OBW1SR_XSPI1_HSLV_Pos          (8U)

#define FLASH_OBW1SR_XSPI1_HSLV_Msk          (0x1UL << FLASH_OBW1SR_XSPI1_HSLV_Pos)              /*!< 0x00000100 */

#define FLASH_OBW1SR_XSPI1_HSLV              FLASH_OBW1SR_XSPI1_HSLV_Msk                         /*!< XSPI1 High-speed at low voltage */

#define FLASH_OBW1SR_XSPI2_HSLV_Pos          (9U)

#define FLASH_OBW1SR_XSPI2_HSLV_Msk          (0x1UL << FLASH_OBW1SR_XSPI2_HSLV_Pos)              /*!< 0x00000200 */

#define FLASH_OBW1SR_XSPI2_HSLV              FLASH_OBW1SR_XSPI2_HSLV_Msk                         /*!< XSPI2 High-speed at low voltage */

#define FLASH_OBW1SR_IWDG_FZ_STOP_Pos        (17U)

#define FLASH_OBW1SR_IWDG_FZ_STOP_Msk        (0x1UL << FLASH_OBW1SR_IWDG_FZ_STOP_Pos)            /*!< 0x00020000 */

#define FLASH_OBW1SR_IWDG_FZ_STOP            FLASH_OBW1SR_IWDG_FZ_STOP_Msk                       /*!< IWDG Stop mode freeze */

#define FLASH_OBW1SR_IWDG_FZ_STBY_Pos        (18U)

#define FLASH_OBW1SR_IWDG_FZ_STBY_Msk        (0x1UL << FLASH_OBW1SR_IWDG_FZ_STBY_Pos)            /*!< 0x00040000 */

#define FLASH_OBW1SR_IWDG_FZ_STBY            FLASH_OBW1SR_IWDG_FZ_STBY_Msk                       /*!< IWDG Standby mode freeze */

#define FLASH_OBW1SR_VDDIO_HSLV_Pos          (29U)

#define FLASH_OBW1SR_VDDIO_HSLV_Msk          (0x1UL << FLASH_OBW1SR_VDDIO_HSLV_Pos)              /*!< 0x20000000 */

#define FLASH_OBW1SR_VDDIO_HSLV              FLASH_OBW1SR_VDDIO_HSLV_Msk                         /*!< I/O High-speed at low voltage */

#define FLASH_OBW1SRP_BOR_LEVEL_Pos          (2U)

#define FLASH_OBW1SRP_BOR_LEVEL_Msk          (0x3UL << FLASH_OBW1SRP_BOR_LEVEL_Pos)              /*!< 0x0000000C */

#define FLASH_OBW1SRP_BOR_LEVEL              FLASH_OBW1SRP_BOR_LEVEL_Msk                         /*!< Brownout level */

#define FLASH_OBW1SRP_BOR_LEVEL_0            (0x1UL << FLASH_OBW1SRP_BOR_LEVEL_Pos)              /*!< 0x00000004 */

#define FLASH_OBW1SRP_BOR_LEVEL_1            (0x2UL << FLASH_OBW1SRP_BOR_LEVEL_Pos)              /*!< 0x00000008 */

#define FLASH_OBW1SRP_IWDG_HW_Pos            (4U)

#define FLASH_OBW1SRP_IWDG_HW_Msk            (0x1UL << FLASH_OBW1SRP_IWDG_HW_Pos)                /*!< 0x00000010 */

#define FLASH_OBW1SRP_IWDG_HW                FLASH_OBW1SRP_IWDG_HW_Msk                           /*!< Independent watchdog HW control */

#define FLASH_OBW1SRP_NRST_STOP_Pos          (6U)

#define FLASH_OBW1SRP_NRST_STOP_Msk          (0x1UL << FLASH_OBW1SRP_NRST_STOP_Pos)              /*!< 0x00000040 */

#define FLASH_OBW1SRP_NRST_STOP              FLASH_OBW1SRP_NRST_STOP_Msk                         /*!< Reset on stop mode */

#define FLASH_OBW1SRP_NRST_STBY_Pos          (7U)

#define FLASH_OBW1SRP_NRST_STBY_Msk          (0x1UL << FLASH_OBW1SRP_NRST_STBY_Pos)              /*!< 0x00000080 */

#define FLASH_OBW1SRP_NRST_STBY              FLASH_OBW1SRP_NRST_STBY_Msk                         /*!< Reset on standby mode */

#define FLASH_OBW1SRP_XSPI1_HSLV_Pos         (8U)

#define FLASH_OBW1SRP_XSPI1_HSLV_Msk         (0x1UL << FLASH_OBW1SRP_XSPI1_HSLV_Pos)             /*!< 0x00000100 */

#define FLASH_OBW1SRP_XSPI1_HSLV             FLASH_OBW1SRP_XSPI1_HSLV_Msk                        /*!< XSPI1 High-speed at low voltage */

#define FLASH_OBW1SRP_XSPI2_HSLV_Pos         (9U)

#define FLASH_OBW1SRP_XSPI2_HSLV_Msk         (0x1UL << FLASH_OBW1SRP_XSPI2_HSLV_Pos)             /*!< 0x00000200 */

#define FLASH_OBW1SRP_XSPI2_HSLV             FLASH_OBW1SRP_XSPI2_HSLV_Msk                        /*!< XSPI2 High-speed at low voltage */

#define FLASH_OBW1SRP_IWDG_FZ_STOP_Pos       (17U)

#define FLASH_OBW1SRP_IWDG_FZ_STOP_Msk       (0x1UL << FLASH_OBW1SRP_IWDG_FZ_STOP_Pos)           /*!< 0x00020000 */

#define FLASH_OBW1SRP_IWDG_FZ_STOP           FLASH_OBW1SRP_IWDG_FZ_STOP_Msk                      /*!< IWDG Stop mode freeze */

#define FLASH_OBW1SRP_IWDG_FZ_STBY_Pos       (18U)

#define FLASH_OBW1SRP_IWDG_FZ_STBY_Msk       (0x1UL << FLASH_OBW1SRP_IWDG_FZ_STBY_Pos)           /*!< 0x00040000 */

#define FLASH_OBW1SRP_IWDG_FZ_STBY           FLASH_OBW1SRP_IWDG_FZ_STBY_Msk                      /*!< IWDG Standby mode freeze */

#define FLASH_OBW1SRP_VDDIO_HSLV_Pos         (29U)

#define FLASH_OBW1SRP_VDDIO_HSLV_Msk         (0x1UL << FLASH_OBW1SRP_VDDIO_HSLV_Pos)             /*!< 0x20000000 */

#define FLASH_OBW1SRP_VDDIO_HSLV             FLASH_OBW1SRP_VDDIO_HSLV_Msk                        /*!< I/O High-speed at low voltage */

#define FLASH_OBW2SR_ITCM_AXI_SHARE_Pos      (0U)

#define FLASH_OBW2SR_ITCM_AXI_SHARE_Msk      (0x7UL << FLASH_OBW2SR_ITCM_AXI_SHARE_Pos)          /*!< 0x00000007 */

#define FLASH_OBW2SR_ITCM_AXI_SHARE          FLASH_OBW2SR_ITCM_AXI_SHARE_Msk                     /*!< ITCM AXI share */

#define FLASH_OBW2SR_DTCM_AXI_SHARE_Pos      (4U)

#define FLASH_OBW2SR_DTCM_AXI_SHARE_Msk      (0x7UL << FLASH_OBW2SR_DTCM_AXI_SHARE_Pos)          /*!< 0x00000070 */

#define FLASH_OBW2SR_DTCM_AXI_SHARE          FLASH_OBW2SR_DTCM_AXI_SHARE_Msk                     /*!< DTCM AXI share */

#define FLASH_OBW2SR_ECC_ON_SRAM_Pos         (8U)

#define FLASH_OBW2SR_ECC_ON_SRAM_Msk         (0x1UL << FLASH_OBW2SR_ECC_ON_SRAM_Pos)             /*!< 0x00000100 */

#define FLASH_OBW2SR_ECC_ON_SRAM             FLASH_OBW2SR_ECC_ON_SRAM_Msk                        /*!< ECC on SRAM */

#define FLASH_OBW2SR_I2C_NI3C_Pos            (9U)

#define FLASH_OBW2SR_I2C_NI3C_Msk            (0x1UL << FLASH_OBW2SR_I2C_NI3C_Pos)                /*!< 0x00000200 */

#define FLASH_OBW2SR_I2C_NI3C                FLASH_OBW2SR_I2C_NI3C_Msk                           /*!< I2C Not I3C */

#define FLASH_OBW2SRP_ITCM_AXI_SHARE_Pos     (0U)

#define FLASH_OBW2SRP_ITCM_AXI_SHARE_Msk     (0x7UL << FLASH_OBW2SRP_ITCM_AXI_SHARE_Pos)         /*!< 0x00000007 */

#define FLASH_OBW2SRP_ITCM_AXI_SHARE         FLASH_OBW2SRP_ITCM_AXI_SHARE_Msk                    /*!< ITCM AXI share */

#define FLASH_OBW2SRP_ITCM_AXI_SHARE_0       (0x1UL << FLASH_OBW2SRP_ITCM_AXI_SHARE_Pos)         /*!< 0x00000001 */

#define FLASH_OBW2SRP_ITCM_AXI_SHARE_1       (0x2UL << FLASH_OBW2SRP_ITCM_AXI_SHARE_Pos)         /*!< 0x00000002 */

#define FLASH_OBW2SRP_ITCM_AXI_SHARE_2       (0x4UL << FLASH_OBW2SRP_ITCM_AXI_SHARE_Pos)         /*!< 0x00000004 */

#define FLASH_OBW2SRP_DTCM_AXI_SHARE_Pos     (4U)

#define FLASH_OBW2SRP_DTCM_AXI_SHARE_Msk     (0x7UL << FLASH_OBW2SRP_DTCM_AXI_SHARE_Pos)         /*!< 0x00000070 */

#define FLASH_OBW2SRP_DTCM_AXI_SHARE         FLASH_OBW2SRP_DTCM_AXI_SHARE_Msk                    /*!< DTCM AXI share */

#define FLASH_OBW2SRP_DTCM_AXI_SHARE_0       (0x1UL << FLASH_OBW2SRP_DTCM_AXI_SHARE_Pos)         /*!< 0x00000010 */

#define FLASH_OBW2SRP_DTCM_AXI_SHARE_1       (0x2UL << FLASH_OBW2SRP_DTCM_AXI_SHARE_Pos)         /*!< 0x00000020 */

#define FLASH_OBW2SRP_DTCM_AXI_SHARE_2       (0x4UL << FLASH_OBW2SRP_DTCM_AXI_SHARE_Pos)         /*!< 0x00000040 */

#define FLASH_OBW2SRP_ECC_ON_SRAM_Pos        (8U)

#define FLASH_OBW2SRP_ECC_ON_SRAM_Msk        (0x1UL << FLASH_OBW2SRP_ECC_ON_SRAM_Pos)            /*!< 0x00000100 */

#define FLASH_OBW2SRP_ECC_ON_SRAM            FLASH_OBW2SRP_ECC_ON_SRAM_Msk                       /*!< ECC on SRAM */

#define FLASH_OBW2SRP_I2C_NI3C_Pos           (9U)

#define FLASH_OBW2SRP_I2C_NI3C_Msk           (0x1UL << FLASH_OBW2SRP_I2C_NI3C_Pos)               /*!< 0x00000200 */

#define FLASH_OBW2SRP_I2C_NI3C               FLASH_OBW2SRP_I2C_NI3C_Msk                          /*!< I2C Not I3C */
