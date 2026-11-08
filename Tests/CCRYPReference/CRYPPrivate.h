// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define CRYP_TIMEOUT_KEYPREPARATION      82U
#define CRYP_TIMEOUT_GCMCCMINITPHASE     299U
#define CRYP_TIMEOUT_GCMCCMHEADERPHASE   290U
#define CRYP_GENERAL_TIMEOUT             500U
#define  CRYP_PHASE_READY                0x00000001U
#define  CRYP_PHASE_PROCESS              0x00000002U
#define  CRYP_PHASE_HEADER_SUSPENDED     0x00000004U
#define  CRYP_PHASE_PAYLOAD_SUSPENDED    0x00000005U
#define  CRYP_PHASE_HEADER_DMA_FEED      0x00000006U
#define CRYP_PHASE_INIT                  0x00000000U
#define CRYP_PHASE_HEADER                CRYP_CR_GCM_CCMPH_0
#define CRYP_PHASE_PAYLOAD               CRYP_CR_GCM_CCMPH_1
#define CRYP_PHASE_FINAL                 CRYP_CR_GCM_CCMPH
#define SAES_PHASE_INIT                  0x00000000U
#define SAES_PHASE_HEADER                SAES_CR_GCMPH_0
#define SAES_PHASE_PAYLOAD               SAES_CR_GCMPH_1
#define SAES_PHASE_FINAL                 SAES_CR_GCMPH
#define CRYP_CCM_CTR1_0                  0x07FFFFFFU
#define CRYP_CCM_CTR1_1                  0xFFFFFF00U
#define CRYP_CCM_CTR1_2                  0x00000001U
#define IT_SUSPENDED                     0x00000000U
#define DMA_SUSPENDED                    0x00000001U
#define ALGOMODE_CRYP_TO_CHMOD_SAES     0
#define ALGOMODE_SAES_TO_CHMOD_CRYP     1
#define CRYP_SET_PHASE(__HANDLE__, __PHASE__)  do{MODIFY_REG(((CRYP_TypeDef *)((__HANDLE__)->Instance))->CR, \
                                                             CRYP_CR_GCM_CCMPH, (__PHASE__));                \
                                                                               }while(0)
#define SAES_SET_PHASE(__HANDLE__, __PHASE__)  do{MODIFY_REG(((SAES_TypeDef *)((__HANDLE__)->Instance))->CR, \
                                                             SAES_CR_GCMPH, (__PHASE__));                    \
                                                                               }while(0)
#define CRYP_FIFO_FLUSH(__HANDLE__) (((CRYP_TypeDef *)((__HANDLE__)->Instance))->CR |=  CRYP_CR_FFLUSH)
#define SAES_IP_RESET(__HANDLE__)   do { \
                                         __IO uint32_t tmpreg; \
                                         SET_BIT(((SAES_TypeDef *)((__HANDLE__)->Instance))->CR, SAES_CR_IPRST); \
                                          \
                                         tmpreg = READ_BIT(((SAES_TypeDef *)((__HANDLE__)->Instance))->CR, \
                                         SAES_CR_IPRST); \
                                         CLEAR_BIT(((SAES_TypeDef *)((__HANDLE__)->Instance))->CR, SAES_CR_IPRST); \
                                         UNUSED(tmpreg); \
                                          } while(0)
#define CRYP_PHASE_INIT                 0x00000000U
#define CRYP_PHASE_HEADER               CRYP_CR_GCM_CCMPH_0
#define CRYP_PHASE_PAYLOAD              CRYP_CR_GCM_CCMPH_1
#define CRYP_PHASE_FINAL                CRYP_CR_GCM_CCMPH
#define SAES_PHASE_INIT                  0x00000000U
#define SAES_PHASE_HEADER                SAES_CR_GCMPH_0
#define SAES_PHASE_PAYLOAD               SAES_CR_GCMPH_1
#define SAES_PHASE_FINAL                 SAES_CR_GCMPH
#define  CRYPEx_PHASE_PROCESS       0x02U
#define  CRYPEx_PHASE_FINAL         0x03U
#define CRYP_CCM_CTR0_0            0x07FFFFFFU
#define CRYP_CCM_CTR0_3            0xFFFFFF00U
