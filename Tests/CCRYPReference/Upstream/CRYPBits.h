// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

#define CRYP_BASE                       (AHB3PERIPH_BASE + 0x0800UL)
#define SAES_BASE                       (AHB3PERIPH_BASE + 0x1000UL)
#define CRYP_CR_ALGODIR_Pos              (2U)
#define CRYP_CR_ALGODIR_Msk              (0x1UL << CRYP_CR_ALGODIR_Pos)           /*!< 0x00000004 */
#define CRYP_CR_ALGODIR                  CRYP_CR_ALGODIR_Msk                      /*!< Algorithm direction (Encrypt/Decrypt) */
#define CRYP_CR_ALGOMODE_Pos             (3U)
#define CRYP_CR_ALGOMODE_Msk             (0x10007UL << CRYP_CR_ALGOMODE_Pos)      /*!< 0x00080038 */
#define CRYP_CR_ALGOMODE                 CRYP_CR_ALGOMODE_Msk                     /*!< Algorithm mode */
#define CRYP_CR_ALGOMODE_0               (0x00001UL << CRYP_CR_ALGOMODE_Pos)      /*!< 0x00000008 */
#define CRYP_CR_ALGOMODE_1               (0x00002UL << CRYP_CR_ALGOMODE_Pos)      /*!< 0x00000010 */
#define CRYP_CR_ALGOMODE_2               (0x00004UL << CRYP_CR_ALGOMODE_Pos)      /*!< 0x00000020 */
#define CRYP_CR_ALGOMODE_3               (0x10000UL << CRYP_CR_ALGOMODE_Pos)      /*!< 0x00080000 */
#define CRYP_CR_ALGOMODE_AES_ECB_Pos     (5U)
#define CRYP_CR_ALGOMODE_AES_ECB_Msk     (0x1UL << CRYP_CR_ALGOMODE_AES_ECB_Pos)  /*!< 0x00000020 */
#define CRYP_CR_ALGOMODE_AES_ECB         CRYP_CR_ALGOMODE_AES_ECB_Msk
#define CRYP_CR_ALGOMODE_AES_CBC_Pos     (3U)
#define CRYP_CR_ALGOMODE_AES_CBC_Msk     (0x5UL << CRYP_CR_ALGOMODE_AES_CBC_Pos)  /*!< 0x00000028 */
#define CRYP_CR_ALGOMODE_AES_CBC         CRYP_CR_ALGOMODE_AES_CBC_Msk
#define CRYP_CR_ALGOMODE_AES_CTR_Pos     (4U)
#define CRYP_CR_ALGOMODE_AES_CTR_Msk     (0x3UL << CRYP_CR_ALGOMODE_AES_CTR_Pos)  /*!< 0x00000030 */
#define CRYP_CR_ALGOMODE_AES_CTR         CRYP_CR_ALGOMODE_AES_CTR_Msk
#define CRYP_CR_ALGOMODE_AES_KEY_Pos     (3U)
#define CRYP_CR_ALGOMODE_AES_KEY_Msk     (0x7UL << CRYP_CR_ALGOMODE_AES_KEY_Pos)  /*!< 0x00000038 */
#define CRYP_CR_ALGOMODE_AES_KEY         CRYP_CR_ALGOMODE_AES_KEY_Msk
#define CRYP_CR_ALGOMODE_AES_GCM_Pos     (19U)
#define CRYP_CR_ALGOMODE_AES_GCM_Msk     (0x1UL << CRYP_CR_ALGOMODE_AES_GCM_Pos)  /*!< 0x00080000 */
#define CRYP_CR_ALGOMODE_AES_GCM         CRYP_CR_ALGOMODE_AES_GCM_Msk
#define CRYP_CR_ALGOMODE_AES_CCM_Pos     (3U)
#define CRYP_CR_ALGOMODE_AES_CCM_Msk     (0x10001UL << CRYP_CR_ALGOMODE_AES_CCM_Pos) /*!< 0x00080008 */
#define CRYP_CR_ALGOMODE_AES_CCM         CRYP_CR_ALGOMODE_AES_CCM_Msk
#define CRYP_CR_DATATYPE_Pos             (6U)
#define CRYP_CR_DATATYPE_Msk             (0x3UL << CRYP_CR_DATATYPE_Pos)          /*!< 0x000000C0 */
#define CRYP_CR_DATATYPE                 CRYP_CR_DATATYPE_Msk                     /*!< Data Type selection */
#define CRYP_CR_DATATYPE_0               (0x1UL << CRYP_CR_DATATYPE_Pos)          /*!< 0x00000040 */
#define CRYP_CR_DATATYPE_1               (0x2UL << CRYP_CR_DATATYPE_Pos)          /*!< 0x00000080 */
#define CRYP_CR_KEYSIZE_Pos              (8U)
#define CRYP_CR_KEYSIZE_Msk              (0x3UL << CRYP_CR_KEYSIZE_Pos)           /*!< 0x00000300 */
#define CRYP_CR_KEYSIZE                  CRYP_CR_KEYSIZE_Msk                      /*!< Key Size selection */
#define CRYP_CR_KEYSIZE_0                (0x1UL << CRYP_CR_KEYSIZE_Pos)           /*!< 0x00000100 */
#define CRYP_CR_KEYSIZE_1                (0x2UL << CRYP_CR_KEYSIZE_Pos)           /*!< 0x00000200 */
#define CRYP_CR_FFLUSH_Pos               (14U)
#define CRYP_CR_FFLUSH_Msk               (0x1UL << CRYP_CR_FFLUSH_Pos)            /*!< 0x00004000 */
#define CRYP_CR_FFLUSH                   CRYP_CR_FFLUSH_Msk                       /*!< CRYP FIFO Flush */
#define CRYP_CR_CRYPEN_Pos               (15U)
#define CRYP_CR_CRYPEN_Msk               (0x1UL << CRYP_CR_CRYPEN_Pos)            /*!< 0x00008000 */
#define CRYP_CR_CRYPEN                   CRYP_CR_CRYPEN_Msk                       /*!< CRYP processor enable */
#define CRYP_CR_GCM_CCMPH_Pos            (16U)
#define CRYP_CR_GCM_CCMPH_Msk            (0x3UL << CRYP_CR_GCM_CCMPH_Pos)         /*!< 0x00030000 */
#define CRYP_CR_GCM_CCMPH                CRYP_CR_GCM_CCMPH_Msk                    /*!< GCM or CCM Phase selection */
#define CRYP_CR_GCM_CCMPH_0              (0x1UL << CRYP_CR_GCM_CCMPH_Pos)         /*!< 0x00010000 */
#define CRYP_CR_GCM_CCMPH_1              (0x2UL << CRYP_CR_GCM_CCMPH_Pos)         /*!< 0x00020000 */
#define CRYP_CR_NPBLB_Pos                (20U)
#define CRYP_CR_NPBLB_Msk                (0xFUL << CRYP_CR_NPBLB_Pos)             /*!< 0x00F00000 */
#define CRYP_CR_NPBLB                    CRYP_CR_NPBLB_Msk                        /*!< Number of Padding Bytes in Last Block of payload */
#define CRYP_CR_KMOD_Pos                (24U)
#define CRYP_CR_KMOD_Msk                (0x3UL << CRYP_CR_KMOD_Pos)               /*!< 0x03000000 */
#define CRYP_CR_KMOD                    CRYP_CR_KMOD_Msk                          /*!< Key mode selection */
#define CRYP_CR_KMOD_0                  (0x1UL << CRYP_CR_KMOD_Pos)               /*!< 0x01000000 */
#define CRYP_CR_KMOD_1                  (0x2UL << CRYP_CR_KMOD_Pos)               /*!< 0x02000000 */
#define CRYP_CR_IPRST_Pos               (31U)
#define CRYP_CR_IPRST_Msk               (0x1UL << CRYP_CR_IPRST_Pos)              /*!< 0x80000000 */
#define CRYP_CR_IPRST                   CRYP_CR_IPRST_Msk                         /*!< CRYP peripheral software reset */
#define CRYP_SR_IFEM_Pos                 (0U)
#define CRYP_SR_IFEM_Msk                 (0x1UL << CRYP_SR_IFEM_Pos)              /*!< 0x00000001 */
#define CRYP_SR_IFEM                     CRYP_SR_IFEM_Msk                         /*!< Input FIFO empty flag */
#define CRYP_SR_IFNF_Pos                 (1U)
#define CRYP_SR_IFNF_Msk                 (0x1UL << CRYP_SR_IFNF_Pos)              /*!< 0x00000002 */
#define CRYP_SR_IFNF                     CRYP_SR_IFNF_Msk                         /*!< Input FIFO not full flag */
#define CRYP_SR_OFNE_Pos                 (2U)
#define CRYP_SR_OFNE_Msk                 (0x1UL << CRYP_SR_OFNE_Pos)              /*!< 0x00000004 */
#define CRYP_SR_OFNE                     CRYP_SR_OFNE_Msk                         /*!< Output FIFO not empty flag */
#define CRYP_SR_OFFU_Pos                 (3U)
#define CRYP_SR_OFFU_Msk                 (0x1UL << CRYP_SR_OFFU_Pos)              /*!< 0x00000008 */
#define CRYP_SR_OFFU                     CRYP_SR_OFFU_Msk                         /*!< Output FIFO full flag */
#define CRYP_SR_BUSY_Pos                 (4U)
#define CRYP_SR_BUSY_Msk                 (0x1UL << CRYP_SR_BUSY_Pos)              /*!< 0x00000010 */
#define CRYP_SR_BUSY                     CRYP_SR_BUSY_Msk                         /*!< Busy bit */
#define CRYP_SR_KERF_Pos                 (6U)
#define CRYP_SR_KERF_Msk                 (0x1UL << CRYP_SR_KERF_Pos)              /*!< 0x00000040 */
#define CRYP_SR_KERF                     CRYP_SR_KERF_Msk                         /*!< Key error flag */
#define CRYP_SR_KEYVALID_Pos             (7U)
#define CRYP_SR_KEYVALID_Msk             (0x1UL << CRYP_SR_KEYVALID_Pos)          /*!< 0x00000080 */
#define CRYP_SR_KEYVALID                 CRYP_SR_KEYVALID_Msk                     /*!< Key valid flag */
#define CRYP_DIN_DATAIN_Pos              (0U)
#define CRYP_DIN_DATAIN_Msk              (0xFFFFFFFFUL << CRYP_DIN_DATAIN_Pos)    /*!< 0xFFFFFFFF */
#define CRYP_DIN_DATAIN                  CRYP_DIN_DATAIN_Msk                      /*!< CRYP Data Input */
#define CRYP_DOUT_DATAOUT_Pos            (0U)
#define CRYP_DOUT_DATAOUT_Msk            (0xFFFFFFFFUL << CRYP_DOUT_DATAOUT_Pos)  /*!< 0xFFFFFFFF */
#define CRYP_DOUT_DATAOUT                CRYP_DOUT_DATAOUT_Msk                    /*!< CRYP Data Output */
#define CRYP_DMACR_DIEN_Pos              (0U)
#define CRYP_DMACR_DIEN_Msk              (0x1UL << CRYP_DMACR_DIEN_Pos)           /*!< 0x00000001 */
#define CRYP_DMACR_DIEN                  CRYP_DMACR_DIEN_Msk                      /*!< DMA Input Enable */
#define CRYP_DMACR_DOEN_Pos              (1U)
#define CRYP_DMACR_DOEN_Msk              (0x1UL << CRYP_DMACR_DOEN_Pos)           /*!< 0x00000002 */
#define CRYP_DMACR_DOEN                  CRYP_DMACR_DOEN_Msk                      /*!< DMA Output Enable */
#define CRYP_IMSCR_INIM_Pos              (0U)
#define CRYP_IMSCR_INIM_Msk              (0x1UL << CRYP_IMSCR_INIM_Pos)           /*!< 0x00000001 */
#define CRYP_IMSCR_INIM                  CRYP_IMSCR_INIM_Msk                      /*!< Input FIFO service interrupt mask */
#define CRYP_IMSCR_OUTIM_Pos             (1U)
#define CRYP_IMSCR_OUTIM_Msk             (0x1UL << CRYP_IMSCR_OUTIM_Pos)          /*!< 0x00000002 */
#define CRYP_IMSCR_OUTIM                 CRYP_IMSCR_OUTIM_Msk                     /*!< Output FIFO service interrupt mask */
#define CRYP_RISR_INRIS_Pos              (0U)
#define CRYP_RISR_INRIS_Msk              (0x1UL << CRYP_RISR_INRIS_Pos)           /*!< 0x00000001 */
#define CRYP_RISR_INRIS                  CRYP_RISR_INRIS_Msk                      /*!< Input FIFO service raw interrupt status */
#define CRYP_RISR_OUTRIS_Pos             (1U)
#define CRYP_RISR_OUTRIS_Msk             (0x1UL << CRYP_RISR_OUTRIS_Pos)          /*!< 0x00000002 */
#define CRYP_RISR_OUTRIS                 CRYP_RISR_OUTRIS_Msk                     /*!< Output FIFO service raw interrupt mask */
#define CRYP_MISR_INMIS_Pos              (0U)
#define CRYP_MISR_INMIS_Msk              (0x1UL << CRYP_MISR_INMIS_Pos)           /*!< 0x00000001 */
#define CRYP_MISR_INMIS                  CRYP_MISR_INMIS_Msk                      /*!< Input FIFO service masked interrupt status */
#define CRYP_MISR_OUTMIS_Pos             (1U)
#define CRYP_MISR_OUTMIS_Msk             (0x1UL << CRYP_MISR_OUTMIS_Pos)          /*!< 0x00000002 */
#define CRYP_MISR_OUTMIS                 CRYP_MISR_OUTMIS_Msk                     /*!< Output FIFO service masked interrupt status */
#define CRYP_K0LR_K_Pos                  (0U)
#define CRYP_K0LR_K_Msk                  (0xFFFFFFFFUL << CRYP_K0LR_K_Pos)        /*!< 0xFFFFFFFF */
#define CRYP_K0LR_K                      CRYP_K0LR_K_Msk                          /*!< AES key bit x (x= 224 to 255) */
#define CRYP_K0RR_K_Pos                  (0U)
#define CRYP_K0RR_K_Msk                  (0xFFFFFFFFUL << CRYP_K0RR_K_Pos)        /*!< 0xFFFFFFFF */
#define CRYP_K0RR_K                      CRYP_K0RR_K_Msk                          /*!< AES key bit x (x= 192 to 223) */
#define CRYP_K1LR_Pos                    (0U)
#define CRYP_K1LR_Msk                    (0xFFFFFFFFUL << CRYP_K1LR_Pos)          /*!< 0xFFFFFFFF */
#define CRYP_K1LR                        CRYP_K1LR_Msk                            /*!< AES key bit x (x= 160 to 291) */
#define CRYP_K1RR_Pos                    (0U)
#define CRYP_K1RR_Msk                    (0xFFFFFFFFUL << CRYP_K1RR_Pos)          /*!< 0xFFFFFFFF */
#define CRYP_K1RR                        CRYP_K1RR_Msk                            /*!< AES key bit x (x= 128 to 159) */
#define CRYP_K2LR_K_Pos                  (0U)
#define CRYP_K2LR_K_Msk                  (0xFFFFFFFFUL << CRYP_K2LR_K_Pos)        /*!< 0xFFFFFFFF */
#define CRYP_K2LR_K                      CRYP_K2LR_K_Msk                          /*!< AES key bit x (x= 96 to 127) */
#define CRYP_K2RR_K_Pos                  (0U)
#define CRYP_K2RR_K_Msk                  (0xFFFFFFFFUL << CRYP_K2RR_K_Pos)        /*!< 0xFFFFFFFF */
#define CRYP_K2RR_K                      CRYP_K2RR_K_Msk                          /*!< AES key bit x (x= 64 to 95) */
#define CRYP_K3LR_K_Pos                  (0U)
#define CRYP_K3LR_K_Msk                  (0xFFFFFFFFUL << CRYP_K3LR_K_Pos)        /*!< 0xFFFFFFFF */
#define CRYP_K3LR_K                      CRYP_K3LR_K_Msk                          /*!< AES key bit x (x= 32 to 63) */
#define CRYP_K3RR_K_Pos                  (0U)
#define CRYP_K3RR_K_Msk                  (0xFFFFFFFFUL << CRYP_K3RR_K_Pos)        /*!< 0xFFFFFFFF */
#define CRYP_K3RR_K                      CRYP_K3RR_K_Msk                          /*!< AES key bit x (x= 0 to 31) */
#define CRYP_IV0LR_IV_Pos                (0U)
#define CRYP_IV0LR_IV_Msk                (0xFFFFFFFFUL << CRYP_IV0LR_IV_Pos)      /*!< 0xFFFFFFFF */
#define CRYP_IV0LR_IV                    CRYP_IV0LR_IV_Msk                        /*!< Initialization vector bit x (x= 0 to 31) */
#define CRYP_IV0RR_IV_Pos                (0U)
#define CRYP_IV0RR_IV_Msk                (0xFFFFFFFFUL << CRYP_IV0RR_IV_Pos)      /*!< 0xFFFFFFFF */
#define CRYP_IV0RR_IV                    CRYP_IV0RR_IV_Msk                        /*!< Initialization vector bit x (x= 32 to 63) */
#define CRYP_IV1LR_IV_Pos                (0U)
#define CRYP_IV1LR_IV_Msk                (0xFFFFFFFFUL << CRYP_IV1LR_IV_Pos)      /*!< 0xFFFFFFFF */
#define CRYP_IV1LR_IV                    CRYP_IV1LR_IV_Msk                        /*!< Initialization vector bit x (x= 64 to 95) */
#define CRYP_IV1RR_IV_Pos                (0U)
#define CRYP_IV1RR_IV_Msk                (0xFFFFFFFFUL << CRYP_IV1RR_IV_Pos)      /*!< 0xFFFFFFFF */
#define CRYP_IV1RR_IV                    CRYP_IV1RR_IV_Msk                        /*!< Initialization vector bit x (x= 96 to 127) */
#define CRYP_CSGCMCCM0R_CSGCMCCM0_Pos          (0U)
#define CRYP_CSGCMCCM0R_CSGCMCCM0_Msk          (0xFFFFFFFFUL << CRYP_CSGCMCCM0R_CSGCMCCM0_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCMCCM0R_CSGCMCCM0              CRYP_CSGCMCCM0R_CSGCMCCM0_Msk                   /*!< CRYP internal state registers for GCM, GMAC and CCM modes */
#define CRYP_CSGCMCCM1R_CSGCMCCM1_Pos          (0U)
#define CRYP_CSGCMCCM1R_CSGCMCCM1_Msk          (0xFFFFFFFFUL << CRYP_CSGCMCCM1R_CSGCMCCM1_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCMCCM1R_CSGCMCCM1              CRYP_CSGCMCCM1R_CSGCMCCM1_Msk                   /*!< CRYP internal state registers for GCM, GMAC and CCM modes */
#define CRYP_CSGCMCCM2R_CSGCMCCM2_Pos          (0U)
#define CRYP_CSGCMCCM2R_CSGCMCCM2_Msk          (0xFFFFFFFFUL << CRYP_CSGCMCCM2R_CSGCMCCM2_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCMCCM2R_CSGCMCCM2              CRYP_CSGCMCCM2R_CSGCMCCM2_Msk                   /*!< CRYP internal state registers for GCM, GMAC and CCM modes */
#define CRYP_CSGCMCCM3R_CSGCMCCM3_Pos          (0U)
#define CRYP_CSGCMCCM3R_CSGCMCCM3_Msk          (0xFFFFFFFFUL << CRYP_CSGCMCCM3R_CSGCMCCM3_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCMCCM3R_CSGCMCCM3              CRYP_CSGCMCCM3R_CSGCMCCM3_Msk                   /*!< CRYP internal state registers for GCM, GMAC and CCM modes */
#define CRYP_CSGCMCCM4R_CSGCMCCM4_Pos          (0U)
#define CRYP_CSGCMCCM4R_CSGCMCCM4_Msk          (0xFFFFFFFFUL << CRYP_CSGCMCCM4R_CSGCMCCM4_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCMCCM4R_CSGCMCCM4              CRYP_CSGCMCCM4R_CSGCMCCM4_Msk                   /*!< CRYP internal state registers for GCM, GMAC and CCM modes */
#define CRYP_CSGCMCCM5R_CSGCMCCM5_Pos          (0U)
#define CRYP_CSGCMCCM5R_CSGCMCCM5_Msk          (0xFFFFFFFFUL << CRYP_CSGCMCCM5R_CSGCMCCM5_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCMCCM5R_CSGCMCCM5              CRYP_CSGCMCCM5R_CSGCMCCM5_Msk                   /*!< CRYP internal state registers for GCM, GMAC and CCM modes */
#define CRYP_CSGCMCCM6R_CSGCMCCM6_Pos          (0U)
#define CRYP_CSGCMCCM6R_CSGCMCCM6_Msk          (0xFFFFFFFFUL << CRYP_CSGCMCCM6R_CSGCMCCM6_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCMCCM6R_CSGCMCCM6              CRYP_CSGCMCCM6R_CSGCMCCM6_Msk                   /*!< CRYP internal state registers for GCM, GMAC and CCM modes */
#define CRYP_CSGCMCCM7R_CSGCMCCM7_Pos          (0U)
#define CRYP_CSGCMCCM7R_CSGCMCCM7_Msk          (0xFFFFFFFFUL << CRYP_CSGCMCCM7R_CSGCMCCM7_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCMCCM7R_CSGCMCCM7              CRYP_CSGCMCCM7R_CSGCMCCM7_Msk                   /*!< CRYP internal state registers for GCM, GMAC and CCM modes */
#define CRYP_CSGCM0R_CSGCM0_Pos          (0U)
#define CRYP_CSGCM0R_CSGCM0_Msk          (0xFFFFFFFFUL << CRYP_CSGCM0R_CSGCM0_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCM0R_CSGCM0              CRYP_CSGCM0R_CSGCM0_Msk                   /*!< CRYP internal state registers for GCM and GMAC modes */
#define CRYP_CSGCM1R_CSGCM1_Pos          (0U)
#define CRYP_CSGCM1R_CSGCM1_Msk          (0xFFFFFFFFUL << CRYP_CSGCM1R_CSGCM1_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCM1R_CSGCM1              CRYP_CSGCM1R_CSGCM1_Msk                   /*!< CRYP internal state registers for GCM and GMAC modes */
#define CRYP_CSGCM2R_CSGCM2_Pos          (0U)
#define CRYP_CSGCM2R_CSGCM2_Msk          (0xFFFFFFFFUL << CRYP_CSGCM2R_CSGCM2_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCM2R_CSGCM2              CRYP_CSGCM2R_CSGCM2_Msk                   /*!< CRYP internal state registers for GCM and GMAC modes */
#define CRYP_CSGCM3R_CSGCM3_Pos          (0U)
#define CRYP_CSGCM3R_CSGCM3_Msk          (0xFFFFFFFFUL << CRYP_CSGCM3R_CSGCM3_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCM3R_CSGCM3              CRYP_CSGCM3R_CSGCM3_Msk                   /*!< CRYP internal state registers for GCM and GMAC modes */
#define CRYP_CSGCM4R_CSGCM4_Pos          (0U)
#define CRYP_CSGCM4R_CSGCM4_Msk          (0xFFFFFFFFUL << CRYP_CSGCM4R_CSGCM4_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCM4R_CSGCM4              CRYP_CSGCM4R_CSGCM4_Msk                   /*!< CRYP internal state registers for GCM and GMAC modes */
#define CRYP_CSGCM5R_CSGCM5_Pos          (0U)
#define CRYP_CSGCM5R_CSGCM5_Msk          (0xFFFFFFFFUL << CRYP_CSGCM5R_CSGCM5_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCM5R_CSGCM5              CRYP_CSGCM5R_CSGCM5_Msk                   /*!< CRYP internal state registers for GCM and GMAC modes */
#define CRYP_CSGCM6R_CSGCM6_Pos          (0U)
#define CRYP_CSGCM6R_CSGCM6_Msk          (0xFFFFFFFFUL << CRYP_CSGCM6R_CSGCM6_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCM6R_CSGCM6              CRYP_CSGCM6R_CSGCM6_Msk                   /*!< CRYP internal state registers for GCM and GMAC modes */
#define CRYP_CSGCM7R_CSGCM7_Pos          (0U)
#define CRYP_CSGCM7R_CSGCM7_Msk          (0xFFFFFFFFUL << CRYP_CSGCM7R_CSGCM7_Pos) /*!< 0xFFFFFFFF */
#define CRYP_CSGCM7R_CSGCM7              CRYP_CSGCM7R_CSGCM7_Msk                   /*!< CRYP internal state registers for GCM and GMAC modes */
#define SAES_CR_EN_Pos                       (0U)
#define SAES_CR_EN_Msk                       (0x1UL << SAES_CR_EN_Pos)                /*!< 0x00000001 */
#define SAES_CR_EN                           SAES_CR_EN_Msk                           /*!< SAES Enable */
#define SAES_CR_DATATYPE_Pos                 (1U)
#define SAES_CR_DATATYPE_Msk                 (0x3UL << SAES_CR_DATATYPE_Pos)          /*!< 0x00000006 */
#define SAES_CR_DATATYPE                     SAES_CR_DATATYPE_Msk                     /*!< Data type selection */
#define SAES_CR_DATATYPE_0                   (0x1UL << SAES_CR_DATATYPE_Pos)          /*!< 0x00000002 */
#define SAES_CR_DATATYPE_1                   (0x2UL << SAES_CR_DATATYPE_Pos)          /*!< 0x00000004 */
#define SAES_CR_MODE_Pos                     (3U)
#define SAES_CR_MODE_Msk                     (0x3UL << SAES_CR_MODE_Pos)              /*!< 0x00000018 */
#define SAES_CR_MODE                         SAES_CR_MODE_Msk                         /*!< SAES Mode Of Operation */
#define SAES_CR_MODE_0                       (0x1UL << SAES_CR_MODE_Pos)              /*!< 0x00000008 */
#define SAES_CR_MODE_1                       (0x2UL << SAES_CR_MODE_Pos)              /*!< 0x00000010 */
#define SAES_CR_CHMOD_Pos                    (5U)
#define SAES_CR_CHMOD_Msk                    (0x803UL << SAES_CR_CHMOD_Pos)           /*!< 0x00010060 */
#define SAES_CR_CHMOD                        SAES_CR_CHMOD_Msk                        /*!< SAES Chaining Mode */
#define SAES_CR_CHMOD_0                      (0x001UL << SAES_CR_CHMOD_Pos)           /*!< 0x00000020 */
#define SAES_CR_CHMOD_1                      (0x002UL << SAES_CR_CHMOD_Pos)           /*!< 0x00000040 */
#define SAES_CR_CHMOD_2                      (0x800UL << SAES_CR_CHMOD_Pos)           /*!< 0x00010000 */
#define SAES_CR_DMAINEN_Pos                  (11U)
#define SAES_CR_DMAINEN_Msk                  (0x1UL << SAES_CR_DMAINEN_Pos)           /*!< 0x00000800 */
#define SAES_CR_DMAINEN                      SAES_CR_DMAINEN_Msk                      /*!< Enable data input phase DMA management  */
#define SAES_CR_DMAOUTEN_Pos                 (12U)
#define SAES_CR_DMAOUTEN_Msk                 (0x1UL << SAES_CR_DMAOUTEN_Pos)          /*!< 0x00001000 */
#define SAES_CR_DMAOUTEN                     SAES_CR_DMAOUTEN_Msk                     /*!< Enable data output phase DMA management */
#define SAES_CR_GCMPH_Pos                    (13U)
#define SAES_CR_GCMPH_Msk                    (0x3UL << SAES_CR_GCMPH_Pos)             /*!< 0x00006000 */
#define SAES_CR_GCMPH                        SAES_CR_GCMPH_Msk                        /*!< GCM Phase */
#define SAES_CR_GCMPH_0                      (0x1UL << SAES_CR_GCMPH_Pos)             /*!< 0x00002000 */
#define SAES_CR_GCMPH_1                      (0x2UL << SAES_CR_GCMPH_Pos)             /*!< 0x00004000 */
#define SAES_CR_KEYSIZE_Pos                  (18U)
#define SAES_CR_KEYSIZE_Msk                  (0x1UL << SAES_CR_KEYSIZE_Pos)           /*!< 0x00040000 */
#define SAES_CR_KEYSIZE                      SAES_CR_KEYSIZE_Msk                      /*!< Key size selection */
#define SAES_CR_NPBLB_Pos                    (20U)
#define SAES_CR_NPBLB_Msk                    (0xFUL << SAES_CR_NPBLB_Pos)             /*!< 0x00F00000 */
#define SAES_CR_NPBLB                        SAES_CR_NPBLB_Msk                        /*!< Number of padding bytes in payload last block */
#define SAES_CR_NPBLB_0                      (0x1UL << SAES_CR_NPBLB_Pos)             /*!< 0x00100000 */
#define SAES_CR_NPBLB_1                      (0x2UL << SAES_CR_NPBLB_Pos)             /*!< 0x00200000 */
#define SAES_CR_NPBLB_2                      (0x4UL << SAES_CR_NPBLB_Pos)             /*!< 0x00400000 */
#define SAES_CR_NPBLB_3                      (0x8UL << SAES_CR_NPBLB_Pos)             /*!< 0x00800000 */
#define SAES_CR_KMOD_Pos                     (24U)
#define SAES_CR_KMOD_Msk                     (0x3UL << SAES_CR_KMOD_Pos)              /*!< 0x00000006 */
#define SAES_CR_KMOD                         SAES_CR_KMOD_Msk                         /*!< Key mode selection */
#define SAES_CR_KMOD_0                       (0x1UL << SAES_CR_KMOD_Pos)              /*!< 0x01000000 */
#define SAES_CR_KMOD_1                       (0x2UL << SAES_CR_KMOD_Pos)              /*!< 0x02000000 */
#define SAES_CR_KSHAREID_Pos                 (26U)
#define SAES_CR_KSHAREID_Msk                (0x3UL << SAES_CR_KSHAREID_Pos)           /*!< 0x00000006 */
#define SAES_CR_KSHAREID                     SAES_CR_KSHAREID_Msk                      /*!< Key Shared ID */
#define SAES_CR_KEYSEL_Pos                  (28U)
#define SAES_CR_KEYSEL_Msk                  (0x7UL << SAES_CR_KEYSEL_Pos)             /*!< 0x00000006 */
#define SAES_CR_KEYSEL                       SAES_CR_KEYSEL_Msk                        /*!< Key Selection */
#define SAES_CR_KEYSEL_0                    (0x1UL << SAES_CR_KEYSEL_Pos)             /*!< 0x02000000 */
#define SAES_CR_KEYSEL_1                    (0x2UL << SAES_CR_KEYSEL_Pos)             /*!< 0x02000000 */
#define SAES_CR_KEYSEL_2                    (0x4UL << SAES_CR_KEYSEL_Pos)             /*!< 0x02000000 */
#define SAES_CR_IPRST_Pos                    (31U)
#define SAES_CR_IPRST_Msk                    (0x1UL << SAES_CR_IPRST_Pos)             /*!< 0x80000001 */
#define SAES_CR_IPRST                        SAES_CR_IPRST_Msk                        /*!< SAES IP software reset */
#define SAES_SR_CCF_Pos                      (0U)
#define SAES_SR_CCF_Msk                      (0x1UL << SAES_SR_CCF_Pos)               /*!< 0x00000001 */
#define SAES_SR_CCF                          SAES_SR_CCF_Msk                          /*!< Computation Complete Flag */
#define SAES_SR_RDERR_Pos                    (1U)
#define SAES_SR_RDERR_Msk                    (0x1UL << SAES_SR_RDERR_Pos)             /*!< 0x00000002 */
#define SAES_SR_RDERR                        SAES_SR_RDERR_Msk                        /*!< Read Error Flag */
#define SAES_SR_WRERR_Pos                    (2U)
#define SAES_SR_WRERR_Msk                    (0x1UL << SAES_SR_WRERR_Pos)             /*!< 0x00000004 */
#define SAES_SR_WRERR                        SAES_SR_WRERR_Msk                        /*!< Write Error Flag */
#define SAES_SR_BUSY_Pos                     (3U)
#define SAES_SR_BUSY_Msk                     (0x1UL << SAES_SR_BUSY_Pos)              /*!< 0x00000008 */
#define SAES_SR_BUSY                         SAES_SR_BUSY_Msk                         /*!< Busy Flag */
#define SAES_SR_KEYVALID_Pos                 (7U)
#define SAES_SR_KEYVALID_Msk                 (0x1UL << SAES_SR_KEYVALID_Pos)          /*!< 0x00000008 */
#define SAES_SR_KEYVALID                     SAES_SR_KEYVALID_Msk                     /*!< KEYVALID Flag */
#define SAES_DINR_Pos                        (0U)
#define SAES_DINR_Msk                        (0xFFFFFFFFUL << SAES_DINR_Pos)          /*!< 0xFFFFFFFF */
#define SAES_DINR                            SAES_DINR_Msk                            /*!< SAES Data Input Register */
#define SAES_DOUTR_Pos                       (0U)
#define SAES_DOUTR_Msk                       (0xFFFFFFFFUL << SAES_DOUTR_Pos)         /*!< 0xFFFFFFFF */
#define SAES_DOUTR                           SAES_DOUTR_Msk                           /*!< SAES Data Output Register */
#define SAES_KEYR0_Pos                       (0U)
#define SAES_KEYR0_Msk                       (0xFFFFFFFFUL << SAES_KEYR0_Pos)         /*!< 0xFFFFFFFF */
#define SAES_KEYR0                           SAES_KEYR0_Msk                           /*!< SAES Key Register 0 */
#define SAES_KEYR1_Pos                       (0U)
#define SAES_KEYR1_Msk                       (0xFFFFFFFFUL << SAES_KEYR1_Pos)         /*!< 0xFFFFFFFF */
#define SAES_KEYR1                           SAES_KEYR1_Msk                           /*!< SAES Key Register 1 */
#define SAES_KEYR2_Pos                       (0U)
#define SAES_KEYR2_Msk                       (0xFFFFFFFFUL << SAES_KEYR2_Pos)         /*!< 0xFFFFFFFF */
#define SAES_KEYR2                           SAES_KEYR2_Msk                           /*!< SAES Key Register 2 */
#define SAES_KEYR3_Pos                       (0U)
#define SAES_KEYR3_Msk                       (0xFFFFFFFFUL << SAES_KEYR3_Pos)         /*!< 0xFFFFFFFF */
#define SAES_KEYR3                           SAES_KEYR3_Msk                           /*!< SAES Key Register 3 */
#define SAES_KEYR4_Pos                       (0U)
#define SAES_KEYR4_Msk                       (0xFFFFFFFFUL << SAES_KEYR4_Pos)         /*!< 0xFFFFFFFF */
#define SAES_KEYR4                           SAES_KEYR4_Msk                           /*!< SAES Key Register 4 */
#define SAES_KEYR5_Pos                       (0U)
#define SAES_KEYR5_Msk                       (0xFFFFFFFFUL << SAES_KEYR5_Pos)         /*!< 0xFFFFFFFF */
#define SAES_KEYR5                           SAES_KEYR5_Msk                           /*!< SAES Key Register 5 */
#define SAES_KEYR6_Pos                       (0U)
#define SAES_KEYR6_Msk                       (0xFFFFFFFFUL << SAES_KEYR6_Pos)         /*!< 0xFFFFFFFF */
#define SAES_KEYR6                           SAES_KEYR6_Msk                           /*!< SAES Key Register 6 */
#define SAES_KEYR7_Pos                       (0U)
#define SAES_KEYR7_Msk                       (0xFFFFFFFFUL << SAES_KEYR7_Pos)         /*!< 0xFFFFFFFF */
#define SAES_KEYR7                           SAES_KEYR7_Msk                           /*!< SAES Key Register 7 */
#define SAES_IVR0_Pos                        (0U)
#define SAES_IVR0_Msk                        (0xFFFFFFFFUL << SAES_IVR0_Pos)          /*!< 0xFFFFFFFF */
#define SAES_IVR0                            SAES_IVR0_Msk                            /*!< SAES Initialization Vector Register 0 */
#define SAES_IVR1_Pos                        (0U)
#define SAES_IVR1_Msk                        (0xFFFFFFFFUL << SAES_IVR1_Pos)          /*!< 0xFFFFFFFF */
#define SAES_IVR1                            SAES_IVR1_Msk                            /*!< SAES Initialization Vector Register 1 */
#define SAES_IVR2_Pos                        (0U)
#define SAES_IVR2_Msk                        (0xFFFFFFFFUL << SAES_IVR2_Pos)          /*!< 0xFFFFFFFF */
#define SAES_IVR2                            SAES_IVR2_Msk                            /*!< SAES Initialization Vector Register 2 */
#define SAES_IVR3_Pos                        (0U)
#define SAES_IVR3_Msk                        (0xFFFFFFFFUL << SAES_IVR3_Pos)          /*!< 0xFFFFFFFF */
#define SAES_IVR3                            SAES_IVR3_Msk                            /*!< SAES Initialization Vector Register 3 */
#define SAES_SUSP0R_Pos                      (0U)
#define SAES_SUSP0R_Msk                      (0xFFFFFFFFUL << SAES_SUSP0R_Pos)        /*!< 0xFFFFFFFF */
#define SAES_SUSP0R                          SAES_SUSP0R_Msk                          /*!< SAES Suspend registers 0 */
#define SAES_SUSP1R_Pos                      (0U)
#define SAES_SUSP1R_Msk                      (0xFFFFFFFFUL << SAES_SUSP1R_Pos)        /*!< 0xFFFFFFFF */
#define SAES_SUSP1R                          SAES_SUSP1R_Msk                          /*!< SAES Suspend registers 1 */
#define SAES_SUSP2R_Pos                      (0U)
#define SAES_SUSP2R_Msk                      (0xFFFFFFFFUL << SAES_SUSP2R_Pos)        /*!< 0xFFFFFFFF */
#define SAES_SUSP2R                          SAES_SUSP2R_Msk                          /*!< SAES Suspend registers 2 */
#define SAES_SUSP3R_Pos                      (0U)
#define SAES_SUSP3R_Msk                      (0xFFFFFFFFUL << SAES_SUSP3R_Pos)        /*!< 0xFFFFFFFF */
#define SAES_SUSP3R                          SAES_SUSP3R_Msk                          /*!< SAES Suspend registers 3 */
#define SAES_SUSP4R_Pos                      (0U)
#define SAES_SUSP4R_Msk                      (0xFFFFFFFFUL << SAES_SUSP4R_Pos)        /*!< 0xFFFFFFFF */
#define SAES_SUSP4R                          SAES_SUSP4R_Msk                          /*!< SAES Suspend registers 4 */
#define SAES_SUSP5R_Pos                      (0U)
#define SAES_SUSP5R_Msk                      (0xFFFFFFFFUL << SAES_SUSP5R_Pos)        /*!< 0xFFFFFFFF */
#define SAES_SUSP5R                          SAES_SUSP5R_Msk                          /*!< AES Suspend registers 5 */
#define SAES_SUSP6R_Pos                      (0U)
#define SAES_SUSP6R_Msk                      (0xFFFFFFFFUL << SAES_SUSP6R_Pos)        /*!< 0xFFFFFFFF */
#define SAES_SUSP6R                          SAES_SUSP6R_Msk                          /*!< SAES Suspend registers 6 */
#define SAES_SUSP7R_Pos                      (0U)
#define SAES_SUSP7R_Msk                      (0xFFFFFFFFUL << SAES_SUSP7R_Pos)        /*!< 0xFFFFFFFF */
#define SAES_SUSP7R                          SAES_SUSP7R_Msk                          /*!< SAES Suspend registers 7 */
#define SAES_IER_CCFIE_Pos                   (0U)
#define SAES_IER_CCFIE_Msk                   (0x1UL << SAES_IER_CCFIE_Pos)            /*!< 0x00000001 */
#define SAES_IER_CCFIE                       SAES_IER_CCFIE_Msk                       /*!< Computation complete flag interrupt enable */
#define SAES_IER_RWEIE_Pos                   (1U)
#define SAES_IER_RWEIE_Msk                   (0x1UL << SAES_IER_RWEIE_Pos)            /*!< 0x00000002 */
#define SAES_IER_RWEIE                       SAES_IER_RWEIE_Msk                       /*!< Read or write error Interrupt Enable */
#define SAES_IER_KEIE_Pos                    (2U)
#define SAES_IER_KEIE_Msk                    (0x1UL << SAES_IER_KEIE_Pos)             /*!< 0x00000004 */
#define SAES_IER_KEIE                        SAES_IER_KEIE_Msk                        /*!< Key error interrupt enable */
#define SAES_IER_RNGEIE_Pos                  (3U)
#define SAES_IER_RNGEIE_Msk                  (0x1UL << SAES_IER_RNGEIE_Pos)           /*!< 0x00000008 */
#define SAES_IER_RNGEIE                      SAES_IER_RNGEIE_Msk                      /*!< Rng error interrupt enable */
#define SAES_ISR_CCF_Pos                     (0U)
#define SAES_ISR_CCF_Msk                     (0x1UL << SAES_ISR_CCF_Pos)              /*!< 0x00000001 */
#define SAES_ISR_CCF                         SAES_ISR_CCF_Msk                         /*!< Computation complete flag */
#define SAES_ISR_RWEIF_Pos                   (1U)
#define SAES_ISR_RWEIF_Msk                   (0x1UL << SAES_ISR_RWEIF_Pos)            /*!< 0x00000002 */
#define SAES_ISR_RWEIF                       SAES_ISR_RWEIF_Msk                       /*!< Read or write error Interrupt flag */
#define SAES_ISR_KEIF_Pos                    (2U)
#define SAES_ISR_KEIF_Msk                    (0x1UL << SAES_ISR_KEIF_Pos)             /*!< 0x00000004 */
#define SAES_ISR_KEIF                        SAES_ISR_KEIF_Msk                        /*!< Key error interrupt flag */
#define SAES_ISR_RNGEIF_Pos                  (3U)
#define SAES_ISR_RNGEIF_Msk                  (0x1UL << SAES_ISR_RNGEIF_Pos)           /*!< 0x00000008 */
#define SAES_ISR_RNGEIF                      SAES_ISR_RNGEIF_Msk                      /*!< Rng error interrupt flag */
#define SAES_ICR_CCF_Pos                     (0U)
#define SAES_ICR_CCF_Msk                     (0x1UL << SAES_ICR_CCF_Pos)              /*!< 0x00000001 */
#define SAES_ICR_CCF                         SAES_ICR_CCF_Msk                         /*!< Computation complete flag clear */
#define SAES_ICR_RWEIF_Pos                   (1U)
#define SAES_ICR_RWEIF_Msk                   (0x1UL << SAES_ICR_RWEIF_Pos)            /*!< 0x00000002 */
#define SAES_ICR_RWEIF                       SAES_ICR_RWEIF_Msk                       /*!< Read or write error Interrupt flag clear */
#define SAES_ICR_KEIF_Pos                    (2U)
#define SAES_ICR_KEIF_Msk                    (0x1UL << SAES_ICR_KEIF_Pos)             /*!< 0x00000004 */
#define SAES_ICR_KEIF                        SAES_ICR_KEIF_Msk                        /*!< Key error interrupt flag clear */
#define SAES_ICR_RNGEIF_Pos                  (3U)
#define SAES_ICR_RNGEIF_Msk                  (0x1UL << SAES_ICR_RNGEIF_Pos)           /*!< 0x00000008 */
#define SAES_ICR_RNGEIF                       SAES_ICR_RNGEIF_Msk                     /*!< Rng error interrupt flag clear */
