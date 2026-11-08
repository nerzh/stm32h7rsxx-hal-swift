#ifndef CSDMMC_HAL_DEF_H
#define CSDMMC_HAL_DEF_H
#include <stdint.h>
#include <stddef.h>
typedef enum {HAL_OK=0,HAL_ERROR=1,HAL_BUSY=2,HAL_TIMEOUT=3} HAL_StatusTypeDef;
typedef enum {HAL_UNLOCKED=0,HAL_LOCKED=1} HAL_LockTypeDef;
typedef enum {RESET=0,SET=1} FlagStatus;
#define __STATIC_INLINE static inline
#define __IO volatile
#define __I volatile const
#define assert_param(x) ((void)0)
#define UNUSED(x) ((void)(x))
#define HAL_MAX_DELAY UINT32_MAX
#endif
