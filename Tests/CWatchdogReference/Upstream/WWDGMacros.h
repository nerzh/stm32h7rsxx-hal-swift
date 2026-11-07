/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define WWDG_IT_EWI                         WWDG_CFR_EWI  /*!< Early wakeup interrupt */
#define WWDG_FLAG_EWIF                      WWDG_SR_EWIF  /*!< Early wakeup interrupt flag */
#define WWDG_PRESCALER_1                    0x00000000u                              /*!< WWDG counter clock = (PCLK1/4096)/1 */
#define WWDG_PRESCALER_2                    WWDG_CFR_WDGTB_0                         /*!< WWDG counter clock = (PCLK1/4096)/2 */
#define WWDG_PRESCALER_4                    WWDG_CFR_WDGTB_1                         /*!< WWDG counter clock = (PCLK1/4096)/4 */
#define WWDG_PRESCALER_8                    (WWDG_CFR_WDGTB_1 | WWDG_CFR_WDGTB_0)    /*!< WWDG counter clock = (PCLK1/4096)/8 */
#define WWDG_PRESCALER_16                   WWDG_CFR_WDGTB_2                         /*!< WWDG counter clock = (PCLK1/4096)/16 */
#define WWDG_PRESCALER_32                   (WWDG_CFR_WDGTB_2 | WWDG_CFR_WDGTB_0)    /*!< WWDG counter clock = (PCLK1/4096)/32 */
#define WWDG_PRESCALER_64                   (WWDG_CFR_WDGTB_2 | WWDG_CFR_WDGTB_1)    /*!< WWDG counter clock = (PCLK1/4096)/64 */
#define WWDG_PRESCALER_128                  WWDG_CFR_WDGTB                           /*!< WWDG counter clock = (PCLK1/4096)/128 */
#define WWDG_EWI_DISABLE                    0x00000000u       /*!< EWI Disable */
#define WWDG_EWI_ENABLE                     WWDG_CFR_EWI      /*!< EWI Enable */
#define IS_WWDG_PRESCALER(__PRESCALER__)    (((__PRESCALER__) == WWDG_PRESCALER_1)  || \
                                             ((__PRESCALER__) == WWDG_PRESCALER_2)  || \
                                             ((__PRESCALER__) == WWDG_PRESCALER_4)  || \
                                             ((__PRESCALER__) == WWDG_PRESCALER_8)  || \
                                             ((__PRESCALER__) == WWDG_PRESCALER_16) || \
                                             ((__PRESCALER__) == WWDG_PRESCALER_32) || \
                                             ((__PRESCALER__) == WWDG_PRESCALER_64) || \
                                             ((__PRESCALER__) == WWDG_PRESCALER_128))
#define IS_WWDG_WINDOW(__WINDOW__)          (((__WINDOW__) >= WWDG_CFR_W_6) && ((__WINDOW__) <= WWDG_CFR_W))
#define IS_WWDG_COUNTER(__COUNTER__)        (((__COUNTER__) >= WWDG_CR_T_6) && ((__COUNTER__) <= WWDG_CR_T))
#define IS_WWDG_EWI_MODE(__MODE__)          (((__MODE__) == WWDG_EWI_ENABLE) || \
                                             ((__MODE__) == WWDG_EWI_DISABLE))
#define __HAL_WWDG_ENABLE(__HANDLE__)                         SET_BIT((__HANDLE__)->Instance->CR, WWDG_CR_WDGA)
#define __HAL_WWDG_ENABLE_IT(__HANDLE__, __INTERRUPT__)       SET_BIT((__HANDLE__)->Instance->CFR, (__INTERRUPT__))
#define __HAL_WWDG_GET_IT(__HANDLE__, __INTERRUPT__)        __HAL_WWDG_GET_FLAG((__HANDLE__),(__INTERRUPT__))
#define __HAL_WWDG_CLEAR_IT(__HANDLE__, __INTERRUPT__)      __HAL_WWDG_CLEAR_FLAG((__HANDLE__), (__INTERRUPT__))
#define __HAL_WWDG_GET_FLAG(__HANDLE__, __FLAG__)           (((__HANDLE__)->Instance->SR & (__FLAG__)) == (__FLAG__))
#define __HAL_WWDG_CLEAR_FLAG(__HANDLE__, __FLAG__)         ((__HANDLE__)->Instance->SR = ~(__FLAG__))
#define __HAL_WWDG_GET_IT_SOURCE(__HANDLE__, __INTERRUPT__) (((__HANDLE__)->Instance->CFR\
                                                              & (__INTERRUPT__)) == (__INTERRUPT__))
