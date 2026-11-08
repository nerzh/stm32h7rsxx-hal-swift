#ifndef CUSB_HAL_DEF_H
#define CUSB_HAL_DEF_H
#include <stdint.h>
#include <stddef.h>
#define __IO volatile
#define __I volatile const
#define __O volatile
#undef __weak
#define __weak
#define __STATIC_INLINE static inline
#define __HAL_LOCK(h) do {if ((h)->Lock == HAL_LOCKED) return HAL_BUSY; (h)->Lock = HAL_LOCKED;} while(0)
#define __HAL_UNLOCK(h) ((h)->Lock = HAL_UNLOCKED)
typedef enum {HAL_OK=0,HAL_ERROR=1,HAL_BUSY=2,HAL_TIMEOUT=3} HAL_StatusTypeDef;
typedef enum {HAL_UNLOCKED=0,HAL_LOCKED=1} HAL_LockTypeDef;
typedef enum {DISABLE=0,ENABLE=1} FunctionalState;
typedef enum {RESET=0,SET=1} FlagStatus, ITStatus;
#endif
