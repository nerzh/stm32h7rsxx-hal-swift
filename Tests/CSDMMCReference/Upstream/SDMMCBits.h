// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

#define DLYB_CR_DEN_Pos                     (0U)
#define DLYB_CR_DEN_Msk                     (0x1UL << DLYB_CR_DEN_Pos)              /*!< 0x00000001 */
#define DLYB_CR_DEN                         DLYB_CR_DEN_Msk                         /*!<Delay Block enable */
#define DLYB_CR_SEN_Pos                     (1U)
#define DLYB_CR_SEN_Msk                     (0x1UL << DLYB_CR_SEN_Pos)              /*!< 0x00000002 */
#define DLYB_CR_SEN                         DLYB_CR_SEN_Msk                         /*!<Sampler length enable */
#define DLYB_CFGR_SEL_Pos                   (0U)
#define DLYB_CFGR_SEL_Msk                   (0xFUL << DLYB_CFGR_SEL_Pos)            /*!< 0x0000000F */
#define DLYB_CFGR_SEL                       DLYB_CFGR_SEL_Msk                       /*!<Select the phase for the Output clock[3:0] */
#define DLYB_CFGR_SEL_0                     (0x1UL << DLYB_CFGR_SEL_Pos)            /*!< 0x00000001 */
#define DLYB_CFGR_SEL_1                     (0x2UL << DLYB_CFGR_SEL_Pos)            /*!< 0x00000002 */
#define DLYB_CFGR_SEL_2                     (0x3UL << DLYB_CFGR_SEL_Pos)            /*!< 0x00000003 */
#define DLYB_CFGR_SEL_3                     (0x8UL << DLYB_CFGR_SEL_Pos)            /*!< 0x00000008 */
#define DLYB_CFGR_UNIT_Pos                  (8U)
#define DLYB_CFGR_UNIT_Msk                  (0x7FUL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00007F00 */
#define DLYB_CFGR_UNIT                      DLYB_CFGR_UNIT_Msk                      /*!<Delay Defines the delay of a Unit delay cell[6:0] */
#define DLYB_CFGR_UNIT_0                    (0x01UL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00000100 */
#define DLYB_CFGR_UNIT_1                    (0x02UL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00000200 */
#define DLYB_CFGR_UNIT_2                    (0x04UL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00000400 */
#define DLYB_CFGR_UNIT_3                    (0x08UL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00000800 */
#define DLYB_CFGR_UNIT_4                    (0x10UL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00001000 */
#define DLYB_CFGR_UNIT_5                    (0x20UL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00002000 */
#define DLYB_CFGR_UNIT_6                    (0x40UL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00004000 */
#define DLYB_CFGR_LNG_Pos                   (16U)
#define DLYB_CFGR_LNG_Msk                   (0xFFFUL << DLYB_CFGR_LNG_Pos)          /*!< 0x0FFF0000 */
#define DLYB_CFGR_LNG                       DLYB_CFGR_LNG_Msk                       /*!<Delay line length value[11:0] */
#define DLYB_CFGR_LNG_0                     (0x001UL << DLYB_CFGR_LNG_Pos)          /*!< 0x00010000 */
#define DLYB_CFGR_LNG_1                     (0x002UL << DLYB_CFGR_LNG_Pos)          /*!< 0x00020000 */
#define DLYB_CFGR_LNG_2                     (0x004UL << DLYB_CFGR_LNG_Pos)          /*!< 0x00040000 */
#define DLYB_CFGR_LNG_3                     (0x008UL << DLYB_CFGR_LNG_Pos)          /*!< 0x00080000 */
#define DLYB_CFGR_LNG_4                     (0x010UL << DLYB_CFGR_LNG_Pos)          /*!< 0x00100000 */
#define DLYB_CFGR_LNG_5                     (0x020UL << DLYB_CFGR_LNG_Pos)          /*!< 0x00200000 */
#define DLYB_CFGR_LNG_6                     (0x040UL << DLYB_CFGR_LNG_Pos)          /*!< 0x00400000 */
#define DLYB_CFGR_LNG_7                     (0x080UL << DLYB_CFGR_LNG_Pos)          /*!< 0x00800000 */
#define DLYB_CFGR_LNG_8                     (0x100UL << DLYB_CFGR_LNG_Pos)          /*!< 0x01000000 */
#define DLYB_CFGR_LNG_9                     (0x200UL << DLYB_CFGR_LNG_Pos)          /*!< 0x02000000 */
#define DLYB_CFGR_LNG_10                    (0x400UL << DLYB_CFGR_LNG_Pos)          /*!< 0x04000000 */
#define DLYB_CFGR_LNG_11                    (0x800UL << DLYB_CFGR_LNG_Pos)          /*!< 0x08000000 */
#define DLYB_CFGR_LNGF_Pos                  (31U)
#define DLYB_CFGR_LNGF_Msk                  (0x1UL << DLYB_CFGR_LNGF_Pos)            /*!< 0x80000000 */
#define DLYB_CFGR_LNGF                      DLYB_CFGR_LNGF_Msk                       /*!<Length valid flag */
#define SDMMC_POWER_PWRCTRL_Pos             (0U)
#define SDMMC_POWER_PWRCTRL_Msk             (0x3UL << SDMMC_POWER_PWRCTRL_Pos)              /*!< 0x00000003 */
#define SDMMC_POWER_PWRCTRL                 SDMMC_POWER_PWRCTRL_Msk                         /*!< SDMMC state control bits */
#define SDMMC_POWER_PWRCTRL_0               (0x1UL << SDMMC_POWER_PWRCTRL_Pos)              /*!< 0x00000001 */
#define SDMMC_POWER_PWRCTRL_1               (0x2UL << SDMMC_POWER_PWRCTRL_Pos)              /*!< 0x00000002 */
#define SDMMC_POWER_VSWITCH_Pos             (2U)
#define SDMMC_POWER_VSWITCH_Msk             (0x1UL << SDMMC_POWER_VSWITCH_Pos)              /*!< 0x00000004 */
#define SDMMC_POWER_VSWITCH                 SDMMC_POWER_VSWITCH_Msk                         /*!< Voltage switch sequence start */
#define SDMMC_POWER_VSWITCHEN_Pos           (3U)
#define SDMMC_POWER_VSWITCHEN_Msk           (0x1UL << SDMMC_POWER_VSWITCHEN_Pos)            /*!< 0x00000008 */
#define SDMMC_POWER_VSWITCHEN               SDMMC_POWER_VSWITCHEN_Msk                       /*!< Voltage switch procedure enable */
#define SDMMC_POWER_DIRPOL_Pos              (4U)
#define SDMMC_POWER_DIRPOL_Msk              (0x1UL << SDMMC_POWER_DIRPOL_Pos)               /*!< 0x00000010 */
#define SDMMC_POWER_DIRPOL                  SDMMC_POWER_DIRPOL_Msk                          /*!< Data and command direction signals polarity selection */
#define SDMMC_CLKCR_CLKDIV_Pos              (0U)
#define SDMMC_CLKCR_CLKDIV_Msk              (0x3FFUL << SDMMC_CLKCR_CLKDIV_Pos)             /*!< 0x000003FF */
#define SDMMC_CLKCR_CLKDIV                  SDMMC_CLKCR_CLKDIV_Msk                          /*!< Clock divide factor */
#define SDMMC_CLKCR_PWRSAV_Pos              (12U)
#define SDMMC_CLKCR_PWRSAV_Msk              (0x1UL << SDMMC_CLKCR_PWRSAV_Pos)               /*!< 0x00001000 */
#define SDMMC_CLKCR_PWRSAV                  SDMMC_CLKCR_PWRSAV_Msk                          /*!< Power saving configuration bit */
#define SDMMC_CLKCR_WIDBUS_Pos              (14U)
#define SDMMC_CLKCR_WIDBUS_Msk              (0x3UL << SDMMC_CLKCR_WIDBUS_Pos)               /*!< 0x0000C000 */
#define SDMMC_CLKCR_WIDBUS                  SDMMC_CLKCR_WIDBUS_Msk                          /*!< Wide bus mode enable bit */
#define SDMMC_CLKCR_WIDBUS_0                (0x1UL << SDMMC_CLKCR_WIDBUS_Pos)               /*!< 0x00004000 */
#define SDMMC_CLKCR_WIDBUS_1                (0x2UL << SDMMC_CLKCR_WIDBUS_Pos)               /*!< 0x00008000 */
#define SDMMC_CLKCR_NEGEDGE_Pos             (16U)
#define SDMMC_CLKCR_NEGEDGE_Msk             (0x1UL << SDMMC_CLKCR_NEGEDGE_Pos)              /*!< 0x00010000 */
#define SDMMC_CLKCR_NEGEDGE                 SDMMC_CLKCR_NEGEDGE_Msk                         /*!< SDMMC_CK dephasing selection bit */
#define SDMMC_CLKCR_HWFC_EN_Pos             (17U)
#define SDMMC_CLKCR_HWFC_EN_Msk             (0x1UL << SDMMC_CLKCR_HWFC_EN_Pos)              /*!< 0x00020000 */
#define SDMMC_CLKCR_HWFC_EN                 SDMMC_CLKCR_HWFC_EN_Msk                         /*!< Hardware flow control enable */
#define SDMMC_CLKCR_DDR_Pos                 (18U)
#define SDMMC_CLKCR_DDR_Msk                 (0x1UL << SDMMC_CLKCR_DDR_Pos)                  /*!< 0x00040000 */
#define SDMMC_CLKCR_DDR                     SDMMC_CLKCR_DDR_Msk                             /*!< Data rate signal selection */
#define SDMMC_CLKCR_BUSSPEED_Pos            (19U)
#define SDMMC_CLKCR_BUSSPEED_Msk            (0x1UL << SDMMC_CLKCR_BUSSPEED_Pos)             /*!< 0x00080000 */
#define SDMMC_CLKCR_BUSSPEED                SDMMC_CLKCR_BUSSPEED_Msk                        /*!< Bus speed mode selection */
#define SDMMC_CLKCR_SELCLKRX_Pos            (20U)
#define SDMMC_CLKCR_SELCLKRX_Msk            (0x3UL << SDMMC_CLKCR_SELCLKRX_Pos)             /*!< 0x00300000 */
#define SDMMC_CLKCR_SELCLKRX                SDMMC_CLKCR_SELCLKRX_Msk                        /*!< Receive clock selection */
#define SDMMC_CLKCR_SELCLKRX_0              (0x1UL << SDMMC_CLKCR_SELCLKRX_Pos)             /*!< 0x00100000 */
#define SDMMC_CLKCR_SELCLKRX_1              (0x2UL << SDMMC_CLKCR_SELCLKRX_Pos)             /*!< 0x00200000 */
#define SDMMC_ARG_CMDARG_Pos                (0U)
#define SDMMC_ARG_CMDARG_Msk                (0xFFFFFFFFUL << SDMMC_ARG_CMDARG_Pos)          /*!< 0xFFFFFFFF */
#define SDMMC_ARG_CMDARG                    SDMMC_ARG_CMDARG_Msk                            /*!< Command argument */
#define SDMMC_CMD_CMDINDEX_Pos              (0U)
#define SDMMC_CMD_CMDINDEX_Msk              (0x3FUL << SDMMC_CMD_CMDINDEX_Pos)              /*!< 0x0000003F */
#define SDMMC_CMD_CMDINDEX                  SDMMC_CMD_CMDINDEX_Msk                          /*!< Command index */
#define SDMMC_CMD_CMDTRANS_Pos              (6U)
#define SDMMC_CMD_CMDTRANS_Msk              (0x1UL << SDMMC_CMD_CMDTRANS_Pos)               /*!< 0x00000040 */
#define SDMMC_CMD_CMDTRANS                  SDMMC_CMD_CMDTRANS_Msk                          /*!< CPSM treats the command as a data transfer command */
#define SDMMC_CMD_CMDSTOP_Pos               (7U)
#define SDMMC_CMD_CMDSTOP_Msk               (0x1UL << SDMMC_CMD_CMDSTOP_Pos)                /*!< 0x00000080 */
#define SDMMC_CMD_CMDSTOP                   SDMMC_CMD_CMDSTOP_Msk                           /*!< CPSM treats the command as a stop transmission command */
#define SDMMC_CMD_WAITRESP_Pos              (8U)
#define SDMMC_CMD_WAITRESP_Msk              (0x3UL << SDMMC_CMD_WAITRESP_Pos)               /*!< 0x00000300 */
#define SDMMC_CMD_WAITRESP                  SDMMC_CMD_WAITRESP_Msk                          /*!< Wait for response bits */
#define SDMMC_CMD_WAITRESP_0                (0x1UL << SDMMC_CMD_WAITRESP_Pos)               /*!< 0x00000100 */
#define SDMMC_CMD_WAITRESP_1                (0x2UL << SDMMC_CMD_WAITRESP_Pos)               /*!< 0x00000200 */
#define SDMMC_CMD_WAITINT_Pos               (10U)
#define SDMMC_CMD_WAITINT_Msk               (0x1UL << SDMMC_CMD_WAITINT_Pos)                /*!< 0x00000400 */
#define SDMMC_CMD_WAITINT                   SDMMC_CMD_WAITINT_Msk                           /*!< CPSM waits for interrupt request */
#define SDMMC_CMD_WAITPEND_Pos              (11U)
#define SDMMC_CMD_WAITPEND_Msk              (0x1UL << SDMMC_CMD_WAITPEND_Pos)               /*!< 0x00000800 */
#define SDMMC_CMD_WAITPEND                  SDMMC_CMD_WAITPEND_Msk                          /*!< CPSM waits for end of data transfer from DPSM */
#define SDMMC_CMD_CPSMEN_Pos                (12U)
#define SDMMC_CMD_CPSMEN_Msk                (0x1UL << SDMMC_CMD_CPSMEN_Pos)                 /*!< 0x00001000 */
#define SDMMC_CMD_CPSMEN                    SDMMC_CMD_CPSMEN_Msk                            /*!< Command path state machine enable bit */
#define SDMMC_CMD_DTHOLD_Pos                (13U)
#define SDMMC_CMD_DTHOLD_Msk                (0x1UL << SDMMC_CMD_DTHOLD_Pos)                 /*!< 0x00002000 */
#define SDMMC_CMD_DTHOLD                    SDMMC_CMD_DTHOLD_Msk                            /*!< Hold new data block transmission and reception in DPSM */
#define SDMMC_CMD_BOOTMODE_Pos              (14U)
#define SDMMC_CMD_BOOTMODE_Msk              (0x1UL << SDMMC_CMD_BOOTMODE_Pos)               /*!< 0x00004000 */
#define SDMMC_CMD_BOOTMODE                  SDMMC_CMD_BOOTMODE_Msk                          /*!< Select the boot mode procedure to be used */
#define SDMMC_CMD_BOOTEN_Pos                (15U)
#define SDMMC_CMD_BOOTEN_Msk                (0x1UL << SDMMC_CMD_BOOTEN_Pos)                 /*!< 0x00008000 */
#define SDMMC_CMD_BOOTEN                    SDMMC_CMD_BOOTEN_Msk                            /*!< Enable boot mode procedure */
#define SDMMC_CMD_CMDSUSPEND_Pos            (16U)
#define SDMMC_CMD_CMDSUSPEND_Msk            (0x1UL << SDMMC_CMD_CMDSUSPEND_Pos)             /*!< 0x00010000 */
#define SDMMC_CMD_CMDSUSPEND                SDMMC_CMD_CMDSUSPEND_Msk                        /*!< CPSM treats the command as a suspend or resume command */
#define SDMMC_RESPCMD_RESPCMD_Pos           (0U)
#define SDMMC_RESPCMD_RESPCMD_Msk           (0x3FUL << SDMMC_RESPCMD_RESPCMD_Pos)           /*!< 0x0000003F */
#define SDMMC_RESPCMD_RESPCMD               SDMMC_RESPCMD_RESPCMD_Msk                       /*!< Response command index */
#define SDMMC_RESP1_CARDSTATUS1_Pos         (0U)
#define SDMMC_RESP1_CARDSTATUS1_Msk         (0xFFFFFFFFUL << SDMMC_RESP1_CARDSTATUS1_Pos)   /*!< 0xFFFFFFFF */
#define SDMMC_RESP1_CARDSTATUS1             SDMMC_RESP1_CARDSTATUS1_Msk                     /*!< Card status [31:0] (short response) or [127:96] (long response) */
#define SDMMC_RESP2_CARDSTATUS2_Pos         (0U)
#define SDMMC_RESP2_CARDSTATUS2_Msk         (0xFFFFFFFFUL << SDMMC_RESP2_CARDSTATUS2_Pos)   /*!< 0xFFFFFFFF */
#define SDMMC_RESP2_CARDSTATUS2             SDMMC_RESP2_CARDSTATUS2_Msk                     /*!< Card status [95:64] (long response) */
#define SDMMC_RESP3_CARDSTATUS3_Pos         (0U)
#define SDMMC_RESP3_CARDSTATUS3_Msk         (0xFFFFFFFFUL << SDMMC_RESP3_CARDSTATUS3_Pos)   /*!< 0xFFFFFFFF */
#define SDMMC_RESP3_CARDSTATUS3             SDMMC_RESP3_CARDSTATUS3_Msk                     /*!< Card status [63:32] (long response) */
#define SDMMC_RESP4_CARDSTATUS4_Pos         (0U)
#define SDMMC_RESP4_CARDSTATUS4_Msk         (0xFFFFFFFFUL << SDMMC_RESP4_CARDSTATUS4_Pos)   /*!< 0xFFFFFFFF */
#define SDMMC_RESP4_CARDSTATUS4             SDMMC_RESP4_CARDSTATUS4_Msk                     /*!< Card status [31:0] (long response) */
#define SDMMC_DTIMER_DATATIME_Pos           (0U)
#define SDMMC_DTIMER_DATATIME_Msk           (0xFFFFFFFFUL << SDMMC_DTIMER_DATATIME_Pos)     /*!< 0xFFFFFFFF */
#define SDMMC_DTIMER_DATATIME               SDMMC_DTIMER_DATATIME_Msk                       /*!< Data and R1b busy timeout period */
#define SDMMC_DLEN_DATALENGTH_Pos           (0U)
#define SDMMC_DLEN_DATALENGTH_Msk           (0x07FFFFFFUL << SDMMC_DLEN_DATALENGTH_Pos)     /*!< 0x07FFFFFF */
#define SDMMC_DLEN_DATALENGTH               SDMMC_DLEN_DATALENGTH_Msk                       /*!< Data length value */
#define SDMMC_DCTRL_DTEN_Pos                (0U)
#define SDMMC_DCTRL_DTEN_Msk                (0x1UL << SDMMC_DCTRL_DTEN_Pos)                 /*!< 0x00000001 */
#define SDMMC_DCTRL_DTEN                    SDMMC_DCTRL_DTEN_Msk                            /*!< Data transfer enable bit */
#define SDMMC_DCTRL_DTDIR_Pos               (1U)
#define SDMMC_DCTRL_DTDIR_Msk               (0x1UL << SDMMC_DCTRL_DTDIR_Pos)                /*!< 0x00000002 */
#define SDMMC_DCTRL_DTDIR                   SDMMC_DCTRL_DTDIR_Msk                           /*!< Data transfer direction selection */
#define SDMMC_DCTRL_DTMODE_Pos              (2U)
#define SDMMC_DCTRL_DTMODE_Msk              (0x3UL << SDMMC_DCTRL_DTMODE_Pos)               /*!< 0x0000000C */
#define SDMMC_DCTRL_DTMODE                  SDMMC_DCTRL_DTMODE_Msk                          /*!< Data transfer mode selection */
#define SDMMC_DCTRL_DTMODE_0                (0x1UL << SDMMC_DCTRL_DTMODE_Pos)               /*!< 0x00000004 */
#define SDMMC_DCTRL_DTMODE_1                (0x2UL << SDMMC_DCTRL_DTMODE_Pos)               /*!< 0x00000008 */
#define SDMMC_DCTRL_DBLOCKSIZE_Pos          (4U)
#define SDMMC_DCTRL_DBLOCKSIZE_Msk          (0xFUL << SDMMC_DCTRL_DBLOCKSIZE_Pos)           /*!< 0x000000F0 */
#define SDMMC_DCTRL_DBLOCKSIZE              SDMMC_DCTRL_DBLOCKSIZE_Msk                      /*!< Data block size */
#define SDMMC_DCTRL_DBLOCKSIZE_0            (0x1UL << SDMMC_DCTRL_DBLOCKSIZE_Pos)           /*!< 0x00000010 */
#define SDMMC_DCTRL_DBLOCKSIZE_1            (0x2UL << SDMMC_DCTRL_DBLOCKSIZE_Pos)           /*!< 0x00000020 */
#define SDMMC_DCTRL_DBLOCKSIZE_2            (0x4UL << SDMMC_DCTRL_DBLOCKSIZE_Pos)           /*!< 0x00000040 */
#define SDMMC_DCTRL_DBLOCKSIZE_3            (0x8UL << SDMMC_DCTRL_DBLOCKSIZE_Pos)           /*!< 0x00000080 */
#define SDMMC_DCTRL_RWSTART_Pos             (8U)
#define SDMMC_DCTRL_RWSTART_Msk             (0x1UL << SDMMC_DCTRL_RWSTART_Pos)              /*!< 0x00000100 */
#define SDMMC_DCTRL_RWSTART                 SDMMC_DCTRL_RWSTART_Msk                         /*!< Read wait start */
#define SDMMC_DCTRL_RWSTOP_Pos              (9U)
#define SDMMC_DCTRL_RWSTOP_Msk              (0x1UL << SDMMC_DCTRL_RWSTOP_Pos)               /*!< 0x00000200 */
#define SDMMC_DCTRL_RWSTOP                  SDMMC_DCTRL_RWSTOP_Msk                          /*!< Read wait stop */
#define SDMMC_DCTRL_RWMOD_Pos               (10U)
#define SDMMC_DCTRL_RWMOD_Msk               (0x1UL << SDMMC_DCTRL_RWMOD_Pos)                /*!< 0x00000400 */
#define SDMMC_DCTRL_RWMOD                   SDMMC_DCTRL_RWMOD_Msk                           /*!< Read wait mode */
#define SDMMC_DCTRL_SDIOEN_Pos              (11U)
#define SDMMC_DCTRL_SDIOEN_Msk              (0x1UL << SDMMC_DCTRL_SDIOEN_Pos)               /*!< 0x00000800 */
#define SDMMC_DCTRL_SDIOEN                  SDMMC_DCTRL_SDIOEN_Msk                          /*!< SD I/O interrupt enable functions */
#define SDMMC_DCTRL_BOOTACKEN_Pos           (12U)
#define SDMMC_DCTRL_BOOTACKEN_Msk           (0x1UL << SDMMC_DCTRL_BOOTACKEN_Pos)            /*!< 0x00001000 */
#define SDMMC_DCTRL_BOOTACKEN               SDMMC_DCTRL_BOOTACKEN_Msk                       /*!< Enable the reception of the boot acknowledgement */
#define SDMMC_DCTRL_FIFORST_Pos             (13U)
#define SDMMC_DCTRL_FIFORST_Msk             (0x1UL << SDMMC_DCTRL_FIFORST_Pos)              /*!< 0x00002000 */
#define SDMMC_DCTRL_FIFORST                 SDMMC_DCTRL_FIFORST_Msk                         /*!< FIFO reset (flush any remaining data) */
#define SDMMC_DCOUNT_DATACOUNT_Pos          (0U)
#define SDMMC_DCOUNT_DATACOUNT_Msk          (0x07FFFFFFUL << SDMMC_DCOUNT_DATACOUNT_Pos)    /*!< 0x07FFFFFF */
#define SDMMC_DCOUNT_DATACOUNT              SDMMC_DCOUNT_DATACOUNT_Msk                      /*!< Data count value */
#define SDMMC_STA_CCRCFAIL_Pos              (0U)
#define SDMMC_STA_CCRCFAIL_Msk              (0x1UL << SDMMC_STA_CCRCFAIL_Pos)               /*!< 0x00000001 */
#define SDMMC_STA_CCRCFAIL                  SDMMC_STA_CCRCFAIL_Msk                          /*!< Command response received (CRC check failed) */
#define SDMMC_STA_DCRCFAIL_Pos              (1U)
#define SDMMC_STA_DCRCFAIL_Msk              (0x1UL << SDMMC_STA_DCRCFAIL_Pos)               /*!< 0x00000002 */
#define SDMMC_STA_DCRCFAIL                  SDMMC_STA_DCRCFAIL_Msk                          /*!< Data block sent/received (CRC check failed) */
#define SDMMC_STA_CTIMEOUT_Pos              (2U)
#define SDMMC_STA_CTIMEOUT_Msk              (0x1UL << SDMMC_STA_CTIMEOUT_Pos)               /*!< 0x00000004 */
#define SDMMC_STA_CTIMEOUT                  SDMMC_STA_CTIMEOUT_Msk                          /*!< Command response timeout */
#define SDMMC_STA_DTIMEOUT_Pos              (3U)
#define SDMMC_STA_DTIMEOUT_Msk              (0x1UL << SDMMC_STA_DTIMEOUT_Pos)               /*!< 0x00000008 */
#define SDMMC_STA_DTIMEOUT                  SDMMC_STA_DTIMEOUT_Msk                          /*!< Data timeout */
#define SDMMC_STA_TXUNDERR_Pos              (4U)
#define SDMMC_STA_TXUNDERR_Msk              (0x1UL << SDMMC_STA_TXUNDERR_Pos)               /*!< 0x00000010 */
#define SDMMC_STA_TXUNDERR                  SDMMC_STA_TXUNDERR_Msk                          /*!< Transmit FIFO underrun error */
#define SDMMC_STA_RXOVERR_Pos               (5U)
#define SDMMC_STA_RXOVERR_Msk               (0x1UL << SDMMC_STA_RXOVERR_Pos)                /*!< 0x00000020 */
#define SDMMC_STA_RXOVERR                   SDMMC_STA_RXOVERR_Msk                           /*!< Received FIFO overrun error */
#define SDMMC_STA_CMDREND_Pos               (6U)
#define SDMMC_STA_CMDREND_Msk               (0x1UL << SDMMC_STA_CMDREND_Pos)                /*!< 0x00000040 */
#define SDMMC_STA_CMDREND                   SDMMC_STA_CMDREND_Msk                           /*!< Command response received (CRC check passed or no CRC) */
#define SDMMC_STA_CMDSENT_Pos               (7U)
#define SDMMC_STA_CMDSENT_Msk               (0x1UL << SDMMC_STA_CMDSENT_Pos)                /*!< 0x00000080 */
#define SDMMC_STA_CMDSENT                   SDMMC_STA_CMDSENT_Msk                           /*!< Command sent (no response required) */
#define SDMMC_STA_DATAEND_Pos               (8U)
#define SDMMC_STA_DATAEND_Msk               (0x1UL << SDMMC_STA_DATAEND_Pos)                /*!< 0x00000100 */
#define SDMMC_STA_DATAEND                   SDMMC_STA_DATAEND_Msk                           /*!< Data transfer ended correctly */
#define SDMMC_STA_DHOLD_Pos                 (9U)
#define SDMMC_STA_DHOLD_Msk                 (0x1UL << SDMMC_STA_DHOLD_Pos)                  /*!< 0x00000200 */
#define SDMMC_STA_DHOLD                     SDMMC_STA_DHOLD_Msk                             /*!< Data transfer hold */
#define SDMMC_STA_DBCKEND_Pos               (10U)
#define SDMMC_STA_DBCKEND_Msk               (0x1UL << SDMMC_STA_DBCKEND_Pos)                /*!< 0x00000400 */
#define SDMMC_STA_DBCKEND                   SDMMC_STA_DBCKEND_Msk                           /*!< Data block sent/received */
#define SDMMC_STA_DABORT_Pos                (11U)
#define SDMMC_STA_DABORT_Msk                (0x1UL << SDMMC_STA_DABORT_Pos)                 /*!< 0x00000800 */
#define SDMMC_STA_DABORT                    SDMMC_STA_DABORT_Msk                            /*!< Data transfer aborted by CMD12 */
#define SDMMC_STA_DPSMACT_Pos               (12U)
#define SDMMC_STA_DPSMACT_Msk               (0x1UL << SDMMC_STA_DPSMACT_Pos)                /*!< 0x00001000 */
#define SDMMC_STA_DPSMACT                   SDMMC_STA_DPSMACT_Msk                           /*!< Data path state machine active */
#define SDMMC_STA_CPSMACT_Pos               (13U)
#define SDMMC_STA_CPSMACT_Msk               (0x1UL << SDMMC_STA_CPSMACT_Pos)                /*!< 0x00002000 */
#define SDMMC_STA_CPSMACT                   SDMMC_STA_CPSMACT_Msk                           /*!< Command path state machine active */
#define SDMMC_STA_TXFIFOHE_Pos              (14U)
#define SDMMC_STA_TXFIFOHE_Msk              (0x1UL << SDMMC_STA_TXFIFOHE_Pos)               /*!< 0x00004000 */
#define SDMMC_STA_TXFIFOHE                  SDMMC_STA_TXFIFOHE_Msk                          /*!< Transmit FIFO half empty */
#define SDMMC_STA_RXFIFOHF_Pos              (15U)
#define SDMMC_STA_RXFIFOHF_Msk              (0x1UL << SDMMC_STA_RXFIFOHF_Pos)               /*!< 0x00008000 */
#define SDMMC_STA_RXFIFOHF                  SDMMC_STA_RXFIFOHF_Msk                          /*!< Receive FIFO half full */
#define SDMMC_STA_TXFIFOF_Pos               (16U)
#define SDMMC_STA_TXFIFOF_Msk               (0x1UL << SDMMC_STA_TXFIFOF_Pos)                /*!< 0x00010000 */
#define SDMMC_STA_TXFIFOF                   SDMMC_STA_TXFIFOF_Msk                           /*!< Transmit FIFO full */
#define SDMMC_STA_RXFIFOF_Pos               (17U)
#define SDMMC_STA_RXFIFOF_Msk               (0x1UL << SDMMC_STA_RXFIFOF_Pos)                /*!< 0x00020000 */
#define SDMMC_STA_RXFIFOF                   SDMMC_STA_RXFIFOF_Msk                           /*!< Receive FIFO full */
#define SDMMC_STA_TXFIFOE_Pos               (18U)
#define SDMMC_STA_TXFIFOE_Msk               (0x1UL << SDMMC_STA_TXFIFOE_Pos)                /*!< 0x00040000 */
#define SDMMC_STA_TXFIFOE                   SDMMC_STA_TXFIFOE_Msk                           /*!< Transmit FIFO empty */
#define SDMMC_STA_RXFIFOE_Pos               (19U)
#define SDMMC_STA_RXFIFOE_Msk               (0x1UL << SDMMC_STA_RXFIFOE_Pos)                /*!< 0x00080000 */
#define SDMMC_STA_RXFIFOE                   SDMMC_STA_RXFIFOE_Msk                           /*!< Receive FIFO empty */
#define SDMMC_STA_BUSYD0_Pos                (20U)
#define SDMMC_STA_BUSYD0_Msk                (0x1UL << SDMMC_STA_BUSYD0_Pos)                 /*!< 0x00100000 */
#define SDMMC_STA_BUSYD0                    SDMMC_STA_BUSYD0_Msk                            /*!< Inverted value of SDMMC_D0 line (busy) */
#define SDMMC_STA_BUSYD0END_Pos             (21U)
#define SDMMC_STA_BUSYD0END_Msk             (0x1UL << SDMMC_STA_BUSYD0END_Pos)              /*!< 0x00200000 */
#define SDMMC_STA_BUSYD0END                 SDMMC_STA_BUSYD0END_Msk                         /*!< End of SDMMC_D0 busy following a CMD response detected */
#define SDMMC_STA_SDIOIT_Pos                (22U)
#define SDMMC_STA_SDIOIT_Msk                (0x1UL << SDMMC_STA_SDIOIT_Pos)                 /*!< 0x00400000 */
#define SDMMC_STA_SDIOIT                    SDMMC_STA_SDIOIT_Msk                            /*!< SDIO interrupt received */
#define SDMMC_STA_ACKFAIL_Pos               (23U)
#define SDMMC_STA_ACKFAIL_Msk               (0x1UL << SDMMC_STA_ACKFAIL_Pos)                /*!< 0x00800000 */
#define SDMMC_STA_ACKFAIL                   SDMMC_STA_ACKFAIL_Msk                           /*!< Boot acknowledgement received (boot acknowledgement check fail) */
#define SDMMC_STA_ACKTIMEOUT_Pos            (24U)
#define SDMMC_STA_ACKTIMEOUT_Msk            (0x1UL << SDMMC_STA_ACKTIMEOUT_Pos)             /*!< 0x01000000 */
#define SDMMC_STA_ACKTIMEOUT                SDMMC_STA_ACKTIMEOUT_Msk                        /*!< Boot acknowledgement timeout */
#define SDMMC_STA_VSWEND_Pos                (25U)
#define SDMMC_STA_VSWEND_Msk                (0x1UL << SDMMC_STA_VSWEND_Pos)                 /*!< 0x02000000 */
#define SDMMC_STA_VSWEND                    SDMMC_STA_VSWEND_Msk                            /*!< Voltage switch critical timing section completion */
#define SDMMC_STA_CKSTOP_Pos                (26U)
#define SDMMC_STA_CKSTOP_Msk                (0x1UL << SDMMC_STA_CKSTOP_Pos)                 /*!< 0x04000000 */
#define SDMMC_STA_CKSTOP                    SDMMC_STA_CKSTOP_Msk                            /*!< SDMMC_CK stopped in voltage switch procedure */
#define SDMMC_STA_IDMATE_Pos                (27U)
#define SDMMC_STA_IDMATE_Msk                (0x1UL << SDMMC_STA_IDMATE_Pos)                 /*!< 0x08000000 */
#define SDMMC_STA_IDMATE                    SDMMC_STA_IDMATE_Msk                            /*!< IDMA transfer error */
#define SDMMC_STA_IDMABTC_Pos               (28U)
#define SDMMC_STA_IDMABTC_Msk               (0x1UL << SDMMC_STA_IDMABTC_Pos)                /*!< 0x10000000 */
#define SDMMC_STA_IDMABTC                   SDMMC_STA_IDMABTC_Msk                           /*!< IDMA buffer transfer complete */
#define SDMMC_ICR_CCRCFAILC_Pos             (0U)
#define SDMMC_ICR_CCRCFAILC_Msk             (0x1UL << SDMMC_ICR_CCRCFAILC_Pos)              /*!< 0x00000001 */
#define SDMMC_ICR_CCRCFAILC                 SDMMC_ICR_CCRCFAILC_Msk                         /*!< Command response received (CRC check failed) clear bit */
#define SDMMC_ICR_DCRCFAILC_Pos             (1U)
#define SDMMC_ICR_DCRCFAILC_Msk             (0x1UL << SDMMC_ICR_DCRCFAILC_Pos)              /*!< 0x00000002 */
#define SDMMC_ICR_DCRCFAILC                 SDMMC_ICR_DCRCFAILC_Msk                         /*!< Data block sent/received (CRC check failed) clear bit */
#define SDMMC_ICR_CTIMEOUTC_Pos             (2U)
#define SDMMC_ICR_CTIMEOUTC_Msk             (0x1UL << SDMMC_ICR_CTIMEOUTC_Pos)              /*!< 0x00000004 */
#define SDMMC_ICR_CTIMEOUTC                 SDMMC_ICR_CTIMEOUTC_Msk                         /*!< Command response timeout clear bit */
#define SDMMC_ICR_DTIMEOUTC_Pos             (3U)
#define SDMMC_ICR_DTIMEOUTC_Msk             (0x1UL << SDMMC_ICR_DTIMEOUTC_Pos)              /*!< 0x00000008 */
#define SDMMC_ICR_DTIMEOUTC                 SDMMC_ICR_DTIMEOUTC_Msk                         /*!< Data timeout clear bit */
#define SDMMC_ICR_TXUNDERRC_Pos             (4U)
#define SDMMC_ICR_TXUNDERRC_Msk             (0x1UL << SDMMC_ICR_TXUNDERRC_Pos)              /*!< 0x00000010 */
#define SDMMC_ICR_TXUNDERRC                 SDMMC_ICR_TXUNDERRC_Msk                         /*!< Transmit FIFO underrun error clear bit */
#define SDMMC_ICR_RXOVERRC_Pos              (5U)
#define SDMMC_ICR_RXOVERRC_Msk              (0x1UL << SDMMC_ICR_RXOVERRC_Pos)               /*!< 0x00000020 */
#define SDMMC_ICR_RXOVERRC                  SDMMC_ICR_RXOVERRC_Msk                          /*!< Received FIFO overrun error clear bit */
#define SDMMC_ICR_CMDRENDC_Pos              (6U)
#define SDMMC_ICR_CMDRENDC_Msk              (0x1UL << SDMMC_ICR_CMDRENDC_Pos)               /*!< 0x00000040 */
#define SDMMC_ICR_CMDRENDC                  SDMMC_ICR_CMDRENDC_Msk                          /*!< Command response received (CRC check passed or no CRC) clear bit */
#define SDMMC_ICR_CMDSENTC_Pos              (7U)
#define SDMMC_ICR_CMDSENTC_Msk              (0x1UL << SDMMC_ICR_CMDSENTC_Pos)               /*!< 0x00000080 */
#define SDMMC_ICR_CMDSENTC                  SDMMC_ICR_CMDSENTC_Msk                          /*!< Command sent (no response required) clear bit */
#define SDMMC_ICR_DATAENDC_Pos              (8U)
#define SDMMC_ICR_DATAENDC_Msk              (0x1UL << SDMMC_ICR_DATAENDC_Pos)               /*!< 0x00000100 */
#define SDMMC_ICR_DATAENDC                  SDMMC_ICR_DATAENDC_Msk                          /*!< Data transfer ended correctly clear bit */
#define SDMMC_ICR_DHOLDC_Pos                (9U)
#define SDMMC_ICR_DHOLDC_Msk                (0x1UL << SDMMC_ICR_DHOLDC_Pos)                 /*!< 0x00000200 */
#define SDMMC_ICR_DHOLDC                    SDMMC_ICR_DHOLDC_Msk                            /*!< Data transfer hold clear bit */
#define SDMMC_ICR_DBCKENDC_Pos              (10U)
#define SDMMC_ICR_DBCKENDC_Msk              (0x1UL << SDMMC_ICR_DBCKENDC_Pos)               /*!< 0x00000400 */
#define SDMMC_ICR_DBCKENDC                  SDMMC_ICR_DBCKENDC_Msk                          /*!< Data block sent/received clear bit */
#define SDMMC_ICR_DABORTC_Pos               (11U)
#define SDMMC_ICR_DABORTC_Msk               (0x1UL << SDMMC_ICR_DABORTC_Pos)                /*!< 0x00000800 */
#define SDMMC_ICR_DABORTC                   SDMMC_ICR_DABORTC_Msk                           /*!< Data transfer aborted by CMD12 clear bit */
#define SDMMC_ICR_BUSYD0ENDC_Pos            (21U)
#define SDMMC_ICR_BUSYD0ENDC_Msk            (0x1UL << SDMMC_ICR_BUSYD0ENDC_Pos)             /*!< 0x00200000 */
#define SDMMC_ICR_BUSYD0ENDC                SDMMC_ICR_BUSYD0ENDC_Msk                        /*!< End of SDMMC_D0 busy following a CMD response detected clear bit */
#define SDMMC_ICR_SDIOITC_Pos               (22U)
#define SDMMC_ICR_SDIOITC_Msk               (0x1UL << SDMMC_ICR_SDIOITC_Pos)                /*!< 0x00400000 */
#define SDMMC_ICR_SDIOITC                   SDMMC_ICR_SDIOITC_Msk                           /*!< SDIO interrupt received clear bit */
#define SDMMC_ICR_ACKFAILC_Pos              (23U)
#define SDMMC_ICR_ACKFAILC_Msk              (0x1UL << SDMMC_ICR_ACKFAILC_Pos)               /*!< 0x00800000 */
#define SDMMC_ICR_ACKFAILC                  SDMMC_ICR_ACKFAILC_Msk                          /*!< Boot acknowledgement received (boot acknowledgement check fail) clear bit */
#define SDMMC_ICR_ACKTIMEOUTC_Pos           (24U)
#define SDMMC_ICR_ACKTIMEOUTC_Msk           (0x1UL << SDMMC_ICR_ACKTIMEOUTC_Pos)            /*!< 0x01000000 */
#define SDMMC_ICR_ACKTIMEOUTC               SDMMC_ICR_ACKTIMEOUTC_Msk                       /*!< Boot acknowledgement timeout clear bit */
#define SDMMC_ICR_VSWENDC_Pos               (25U)
#define SDMMC_ICR_VSWENDC_Msk               (0x1UL << SDMMC_ICR_VSWENDC_Pos)                /*!< 0x02000000 */
#define SDMMC_ICR_VSWENDC                   SDMMC_ICR_VSWENDC_Msk                           /*!< Voltage switch critical timing section completion clear bit */
#define SDMMC_ICR_CKSTOPC_Pos               (26U)
#define SDMMC_ICR_CKSTOPC_Msk               (0x1UL << SDMMC_ICR_CKSTOPC_Pos)                /*!< 0x04000000 */
#define SDMMC_ICR_CKSTOPC                   SDMMC_ICR_CKSTOPC_Msk                           /*!< SDMMC_CK stopped in voltage switch procedure clear bit */
#define SDMMC_ICR_IDMATEC_Pos               (27U)
#define SDMMC_ICR_IDMATEC_Msk               (0x1UL << SDMMC_ICR_IDMATEC_Pos)                /*!< 0x08000000 */
#define SDMMC_ICR_IDMATEC                   SDMMC_ICR_IDMATEC_Msk                           /*!< IDMA transfer error */
#define SDMMC_ICR_IDMABTCC_Pos              (28U)
#define SDMMC_ICR_IDMABTCC_Msk              (0x1UL << SDMMC_ICR_IDMABTCC_Pos)               /*!< 0x10000000 */
#define SDMMC_ICR_IDMABTCC                  SDMMC_ICR_IDMABTCC_Msk                          /*!< IDMA buffer transfer complete clear bit */
#define SDMMC_MASK_CCRCFAILIE_Pos           (0U)
#define SDMMC_MASK_CCRCFAILIE_Msk           (0x1UL << SDMMC_MASK_CCRCFAILIE_Pos)            /*!< 0x00000001 */
#define SDMMC_MASK_CCRCFAILIE               SDMMC_MASK_CCRCFAILIE_Msk                       /*!< Command response received (CRC check failed) interrupt enable */
#define SDMMC_MASK_DCRCFAILIE_Pos           (1U)
#define SDMMC_MASK_DCRCFAILIE_Msk           (0x1UL << SDMMC_MASK_DCRCFAILIE_Pos)            /*!< 0x00000002 */
#define SDMMC_MASK_DCRCFAILIE               SDMMC_MASK_DCRCFAILIE_Msk                       /*!< Data block sent/received (CRC check failed) interrupt enable */
#define SDMMC_MASK_CTIMEOUTIE_Pos           (2U)
#define SDMMC_MASK_CTIMEOUTIE_Msk           (0x1UL << SDMMC_MASK_CTIMEOUTIE_Pos)            /*!< 0x00000004 */
#define SDMMC_MASK_CTIMEOUTIE               SDMMC_MASK_CTIMEOUTIE_Msk                       /*!< Command response timeout interrupt enable */
#define SDMMC_MASK_DTIMEOUTIE_Pos           (3U)
#define SDMMC_MASK_DTIMEOUTIE_Msk           (0x1UL << SDMMC_MASK_DTIMEOUTIE_Pos)            /*!< 0x00000008 */
#define SDMMC_MASK_DTIMEOUTIE               SDMMC_MASK_DTIMEOUTIE_Msk                       /*!< Data timeout interrupt enable */
#define SDMMC_MASK_TXUNDERRIE_Pos           (4U)
#define SDMMC_MASK_TXUNDERRIE_Msk           (0x1UL << SDMMC_MASK_TXUNDERRIE_Pos)            /*!< 0x00000010 */
#define SDMMC_MASK_TXUNDERRIE               SDMMC_MASK_TXUNDERRIE_Msk                       /*!< Transmit FIFO underrun error interrupt enable */
#define SDMMC_MASK_RXOVERRIE_Pos            (5U)
#define SDMMC_MASK_RXOVERRIE_Msk            (0x1UL << SDMMC_MASK_RXOVERRIE_Pos)             /*!< 0x00000020 */
#define SDMMC_MASK_RXOVERRIE                SDMMC_MASK_RXOVERRIE_Msk                        /*!< Received FIFO overrun error interrupt enable */
#define SDMMC_MASK_CMDRENDIE_Pos            (6U)
#define SDMMC_MASK_CMDRENDIE_Msk            (0x1UL << SDMMC_MASK_CMDRENDIE_Pos)             /*!< 0x00000040 */
#define SDMMC_MASK_CMDRENDIE                SDMMC_MASK_CMDRENDIE_Msk                        /*!< Command response received (CRC check passed or no CRC) interrupt enable */
#define SDMMC_MASK_CMDSENTIE_Pos            (7U)
#define SDMMC_MASK_CMDSENTIE_Msk            (0x1UL << SDMMC_MASK_CMDSENTIE_Pos)             /*!< 0x00000080 */
#define SDMMC_MASK_CMDSENTIE                SDMMC_MASK_CMDSENTIE_Msk                        /*!< Command sent (no response required) interrupt enable */
#define SDMMC_MASK_DATAENDIE_Pos            (8U)
#define SDMMC_MASK_DATAENDIE_Msk            (0x1UL << SDMMC_MASK_DATAENDIE_Pos)             /*!< 0x00000100 */
#define SDMMC_MASK_DATAENDIE                SDMMC_MASK_DATAENDIE_Msk                        /*!< Data transfer ended correctly interrupt enable */
#define SDMMC_MASK_DHOLDIE_Pos              (9U)
#define SDMMC_MASK_DHOLDIE_Msk              (0x1UL << SDMMC_MASK_DHOLDIE_Pos)               /*!< 0x00000200 */
#define SDMMC_MASK_DHOLDIE                  SDMMC_MASK_DHOLDIE_Msk                          /*!< Data transfer hold interrupt enable */
#define SDMMC_MASK_DBCKENDIE_Pos            (10U)
#define SDMMC_MASK_DBCKENDIE_Msk            (0x1UL << SDMMC_MASK_DBCKENDIE_Pos)             /*!< 0x00000400 */
#define SDMMC_MASK_DBCKENDIE                SDMMC_MASK_DBCKENDIE_Msk                        /*!< Data block sent/received interrupt enable */
#define SDMMC_MASK_DABORTIE_Pos             (11U)
#define SDMMC_MASK_DABORTIE_Msk             (0x1UL << SDMMC_MASK_DABORTIE_Pos)              /*!< 0x00000800 */
#define SDMMC_MASK_DABORTIE                 SDMMC_MASK_DABORTIE_Msk                         /*!< Data transfer aborted by CMD12 interrupt enable */
#define SDMMC_MASK_TXFIFOHEIE_Pos           (14U)
#define SDMMC_MASK_TXFIFOHEIE_Msk           (0x1UL << SDMMC_MASK_TXFIFOHEIE_Pos)            /*!< 0x00004000 */
#define SDMMC_MASK_TXFIFOHEIE               SDMMC_MASK_TXFIFOHEIE_Msk                       /*!< Transmit FIFO half empty interrupt enable */
#define SDMMC_MASK_RXFIFOHFIE_Pos           (15U)
#define SDMMC_MASK_RXFIFOHFIE_Msk           (0x1UL << SDMMC_MASK_RXFIFOHFIE_Pos)            /*!< 0x00008000 */
#define SDMMC_MASK_RXFIFOHFIE               SDMMC_MASK_RXFIFOHFIE_Msk                       /*!< Receive FIFO half full interrupt enable */
#define SDMMC_MASK_RXFIFOFIE_Pos            (17U)
#define SDMMC_MASK_RXFIFOFIE_Msk            (0x1UL << SDMMC_MASK_RXFIFOFIE_Pos)             /*!< 0x00020000 */
#define SDMMC_MASK_RXFIFOFIE                SDMMC_MASK_RXFIFOFIE_Msk                        /*!< Receive FIFO full interrupt enable */
#define SDMMC_MASK_TXFIFOEIE_Pos            (18U)
#define SDMMC_MASK_TXFIFOEIE_Msk            (0x1UL << SDMMC_MASK_TXFIFOEIE_Pos)             /*!< 0x00040000 */
#define SDMMC_MASK_TXFIFOEIE                SDMMC_MASK_TXFIFOEIE_Msk                        /*!< Transmit FIFO empty interrupt enable */
#define SDMMC_MASK_BUSYD0ENDIE_Pos          (21U)
#define SDMMC_MASK_BUSYD0ENDIE_Msk          (0x1UL << SDMMC_MASK_BUSYD0ENDIE_Pos)           /*!< 0x00200000 */
#define SDMMC_MASK_BUSYD0ENDIE              SDMMC_MASK_BUSYD0ENDIE_Msk                      /*!< End of SDMMC_D0 busy following a CMD response detected interrupt enable */
#define SDMMC_MASK_SDIOITIE_Pos             (22U)
#define SDMMC_MASK_SDIOITIE_Msk             (0x1UL << SDMMC_MASK_SDIOITIE_Pos)              /*!< 0x00400000 */
#define SDMMC_MASK_SDIOITIE                 SDMMC_MASK_SDIOITIE_Msk                         /*!< SDIO interrupt received interrupt enable */
#define SDMMC_MASK_ACKFAILIE_Pos            (23U)
#define SDMMC_MASK_ACKFAILIE_Msk            (0x1UL << SDMMC_MASK_ACKFAILIE_Pos)             /*!< 0x00800000 */
#define SDMMC_MASK_ACKFAILIE                SDMMC_MASK_ACKFAILIE_Msk                        /*!< Boot acknowledgement received (boot acknowledgement check fail) interrupt enable */
#define SDMMC_MASK_ACKTIMEOUTIE_Pos         (24U)
#define SDMMC_MASK_ACKTIMEOUTIE_Msk         (0x1UL << SDMMC_MASK_ACKTIMEOUTIE_Pos)          /*!< 0x01000000 */
#define SDMMC_MASK_ACKTIMEOUTIE             SDMMC_MASK_ACKTIMEOUTIE_Msk                     /*!< Boot acknowledgement timeout interrupt enable */
#define SDMMC_MASK_VSWENDIE_Pos             (25U)
#define SDMMC_MASK_VSWENDIE_Msk             (0x1UL << SDMMC_MASK_VSWENDIE_Pos)              /*!< 0x02000000 */
#define SDMMC_MASK_VSWENDIE                 SDMMC_MASK_VSWENDIE_Msk                         /*!< Voltage switch critical timing section completion interrupt enable */
#define SDMMC_MASK_CKSTOPIE_Pos             (26U)
#define SDMMC_MASK_CKSTOPIE_Msk             (0x1UL << SDMMC_MASK_CKSTOPIE_Pos)              /*!< 0x04000000 */
#define SDMMC_MASK_CKSTOPIE                 SDMMC_MASK_CKSTOPIE_Msk                         /*!< SDMMC_CK stopped in voltage switch procedure interrupt enable */
#define SDMMC_MASK_IDMABTCIE_Pos            (28U)
#define SDMMC_MASK_IDMABTCIE_Msk            (0x1UL << SDMMC_MASK_IDMABTCIE_Pos)             /*!< 0x10000000 */
#define SDMMC_MASK_IDMABTCIE                SDMMC_MASK_IDMABTCIE_Msk                        /*!< IDMA buffer transfer complete interrupt enable */
#define SDMMC_ACKTIME_ACKTIME_Pos           (0U)
#define SDMMC_ACKTIME_ACKTIME_Msk           (0x07FFFFFFUL << SDMMC_ACKTIME_ACKTIME_Pos)     /*!< 0x07FFFFFF */
#define SDMMC_ACKTIME_ACKTIME               SDMMC_ACKTIME_ACKTIME_Msk                       /*!< Boot acknowledgement timeout period */
#define SDMMC_FIFO_FIFODATA_Pos             (0U)
#define SDMMC_FIFO_FIFODATA_Msk             (0xFFFFFFFFUL << SDMMC_FIFO_FIFODATA_Pos)       /*!< 0xFFFFFFFF */
#define SDMMC_FIFO_FIFODATA                 SDMMC_FIFO_FIFODATA_Msk                         /*!< Receive and transmit FIFO data */
#define SDMMC_IDMA_IDMAEN_Pos               (0U)
#define SDMMC_IDMA_IDMAEN_Msk               (0x1UL << SDMMC_IDMA_IDMAEN_Pos)                /*!< 0x00000001 */
#define SDMMC_IDMA_IDMAEN                   SDMMC_IDMA_IDMAEN_Msk                           /*!< IDMA enable */
#define SDMMC_IDMA_IDMABMODE_Pos            (1U)
#define SDMMC_IDMA_IDMABMODE_Msk            (0x1UL << SDMMC_IDMA_IDMABMODE_Pos)             /*!< 0x00000002 */
#define SDMMC_IDMA_IDMABMODE                SDMMC_IDMA_IDMABMODE_Msk                        /*!< Buffer mode selection*/
#define SDMMC_IDMABSIZE_IDMABNDT_Pos        (5U)
#define SDMMC_IDMABSIZE_IDMABNDT_Msk        (0xFFFUL << SDMMC_IDMABSIZE_IDMABNDT_Pos)       /*!< 0x0001FFE0 */
#define SDMMC_IDMABSIZE_IDMABNDT            SDMMC_IDMABSIZE_IDMABNDT_Msk                    /*!< Number of bytes per buffer */
#define SDMMC_IDMABASER_IDMABASER_Pos       (0U)
#define SDMMC_IDMABASER_IDMABASER_Msk       (0xFFFFFFFFUL << SDMMC_IDMABASER_IDMABASER_Pos) /*!< 0xFFFFFFFF */
#define SDMMC_IDMABASER_IDMABASER           SDMMC_IDMABASER_IDMABASER_Msk                   /*!< Buffer memory base address */
#define SDMMC_IDMALAR_IDMALA_Pos            (2U)
#define SDMMC_IDMALAR_IDMALA_Msk            (0x3FFFUL << SDMMC_IDMALAR_IDMALA_Pos)          /*!< 0x0000FFFC */
#define SDMMC_IDMALAR_IDMALA                SDMMC_IDMALAR_IDMALA_Msk                        /*!< Linked list item address offset */
#define SDMMC_IDMALAR_ABR_Pos               (29U)
#define SDMMC_IDMALAR_ABR_Msk               (0x1UL << SDMMC_IDMALAR_ABR_Pos)                /*!< 0x20000000 */
#define SDMMC_IDMALAR_ABR                   SDMMC_IDMALAR_ABR_Msk                           /*!< Acknowledge linked list buffer ready */
#define SDMMC_IDMALAR_ULS_Pos               (30U)
#define SDMMC_IDMALAR_ULS_Msk               (0x1UL << SDMMC_IDMALAR_ULS_Pos)                /*!< 0x40000000 */
#define SDMMC_IDMALAR_ULS                   SDMMC_IDMALAR_ULS_Msk                           /*!< Update Size from linked list */
#define SDMMC_IDMALAR_ULA_Pos               (31U)
#define SDMMC_IDMALAR_ULA_Msk               (0x1UL << SDMMC_IDMALAR_ULA_Pos)                /*!< 0x80000000 */
#define SDMMC_IDMALAR_ULA                   SDMMC_IDMALAR_ULA_Msk                           /*!< Update Address from linked list */
#define SDMMC_IDMABAR_IDMABAR_Pos           (2U)
#define SDMMC_IDMABAR_IDMABAR_Msk           (0x3FFFFFFFUL << SDMMC_IDMABAR_IDMABAR_Pos)     /*!< 0xFFFFFFFC */
#define SDMMC_IDMABAR_IDMABAR               SDMMC_IDMABAR_IDMABAR_Msk                       /*!< Linked list memory base address */
