// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

#define IS_TIM_INSTANCE(INSTANCE)       (((INSTANCE) == TIM1)  || \
                                         ((INSTANCE) == TIM2)  || \
                                         ((INSTANCE) == TIM3)  || \
                                         ((INSTANCE) == TIM4)  || \
                                         ((INSTANCE) == TIM5)  || \
                                         ((INSTANCE) == TIM6)  || \
                                         ((INSTANCE) == TIM7)  || \
                                         ((INSTANCE) == TIM9)  || \
                                         ((INSTANCE) == TIM12) || \
                                         ((INSTANCE) == TIM13) || \
                                         ((INSTANCE) == TIM14) || \
                                         ((INSTANCE) == TIM15) || \
                                         ((INSTANCE) == TIM16) || \
                                         ((INSTANCE) == TIM17))
#define IS_TIM_32B_COUNTER_INSTANCE(INSTANCE) (((INSTANCE) == TIM2)  || \
                                               ((INSTANCE) == TIM3)  || \
                                               ((INSTANCE) == TIM4)  || \
                                               ((INSTANCE) == TIM5))
#define IS_TIM_ADVANCED_INSTANCE(INSTANCE)     ((INSTANCE) == TIM1)
#define IS_TIM_BREAK_INSTANCE(INSTANCE)    (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM15) || \
                                            ((INSTANCE) == TIM16) || \
                                            ((INSTANCE) == TIM17))
#define IS_TIM_BREAKSOURCE_INSTANCE(INSTANCE) (((INSTANCE) == TIM1)  || \
                                               ((INSTANCE) == TIM15) || \
                                               ((INSTANCE) == TIM16) || \
                                               ((INSTANCE) == TIM17))
#define IS_TIM_BKIN2_INSTANCE(INSTANCE) ((INSTANCE) == TIM1)
#define IS_TIM_CC1_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  || \
                                         ((INSTANCE) == TIM2)  || \
                                         ((INSTANCE) == TIM3)  || \
                                         ((INSTANCE) == TIM4)  || \
                                         ((INSTANCE) == TIM5)  || \
                                         ((INSTANCE) == TIM9)  || \
                                         ((INSTANCE) == TIM12) || \
                                         ((INSTANCE) == TIM13) || \
                                         ((INSTANCE) == TIM14) || \
                                         ((INSTANCE) == TIM15) || \
                                         ((INSTANCE) == TIM16) || \
                                         ((INSTANCE) == TIM17))
#define IS_TIM_CC2_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  || \
                                         ((INSTANCE) == TIM2)  || \
                                         ((INSTANCE) == TIM3)  || \
                                         ((INSTANCE) == TIM4)  || \
                                         ((INSTANCE) == TIM5)  || \
                                         ((INSTANCE) == TIM9)  || \
                                         ((INSTANCE) == TIM12) || \
                                         ((INSTANCE) == TIM15))
#define IS_TIM_CC3_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  || \
                                         ((INSTANCE) == TIM2)  || \
                                         ((INSTANCE) == TIM3)  || \
                                         ((INSTANCE) == TIM4)  || \
                                         ((INSTANCE) == TIM5))
#define IS_TIM_CC4_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  || \
                                         ((INSTANCE) == TIM2)  || \
                                         ((INSTANCE) == TIM3)  || \
                                         ((INSTANCE) == TIM4)  || \
                                         ((INSTANCE) == TIM5))
#define IS_TIM_CC5_INSTANCE(INSTANCE)   ((INSTANCE) == TIM1)
#define IS_TIM_CC6_INSTANCE(INSTANCE)   ((INSTANCE) == TIM1)
#define IS_TIM_DMA_INSTANCE(INSTANCE)      (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5)  || \
                                            ((INSTANCE) == TIM6)  || \
                                            ((INSTANCE) == TIM7)  || \
                                            ((INSTANCE) == TIM15) || \
                                            ((INSTANCE) == TIM16) || \
                                            ((INSTANCE) == TIM17))
#define IS_TIM_DMA_CC_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5)  || \
                                            ((INSTANCE) == TIM15) || \
                                            ((INSTANCE) == TIM16) || \
                                            ((INSTANCE) == TIM17))
#define IS_TIM_DMABURST_INSTANCE(INSTANCE) (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5)  || \
                                            ((INSTANCE) == TIM15) || \
                                            ((INSTANCE) == TIM16) || \
                                            ((INSTANCE) == TIM17))
