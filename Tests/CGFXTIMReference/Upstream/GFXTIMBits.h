// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010, stm32h7s3xx.h.
typedef struct
{
  __IO uint32_t CR;            /*!< GFXTIM configuration register,                    Address offset: 0x00 */
  __IO uint32_t CGCR;          /*!< GFXTIM clock generator configuration register,    Address offset: 0x04 */
  __IO uint32_t TCR;           /*!< GFXTIM timers configuration register,             Address offset: 0x08 */
  __IO uint32_t TDR;           /*!< GFXTIM timers disable register,                   Address offset: 0x0C */
  __IO uint32_t EVCR;          /*!< GFXTIM events control register,                   Address offset: 0x10 */
  __IO uint32_t EVSR;          /*!< GFXTIM events selection register,                 Address offset: 0x14 */
  uint32_t RESERVED1[2];       /*!< Reserved,                                         Address offset: 0x18-0x1C */
  __IO uint32_t WDGTCR;        /*!< GFXTIM watchdog timer configuration register,     Address offset: 0x20 */
  uint32_t RESERVED2[3];       /*!< Reserved,                                         Address offset: 0x24-0x2C */
  __IO uint32_t ISR;           /*!< GFXTIM interrupt status register,                 Address offset: 0x30 */
  __IO uint32_t ICR;           /*!< GFXTIM interrupt clear register,                  Address offset: 0x34 */
  __IO uint32_t IER;           /*!< GFXTIM interrupt enable register,                 Address offset: 0x38 */
  __IO uint32_t TSR;           /*!< GFXTIM timers status register,                    Address offset: 0x3C */
  __IO uint32_t LCCRR;         /*!< GFXTIM line clock counter reload register,        Address offset: 0x40 */
  __IO uint32_t FCCRR;         /*!< GFXTIM frame clock counter reload register,       Address offset: 0x44 */
  uint32_t RESERVED3[2];       /*!< Reserved,                                         Address offset: 0x48-0x4C */
  __IO uint32_t ATR;           /*!< GFXTIM absolute time register,                    Address offset: 0x50 */
  __IO uint32_t AFCR;          /*!< GFXTIM absolute frame counter register,           Address offset: 0x54 */
  __IO uint32_t ALCR;          /*!< GFXTIM absolute line counter register,            Address offset: 0x58 */
  uint32_t RESERVED4[1];       /*!< Reserved,                                         Address offset: 0x5C */
  __IO uint32_t AFCC1R;        /*!< GFXTIM absolute frame counter compare 1 register, Address offset: 0x60 */
  uint32_t RESERVED5[3];       /*!< Reserved,                                         Address offset: 0x64-0X6C */
  __IO uint32_t ALCC1R;        /*!< GFXTIM absolute line counter compare 1 register,  Address offset: 0x70 */
  __IO uint32_t ALCC2R;        /*!< GFXTIM absolute line counter compare 2 register,  Address offset: 0x74 */
  uint32_t RESERVED6[2];       /*!< Reserved,                                         Address offset: 0x78-0X7C */
  __IO uint32_t RFC1R;         /*!< GFXTIM relative frame counter 1 register,         Address offset: 0x80 */
  __IO uint32_t RFC1RR;        /*!< GFXTIM relative frame counter 1 reload register,  Address offset: 0x84 */
  __IO uint32_t RFC2R;         /*!< GFXTIM relative frame counter 2 register,         Address offset: 0x88 */
  __IO uint32_t RFC2RR;        /*!< GFXTIM relative frame counter 2 reload register,  Address offset: 0x8C */
  uint32_t RESERVED7[4];       /*!< Reserved,                                         Address offset: 0x90-0X9C */
  __IO uint32_t WDGCR;         /*!< GFXTIM watchdog counter register,                 Address offset: 0xA0 */
  __IO uint32_t WDGRR;         /*!< GFXTIM watchdog reload register,                  Address offset: 0xA4 */
  __IO uint32_t WDGPAR;        /*!< GFXTIM watchdog pre-alarm register,               Address offset: 0xA8 */
  uint32_t RESERVED8[209];     /*!< Reserved,                                         Address offset: 0xAC-0X3EC */
  __IO uint32_t HWCFGR;        /*!< GFXTIM HW configuration register,                 Address offset: 0x3F0 */
  __IO uint32_t VERR;          /*!< GFXTIM version register,                          Address offset: 0x3F4 */
  __IO uint32_t IPIDR;         /*!< GFXTIM identification register,                   Address offset: 0x3F8 */
  __IO uint32_t SIDR;          /*!< GFXTIM size identification register,              Address offset: 0x3FC */
} GFXTIM_TypeDef;
#define GFXTIM_CR_TES_Pos              (0U)
#define GFXTIM_CR_TES_Msk              (0x3UL << GFXTIM_CR_TES_Pos)            /*!< 0x00000003 */
#define GFXTIM_CR_TES                  GFXTIM_CR_TES_Msk
#define GFXTIM_CR_TES_0                (0x1UL << GFXTIM_CR_TES_Pos)            /*!< 0x00000001 */
#define GFXTIM_CR_TES_1                (0x2UL << GFXTIM_CR_TES_Pos)            /*!< 0x00000002 */
#define GFXTIM_CR_TEPOL_Pos            (4U)
#define GFXTIM_CR_TEPOL_Msk            (0x1UL << GFXTIM_CR_TEPOL_Pos)          /*!< 0x00000010 */
#define GFXTIM_CR_TEPOL                GFXTIM_CR_TEPOL_Msk
#define GFXTIM_CR_SYNCS_Pos            (8U)
#define GFXTIM_CR_SYNCS_Msk            (0x3UL << GFXTIM_CR_SYNCS_Pos)          /*!< 0x00000300 */
#define GFXTIM_CR_SYNCS                GFXTIM_CR_SYNCS_Msk
#define GFXTIM_CR_SYNCS_0              (0x1UL << GFXTIM_CR_SYNCS_Pos)          /*!< 0x00000100 */
#define GFXTIM_CR_SYNCS_1              (0x2UL << GFXTIM_CR_SYNCS_Pos)          /*!< 0x00000200 */
#define GFXTIM_CR_FCCOE_Pos            (16U)
#define GFXTIM_CR_FCCOE_Msk            (0x1UL << GFXTIM_CR_FCCOE_Pos)          /*!< 0x00010000 */
#define GFXTIM_CR_FCCOE                GFXTIM_CR_FCCOE_Msk
#define GFXTIM_CR_LCCOE_Pos            (17U)
#define GFXTIM_CR_LCCOE_Msk            (0x1UL << GFXTIM_CR_LCCOE_Pos)          /*!< 0x00020000 */
#define GFXTIM_CR_LCCOE                GFXTIM_CR_LCCOE_Msk
#define GFXTIM_CGCR_LCS_Pos           (0U)
#define GFXTIM_CGCR_LCS_Msk           (0x7UL << GFXTIM_CGCR_LCS_Pos)           /*!< 0x00000007 */
#define GFXTIM_CGCR_LCS               GFXTIM_CGCR_LCS_Msk
#define GFXTIM_CGCR_LCS_0             (0x1UL << GFXTIM_CGCR_LCS_Pos)           /*!< 0x00000001 */
#define GFXTIM_CGCR_LCS_1             (0x2UL << GFXTIM_CGCR_LCS_Pos)           /*!< 0x00000002 */
#define GFXTIM_CGCR_LCS_2             (0x4UL << GFXTIM_CGCR_LCS_Pos)           /*!< 0x00000004 */
#define GFXTIM_CGCR_LCCCS_Pos         (4U)
#define GFXTIM_CGCR_LCCCS_Msk         (0x1UL << GFXTIM_CGCR_LCCCS_Pos)         /*!< 0x00000010 */
#define GFXTIM_CGCR_LCCCS             GFXTIM_CGCR_LCCCS_Msk
#define GFXTIM_CGCR_LCCFR_Pos         (8U)
#define GFXTIM_CGCR_LCCFR_Msk         (0x1UL << GFXTIM_CGCR_LCCFR_Pos)         /*!< 0x00000100 */
#define GFXTIM_CGCR_LCCFR             GFXTIM_CGCR_LCCFR_Msk
#define GFXTIM_CGCR_LCCHRS_Pos        (12U)
#define GFXTIM_CGCR_LCCHRS_Msk        (0x7UL << GFXTIM_CGCR_LCCHRS_Pos)        /*!< 0x00007000 */
#define GFXTIM_CGCR_LCCHRS            GFXTIM_CGCR_LCCHRS_Msk
#define GFXTIM_CGCR_LCCHRS_0          (0x1UL << GFXTIM_CGCR_LCCHRS_Pos)        /*!< 0x00001000 */
#define GFXTIM_CGCR_LCCHRS_1          (0x2UL << GFXTIM_CGCR_LCCHRS_Pos)        /*!< 0x00002000 */
#define GFXTIM_CGCR_LCCHRS_2          (0x4UL << GFXTIM_CGCR_LCCHRS_Pos)        /*!< 0x00004000 */
#define GFXTIM_CGCR_FCS_Pos           (16U)
#define GFXTIM_CGCR_FCS_Msk           (0x7UL << GFXTIM_CGCR_FCS_Pos)           /*!< 0x00000007 */
#define GFXTIM_CGCR_FCS               GFXTIM_CGCR_FCS_Msk
#define GFXTIM_CGCR_FCS_0             (0x1UL << GFXTIM_CGCR_FCS_Pos)           /*!< 0x00001000 */
#define GFXTIM_CGCR_FCS_1             (0x2UL << GFXTIM_CGCR_FCS_Pos)           /*!< 0x00002000 */
#define GFXTIM_CGCR_FCS_2             (0x4UL << GFXTIM_CGCR_FCS_Pos)           /*!< 0x00004000 */
#define GFXTIM_CGCR_FCCCS_Pos         (20U)
#define GFXTIM_CGCR_FCCCS_Msk         (0x7UL << GFXTIM_CGCR_FCCCS_Pos)         /*!< 0x00070000 */
#define GFXTIM_CGCR_FCCCS             GFXTIM_CGCR_FCCCS_Msk
#define GFXTIM_CGCR_FCCCS_0           (0x1UL << GFXTIM_CGCR_FCCCS_Pos)         /*!< 0x00010000 */
#define GFXTIM_CGCR_FCCCS_1           (0x2UL << GFXTIM_CGCR_FCCCS_Pos)         /*!< 0x00020000 */
#define GFXTIM_CGCR_FCCCS_2           (0x4UL << GFXTIM_CGCR_FCCCS_Pos)         /*!< 0x00040000 */
#define GFXTIM_CGCR_FCCFR_Pos         (24U)
#define GFXTIM_CGCR_FCCFR_Msk         (0x1UL << GFXTIM_CGCR_FCCFR_Pos)         /*!< 0x00100000 */
#define GFXTIM_CGCR_FCCFR             GFXTIM_CGCR_FCCFR_Msk
#define GFXTIM_CGCR_FCCHRS_Pos        (28U)
#define GFXTIM_CGCR_FCCHRS_Msk        (0x7UL << GFXTIM_CGCR_FCCHRS_Pos)        /*!< 0x70000000 */
#define GFXTIM_CGCR_FCCHRS            GFXTIM_CGCR_FCCHRS_Msk
#define GFXTIM_CGCR_FCCHRS_0          (0x1UL << GFXTIM_CGCR_FCCHRS_Pos)        /*!< 0x10000000 */
#define GFXTIM_CGCR_FCCHRS_1          (0x2UL << GFXTIM_CGCR_FCCHRS_Pos)        /*!< 0x20000000 */
#define GFXTIM_CGCR_FCCHRS_2          (0x4UL << GFXTIM_CGCR_FCCHRS_Pos)        /*!< 0x40000000 */
#define GFXTIM_TCR_AFCEN_Pos           (0U)
#define GFXTIM_TCR_AFCEN_Msk           (0x1UL << GFXTIM_TCR_AFCEN_Pos)         /*!< 0x00000001 */
#define GFXTIM_TCR_AFCEN               GFXTIM_TCR_AFCEN_Msk
#define GFXTIM_TCR_FAFCR_Pos           (1U)
#define GFXTIM_TCR_FAFCR_Msk           (0x1UL << GFXTIM_TCR_FAFCR_Pos)         /*!< 0x00000002 */
#define GFXTIM_TCR_FAFCR               GFXTIM_TCR_FAFCR_Msk
#define GFXTIM_TCR_ALCEN_Pos           (4U)
#define GFXTIM_TCR_ALCEN_Msk           (0x1UL << GFXTIM_TCR_ALCEN_Pos)         /*!< 0x00000010 */
#define GFXTIM_TCR_ALCEN               GFXTIM_TCR_ALCEN_Msk
#define GFXTIM_TCR_FALCR_Pos           (5U)
#define GFXTIM_TCR_FALCR_Msk           (0x1UL << GFXTIM_TCR_FALCR_Pos)         /*!< 0x00000020 */
#define GFXTIM_TCR_FALCR               GFXTIM_TCR_FALCR_Msk
#define GFXTIM_TCR_RFC1EN_Pos          (16U)
#define GFXTIM_TCR_RFC1EN_Msk          (0x1UL << GFXTIM_TCR_RFC1EN_Pos)        /*!< 0x00010000 */
#define GFXTIM_TCR_RFC1EN              GFXTIM_TCR_RFC1EN_Msk
#define GFXTIM_TCR_RFC1CM_Pos          (17U)
#define GFXTIM_TCR_RFC1CM_Msk          (0x1UL << GFXTIM_TCR_RFC1CM_Pos)        /*!< 0x00020000 */
#define GFXTIM_TCR_RFC1CM              GFXTIM_TCR_RFC1CM_Msk
#define GFXTIM_TCR_FRFC1R_Pos          (18U)
#define GFXTIM_TCR_FRFC1R_Msk          (0x1UL << GFXTIM_TCR_FRFC1R_Pos)        /*!< 0x00040000 */
#define GFXTIM_TCR_FRFC1R              GFXTIM_TCR_FRFC1R_Msk
#define GFXTIM_TCR_RFC2EN_Pos          (20U)
#define GFXTIM_TCR_RFC2EN_Msk          (0x1UL << GFXTIM_TCR_RFC2EN_Pos)        /*!< 0x00100000 */
#define GFXTIM_TCR_RFC2EN              GFXTIM_TCR_RFC2EN_Msk
#define GFXTIM_TCR_RFC2CM_Pos          (21U)
#define GFXTIM_TCR_RFC2CM_Msk          (0x1UL << GFXTIM_TCR_RFC2CM_Pos)        /*!< 0x00200000 */
#define GFXTIM_TCR_RFC2CM              GFXTIM_TCR_RFC2CM_Msk
#define GFXTIM_TCR_FRFC2R_Pos          (22U)
#define GFXTIM_TCR_FRFC2R_Msk          (0x1UL << GFXTIM_TCR_FRFC2R_Pos)        /*!< 0x00400000 */
#define GFXTIM_TCR_FRFC2R              GFXTIM_TCR_FRFC2R_Msk
#define GFXTIM_TDR_AFCDIS_Pos          (0U)
#define GFXTIM_TDR_AFCDIS_Msk          (0x1UL << GFXTIM_TDR_AFCDIS_Pos)        /*!< 0x00000001 */
#define GFXTIM_TDR_AFCDIS              GFXTIM_TDR_AFCDIS_Msk
#define GFXTIM_TDR_ALCDIS_Pos          (4U)
#define GFXTIM_TDR_ALCDIS_Msk          (0x1UL << GFXTIM_TDR_ALCDIS_Pos)        /*!< 0x00000010 */
#define GFXTIM_TDR_ALCDIS              GFXTIM_TDR_ALCDIS_Msk
#define GFXTIM_TDR_RFC1DIS_Pos         (16U)
#define GFXTIM_TDR_RFC1DIS_Msk         (0x1UL << GFXTIM_TDR_RFC1DIS_Pos)       /*!< 0x00010000 */
#define GFXTIM_TDR_RFC1DIS             GFXTIM_TDR_RFC1DIS_Msk
#define GFXTIM_TDR_RFC2DIS_Pos         (20U)
#define GFXTIM_TDR_RFC2DIS_Msk         (0x1UL << GFXTIM_TDR_RFC2DIS_Pos)       /*!< 0x00100000 */
#define GFXTIM_TDR_RFC2DIS             GFXTIM_TDR_RFC2DIS_Msk
#define GFXTIM_EVCR_EV1EN_Pos          (0U)
#define GFXTIM_EVCR_EV1EN_Msk          (0x1UL << GFXTIM_EVCR_EV1EN_Pos)        /*!< 0x00000001 */
#define GFXTIM_EVCR_EV1EN              GFXTIM_EVCR_EV1EN_Msk
#define GFXTIM_EVCR_EV2EN_Pos          (1U)
#define GFXTIM_EVCR_EV2EN_Msk          (0x1UL << GFXTIM_EVCR_EV2EN_Pos)        /*!< 0x00000002 */
#define GFXTIM_EVCR_EV2EN              GFXTIM_EVCR_EV2EN_Msk
#define GFXTIM_EVCR_EV3EN_Pos          (2U)
#define GFXTIM_EVCR_EV3EN_Msk          (0x1UL << GFXTIM_EVCR_EV3EN_Pos)        /*!< 0x00000004 */
#define GFXTIM_EVCR_EV3EN              GFXTIM_EVCR_EV3EN_Msk
#define GFXTIM_EVCR_EV4EN_Pos          (3U)
#define GFXTIM_EVCR_EV4EN_Msk          (0x1UL << GFXTIM_EVCR_EV4EN_Pos)        /*!< 0x00000008 */
#define GFXTIM_EVCR_EV4EN              GFXTIM_EVCR_EV4EN_Msk
#define GFXTIM_EVSR_LES1_Pos           (0U)
#define GFXTIM_EVSR_LES1_Msk           (0x7UL << GFXTIM_EVSR_LES1_Pos)         /*!< 0x00000007 */
#define GFXTIM_EVSR_LES1               GFXTIM_EVSR_LES1_Msk
#define GFXTIM_EVSR_LES1_0             (0x1UL << GFXTIM_EVSR_LES1_Pos)         /*!< 0x00000001 */
#define GFXTIM_EVSR_LES1_1             (0x2UL << GFXTIM_EVSR_LES1_Pos)         /*!< 0x00000002 */
#define GFXTIM_EVSR_LES1_2             (0x4UL << GFXTIM_EVSR_LES1_Pos)         /*!< 0x00000004 */
#define GFXTIM_EVSR_FES1_Pos           (4U)
#define GFXTIM_EVSR_FES1_Msk           (0x7UL << GFXTIM_EVSR_FES1_Pos)         /*!< 0x00000070 */
#define GFXTIM_EVSR_FES1               GFXTIM_EVSR_FES1_Msk
#define GFXTIM_EVSR_FES1_0             (0x1UL << GFXTIM_EVSR_FES1_Pos)         /*!< 0x00000010 */
#define GFXTIM_EVSR_FES1_1             (0x2UL << GFXTIM_EVSR_FES1_Pos)         /*!< 0x00000020 */
#define GFXTIM_EVSR_FES1_2             (0x4UL << GFXTIM_EVSR_FES1_Pos)         /*!< 0x00000040 */
#define GFXTIM_EVSR_LES2_Pos           (8U)
#define GFXTIM_EVSR_LES2_Msk           (0x7UL << GFXTIM_EVSR_LES2_Pos)         /*!< 0x00000700 */
#define GFXTIM_EVSR_LES2               GFXTIM_EVSR_LES2_Msk
#define GFXTIM_EVSR_LES2_0             (0x1UL << GFXTIM_EVSR_LES2_Pos)         /*!< 0x00000100 */
#define GFXTIM_EVSR_LES2_1             (0x2UL << GFXTIM_EVSR_LES2_Pos)         /*!< 0x00000200 */
#define GFXTIM_EVSR_LES2_2             (0x4UL << GFXTIM_EVSR_LES2_Pos)         /*!< 0x00000400 */
#define GFXTIM_EVSR_FES2_Pos           (12U)
#define GFXTIM_EVSR_FES2_Msk           (0x7UL << GFXTIM_EVSR_FES2_Pos)         /*!< 0x00007000 */
#define GFXTIM_EVSR_FES2               GFXTIM_EVSR_FES2_Msk
#define GFXTIM_EVSR_FES2_0             (0x1UL << GFXTIM_EVSR_FES2_Pos)         /*!< 0x00001000 */
#define GFXTIM_EVSR_FES2_1             (0x2UL << GFXTIM_EVSR_FES2_Pos)         /*!< 0x00002000 */
#define GFXTIM_EVSR_FES2_2             (0x4UL << GFXTIM_EVSR_FES2_Pos)         /*!< 0x00004000 */
#define GFXTIM_EVSR_LES3_Pos           (16U)
#define GFXTIM_EVSR_LES3_Msk           (0x7UL << GFXTIM_EVSR_LES3_Pos)         /*!< 0x00070000 */
#define GFXTIM_EVSR_LES3               GFXTIM_EVSR_LES3_Msk
#define GFXTIM_EVSR_LES3_0             (0x1UL << GFXTIM_EVSR_LES3_Pos)         /*!< 0x00010000 */
#define GFXTIM_EVSR_LES3_1             (0x2UL << GFXTIM_EVSR_LES3_Pos)         /*!< 0x00020000 */
#define GFXTIM_EVSR_LES3_2             (0x4UL << GFXTIM_EVSR_LES3_Pos)         /*!< 0x00040000 */
#define GFXTIM_EVSR_FES3_Pos           (20U)
#define GFXTIM_EVSR_FES3_Msk           (0x7UL << GFXTIM_EVSR_FES3_Pos)         /*!< 0x00700000 */
#define GFXTIM_EVSR_FES3               GFXTIM_EVSR_FES3_Msk
#define GFXTIM_EVSR_FES3_0             (0x1UL << GFXTIM_EVSR_FES3_Pos)         /*!< 0x00100000 */
#define GFXTIM_EVSR_FES3_1             (0x2UL << GFXTIM_EVSR_FES3_Pos)         /*!< 0x00200000 */
#define GFXTIM_EVSR_FES3_2             (0x4UL << GFXTIM_EVSR_FES3_Pos)         /*!< 0x00400000 */
#define GFXTIM_EVSR_LES4_Pos           (24U)
#define GFXTIM_EVSR_LES4_Msk           (0x7UL << GFXTIM_EVSR_LES4_Pos)         /*!< 0x07000000 */
#define GFXTIM_EVSR_LES4               GFXTIM_EVSR_LES4_Msk
#define GFXTIM_EVSR_LES4_0             (0x1UL << GFXTIM_EVSR_LES4_Pos)         /*!< 0x01000000 */
#define GFXTIM_EVSR_LES4_1             (0x2UL << GFXTIM_EVSR_LES4_Pos)         /*!< 0x02000000 */
#define GFXTIM_EVSR_LES4_2             (0x4UL << GFXTIM_EVSR_LES4_Pos)         /*!< 0x04000000 */
#define GFXTIM_EVSR_FES4_Pos           (28U)
#define GFXTIM_EVSR_FES4_Msk           (0x7UL << GFXTIM_EVSR_FES4_Pos)         /*!< 0x70000000 */
#define GFXTIM_EVSR_FES4               GFXTIM_EVSR_FES4_Msk
#define GFXTIM_EVSR_FES4_0             (0x1UL << GFXTIM_EVSR_FES4_Pos)         /*!< 0x10000000 */
#define GFXTIM_EVSR_FES4_1             (0x2UL << GFXTIM_EVSR_FES4_Pos)         /*!< 0x20000000 */
#define GFXTIM_EVSR_FES4_2             (0x4UL << GFXTIM_EVSR_FES4_Pos)         /*!< 0x40000000 */
#define GFXTIM_WDGTCR_WDGEN_Pos        (0U)
#define GFXTIM_WDGTCR_WDGEN_Msk        (0x1UL << GFXTIM_WDGTCR_WDGEN_Pos)      /*!< 0x00000001 */
#define GFXTIM_WDGTCR_WDGEN            GFXTIM_WDGTCR_WDGEN_Msk
#define GFXTIM_WDGTCR_WDGDIS_Pos       (1U)
#define GFXTIM_WDGTCR_WDGDIS_Msk       (0x1UL << GFXTIM_WDGTCR_WDGDIS_Pos)     /*!< 0x00000002 */
#define GFXTIM_WDGTCR_WDGDIS           GFXTIM_WDGTCR_WDGDIS_Msk
#define GFXTIM_WDGTCR_WDGS_Pos         (2U)
#define GFXTIM_WDGTCR_WDGS_Msk         (0x1UL << GFXTIM_WDGTCR_WDGS_Pos)       /*!< 0x00000004 */
#define GFXTIM_WDGTCR_WDGS             GFXTIM_WDGTCR_WDGS_Msk
#define GFXTIM_WDGTCR_WDGHRC_Pos       (4U)
#define GFXTIM_WDGTCR_WDGHRC_Msk       (0x3UL << GFXTIM_WDGTCR_WDGHRC_Pos)     /*!< 0x00000030 */
#define GFXTIM_WDGTCR_WDGHRC           GFXTIM_WDGTCR_WDGHRC_Msk
#define GFXTIM_WDGTCR_WDGHRC_0         (0x1UL << GFXTIM_WDGTCR_WDGHRC_Pos)     /*!< 0x00000010 */
#define GFXTIM_WDGTCR_WDGHRC_1         (0x2UL << GFXTIM_WDGTCR_WDGHRC_Pos)     /*!< 0x00000020 */
#define GFXTIM_WDGTCR_WDGCS_Pos        (8U)
#define GFXTIM_WDGTCR_WDGCS_Msk        (0xFUL << GFXTIM_WDGTCR_WDGCS_Pos)      /*!< 0x00000700 */
#define GFXTIM_WDGTCR_WDGCS            GFXTIM_WDGTCR_WDGCS_Msk
#define GFXTIM_WDGTCR_WDGCS_0          (0x1UL << GFXTIM_WDGTCR_WDGCS_Pos)      /*!< 0x00000100 */
#define GFXTIM_WDGTCR_WDGCS_1          (0x2UL << GFXTIM_WDGTCR_WDGCS_Pos)      /*!< 0x00000200 */
#define GFXTIM_WDGTCR_WDGCS_2          (0x4UL << GFXTIM_WDGTCR_WDGCS_Pos)      /*!< 0x00000400 */
#define GFXTIM_WDGTCR_WDGCS_3          (0x8UL << GFXTIM_WDGTCR_WDGCS_Pos)      /*!< 0x00000800 */
#define GFXTIM_WDGTCR_FWDGR_Pos        (16U)
#define GFXTIM_WDGTCR_FWDGR_Msk        (0x1UL << GFXTIM_WDGTCR_FWDGR_Pos)      /*!< 0x00010000 */
#define GFXTIM_WDGTCR_FWDGR            GFXTIM_WDGTCR_FWDGR_Msk
#define GFXTIM_ISR_AFCOF_Pos           (0U)
#define GFXTIM_ISR_AFCOF_Msk           (0x1UL << GFXTIM_ISR_AFCOF_Pos)         /*!< 0x00000001 */
#define GFXTIM_ISR_AFCOF               GFXTIM_ISR_AFCOF_Msk
#define GFXTIM_ISR_ALCOF_Pos           (1U)
#define GFXTIM_ISR_ALCOF_Msk           (0x1UL << GFXTIM_ISR_ALCOF_Pos)         /*!< 0x00000002 */
#define GFXTIM_ISR_ALCOF               GFXTIM_ISR_ALCOF_Msk
#define GFXTIM_ISR_TEF_Pos             (2U)
#define GFXTIM_ISR_TEF_Msk             (0x1UL << GFXTIM_ISR_TEF_Pos)           /*!< 0x00000004 */
#define GFXTIM_ISR_TEF                 GFXTIM_ISR_TEF_Msk
#define GFXTIM_ISR_AFCC1F_Pos          (4U)
#define GFXTIM_ISR_AFCC1F_Msk          (0x1UL << GFXTIM_ISR_AFCC1F_Pos)        /*!< 0x00000010 */
#define GFXTIM_ISR_AFCC1F              GFXTIM_ISR_AFCC1F_Msk
#define GFXTIM_ISR_ALCC1F_Pos          (8U)
#define GFXTIM_ISR_ALCC1F_Msk          (0x1UL << GFXTIM_ISR_ALCC1F_Pos)        /*!< 0x00000100 */
#define GFXTIM_ISR_ALCC1F              GFXTIM_ISR_ALCC1F_Msk
#define GFXTIM_ISR_ALCC2F_Pos          (9U)
#define GFXTIM_ISR_ALCC2F_Msk          (0x1UL << GFXTIM_ISR_ALCC2F_Pos)        /*!< 0x00000200 */
#define GFXTIM_ISR_ALCC2F              GFXTIM_ISR_ALCC2F_Msk
#define GFXTIM_ISR_RFC1RF_Pos          (12U)
#define GFXTIM_ISR_RFC1RF_Msk          (0x1UL << GFXTIM_ISR_RFC1RF_Pos)        /*!< 0x00001000 */
#define GFXTIM_ISR_RFC1RF              GFXTIM_ISR_RFC1RF_Msk
#define GFXTIM_ISR_RFC2RF_Pos          (13U)
#define GFXTIM_ISR_RFC2RF_Msk          (0x1UL << GFXTIM_ISR_RFC2RF_Pos)        /*!< 0x00002000 */
#define GFXTIM_ISR_RFC2RF              GFXTIM_ISR_RFC2RF_Msk
#define GFXTIM_ISR_EV1F_Pos            (16U)
#define GFXTIM_ISR_EV1F_Msk            (0x1UL << GFXTIM_ISR_EV1F_Pos)          /*!< 0x00010000 */
#define GFXTIM_ISR_EV1F                GFXTIM_ISR_EV1F_Msk
#define GFXTIM_ISR_EV2F_Pos            (17U)
#define GFXTIM_ISR_EV2F_Msk            (0x1UL << GFXTIM_ISR_EV2F_Pos)          /*!< 0x00020000 */
#define GFXTIM_ISR_EV2F                GFXTIM_ISR_EV2F_Msk
#define GFXTIM_ISR_EV3F_Pos            (18U)
#define GFXTIM_ISR_EV3F_Msk            (0x1UL << GFXTIM_ISR_EV3F_Pos)          /*!< 0x00040000 */
#define GFXTIM_ISR_EV3F                GFXTIM_ISR_EV3F_Msk
#define GFXTIM_ISR_EV4F_Pos            (19U)
#define GFXTIM_ISR_EV4F_Msk            (0x1UL << GFXTIM_ISR_EV4F_Pos)          /*!< 0x00080000 */
#define GFXTIM_ISR_EV4F                GFXTIM_ISR_EV4F_Msk
#define GFXTIM_ISR_WDGAF_Pos           (24U)
#define GFXTIM_ISR_WDGAF_Msk           (0x1UL << GFXTIM_ISR_WDGAF_Pos)         /*!< 0x01000000 */
#define GFXTIM_ISR_WDGAF               GFXTIM_ISR_WDGAF_Msk
#define GFXTIM_ISR_WDGPF_Pos           (25U)
#define GFXTIM_ISR_WDGPF_Msk           (0x1UL << GFXTIM_ISR_WDGPF_Pos)         /*!< 0x02000000 */
#define GFXTIM_ISR_WDGPF               GFXTIM_ISR_WDGPF_Msk
#define GFXTIM_ICR_CAFCOF_Pos          (0U)
#define GFXTIM_ICR_CAFCOF_Msk          (0x1UL << GFXTIM_ICR_CAFCOF_Pos)        /*!< 0x00000001 */
#define GFXTIM_ICR_CAFCOF              GFXTIM_ICR_CAFCOF_Msk
#define GFXTIM_ICR_CALCOF_Pos          (1U)
#define GFXTIM_ICR_CALCOF_Msk          (0x1UL << GFXTIM_ICR_CALCOF_Pos)        /*!< 0x00000002 */
#define GFXTIM_ICR_CALCOF              GFXTIM_ICR_CALCOF_Msk
#define GFXTIM_ICR_CTEF_Pos            (2U)
#define GFXTIM_ICR_CTEF_Msk            (0x1UL << GFXTIM_ICR_CTEF_Pos)          /*!< 0x00000004 */
#define GFXTIM_ICR_CTEF                GFXTIM_ICR_CTEF_Msk
#define GFXTIM_ICR_CAFCC1F_Pos         (4U)
#define GFXTIM_ICR_CAFCC1F_Msk         (0x1UL << GFXTIM_ICR_CAFCC1F_Pos)       /*!< 0x00000010 */
#define GFXTIM_ICR_CAFCC1F             GFXTIM_ICR_CAFCC1F_Msk
#define GFXTIM_ICR_CALCC1F_Pos         (8U)
#define GFXTIM_ICR_CALCC1F_Msk         (0x1UL << GFXTIM_ICR_CALCC1F_Pos)       /*!< 0x00000100 */
#define GFXTIM_ICR_CALCC1F             GFXTIM_ICR_CALCC1F_Msk
#define GFXTIM_ICR_CALCC2F_Pos         (9U)
#define GFXTIM_ICR_CALCC2F_Msk         (0x1UL << GFXTIM_ICR_CALCC2F_Pos)       /*!< 0x00000200 */
#define GFXTIM_ICR_CALCC2F             GFXTIM_ICR_CALCC2F_Msk
#define GFXTIM_ICR_CRFC1RF_Pos         (12U)
#define GFXTIM_ICR_CRFC1RF_Msk         (0x1UL << GFXTIM_ICR_CRFC1RF_Pos)       /*!< 0x00001000 */
#define GFXTIM_ICR_CRFC1RF             GFXTIM_ICR_CRFC1RF_Msk
#define GFXTIM_ICR_CRFC2RF_Pos         (13U)
#define GFXTIM_ICR_CRFC2RF_Msk         (0x1UL << GFXTIM_ICR_CRFC2RF_Pos)       /*!< 0x00002000 */
#define GFXTIM_ICR_CRFC2RF             GFXTIM_ICR_CRFC2RF_Msk
#define GFXTIM_ICR_CEV1F_Pos           (16U)
#define GFXTIM_ICR_CEV1F_Msk           (0x1UL << GFXTIM_ICR_CEV1F_Pos)         /*!< 0x00010000 */
#define GFXTIM_ICR_CEV1F               GFXTIM_ICR_CEV1F_Msk
#define GFXTIM_ICR_CEV2F_Pos           (17U)
#define GFXTIM_ICR_CEV2F_Msk           (0x1UL << GFXTIM_ICR_CEV2F_Pos)         /*!< 0x00020000 */
#define GFXTIM_ICR_CEV2F               GFXTIM_ICR_CEV2F_Msk
#define GFXTIM_ICR_CEV3F_Pos           (18U)
#define GFXTIM_ICR_CEV3F_Msk           (0x1UL << GFXTIM_ICR_CEV3F_Pos)         /*!< 0x00040000 */
#define GFXTIM_ICR_CEV3F               GFXTIM_ICR_CEV3F_Msk
#define GFXTIM_ICR_CEV4F_Pos           (19U)
#define GFXTIM_ICR_CEV4F_Msk           (0x1UL << GFXTIM_ICR_CEV4F_Pos)         /*!< 0x00080000 */
#define GFXTIM_ICR_CEV4F               GFXTIM_ICR_CEV4F_Msk
#define GFXTIM_ICR_CWDGAF_Pos          (24U)
#define GFXTIM_ICR_CWDGAF_Msk          (0x1UL << GFXTIM_ICR_CWDGAF_Pos)        /*!< 0x01000000 */
#define GFXTIM_ICR_CWDGAF              GFXTIM_ICR_CWDGAF_Msk
#define GFXTIM_ICR_CWDGPF_Pos          (25U)
#define GFXTIM_ICR_CWDGPF_Msk          (0x1UL << GFXTIM_ICR_CWDGPF_Pos)        /*!< 0x02000000 */
#define GFXTIM_ICR_CWDGPF              GFXTIM_ICR_CWDGPF_Msk
#define GFXTIM_IER_AFCOIE_Pos          (0U)
#define GFXTIM_IER_AFCOIE_Msk          (0x1UL << GFXTIM_IER_AFCOIE_Pos)        /*!< 0x00000001 */
#define GFXTIM_IER_AFCOIE              GFXTIM_IER_AFCOIE_Msk
#define GFXTIM_IER_ALCOIE_Pos          (1U)
#define GFXTIM_IER_ALCOIE_Msk          (0x1UL << GFXTIM_IER_ALCOIE_Pos)        /*!< 0x00000002 */
#define GFXTIM_IER_ALCOIE              GFXTIM_IER_ALCOIE_Msk
#define GFXTIM_IER_TEIE_Pos            (2U)
#define GFXTIM_IER_TEIE_Msk            (0x1UL << GFXTIM_IER_TEIE_Pos)          /*!< 0x00000004 */
#define GFXTIM_IER_TEIE                GFXTIM_IER_TEIE_Msk
#define GFXTIM_IER_AFCC1IE_Pos         (4U)
#define GFXTIM_IER_AFCC1IE_Msk         (0x1UL << GFXTIM_IER_AFCC1IE_Pos)       /*!< 0x00000010 */
#define GFXTIM_IER_AFCC1IE             GFXTIM_IER_AFCC1IE_Msk
#define GFXTIM_IER_ALCC1IE_Pos         (8U)
#define GFXTIM_IER_ALCC1IE_Msk         (0x1UL << GFXTIM_IER_ALCC1IE_Pos)       /*!< 0x00000100 */
#define GFXTIM_IER_ALCC1IE             GFXTIM_IER_ALCC1IE_Msk
#define GFXTIM_IER_ALCC2IE_Pos         (9U)
#define GFXTIM_IER_ALCC2IE_Msk         (0x1UL << GFXTIM_IER_ALCC2IE_Pos)       /*!< 0x00000200 */
#define GFXTIM_IER_ALCC2IE             GFXTIM_IER_ALCC2IE_Msk
#define GFXTIM_IER_RFC1RIE_Pos         (12U)
#define GFXTIM_IER_RFC1RIE_Msk         (0x1UL << GFXTIM_IER_RFC1RIE_Pos)       /*!< 0x00001000 */
#define GFXTIM_IER_RFC1RIE             GFXTIM_IER_RFC1RIE_Msk
#define GFXTIM_IER_RFC2RIE_Pos         (13U)
#define GFXTIM_IER_RFC2RIE_Msk         (0x1UL << GFXTIM_IER_RFC2RIE_Pos)       /*!< 0x00002000 */
#define GFXTIM_IER_RFC2RIE             GFXTIM_IER_RFC2RIE_Msk
#define GFXTIM_IER_EV1IE_Pos           (16U)
#define GFXTIM_IER_EV1IE_Msk           (0x1UL << GFXTIM_IER_EV1IE_Pos)         /*!< 0x00010000 */
#define GFXTIM_IER_EV1IE               GFXTIM_IER_EV1IE_Msk
#define GFXTIM_IER_EV2IE_Pos           (17U)
#define GFXTIM_IER_EV2IE_Msk           (0x1UL << GFXTIM_IER_EV2IE_Pos)         /*!< 0x00020000 */
#define GFXTIM_IER_EV2IE               GFXTIM_IER_EV2IE_Msk
#define GFXTIM_IER_EV3IE_Pos           (18U)
#define GFXTIM_IER_EV3IE_Msk           (0x1UL << GFXTIM_IER_EV3IE_Pos)         /*!< 0x00040000 */
#define GFXTIM_IER_EV3IE               GFXTIM_IER_EV3IE_Msk
#define GFXTIM_IER_EV4IE_Pos           (19U)
#define GFXTIM_IER_EV4IE_Msk           (0x1UL << GFXTIM_IER_EV4IE_Pos)         /*!< 0x00080000 */
#define GFXTIM_IER_EV4IE               GFXTIM_IER_EV4IE_Msk
#define GFXTIM_IER_WDGAIE_Pos          (24U)
#define GFXTIM_IER_WDGAIE_Msk          (0x1UL << GFXTIM_IER_WDGAIE_Pos)        /*!< 0x01000000 */
#define GFXTIM_IER_WDGAIE              GFXTIM_IER_WDGAIE_Msk
#define GFXTIM_IER_WDGPIE_Pos          (25U)
#define GFXTIM_IER_WDGPIE_Msk          (0x1UL << GFXTIM_IER_WDGPIE_Pos)        /*!< 0x02000000 */
#define GFXTIM_IER_WDGPIE              GFXTIM_IER_WDGPIE_Msk
#define GFXTIM_TSR_AFCS_Pos            (0U)
#define GFXTIM_TSR_AFCS_Msk            (0x1UL << GFXTIM_TSR_AFCS_Pos)          /*!< 0x00000001 */
#define GFXTIM_TSR_AFCS                GFXTIM_TSR_AFCS_Msk
#define GFXTIM_TSR_ALCS_Pos            (4U)
#define GFXTIM_TSR_ALCS_Msk            (0x1UL << GFXTIM_TSR_ALCS_Pos)          /*!< 0x00000010 */
#define GFXTIM_TSR_ALCS                GFXTIM_TSR_ALCS_Msk
#define GFXTIM_TSR_RFC1S_Pos           (16U)
#define GFXTIM_TSR_RFC1S_Msk           (0x1UL << GFXTIM_TSR_RFC1S_Pos)         /*!< 0x00010000 */
#define GFXTIM_TSR_RFC1S               GFXTIM_TSR_RFC1S_Msk
#define GFXTIM_TSR_RFC2S_Pos           (20U)
#define GFXTIM_TSR_RFC2S_Msk           (0x1UL << GFXTIM_TSR_RFC2S_Pos)         /*!< 0x00100000 */
#define GFXTIM_TSR_RFC2S               GFXTIM_TSR_RFC2S_Msk
#define GFXTIM_LCCRR_RELOAD_Pos        (0U)
#define GFXTIM_LCCRR_RELOAD_Msk        (0x3FFFFFUL << GFXTIM_LCCRR_RELOAD_Pos) /*!< 0x003FFFFF */
#define GFXTIM_LCCRR_RELOAD            GFXTIM_LCCRR_RELOAD_Msk
#define GFXTIM_FCCRR_RELOAD_Pos        (0U)
#define GFXTIM_FCCRR_RELOAD_Msk        (0xFFFUL << GFXTIM_FCCRR_RELOAD_Pos)    /*!< 0x00000FFF */
#define GFXTIM_FCCRR_RELOAD            GFXTIM_FCCRR_RELOAD_Msk
#define GFXTIM_ATR_LINE_Pos            (0U)
#define GFXTIM_ATR_LINE_Msk            (0xFFFUL << GFXTIM_ATR_LINE_Pos)        /*!< 0x00000FFF */
#define GFXTIM_ATR_LINE                GFXTIM_ATR_LINE_Msk
#define GFXTIM_ATR_FRAME_Pos           (12U)
#define GFXTIM_ATR_FRAME_Msk           (0xFFFFFUL << GFXTIM_ATR_FRAME_Pos)     /*!< 0xFFFFF000 */
#define GFXTIM_ATR_FRAME               GFXTIM_ATR_FRAME_Msk
#define GFXTIM_AFCR_FRAME_Pos          (0U)
#define GFXTIM_AFCR_FRAME_Msk          (0xFFFFFUL << GFXTIM_AFCR_FRAME_Pos)    /*!< 0x000FFFFF */
#define GFXTIM_AFCR_FRAME              GFXTIM_AFCR_FRAME_Msk
#define GFXTIM_ALCR_LINE_Pos           (0U)
#define GFXTIM_ALCR_LINE_Msk           (0xFFFUL << GFXTIM_ALCR_LINE_Pos)       /*!< 0x00000FFF */
#define GFXTIM_ALCR_LINE               GFXTIM_ALCR_LINE_Msk
#define GFXTIM_AFCC1R_FRAME_Pos        (0U)
#define GFXTIM_AFCC1R_FRAME_Msk        (0xFFFFFUL << GFXTIM_AFCC1R_FRAME_Pos)  /*!< 0x000FFFFF */
#define GFXTIM_AFCC1R_FRAME            GFXTIM_AFCC1R_FRAME_Msk
#define GFXTIM_ALCC1R_LINE_Pos         (0U)
#define GFXTIM_ALCC1R_LINE_Msk         (0xFFFUL << GFXTIM_ALCC1R_LINE_Pos)     /*!< 0x00000FFF */
#define GFXTIM_ALCC1R_LINE             GFXTIM_ALCC1R_LINE_Msk
#define GFXTIM_ALCC2R_LINE_Pos         (0U)
#define GFXTIM_ALCC2R_LINE_Msk         (0xFFFUL << GFXTIM_ALCC2R_LINE_Pos)     /*!< 0x00000FFF */
#define GFXTIM_ALCC2R_LINE             GFXTIM_ALCC2R_LINE_Msk
#define GFXTIM_RFC1R_FRAME_Pos         (0U)
#define GFXTIM_RFC1R_FRAME_Msk         (0xFFFUL << GFXTIM_RFC1R_FRAME_Pos)     /*!< 0x00000FFF */
#define GFXTIM_RFC1R_FRAME             GFXTIM_RFC1R_FRAME_Msk
#define GFXTIM_RFC1RR_FRAME_Pos        (0U)
#define GFXTIM_RFC1RR_FRAME_Msk        (0xFFFUL << GFXTIM_RFC1RR_FRAME_Pos)    /*!< 0x00000FFF */
#define GFXTIM_RFC1RR_FRAME            GFXTIM_RFC1RR_FRAME_Msk
#define GFXTIM_RFC2R_FRAME_Pos         (0U)
#define GFXTIM_RFC2R_FRAME_Msk         (0xFFFUL << GFXTIM_RFC2R_FRAME_Pos)     /*!< 0x00000FFF */
#define GFXTIM_RFC2R_FRAME             GFXTIM_RFC2R_FRAME_Msk
#define GFXTIM_RFC2RR_FRAME_Pos        (0U)
#define GFXTIM_RFC2RR_FRAME_Msk        (0xFFFUL << GFXTIM_RFC2RR_FRAME_Pos)    /*!< 0x00000FFF */
#define GFXTIM_RFC2RR_FRAME            GFXTIM_RFC2RR_FRAME_Msk
#define GFXTIM_WDGCR_VALUE_Pos         (0U)
#define GFXTIM_WDGCR_VALUE_Msk         (0xFFFFUL << GFXTIM_WDGCR_VALUE_Pos)    /*!< 0x0000FFFF */
#define GFXTIM_WDGCR_VALUE             GFXTIM_WDGCR_VALUE_Msk
#define GFXTIM_WDGRR_RELOAD_Pos        (0U)
#define GFXTIM_WDGRR_RELOAD_Msk        (0xFFFFUL << GFXTIM_WDGRR_RELOAD_Pos)   /*!< 0x0000FFFF */
#define GFXTIM_WDGRR_RELOAD            GFXTIM_WDGRR_RELOAD_Msk
#define GFXTIM_WDGPAR_PREALARM_Pos      (0U)
#define GFXTIM_WDGPAR_PREALARM_Msk     (0xFFFFUL << GFXTIM_WDGPAR_PREALARM_Pos)/*!< 0x0000FFFF */
#define GFXTIM_WDGPAR_PREALARM          GFXTIM_WDGPAR_PREALARM_Msk
#define GFXTIM_VERR_MINREV_Pos         (0U)
#define GFXTIM_VERR_MINREV_Msk         (0xFUL << GFXTIM_VERR_MINREV_Pos)       /*!< 0x0000000F */
#define GFXTIM_VERR_MINREV             GFXTIM_VERR_MINREV_Msk
#define GFXTIM_VERR_MAJREV_Pos         (4U)
#define GFXTIM_VERR_MAJREV_Msk         (0xFUL << GFXTIM_VERR_MAJREV_Pos)       /*!< 0x000000F0 */
#define GFXTIM_VERR_MAJREV             GFXTIM_VERR_MAJREV_Msk
#define GFXTIM_IPIDR_ID_Pos            (0U)
#define GFXTIM_IPIDR_ID_Msk            (0xFFFFFFFFUL << GFXTIM_IPIDR_ID_Pos)   /*!< 0xFFFFFFFF */
#define GFXTIM_IPIDR_ID                GFXTIM_IPIDR_ID_Msk
#define GFXTIM_SIDR_SID_Pos            (0U)
#define GFXTIM_SIDR_SID_Msk            (0xFFFFFFFFUL << GFXTIM_SIDR_SID_Pos)   /*!< 0xFFFFFFFF */
#define GFXTIM_SIDR_SID                GFXTIM_SIDR_SID_Msk
