// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS definitions from 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
typedef struct
{
  __IO uint32_t CONFR0;          /*!< JPEG Codec Control Register (JPEG_CONFR0),        Address offset: 0x00 */
  __IO uint32_t CONFR1;          /*!< JPEG Codec Control Register (JPEG_CONFR1),        Address offset: 0x04 */
  __IO uint32_t CONFR2;          /*!< JPEG Codec Control Register (JPEG_CONFR2),        Address offset: 0x08 */
  __IO uint32_t CONFR3;          /*!< JPEG Codec Control Register (JPEG_CONFR3),        Address offset: 0x0C */
  __IO uint32_t CONFR4;          /*!< JPEG Codec Control Register (JPEG_CONFR4),        Address offset: 0x10 */
  __IO uint32_t CONFR5;          /*!< JPEG Codec Control Register (JPEG_CONFR5),        Address offset: 0x14 */
  __IO uint32_t CONFR6;          /*!< JPEG Codec Control Register (JPEG_CONFR6),        Address offset: 0x18 */
  __IO uint32_t CONFR7;          /*!< JPEG Codec Control Register (JPEG_CONFR7),        Address offset: 0x1C */
       uint32_t RESERVED0[4];    /* Reserved                                            Address offset: 0x20-0x2C */
  __IO uint32_t CR;              /*!< JPEG Control Register (JPEG_CR),                  Address offset: 0x30 */
  __IO uint32_t SR;              /*!< JPEG Status Register (JPEG_SR),                   Address offset: 0x34 */
  __IO uint32_t CFR;             /*!< JPEG Clear Flag Register (JPEG_CFR),              Address offset: 0x38 */
       uint32_t RESERVED1;       /* Reserved                                            Address offset: 0x3C */
  __IO uint32_t DIR;             /*!< JPEG Data Input Register (JPEG_DIR),              Address offset: 0x40 */
  __IO uint32_t DOR;             /*!< JPEG Data Output Register (JPEG_DOR),             Address offset: 0x44 */
       uint32_t RESERVED2[2];    /* Reserved                                            Address offset: 0x48-0x4C */
  __IO uint32_t QMEM0[16];       /*!< JPEG quantization tables 0,                       Address offset: 0x50-0x8C */
  __IO uint32_t QMEM1[16];       /*!< JPEG quantization tables 1,                       Address offset: 0x90-0xCC */
  __IO uint32_t QMEM2[16];       /*!< JPEG quantization tables 2,                       Address offset: 0xD0-0x10C */
  __IO uint32_t QMEM3[16];       /*!< JPEG quantization tables 3,                       Address offset: 0x110-0x14C */
  __IO uint32_t HUFFMIN[16];     /*!< JPEG HuffMin tables,                              Address offset: 0x150-0x18C */
  __IO uint32_t HUFFBASE[32];    /*!< JPEG HuffSymb tables,                             Address offset: 0x190-0x20C */
  __IO uint32_t HUFFSYMB[84];    /*!< JPEG HUFFSYMB tables,                             Address offset: 0x210-0x35C */
  __IO uint32_t DHTMEM[103];     /*!< JPEG DHTMem tables,                               Address offset: 0x360-0x4F8 */
       uint32_t RESERVED3;       /* Reserved                                            Address offset: 0x4FC */
  __IO uint32_t HUFFENC_AC0[88]; /*!< JPEG encodor, AC Huffman table 0,                 Address offset: 0x500-0x65C */
  __IO uint32_t HUFFENC_AC1[88]; /*!< JPEG encodor, AC Huffman table 1,                 Address offset: 0x660-0x7BC */
  __IO uint32_t HUFFENC_DC0[8];  /*!< JPEG encodor, DC Huffman table 0,                 Address offset: 0x7C0-0x7DC */
  __IO uint32_t HUFFENC_DC1[8];  /*!< JPEG encodor, DC Huffman table 1,                 Address offset: 0x7E0-0x7FC */
} JPEG_TypeDef;
#define JPEG_BASE                       (AHB5PERIPH_BASE + 0x3000UL)
#define JPEG_CONFR0_START_Pos          (0U)
#define JPEG_CONFR0_START_Msk          (0x1UL << JPEG_CONFR0_START_Pos)        /*!< 0x00000001 */
#define JPEG_CONFR0_START              JPEG_CONFR0_START_Msk                   /*!<Start/Stop bit */
#define JPEG_CONFR1_NF_Pos             (0U)
#define JPEG_CONFR1_NF_Msk             (0x3UL << JPEG_CONFR1_NF_Pos)           /*!< 0x00000003 */
#define JPEG_CONFR1_NF                 JPEG_CONFR1_NF_Msk                      /*!<Number of color components */
#define JPEG_CONFR1_NF_0               (0x1UL << JPEG_CONFR1_NF_Pos)           /*!< 0x00000001 */
#define JPEG_CONFR1_NF_1               (0x2UL << JPEG_CONFR1_NF_Pos)           /*!< 0x00000002 */
#define JPEG_CONFR1_DE_Pos             (3U)
#define JPEG_CONFR1_DE_Msk             (0x1UL << JPEG_CONFR1_DE_Pos)           /*!< 0x00000008 */
#define JPEG_CONFR1_DE                 JPEG_CONFR1_DE_Msk                      /*!<Decoding Enable */
#define JPEG_CONFR1_COLORSPACE_Pos     (4U)
#define JPEG_CONFR1_COLORSPACE_Msk     (0x3UL << JPEG_CONFR1_COLORSPACE_Pos)   /*!< 0x00000030 */
#define JPEG_CONFR1_COLORSPACE         JPEG_CONFR1_COLORSPACE_Msk              /*!<Color Space */
#define JPEG_CONFR1_COLORSPACE_0       (0x1UL << JPEG_CONFR1_COLORSPACE_Pos)   /*!< 0x00000010 */
#define JPEG_CONFR1_COLORSPACE_1       (0x2UL << JPEG_CONFR1_COLORSPACE_Pos)   /*!< 0x00000020 */
#define JPEG_CONFR1_NS_Pos             (6U)
#define JPEG_CONFR1_NS_Msk             (0x3UL << JPEG_CONFR1_NS_Pos)           /*!< 0x000000C0 */
#define JPEG_CONFR1_NS                 JPEG_CONFR1_NS_Msk                      /*!<Number of components for Scan */
#define JPEG_CONFR1_NS_0               (0x1UL << JPEG_CONFR1_NS_Pos)           /*!< 0x00000040 */
#define JPEG_CONFR1_NS_1               (0x2UL << JPEG_CONFR1_NS_Pos)           /*!< 0x00000080 */
#define JPEG_CONFR1_HDR_Pos            (8U)
#define JPEG_CONFR1_HDR_Msk            (0x1UL << JPEG_CONFR1_HDR_Pos)          /*!< 0x00000100 */
#define JPEG_CONFR1_HDR                JPEG_CONFR1_HDR_Msk                     /*!<Header Processing On/Off */
#define JPEG_CONFR1_YSIZE_Pos          (16U)
#define JPEG_CONFR1_YSIZE_Msk          (0xFFFFUL << JPEG_CONFR1_YSIZE_Pos)     /*!< 0xFFFF0000 */
#define JPEG_CONFR1_YSIZE              JPEG_CONFR1_YSIZE_Msk                   /*!<Number of lines in source image */
#define JPEG_CONFR2_NMCU_Pos           (0U)
#define JPEG_CONFR2_NMCU_Msk           (0x3FFFFFFUL << JPEG_CONFR2_NMCU_Pos)   /*!< 0x03FFFFFF */
#define JPEG_CONFR2_NMCU               JPEG_CONFR2_NMCU_Msk                    /*!<Number of MCU units minus 1 to encode */
#define JPEG_CONFR3_XSIZE_Pos          (16U)
#define JPEG_CONFR3_XSIZE_Msk          (0xFFFFUL << JPEG_CONFR3_XSIZE_Pos)     /*!< 0xFFFF0000 */
#define JPEG_CONFR3_XSIZE              JPEG_CONFR3_XSIZE_Msk                   /*!<Number of pixels per line */
#define JPEG_CONFR4_HD_Pos             (0U)
#define JPEG_CONFR4_HD_Msk             (0x1UL << JPEG_CONFR4_HD_Pos)           /*!< 0x00000001 */
#define JPEG_CONFR4_HD                 JPEG_CONFR4_HD_Msk                      /*!<Selects the Huffman table for encoding the DC coefficients */
#define JPEG_CONFR4_HA_Pos             (1U)
#define JPEG_CONFR4_HA_Msk             (0x1UL << JPEG_CONFR4_HA_Pos)           /*!< 0x00000002 */
#define JPEG_CONFR4_HA                 JPEG_CONFR4_HA_Msk                      /*!<Selects the Huffman table for encoding the AC coefficients */
#define JPEG_CONFR4_QT_Pos             (2U)
#define JPEG_CONFR4_QT_Msk             (0x3UL << JPEG_CONFR4_QT_Pos)           /*!< 0x0000000C */
#define JPEG_CONFR4_QT                 JPEG_CONFR4_QT_Msk                      /*!<Selects quantization table associated with a color component */
#define JPEG_CONFR4_QT_0               (0x1UL << JPEG_CONFR4_QT_Pos)           /*!< 0x00000004 */
#define JPEG_CONFR4_QT_1               (0x2UL << JPEG_CONFR4_QT_Pos)           /*!< 0x00000008 */
#define JPEG_CONFR4_NB_Pos             (4U)
#define JPEG_CONFR4_NB_Msk             (0xFUL << JPEG_CONFR4_NB_Pos)           /*!< 0x000000F0 */
#define JPEG_CONFR4_NB                 JPEG_CONFR4_NB_Msk                      /*!<Number of data units minus 1 that belong to a particular color in the MCU */
#define JPEG_CONFR4_NB_0               (0x1UL << JPEG_CONFR4_NB_Pos)           /*!< 0x00000010 */
#define JPEG_CONFR4_NB_1               (0x2UL << JPEG_CONFR4_NB_Pos)           /*!< 0x00000020 */
#define JPEG_CONFR4_NB_2               (0x4UL << JPEG_CONFR4_NB_Pos)           /*!< 0x00000040 */
#define JPEG_CONFR4_NB_3               (0x8UL << JPEG_CONFR4_NB_Pos)           /*!< 0x00000080 */
#define JPEG_CONFR4_VSF_Pos            (8U)
#define JPEG_CONFR4_VSF_Msk            (0xFUL << JPEG_CONFR4_VSF_Pos)          /*!< 0x00000F00 */
#define JPEG_CONFR4_VSF                JPEG_CONFR4_VSF_Msk                     /*!<Vertical sampling factor for component 1 */
#define JPEG_CONFR4_VSF_0              (0x1UL << JPEG_CONFR4_VSF_Pos)          /*!< 0x00000100 */
#define JPEG_CONFR4_VSF_1              (0x2UL << JPEG_CONFR4_VSF_Pos)          /*!< 0x00000200 */
#define JPEG_CONFR4_VSF_2              (0x4UL << JPEG_CONFR4_VSF_Pos)          /*!< 0x00000400 */
#define JPEG_CONFR4_VSF_3              (0x8UL << JPEG_CONFR4_VSF_Pos)          /*!< 0x00000800 */
#define JPEG_CONFR4_HSF_Pos            (12U)
#define JPEG_CONFR4_HSF_Msk            (0xFUL << JPEG_CONFR4_HSF_Pos)          /*!< 0x0000F000 */
#define JPEG_CONFR4_HSF                JPEG_CONFR4_HSF_Msk                     /*!<Horizontal sampling factor for component 1 */
#define JPEG_CONFR4_HSF_0              (0x1UL << JPEG_CONFR4_HSF_Pos)          /*!< 0x00001000 */
#define JPEG_CONFR4_HSF_1              (0x2UL << JPEG_CONFR4_HSF_Pos)          /*!< 0x00002000 */
#define JPEG_CONFR4_HSF_2              (0x4UL << JPEG_CONFR4_HSF_Pos)          /*!< 0x00004000 */
#define JPEG_CONFR4_HSF_3              (0x8UL << JPEG_CONFR4_HSF_Pos)          /*!< 0x00008000 */
#define JPEG_CONFR5_HD_Pos             (0U)
#define JPEG_CONFR5_HD_Msk             (0x1UL << JPEG_CONFR5_HD_Pos)           /*!< 0x00000001 */
#define JPEG_CONFR5_HD                 JPEG_CONFR5_HD_Msk                      /*!<Selects the Huffman table for encoding the DC coefficients */
#define JPEG_CONFR5_HA_Pos             (1U)
#define JPEG_CONFR5_HA_Msk             (0x1UL << JPEG_CONFR5_HA_Pos)           /*!< 0x00000002 */
#define JPEG_CONFR5_HA                 JPEG_CONFR5_HA_Msk                      /*!<Selects the Huffman table for encoding the AC coefficients */
#define JPEG_CONFR5_QT_Pos             (2U)
#define JPEG_CONFR5_QT_Msk             (0x3UL << JPEG_CONFR5_QT_Pos)           /*!< 0x0000000C */
#define JPEG_CONFR5_QT                 JPEG_CONFR5_QT_Msk                      /*!<Selects quantization table associated with a color component */
#define JPEG_CONFR5_QT_0               (0x1UL << JPEG_CONFR5_QT_Pos)           /*!< 0x00000004 */
#define JPEG_CONFR5_QT_1               (0x2UL << JPEG_CONFR5_QT_Pos)           /*!< 0x00000008 */
#define JPEG_CONFR5_NB_Pos             (4U)
#define JPEG_CONFR5_NB_Msk             (0xFUL << JPEG_CONFR5_NB_Pos)           /*!< 0x000000F0 */
#define JPEG_CONFR5_NB                 JPEG_CONFR5_NB_Msk                      /*!<Number of data units minus 1 that belong to a particular color in the MCU */
#define JPEG_CONFR5_NB_0               (0x1UL << JPEG_CONFR5_NB_Pos)           /*!< 0x00000010 */
#define JPEG_CONFR5_NB_1               (0x2UL << JPEG_CONFR5_NB_Pos)           /*!< 0x00000020 */
#define JPEG_CONFR5_NB_2               (0x4UL << JPEG_CONFR5_NB_Pos)           /*!< 0x00000040 */
#define JPEG_CONFR5_NB_3               (0x8UL << JPEG_CONFR5_NB_Pos)           /*!< 0x00000080 */
#define JPEG_CONFR5_VSF_Pos            (8U)
#define JPEG_CONFR5_VSF_Msk            (0xFUL << JPEG_CONFR5_VSF_Pos)          /*!< 0x00000F00 */
#define JPEG_CONFR5_VSF                JPEG_CONFR5_VSF_Msk                     /*!<Vertical sampling factor for component 2 */
#define JPEG_CONFR5_VSF_0              (0x1UL << JPEG_CONFR5_VSF_Pos)          /*!< 0x00000100 */
#define JPEG_CONFR5_VSF_1              (0x2UL << JPEG_CONFR5_VSF_Pos)          /*!< 0x00000200 */
#define JPEG_CONFR5_VSF_2              (0x4UL << JPEG_CONFR5_VSF_Pos)          /*!< 0x00000400 */
#define JPEG_CONFR5_VSF_3              (0x8UL << JPEG_CONFR5_VSF_Pos)          /*!< 0x00000800 */
#define JPEG_CONFR5_HSF_Pos            (12U)
#define JPEG_CONFR5_HSF_Msk            (0xFUL << JPEG_CONFR5_HSF_Pos)          /*!< 0x0000F000 */
#define JPEG_CONFR5_HSF                JPEG_CONFR5_HSF_Msk                     /*!<Horizontal sampling factor for component 2 */
#define JPEG_CONFR5_HSF_0              (0x1UL << JPEG_CONFR5_HSF_Pos)          /*!< 0x00001000 */
#define JPEG_CONFR5_HSF_1              (0x2UL << JPEG_CONFR5_HSF_Pos)          /*!< 0x00002000 */
#define JPEG_CONFR5_HSF_2              (0x4UL << JPEG_CONFR5_HSF_Pos)          /*!< 0x00004000 */
#define JPEG_CONFR5_HSF_3              (0x8UL << JPEG_CONFR5_HSF_Pos)          /*!< 0x00008000 */
#define JPEG_CONFR6_HD_Pos             (0U)
#define JPEG_CONFR6_HD_Msk             (0x1UL << JPEG_CONFR6_HD_Pos)           /*!< 0x00000001 */
#define JPEG_CONFR6_HD                 JPEG_CONFR6_HD_Msk                      /*!<Selects the Huffman table for encoding the DC coefficients */
#define JPEG_CONFR6_HA_Pos             (1U)
#define JPEG_CONFR6_HA_Msk             (0x1UL << JPEG_CONFR6_HA_Pos)           /*!< 0x00000002 */
#define JPEG_CONFR6_HA                 JPEG_CONFR6_HA_Msk                      /*!<Selects the Huffman table for encoding the AC coefficients */
#define JPEG_CONFR6_QT_Pos             (2U)
#define JPEG_CONFR6_QT_Msk             (0x3UL << JPEG_CONFR6_QT_Pos)           /*!< 0x0000000C */
#define JPEG_CONFR6_QT                 JPEG_CONFR6_QT_Msk                      /*!<Selects quantization table associated with a color component */
#define JPEG_CONFR6_QT_0               (0x1UL << JPEG_CONFR6_QT_Pos)           /*!< 0x00000004 */
#define JPEG_CONFR6_QT_1               (0x2UL << JPEG_CONFR6_QT_Pos)           /*!< 0x00000008 */
#define JPEG_CONFR6_NB_Pos             (4U)
#define JPEG_CONFR6_NB_Msk             (0xFUL << JPEG_CONFR6_NB_Pos)           /*!< 0x000000F0 */
#define JPEG_CONFR6_NB                 JPEG_CONFR6_NB_Msk                      /*!<Number of data units minus 1 that belong to a particular color in the MCU */
#define JPEG_CONFR6_NB_0               (0x1UL << JPEG_CONFR6_NB_Pos)           /*!< 0x00000010 */
#define JPEG_CONFR6_NB_1               (0x2UL << JPEG_CONFR6_NB_Pos)           /*!< 0x00000020 */
#define JPEG_CONFR6_NB_2               (0x4UL << JPEG_CONFR6_NB_Pos)           /*!< 0x00000040 */
#define JPEG_CONFR6_NB_3               (0x8UL << JPEG_CONFR6_NB_Pos)           /*!< 0x00000080 */
#define JPEG_CONFR6_VSF_Pos            (8U)
#define JPEG_CONFR6_VSF_Msk            (0xFUL << JPEG_CONFR6_VSF_Pos)          /*!< 0x00000F00 */
#define JPEG_CONFR6_VSF                JPEG_CONFR6_VSF_Msk                     /*!<Vertical sampling factor for component 2 */
#define JPEG_CONFR6_VSF_0              (0x1UL << JPEG_CONFR6_VSF_Pos)          /*!< 0x00000100 */
#define JPEG_CONFR6_VSF_1              (0x2UL << JPEG_CONFR6_VSF_Pos)          /*!< 0x00000200 */
#define JPEG_CONFR6_VSF_2              (0x4UL << JPEG_CONFR6_VSF_Pos)          /*!< 0x00000400 */
#define JPEG_CONFR6_VSF_3              (0x8UL << JPEG_CONFR6_VSF_Pos)          /*!< 0x00000800 */
#define JPEG_CONFR6_HSF_Pos            (12U)
#define JPEG_CONFR6_HSF_Msk            (0xFUL << JPEG_CONFR6_HSF_Pos)          /*!< 0x0000F000 */
#define JPEG_CONFR6_HSF                JPEG_CONFR6_HSF_Msk                     /*!<Horizontal sampling factor for component 2 */
#define JPEG_CONFR6_HSF_0              (0x1UL << JPEG_CONFR6_HSF_Pos)          /*!< 0x00001000 */
#define JPEG_CONFR6_HSF_1              (0x2UL << JPEG_CONFR6_HSF_Pos)          /*!< 0x00002000 */
#define JPEG_CONFR6_HSF_2              (0x4UL << JPEG_CONFR6_HSF_Pos)          /*!< 0x00004000 */
#define JPEG_CONFR6_HSF_3              (0x8UL << JPEG_CONFR6_HSF_Pos)          /*!< 0x00008000 */
#define JPEG_CONFR7_HD_Pos             (0U)
#define JPEG_CONFR7_HD_Msk             (0x1UL << JPEG_CONFR7_HD_Pos)           /*!< 0x00000001 */
#define JPEG_CONFR7_HD                 JPEG_CONFR7_HD_Msk                      /*!<Selects the Huffman table for encoding the DC coefficients */
#define JPEG_CONFR7_HA_Pos             (1U)
#define JPEG_CONFR7_HA_Msk             (0x1UL << JPEG_CONFR7_HA_Pos)           /*!< 0x00000002 */
#define JPEG_CONFR7_HA                 JPEG_CONFR7_HA_Msk                      /*!<Selects the Huffman table for encoding the AC coefficients */
#define JPEG_CONFR7_QT_Pos             (2U)
#define JPEG_CONFR7_QT_Msk             (0x3UL << JPEG_CONFR7_QT_Pos)           /*!< 0x0000000C */
#define JPEG_CONFR7_QT                 JPEG_CONFR7_QT_Msk                      /*!<Selects quantization table associated with a color component */
#define JPEG_CONFR7_QT_0               (0x1UL << JPEG_CONFR7_QT_Pos)           /*!< 0x00000004 */
#define JPEG_CONFR7_QT_1               (0x2UL << JPEG_CONFR7_QT_Pos)           /*!< 0x00000008 */
#define JPEG_CONFR7_NB_Pos             (4U)
#define JPEG_CONFR7_NB_Msk             (0xFUL << JPEG_CONFR7_NB_Pos)           /*!< 0x000000F0 */
#define JPEG_CONFR7_NB                 JPEG_CONFR7_NB_Msk                      /*!<Number of data units minus 1 that belong to a particular color in the MCU */
#define JPEG_CONFR7_NB_0               (0x1UL << JPEG_CONFR7_NB_Pos)           /*!< 0x00000010 */
#define JPEG_CONFR7_NB_1               (0x2UL << JPEG_CONFR7_NB_Pos)           /*!< 0x00000020 */
#define JPEG_CONFR7_NB_2               (0x4UL << JPEG_CONFR7_NB_Pos)           /*!< 0x00000040 */
#define JPEG_CONFR7_NB_3               (0x8UL << JPEG_CONFR7_NB_Pos)           /*!< 0x00000080 */
#define JPEG_CONFR7_VSF_Pos            (8U)
#define JPEG_CONFR7_VSF_Msk            (0xFUL << JPEG_CONFR7_VSF_Pos)          /*!< 0x00000F00 */
#define JPEG_CONFR7_VSF                JPEG_CONFR7_VSF_Msk                     /*!<Vertical sampling factor for component 2 */
#define JPEG_CONFR7_VSF_0              (0x1UL << JPEG_CONFR7_VSF_Pos)          /*!< 0x00000100 */
#define JPEG_CONFR7_VSF_1              (0x2UL << JPEG_CONFR7_VSF_Pos)          /*!< 0x00000200 */
#define JPEG_CONFR7_VSF_2              (0x4UL << JPEG_CONFR7_VSF_Pos)          /*!< 0x00000400 */
#define JPEG_CONFR7_VSF_3              (0x8UL << JPEG_CONFR7_VSF_Pos)          /*!< 0x00000800 */
#define JPEG_CONFR7_HSF_Pos            (12U)
#define JPEG_CONFR7_HSF_Msk            (0xFUL << JPEG_CONFR7_HSF_Pos)          /*!< 0x0000F000 */
#define JPEG_CONFR7_HSF                JPEG_CONFR7_HSF_Msk                     /*!<Horizontal sampling factor for component 2 */
#define JPEG_CONFR7_HSF_0              (0x1UL << JPEG_CONFR7_HSF_Pos)          /*!< 0x00001000 */
#define JPEG_CONFR7_HSF_1              (0x2UL << JPEG_CONFR7_HSF_Pos)          /*!< 0x00002000 */
#define JPEG_CONFR7_HSF_2              (0x4UL << JPEG_CONFR7_HSF_Pos)          /*!< 0x00004000 */
#define JPEG_CONFR7_HSF_3              (0x8UL << JPEG_CONFR7_HSF_Pos)          /*!< 0x00008000 */
#define JPEG_CR_JCEN_Pos               (0U)
#define JPEG_CR_JCEN_Msk               (0x1UL << JPEG_CR_JCEN_Pos)             /*!< 0x00000001 */
#define JPEG_CR_JCEN                   JPEG_CR_JCEN_Msk                        /*!<Enable the JPEG Codec Core */
#define JPEG_CR_IFTIE_Pos              (1U)
#define JPEG_CR_IFTIE_Msk              (0x1UL << JPEG_CR_IFTIE_Pos)            /*!< 0x00000002 */
#define JPEG_CR_IFTIE                  JPEG_CR_IFTIE_Msk                       /*!<Input FIFO Threshold Interrupt Enable */
#define JPEG_CR_IFNFIE_Pos             (2U)
#define JPEG_CR_IFNFIE_Msk             (0x1UL << JPEG_CR_IFNFIE_Pos)           /*!< 0x00000004 */
#define JPEG_CR_IFNFIE                 JPEG_CR_IFNFIE_Msk                      /*!<Input FIFO Not Full Interrupt Enable */
#define JPEG_CR_OFTIE_Pos              (3U)
#define JPEG_CR_OFTIE_Msk              (0x1UL << JPEG_CR_OFTIE_Pos)            /*!< 0x00000008 */
#define JPEG_CR_OFTIE                  JPEG_CR_OFTIE_Msk                       /*!<Output FIFO Threshold Interrupt Enable */
#define JPEG_CR_OFNEIE_Pos             (4U)
#define JPEG_CR_OFNEIE_Msk             (0x1UL << JPEG_CR_OFNEIE_Pos)           /*!< 0x00000010 */
#define JPEG_CR_OFNEIE                 JPEG_CR_OFNEIE_Msk                      /*!<Output FIFO Not Empty Interrupt Enable */
#define JPEG_CR_EOCIE_Pos              (5U)
#define JPEG_CR_EOCIE_Msk              (0x1UL << JPEG_CR_EOCIE_Pos)            /*!< 0x00000020 */
#define JPEG_CR_EOCIE                  JPEG_CR_EOCIE_Msk                       /*!<End of Conversion Interrupt Enable */
#define JPEG_CR_HPDIE_Pos              (6U)
#define JPEG_CR_HPDIE_Msk              (0x1UL << JPEG_CR_HPDIE_Pos)            /*!< 0x00000040 */
#define JPEG_CR_HPDIE                  JPEG_CR_HPDIE_Msk                       /*!<Header Parsing Done Interrupt Enable */
#define JPEG_CR_IDMAEN_Pos             (11U)
#define JPEG_CR_IDMAEN_Msk             (0x1UL << JPEG_CR_IDMAEN_Pos)           /*!< 0x00000800 */
#define JPEG_CR_IDMAEN                 JPEG_CR_IDMAEN_Msk                      /*!< Input DMA enable */
#define JPEG_CR_ODMAEN_Pos             (12U)
#define JPEG_CR_ODMAEN_Msk             (0x1UL << JPEG_CR_ODMAEN_Pos)           /*!< 0x00001000 */
#define JPEG_CR_ODMAEN                 JPEG_CR_ODMAEN_Msk                      /*!< output DMA enable */
#define JPEG_CR_IFF_Pos                (13U)
#define JPEG_CR_IFF_Msk                (0x1UL << JPEG_CR_IFF_Pos)              /*!< 0x00002000 */
#define JPEG_CR_IFF                    JPEG_CR_IFF_Msk                         /*!<Flush the input FIFO */
#define JPEG_CR_OFF_Pos                (14U)
#define JPEG_CR_OFF_Msk                (0x1UL << JPEG_CR_OFF_Pos)              /*!< 0x00004000 */
#define JPEG_CR_OFF                    JPEG_CR_OFF_Msk                         /*!<Flush the output FIFO */
#define JPEG_SR_IFTF_Pos               (1U)
#define JPEG_SR_IFTF_Msk               (0x1UL << JPEG_SR_IFTF_Pos)             /*!< 0x00000002 */
#define JPEG_SR_IFTF                   JPEG_SR_IFTF_Msk                        /*!<Input FIFO is not full and is below its threshold flag */
#define JPEG_SR_IFNFF_Pos              (2U)
#define JPEG_SR_IFNFF_Msk              (0x1UL << JPEG_SR_IFNFF_Pos)            /*!< 0x00000004 */
#define JPEG_SR_IFNFF                  JPEG_SR_IFNFF_Msk                       /*!<Input FIFO Not Full Flag, a data can be written */
#define JPEG_SR_OFTF_Pos               (3U)
#define JPEG_SR_OFTF_Msk               (0x1UL << JPEG_SR_OFTF_Pos)             /*!< 0x00000008 */
#define JPEG_SR_OFTF                   JPEG_SR_OFTF_Msk                        /*!<Output FIFO is not empty and has reach its threshold */
#define JPEG_SR_OFNEF_Pos              (4U)
#define JPEG_SR_OFNEF_Msk              (0x1UL << JPEG_SR_OFNEF_Pos)            /*!< 0x00000010 */
#define JPEG_SR_OFNEF                  JPEG_SR_OFNEF_Msk                       /*!<Output FIFO is not empty, a data is available */
#define JPEG_SR_EOCF_Pos               (5U)
#define JPEG_SR_EOCF_Msk               (0x1UL << JPEG_SR_EOCF_Pos)             /*!< 0x00000020 */
#define JPEG_SR_EOCF                   JPEG_SR_EOCF_Msk                        /*!<JPEG Codec core has finished the encoding or the decoding process and than last data has been sent to the output FIFO */
#define JPEG_SR_HPDF_Pos               (6U)
#define JPEG_SR_HPDF_Msk               (0x1UL << JPEG_SR_HPDF_Pos)             /*!< 0x00000040 */
#define JPEG_SR_HPDF                   JPEG_SR_HPDF_Msk                        /*!<JPEG Codec has finished the parsing of the headers and the internal registers have been updated */
#define JPEG_SR_COF_Pos                (7U)
#define JPEG_SR_COF_Msk                (0x1UL << JPEG_SR_COF_Pos)              /*!< 0x00000080 */
#define JPEG_SR_COF                    JPEG_SR_COF_Msk                         /*!<JPEG Codec operation on going flag */
#define JPEG_CFR_CEOCF_Pos             (4U)
#define JPEG_CFR_CEOCF_Msk             (0x1UL << JPEG_CFR_CEOCF_Pos)           /*!< 0x00000010 */
#define JPEG_CFR_CEOCF                 JPEG_CFR_CEOCF_Msk                      /*!<Clear End of Conversion Flag */
#define JPEG_CFR_CHPDF_Pos             (5U)
#define JPEG_CFR_CHPDF_Msk             (0x1UL << JPEG_CFR_CHPDF_Pos)           /*!< 0x00000020 */
#define JPEG_CFR_CHPDF                 JPEG_CFR_CHPDF_Msk                      /*!<Clear Header Parsing Done Flag */
#define JPEG_DIR_DATAIN_Pos            (0U)
#define JPEG_DIR_DATAIN_Msk            (0xFFFFFFFFUL << JPEG_DIR_DATAIN_Pos)   /*!< 0xFFFFFFFF */
#define JPEG_DIR_DATAIN                JPEG_DIR_DATAIN_Msk                     /*!<Data Input FIFO */
#define JPEG_DOR_DATAOUT_Pos           (0U)
#define JPEG_DOR_DATAOUT_Msk           (0xFFFFFFFFUL << JPEG_DOR_DATAOUT_Pos)  /*!< 0xFFFFFFFF */
#define JPEG_DOR_DATAOUT               JPEG_DOR_DATAOUT_Msk                    /*!<Data Output FIFO */
