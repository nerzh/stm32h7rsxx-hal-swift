/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Extracted unchanged from CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define PERIPH_BASE                     0x40000000UL  /*!< AHB and APB Peripherals base address */

#define AHB3PERIPH_BASE                 (PERIPH_BASE + 0x08020000UL)

#define HASH_BASE                       (AHB3PERIPH_BASE + 0x0400UL)

#define HASH_DIGEST_BASE                (AHB3PERIPH_BASE + 0x0710UL)

#define DMA_CSR_FIFOL_Pos                   (16U)

#define DMA_CSR_FIFOL_Msk                   (0xFFUL << DMA_CSR_FIFOL_Pos)           /*!< 0x00FF0000 */

#define DMA_CSR_FIFOL                       DMA_CSR_FIFOL_Msk                       /*!< Monitored FIFO level in bytes */

#define DMA_CBR1_BNDT_Pos                   (0U)

#define DMA_CBR1_BNDT_Msk                   (0xFFFFUL << DMA_CBR1_BNDT_Pos)         /*!< 0x0000FFFF */

#define DMA_CBR1_BNDT                       DMA_CBR1_BNDT_Msk                       /*!< Block number of data bytes to transfer from the source */

#define HASH_CR_INIT_Pos                    (2U)

#define HASH_CR_INIT_Msk                    (0x1UL << HASH_CR_INIT_Pos)             /*!< 0x00000004 */

#define HASH_CR_INIT                        HASH_CR_INIT_Msk

#define HASH_CR_DMAE_Pos                    (3U)

#define HASH_CR_DMAE_Msk                    (0x1UL << HASH_CR_DMAE_Pos)             /*!< 0x00000008 */

#define HASH_CR_DMAE                        HASH_CR_DMAE_Msk

#define HASH_CR_DATATYPE_Pos                (4U)

#define HASH_CR_DATATYPE_Msk                (0x3UL << HASH_CR_DATATYPE_Pos)         /*!< 0x00000030 */

#define HASH_CR_DATATYPE                    HASH_CR_DATATYPE_Msk

#define HASH_CR_DATATYPE_0                  (0x1UL << HASH_CR_DATATYPE_Pos)         /*!< 0x00000010 */

#define HASH_CR_DATATYPE_1                  (0x2UL << HASH_CR_DATATYPE_Pos)         /*!< 0x00000020 */

#define HASH_CR_MODE_Pos                    (6U)

#define HASH_CR_MODE_Msk                    (0x1UL << HASH_CR_MODE_Pos)             /*!< 0x00000040 */

#define HASH_CR_MODE                        HASH_CR_MODE_Msk

#define HASH_CR_DINNE_Pos                   (12U)

#define HASH_CR_DINNE_Msk                   (0x1UL << HASH_CR_DINNE_Pos)            /*!< 0x00001000 */

#define HASH_CR_DINNE                       HASH_CR_DINNE_Msk

#define HASH_CR_MDMAT_Pos                   (13U)

#define HASH_CR_MDMAT_Msk                   (0x1UL << HASH_CR_MDMAT_Pos)            /*!< 0x00002000 */

#define HASH_CR_MDMAT                       HASH_CR_MDMAT_Msk

#define HASH_CR_LKEY_Pos                    (16U)

#define HASH_CR_LKEY_Msk                    (0x1UL << HASH_CR_LKEY_Pos)             /*!< 0x00010000 */

#define HASH_CR_LKEY                        HASH_CR_LKEY_Msk

#define HASH_CR_ALGO_Pos                    (17U)

#define HASH_CR_ALGO_Msk                    (0xFUL << HASH_CR_ALGO_Pos)             /*!< 0x001E0000 */

#define HASH_CR_ALGO                        HASH_CR_ALGO_Msk

#define HASH_CR_ALGO_0                      (0x1UL << HASH_CR_ALGO_Pos)             /*!< 0x00020000 */

#define HASH_CR_ALGO_1                      (0x2UL << HASH_CR_ALGO_Pos)             /*!< 0x00040000 */

#define HASH_CR_ALGO_2                      (0x4UL << HASH_CR_ALGO_Pos)             /*!< 0x00080000 */

#define HASH_CR_ALGO_3                      (0x8UL << HASH_CR_ALGO_Pos)             /*!< 0x00100000 */

#define HASH_STR_NBLW_Pos                   (0U)

#define HASH_STR_NBLW_Msk                   (0x1FUL << HASH_STR_NBLW_Pos)           /*!< 0x0000001F */

#define HASH_STR_NBLW                       HASH_STR_NBLW_Msk

#define HASH_STR_DCAL_Pos                   (8U)

#define HASH_STR_DCAL_Msk                   (0x1UL << HASH_STR_DCAL_Pos)            /*!< 0x00000100 */

#define HASH_STR_DCAL                       HASH_STR_DCAL_Msk

#define HASH_IMR_DINIE_Pos                  (0U)

#define HASH_IMR_DINIE_Msk                  (0x1UL << HASH_IMR_DINIE_Pos)           /*!< 0x00000001 */

#define HASH_IMR_DINIE                      HASH_IMR_DINIE_Msk

#define HASH_IMR_DCIE_Pos                   (1U)

#define HASH_IMR_DCIE_Msk                   (0x1UL << HASH_IMR_DCIE_Pos)            /*!< 0x00000002 */

#define HASH_IMR_DCIE                       HASH_IMR_DCIE_Msk

#define HASH_SR_DINIS_Pos                   (0U)

#define HASH_SR_DINIS_Msk                   (0x1UL << HASH_SR_DINIS_Pos)            /*!< 0x00000001 */

#define HASH_SR_DINIS                       HASH_SR_DINIS_Msk

#define HASH_SR_DCIS_Pos                    (1U)

#define HASH_SR_DCIS_Msk                    (0x1UL << HASH_SR_DCIS_Pos)             /*!< 0x00000002 */

#define HASH_SR_DCIS                        HASH_SR_DCIS_Msk

#define HASH_SR_DMAS_Pos                    (2U)

#define HASH_SR_DMAS_Msk                    (0x1UL << HASH_SR_DMAS_Pos)             /*!< 0x00000004 */

#define HASH_SR_DMAS                        HASH_SR_DMAS_Msk

#define HASH_SR_BUSY_Pos                    (3U)

#define HASH_SR_BUSY_Msk                    (0x1UL << HASH_SR_BUSY_Pos)             /*!< 0x00000008 */

#define HASH_SR_BUSY                        HASH_SR_BUSY_Msk

#define SET_BIT(REG, BIT)     ((REG) |= (BIT))

#define CLEAR_BIT(REG, BIT)   ((REG) &= ~(BIT))

#define READ_BIT(REG, BIT)    ((REG) & (BIT))

#define WRITE_REG(REG, VAL)   ((REG) = (VAL))

#define READ_REG(REG)         ((REG))

#define MODIFY_REG(REG, CLEARMASK, SETMASK)  WRITE_REG((REG), (((READ_REG(REG)) & (~(CLEARMASK))) | (SETMASK)))
