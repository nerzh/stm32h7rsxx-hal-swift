#ifndef C_GPIO_REFERENCE_HAL_DEF_H
#define C_GPIO_REFERENCE_HAL_DEF_H

#include "../include/CGPIOReference.h"

typedef CGPIOReferenceGPIO GPIO_TypeDef;
typedef enum { HAL_OK = 0, HAL_ERROR = 1, HAL_BUSY = 2, HAL_TIMEOUT = 3 } HAL_StatusTypeDef;

#define __IO volatile
#ifdef __weak
#undef __weak
#endif
#define __weak __attribute__((weak))
#define UNUSED(value) ((void)(value))
/* Match the upstream default build without USE_FULL_ASSERT. */
#define assert_param(expression) ((void)0)

#endif
