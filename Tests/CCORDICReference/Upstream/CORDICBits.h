/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Extracted unchanged from CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define CORDIC_CSR_FUNC_Pos                 (0U)

#define CORDIC_CSR_FUNC_Msk                 (0xFUL << CORDIC_CSR_FUNC_Pos)          /*!< 0x0000000F */

#define CORDIC_CSR_FUNC                     CORDIC_CSR_FUNC_Msk                     /*!< Function */

#define CORDIC_CSR_FUNC_0                   (0x1UL << CORDIC_CSR_FUNC_Pos)          /*!< 0x00000001 */

#define CORDIC_CSR_FUNC_1                   (0x2UL << CORDIC_CSR_FUNC_Pos)          /*!< 0x00000002 */

#define CORDIC_CSR_FUNC_2                   (0x4UL << CORDIC_CSR_FUNC_Pos)          /*!< 0x00000004 */

#define CORDIC_CSR_FUNC_3                   (0x8UL << CORDIC_CSR_FUNC_Pos)          /*!< 0x00000008 */

#define CORDIC_CSR_PRECISION_Pos            (4U)

#define CORDIC_CSR_PRECISION_Msk            (0xFUL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x000000F0 */

#define CORDIC_CSR_PRECISION                CORDIC_CSR_PRECISION_Msk                /*!< Precision */

#define CORDIC_CSR_PRECISION_0              (0x1UL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x00000010 */

#define CORDIC_CSR_PRECISION_1              (0x2UL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x00000020 */

#define CORDIC_CSR_PRECISION_2              (0x4UL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x00000040 */

#define CORDIC_CSR_PRECISION_3              (0x8UL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x00000080 */

#define CORDIC_CSR_SCALE_Pos                (8U)

#define CORDIC_CSR_SCALE_Msk                (0x7UL << CORDIC_CSR_SCALE_Pos)         /*!< 0x00000700 */

#define CORDIC_CSR_SCALE                    CORDIC_CSR_SCALE_Msk                    /*!< Scaling factor */

#define CORDIC_CSR_SCALE_0                  (0x1UL << CORDIC_CSR_SCALE_Pos)         /*!< 0x00000100 */

#define CORDIC_CSR_SCALE_1                  (0x2UL << CORDIC_CSR_SCALE_Pos)         /*!< 0x00000200 */

#define CORDIC_CSR_SCALE_2                  (0x4UL << CORDIC_CSR_SCALE_Pos)         /*!< 0x00000400 */

#define CORDIC_CSR_IEN_Pos                  (16U)

#define CORDIC_CSR_IEN_Msk                  (0x1UL << CORDIC_CSR_IEN_Pos)           /*!< 0x00010000 */

#define CORDIC_CSR_IEN                      CORDIC_CSR_IEN_Msk                      /*!< Interrupt Enable */

#define CORDIC_CSR_DMAREN_Pos               (17U)

#define CORDIC_CSR_DMAREN_Msk               (0x1UL << CORDIC_CSR_DMAREN_Pos)        /*!< 0x00020000 */

#define CORDIC_CSR_DMAREN                   CORDIC_CSR_DMAREN_Msk                   /*!< DMA Read channel Enable */

#define CORDIC_CSR_DMAWEN_Pos               (18U)

#define CORDIC_CSR_DMAWEN_Msk               (0x1UL << CORDIC_CSR_DMAWEN_Pos)        /*!< 0x00040000 */

#define CORDIC_CSR_DMAWEN                   CORDIC_CSR_DMAWEN_Msk                   /*!< DMA Write channel Enable */

#define CORDIC_CSR_NRES_Pos                 (19U)

#define CORDIC_CSR_NRES_Msk                 (0x1UL << CORDIC_CSR_NRES_Pos)          /*!< 0x00080000 */

#define CORDIC_CSR_NRES                     CORDIC_CSR_NRES_Msk                     /*!< Number of results in WDATA register */

#define CORDIC_CSR_NARGS_Pos                (20U)

#define CORDIC_CSR_NARGS_Msk                (0x1UL << CORDIC_CSR_NARGS_Pos)         /*!< 0x00100000 */

#define CORDIC_CSR_NARGS                    CORDIC_CSR_NARGS_Msk                    /*!< Number of arguments in RDATA register */

#define CORDIC_CSR_RESSIZE_Pos              (21U)

#define CORDIC_CSR_RESSIZE_Msk              (0x1UL << CORDIC_CSR_RESSIZE_Pos)       /*!< 0x00200000 */

#define CORDIC_CSR_RESSIZE                  CORDIC_CSR_RESSIZE_Msk                  /*!< Width of output data */

#define CORDIC_CSR_ARGSIZE_Pos              (22U)

#define CORDIC_CSR_ARGSIZE_Msk              (0x1UL << CORDIC_CSR_ARGSIZE_Pos)       /*!< 0x00400000 */

#define CORDIC_CSR_ARGSIZE                  CORDIC_CSR_ARGSIZE_Msk                  /*!< Width of input data */

#define CORDIC_CSR_RRDY_Pos                 (31U)

#define CORDIC_CSR_RRDY_Msk                 (0x1UL << CORDIC_CSR_RRDY_Pos)          /*!< 0x80000000 */

#define CORDIC_CSR_RRDY                     CORDIC_CSR_RRDY_Msk                     /*!< Result Ready Flag */

#define IS_CORDIC_ALL_INSTANCE(INSTANCE) ((INSTANCE) == CORDIC)
