/* Copyright (c) 2022 STMicroelectronics. SPDX-License-Identifier: Apache-2.0
 * CMSIS device extracts at 7e6e213ddc397c76622a0aca2f623ccc3b34c010. */
typedef struct
{
  __IO uint32_t ISR;           /*!< LPTIM Interrupt and Status register,    Address offset: 0x00 */
  __IO uint32_t ICR;           /*!< LPTIM Interrupt Clear register,         Address offset: 0x04 */
  __IO uint32_t DIER;          /*!< LPTIM Interrupt Enable register,        Address offset: 0x08 */
  __IO uint32_t CFGR;          /*!< LPTIM Configuration register,           Address offset: 0x0C */
  __IO uint32_t CR;            /*!< LPTIM Control register,                 Address offset: 0x10 */
  __IO uint32_t CCR1;          /*!< LPTIM Capture/Compare register 1,       Address offset: 0x14 */
  __IO uint32_t ARR;           /*!< LPTIM Autoreload register,              Address offset: 0x18 */
  __IO uint32_t CNT;           /*!< LPTIM Counter register,                 Address offset: 0x1C */
  __IO uint32_t RESERVED0;     /*!< Reserved,                               Address offset: 0x20 */
  __IO uint32_t CFGR2;         /*!< LPTIM Configuration register 2,         Address offset: 0x24 */
  __IO uint32_t RCR;           /*!< LPTIM Repetition register,              Address offset: 0x28 */
  __IO uint32_t CCMR1;         /*!< LPTIM Capture/Compare mode register,    Address offset: 0x2C */
  __IO uint32_t RESERVED1;     /*!< Reserved,                               Address offset: 0x30 */
  __IO uint32_t CCR2;          /*!< LPTIM Capture/Compare register 2,       Address offset: 0x34 */
} LPTIM_TypeDef;
#define EXTI_IMR2_IM47_Pos           (15U)
#define EXTI_IMR2_IM47_Msk           (0x1UL << EXTI_IMR2_IM47_Pos)             /*!< 0x00008000 */
#define EXTI_IMR2_IM47               EXTI_IMR2_IM47_Msk                        /*!< Interrupt Mask on line 47 */
#define EXTI_IMR2_IM48_Pos           (16U)
#define EXTI_IMR2_IM48_Msk           (0x1UL << EXTI_IMR2_IM48_Pos)             /*!< 0x00010000 */
#define EXTI_IMR2_IM48               EXTI_IMR2_IM48_Msk                        /*!< Interrupt Mask on line 48 */
#define EXTI_IMR2_IM50_Pos           (18U)
#define EXTI_IMR2_IM50_Msk           (0x1UL << EXTI_IMR2_IM50_Pos)             /*!< 0x00040000 */
#define EXTI_IMR2_IM50               EXTI_IMR2_IM50_Msk                        /*!< Interrupt Mask on line 50 */
#define EXTI_IMR2_IM52_Pos           (20U)
#define EXTI_IMR2_IM52_Msk           (0x1UL << EXTI_IMR2_IM52_Pos)             /*!< 0x00100000 */
#define EXTI_IMR2_IM52               EXTI_IMR2_IM52_Msk                        /*!< Interrupt Mask on line 52 */
#define EXTI_IMR2_IM53_Pos           (21U)
#define EXTI_IMR2_IM53_Msk           (0x1UL << EXTI_IMR2_IM53_Pos)             /*!< 0x00200000 */
#define EXTI_IMR2_IM53               EXTI_IMR2_IM53_Msk                        /*!< Interrupt Mask on line 53 */
#define LPTIM_ISR_CC1IF_Pos            (0U)
#define LPTIM_ISR_CC1IF_Msk            (0x1UL << LPTIM_ISR_CC1IF_Pos)          /*!< 0x00000001 */
#define LPTIM_ISR_CC1IF                LPTIM_ISR_CC1IF_Msk                     /*!< Capture/Compare 1 interrupt flag */
#define LPTIM_ISR_ARRM_Pos             (1U)
#define LPTIM_ISR_ARRM_Msk             (0x1UL << LPTIM_ISR_ARRM_Pos)           /*!< 0x00000002 */
#define LPTIM_ISR_ARRM                 LPTIM_ISR_ARRM_Msk                      /*!< Autoreload match */
#define LPTIM_ISR_EXTTRIG_Pos          (2U)
#define LPTIM_ISR_EXTTRIG_Msk          (0x1UL << LPTIM_ISR_EXTTRIG_Pos)        /*!< 0x00000004 */
#define LPTIM_ISR_EXTTRIG              LPTIM_ISR_EXTTRIG_Msk                   /*!< External trigger edge event */
#define LPTIM_ISR_CMP1OK_Pos           (3U)
#define LPTIM_ISR_CMP1OK_Msk           (0x1UL << LPTIM_ISR_CMP1OK_Pos)         /*!< 0x00000008 */
#define LPTIM_ISR_CMP1OK               LPTIM_ISR_CMP1OK_Msk                    /*!< Compare register 1 update OK */
#define LPTIM_ISR_ARROK_Pos            (4U)
#define LPTIM_ISR_ARROK_Msk            (0x1UL << LPTIM_ISR_ARROK_Pos)          /*!< 0x00000010 */
#define LPTIM_ISR_ARROK                LPTIM_ISR_ARROK_Msk                     /*!< Autoreload register update OK */
#define LPTIM_ISR_UP_Pos               (5U)
#define LPTIM_ISR_UP_Msk               (0x1UL << LPTIM_ISR_UP_Pos)             /*!< 0x00000020 */
#define LPTIM_ISR_UP                   LPTIM_ISR_UP_Msk                        /*!< Counter direction change down to up */
#define LPTIM_ISR_DOWN_Pos             (6U)
#define LPTIM_ISR_DOWN_Msk             (0x1UL << LPTIM_ISR_DOWN_Pos)           /*!< 0x00000040 */
#define LPTIM_ISR_DOWN                 LPTIM_ISR_DOWN_Msk                      /*!< Counter direction change up to down */
#define LPTIM_ISR_UE_Pos               (7U)
#define LPTIM_ISR_UE_Msk               (0x1UL << LPTIM_ISR_UE_Pos)             /*!< 0x00000080 */
#define LPTIM_ISR_UE                   LPTIM_ISR_UE_Msk                        /*!< Update event */
#define LPTIM_ISR_REPOK_Pos            (8U)
#define LPTIM_ISR_REPOK_Msk            (0x1UL << LPTIM_ISR_REPOK_Pos)          /*!< 0x00000100 */
#define LPTIM_ISR_REPOK                LPTIM_ISR_REPOK_Msk                     /*!< Repetition register update OK */
#define LPTIM_ISR_CC2IF_Pos            (9U)
#define LPTIM_ISR_CC2IF_Msk            (0x1UL << LPTIM_ISR_CC2IF_Pos)          /*!< 0x00000200 */
#define LPTIM_ISR_CC2IF                LPTIM_ISR_CC2IF_Msk                     /*!< Capture/Compare 2 interrupt flag */
#define LPTIM_ISR_CC1OF_Pos            (12U)
#define LPTIM_ISR_CC1OF_Msk            (0x1UL << LPTIM_ISR_CC1OF_Pos)          /*!< 0x00001000 */
#define LPTIM_ISR_CC1OF                LPTIM_ISR_CC1OF_Msk                     /*!< Capture/Compare 1 over-capture flag */
#define LPTIM_ISR_CC2OF_Pos            (13U)
#define LPTIM_ISR_CC2OF_Msk            (0x1UL << LPTIM_ISR_CC2OF_Pos)          /*!< 0x00002000 */
#define LPTIM_ISR_CC2OF                LPTIM_ISR_CC2OF_Msk                     /*!< Capture/Compare 2 over-capture flag */
#define LPTIM_ISR_CMP2OK_Pos           (19U)
#define LPTIM_ISR_CMP2OK_Msk           (0x1UL << LPTIM_ISR_CMP2OK_Pos)         /*!< 0x00080000 */
#define LPTIM_ISR_CMP2OK               LPTIM_ISR_CMP2OK_Msk                    /*!< Compare register 2 update OK */
#define LPTIM_ISR_DIEROK_Pos           (24U)
#define LPTIM_ISR_DIEROK_Msk           (0x1UL << LPTIM_ISR_DIEROK_Pos)         /*!< 0x01000000 */
#define LPTIM_ISR_DIEROK               LPTIM_ISR_DIEROK_Msk                    /*!< Interrupt enable register update OK */
#define LPTIM_ICR_CC1CF_Pos            (0U)
#define LPTIM_ICR_CC1CF_Msk            (0x1UL << LPTIM_ICR_CC1CF_Pos)          /*!< 0x00000001 */
#define LPTIM_ICR_CC1CF                LPTIM_ICR_CC1CF_Msk                     /*!< Capture/Compare 1 clear flag  */
#define LPTIM_ICR_ARRMCF_Pos           (1U)
#define LPTIM_ICR_ARRMCF_Msk           (0x1UL << LPTIM_ICR_ARRMCF_Pos)         /*!< 0x00000002 */
#define LPTIM_ICR_ARRMCF               LPTIM_ICR_ARRMCF_Msk                    /*!< Autoreload match clear flag */
#define LPTIM_ICR_EXTTRIGCF_Pos        (2U)
#define LPTIM_ICR_EXTTRIGCF_Msk        (0x1UL << LPTIM_ICR_EXTTRIGCF_Pos)      /*!< 0x00000004 */
#define LPTIM_ICR_EXTTRIGCF            LPTIM_ICR_EXTTRIGCF_Msk                 /*!< External trigger edge event clear flag */
#define LPTIM_ICR_CMP1OKCF_Pos         (3U)
#define LPTIM_ICR_CMP1OKCF_Msk         (0x1UL << LPTIM_ICR_CMP1OKCF_Pos)       /*!< 0x00000008 */
#define LPTIM_ICR_CMP1OKCF             LPTIM_ICR_CMP1OKCF_Msk                  /*!< Compare register 1 update OK clear flag */
#define LPTIM_ICR_ARROKCF_Pos          (4U)
#define LPTIM_ICR_ARROKCF_Msk          (0x1UL << LPTIM_ICR_ARROKCF_Pos)        /*!< 0x00000010 */
#define LPTIM_ICR_ARROKCF              LPTIM_ICR_ARROKCF_Msk                   /*!< Autoreload register update OK clear flag */
#define LPTIM_ICR_UPCF_Pos             (5U)
#define LPTIM_ICR_UPCF_Msk             (0x1UL << LPTIM_ICR_UPCF_Pos)           /*!< 0x00000020 */
#define LPTIM_ICR_UPCF                 LPTIM_ICR_UPCF_Msk                      /*!< Counter direction change down to up clear flag */
#define LPTIM_ICR_DOWNCF_Pos           (6U)
#define LPTIM_ICR_DOWNCF_Msk           (0x1UL << LPTIM_ICR_DOWNCF_Pos)         /*!< 0x00000040 */
#define LPTIM_ICR_DOWNCF               LPTIM_ICR_DOWNCF_Msk                    /*!< Counter direction change up to down clear flag */
#define LPTIM_ICR_UECF_Pos             (7U)
#define LPTIM_ICR_UECF_Msk             (0x1UL << LPTIM_ICR_UECF_Pos)           /*!< 0x00000080 */
#define LPTIM_ICR_UECF                 LPTIM_ICR_UECF_Msk                      /*!< Update event clear flag */
#define LPTIM_ICR_REPOKCF_Pos          (8U)
#define LPTIM_ICR_REPOKCF_Msk          (0x1UL << LPTIM_ICR_REPOKCF_Pos)        /*!< 0x00000100 */
#define LPTIM_ICR_REPOKCF              LPTIM_ICR_REPOKCF_Msk                   /*!< Repetition register update OK clear flag */
#define LPTIM_ICR_CC2CF_Pos            (9U)
#define LPTIM_ICR_CC2CF_Msk            (0x1UL << LPTIM_ICR_CC2CF_Pos)          /*!< 0x00000200 */
#define LPTIM_ICR_CC2CF                LPTIM_ICR_CC2CF_Msk                     /*!< Capture/Compare 2 clear flag  */
#define LPTIM_ICR_CC1OCF_Pos           (12U)
#define LPTIM_ICR_CC1OCF_Msk           (0x1UL << LPTIM_ICR_CC1OCF_Pos)         /*!< 0x00001000 */
#define LPTIM_ICR_CC1OCF               LPTIM_ICR_CC1OCF_Msk                    /*!< Capture/Compare 1 over-capture clear flag */
#define LPTIM_ICR_CC2OCF_Pos           (13U)
#define LPTIM_ICR_CC2OCF_Msk           (0x1UL << LPTIM_ICR_CC2OCF_Pos)         /*!< 0x00002000 */
#define LPTIM_ICR_CC2OCF               LPTIM_ICR_CC2OCF_Msk                    /*!< Capture/Compare 2 over-capture clear flag */
#define LPTIM_ICR_CMP2OKCF_Pos         (19U)
#define LPTIM_ICR_CMP2OKCF_Msk         (0x1UL << LPTIM_ICR_CMP2OKCF_Pos)       /*!< 0x00080000 */
#define LPTIM_ICR_CMP2OKCF             LPTIM_ICR_CMP2OKCF_Msk                  /*!< Compare register 2 update OK clear flag */
#define LPTIM_ICR_DIEROKCF_Pos         (24U)
#define LPTIM_ICR_DIEROKCF_Msk         (0x1UL << LPTIM_ICR_DIEROKCF_Pos)       /*!< 0x01000000 */
#define LPTIM_ICR_DIEROKCF             LPTIM_ICR_DIEROKCF_Msk                  /*!< Interrupt enable register update OK clear flag */
#define LPTIM_DIER_CC1IE_Pos           (0U)
#define LPTIM_DIER_CC1IE_Msk           (0x1UL << LPTIM_DIER_CC1IE_Pos)         /*!< 0x00000001 */
#define LPTIM_DIER_CC1IE               LPTIM_DIER_CC1IE_Msk                    /*!< Compare/Compare 1 interrupt enable */
#define LPTIM_DIER_ARRMIE_Pos          (1U)
#define LPTIM_DIER_ARRMIE_Msk          (0x1UL << LPTIM_DIER_ARRMIE_Pos)        /*!< 0x00000002 */
#define LPTIM_DIER_ARRMIE              LPTIM_DIER_ARRMIE_Msk                   /*!< Autoreload match interrupt enable */
#define LPTIM_DIER_EXTTRIGIE_Pos       (2U)
#define LPTIM_DIER_EXTTRIGIE_Msk       (0x1UL << LPTIM_DIER_EXTTRIGIE_Pos)     /*!< 0x00000004 */
#define LPTIM_DIER_EXTTRIGIE           LPTIM_DIER_EXTTRIGIE_Msk                /*!< External trigger edge event interrupt enable */
#define LPTIM_DIER_CMP1OKIE_Pos        (3U)
#define LPTIM_DIER_CMP1OKIE_Msk        (0x1UL << LPTIM_DIER_CMP1OKIE_Pos)      /*!< 0x00000008 */
#define LPTIM_DIER_CMP1OKIE            LPTIM_DIER_CMP1OKIE_Msk                 /*!< Compare register 1 update OK interrupt enable */
#define LPTIM_DIER_ARROKIE_Pos         (4U)
#define LPTIM_DIER_ARROKIE_Msk         (0x1UL << LPTIM_DIER_ARROKIE_Pos)       /*!< 0x00000010 */
#define LPTIM_DIER_ARROKIE             LPTIM_DIER_ARROKIE_Msk                  /*!< Autoreload register update OK interrupt enable */
#define LPTIM_DIER_UPIE_Pos            (5U)
#define LPTIM_DIER_UPIE_Msk            (0x1UL << LPTIM_DIER_UPIE_Pos)          /*!< 0x00000020 */
#define LPTIM_DIER_UPIE                LPTIM_DIER_UPIE_Msk                     /*!< Counter direction change down to up interrupt enable */
#define LPTIM_DIER_DOWNIE_Pos          (6U)
#define LPTIM_DIER_DOWNIE_Msk          (0x1UL << LPTIM_DIER_DOWNIE_Pos)        /*!< 0x00000040 */
#define LPTIM_DIER_DOWNIE              LPTIM_DIER_DOWNIE_Msk                   /*!< Counter direction change up to down interrupt enable */
#define LPTIM_DIER_UEIE_Pos            (7U)
#define LPTIM_DIER_UEIE_Msk            (0x1UL << LPTIM_DIER_UEIE_Pos)          /*!< 0x00000080 */
#define LPTIM_DIER_UEIE                LPTIM_DIER_UEIE_Msk                     /*!< Update event interrupt enable */
#define LPTIM_DIER_REPOKIE_Pos         (8U)
#define LPTIM_DIER_REPOKIE_Msk         (0x1UL << LPTIM_DIER_REPOKIE_Pos)       /*!< 0x00000100 */
#define LPTIM_DIER_REPOKIE             LPTIM_DIER_REPOKIE_Msk                  /*!< Repetition register update OK interrupt enable */
#define LPTIM_DIER_CC2IE_Pos           (9U)
#define LPTIM_DIER_CC2IE_Msk           (0x1UL << LPTIM_DIER_CC2IE_Pos)         /*!< 0x00000200 */
#define LPTIM_DIER_CC2IE               LPTIM_DIER_CC2IE_Msk                    /*!< Capture/Compare 2 interrupt interrupt enable */
#define LPTIM_DIER_CC1OIE_Pos          (12U)
#define LPTIM_DIER_CC1OIE_Msk          (0x1UL << LPTIM_DIER_CC1OIE_Pos)        /*!< 0x00001000 */
#define LPTIM_DIER_CC1OIE              LPTIM_DIER_CC1OIE_Msk                   /*!< Capture/Compare 1 over-capture interrupt enable */
#define LPTIM_DIER_CC2OIE_Pos          (13U)
#define LPTIM_DIER_CC2OIE_Msk          (0x1UL << LPTIM_DIER_CC2OIE_Pos)        /*!< 0x00002000 */
#define LPTIM_DIER_CC2OIE              LPTIM_DIER_CC2OIE_Msk                   /*!< Capture/Compare 2 over-capture interrupt enable */
#define LPTIM_DIER_CC1DE_Pos           (16U)
#define LPTIM_DIER_CC1DE_Msk           (0x1UL << LPTIM_DIER_CC1DE_Pos)         /*!< 0x00010000 */
#define LPTIM_DIER_CC1DE               LPTIM_DIER_CC1DE_Msk                    /*!< Capture/Compare 1 DMA request enable */
#define LPTIM_DIER_CMP2OKIE_Pos        (19U)
#define LPTIM_DIER_CMP2OKIE_Msk        (0x1UL << LPTIM_DIER_CMP2OKIE_Pos)      /*!< 0x00080000 */
#define LPTIM_DIER_CMP2OKIE            LPTIM_DIER_CMP2OKIE_Msk                 /*!< Compare register 2 update OK interrupt enable */
#define LPTIM_DIER_UEDE_Pos            (23U)
#define LPTIM_DIER_UEDE_Msk            (0x1UL << LPTIM_DIER_UEDE_Pos)          /*!< 0x00800000 */
#define LPTIM_DIER_UEDE                LPTIM_DIER_UEDE_Msk                     /*!< Update event DMA request enable */
#define LPTIM_DIER_CC2DE_Pos           (25U)
#define LPTIM_DIER_CC2DE_Msk           (0x1UL << LPTIM_DIER_CC2DE_Pos)         /*!< 0x02000000 */
#define LPTIM_DIER_CC2DE               LPTIM_DIER_CC2DE_Msk                    /*!< Capture/Compare 2 DMA request enable */
#define LPTIM_CFGR_CKSEL_Pos           (0U)
#define LPTIM_CFGR_CKSEL_Msk           (0x1UL << LPTIM_CFGR_CKSEL_Pos)         /*!< 0x00000001 */
#define LPTIM_CFGR_CKSEL               LPTIM_CFGR_CKSEL_Msk                    /*!< Clock selector */
#define LPTIM_CFGR_CKPOL_Pos           (1U)
#define LPTIM_CFGR_CKPOL_Msk           (0x3UL << LPTIM_CFGR_CKPOL_Pos)         /*!< 0x00000006 */
#define LPTIM_CFGR_CKPOL               LPTIM_CFGR_CKPOL_Msk                    /*!< CKPOL[1:0] bits (Clock polarity) */
#define LPTIM_CFGR_CKPOL_0             (0x1UL << LPTIM_CFGR_CKPOL_Pos)         /*!< 0x00000002 */
#define LPTIM_CFGR_CKPOL_1             (0x2UL << LPTIM_CFGR_CKPOL_Pos)         /*!< 0x00000004 */
#define LPTIM_CFGR_CKFLT_Pos           (3U)
#define LPTIM_CFGR_CKFLT_Msk           (0x3UL << LPTIM_CFGR_CKFLT_Pos)         /*!< 0x00000018 */
#define LPTIM_CFGR_CKFLT               LPTIM_CFGR_CKFLT_Msk                    /*!< CKFLT[1:0] bits (Configurable digital filter for external clock) */
#define LPTIM_CFGR_CKFLT_0             (0x1UL << LPTIM_CFGR_CKFLT_Pos)         /*!< 0x00000008 */
#define LPTIM_CFGR_CKFLT_1             (0x2UL << LPTIM_CFGR_CKFLT_Pos)         /*!< 0x00000010 */
#define LPTIM_CFGR_TRGFLT_Pos          (6U)
#define LPTIM_CFGR_TRGFLT_Msk          (0x3UL << LPTIM_CFGR_TRGFLT_Pos)        /*!< 0x000000C0 */
#define LPTIM_CFGR_TRGFLT              LPTIM_CFGR_TRGFLT_Msk                   /*!< TRGFLT[1:0] bits (Configurable digital filter for trigger) */
#define LPTIM_CFGR_TRGFLT_0            (0x1UL << LPTIM_CFGR_TRGFLT_Pos)        /*!< 0x00000040 */
#define LPTIM_CFGR_TRGFLT_1            (0x2UL << LPTIM_CFGR_TRGFLT_Pos)        /*!< 0x00000080 */
#define LPTIM_CFGR_PRESC_Pos           (9U)
#define LPTIM_CFGR_PRESC_Msk           (0x7UL << LPTIM_CFGR_PRESC_Pos)         /*!< 0x00000E00 */
#define LPTIM_CFGR_PRESC               LPTIM_CFGR_PRESC_Msk                    /*!< PRESC[2:0] bits (Clock prescaler) */
#define LPTIM_CFGR_PRESC_0             (0x1UL << LPTIM_CFGR_PRESC_Pos)         /*!< 0x00000200 */
#define LPTIM_CFGR_PRESC_1             (0x2UL << LPTIM_CFGR_PRESC_Pos)         /*!< 0x00000400 */
#define LPTIM_CFGR_PRESC_2             (0x4UL << LPTIM_CFGR_PRESC_Pos)         /*!< 0x00000800 */
#define LPTIM_CFGR_TRIGSEL_Pos         (13U)
#define LPTIM_CFGR_TRIGSEL_Msk         (0x7UL << LPTIM_CFGR_TRIGSEL_Pos)       /*!< 0x0000E000 */
#define LPTIM_CFGR_TRIGSEL             LPTIM_CFGR_TRIGSEL_Msk                  /*!< TRIGSEL[2:0]] bits (Trigger selector) */
#define LPTIM_CFGR_TRIGSEL_0           (0x1UL << LPTIM_CFGR_TRIGSEL_Pos)       /*!< 0x00002000 */
#define LPTIM_CFGR_TRIGSEL_1           (0x2UL << LPTIM_CFGR_TRIGSEL_Pos)       /*!< 0x00004000 */
#define LPTIM_CFGR_TRIGSEL_2           (0x4UL << LPTIM_CFGR_TRIGSEL_Pos)       /*!< 0x00008000 */
#define LPTIM_CFGR_TRIGEN_Pos          (17U)
#define LPTIM_CFGR_TRIGEN_Msk          (0x3UL << LPTIM_CFGR_TRIGEN_Pos)        /*!< 0x00060000 */
#define LPTIM_CFGR_TRIGEN              LPTIM_CFGR_TRIGEN_Msk                   /*!< TRIGEN[1:0] bits (Trigger enable and polarity) */
#define LPTIM_CFGR_TRIGEN_0            (0x1UL << LPTIM_CFGR_TRIGEN_Pos)        /*!< 0x00020000 */
#define LPTIM_CFGR_TRIGEN_1            (0x2UL << LPTIM_CFGR_TRIGEN_Pos)        /*!< 0x00040000 */
#define LPTIM_CFGR_TIMOUT_Pos          (19U)
#define LPTIM_CFGR_TIMOUT_Msk          (0x1UL << LPTIM_CFGR_TIMOUT_Pos)        /*!< 0x00080000 */
#define LPTIM_CFGR_TIMOUT              LPTIM_CFGR_TIMOUT_Msk                   /*!< Timout enable */
#define LPTIM_CFGR_WAVE_Pos            (20U)
#define LPTIM_CFGR_WAVE_Msk            (0x1UL << LPTIM_CFGR_WAVE_Pos)          /*!< 0x00100000 */
#define LPTIM_CFGR_WAVE                LPTIM_CFGR_WAVE_Msk                     /*!< Waveform shape */
#define LPTIM_CFGR_WAVPOL_Pos          (21U)
#define LPTIM_CFGR_WAVPOL_Msk          (0x1UL << LPTIM_CFGR_WAVPOL_Pos)        /*!< 0x00200000 */
#define LPTIM_CFGR_WAVPOL              LPTIM_CFGR_WAVPOL_Msk                   /*!< Waveform shape */
#define LPTIM_CFGR_PRELOAD_Pos         (22U)
#define LPTIM_CFGR_PRELOAD_Msk         (0x1UL << LPTIM_CFGR_PRELOAD_Pos)       /*!< 0x00400000 */
#define LPTIM_CFGR_PRELOAD             LPTIM_CFGR_PRELOAD_Msk                  /*!< Reg update mode */
#define LPTIM_CFGR_COUNTMODE_Pos       (23U)
#define LPTIM_CFGR_COUNTMODE_Msk       (0x1UL << LPTIM_CFGR_COUNTMODE_Pos)     /*!< 0x00800000 */
#define LPTIM_CFGR_COUNTMODE           LPTIM_CFGR_COUNTMODE_Msk                /*!< Counter mode enable */
#define LPTIM_CFGR_ENC_Pos             (24U)
#define LPTIM_CFGR_ENC_Msk             (0x1UL << LPTIM_CFGR_ENC_Pos)           /*!< 0x01000000 */
#define LPTIM_CFGR_ENC                 LPTIM_CFGR_ENC_Msk                      /*!< Encoder mode enable */
#define LPTIM_CR_ENABLE_Pos            (0U)
#define LPTIM_CR_ENABLE_Msk            (0x1UL << LPTIM_CR_ENABLE_Pos)          /*!< 0x00000001 */
#define LPTIM_CR_ENABLE                LPTIM_CR_ENABLE_Msk                     /*!< LPTIMer enable */
#define LPTIM_CR_SNGSTRT_Pos           (1U)
#define LPTIM_CR_SNGSTRT_Msk           (0x1UL << LPTIM_CR_SNGSTRT_Pos)         /*!< 0x00000002 */
#define LPTIM_CR_SNGSTRT               LPTIM_CR_SNGSTRT_Msk                    /*!< Timer start in single mode */
#define LPTIM_CR_CNTSTRT_Pos           (2U)
#define LPTIM_CR_CNTSTRT_Msk           (0x1UL << LPTIM_CR_CNTSTRT_Pos)         /*!< 0x00000004 */
#define LPTIM_CR_CNTSTRT               LPTIM_CR_CNTSTRT_Msk                    /*!< Timer start in continuous mode */
#define LPTIM_CR_COUNTRST_Pos          (3U)
#define LPTIM_CR_COUNTRST_Msk          (0x1UL << LPTIM_CR_COUNTRST_Pos)        /*!< 0x00000008 */
#define LPTIM_CR_COUNTRST              LPTIM_CR_COUNTRST_Msk                   /*!< Timer Counter reset in synchronous mode*/
#define LPTIM_CR_RSTARE_Pos            (4U)
#define LPTIM_CR_RSTARE_Msk            (0x1UL << LPTIM_CR_RSTARE_Pos)          /*!< 0x00000010 */
#define LPTIM_CR_RSTARE                LPTIM_CR_RSTARE_Msk                     /*!< Timer Counter reset after read enable (asynchronously)*/
#define LPTIM_CCR1_CCR1_Pos            (0U)
#define LPTIM_CCR1_CCR1_Msk            (0xFFFFUL << LPTIM_CCR1_CCR1_Pos)       /*!< 0x0000FFFF */
#define LPTIM_CCR1_CCR1                LPTIM_CCR1_CCR1_Msk                     /*!< Compare register 1 */
#define LPTIM_ARR_ARR_Pos              (0U)
#define LPTIM_ARR_ARR_Msk              (0xFFFFUL << LPTIM_ARR_ARR_Pos)         /*!< 0x0000FFFF */
#define LPTIM_ARR_ARR                  LPTIM_ARR_ARR_Msk                       /*!< Auto reload register */
#define LPTIM_CNT_CNT_Pos              (0U)
#define LPTIM_CNT_CNT_Msk              (0xFFFFUL << LPTIM_CNT_CNT_Pos)         /*!< 0x0000FFFF */
#define LPTIM_CNT_CNT                  LPTIM_CNT_CNT_Msk                       /*!< Counter register */
#define LPTIM_CFGR2_IN1SEL_Pos         (0U)
#define LPTIM_CFGR2_IN1SEL_Msk         (0x3UL << LPTIM_CFGR2_IN1SEL_Pos)       /*!< 0x00000003 */
#define LPTIM_CFGR2_IN1SEL             LPTIM_CFGR2_IN1SEL_Msk                  /*!< IN1SEL[1:0] bits (Remap selection) */
#define LPTIM_CFGR2_IN1SEL_0           (0x1UL << LPTIM_CFGR2_IN1SEL_Pos)       /*!< 0x00000001 */
#define LPTIM_CFGR2_IN1SEL_1           (0x2UL << LPTIM_CFGR2_IN1SEL_Pos)       /*!< 0x00000002 */
#define LPTIM_CFGR2_IN2SEL_Pos         (4U)
#define LPTIM_CFGR2_IN2SEL_Msk         (0x3UL << LPTIM_CFGR2_IN2SEL_Pos)       /*!< 0x00000030 */
#define LPTIM_CFGR2_IN2SEL             LPTIM_CFGR2_IN2SEL_Msk                  /*!< IN2SEL[5:4] bits (Remap selection) */
#define LPTIM_CFGR2_IN2SEL_0           (0x1UL << LPTIM_CFGR2_IN2SEL_Pos)       /*!< 0x00000010 */
#define LPTIM_CFGR2_IN2SEL_1           (0x2UL << LPTIM_CFGR2_IN2SEL_Pos)       /*!< 0x00000020 */
#define LPTIM_CFGR2_IC1SEL_Pos         (16U)
#define LPTIM_CFGR2_IC1SEL_Msk         (0x3UL << LPTIM_CFGR2_IC1SEL_Pos)       /*!< 0x00000003 */
#define LPTIM_CFGR2_IC1SEL             LPTIM_CFGR2_IC1SEL_Msk                  /*!< IC1SEL[17:16] bits */
#define LPTIM_CFGR2_IC1SEL_0           (0x1UL << LPTIM_CFGR2_IC1SEL_Pos)       /*!< 0x00010000 */
#define LPTIM_CFGR2_IC1SEL_1           (0x2UL << LPTIM_CFGR2_IC1SEL_Pos)       /*!< 0x00020000 */
#define LPTIM_CFGR2_IC2SEL_Pos         (20U)
#define LPTIM_CFGR2_IC2SEL_Msk         (0x3UL << LPTIM_CFGR2_IC2SEL_Pos)       /*!< 0x00000030 */
#define LPTIM_CFGR2_IC2SEL             LPTIM_CFGR2_IC2SEL_Msk                  /*!< IC2SEL[21:20] bits */
#define LPTIM_CFGR2_IC2SEL_0           (0x1UL << LPTIM_CFGR2_IC2SEL_Pos)       /*!< 0x00100000 */
#define LPTIM_CFGR2_IC2SEL_1           (0x2UL << LPTIM_CFGR2_IC2SEL_Pos)       /*!< 0x00200000 */
#define LPTIM_RCR_REP_Pos              (0U)
#define LPTIM_RCR_REP_Msk              (0xFFUL << LPTIM_RCR_REP_Pos)           /*!< 0x000000FF */
#define LPTIM_RCR_REP                  LPTIM_RCR_REP_Msk                       /*!< Repetition register value */
#define LPTIM_CCMR1_CC1SEL_Pos         (0U)
#define LPTIM_CCMR1_CC1SEL_Msk         (0x1UL << LPTIM_CCMR1_CC1SEL_Pos)       /*!< 0x00000001 */
#define LPTIM_CCMR1_CC1SEL             LPTIM_CCMR1_CC1SEL_Msk                  /*!< Capture/Compare 1 selection */
#define LPTIM_CCMR1_CC1E_Pos           (1U)
#define LPTIM_CCMR1_CC1E_Msk           (0x1UL << LPTIM_CCMR1_CC1E_Pos)         /*!< 0x00000002 */
#define LPTIM_CCMR1_CC1E               LPTIM_CCMR1_CC1E_Msk                    /*!< Capture/Compare 1 output enable */
#define LPTIM_CCMR1_CC1P_Pos           (2U)
#define LPTIM_CCMR1_CC1P_Msk           (0x3UL << LPTIM_CCMR1_CC1P_Pos)         /*!< 0x0000000C */
#define LPTIM_CCMR1_CC1P               LPTIM_CCMR1_CC1P_Msk                    /*!< Capture/Compare 1 output polarity */
#define LPTIM_CCMR1_CC1P_0             (0x1UL << LPTIM_CCMR1_CC1P_Pos)         /*!< 0x00000004 */
#define LPTIM_CCMR1_CC1P_1             (0x2UL << LPTIM_CCMR1_CC1P_Pos)         /*!< 0x00000008 */
#define LPTIM_CCMR1_IC1PSC_Pos         (8U)
#define LPTIM_CCMR1_IC1PSC_Msk         (0x3UL << LPTIM_CCMR1_IC1PSC_Pos)       /*!< 0x00000300 */
#define LPTIM_CCMR1_IC1PSC             LPTIM_CCMR1_IC1PSC_Msk                  /*!< Input capture 1 prescaler */
#define LPTIM_CCMR1_IC1PSC_0           (0x1UL << LPTIM_CCMR1_IC1PSC_Pos)       /*!< 0x00000100 */
#define LPTIM_CCMR1_IC1PSC_1           (0x2UL << LPTIM_CCMR1_IC1PSC_Pos)       /*!< 0x00000200 */
#define LPTIM_CCMR1_IC1F_Pos           (12U)
#define LPTIM_CCMR1_IC1F_Msk           (0x3UL << LPTIM_CCMR1_IC1F_Pos)         /*!< 0x00003000 */
#define LPTIM_CCMR1_IC1F               LPTIM_CCMR1_IC1F_Msk                    /*!< Input capture 1 filter */
#define LPTIM_CCMR1_IC1F_0             (0x1UL << LPTIM_CCMR1_IC1F_Pos)         /*!< 0x00001000 */
#define LPTIM_CCMR1_IC1F_1             (0x2UL << LPTIM_CCMR1_IC1F_Pos)         /*!< 0x00002000 */
#define LPTIM_CCMR1_CC2SEL_Pos         (16U)
#define LPTIM_CCMR1_CC2SEL_Msk         (0x1UL << LPTIM_CCMR1_CC2SEL_Pos)       /*!< 0x00010000 */
#define LPTIM_CCMR1_CC2SEL             LPTIM_CCMR1_CC2SEL_Msk                  /*!< Capture/Compare 2 selection */
#define LPTIM_CCMR1_CC2E_Pos           (17U)
#define LPTIM_CCMR1_CC2E_Msk           (0x1UL << LPTIM_CCMR1_CC2E_Pos)         /*!< 0x00020000 */
#define LPTIM_CCMR1_CC2E               LPTIM_CCMR1_CC2E_Msk                    /*!< Capture/Compare 2 output enable */
#define LPTIM_CCMR1_CC2P_Pos           (18U)
#define LPTIM_CCMR1_CC2P_Msk           (0x3UL << LPTIM_CCMR1_CC2P_Pos)         /*!< 0x000C0000 */
#define LPTIM_CCMR1_CC2P               LPTIM_CCMR1_CC2P_Msk                    /*!< Capture/Compare 2 output polarity */
#define LPTIM_CCMR1_CC2P_0             (0x1UL << LPTIM_CCMR1_CC2P_Pos)         /*!< 0x00040000 */
#define LPTIM_CCMR1_CC2P_1             (0x2UL << LPTIM_CCMR1_CC2P_Pos)         /*!< 0x00080000 */
#define LPTIM_CCMR1_IC2PSC_Pos         (24U)
#define LPTIM_CCMR1_IC2PSC_Msk         (0x3UL << LPTIM_CCMR1_IC2PSC_Pos)       /*!< 0x03000000 */
#define LPTIM_CCMR1_IC2PSC             LPTIM_CCMR1_IC2PSC_Msk                  /*!< Input capture 2 prescaler */
#define LPTIM_CCMR1_IC2PSC_0           (0x1UL << LPTIM_CCMR1_IC2PSC_Pos)       /*!< 0x01000000 */
#define LPTIM_CCMR1_IC2PSC_1           (0x2UL << LPTIM_CCMR1_IC2PSC_Pos)       /*!< 0x02000000 */
#define LPTIM_CCMR1_IC2F_Pos           (28U)
#define LPTIM_CCMR1_IC2F_Msk           (0x3UL << LPTIM_CCMR1_IC2F_Pos)         /*!< 0x30000000 */
#define LPTIM_CCMR1_IC2F               LPTIM_CCMR1_IC2F_Msk                    /*!< Input capture 2 filter */
#define LPTIM_CCMR1_IC2F_0             (0x1UL << LPTIM_CCMR1_IC2F_Pos)         /*!< 0x10000000 */
#define LPTIM_CCMR1_IC2F_1             (0x2UL << LPTIM_CCMR1_IC2F_Pos)         /*!< 0x20000000 */
#define LPTIM_CCR2_CCR2_Pos            (0U)
#define LPTIM_CCR2_CCR2_Msk            (0xFFFFUL << LPTIM_CCR2_CCR2_Pos)       /*!< 0x0000FFFF */
#define LPTIM_CCR2_CCR2                LPTIM_CCR2_CCR2_Msk                     /*!< Compare register 2 */