#define IS_TIM_CCX_INSTANCE(INSTANCE, CHANNEL) \
    ((((INSTANCE) == TIM1) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||          \
      ((CHANNEL) == TIM_CHANNEL_2) ||          \
      ((CHANNEL) == TIM_CHANNEL_3) ||          \
      ((CHANNEL) == TIM_CHANNEL_4) ||          \
      ((CHANNEL) == TIM_CHANNEL_5) ||          \
      ((CHANNEL) == TIM_CHANNEL_6)))           \
     ||                                        \
     (((INSTANCE) == TIM2) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||          \
      ((CHANNEL) == TIM_CHANNEL_2) ||          \
      ((CHANNEL) == TIM_CHANNEL_3) ||          \
      ((CHANNEL) == TIM_CHANNEL_4)))           \
     ||                                        \
     (((INSTANCE) == TIM3) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||          \
      ((CHANNEL) == TIM_CHANNEL_2) ||          \
      ((CHANNEL) == TIM_CHANNEL_3) ||          \
      ((CHANNEL) == TIM_CHANNEL_4)))           \
     ||                                        \
     (((INSTANCE) == TIM4) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||          \
      ((CHANNEL) == TIM_CHANNEL_2) ||          \
      ((CHANNEL) == TIM_CHANNEL_3) ||          \
      ((CHANNEL) == TIM_CHANNEL_4)))           \
     ||                                        \
     (((INSTANCE) == TIM5) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||          \
      ((CHANNEL) == TIM_CHANNEL_2) ||          \
      ((CHANNEL) == TIM_CHANNEL_3) ||          \
      ((CHANNEL) == TIM_CHANNEL_4)))           \
     ||                                        \
     (((INSTANCE) == TIM9) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||          \
      ((CHANNEL) == TIM_CHANNEL_2)))           \
     ||                                        \
     (((INSTANCE) == TIM12) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||          \
      ((CHANNEL) == TIM_CHANNEL_2)))           \
     ||                                        \
     (((INSTANCE) == TIM13) && \
     (((CHANNEL) == TIM_CHANNEL_1)))           \
     ||                                        \
     (((INSTANCE) == TIM14) && \
     (((CHANNEL) == TIM_CHANNEL_1)))           \
     ||                                        \
     (((INSTANCE) == TIM15) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||          \
      ((CHANNEL) == TIM_CHANNEL_2)))           \
     ||                                        \
     (((INSTANCE) == TIM16) && \
     (((CHANNEL) == TIM_CHANNEL_1)))           \
     ||                                        \
     (((INSTANCE) == TIM17) && \
     (((CHANNEL) == TIM_CHANNEL_1))))
#define IS_TIM_CCXN_INSTANCE(INSTANCE, CHANNEL) \
    ((((INSTANCE) == TIM1) && \
     (((CHANNEL) == TIM_CHANNEL_1) ||           \
      ((CHANNEL) == TIM_CHANNEL_2) ||           \
      ((CHANNEL) == TIM_CHANNEL_3) ||           \
      ((CHANNEL) == TIM_CHANNEL_4)))            \
    ||                                          \
    (((INSTANCE) == TIM15) && \
     ((CHANNEL) == TIM_CHANNEL_1))              \
    ||                                          \
    (((INSTANCE) == TIM16) && \
     ((CHANNEL) == TIM_CHANNEL_1))              \
    ||                                          \
    (((INSTANCE) == TIM17) && \
     ((CHANNEL) == TIM_CHANNEL_1)))
#define IS_TIM_CLOCK_DIVISION_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  || \
                                                    ((INSTANCE) == TIM2)  || \
                                                    ((INSTANCE) == TIM3)  || \
                                                    ((INSTANCE) == TIM4)  || \
                                                    ((INSTANCE) == TIM5)  || \
                                                    ((INSTANCE) == TIM9)  || \
                                                    ((INSTANCE) == TIM12) || \
                                                    ((INSTANCE) == TIM13) || \
                                                    ((INSTANCE) == TIM14) || \
                                                    ((INSTANCE) == TIM15) || \
                                                    ((INSTANCE) == TIM16) || \
                                                    ((INSTANCE) == TIM17))
#define IS_TIM_CLOCKSOURCE_ETRMODE1_INSTANCE(INSTANCE) (((INSTANCE) == TIM1)  || \
                                                        ((INSTANCE) == TIM2)  || \
                                                        ((INSTANCE) == TIM3)  || \
                                                        ((INSTANCE) == TIM4)  || \
                                                        ((INSTANCE) == TIM5))
#define IS_TIM_CLOCKSOURCE_ETRMODE2_INSTANCE(INSTANCE) (((INSTANCE) == TIM1)  || \
                                                        ((INSTANCE) == TIM2)  || \
                                                        ((INSTANCE) == TIM3)  || \
                                                        ((INSTANCE) == TIM4)  || \
                                                        ((INSTANCE) == TIM5))
#define IS_TIM_CLOCKSOURCE_TIX_INSTANCE(INSTANCE)      (((INSTANCE) == TIM1)  || \
                                                        ((INSTANCE) == TIM2)  || \
                                                        ((INSTANCE) == TIM3)  || \
                                                        ((INSTANCE) == TIM4)  || \
                                                        ((INSTANCE) == TIM5)  || \
                                                        ((INSTANCE) == TIM9)  || \
                                                        ((INSTANCE) == TIM12) || \
                                                        ((INSTANCE) == TIM15))
