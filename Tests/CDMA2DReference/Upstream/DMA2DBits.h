// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010, stm32h7s3xx.h.
typedef struct
{
  __IO uint32_t CR;            /*!< DMA2D Control Register,                         Address offset: 0x00 */
  __IO uint32_t ISR;           /*!< DMA2D Interrupt Status Register,                Address offset: 0x04 */
  __IO uint32_t IFCR;          /*!< DMA2D Interrupt Flag Clear Register,            Address offset: 0x08 */
  __IO uint32_t FGMAR;         /*!< DMA2D Foreground Memory Address Register,       Address offset: 0x0C */
  __IO uint32_t FGOR;          /*!< DMA2D Foreground Offset Register,               Address offset: 0x10 */
  __IO uint32_t BGMAR;         /*!< DMA2D Background Memory Address Register,       Address offset: 0x14 */
  __IO uint32_t BGOR;          /*!< DMA2D Background Offset Register,               Address offset: 0x18 */
  __IO uint32_t FGPFCCR;       /*!< DMA2D Foreground PFC Control Register,          Address offset: 0x1C */
  __IO uint32_t FGCOLR;        /*!< DMA2D Foreground Color Register,                Address offset: 0x20 */
  __IO uint32_t BGPFCCR;       /*!< DMA2D Background PFC Control Register,          Address offset: 0x24 */
  __IO uint32_t BGCOLR;        /*!< DMA2D Background Color Register,                Address offset: 0x28 */
  __IO uint32_t FGCMAR;        /*!< DMA2D Foreground CLUT Memory Address Register,  Address offset: 0x2C */
  __IO uint32_t BGCMAR;        /*!< DMA2D Background CLUT Memory Address Register,  Address offset: 0x30 */
  __IO uint32_t OPFCCR;        /*!< DMA2D Output PFC Control Register,              Address offset: 0x34 */
  __IO uint32_t OCOLR;         /*!< DMA2D Output Color Register,                    Address offset: 0x38 */
  __IO uint32_t OMAR;          /*!< DMA2D Output Memory Address Register,           Address offset: 0x3C */
  __IO uint32_t OOR;           /*!< DMA2D Output Offset Register,                   Address offset: 0x40 */
  __IO uint32_t NLR;           /*!< DMA2D Number of Line Register,                  Address offset: 0x44 */
  __IO uint32_t LWR;           /*!< DMA2D Line Watermark Register,                  Address offset: 0x48 */
  __IO uint32_t AMTCR;         /*!< DMA2D AHB Master Timer Configuration Register,  Address offset: 0x4C */
  uint32_t      RESERVED[236]; /*!< Reserved,                                 Address offset: 0x50-0x3FF */
  __IO uint32_t FGCLUT[256];   /*!< DMA2D Foreground CLUT,                    Address offset:0x400-0x7FF */
  __IO uint32_t BGCLUT[256];   /*!< DMA2D Background CLUT,                    Address offset:0x800-0xBFF */
} DMA2D_TypeDef;
#define DMA2D_CR_START_Pos         (0U)
#define DMA2D_CR_START_Msk         (0x1UL << DMA2D_CR_START_Pos)               /*!< 0x00000001 */
#define DMA2D_CR_START             DMA2D_CR_START_Msk                          /*!< Start transfer */
#define DMA2D_CR_SUSP_Pos          (1U)
#define DMA2D_CR_SUSP_Msk          (0x1UL << DMA2D_CR_SUSP_Pos)                /*!< 0x00000002 */
#define DMA2D_CR_SUSP              DMA2D_CR_SUSP_Msk                           /*!< Suspend transfer */
#define DMA2D_CR_ABORT_Pos         (2U)
#define DMA2D_CR_ABORT_Msk         (0x1UL << DMA2D_CR_ABORT_Pos)               /*!< 0x00000004 */
#define DMA2D_CR_ABORT             DMA2D_CR_ABORT_Msk                          /*!< Abort transfer */
#define DMA2D_CR_LOM_Pos           (6U)
#define DMA2D_CR_LOM_Msk           (0x1UL << DMA2D_CR_LOM_Pos)                 /*!< 0x00000040 */
#define DMA2D_CR_LOM               DMA2D_CR_LOM_Msk                            /*!< Line Offset Mode */
#define DMA2D_CR_TEIE_Pos          (8U)
#define DMA2D_CR_TEIE_Msk          (0x1UL << DMA2D_CR_TEIE_Pos)                /*!< 0x00000100 */
#define DMA2D_CR_TEIE              DMA2D_CR_TEIE_Msk                           /*!< Transfer Error Interrupt Enable */
#define DMA2D_CR_TCIE_Pos          (9U)
#define DMA2D_CR_TCIE_Msk          (0x1UL << DMA2D_CR_TCIE_Pos)                /*!< 0x00000200 */
#define DMA2D_CR_TCIE              DMA2D_CR_TCIE_Msk                           /*!< Transfer Complete Interrupt Enable */
#define DMA2D_CR_TWIE_Pos          (10U)
#define DMA2D_CR_TWIE_Msk          (0x1UL << DMA2D_CR_TWIE_Pos)                /*!< 0x00000400 */
#define DMA2D_CR_TWIE              DMA2D_CR_TWIE_Msk                           /*!< Transfer Watermark Interrupt Enable */
#define DMA2D_CR_CAEIE_Pos         (11U)
#define DMA2D_CR_CAEIE_Msk         (0x1UL << DMA2D_CR_CAEIE_Pos)               /*!< 0x00000800 */
#define DMA2D_CR_CAEIE             DMA2D_CR_CAEIE_Msk                          /*!< CLUT Access Error Interrupt Enable */
#define DMA2D_CR_CTCIE_Pos         (12U)
#define DMA2D_CR_CTCIE_Msk         (0x1UL << DMA2D_CR_CTCIE_Pos)               /*!< 0x00001000 */
#define DMA2D_CR_CTCIE             DMA2D_CR_CTCIE_Msk                          /*!< CLUT Transfer Complete Interrupt Enable */
#define DMA2D_CR_CEIE_Pos          (13U)
#define DMA2D_CR_CEIE_Msk          (0x1UL << DMA2D_CR_CEIE_Pos)                /*!< 0x00002000 */
#define DMA2D_CR_CEIE              DMA2D_CR_CEIE_Msk                           /*!< Configuration Error Interrupt Enable */
#define DMA2D_CR_MODE_Pos          (16U)
#define DMA2D_CR_MODE_Msk          (0x7UL << DMA2D_CR_MODE_Pos)                /*!< 0x00070000 */
#define DMA2D_CR_MODE              DMA2D_CR_MODE_Msk                           /*!< DMA2D Mode[2:0] */
#define DMA2D_CR_MODE_0            (0x1UL << DMA2D_CR_MODE_Pos)                /*!< 0x00010000 */
#define DMA2D_CR_MODE_1            (0x2UL << DMA2D_CR_MODE_Pos)                /*!< 0x00020000 */
#define DMA2D_CR_MODE_2            (0x4UL << DMA2D_CR_MODE_Pos)                /*!< 0x00040000 */
#define DMA2D_ISR_TEIF_Pos         (0U)
#define DMA2D_ISR_TEIF_Msk         (0x1UL << DMA2D_ISR_TEIF_Pos)               /*!< 0x00000001 */
#define DMA2D_ISR_TEIF             DMA2D_ISR_TEIF_Msk                          /*!< Transfer Error Interrupt Flag */
#define DMA2D_ISR_TCIF_Pos         (1U)
#define DMA2D_ISR_TCIF_Msk         (0x1UL << DMA2D_ISR_TCIF_Pos)               /*!< 0x00000002 */
#define DMA2D_ISR_TCIF             DMA2D_ISR_TCIF_Msk                          /*!< Transfer Complete Interrupt Flag */
#define DMA2D_ISR_TWIF_Pos         (2U)
#define DMA2D_ISR_TWIF_Msk         (0x1UL << DMA2D_ISR_TWIF_Pos)               /*!< 0x00000004 */
#define DMA2D_ISR_TWIF             DMA2D_ISR_TWIF_Msk                          /*!< Transfer Watermark Interrupt Flag */
#define DMA2D_ISR_CAEIF_Pos        (3U)
#define DMA2D_ISR_CAEIF_Msk        (0x1UL << DMA2D_ISR_CAEIF_Pos)              /*!< 0x00000008 */
#define DMA2D_ISR_CAEIF            DMA2D_ISR_CAEIF_Msk                         /*!< CLUT Access Error Interrupt Flag */
#define DMA2D_ISR_CTCIF_Pos        (4U)
#define DMA2D_ISR_CTCIF_Msk        (0x1UL << DMA2D_ISR_CTCIF_Pos)              /*!< 0x00000010 */
#define DMA2D_ISR_CTCIF            DMA2D_ISR_CTCIF_Msk                         /*!< CLUT Transfer Complete Interrupt Flag */
#define DMA2D_ISR_CEIF_Pos         (5U)
#define DMA2D_ISR_CEIF_Msk         (0x1UL << DMA2D_ISR_CEIF_Pos)               /*!< 0x00000020 */
#define DMA2D_ISR_CEIF             DMA2D_ISR_CEIF_Msk                          /*!< Configuration Error Interrupt Flag */
#define DMA2D_IFCR_CTEIF_Pos       (0U)
#define DMA2D_IFCR_CTEIF_Msk       (0x1UL << DMA2D_IFCR_CTEIF_Pos)             /*!< 0x00000001 */
#define DMA2D_IFCR_CTEIF           DMA2D_IFCR_CTEIF_Msk                        /*!< Clears Transfer Error Interrupt Flag */
#define DMA2D_IFCR_CTCIF_Pos       (1U)
#define DMA2D_IFCR_CTCIF_Msk       (0x1UL << DMA2D_IFCR_CTCIF_Pos)             /*!< 0x00000002 */
#define DMA2D_IFCR_CTCIF           DMA2D_IFCR_CTCIF_Msk                        /*!< Clears Transfer Complete Interrupt Flag */
#define DMA2D_IFCR_CTWIF_Pos       (2U)
#define DMA2D_IFCR_CTWIF_Msk       (0x1UL << DMA2D_IFCR_CTWIF_Pos)             /*!< 0x00000004 */
#define DMA2D_IFCR_CTWIF           DMA2D_IFCR_CTWIF_Msk                        /*!< Clears Transfer Watermark Interrupt Flag */
#define DMA2D_IFCR_CAECIF_Pos      (3U)
#define DMA2D_IFCR_CAECIF_Msk      (0x1UL << DMA2D_IFCR_CAECIF_Pos)            /*!< 0x00000008 */
#define DMA2D_IFCR_CAECIF          DMA2D_IFCR_CAECIF_Msk                       /*!< Clears CLUT Access Error Interrupt Flag */
#define DMA2D_IFCR_CCTCIF_Pos      (4U)
#define DMA2D_IFCR_CCTCIF_Msk      (0x1UL << DMA2D_IFCR_CCTCIF_Pos)            /*!< 0x00000010 */
#define DMA2D_IFCR_CCTCIF          DMA2D_IFCR_CCTCIF_Msk                       /*!< Clears CLUT Transfer Complete Interrupt Flag */
#define DMA2D_IFCR_CCEIF_Pos       (5U)
#define DMA2D_IFCR_CCEIF_Msk       (0x1UL << DMA2D_IFCR_CCEIF_Pos)             /*!< 0x00000020 */
#define DMA2D_IFCR_CCEIF           DMA2D_IFCR_CCEIF_Msk                        /*!< Clears Configuration Error Interrupt Flag */
#define DMA2D_FGMAR_MA_Pos         (0U)
#define DMA2D_FGMAR_MA_Msk         (0xFFFFFFFFUL << DMA2D_FGMAR_MA_Pos)        /*!< 0xFFFFFFFF */
#define DMA2D_FGMAR_MA             DMA2D_FGMAR_MA_Msk                          /*!< Memory Address */
#define DMA2D_FGOR_LO_Pos          (0U)
#define DMA2D_FGOR_LO_Msk          (0xFFFFUL << DMA2D_FGOR_LO_Pos)             /*!< 0x0000FFFF */
#define DMA2D_FGOR_LO              DMA2D_FGOR_LO_Msk                           /*!< Line Offset */
#define DMA2D_BGMAR_MA_Pos         (0U)
#define DMA2D_BGMAR_MA_Msk         (0xFFFFFFFFUL << DMA2D_BGMAR_MA_Pos)        /*!< 0xFFFFFFFF */
#define DMA2D_BGMAR_MA             DMA2D_BGMAR_MA_Msk                          /*!< Memory Address */
#define DMA2D_BGOR_LO_Pos          (0U)
#define DMA2D_BGOR_LO_Msk          (0xFFFFUL << DMA2D_BGOR_LO_Pos)             /*!< 0x0000FFFF */
#define DMA2D_BGOR_LO              DMA2D_BGOR_LO_Msk                           /*!< Line Offset */
#define DMA2D_FGPFCCR_CM_Pos       (0U)
#define DMA2D_FGPFCCR_CM_Msk       (0xFUL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x0000000F */
#define DMA2D_FGPFCCR_CM           DMA2D_FGPFCCR_CM_Msk                        /*!< Input color mode CM[3:0] */
#define DMA2D_FGPFCCR_CM_0         (0x1UL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x00000001 */
#define DMA2D_FGPFCCR_CM_1         (0x2UL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x00000002 */
#define DMA2D_FGPFCCR_CM_2         (0x4UL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x00000004 */
#define DMA2D_FGPFCCR_CM_3         (0x8UL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x00000008 */
#define DMA2D_FGPFCCR_CCM_Pos      (4U)
#define DMA2D_FGPFCCR_CCM_Msk      (0x1UL << DMA2D_FGPFCCR_CCM_Pos)            /*!< 0x00000010 */
#define DMA2D_FGPFCCR_CCM          DMA2D_FGPFCCR_CCM_Msk                       /*!< CLUT Color mode */
#define DMA2D_FGPFCCR_START_Pos    (5U)
#define DMA2D_FGPFCCR_START_Msk    (0x1UL << DMA2D_FGPFCCR_START_Pos)          /*!< 0x00000020 */
#define DMA2D_FGPFCCR_START        DMA2D_FGPFCCR_START_Msk                     /*!< Start */
#define DMA2D_FGPFCCR_CS_Pos       (8U)
#define DMA2D_FGPFCCR_CS_Msk       (0xFFUL << DMA2D_FGPFCCR_CS_Pos)            /*!< 0x0000FF00 */
#define DMA2D_FGPFCCR_CS           DMA2D_FGPFCCR_CS_Msk                        /*!< CLUT size */
#define DMA2D_FGPFCCR_AM_Pos       (16U)
#define DMA2D_FGPFCCR_AM_Msk       (0x3UL << DMA2D_FGPFCCR_AM_Pos)             /*!< 0x00030000 */
#define DMA2D_FGPFCCR_AM           DMA2D_FGPFCCR_AM_Msk                        /*!< Alpha mode AM[1:0] */
#define DMA2D_FGPFCCR_AM_0         (0x1UL << DMA2D_FGPFCCR_AM_Pos)             /*!< 0x00010000 */
#define DMA2D_FGPFCCR_AM_1         (0x2UL << DMA2D_FGPFCCR_AM_Pos)             /*!< 0x00020000 */
#define DMA2D_FGPFCCR_CSS_Pos      (18U)
#define DMA2D_FGPFCCR_CSS_Msk      (0x3UL << DMA2D_FGPFCCR_CSS_Pos)            /*!< 0x000C0000 */
#define DMA2D_FGPFCCR_CSS          DMA2D_FGPFCCR_CSS_Msk                       /*!< Chroma Sub-Sampling */
#define DMA2D_FGPFCCR_CSS_0        (0x1UL << DMA2D_FGPFCCR_CSS_Pos)            /*!< 0x00040000 */
#define DMA2D_FGPFCCR_CSS_1        (0x2UL << DMA2D_FGPFCCR_CSS_Pos)            /*!< 0x00080000 */
#define DMA2D_FGPFCCR_AI_Pos       (20U)
#define DMA2D_FGPFCCR_AI_Msk       (0x1UL << DMA2D_FGPFCCR_AI_Pos)             /*!< 0x00100000 */
#define DMA2D_FGPFCCR_AI           DMA2D_FGPFCCR_AI_Msk                        /*!< Alpha Inverted */
#define DMA2D_FGPFCCR_RBS_Pos      (21U)
#define DMA2D_FGPFCCR_RBS_Msk      (0x1UL << DMA2D_FGPFCCR_RBS_Pos)            /*!< 0x00200000 */
#define DMA2D_FGPFCCR_RBS          DMA2D_FGPFCCR_RBS_Msk                       /*!< Red Blue Swap */
#define DMA2D_FGPFCCR_ALPHA_Pos    (24U)
#define DMA2D_FGPFCCR_ALPHA_Msk    (0xFFUL << DMA2D_FGPFCCR_ALPHA_Pos)         /*!< 0xFF000000 */
#define DMA2D_FGPFCCR_ALPHA        DMA2D_FGPFCCR_ALPHA_Msk                     /*!< Alpha value */
#define DMA2D_FGCOLR_BLUE_Pos      (0U)
#define DMA2D_FGCOLR_BLUE_Msk      (0xFFUL << DMA2D_FGCOLR_BLUE_Pos)           /*!< 0x000000FF */
#define DMA2D_FGCOLR_BLUE          DMA2D_FGCOLR_BLUE_Msk                       /*!< Blue Value */
#define DMA2D_FGCOLR_GREEN_Pos     (8U)
#define DMA2D_FGCOLR_GREEN_Msk     (0xFFUL << DMA2D_FGCOLR_GREEN_Pos)          /*!< 0x0000FF00 */
#define DMA2D_FGCOLR_GREEN         DMA2D_FGCOLR_GREEN_Msk                      /*!< Green Value */
#define DMA2D_FGCOLR_RED_Pos       (16U)
#define DMA2D_FGCOLR_RED_Msk       (0xFFUL << DMA2D_FGCOLR_RED_Pos)            /*!< 0x00FF0000 */
#define DMA2D_FGCOLR_RED           DMA2D_FGCOLR_RED_Msk                        /*!< Red Value */
#define DMA2D_BGPFCCR_CM_Pos       (0U)
#define DMA2D_BGPFCCR_CM_Msk       (0xFUL << DMA2D_BGPFCCR_CM_Pos)             /*!< 0x0000000F */
#define DMA2D_BGPFCCR_CM           DMA2D_BGPFCCR_CM_Msk                        /*!< Input color mode CM[3:0] */
#define DMA2D_BGPFCCR_CM_0         (0x1UL << DMA2D_BGPFCCR_CM_Pos)             /*!< 0x00000001 */
#define DMA2D_BGPFCCR_CM_1         (0x2UL << DMA2D_BGPFCCR_CM_Pos)             /*!< 0x00000002 */
#define DMA2D_BGPFCCR_CM_2         (0x4UL << DMA2D_BGPFCCR_CM_Pos)             /*!< 0x00000004 */
#define DMA2D_BGPFCCR_CM_3         (0x8UL << DMA2D_BGPFCCR_CM_Pos)             /*!< 0x00000008 */
#define DMA2D_BGPFCCR_CCM_Pos      (4U)
#define DMA2D_BGPFCCR_CCM_Msk      (0x1UL << DMA2D_BGPFCCR_CCM_Pos)            /*!< 0x00000010 */
#define DMA2D_BGPFCCR_CCM          DMA2D_BGPFCCR_CCM_Msk                       /*!< CLUT Color mode */
#define DMA2D_BGPFCCR_START_Pos    (5U)
#define DMA2D_BGPFCCR_START_Msk    (0x1UL << DMA2D_BGPFCCR_START_Pos)          /*!< 0x00000020 */
#define DMA2D_BGPFCCR_START        DMA2D_BGPFCCR_START_Msk                     /*!< Start */
#define DMA2D_BGPFCCR_CS_Pos       (8U)
#define DMA2D_BGPFCCR_CS_Msk       (0xFFUL << DMA2D_BGPFCCR_CS_Pos)            /*!< 0x0000FF00 */
#define DMA2D_BGPFCCR_CS           DMA2D_BGPFCCR_CS_Msk                        /*!< CLUT size */
#define DMA2D_BGPFCCR_AM_Pos       (16U)
#define DMA2D_BGPFCCR_AM_Msk       (0x3UL << DMA2D_BGPFCCR_AM_Pos)             /*!< 0x00030000 */
#define DMA2D_BGPFCCR_AM           DMA2D_BGPFCCR_AM_Msk                        /*!< Alpha mode AM[1:0] */
#define DMA2D_BGPFCCR_AM_0         (0x1UL << DMA2D_BGPFCCR_AM_Pos)             /*!< 0x00010000 */
#define DMA2D_BGPFCCR_AM_1         (0x2UL << DMA2D_BGPFCCR_AM_Pos)             /*!< 0x00020000 */
#define DMA2D_BGPFCCR_AI_Pos       (20U)
#define DMA2D_BGPFCCR_AI_Msk       (0x1UL << DMA2D_BGPFCCR_AI_Pos)             /*!< 0x00100000 */
#define DMA2D_BGPFCCR_AI           DMA2D_BGPFCCR_AI_Msk                        /*!< Alpha Inverted */
#define DMA2D_BGPFCCR_RBS_Pos      (21U)
#define DMA2D_BGPFCCR_RBS_Msk      (0x1UL << DMA2D_BGPFCCR_RBS_Pos)            /*!< 0x00200000 */
#define DMA2D_BGPFCCR_RBS          DMA2D_BGPFCCR_RBS_Msk                       /*!< Red Blue Swap */
#define DMA2D_BGPFCCR_ALPHA_Pos    (24U)
#define DMA2D_BGPFCCR_ALPHA_Msk    (0xFFUL << DMA2D_BGPFCCR_ALPHA_Pos)         /*!< 0xFF000000 */
#define DMA2D_BGPFCCR_ALPHA        DMA2D_BGPFCCR_ALPHA_Msk                     /*!< Alpha value */
#define DMA2D_BGCOLR_BLUE_Pos      (0U)
#define DMA2D_BGCOLR_BLUE_Msk      (0xFFUL << DMA2D_BGCOLR_BLUE_Pos)           /*!< 0x000000FF */
#define DMA2D_BGCOLR_BLUE          DMA2D_BGCOLR_BLUE_Msk                       /*!< Blue Value */
#define DMA2D_BGCOLR_GREEN_Pos     (8U)
#define DMA2D_BGCOLR_GREEN_Msk     (0xFFUL << DMA2D_BGCOLR_GREEN_Pos)          /*!< 0x0000FF00 */
#define DMA2D_BGCOLR_GREEN         DMA2D_BGCOLR_GREEN_Msk                      /*!< Green Value */
#define DMA2D_BGCOLR_RED_Pos       (16U)
#define DMA2D_BGCOLR_RED_Msk       (0xFFUL << DMA2D_BGCOLR_RED_Pos)            /*!< 0x00FF0000 */
#define DMA2D_BGCOLR_RED           DMA2D_BGCOLR_RED_Msk                        /*!< Red Value */
#define DMA2D_FGCMAR_MA_Pos        (0U)
#define DMA2D_FGCMAR_MA_Msk        (0xFFFFFFFFUL << DMA2D_FGCMAR_MA_Pos)       /*!< 0xFFFFFFFF */
#define DMA2D_FGCMAR_MA            DMA2D_FGCMAR_MA_Msk                         /*!< Memory Address */
#define DMA2D_BGCMAR_MA_Pos        (0U)
#define DMA2D_BGCMAR_MA_Msk        (0xFFFFFFFFUL << DMA2D_BGCMAR_MA_Pos)       /*!< 0xFFFFFFFF */
#define DMA2D_BGCMAR_MA            DMA2D_BGCMAR_MA_Msk                         /*!< Memory Address */
#define DMA2D_OPFCCR_CM_Pos        (0U)
#define DMA2D_OPFCCR_CM_Msk        (0x7UL << DMA2D_OPFCCR_CM_Pos)              /*!< 0x00000007 */
#define DMA2D_OPFCCR_CM            DMA2D_OPFCCR_CM_Msk                         /*!< Color mode CM[2:0] */
#define DMA2D_OPFCCR_CM_0          (0x1UL << DMA2D_OPFCCR_CM_Pos)              /*!< 0x00000001 */
#define DMA2D_OPFCCR_CM_1          (0x2UL << DMA2D_OPFCCR_CM_Pos)              /*!< 0x00000002 */
#define DMA2D_OPFCCR_CM_2          (0x4UL << DMA2D_OPFCCR_CM_Pos)              /*!< 0x00000004 */
#define DMA2D_OPFCCR_SB_Pos        (8U)
#define DMA2D_OPFCCR_SB_Msk        (0x1UL << DMA2D_OPFCCR_SB_Pos)              /*!< 0x00000100 */
#define DMA2D_OPFCCR_SB            DMA2D_OPFCCR_SB_Msk                         /*!< Swap Bytes */
#define DMA2D_OPFCCR_AI_Pos        (20U)
#define DMA2D_OPFCCR_AI_Msk        (0x1UL << DMA2D_OPFCCR_AI_Pos)              /*!< 0x00100000 */
#define DMA2D_OPFCCR_AI            DMA2D_OPFCCR_AI_Msk                         /*!< Alpha Inverted */
#define DMA2D_OPFCCR_RBS_Pos       (21U)
#define DMA2D_OPFCCR_RBS_Msk       (0x1UL << DMA2D_OPFCCR_RBS_Pos)             /*!< 0x00200000 */
#define DMA2D_OPFCCR_RBS           DMA2D_OPFCCR_RBS_Msk                        /*!< Red Blue Swap */
#define DMA2D_OCOLR_BLUE_1         (0x000000FFUL)                              /*!< Blue Value */
#define DMA2D_OCOLR_GREEN_1        (0x0000FF00UL)                              /*!< Green Value  */
#define DMA2D_OCOLR_RED_1          (0x00FF0000UL)                              /*!< Red Value */
#define DMA2D_OCOLR_ALPHA_1        (0xFF000000UL)                              /*!< Alpha Channel Value */
#define DMA2D_OCOLR_BLUE_2         (0x0000001FUL)                              /*!< Blue Value */
#define DMA2D_OCOLR_GREEN_2        (0x000007E0UL)                              /*!< Green Value  */
#define DMA2D_OCOLR_RED_2          (0x0000F800UL)                              /*!< Red Value */
#define DMA2D_OCOLR_BLUE_3         (0x0000001FUL)                              /*!< Blue Value */
#define DMA2D_OCOLR_GREEN_3        (0x000003E0UL)                              /*!< Green Value  */
#define DMA2D_OCOLR_RED_3          (0x00007C00UL)                              /*!< Red Value */
#define DMA2D_OCOLR_ALPHA_3        (0x00008000UL)                              /*!< Alpha Channel Value */
#define DMA2D_OCOLR_BLUE_4         (0x0000000FUL)                              /*!< Blue Value */
#define DMA2D_OCOLR_GREEN_4        (0x000000F0UL)                              /*!< Green Value  */
#define DMA2D_OCOLR_RED_4          (0x00000F00UL)                              /*!< Red Value */
#define DMA2D_OCOLR_ALPHA_4        (0x0000F000UL)                              /*!< Alpha Channel Value */
#define DMA2D_OMAR_MA_Pos          (0U)
#define DMA2D_OMAR_MA_Msk          (0xFFFFFFFFUL << DMA2D_OMAR_MA_Pos)         /*!< 0xFFFFFFFF */
#define DMA2D_OMAR_MA              DMA2D_OMAR_MA_Msk                           /*!< Memory Address */
#define DMA2D_OOR_LO_Pos           (0U)
#define DMA2D_OOR_LO_Msk           (0xFFFFUL << DMA2D_OOR_LO_Pos)              /*!< 0x0000FFFF */
#define DMA2D_OOR_LO               DMA2D_OOR_LO_Msk                            /*!< Line Offset */
#define DMA2D_NLR_NL_Pos           (0U)
#define DMA2D_NLR_NL_Msk           (0xFFFFUL << DMA2D_NLR_NL_Pos)              /*!< 0x0000FFFF */
#define DMA2D_NLR_NL               DMA2D_NLR_NL_Msk                            /*!< Number of Lines */
#define DMA2D_NLR_PL_Pos           (16U)
#define DMA2D_NLR_PL_Msk           (0x3FFFUL << DMA2D_NLR_PL_Pos)              /*!< 0x3FFF0000 */
#define DMA2D_NLR_PL               DMA2D_NLR_PL_Msk                            /*!< Pixel per Lines */
#define DMA2D_LWR_LW_Pos           (0U)
#define DMA2D_LWR_LW_Msk           (0xFFFFUL << DMA2D_LWR_LW_Pos)              /*!< 0x0000FFFF */
#define DMA2D_LWR_LW               DMA2D_LWR_LW_Msk                            /*!< Line Watermark */
#define DMA2D_AMTCR_EN_Pos         (0U)
#define DMA2D_AMTCR_EN_Msk         (0x1UL << DMA2D_AMTCR_EN_Pos)               /*!< 0x00000001 */
#define DMA2D_AMTCR_EN             DMA2D_AMTCR_EN_Msk                          /*!< Enable */
#define DMA2D_AMTCR_DT_Pos         (8U)
#define DMA2D_AMTCR_DT_Msk         (0xFFUL << DMA2D_AMTCR_DT_Pos)              /*!< 0x0000FF00 */
#define DMA2D_AMTCR_DT             DMA2D_AMTCR_DT_Msk                          /*!< Dead Time */
