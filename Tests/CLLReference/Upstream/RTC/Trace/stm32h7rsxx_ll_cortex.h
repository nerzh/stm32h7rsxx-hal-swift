// Copyright (c) 2022 STMicroelectronics. SPDX-License-Identifier: BSD-3-Clause
#pragma once
#include "stm32h7rsxx.h"
__STATIC_INLINE uint32_t LL_SYSTICK_IsActiveCounterFlag(void)
{
  return (((CL57_Read(CL57_Cells+224) & 0x10000UL) == (0x10000UL)) ? 1UL : 0UL);
}
