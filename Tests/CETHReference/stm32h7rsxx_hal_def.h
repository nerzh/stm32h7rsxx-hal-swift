#ifndef CETH_HAL_DEF_H
#define CETH_HAL_DEF_H
#include <stdint.h>
#include <stddef.h>
#define __IO volatile
#define __I volatile const
#define __O volatile
#undef __weak
#define __weak
#define __STATIC_INLINE static inline
#define __HAL_LOCK(h) ((void)0)
#define __HAL_UNLOCK(h) ((void)0)
typedef enum {HAL_OK=0,HAL_ERROR=1,HAL_BUSY=2,HAL_TIMEOUT=3} HAL_StatusTypeDef;
typedef enum {HAL_UNLOCKED=0,HAL_LOCKED=1} HAL_LockTypeDef;
typedef enum {DISABLE=0,ENABLE=1} FunctionalState;
typedef enum {RESET=0,SET=1} FlagStatus, ITStatus;
#endif
