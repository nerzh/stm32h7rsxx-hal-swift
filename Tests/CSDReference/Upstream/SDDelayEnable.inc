// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

__STATIC_INLINE void LL_DLYB_Enable(DLYB_TypeDef *DLYBx)
{
  SET_BIT(DLYBx->CR, DLYB_CR_DEN);
}
