// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

#define FMC_BCR1_CCLKEN_Pos        (20U)
#define FMC_BCR1_CCLKEN_Msk        (0x1UL << FMC_BCR1_CCLKEN_Pos)              /*!< 0x00100000 */
#define FMC_BCR1_CCLKEN            FMC_BCR1_CCLKEN_Msk                         /*!< Continuous clock enable */
#define FMC_BCR1_WFDIS_Pos         (21U)
#define FMC_BCR1_WFDIS_Msk         (0x1UL << FMC_BCR1_WFDIS_Pos)               /*!< 0x00200000 */
#define FMC_BCR1_WFDIS             FMC_BCR1_WFDIS_Msk                          /*!< Write FIFO Disable */
#define FMC_BCR1_BMAP_Pos          (24U)
#define FMC_BCR1_BMAP_Msk          (0x3UL << FMC_BCR1_BMAP_Pos)                /*!< 0x03000000 */
#define FMC_BCR1_BMAP              FMC_BCR1_BMAP_Msk                           /*!< FMC bank mapping */
#define FMC_BCR1_BMAP_0            (0x1UL << FMC_BCR1_BMAP_Pos)                /*!< 0x01000000 */
#define FMC_BCR1_BMAP_1            (0x2UL << FMC_BCR1_BMAP_Pos)                /*!< 0x02000000 */
#define FMC_BCR1_FMCEN_Pos         (31U)
#define FMC_BCR1_FMCEN_Msk         (0x1UL << FMC_BCR1_FMCEN_Pos)               /*!< 0x80000000 */
#define FMC_BCR1_FMCEN             FMC_BCR1_FMCEN_Msk                          /*!< FMC controller enable */
#define FMC_BCRx_MBKEN_Pos         (0U)
#define FMC_BCRx_MBKEN_Msk         (0x1UL << FMC_BCRx_MBKEN_Pos)               /*!< 0x00000001 */
#define FMC_BCRx_MBKEN             FMC_BCRx_MBKEN_Msk                          /*!< Memory bank enable bit */
#define FMC_BCRx_MUXEN_Pos         (1U)
#define FMC_BCRx_MUXEN_Msk         (0x1UL << FMC_BCRx_MUXEN_Pos)               /*!< 0x00000002 */
#define FMC_BCRx_MUXEN             FMC_BCRx_MUXEN_Msk                          /*!< Address/data multiplexing enable bit */
#define FMC_BCRx_MTYP_Pos          (2U)
#define FMC_BCRx_MTYP_Msk          (0x3UL << FMC_BCRx_MTYP_Pos)                /*!< 0x0000000C */
#define FMC_BCRx_MTYP              FMC_BCRx_MTYP_Msk                           /*!< Memory type */
#define FMC_BCRx_MTYP_0            (0x1UL << FMC_BCRx_MTYP_Pos)                /*!< 0x00000004 */
#define FMC_BCRx_MTYP_1            (0x2UL << FMC_BCRx_MTYP_Pos)                /*!< 0x00000008 */
#define FMC_BCRx_MWID_Pos          (4U)
#define FMC_BCRx_MWID_Msk          (0x3UL << FMC_BCRx_MWID_Pos)                /*!< 0x00000030 */
#define FMC_BCRx_MWID              FMC_BCRx_MWID_Msk                           /*!< Memory data bus width */
#define FMC_BCRx_MWID_0            (0x1UL << FMC_BCRx_MWID_Pos)                /*!< 0x00000010 */
#define FMC_BCRx_MWID_1            (0x2UL << FMC_BCRx_MWID_Pos)                /*!< 0x00000020 */
#define FMC_BCRx_FACCEN_Pos        (6U)
#define FMC_BCRx_FACCEN_Msk        (0x1UL << FMC_BCRx_FACCEN_Pos)              /*!< 0x00000040 */
#define FMC_BCRx_FACCEN            FMC_BCRx_FACCEN_Msk                         /*!< Flash access enable */
#define FMC_BCRx_BURSTEN_Pos       (8U)
#define FMC_BCRx_BURSTEN_Msk       (0x1UL << FMC_BCRx_BURSTEN_Pos)             /*!< 0x00000100 */
#define FMC_BCRx_BURSTEN           FMC_BCRx_BURSTEN_Msk                        /*!< Burst enable bit */
#define FMC_BCRx_WAITPOL_Pos       (9U)
#define FMC_BCRx_WAITPOL_Msk       (0x1UL << FMC_BCRx_WAITPOL_Pos)             /*!< 0x00000200 */
#define FMC_BCRx_WAITPOL           FMC_BCRx_WAITPOL_Msk                        /*!< Wait signal polarity bit */
#define FMC_BCRx_WAITCFG_Pos       (11U)
#define FMC_BCRx_WAITCFG_Msk       (0x1UL << FMC_BCRx_WAITCFG_Pos)             /*!< 0x00000800 */
#define FMC_BCRx_WAITCFG           FMC_BCRx_WAITCFG_Msk                        /*!< Wait timing configuration */
#define FMC_BCRx_WREN_Pos          (12U)
#define FMC_BCRx_WREN_Msk          (0x1UL << FMC_BCRx_WREN_Pos)                /*!< 0x00001000 */
#define FMC_BCRx_WREN              FMC_BCRx_WREN_Msk                           /*!< Write enable bit */
#define FMC_BCRx_WAITEN_Pos        (13U)
#define FMC_BCRx_WAITEN_Msk        (0x1UL << FMC_BCRx_WAITEN_Pos)              /*!< 0x00002000 */
#define FMC_BCRx_WAITEN            FMC_BCRx_WAITEN_Msk                         /*!< Wait enable bit */
#define FMC_BCRx_EXTMOD_Pos        (14U)
#define FMC_BCRx_EXTMOD_Msk        (0x1UL << FMC_BCRx_EXTMOD_Pos)              /*!< 0x00004000 */
#define FMC_BCRx_EXTMOD            FMC_BCRx_EXTMOD_Msk                         /*!< Extended mode enable */
#define FMC_BCRx_ASYNCWAIT_Pos     (15U)
#define FMC_BCRx_ASYNCWAIT_Msk     (0x1UL << FMC_BCRx_ASYNCWAIT_Pos)           /*!< 0x00008000 */
#define FMC_BCRx_ASYNCWAIT         FMC_BCRx_ASYNCWAIT_Msk                      /*!< Wait signal during asynchronous transfers */
#define FMC_BCRx_CPSIZE_Pos        (16U)
#define FMC_BCRx_CPSIZE_Msk        (0x7UL << FMC_BCRx_CPSIZE_Pos)              /*!< 0x00070000 */
#define FMC_BCRx_CPSIZE            FMC_BCRx_CPSIZE_Msk                         /*!< CRAM page size */
#define FMC_BCRx_CPSIZE_0          (0x1UL << FMC_BCRx_CPSIZE_Pos)              /*!< 0x00010000 */
#define FMC_BCRx_CPSIZE_1          (0x2UL << FMC_BCRx_CPSIZE_Pos)              /*!< 0x00020000 */
#define FMC_BCRx_CPSIZE_2          (0x4UL << FMC_BCRx_CPSIZE_Pos)              /*!< 0x00040000 */
#define FMC_BCRx_CBURSTRW_Pos      (19U)
#define FMC_BCRx_CBURSTRW_Msk      (0x1UL << FMC_BCRx_CBURSTRW_Pos)            /*!< 0x00080000 */
#define FMC_BCRx_CBURSTRW          FMC_BCRx_CBURSTRW_Msk                       /*!< Write burst enable */
#define FMC_BTRx_ADDSET_Pos        (0U)
#define FMC_BTRx_ADDSET_Msk        (0xFUL << FMC_BTRx_ADDSET_Pos)              /*!< 0x0000000F */
#define FMC_BTRx_ADDSET            FMC_BTRx_ADDSET_Msk                         /*!< Address setup phase duration */
#define FMC_BTRx_ADDSET_0          (0x1UL << FMC_BTRx_ADDSET_Pos)              /*!< 0x00000001 */
#define FMC_BTRx_ADDSET_1          (0x2UL << FMC_BTRx_ADDSET_Pos)              /*!< 0x00000002 */
#define FMC_BTRx_ADDSET_2          (0x4UL << FMC_BTRx_ADDSET_Pos)              /*!< 0x00000004 */
#define FMC_BTRx_ADDSET_3          (0x8UL << FMC_BTRx_ADDSET_Pos)              /*!< 0x00000008 */
#define FMC_BTRx_ADDHLD_Pos        (4U)
#define FMC_BTRx_ADDHLD_Msk        (0xFUL << FMC_BTRx_ADDHLD_Pos)              /*!< 0x000000F0 */
#define FMC_BTRx_ADDHLD            FMC_BTRx_ADDHLD_Msk                         /*!< Address-hold phase duration */
#define FMC_BTRx_ADDHLD_0          (0x1UL << FMC_BTRx_ADDHLD_Pos)              /*!< 0x00000010 */
#define FMC_BTRx_ADDHLD_1          (0x2UL << FMC_BTRx_ADDHLD_Pos)              /*!< 0x00000020 */
#define FMC_BTRx_ADDHLD_2          (0x4UL << FMC_BTRx_ADDHLD_Pos)              /*!< 0x00000040 */
#define FMC_BTRx_ADDHLD_3          (0x8UL << FMC_BTRx_ADDHLD_Pos)              /*!< 0x00000080 */
#define FMC_BTRx_DATAST_Pos        (8U)
#define FMC_BTRx_DATAST_Msk        (0xFFUL << FMC_BTRx_DATAST_Pos)             /*!< 0x0000FF00 */
#define FMC_BTRx_DATAST            FMC_BTRx_DATAST_Msk                         /*!< Data-phase duration */
#define FMC_BTRx_DATAST_0          (0x01UL << FMC_BTRx_DATAST_Pos)             /*!< 0x00000100 */
#define FMC_BTRx_DATAST_1          (0x02UL << FMC_BTRx_DATAST_Pos)             /*!< 0x00000200 */
#define FMC_BTRx_DATAST_2          (0x04UL << FMC_BTRx_DATAST_Pos)             /*!< 0x00000400 */
#define FMC_BTRx_DATAST_3          (0x08UL << FMC_BTRx_DATAST_Pos)             /*!< 0x00000800 */
#define FMC_BTRx_DATAST_4          (0x10UL << FMC_BTRx_DATAST_Pos)             /*!< 0x00001000 */
#define FMC_BTRx_DATAST_5          (0x20UL << FMC_BTRx_DATAST_Pos)             /*!< 0x00002000 */
#define FMC_BTRx_DATAST_6          (0x40UL << FMC_BTRx_DATAST_Pos)             /*!< 0x00004000 */
#define FMC_BTRx_DATAST_7          (0x80UL << FMC_BTRx_DATAST_Pos)             /*!< 0x00008000 */
#define FMC_BTRx_BUSTURN_Pos       (16U)
#define FMC_BTRx_BUSTURN_Msk       (0xFUL << FMC_BTRx_BUSTURN_Pos)             /*!< 0x000F0000 */
#define FMC_BTRx_BUSTURN           FMC_BTRx_BUSTURN_Msk                        /*!< Bus turnaround phase duration */
#define FMC_BTRx_BUSTURN_0         (0x1UL << FMC_BTRx_BUSTURN_Pos)             /*!< 0x00010000 */
#define FMC_BTRx_BUSTURN_1         (0x2UL << FMC_BTRx_BUSTURN_Pos)             /*!< 0x00020000 */
#define FMC_BTRx_BUSTURN_2         (0x4UL << FMC_BTRx_BUSTURN_Pos)             /*!< 0x00040000 */
#define FMC_BTRx_BUSTURN_3         (0x8UL << FMC_BTRx_BUSTURN_Pos)             /*!< 0x00080000 */
#define FMC_BTRx_CLKDIV_Pos        (20U)
#define FMC_BTRx_CLKDIV_Msk        (0xFUL << FMC_BTRx_CLKDIV_Pos)              /*!< 0x00F00000 */
#define FMC_BTRx_CLKDIV            FMC_BTRx_CLKDIV_Msk                         /*!< Clock divide ratio */
#define FMC_BTRx_CLKDIV_0          (0x1UL << FMC_BTRx_CLKDIV_Pos)              /*!< 0x00100000 */
#define FMC_BTRx_CLKDIV_1          (0x2UL << FMC_BTRx_CLKDIV_Pos)              /*!< 0x00200000 */
#define FMC_BTRx_CLKDIV_2          (0x4UL << FMC_BTRx_CLKDIV_Pos)              /*!< 0x00400000 */
#define FMC_BTRx_CLKDIV_3          (0x8UL << FMC_BTRx_CLKDIV_Pos)              /*!< 0x00800000 */
#define FMC_BTRx_DATLAT_Pos        (24U)
#define FMC_BTRx_DATLAT_Msk        (0xFUL << FMC_BTRx_DATLAT_Pos)              /*!< 0x0F000000 */
#define FMC_BTRx_DATLAT            FMC_BTRx_DATLAT_Msk                         /*!< Data latency for synchronous memory */
#define FMC_BTRx_DATLAT_0          (0x1UL << FMC_BTRx_DATLAT_Pos)              /*!< 0x01000000 */
#define FMC_BTRx_DATLAT_1          (0x2UL << FMC_BTRx_DATLAT_Pos)              /*!< 0x02000000 */
#define FMC_BTRx_DATLAT_2          (0x4UL << FMC_BTRx_DATLAT_Pos)              /*!< 0x04000000 */
#define FMC_BTRx_DATLAT_3          (0x8UL << FMC_BTRx_DATLAT_Pos)              /*!< 0x08000000 */
#define FMC_BTRx_ACCMOD_Pos        (28U)
#define FMC_BTRx_ACCMOD_Msk        (0x3UL << FMC_BTRx_ACCMOD_Pos)              /*!< 0x30000000 */
#define FMC_BTRx_ACCMOD            FMC_BTRx_ACCMOD_Msk                         /*!< Access mode */
#define FMC_BTRx_ACCMOD_0          (0x1UL << FMC_BTRx_ACCMOD_Pos)              /*!< 0x10000000 */
#define FMC_BTRx_ACCMOD_1          (0x2UL << FMC_BTRx_ACCMOD_Pos)              /*!< 0x20000000 */
#define FMC_BWTRx_ADDSET_Pos       (0U)
#define FMC_BWTRx_ADDSET_Msk       (0xFUL << FMC_BWTRx_ADDSET_Pos)             /*!< 0x0000000F */
#define FMC_BWTRx_ADDSET           FMC_BWTRx_ADDSET_Msk                        /*!< Address setup phase duration */
#define FMC_BWTRx_ADDSET_0         (0x1UL << FMC_BWTRx_ADDSET_Pos)             /*!< 0x00000001 */
#define FMC_BWTRx_ADDSET_1         (0x2UL << FMC_BWTRx_ADDSET_Pos)             /*!< 0x00000002 */
#define FMC_BWTRx_ADDSET_2         (0x4UL << FMC_BWTRx_ADDSET_Pos)             /*!< 0x00000004 */
#define FMC_BWTRx_ADDSET_3         (0x8UL << FMC_BWTRx_ADDSET_Pos)             /*!< 0x00000008 */
#define FMC_BWTRx_ADDHLD_Pos       (4U)
#define FMC_BWTRx_ADDHLD_Msk       (0xFUL << FMC_BWTRx_ADDHLD_Pos)             /*!< 0x000000F0 */
#define FMC_BWTRx_ADDHLD           FMC_BWTRx_ADDHLD_Msk                        /*!< Address-hold phase duration */
#define FMC_BWTRx_ADDHLD_0         (0x1UL << FMC_BWTRx_ADDHLD_Pos)             /*!< 0x00000010 */
#define FMC_BWTRx_ADDHLD_1         (0x2UL << FMC_BWTRx_ADDHLD_Pos)             /*!< 0x00000020 */
#define FMC_BWTRx_ADDHLD_2         (0x4UL << FMC_BWTRx_ADDHLD_Pos)             /*!< 0x00000040 */
#define FMC_BWTRx_ADDHLD_3         (0x8UL << FMC_BWTRx_ADDHLD_Pos)             /*!< 0x00000080 */
#define FMC_BWTRx_DATAST_Pos       (8U)
#define FMC_BWTRx_DATAST_Msk       (0xFFUL << FMC_BWTRx_DATAST_Pos)            /*!< 0x0000FF00 */
#define FMC_BWTRx_DATAST           FMC_BWTRx_DATAST_Msk                        /*!< Data-phase duration */
#define FMC_BWTRx_DATAST_0         (0x01UL << FMC_BWTRx_DATAST_Pos)            /*!< 0x00000100 */
#define FMC_BWTRx_DATAST_1         (0x02UL << FMC_BWTRx_DATAST_Pos)            /*!< 0x00000200 */
#define FMC_BWTRx_DATAST_2         (0x04UL << FMC_BWTRx_DATAST_Pos)            /*!< 0x00000400 */
#define FMC_BWTRx_DATAST_3         (0x08UL << FMC_BWTRx_DATAST_Pos)            /*!< 0x00000800 */
#define FMC_BWTRx_DATAST_4         (0x10UL << FMC_BWTRx_DATAST_Pos)            /*!< 0x00001000 */
#define FMC_BWTRx_DATAST_5         (0x20UL << FMC_BWTRx_DATAST_Pos)            /*!< 0x00002000 */
#define FMC_BWTRx_DATAST_6         (0x40UL << FMC_BWTRx_DATAST_Pos)            /*!< 0x00004000 */
#define FMC_BWTRx_DATAST_7         (0x80UL << FMC_BWTRx_DATAST_Pos)            /*!< 0x00008000 */
#define FMC_BWTRx_BUSTURN_Pos      (16U)
#define FMC_BWTRx_BUSTURN_Msk      (0xFUL << FMC_BWTRx_BUSTURN_Pos)            /*!< 0x000F0000 */
#define FMC_BWTRx_BUSTURN          FMC_BWTRx_BUSTURN_Msk                       /*!< Bus turnaround phase duration */
#define FMC_BWTRx_BUSTURN_0        (0x1UL << FMC_BWTRx_BUSTURN_Pos)            /*!< 0x00010000 */
#define FMC_BWTRx_BUSTURN_1        (0x2UL << FMC_BWTRx_BUSTURN_Pos)            /*!< 0x00020000 */
#define FMC_BWTRx_BUSTURN_2        (0x4UL << FMC_BWTRx_BUSTURN_Pos)            /*!< 0x00040000 */
#define FMC_BWTRx_BUSTURN_3        (0x8UL << FMC_BWTRx_BUSTURN_Pos)            /*!< 0x00080000 */
#define FMC_BWTRx_ACCMOD_Pos       (28U)
#define FMC_BWTRx_ACCMOD_Msk       (0x3UL << FMC_BWTRx_ACCMOD_Pos)             /*!< 0x30000000 */
#define FMC_BWTRx_ACCMOD           FMC_BWTRx_ACCMOD_Msk                        /*!< Access mode */
#define FMC_BWTRx_ACCMOD_0         (0x1UL << FMC_BWTRx_ACCMOD_Pos)             /*!< 0x10000000 */
#define FMC_BWTRx_ACCMOD_1         (0x2UL << FMC_BWTRx_ACCMOD_Pos)             /*!< 0x20000000 */
#define FMC_PCR_PWAITEN_Pos        (1U)
#define FMC_PCR_PWAITEN_Msk        (0x1UL << FMC_PCR_PWAITEN_Pos)              /*!< 0x00000002 */
#define FMC_PCR_PWAITEN            FMC_PCR_PWAITEN_Msk                         /*!< Wait feature enable bit */
#define FMC_PCR_PBKEN_Pos          (2U)
#define FMC_PCR_PBKEN_Msk          (0x1UL << FMC_PCR_PBKEN_Pos)                /*!< 0x00000004 */
#define FMC_PCR_PBKEN              FMC_PCR_PBKEN_Msk                           /*!< NAND Flash memory bank enable bit */
#define FMC_PCR_PWID_Pos           (4U)
#define FMC_PCR_PWID_Msk           (0x3UL << FMC_PCR_PWID_Pos)                 /*!< 0x00000030 */
#define FMC_PCR_PWID               FMC_PCR_PWID_Msk                            /*!< Data bus width */
#define FMC_PCR_PWID_0             (0x1UL << FMC_PCR_PWID_Pos)                 /*!< 0x00000010 */
#define FMC_PCR_PWID_1             (0x2UL << FMC_PCR_PWID_Pos)                 /*!< 0x00000020 */
#define FMC_PCR_ECCEN_Pos          (6U)
#define FMC_PCR_ECCEN_Msk          (0x1UL << FMC_PCR_ECCEN_Pos)                /*!< 0x00000040 */
#define FMC_PCR_ECCEN              FMC_PCR_ECCEN_Msk                           /*!< ECC computation logic enable bit */
#define FMC_PCR_TCLR_Pos           (9U)
#define FMC_PCR_TCLR_Msk           (0xFUL << FMC_PCR_TCLR_Pos)                 /*!< 0x00001E00 */
#define FMC_PCR_TCLR               FMC_PCR_TCLR_Msk                            /*!< CLE to RE delay */
#define FMC_PCR_TCLR_0             (0x1UL << FMC_PCR_TCLR_Pos)                 /*!< 0x00000200 */
#define FMC_PCR_TCLR_1             (0x2UL << FMC_PCR_TCLR_Pos)                 /*!< 0x00000400 */
#define FMC_PCR_TCLR_2             (0x4UL << FMC_PCR_TCLR_Pos)                 /*!< 0x00000800 */
#define FMC_PCR_TCLR_3             (0x8UL << FMC_PCR_TCLR_Pos)                 /*!< 0x00001000 */
#define FMC_PCR_TAR_Pos            (13U)
#define FMC_PCR_TAR_Msk            (0xFUL << FMC_PCR_TAR_Pos)                  /*!< 0x0001E000 */
#define FMC_PCR_TAR                FMC_PCR_TAR_Msk                             /*!< ALE to RE delay */
#define FMC_PCR_TAR_0              (0x1UL << FMC_PCR_TAR_Pos)                  /*!< 0x00002000 */
#define FMC_PCR_TAR_1              (0x2UL << FMC_PCR_TAR_Pos)                  /*!< 0x00004000 */
#define FMC_PCR_TAR_2              (0x4UL << FMC_PCR_TAR_Pos)                  /*!< 0x00008000 */
#define FMC_PCR_TAR_3              (0x8UL << FMC_PCR_TAR_Pos)                  /*!< 0x00010000 */
#define FMC_PCR_ECCPS_Pos          (17U)
#define FMC_PCR_ECCPS_Msk          (0x7UL << FMC_PCR_ECCPS_Pos)                /*!< 0x000E0000 */
#define FMC_PCR_ECCPS              FMC_PCR_ECCPS_Msk                           /*!< ECC page size */
#define FMC_PCR_ECCPS_0            (0x1UL << FMC_PCR_ECCPS_Pos)                /*!< 0x00020000 */
#define FMC_PCR_ECCPS_1            (0x2UL << FMC_PCR_ECCPS_Pos)                /*!< 0x00040000 */
#define FMC_PCR_ECCPS_2            (0x4UL << FMC_PCR_ECCPS_Pos)                /*!< 0x00080000 */
#define FMC_SR_IRS_Pos             (0U)
#define FMC_SR_IRS_Msk             (0x1UL << FMC_SR_IRS_Pos)                   /*!< 0x00000001 */
#define FMC_SR_IRS                 FMC_SR_IRS_Msk                              /*!< Interrupt rising edge status */
#define FMC_SR_ILS_Pos             (1U)
#define FMC_SR_ILS_Msk             (0x1UL << FMC_SR_ILS_Pos)                   /*!< 0x00000002 */
#define FMC_SR_ILS                 FMC_SR_ILS_Msk                              /*!< Interrupt high-level status */
#define FMC_SR_IFS_Pos             (2U)
#define FMC_SR_IFS_Msk             (0x1UL << FMC_SR_IFS_Pos)                   /*!< 0x00000004 */
#define FMC_SR_IFS                 FMC_SR_IFS_Msk                              /*!< Interrupt falling edge status */
#define FMC_SR_IREN_Pos            (3U)
#define FMC_SR_IREN_Msk            (0x1UL << FMC_SR_IREN_Pos)                  /*!< 0x00000008 */
#define FMC_SR_IREN                FMC_SR_IREN_Msk                             /*!< Interrupt rising edge detection enable bit */
#define FMC_SR_ILEN_Pos            (4U)
#define FMC_SR_ILEN_Msk            (0x1UL << FMC_SR_ILEN_Pos)                  /*!< 0x00000010 */
#define FMC_SR_ILEN                FMC_SR_ILEN_Msk                             /*!< Interrupt high-level detection enable bit */
#define FMC_SR_IFEN_Pos            (5U)
#define FMC_SR_IFEN_Msk            (0x1UL << FMC_SR_IFEN_Pos)                  /*!< 0x00000020 */
#define FMC_SR_IFEN                FMC_SR_IFEN_Msk                             /*!< Interrupt falling edge detection enable bit */
#define FMC_SR_FEMPT_Pos           (6U)
#define FMC_SR_FEMPT_Msk           (0x1UL << FMC_SR_FEMPT_Pos)                 /*!< 0x00000040 */
#define FMC_SR_FEMPT               FMC_SR_FEMPT_Msk                            /*!< FIFO empty */
#define FMC_PMEM_MEMSET_Pos        (0U)
#define FMC_PMEM_MEMSET_Msk        (0xFFUL << FMC_PMEM_MEMSET_Pos)             /*!< 0x000000FF */
#define FMC_PMEM_MEMSET            FMC_PMEM_MEMSET_Msk                         /*!< Common memory setup time */
#define FMC_PMEM_MEMSET_0          (0x01UL << FMC_PMEM_MEMSET_Pos)             /*!< 0x00000001 */
#define FMC_PMEM_MEMSET_1          (0x02UL << FMC_PMEM_MEMSET_Pos)             /*!< 0x00000002 */
#define FMC_PMEM_MEMSET_2          (0x04UL << FMC_PMEM_MEMSET_Pos)             /*!< 0x00000004 */
#define FMC_PMEM_MEMSET_3          (0x08UL << FMC_PMEM_MEMSET_Pos)             /*!< 0x00000008 */
#define FMC_PMEM_MEMSET_4          (0x10UL << FMC_PMEM_MEMSET_Pos)             /*!< 0x00000010 */
#define FMC_PMEM_MEMSET_5          (0x20UL << FMC_PMEM_MEMSET_Pos)             /*!< 0x00000020 */
#define FMC_PMEM_MEMSET_6          (0x40UL << FMC_PMEM_MEMSET_Pos)             /*!< 0x00000040 */
#define FMC_PMEM_MEMSET_7          (0x80UL << FMC_PMEM_MEMSET_Pos)             /*!< 0x00000080 */
#define FMC_PMEM_MEMWAIT_Pos       (8U)
#define FMC_PMEM_MEMWAIT_Msk       (0xFFUL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x0000FF00 */
#define FMC_PMEM_MEMWAIT           FMC_PMEM_MEMWAIT_Msk                        /*!< Common memory wait time */
#define FMC_PMEM_MEMWAIT_0         (0x01UL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x00000100 */
#define FMC_PMEM_MEMWAIT_1         (0x02UL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x00000200 */
#define FMC_PMEM_MEMWAIT_2         (0x04UL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x00000400 */
#define FMC_PMEM_MEMWAIT_3         (0x08UL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x00000800 */
#define FMC_PMEM_MEMWAIT_4         (0x10UL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x00001000 */
#define FMC_PMEM_MEMWAIT_5         (0x20UL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x00002000 */
#define FMC_PMEM_MEMWAIT_6         (0x40UL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x00004000 */
#define FMC_PMEM_MEMWAIT_7         (0x80UL << FMC_PMEM_MEMWAIT_Pos)            /*!< 0x00008000 */
#define FMC_PMEM_MEMHOLD_Pos       (16U)
#define FMC_PMEM_MEMHOLD_Msk       (0xFFUL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00FF0000 */
#define FMC_PMEM_MEMHOLD           FMC_PMEM_MEMHOLD_Msk                        /*!< Common memory hold time */
#define FMC_PMEM_MEMHOLD_0         (0x01UL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00010000 */
#define FMC_PMEM_MEMHOLD_1         (0x02UL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00020000 */
#define FMC_PMEM_MEMHOLD_2         (0x04UL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00040000 */
#define FMC_PMEM_MEMHOLD_3         (0x08UL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00080000 */
#define FMC_PMEM_MEMHOLD_4         (0x10UL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00100000 */
#define FMC_PMEM_MEMHOLD_5         (0x20UL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00200000 */
#define FMC_PMEM_MEMHOLD_6         (0x40UL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00400000 */
#define FMC_PMEM_MEMHOLD_7         (0x80UL << FMC_PMEM_MEMHOLD_Pos)            /*!< 0x00800000 */
#define FMC_PMEM_MEMHIZ_Pos        (24U)
#define FMC_PMEM_MEMHIZ_Msk        (0xFFUL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0xFF000000 */
#define FMC_PMEM_MEMHIZ            FMC_PMEM_MEMHIZ_Msk                         /*!< Common memory databus Hi-Z time */
#define FMC_PMEM_MEMHIZ_0          (0x01UL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0x01000000 */
#define FMC_PMEM_MEMHIZ_1          (0x02UL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0x02000000 */
#define FMC_PMEM_MEMHIZ_2          (0x04UL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0x04000000 */
#define FMC_PMEM_MEMHIZ_3          (0x08UL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0x08000000 */
#define FMC_PMEM_MEMHIZ_4          (0x10UL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0x10000000 */
#define FMC_PMEM_MEMHIZ_5          (0x20UL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0x20000000 */
#define FMC_PMEM_MEMHIZ_6          (0x40UL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0x40000000 */
#define FMC_PMEM_MEMHIZ_7          (0x80UL << FMC_PMEM_MEMHIZ_Pos)             /*!< 0x80000000 */
#define FMC_PATT_ATTSET_Pos        (0U)
#define FMC_PATT_ATTSET_Msk        (0xFFUL << FMC_PATT_ATTSET_Pos)             /*!< 0x000000FF */
#define FMC_PATT_ATTSET            FMC_PATT_ATTSET_Msk                         /*!< Attribute memory setup time */
#define FMC_PATT_ATTSET_0          (0x01UL << FMC_PATT_ATTSET_Pos)             /*!< 0x00000001 */
#define FMC_PATT_ATTSET_1          (0x02UL << FMC_PATT_ATTSET_Pos)             /*!< 0x00000002 */
#define FMC_PATT_ATTSET_2          (0x04UL << FMC_PATT_ATTSET_Pos)             /*!< 0x00000004 */
#define FMC_PATT_ATTSET_3          (0x08UL << FMC_PATT_ATTSET_Pos)             /*!< 0x00000008 */
#define FMC_PATT_ATTSET_4          (0x10UL << FMC_PATT_ATTSET_Pos)             /*!< 0x00000010 */
#define FMC_PATT_ATTSET_5          (0x20UL << FMC_PATT_ATTSET_Pos)             /*!< 0x00000020 */
#define FMC_PATT_ATTSET_6          (0x40UL << FMC_PATT_ATTSET_Pos)             /*!< 0x00000040 */
#define FMC_PATT_ATTSET_7          (0x80UL << FMC_PATT_ATTSET_Pos)             /*!< 0x00000080 */
#define FMC_PATT_ATTWAIT_Pos       (8U)
#define FMC_PATT_ATTWAIT_Msk       (0xFFUL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x0000FF00 */
#define FMC_PATT_ATTWAIT           FMC_PATT_ATTWAIT_Msk                        /*!< Attribute memory wait time */
#define FMC_PATT_ATTWAIT_0         (0x01UL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x00000100 */
#define FMC_PATT_ATTWAIT_1         (0x02UL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x00000200 */
#define FMC_PATT_ATTWAIT_2         (0x04UL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x00000400 */
#define FMC_PATT_ATTWAIT_3         (0x08UL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x00000800 */
#define FMC_PATT_ATTWAIT_4         (0x10UL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x00001000 */
#define FMC_PATT_ATTWAIT_5         (0x20UL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x00002000 */
#define FMC_PATT_ATTWAIT_6         (0x40UL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x00004000 */
#define FMC_PATT_ATTWAIT_7         (0x80UL << FMC_PATT_ATTWAIT_Pos)            /*!< 0x00008000 */
#define FMC_PATT_ATTHOLD_Pos       (16U)
#define FMC_PATT_ATTHOLD_Msk       (0xFFUL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00FF0000 */
#define FMC_PATT_ATTHOLD           FMC_PATT_ATTHOLD_Msk                        /*!< Attribute memory hold time */
#define FMC_PATT_ATTHOLD_0         (0x01UL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00010000 */
#define FMC_PATT_ATTHOLD_1         (0x02UL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00020000 */
#define FMC_PATT_ATTHOLD_2         (0x04UL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00040000 */
#define FMC_PATT_ATTHOLD_3         (0x08UL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00080000 */
#define FMC_PATT_ATTHOLD_4         (0x10UL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00100000 */
#define FMC_PATT_ATTHOLD_5         (0x20UL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00200000 */
#define FMC_PATT_ATTHOLD_6         (0x40UL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00400000 */
#define FMC_PATT_ATTHOLD_7         (0x80UL << FMC_PATT_ATTHOLD_Pos)            /*!< 0x00800000 */
#define FMC_PATT_ATTHIZ_Pos        (24U)
#define FMC_PATT_ATTHIZ_Msk        (0xFFUL << FMC_PATT_ATTHIZ_Pos)             /*!< 0xFF000000 */
#define FMC_PATT_ATTHIZ            FMC_PATT_ATTHIZ_Msk                         /*!< Attribute memory data bus Hi-Z time */
#define FMC_PATT_ATTHIZ_0          (0x01UL << FMC_PATT_ATTHIZ_Pos)             /*!< 0x01000000 */
#define FMC_PATT_ATTHIZ_1          (0x02UL << FMC_PATT_ATTHIZ_Pos)             /*!< 0x02000000 */
#define FMC_PATT_ATTHIZ_2          (0x04UL << FMC_PATT_ATTHIZ_Pos)             /*!< 0x04000000 */
#define FMC_PATT_ATTHIZ_3          (0x08UL << FMC_PATT_ATTHIZ_Pos)             /*!< 0x08000000 */
#define FMC_PATT_ATTHIZ_4          (0x10UL << FMC_PATT_ATTHIZ_Pos)             /*!< 0x10000000 */
#define FMC_PATT_ATTHIZ_5          (0x20UL << FMC_PATT_ATTHIZ_Pos)             /*!< 0x20000000 */
#define FMC_PATT_ATTHIZ_6          (0x40UL << FMC_PATT_ATTHIZ_Pos)             /*!< 0x40000000 */
#define FMC_PATT_ATTHIZ_7          (0x80UL << FMC_PATT_ATTHIZ_Pos)             /*!< 0x80000000 */
#define FMC_ECCR_ECC_Pos           (0U)
#define FMC_ECCR_ECC_Msk           (0xFFFFFFFFUL << FMC_ECCR_ECC_Pos)          /*!< 0xFFFFFFFF */
#define FMC_ECCR_ECC               FMC_ECCR_ECC_Msk                            /*!< ECC result */
#define FMC_SDCRx_NC_Pos           (0U)
#define FMC_SDCRx_NC_Msk           (0x3UL << FMC_SDCRx_NC_Pos)                 /*!< 0x00000003 */
#define FMC_SDCRx_NC               FMC_SDCRx_NC_Msk                            /*!< Number of column address bits */
#define FMC_SDCRx_NC_0             (0x1UL << FMC_SDCRx_NC_Pos)                 /*!< 0x00000001 */
#define FMC_SDCRx_NC_1             (0x2UL << FMC_SDCRx_NC_Pos)                 /*!< 0x00000002 */
#define FMC_SDCRx_NR_Pos           (2U)
#define FMC_SDCRx_NR_Msk           (0x3UL << FMC_SDCRx_NR_Pos)                 /*!< 0x0000000C */
#define FMC_SDCRx_NR               FMC_SDCRx_NR_Msk                            /*!< Number of row address bits */
#define FMC_SDCRx_NR_0             (0x1UL << FMC_SDCRx_NR_Pos)                 /*!< 0x00000004 */
#define FMC_SDCRx_NR_1             (0x2UL << FMC_SDCRx_NR_Pos)                 /*!< 0x00000008 */
#define FMC_SDCRx_MWID_Pos         (4U)
#define FMC_SDCRx_MWID_Msk         (0x3UL << FMC_SDCRx_MWID_Pos)               /*!< 0x00000030 */
#define FMC_SDCRx_MWID             FMC_SDCRx_MWID_Msk                          /*!< Memory data bus width */
#define FMC_SDCRx_MWID_0           (0x1UL << FMC_SDCRx_MWID_Pos)               /*!< 0x00000010 */
#define FMC_SDCRx_MWID_1           (0x2UL << FMC_SDCRx_MWID_Pos)               /*!< 0x00000020 */
#define FMC_SDCRx_NB_Pos           (6U)
#define FMC_SDCRx_NB_Msk           (0x1UL << FMC_SDCRx_NB_Pos)                 /*!< 0x00000040 */
#define FMC_SDCRx_NB               FMC_SDCRx_NB_Msk                            /*!< Number of internal banks */
#define FMC_SDCRx_CAS_Pos          (7U)
#define FMC_SDCRx_CAS_Msk          (0x3UL << FMC_SDCRx_CAS_Pos)                /*!< 0x00000180 */
#define FMC_SDCRx_CAS              FMC_SDCRx_CAS_Msk                           /*!< CAS latency */
#define FMC_SDCRx_CAS_0            (0x1UL << FMC_SDCRx_CAS_Pos)                /*!< 0x00000080 */
#define FMC_SDCRx_CAS_1            (0x2UL << FMC_SDCRx_CAS_Pos)                /*!< 0x00000100 */
#define FMC_SDCRx_WP_Pos           (9U)
#define FMC_SDCRx_WP_Msk           (0x1UL << FMC_SDCRx_WP_Pos)                 /*!< 0x00000200 */
#define FMC_SDCRx_WP               FMC_SDCRx_WP_Msk                            /*!< Write protection */
#define FMC_SDCRx_SDCLK_Pos        (10U)
#define FMC_SDCRx_SDCLK_Msk        (0x3UL << FMC_SDCRx_SDCLK_Pos)              /*!< 0x00000C00 */
#define FMC_SDCRx_SDCLK            FMC_SDCRx_SDCLK_Msk                         /*!< SDRAM clock configuration */
#define FMC_SDCRx_SDCLK_0          (0x1UL << FMC_SDCRx_SDCLK_Pos)              /*!< 0x00000400 */
#define FMC_SDCRx_SDCLK_1          (0x2UL << FMC_SDCRx_SDCLK_Pos)              /*!< 0x00000800 */
#define FMC_SDCRx_RBURST_Pos       (12U)
#define FMC_SDCRx_RBURST_Msk       (0x1UL << FMC_SDCRx_RBURST_Pos)             /*!< 0x00001000 */
#define FMC_SDCRx_RBURST           FMC_SDCRx_RBURST_Msk                        /*!< Read burst */
#define FMC_SDCRx_RPIPE_Pos        (13U)
#define FMC_SDCRx_RPIPE_Msk        (0x3UL << FMC_SDCRx_RPIPE_Pos)              /*!< 0x00006000 */
#define FMC_SDCRx_RPIPE            FMC_SDCRx_RPIPE_Msk                         /*!< Read pipe */
#define FMC_SDCRx_RPIPE_0          (0x1UL << FMC_SDCRx_RPIPE_Pos)              /*!< 0x00002000 */
#define FMC_SDCRx_RPIPE_1          (0x2UL << FMC_SDCRx_RPIPE_Pos)              /*!< 0x00004000 */
#define FMC_SDTRx_TMRD_Pos         (0U)
#define FMC_SDTRx_TMRD_Msk         (0xFUL << FMC_SDTRx_TMRD_Pos)               /*!< 0x0000000F */
#define FMC_SDTRx_TMRD             FMC_SDTRx_TMRD_Msk                          /*!< Load mode register to active */
#define FMC_SDTRx_TMRD_0           (0x1UL << FMC_SDTRx_TMRD_Pos)               /*!< 0x00000001 */
#define FMC_SDTRx_TMRD_1           (0x2UL << FMC_SDTRx_TMRD_Pos)               /*!< 0x00000002 */
#define FMC_SDTRx_TMRD_2           (0x4UL << FMC_SDTRx_TMRD_Pos)               /*!< 0x00000004 */
#define FMC_SDTRx_TMRD_3           (0x8UL << FMC_SDTRx_TMRD_Pos)               /*!< 0x00000008 */
#define FMC_SDTRx_TXSR_Pos         (4U)
#define FMC_SDTRx_TXSR_Msk         (0xFUL << FMC_SDTRx_TXSR_Pos)               /*!< 0x000000F0 */
#define FMC_SDTRx_TXSR             FMC_SDTRx_TXSR_Msk                          /*!<Exit self-refresh delay */
#define FMC_SDTRx_TXSR_0           (0x1UL << FMC_SDTRx_TXSR_Pos)               /*!< 0x00000010 */
#define FMC_SDTRx_TXSR_1           (0x2UL << FMC_SDTRx_TXSR_Pos)               /*!< 0x00000020 */
#define FMC_SDTRx_TXSR_2           (0x4UL << FMC_SDTRx_TXSR_Pos)               /*!< 0x00000040 */
#define FMC_SDTRx_TXSR_3           (0x8UL << FMC_SDTRx_TXSR_Pos)               /*!< 0x00000080 */
#define FMC_SDTRx_TRAS_Pos         (8U)
#define FMC_SDTRx_TRAS_Msk         (0xFUL << FMC_SDTRx_TRAS_Pos)               /*!< 0x00000F00 */
#define FMC_SDTRx_TRAS             FMC_SDTRx_TRAS_Msk                          /*!< Self refresh time */
#define FMC_SDTRx_TRAS_0           (0x1UL << FMC_SDTRx_TRAS_Pos)               /*!< 0x00000100 */
#define FMC_SDTRx_TRAS_1           (0x2UL << FMC_SDTRx_TRAS_Pos)               /*!< 0x00000200 */
#define FMC_SDTRx_TRAS_2           (0x4UL << FMC_SDTRx_TRAS_Pos)               /*!< 0x00000400 */
#define FMC_SDTRx_TRAS_3           (0x8UL << FMC_SDTRx_TRAS_Pos)               /*!< 0x00000800 */
#define FMC_SDTRx_TRC_Pos          (12U)
#define FMC_SDTRx_TRC_Msk          (0xFUL << FMC_SDTRx_TRC_Pos)                /*!< 0x0000F000 */
#define FMC_SDTRx_TRC              FMC_SDTRx_TRC_Msk                           /*!< Row cycle delay */
#define FMC_SDTRx_TRC_0            (0x1UL << FMC_SDTRx_TRC_Pos)                /*!< 0x00001000 */
#define FMC_SDTRx_TRC_1            (0x2UL << FMC_SDTRx_TRC_Pos)                /*!< 0x00002000 */
#define FMC_SDTRx_TRC_2            (0x4UL << FMC_SDTRx_TRC_Pos)                /*!< 0x00004000 */
#define FMC_SDTRx_TRC_3            (0x8UL << FMC_SDTRx_TRC_Pos)                /*!< 0x00008000 */
#define FMC_SDTRx_TWR_Pos          (16U)
#define FMC_SDTRx_TWR_Msk          (0xFUL << FMC_SDTRx_TWR_Pos)                /*!< 0x000F0000 */
#define FMC_SDTRx_TWR              FMC_SDTRx_TWR_Msk                           /*!< Recovery delay */
#define FMC_SDTRx_TWR_0            (0x1UL << FMC_SDTRx_TWR_Pos)                /*!< 0x00010000 */
#define FMC_SDTRx_TWR_1            (0x2UL << FMC_SDTRx_TWR_Pos)                /*!< 0x00020000 */
#define FMC_SDTRx_TWR_2            (0x4UL << FMC_SDTRx_TWR_Pos)                /*!< 0x00040000 */
#define FMC_SDTRx_TWR_3            (0x8UL << FMC_SDTRx_TWR_Pos)                /*!< 0x00080000 */
#define FMC_SDTRx_TRP_Pos          (20U)
#define FMC_SDTRx_TRP_Msk          (0xFUL << FMC_SDTRx_TRP_Pos)                /*!< 0x00F00000 */
#define FMC_SDTRx_TRP              FMC_SDTRx_TRP_Msk                           /*!< Row precharge delay */
#define FMC_SDTRx_TRP_0            (0x1UL << FMC_SDTRx_TRP_Pos)                /*!< 0x00100000 */
#define FMC_SDTRx_TRP_1            (0x2UL << FMC_SDTRx_TRP_Pos)                /*!< 0x00200000 */
#define FMC_SDTRx_TRP_2            (0x4UL << FMC_SDTRx_TRP_Pos)                /*!< 0x00400000 */
#define FMC_SDTRx_TRP_3            (0x8UL << FMC_SDTRx_TRP_Pos)                /*!< 0x00800000 */
#define FMC_SDTRx_TRCD_Pos         (24U)
#define FMC_SDTRx_TRCD_Msk         (0xFUL << FMC_SDTRx_TRCD_Pos)               /*!< 0x0F000000 */
#define FMC_SDTRx_TRCD             FMC_SDTRx_TRCD_Msk                          /*!< Row to column delay */
#define FMC_SDTRx_TRCD_0           (0x1UL << FMC_SDTRx_TRCD_Pos)               /*!< 0x01000000 */
#define FMC_SDTRx_TRCD_1           (0x2UL << FMC_SDTRx_TRCD_Pos)               /*!< 0x02000000 */
#define FMC_SDTRx_TRCD_2           (0x4UL << FMC_SDTRx_TRCD_Pos)               /*!< 0x04000000 */
#define FMC_SDTRx_TRCD_3           (0x8UL << FMC_SDTRx_TRCD_Pos)               /*!< 0x08000000 */
#define FMC_SDCMR_MODE_Pos         (0U)
#define FMC_SDCMR_MODE_Msk         (0x7UL << FMC_SDCMR_MODE_Pos)               /*!< 0x00000007 */
#define FMC_SDCMR_MODE             FMC_SDCMR_MODE_Msk                          /*!< Command mode */
#define FMC_SDCMR_MODE_0           (0x1UL << FMC_SDCMR_MODE_Pos)               /*!< 0x00000001 */
#define FMC_SDCMR_MODE_1           (0x2UL << FMC_SDCMR_MODE_Pos)               /*!< 0x00000002 */
#define FMC_SDCMR_MODE_2           (0x4UL << FMC_SDCMR_MODE_Pos)               /*!< 0x00000004 */
#define FMC_SDCMR_CTB2_Pos         (3U)
#define FMC_SDCMR_CTB2_Msk         (0x1UL << FMC_SDCMR_CTB2_Pos)               /*!< 0x00000008 */
#define FMC_SDCMR_CTB2             FMC_SDCMR_CTB2_Msk                          /*!< Command target bank 2 */
#define FMC_SDCMR_CTB1_Pos         (4U)
#define FMC_SDCMR_CTB1_Msk         (0x1UL << FMC_SDCMR_CTB1_Pos)               /*!< 0x00000010 */
#define FMC_SDCMR_CTB1             FMC_SDCMR_CTB1_Msk                          /*!< Command target bank 1 */
#define FMC_SDCMR_NRFS_Pos         (5U)
#define FMC_SDCMR_NRFS_Msk         (0xFUL << FMC_SDCMR_NRFS_Pos)               /*!< 0x000001E0 */
#define FMC_SDCMR_NRFS             FMC_SDCMR_NRFS_Msk                          /*!< Number of auto-refresh */
#define FMC_SDCMR_NRFS_0           (0x1UL << FMC_SDCMR_NRFS_Pos)               /*!< 0x00000020 */
#define FMC_SDCMR_NRFS_1           (0x2UL << FMC_SDCMR_NRFS_Pos)               /*!< 0x00000040 */
#define FMC_SDCMR_NRFS_2           (0x4UL << FMC_SDCMR_NRFS_Pos)               /*!< 0x00000080 */
#define FMC_SDCMR_NRFS_3           (0x8UL << FMC_SDCMR_NRFS_Pos)               /*!< 0x00000100 */
#define FMC_SDCMR_MRD_Pos          (9U)
#define FMC_SDCMR_MRD_Msk          (0x3FFFUL << FMC_SDCMR_MRD_Pos)             /*!< 0x007FFE00 */
#define FMC_SDCMR_MRD              FMC_SDCMR_MRD_Msk                           /*!< Mode register definition */
#define FMC_SDRTR_CRE_Pos          (0U)
#define FMC_SDRTR_CRE_Msk          (0x1UL << FMC_SDRTR_CRE_Pos)                /*!< 0x00000001 */
#define FMC_SDRTR_CRE              FMC_SDRTR_CRE_Msk                           /*!< Clear refresh error flag */
#define FMC_SDRTR_COUNT_Pos        (1U)
#define FMC_SDRTR_COUNT_Msk        (0x1FFFUL << FMC_SDRTR_COUNT_Pos)           /*!< 0x00003FFE */
#define FMC_SDRTR_COUNT            FMC_SDRTR_COUNT_Msk                         /*!< Refresh timer count */
#define FMC_SDRTR_REIE_Pos         (14U)
#define FMC_SDRTR_REIE_Msk         (0x1UL << FMC_SDRTR_REIE_Pos)               /*!< 0x00004000 */
#define FMC_SDRTR_REIE             FMC_SDRTR_REIE_Msk                          /*!< RES interrupt enable */
#define FMC_SDSR_RE_Pos            (0U)
#define FMC_SDSR_RE_Msk            (0x1UL << FMC_SDSR_RE_Pos)                  /*!< 0x00000001 */
#define FMC_SDSR_RE                FMC_SDSR_RE_Msk                             /*!< Refresh error flag */
#define FMC_SDSR_MODES1_Pos        (1U)
#define FMC_SDSR_MODES1_Msk        (0x3UL << FMC_SDSR_MODES1_Pos)              /*!< 0x00000006 */
#define FMC_SDSR_MODES1            FMC_SDSR_MODES1_Msk                         /*!< Status mode for bank 1 */
#define FMC_SDSR_MODES1_0          (0x1UL << FMC_SDSR_MODES1_Pos)              /*!< 0x00000002 */
#define FMC_SDSR_MODES1_1          (0x2UL << FMC_SDSR_MODES1_Pos)              /*!< 0x00000004 */
#define FMC_SDSR_MODES2_Pos        (3U)
#define FMC_SDSR_MODES2_Msk        (0x3UL << FMC_SDSR_MODES2_Pos)              /*!< 0x00000018 */
#define FMC_SDSR_MODES2            FMC_SDSR_MODES2_Msk                         /*!< Status mode for bank 2 */
#define FMC_SDSR_MODES2_0          (0x1UL << FMC_SDSR_MODES2_Pos)              /*!< 0x00000008 */
#define FMC_SDSR_MODES2_1          (0x2UL << FMC_SDSR_MODES2_Pos)              /*!< 0x00000010 */
