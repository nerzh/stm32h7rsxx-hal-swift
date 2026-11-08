// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS definitions from 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
typedef struct
{
  __IO uint32_t GCR;            /*!< MDF Global Control register,             Address offset: 0x00  */
  __IO uint32_t CKGCR;          /*!< MDF Clock Generator Control Register,    Address offset: 0x04  */
} MDF_TypeDef;

/**
  * @brief ADF filter
  */
typedef struct
{
  __IO uint32_t SITFCR;         /*!< MDF Serial Interface Control Register,          Address offset: 0x80 */
  __IO uint32_t BSMXCR;         /*!< MDF Bitstream Matrix Control Register,          Address offset: 0x84 */
  __IO uint32_t DFLTCR;         /*!< MDF Digital Filter Control Register,            Address offset: 0x88 */
  __IO uint32_t DFLTCICR;       /*!< MDF MCIC Configuration Register,                Address offset: 0x8C */
  __IO uint32_t DFLTRSFR;       /*!< MDF Reshape Filter Configuration Register,      Address offset: 0x90 */
  uint32_t      RESERVED0[4];   /*!< Reserved, 0x94-0xA0                                                  */
  __IO uint32_t DLYCR;          /*!< MDF Delay control Register,                     Address offset: 0xA4 */
  uint32_t      RESERVED1[1];   /*!< Reserved, 0xA8                                                       */
  __IO uint32_t DFLTIER;        /*!< MDF DFLT Interrupt enable Register,             Address offset: 0xAC */
  __IO uint32_t DFLTISR;        /*!< MDF DFLT Interrupt status Register,             Address offset: 0xB0 */
  uint32_t      RESERVED2[1];   /*!< Reserved, 0xB4                                                       */
  __IO uint32_t SADCR;          /*!< MDF SAD Control Register,                       Address offset: 0xB8 */
  __IO uint32_t SADCFGR;        /*!< MDF SAD configuration register,                 Address offset: 0xBC */
  __IO uint32_t SADSDLVR;       /*!< MDF SAD Sound level Register,                   Address offset: 0xC0 */
  __IO uint32_t SADANLVR;       /*!< MDF SAD Ambient Noise level Register,           Address offset: 0xC4 */
  uint32_t      RESERVED3[10];  /*!< Reserved, 0xC8-0xEC                                                  */
  __IO uint32_t DFLTDR;         /*!< MDF Digital Filter Data Register,               Address offset: 0xF0 */
} MDF_Filter_TypeDef;
#define MDF_GCR_TRGO_Pos                    (0U)
#define MDF_GCR_TRGO_Msk                    (0x1UL << MDF_GCR_TRGO_Pos)             /*!< 0x00000001 */
#define MDF_GCR_TRGO                        MDF_GCR_TRGO_Msk                        /*!< Trigger output control */
#define MDF_CKGCR_CKGDEN_Pos                (0U)
#define MDF_CKGCR_CKGDEN_Msk                (0x1UL << MDF_CKGCR_CKGDEN_Pos)         /*!< 0x00000001 */
#define MDF_CKGCR_CKGDEN                    MDF_CKGCR_CKGDEN_Msk                    /*!< CKGDEN dividers enable */
#define MDF_CKGCR_CCK0EN_Pos                (1U)
#define MDF_CKGCR_CCK0EN_Msk                (0x1UL << MDF_CKGCR_CCK0EN_Pos)         /*!< 0x00000002 */
#define MDF_CKGCR_CCK0EN                    MDF_CKGCR_CCK0EN_Msk                    /*!< CCK0 clock enable */
#define MDF_CKGCR_CCK1EN_Pos                (2U)
#define MDF_CKGCR_CCK1EN_Msk                (0x1UL << MDF_CKGCR_CCK1EN_Pos)         /*!< 0x00000004 */
#define MDF_CKGCR_CCK1EN                    MDF_CKGCR_CCK1EN_Msk                    /*!< CCK1 clock enable */
#define MDF_CKGCR_CKGMOD_Pos                (4U)
#define MDF_CKGCR_CKGMOD_Msk                (0x1UL << MDF_CKGCR_CKGMOD_Pos)         /*!< 0x00000010 */
#define MDF_CKGCR_CKGMOD                    MDF_CKGCR_CKGMOD_Msk                    /*!< Clock genartor mode */
#define MDF_CKGCR_CCK0DIR_Pos               (5U)
#define MDF_CKGCR_CCK0DIR_Msk               (0x1UL << MDF_CKGCR_CCK0DIR_Pos)        /*!< 0x00000020 */
#define MDF_CKGCR_CCK0DIR                   MDF_CKGCR_CCK0DIR_Msk                   /*!< CCK0 clock direction */
#define MDF_CKGCR_CCK1DIR_Pos               (6U)
#define MDF_CKGCR_CCK1DIR_Msk               (0x1UL << MDF_CKGCR_CCK1DIR_Pos)        /*!< 0x00000040 */
#define MDF_CKGCR_CCK1DIR                   MDF_CKGCR_CCK1DIR_Msk                   /*!< CCK1 clock direction */
#define MDF_CKGCR_TRGSENS_Pos               (8U)
#define MDF_CKGCR_TRGSENS_Msk               (0x1UL << MDF_CKGCR_TRGSENS_Pos)        /*!< 0x00000100 */
#define MDF_CKGCR_TRGSENS                   MDF_CKGCR_TRGSENS_Msk                   /*!< CKGEN trigger sensitivity selection */
#define MDF_CKGCR_TRGSRC_Pos                (12U)
#define MDF_CKGCR_TRGSRC_Msk                (0xFUL << MDF_CKGCR_TRGSRC_Pos)         /*!< 0x0000F000 */
#define MDF_CKGCR_TRGSRC                    MDF_CKGCR_TRGSRC_Msk                    /*!< Digital Filter trigger signal selection */
#define MDF_CKGCR_TRGSRC_0                  (0x1UL << MDF_CKGCR_TRGSRC_Pos)         /*!< 0x00001000 */
#define MDF_CKGCR_TRGSRC_1                  (0x2UL << MDF_CKGCR_TRGSRC_Pos)         /*!< 0x00002000 */
#define MDF_CKGCR_TRGSRC_2                  (0x4UL << MDF_CKGCR_TRGSRC_Pos)         /*!< 0x00004000 */
#define MDF_CKGCR_TRGSRC_3                  (0x8UL << MDF_CKGCR_TRGSRC_Pos)         /*!< 0x00008000 */
#define MDF_CKGCR_CCKDIV_Pos                (16U)
#define MDF_CKGCR_CCKDIV_Msk                (0xFUL << MDF_CKGCR_CCKDIV_Pos)         /*!< 0x000F0000 */
#define MDF_CKGCR_CCKDIV                    MDF_CKGCR_CCKDIV_Msk                    /*!< Divider to control the MDF_CCK clock */
#define MDF_CKGCR_PROCDIV_Pos               (24U)
#define MDF_CKGCR_PROCDIV_Msk               (0x7FUL << MDF_CKGCR_PROCDIV_Pos)       /*!< 0x7F000000 */
#define MDF_CKGCR_PROCDIV                   MDF_CKGCR_PROCDIV_Msk                   /*!< Divider to control the serial interface clock */
#define MDF_CKGCR_CKGACTIVE_Pos             (31U)
#define MDF_CKGCR_CKGACTIVE_Msk             (0x1UL << MDF_CKGCR_CKGACTIVE_Pos)      /*!< 0x80000000 */
#define MDF_CKGCR_CKGACTIVE                 MDF_CKGCR_CKGACTIVE_Msk                 /*!< Clock generator active flag */
#define MDF_SITFCR_SITFEN_Pos               (0U)
#define MDF_SITFCR_SITFEN_Msk               (0x1UL << MDF_SITFCR_SITFEN_Pos)        /*!< 0x00000001 */
#define MDF_SITFCR_SITFEN                   MDF_SITFCR_SITFEN_Msk                   /*!< Serial interface enable */
#define MDF_SITFCR_SCKSRC_Pos               (1U)
#define MDF_SITFCR_SCKSRC_Msk               (0x3UL << MDF_SITFCR_SCKSRC_Pos)        /*!< 0x00000006 */
#define MDF_SITFCR_SCKSRC                   MDF_SITFCR_SCKSRC_Msk                   /*!< Serial clock source */
#define MDF_SITFCR_SCKSRC_0                 (0x1UL << MDF_SITFCR_SCKSRC_Pos)
#define MDF_SITFCR_SCKSRC_1                 (0x2UL << MDF_SITFCR_SCKSRC_Pos)
#define MDF_SITFCR_SITFMOD_Pos              (4U)
#define MDF_SITFCR_SITFMOD_Msk              (0x3UL << MDF_SITFCR_SITFMOD_Pos)       /*!< 0x00000030 */
#define MDF_SITFCR_SITFMOD                  MDF_SITFCR_SITFMOD_Msk                  /*!< Serial interface type */
#define MDF_SITFCR_SITFMOD_0                (0x1UL << MDF_SITFCR_SITFMOD_Pos)       /*!< 0x00000010 */
#define MDF_SITFCR_SITFMOD_1                (0x2UL << MDF_SITFCR_SITFMOD_Pos)       /*!< 0x00000020 */
#define MDF_SITFCR_STH_Pos                  (8U)
#define MDF_SITFCR_STH_Msk                  (0x1FUL << MDF_SITFCR_STH_Pos)          /*!< 0x00001F00 */
#define MDF_SITFCR_STH                      MDF_SITFCR_STH_Msk                      /*!< Manchester Symbol threshold / SPI threshold */
#define MDF_SITFCR_SITFACTIVE_Pos           (31U)
#define MDF_SITFCR_SITFACTIVE_Msk           (0x1UL << MDF_SITFCR_SITFACTIVE_Pos)    /*!< 0x80000000 */
#define MDF_SITFCR_SITFACTIVE               MDF_SITFCR_SITFACTIVE_Msk               /*!< Serial interface active flag */
#define MDF_BSMXCR_BSSEL_Pos                (0U)
#define MDF_BSMXCR_BSSEL_Msk                (0x1FUL << MDF_BSMXCR_BSSEL_Pos)        /*!< 0x0000001F */
#define MDF_BSMXCR_BSSEL                    MDF_BSMXCR_BSSEL_Msk                    /*!< Bit Streal selection */
#define MDF_BSMXCR_BSSEL_0                  (0x1UL  << MDF_BSMXCR_BSSEL_Pos)        /*!< 0x00000001 */
#define MDF_BSMXCR_BSSEL_1                  (0x2UL  << MDF_BSMXCR_BSSEL_Pos)        /*!< 0x00000002 */
#define MDF_BSMXCR_BSSEL_2                  (0x4UL  << MDF_BSMXCR_BSSEL_Pos)        /*!< 0x00000004 */
#define MDF_BSMXCR_BSSEL_3                  (0x8UL  << MDF_BSMXCR_BSSEL_Pos)        /*!< 0x00000008 */
#define MDF_BSMXCR_BSSEL_4                  (0x10UL  << MDF_BSMXCR_BSSEL_Pos)       /*!< 0x00000010 */
#define MDF_BSMXCR_BSMXACTIVE_Pos           (31U)
#define MDF_BSMXCR_BSMXACTIVE_Msk           (0x1UL << MDF_BSMXCR_BSMXACTIVE_Pos)    /*!< 0x80000000 */
#define MDF_BSMXCR_BSMXACTIVE               MDF_BSMXCR_BSMXACTIVE_Msk               /*!< Bit Streal activation flag */
#define MDF_DFLTCR_DFLTEN_Pos               (0U)
#define MDF_DFLTCR_DFLTEN_Msk               (0x1UL << MDF_DFLTCR_DFLTEN_Pos)        /*!< 0x00000001 */
#define MDF_DFLTCR_DFLTEN                   MDF_DFLTCR_DFLTEN_Msk                   /*!< Digital filter enable */
#define MDF_DFLTCR_DMAEN_Pos                (1U)
#define MDF_DFLTCR_DMAEN_Msk                (0x1UL << MDF_DFLTCR_DMAEN_Pos)         /*!< 0x00000002 */
#define MDF_DFLTCR_DMAEN                    MDF_DFLTCR_DMAEN_Msk                    /*!< DMA request enable */
#define MDF_DFLTCR_FTH_Pos                  (2U)
#define MDF_DFLTCR_FTH_Msk                  (0x1UL << MDF_DFLTCR_FTH_Pos)           /*!< 0x00000004 */
#define MDF_DFLTCR_FTH                      MDF_DFLTCR_FTH_Msk                      /*!< RXFIFO Threshold selection */
#define MDF_DFLTCR_ACQMOD_Pos               (4U)
#define MDF_DFLTCR_ACQMOD_Msk               (0x7UL << MDF_DFLTCR_ACQMOD_Pos)        /*!< 0x00000004 */
#define MDF_DFLTCR_ACQMOD                   MDF_DFLTCR_ACQMOD_Msk                   /*!< Digital filter trigger mode */
#define MDF_DFLTCR_ACQMOD_0                 (0x1UL << MDF_DFLTCR_ACQMOD_Pos)        /*!< 0x00000010 */
#define MDF_DFLTCR_ACQMOD_1                 (0x2UL << MDF_DFLTCR_ACQMOD_Pos)        /*!< 0x00000020 */
#define MDF_DFLTCR_ACQMOD_2                 (0x4UL << MDF_DFLTCR_ACQMOD_Pos)        /*!< 0x00000040 */
#define MDF_DFLTCR_TRGSENS_Pos              (8U)
#define MDF_DFLTCR_TRGSENS_Msk              (0x1UL << MDF_DFLTCR_TRGSENS_Pos)       /*!< 0x00000004 */
#define MDF_DFLTCR_TRGSENS                  MDF_DFLTCR_TRGSENS_Msk                  /*!< Digital filter trigger sensitivity selection */
#define MDF_DFLTCR_TRGSRC_Pos               (12U)
#define MDF_DFLTCR_TRGSRC_Msk               (0xFUL << MDF_DFLTCR_TRGSRC_Pos)        /*!< 0x00000004 */
#define MDF_DFLTCR_TRGSRC                   MDF_DFLTCR_TRGSRC_Msk                   /*!< Digital filter trigger signal selection */
#define MDF_DFLTCR_TRGSRC_0                 (0x1UL << MDF_DFLTCR_TRGSRC_Pos)        /*!< 0x00001000 */
#define MDF_DFLTCR_TRGSRC_1                 (0x2UL << MDF_DFLTCR_TRGSRC_Pos)        /*!< 0x00002000 */
#define MDF_DFLTCR_TRGSRC_2                 (0x4UL << MDF_DFLTCR_TRGSRC_Pos)        /*!< 0x00004000 */
#define MDF_DFLTCR_TRGSRC_3                 (0x8UL << MDF_DFLTCR_TRGSRC_Pos)        /*!< 0x00008000 */
#define MDF_DFLTCR_NBDIS_Pos                (20U)
#define MDF_DFLTCR_NBDIS_Msk                (0xFFUL << MDF_DFLTCR_NBDIS_Pos)        /*!< 0x00000004 */
#define MDF_DFLTCR_NBDIS                    MDF_DFLTCR_NBDIS_Msk                    /*!< Number of samples to be discard */
#define MDF_DFLTCR_DFLTRUN_Pos              (30U)
#define MDF_DFLTCR_DFLTRUN_Msk              (0x1UL << MDF_DFLTCR_DFLTRUN_Pos)       /*!< 0x00000004 */
#define MDF_DFLTCR_DFLTRUN                  MDF_DFLTCR_DFLTRUN_Msk                  /*!< Digital filter run status flag */
#define MDF_DFLTCR_DFLTACTIVE_Pos           (31U)
#define MDF_DFLTCR_DFLTACTIVE_Msk           (0x1UL << MDF_DFLTCR_DFLTACTIVE_Pos)    /*!< 0x00000004 */
#define MDF_DFLTCR_DFLTACTIVE               MDF_DFLTCR_DFLTACTIVE_Msk               /*!< Digital filter active flag */
#define MDF_DFLTCICR_DATSRC_Pos             (0U)
#define MDF_DFLTCICR_DATSRC_Msk             (0x3UL << MDF_DFLTCICR_DATSRC_Pos)      /*!< 0x00000003 */
#define MDF_DFLTCICR_DATSRC                 MDF_DFLTCICR_DATSRC_Msk                 /*!< Source Data for the digital filter */
#define MDF_DFLTCICR_DATSRC_0               (0x1UL << MDF_DFLTCICR_DATSRC_Pos)      /*!< 0x00000001 */
#define MDF_DFLTCICR_DATSRC_1               (0x2UL << MDF_DFLTCICR_DATSRC_Pos)      /*!< 0x00000002 */
#define MDF_DFLTCICR_CICMOD_Pos             (4U)
#define MDF_DFLTCICR_CICMOD_Msk             (0x7UL << MDF_DFLTCICR_CICMOD_Pos)      /*!< 0x00000070 */
#define MDF_DFLTCICR_CICMOD                 MDF_DFLTCICR_CICMOD_Msk                 /*!< Select the CIC Mode*/
#define MDF_DFLTCICR_CICMOD_0               (0x1UL << MDF_DFLTCICR_CICMOD_Pos)      /*!< 0x00000010 */
#define MDF_DFLTCICR_CICMOD_1               (0x2UL << MDF_DFLTCICR_CICMOD_Pos)      /*!< 0x00000020 */
#define MDF_DFLTCICR_CICMOD_2               (0x4UL << MDF_DFLTCICR_CICMOD_Pos)      /*!< 0x00000030 */
#define MDF_DFLTCICR_MCICD_Pos              (8U)
#define MDF_DFLTCICR_MCICD_Msk              (0x1FFUL << MDF_DFLTCICR_MCICD_Pos)     /*!< 0x0001FF00 */
#define MDF_DFLTCICR_MCICD                  MDF_DFLTCICR_MCICD_Msk                  /*!< CIC decimation ratio selection*/
#define MDF_DFLTCICR_SCALE_Pos              (20U)
#define MDF_DFLTCICR_SCALE_Msk              (0x3FUL << MDF_DFLTCICR_SCALE_Pos)      /*!< 0x03F00000 */
#define MDF_DFLTCICR_SCALE                  MDF_DFLTCICR_SCALE_Msk                  /*!< Scaling factor selection*/
#define MDF_DFLTRSFR_RSFLTBYP_Pos           (0U)
#define MDF_DFLTRSFR_RSFLTBYP_Msk           (0x1UL << MDF_DFLTRSFR_RSFLTBYP_Pos)    /*!< 0x00000001 */
#define MDF_DFLTRSFR_RSFLTBYP               MDF_DFLTRSFR_RSFLTBYP_Msk               /*!< Reshape filter bypass*/
#define MDF_DFLTRSFR_RSFLTD_Pos             (4U)
#define MDF_DFLTRSFR_RSFLTD_Msk             (0x1UL << MDF_DFLTRSFR_RSFLTD_Pos)      /*!< 0x00000010 */
#define MDF_DFLTRSFR_RSFLTD                 MDF_DFLTRSFR_RSFLTD_Msk                 /*!< Reshape filter decimation ratio*/
#define MDF_DFLTRSFR_HPFBYP_Pos             (7U)
#define MDF_DFLTRSFR_HPFBYP_Msk             (0x1UL << MDF_DFLTRSFR_HPFBYP_Pos)      /*!< 0x00000080 */
#define MDF_DFLTRSFR_HPFBYP                 MDF_DFLTRSFR_HPFBYP_Msk                 /*!< High-pass filter bypass*/
#define MDF_DFLTRSFR_HPFC_Pos               (8U)
#define MDF_DFLTRSFR_HPFC_Msk               (0x3UL << MDF_DFLTRSFR_HPFC_Pos)        /*!< 0x00000080 */
#define MDF_DFLTRSFR_HPFC                   MDF_DFLTRSFR_HPFC_Msk                   /*!< High-pass filter cut-off frequency*/
#define MDF_DFLTRSFR_HPFC_0                 (0x1UL << MDF_DFLTRSFR_HPFC_Pos)
#define MDF_DFLTRSFR_HPFC_1                 (0x2UL << MDF_DFLTRSFR_HPFC_Pos)
#define MDF_DLYCR_SKPDLY_Pos                (0U)
#define MDF_DLYCR_SKPDLY_Msk                (0x7FUL << MDF_DLYCR_SKPDLY_Pos)        /*!< 0x0000007F */
#define MDF_DLYCR_SKPDLY                    MDF_DLYCR_SKPDLY_Msk                    /*!< Delay to apply to a bitstream*/
#define MDF_DLYCR_SKPBF_Pos                 (31U)
#define MDF_DLYCR_SKPBF_Msk                 (0x1UL << MDF_DLYCR_SKPBF_Pos)          /*!< 0x80000000 */
#define MDF_DLYCR_SKPBF                     MDF_DLYCR_SKPBF_Msk                     /*!< DSkip Busy Flag*/
#define MDF_DFLTIER_FTHIE_Pos               (0U)
#define MDF_DFLTIER_FTHIE_Msk               (0x1UL << MDF_DFLTIER_FTHIE_Pos)        /*!< 0x00000001 */
#define MDF_DFLTIER_FTHIE                   MDF_DFLTIER_FTHIE_Msk                   /*!< RXFIFO threshold interrupt enable*/
#define MDF_DFLTIER_DOVRIE_Pos              (1U)
#define MDF_DFLTIER_DOVRIE_Msk              (0x1UL << MDF_DFLTIER_DOVRIE_Pos)       /*!< 0x00000002 */
#define MDF_DFLTIER_DOVRIE                  MDF_DFLTIER_DOVRIE_Msk                  /*!< Data overflow interrupt enable*/
#define MDF_DFLTIER_SATIE_Pos               (9U)
#define MDF_DFLTIER_SATIE_Msk               (0x1UL << MDF_DFLTIER_SATIE_Pos)        /*!< 0x00000200 */
#define MDF_DFLTIER_SATIE                   MDF_DFLTIER_SATIE_Msk                   /*!< Saturation detection interrupt enable*/
#define MDF_DFLTIER_CKABIE_Pos              (10U)
#define MDF_DFLTIER_CKABIE_Msk              (0x1UL << MDF_DFLTIER_CKABIE_Pos)       /*!< 0x00000400 */
#define MDF_DFLTIER_CKABIE                  MDF_DFLTIER_CKABIE_Msk                  /*!< Clock absence detection interrupt enable*/
#define MDF_DFLTIER_RFOVRIE_Pos             (11U)
#define MDF_DFLTIER_RFOVRIE_Msk             (0x1UL << MDF_DFLTIER_RFOVRIE_Pos)      /*!< 0x00000800 */
#define MDF_DFLTIER_RFOVRIE                 MDF_DFLTIER_RFOVRIE_Msk                 /*!< Reshape filter overrun interrupt enable*/
#define MDF_DFLTIER_SDDETIE_Pos             (12U)
#define MDF_DFLTIER_SDDETIE_Msk             (0x1UL << MDF_DFLTIER_SDDETIE_Pos)      /*!< 0x00001000 */
#define MDF_DFLTIER_SDDETIE                 MDF_DFLTIER_SDDETIE_Msk                 /*!< SAD interrupt enable*/
#define MDF_DFLTIER_SDLVLIE_Pos             (13U)
#define MDF_DFLTIER_SDLVLIE_Msk             (0x1UL << MDF_DFLTIER_SDLVLIE_Pos)      /*!< 0x00002000 */
#define MDF_DFLTIER_SDLVLIE                 MDF_DFLTIER_SDLVLIE_Msk                 /*!< Sound level value ready interrupt enable*/
#define MDF_DFLTISR_FTHF_Pos                (0U)
#define MDF_DFLTISR_FTHF_Msk                (0x1UL << MDF_DFLTISR_FTHF_Pos)         /*!< 0x00000001 */
#define MDF_DFLTISR_FTHF                    MDF_DFLTISR_FTHF_Msk                    /*!< RXFIFO threshold interrupt flag*/
#define MDF_DFLTISR_DOVRF_Pos               (1U)
#define MDF_DFLTISR_DOVRF_Msk               (0x1UL << MDF_DFLTISR_DOVRF_Pos)        /*!< 0x00000002 */
#define MDF_DFLTISR_DOVRF                   MDF_DFLTISR_DOVRF_Msk                   /*!< Data overflow interrupt flag*/
#define MDF_DFLTISR_RXNEF_Pos               (3U)
#define MDF_DFLTISR_RXNEF_Msk               (0x1UL << MDF_DFLTISR_RXNEF_Pos)        /*!< 0x00000008 */
#define MDF_DFLTISR_RXNEF                   MDF_DFLTISR_RXNEF_Msk                   /*!< RXFIFO not empty flag*/
#define MDF_DFLTISR_SATF_Pos                (9U)
#define MDF_DFLTISR_SATF_Msk                (0x1UL << MDF_DFLTISR_SATF_Pos)         /*!< 0x00000200 */
#define MDF_DFLTISR_SATF                    MDF_DFLTISR_SATF_Msk                    /*!< Saturation detection interrupt flag*/
#define MDF_DFLTISR_CKABF_Pos               (10U)
#define MDF_DFLTISR_CKABF_Msk               (0x1UL << MDF_DFLTISR_CKABF_Pos)        /*!< 0x00000400 */
#define MDF_DFLTISR_CKABF                   MDF_DFLTISR_CKABF_Msk                   /*!< Clock absence detection interrupt flag*/
#define MDF_DFLTISR_RFOVRF_Pos              (11U)
#define MDF_DFLTISR_RFOVRF_Msk              (0x1UL << MDF_DFLTISR_RFOVRF_Pos)       /*!< 0x00000800 */
#define MDF_DFLTISR_RFOVRF                  MDF_DFLTISR_RFOVRF_Msk                  /*!< Reshape filter overrun interrupt flag*/
#define MDF_DFLTISR_SDDETF_Pos              (12U)
#define MDF_DFLTISR_SDDETF_Msk              (0x1UL << MDF_DFLTISR_SDDETF_Pos)        /*!< 0x00001000 */
#define MDF_DFLTISR_SDDETF                  MDF_DFLTISR_SDDETF_Msk                  /*!< SAD interrupt flag*/
#define MDF_DFLTISR_SDLVLF_Pos              (13U)
#define MDF_DFLTISR_SDLVLF_Msk              (0x1UL << MDF_DFLTISR_SDLVLF_Pos)       /*!< 0x00002000 */
#define MDF_DFLTISR_SDLVLF                  MDF_DFLTISR_SDLVLF_Msk                  /*!< Sound level value ready interrupt flag*/
#define MDF_SADCR_SADEN_Pos                 (0U)
#define MDF_SADCR_SADEN_Msk                 (0x1UL << MDF_SADCR_SADEN_Pos)          /*!< 0x00000001 */
#define MDF_SADCR_SADEN                     MDF_SADCR_SADEN_Msk                     /*!< SAD enable*/
#define MDF_SADCR_DATCAP_Pos                (1U)
#define MDF_SADCR_DATCAP_Msk                (0x3UL << MDF_SADCR_DATCAP_Pos)         /*!< 0x00000003 */
#define MDF_SADCR_DATCAP                    MDF_SADCR_DATCAP_Msk                    /*!< SAD data capture mode*/
#define MDF_SADCR_DATCAP_0                  (0x1UL << MDF_SADCR_DATCAP_Pos)         /*!< 0x00000002 */
#define MDF_SADCR_DATCAP_1                  (0x2UL << MDF_SADCR_DATCAP_Pos)         /*!< 0x00000004 */
#define MDF_SADCR_DETCFG_Pos                (3U)
#define MDF_SADCR_DETCFG_Msk                (0x1UL << MDF_SADCR_DETCFG_Pos)         /*!< 0x00000008 */
#define MDF_SADCR_DETCFG                    MDF_SADCR_DETCFG_Msk                    /*!< SAD trigger event configuration*/
#define MDF_SADCR_SADST_Pos                 (4U)
#define MDF_SADCR_SADST_Msk                 (0x3UL << MDF_SADCR_SADST_Pos)          /*!< 0x00000030 */
#define MDF_SADCR_SADST                     MDF_SADCR_SADST_Msk                     /*!< SAD state*/
#define MDF_SADCR_HYSTEN_Pos                (7U)
#define MDF_SADCR_HYSTEN_Msk                (0x1UL << MDF_SADCR_HYSTEN_Pos)         /*!< 0x00000080 */
#define MDF_SADCR_HYSTEN                    MDF_SADCR_HYSTEN_Msk                    /*!< Hysteresis enable*/
#define MDF_SADCR_FRSIZE_Pos                (8U)
#define MDF_SADCR_FRSIZE_Msk                (0x7UL << MDF_SADCR_FRSIZE_Pos)         /*!< 0x00000700 */
#define MDF_SADCR_FRSIZE                    MDF_SADCR_FRSIZE_Msk                    /*!< Frame size*/
#define MDF_SADCR_FRSIZE_0                  (0x1UL << MDF_SADCR_FRSIZE_Pos)         /*!< 0x00000100 */
#define MDF_SADCR_FRSIZE_1                  (0x2UL << MDF_SADCR_FRSIZE_Pos)         /*!< 0x00000200 */
#define MDF_SADCR_FRSIZE_2                  (0x4UL << MDF_SADCR_FRSIZE_Pos)         /*!< 0x00000300 */
#define MDF_SADCR_SADMOD_Pos                (12U)
#define MDF_SADCR_SADMOD_Msk                (0x3UL << MDF_SADCR_SADMOD_Pos)         /*!< 0x00003000 */
#define MDF_SADCR_SADMOD                    MDF_SADCR_SADMOD_Msk                    /*!< SAD working mode*/
#define MDF_SADCR_SADMOD_0                  (0x1UL << MDF_SADCR_SADMOD_Pos)         /*!< 0x00001000 */
#define MDF_SADCR_SADMOD_1                  (0x2UL << MDF_SADCR_SADMOD_Pos)         /*!< 0x00002000 */
#define MDF_SADCR_SADACTIVE_Pos             (31U)
#define MDF_SADCR_SADACTIVE_Msk             (0x1UL << MDF_SADCR_SADACTIVE_Pos)      /*!< 0x80000000 */
#define MDF_SADCR_SADACTIVE                 MDF_SADCR_SADACTIVE_Msk                 /*!< SAD active flag*/
#define MDF_SADCFGR_SNTHR_Pos               (0U)
#define MDF_SADCFGR_SNTHR_Msk               (0xFUL << MDF_SADCFGR_SNTHR_Pos)        /*!< 0x0000000F */
#define MDF_SADCFGR_SNTHR                   MDF_SADCFGR_SNTHR_Msk                   /*!< Signal to noise threshold*/
#define MDF_SADCFGR_SNTHR_0                 (0x1UL << MDF_SADCFGR_SNTHR_Pos)        /*!< 0x00000001 */
#define MDF_SADCFGR_SNTHR_1                 (0x2UL << MDF_SADCFGR_SNTHR_Pos)        /*!< 0x00000002 */
#define MDF_SADCFGR_SNTHR_2                 (0x4UL << MDF_SADCFGR_SNTHR_Pos)        /*!< 0x00000004 */
#define MDF_SADCFGR_SNTHR_3                 (0x8UL << MDF_SADCFGR_SNTHR_Pos)        /*!< 0x00000008 */
#define MDF_SADCFGR_ANSLP_Pos               (4U)
#define MDF_SADCFGR_ANSLP_Msk               (0x7UL << MDF_SADCFGR_ANSLP_Pos)        /*!< 0x00000070 */
#define MDF_SADCFGR_ANSLP                   MDF_SADCFGR_ANSLP_Msk                   /*!< Ambiant noise slope control*/
#define MDF_SADCFGR_LFRNB_Pos               (8U)
#define MDF_SADCFGR_LFRNB_Msk               (0x7UL << MDF_SADCFGR_LFRNB_Pos)        /*!< 0x00000700 */
#define MDF_SADCFGR_LFRNB                   MDF_SADCFGR_LFRNB_Msk                   /*!< Number of learning frames*/
#define MDF_SADCFGR_LFRNB_0                 (0x1UL << MDF_SADCFGR_LFRNB_Pos)        /*!< 0x00000100 */
#define MDF_SADCFGR_LFRNB_1                 (0x2UL << MDF_SADCFGR_LFRNB_Pos)        /*!< 0x00000200 */
#define MDF_SADCFGR_LFRNB_2                 (0x4UL << MDF_SADCFGR_LFRNB_Pos)        /*!< 0x00000400 */
#define MDF_SADCFGR_HGOVR_Pos               (12U)
#define MDF_SADCFGR_HGOVR_Msk               (0x7UL << MDF_SADCFGR_HGOVR_Pos)        /*!< 0x00007000 */
#define MDF_SADCFGR_HGOVR                   MDF_SADCFGR_HGOVR_Msk                   /*!< Hangover time window*/
#define MDF_SADCFGR_HGOVR_0                 (0x1UL << MDF_SADCFGR_HGOVR_Pos)        /*!< 0x00001000 */
#define MDF_SADCFGR_HGOVR_1                 (0x2UL << MDF_SADCFGR_HGOVR_Pos)        /*!< 0x00002000 */
#define MDF_SADCFGR_HGOVR_2                 (0x4UL << MDF_SADCFGR_HGOVR_Pos)        /*!< 0x00004000 */
#define MDF_SADCFGR_ANMIN_Pos               (16U)
#define MDF_SADCFGR_ANMIN_Msk               (0x1FFFUL << MDF_SADCFGR_ANMIN_Pos)     /*!< 0x1FFF0000 */
#define MDF_SADCFGR_ANMIN                   MDF_SADCFGR_ANMIN_Msk                   /*!< Hangover time window*/
#define MDF_SADSDLVR_SDLVL_Pos              (0U)
#define MDF_SADSDLVR_SDLVL_Msk              (0x7FFFUL << MDF_SADSDLVR_SDLVL_Pos)    /*!< 0x00007FFF */
#define MDF_SADSDLVR_SDLVL                  MDF_SADSDLVR_SDLVL_Msk                  /*!< Short term sound level*/
#define MDF_SADANLVR_ANLVL_Pos              (0U)
#define MDF_SADANLVR_ANLVL_Msk              (0x7FFFUL << MDF_SADANLVR_ANLVL_Pos)    /*!< 0x00007FFF */
#define MDF_SADANLVR_ANLVL                  MDF_SADANLVR_ANLVL_Msk                  /*!< Ambiant noise level estimation*/
#define MDF_DFLTDR_DR_Pos                   (8U)
#define MDF_DFLTDR_DR_Msk                   (0xFFFFFFUL << MDF_DFLTDR_DR_Pos)       /*!< 0xFFFFFF00 */
#define MDF_DFLTDR_DR                       MDF_DFLTDR_DR_Msk                       /*!< MCIC decimation counter*/
