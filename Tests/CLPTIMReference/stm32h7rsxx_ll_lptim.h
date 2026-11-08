/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Exact extracts from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define READ_BIT(REG,BIT) ((REG)&(BIT))
#define __STATIC_INLINE static inline
static const uint8_t LL_LPTIM_SHIFT_TAB_ICxF[] =
{
  0U,                              /* IC1F */
  16U                              /* IC2F */
};
static const uint8_t LL_LPTIM_OFFSET_TAB_ICx[8][4] =
{
  {2U, 7U, 9U, 13U},
  {3U, 5U, 6U, 8U},
  {2U, 3U, 4U, 5U},
  {2U, 2U, 3U, 3U},
  {2U, 2U, 2U, 2U},
  {2U, 2U, 2U, 2U},
  {2U, 2U, 2U, 2U},
  {2U, 2U, 2U, 2U}

};
#define LL_LPTIM_CHANNEL_CH1                  0x00000000U     /*!< LPTIM input/output channel 1 */
#define LL_LPTIM_CHANNEL_CH2                  0x00000001U     /*!< LPTIM input/output channel 2 */
#define LL_LPTIM_IC_GET_OFFSET(__PSC__, __FLT__) LL_LPTIM_OFFSET_TAB_ICx\
  [((__PSC__) & LPTIM_CFGR_PRESC_Msk) >> LPTIM_CFGR_PRESC_Pos]\
  [((__FLT__) & LPTIM_CCMR1_IC1F_Msk) >> LPTIM_CCMR1_IC1F_Pos]
__STATIC_INLINE uint32_t LL_LPTIM_GetPrescaler(const LPTIM_TypeDef *LPTIMx)
{
  return (uint32_t)(READ_BIT(LPTIMx->CFGR, LPTIM_CFGR_PRESC));
}
__STATIC_INLINE uint32_t LL_LPTIM_IC_GetFilter(const LPTIM_TypeDef *LPTIMx, uint32_t Channel)
{
  return (uint32_t)((READ_BIT(LPTIMx->CCMR1, LPTIM_CCMR1_IC1F << LL_LPTIM_SHIFT_TAB_ICxF[Channel])) >>                 \
                    LL_LPTIM_SHIFT_TAB_ICxF[Channel]);
}