#define IS_TIM_CLOCKSOURCE_ITRX_INSTANCE(INSTANCE)     (((INSTANCE) == TIM1)  ||  \
                                                        ((INSTANCE) == TIM2)  ||  \
                                                        ((INSTANCE) == TIM3)  ||  \
                                                        ((INSTANCE) == TIM4)  ||  \
                                                        ((INSTANCE) == TIM5)  ||  \
                                                        ((INSTANCE) == TIM9)  ||  \
                                                        ((INSTANCE) == TIM12) ||  \
                                                        ((INSTANCE) == TIM15))
#define IS_TIM_COMBINED3PHASEPWM_INSTANCE(INSTANCE) ((INSTANCE) == TIM1)
#define IS_TIM_COMMUTATION_EVENT_INSTANCE(INSTANCE) (((INSTANCE) == TIM1)  || \
                                                     ((INSTANCE) == TIM15) || \
                                                     ((INSTANCE) == TIM16) || \
                                                     ((INSTANCE) == TIM17))
#define IS_TIM_COUNTER_MODE_SELECT_INSTANCE(INSTANCE)  (((INSTANCE) == TIM1)  || \
                                                        ((INSTANCE) == TIM2)  || \
                                                        ((INSTANCE) == TIM3)  || \
                                                        ((INSTANCE) == TIM4)  || \
                                                        ((INSTANCE) == TIM5))
#define IS_TIM_ENCODER_INTERFACE_INSTANCE(INSTANCE)  (((INSTANCE) == TIM1)  || \
                                                      ((INSTANCE) == TIM2)  || \
                                                      ((INSTANCE) == TIM3)  || \
                                                      ((INSTANCE) == TIM4)  || \
                                                      ((INSTANCE) == TIM5))
#define IS_TIM_HALL_SENSOR_INTERFACE_INSTANCE(INSTANCE) (((INSTANCE) == TIM1)  || \
                                                         ((INSTANCE) == TIM2)  || \
                                                         ((INSTANCE) == TIM3)  || \
                                                         ((INSTANCE) == TIM4)  || \
                                                         ((INSTANCE) == TIM5)  || \
                                                         ((INSTANCE) == TIM9)  || \
                                                         ((INSTANCE) == TIM12) || \
                                                         ((INSTANCE) == TIM15))
#define IS_TIM_ETR_INSTANCE(INSTANCE)      (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5))
#define IS_TIM_ETRSEL_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5))
#define IS_TIM_MASTER_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5)  || \
                                            ((INSTANCE) == TIM6)  || \
                                            ((INSTANCE) == TIM7)  || \
                                            ((INSTANCE) == TIM9)  || \
                                            ((INSTANCE) == TIM12) || \
                                            ((INSTANCE) == TIM15))
#define IS_TIM_SLAVE_INSTANCE(INSTANCE)    (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5)  || \
                                            ((INSTANCE) == TIM9)  || \
                                            ((INSTANCE) == TIM12) || \
                                            ((INSTANCE) == TIM15))
#define IS_TIM_OCXREF_CLEAR_INSTANCE(INSTANCE)  (((INSTANCE) == TIM1)  || \
                                                 ((INSTANCE) == TIM2)  || \
                                                 ((INSTANCE) == TIM3)  || \
                                                 ((INSTANCE) == TIM4)  || \
                                                 ((INSTANCE) == TIM5))
#define IS_TIM_REMAP_INSTANCE(INSTANCE)    (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5))
#define IS_TIM_REPETITION_COUNTER_INSTANCE(INSTANCE)  (((INSTANCE) == TIM1)  || \
                                                       ((INSTANCE) == TIM15) || \
                                                       ((INSTANCE) == TIM16) || \
                                                       ((INSTANCE) == TIM17))
#define IS_TIM_TISEL_INSTANCE(INSTANCE) (((INSTANCE) == TIM2)  || \
                                         ((INSTANCE) == TIM3)  || \
                                         ((INSTANCE) == TIM9)  || \
                                         ((INSTANCE) == TIM12) || \
                                         ((INSTANCE) == TIM15) || \
                                         ((INSTANCE) == TIM16) || \
                                         ((INSTANCE) == TIM17))
#define IS_TIM_TRGO2_INSTANCE(INSTANCE)    ((INSTANCE) == TIM1)
#define IS_TIM_XOR_INSTANCE(INSTANCE)      (((INSTANCE) == TIM1)  || \
                                            ((INSTANCE) == TIM2)  || \
                                            ((INSTANCE) == TIM3)  || \
                                            ((INSTANCE) == TIM4)  || \
                                            ((INSTANCE) == TIM5)  || \
                                            ((INSTANCE) == TIM9)  || \
                                            ((INSTANCE) == TIM12) || \
                                            ((INSTANCE) == TIM15))
