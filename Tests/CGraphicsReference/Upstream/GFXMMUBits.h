// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010, stm32h7s7xx.h.
typedef struct
{
  __IO uint32_t CR;              /*!< GFXMMU configuration register,                     Address offset: 0x00 */
  __IO uint32_t SR;              /*!< GFXMMU status register,                            Address offset: 0x04 */
  __IO uint32_t FCR;             /*!< GFXMMU flag clear register,                        Address offset: 0x08 */
       uint32_t RESERVED0;       /*!< Reserved0,                                         Address offset: 0x0C */
  __IO uint32_t DVR;             /*!< GFXMMU default value register,                     Address offset: 0x10 */
  __IO uint32_t DAR;             /*!< GFXMMU default alpha register,                     Address offset: 0x14 */
       uint32_t RESERVED1[2];    /*!< Reserved1,                                 Address offset: 0x18 to 0x1C */
  __IO uint32_t B0CR;            /*!< GFXMMU buffer 0 configuration register,            Address offset: 0x20 */
  __IO uint32_t B1CR;            /*!< GFXMMU buffer 1 configuration register,            Address offset: 0x24 */
  __IO uint32_t B2CR;            /*!< GFXMMU buffer 2 configuration register,            Address offset: 0x28 */
  __IO uint32_t B3CR;            /*!< GFXMMU buffer 3 configuration register,            Address offset: 0x2C */
       uint32_t RESERVED2[1012]; /*!< Reserved2,                                 Address offset: 0x30 to 0xFFC */
  __IO uint32_t LUT[2048];       /*!< GFXMMU LUT registers,                      Address offset: 0x1000 to 0x2FFC
                                      For LUT line i, LUTiL = LUT[2*i] and LUTiH = LUT[(2*i)+1] */
} GFXMMU_TypeDef;
#define GFXMMU_CR_B0OIE_Pos                (0U)
#define GFXMMU_CR_B0OIE_Msk                (0x1UL << GFXMMU_CR_B0OIE_Pos)      /*!< 0x00000001 */
#define GFXMMU_CR_B0OIE                    GFXMMU_CR_B0OIE_Msk                 /*!< Buffer 0 overflow interrupt enable */
#define GFXMMU_CR_B1OIE_Pos                (1U)
#define GFXMMU_CR_B1OIE_Msk                (0x1UL << GFXMMU_CR_B1OIE_Pos)      /*!< 0x00000002 */
#define GFXMMU_CR_B1OIE                    GFXMMU_CR_B1OIE_Msk                 /*!< Buffer 1 overflow interrupt enable */
#define GFXMMU_CR_B2OIE_Pos                (2U)
#define GFXMMU_CR_B2OIE_Msk                (0x1UL << GFXMMU_CR_B2OIE_Pos)      /*!< 0x00000004 */
#define GFXMMU_CR_B2OIE                    GFXMMU_CR_B2OIE_Msk                 /*!< Buffer 2 overflow interrupt enable */
#define GFXMMU_CR_B3OIE_Pos                (3U)
#define GFXMMU_CR_B3OIE_Msk                (0x1UL << GFXMMU_CR_B3OIE_Pos)      /*!< 0x00000008 */
#define GFXMMU_CR_B3OIE                    GFXMMU_CR_B3OIE_Msk                 /*!< Buffer 3 overflow interrupt enable */
#define GFXMMU_CR_AMEIE_Pos                (4U)
#define GFXMMU_CR_AMEIE_Msk                (0x1UL << GFXMMU_CR_AMEIE_Pos)      /*!< 0x00000010 */
#define GFXMMU_CR_AMEIE                    GFXMMU_CR_AMEIE_Msk                 /*!< AHB master error interrupt enable */
#define GFXMMU_CR_BS_Pos                   (6U)
#define GFXMMU_CR_BS_Msk                   (0x1UL << GFXMMU_CR_BS_Pos)         /*!< 0x00000040 */
#define GFXMMU_CR_BS                       GFXMMU_CR_BS_Msk                    /*!< Block size */
#define GFXMMU_CR_ATE_Pos                  (15U)
#define GFXMMU_CR_ATE_Msk                  (0x1UL << GFXMMU_CR_ATE_Pos)        /*!< 0x00008000 */
#define GFXMMU_CR_ATE                      GFXMMU_CR_ATE_Msk                   /*!< Address translation enable */
#define GFXMMU_CR_B0PE_Pos                 (24U)
#define GFXMMU_CR_B0PE_Msk                 (0x1UL << GFXMMU_CR_B0PE_Pos)       /*!< 0x01000000 */
#define GFXMMU_CR_B0PE                     GFXMMU_CR_B0PE_Msk                  /*!< Buffer 0 packing enable */
#define GFXMMU_CR_B0PM_Pos                 (25U)
#define GFXMMU_CR_B0PM_Msk                 (0x1UL << GFXMMU_CR_B0PM_Pos)       /*!< 0x02000000 */
#define GFXMMU_CR_B0PM                     GFXMMU_CR_B0PM_Msk                  /*!< Buffer 0 packing mode */
#define GFXMMU_CR_B1PE_Pos                 (26U)
#define GFXMMU_CR_B1PE_Msk                 (0x1UL << GFXMMU_CR_B1PE_Pos)       /*!< 0x04000000 */
#define GFXMMU_CR_B1PE                     GFXMMU_CR_B1PE_Msk                  /*!< Buffer 1 packing enable */
#define GFXMMU_CR_B1PM_Pos                 (27U)
#define GFXMMU_CR_B1PM_Msk                 (0x1UL << GFXMMU_CR_B1PM_Pos)       /*!< 0x08000000 */
#define GFXMMU_CR_B1PM                     GFXMMU_CR_B1PM_Msk                  /*!< Buffer 1 packing mode */
#define GFXMMU_CR_B2PE_Pos                 (28U)
#define GFXMMU_CR_B2PE_Msk                 (0x1UL << GFXMMU_CR_B2PE_Pos)       /*!< 0x10000000 */
#define GFXMMU_CR_B2PE                     GFXMMU_CR_B2PE_Msk                  /*!< Buffer 0 packing enable */
#define GFXMMU_CR_B2PM_Pos                 (29U)
#define GFXMMU_CR_B2PM_Msk                 (0x1UL << GFXMMU_CR_B2PM_Pos)       /*!< 0x20000000 */
#define GFXMMU_CR_B2PM                     GFXMMU_CR_B2PM_Msk                  /*!< Buffer 0 packing mode */
#define GFXMMU_CR_B3PE_Pos                 (30U)
#define GFXMMU_CR_B3PE_Msk                 (0x1UL << GFXMMU_CR_B3PE_Pos)       /*!< 0x40000000 */
#define GFXMMU_CR_B3PE                     GFXMMU_CR_B3PE_Msk                  /*!< Buffer 0 packing enable */
#define GFXMMU_CR_B3PM_Pos                 (31U)
#define GFXMMU_CR_B3PM_Msk                 (0x1UL << GFXMMU_CR_B3PM_Pos)       /*!< 0x80000000 */
#define GFXMMU_CR_B3PM                     GFXMMU_CR_B3PM_Msk                  /*!< Buffer 0 packing mode */
#define GFXMMU_SR_B0OF_Pos                 (0U)
#define GFXMMU_SR_B0OF_Msk                 (0x1UL << GFXMMU_SR_B0OF_Pos)       /*!< 0x00000001 */
#define GFXMMU_SR_B0OF                     GFXMMU_SR_B0OF_Msk                  /*!< Buffer 0 overflow flag */
#define GFXMMU_SR_B1OF_Pos                 (1U)
#define GFXMMU_SR_B1OF_Msk                 (0x1UL << GFXMMU_SR_B1OF_Pos)       /*!< 0x00000002 */
#define GFXMMU_SR_B1OF                     GFXMMU_SR_B1OF_Msk                  /*!< Buffer 1 overflow flag */
#define GFXMMU_SR_B2OF_Pos                 (2U)
#define GFXMMU_SR_B2OF_Msk                 (0x1UL << GFXMMU_SR_B2OF_Pos)       /*!< 0x00000004 */
#define GFXMMU_SR_B2OF                     GFXMMU_SR_B2OF_Msk                  /*!< Buffer 2 overflow flag */
#define GFXMMU_SR_B3OF_Pos                 (3U)
#define GFXMMU_SR_B3OF_Msk                 (0x1UL << GFXMMU_SR_B3OF_Pos)       /*!< 0x00000008 */
#define GFXMMU_SR_B3OF                     GFXMMU_SR_B3OF_Msk                  /*!< Buffer 3 overflow flag */
#define GFXMMU_SR_AMEF_Pos                 (4U)
#define GFXMMU_SR_AMEF_Msk                 (0x1UL << GFXMMU_SR_AMEF_Pos)       /*!< 0x00000010 */
#define GFXMMU_SR_AMEF                     GFXMMU_SR_AMEF_Msk                  /*!< AXI master error flag */
#define GFXMMU_FCR_CB0OF_Pos               (0U)
#define GFXMMU_FCR_CB0OF_Msk               (0x1UL << GFXMMU_FCR_CB0OF_Pos)     /*!< 0x00000001 */
#define GFXMMU_FCR_CB0OF                   GFXMMU_FCR_CB0OF_Msk                /*!< Clear buffer 0 overflow flag */
#define GFXMMU_FCR_CB1OF_Pos               (1U)
#define GFXMMU_FCR_CB1OF_Msk               (0x1UL << GFXMMU_FCR_CB1OF_Pos)     /*!< 0x00000002 */
#define GFXMMU_FCR_CB1OF                   GFXMMU_FCR_CB1OF_Msk                /*!< Clear buffer 1 overflow flag */
#define GFXMMU_FCR_CB2OF_Pos               (2U)
#define GFXMMU_FCR_CB2OF_Msk               (0x1UL << GFXMMU_FCR_CB2OF_Pos)     /*!< 0x00000004 */
#define GFXMMU_FCR_CB2OF                   GFXMMU_FCR_CB2OF_Msk                /*!< Clear buffer 2 overflow flag */
#define GFXMMU_FCR_CB3OF_Pos               (3U)
#define GFXMMU_FCR_CB3OF_Msk               (0x1UL << GFXMMU_FCR_CB3OF_Pos)     /*!< 0x00000008 */
#define GFXMMU_FCR_CB3OF                   GFXMMU_FCR_CB3OF_Msk                /*!< Clear buffer 3 overflow flag */
#define GFXMMU_FCR_CAMEF_Pos               (4U)
#define GFXMMU_FCR_CAMEF_Msk               (0x1UL << GFXMMU_FCR_CAMEF_Pos)     /*!< 0x00000010 */
#define GFXMMU_FCR_CAMEF                   GFXMMU_FCR_CAMEF_Msk                /*!< Clear AHB master error flag */
#define GFXMMU_DVR_DV_Pos                  (0U)
#define GFXMMU_DVR_DV_Msk                  (0xFFFFFFFFUL << GFXMMU_DVR_DV_Pos) /*!< 0xFFFFFFFF */
#define GFXMMU_DVR_DV                      GFXMMU_DVR_DV_Msk                   /*!< DV[31:0] bits (Default value) */
#define GFXMMU_DAR_DA_Pos                  (0U)
#define GFXMMU_DAR_DA_Msk                  (0xFFUL << GFXMMU_DVR_DA_Pos)       /*!< 0x000000FF */
#define GFXMMU_DAR_DA                      GFXMMU_DVR_DA_Msk                   /*!< DA[7:0] bits (Default alpha) */
#define GFXMMU_B0CR_PBO_Pos                (4U)
#define GFXMMU_B0CR_PBO_Msk                (0x7FFFFUL << GFXMMU_B0CR_PBO_Pos)  /*!< 0x007FFFF0 */
#define GFXMMU_B0CR_PBO                    GFXMMU_B0CR_PBO_Msk                 /*!< PB0[22:4] bits (Physical buffer offset) */
#define GFXMMU_B0CR_PBBA_Pos               (23U)
#define GFXMMU_B0CR_PBBA_Msk               (0x1FFUL << GFXMMU_B0CR_PBBA_Pos)   /*!< 0xFF800000 */
#define GFXMMU_B0CR_PBBA                   GFXMMU_B0CR_PBBA_Msk                /*!< PBBA[31:23] bits (Physical buffer base address) */
#define GFXMMU_B1CR_PBO_Pos                (4U)
#define GFXMMU_B1CR_PBO_Msk                (0x7FFFFUL << GFXMMU_B1CR_PBO_Pos)  /*!< 0x007FFFF0 */
#define GFXMMU_B1CR_PBO                    GFXMMU_B1CR_PBO_Msk                 /*!< PB0[22:4] bits (Physical buffer offset) */
#define GFXMMU_B1CR_PBBA_Pos               (23U)
#define GFXMMU_B1CR_PBBA_Msk               (0x1FFUL << GFXMMU_B1CR_PBBA_Pos)   /*!< 0xFF800000 */
#define GFXMMU_B1CR_PBBA                   GFXMMU_B1CR_PBBA_Msk                /*!< PBBA[31:23] bits (Physical buffer base address) */
#define GFXMMU_B2CR_PBO_Pos                (4U)
#define GFXMMU_B2CR_PBO_Msk                (0x7FFFFUL << GFXMMU_B2CR_PBO_Pos)  /*!< 0x007FFFF0 */
#define GFXMMU_B2CR_PBO                    GFXMMU_B2CR_PBO_Msk                 /*!< PB0[22:4] bits (Physical buffer offset) */
#define GFXMMU_B2CR_PBBA_Pos               (23U)
#define GFXMMU_B2CR_PBBA_Msk               (0x1FFUL << GFXMMU_B2CR_PBBA_Pos)   /*!< 0xFF800000 */
#define GFXMMU_B2CR_PBBA                   GFXMMU_B2CR_PBBA_Msk                /*!< PBBA[31:23] bits (Physical buffer base address) */
#define GFXMMU_B3CR_PBO_Pos                (4U)
#define GFXMMU_B3CR_PBO_Msk                (0x7FFFFUL << GFXMMU_B3CR_PBO_Pos)  /*!< 0x007FFFF0 */
#define GFXMMU_B3CR_PBO                    GFXMMU_B3CR_PBO_Msk                 /*!< PB0[22:4] bits (Physical buffer offset) */
#define GFXMMU_B3CR_PBBA_Pos               (23U)
#define GFXMMU_B3CR_PBBA_Msk               (0x1FFUL << GFXMMU_B3CR_PBBA_Pos)   /*!< 0xFF800000 */
#define GFXMMU_B3CR_PBBA                   GFXMMU_B3CR_PBBA_Msk                /*!< PBBA[31:23] bits (Physical buffer base address) */
#define GFXMMU_LUTxL_EN_Pos                (0U)
#define GFXMMU_LUTxL_EN_Msk                (0x1UL << GFXMMU_LUTxL_EN_Pos)      /*!< 0x00000001 */
#define GFXMMU_LUTxL_EN                    GFXMMU_LUTxL_EN_Msk                 /*!< Enable */
#define GFXMMU_LUTxL_FVB_Pos               (8U)
#define GFXMMU_LUTxL_FVB_Msk               (0xFFUL << GFXMMU_LUTxL_FVB_Pos)    /*!< 0x0000FF00 */
#define GFXMMU_LUTxL_FVB                   GFXMMU_LUTxL_FVB_Msk                /*!< FVB[7:0] bits (First visible block) */
#define GFXMMU_LUTxL_LVB_Pos               (16U)
#define GFXMMU_LUTxL_LVB_Msk               (0xFFUL << GFXMMU_LUTxL_LVB_Pos)    /*!< 0x00FF0000 */
#define GFXMMU_LUTxL_LVB                   GFXMMU_LUTxL_LVB_Msk                /*!< LVB[7:0] bits (Last visible block) */
#define GFXMMU_LUTxH_LO_Pos                (0U)
#define GFXMMU_LUTxH_LO_Msk                (0x3FFFFUL << GFXMMU_LUTxH_LO_Pos)  /*!< 0x0003FFFF */
#define GFXMMU_LUTxH_LO                    GFXMMU_LUTxH_LO_Msk                 /*!< LO[17:0] bits (Line offset) */
