/* Test boundary for the unchanged public HAL headers. */
#ifndef CLPTIM_HAL_DEF_H
#define CLPTIM_HAL_DEF_H
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
typedef struct { uint32_t LinkRegisters[8]; } DMA_NodeTypeDef;
typedef struct { DMA_NodeTypeDef *Head; } DMA_QListTypeDef;
typedef struct DMA_HandleTypeDef {
 uint32_t Mode; DMA_QListTypeDef *LinkedListQueue; void *Parent;
 void (*XferCpltCallback)(struct DMA_HandleTypeDef *);
 void (*XferHalfCpltCallback)(struct DMA_HandleTypeDef *);
 void (*XferErrorCallback)(struct DMA_HandleTypeDef *);
} DMA_HandleTypeDef;
#define DMA_LINKEDLIST 0x80U
#define NODE_CBR1_DEFAULT_OFFSET 2U
#define NODE_CSAR_DEFAULT_OFFSET 3U
#define NODE_CDAR_DEFAULT_OFFSET 4U
#endif
