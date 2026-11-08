#ifndef CSMBUS_HAL_DEF_H
#define CSMBUS_HAL_DEF_H
#include <stdint.h>
#include <stddef.h>
#include "../CUARTReference/include/UARTDMAReferenceTypes.h"
typedef enum { DISABLE=0, ENABLE=1 } FunctionalState;
typedef enum { RESET=0, SET=1 } FlagStatus;
#define HAL_MAX_DELAY UINT32_MAX
#define __HAL_LOCK(h) do { if ((h)->Lock == HAL_LOCKED) { return HAL_BUSY; } else { (h)->Lock = HAL_LOCKED; } } while (0)
#define __HAL_UNLOCK(h) do { (h)->Lock = HAL_UNLOCKED; } while (0)
#endif
