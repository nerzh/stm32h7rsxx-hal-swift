/* Test boundary for the unchanged public HAL headers. */
#ifndef CPSSI_HAL_DEF_H
#define CPSSI_HAL_DEF_H
#include <stdint.h>
#include <stddef.h>
typedef enum { HAL_OK=0, HAL_ERROR=1, HAL_BUSY=2, HAL_TIMEOUT=3 } HAL_StatusTypeDef;
typedef enum { HAL_UNLOCKED=0, HAL_LOCKED=1 } HAL_LockTypeDef;
typedef enum { DISABLE=0, ENABLE=1 } FunctionalState;
#define __IO volatile
#define SET 1U
#define RESET 0U
#define __HAL_LOCK(h) do { if ((h)->Lock == HAL_LOCKED) { return HAL_BUSY; } else { (h)->Lock = HAL_LOCKED; } } while (0)
#define __HAL_UNLOCK(h) do { (h)->Lock = HAL_UNLOCKED; } while (0)
#endif
