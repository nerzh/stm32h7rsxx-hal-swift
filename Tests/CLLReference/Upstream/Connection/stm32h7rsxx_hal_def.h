#pragma once
#include "stm32h7rsxx.h"
#define assert_param(expr) ((void)0U)
typedef enum {HAL_OK=0, HAL_ERROR=1, HAL_BUSY=2, HAL_TIMEOUT=3} HAL_StatusTypeDef;
uint32_t HAL_GetTick(void);
