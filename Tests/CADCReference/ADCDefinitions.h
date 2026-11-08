#ifndef CADC_DEFINITIONS_H
#define CADC_DEFINITIONS_H
#include "stm32h7rsxx.h"
#include <string.h>
typedef struct {uint32_t SrcDataWidth;} DMA_InitTypeDef;
typedef struct {DMA_InitTypeDef Init;} DMA_NodeConfTypeDef;
typedef struct {uint32_t LinkRegisters[8];} DMA_NodeTypeDef;
typedef struct {DMA_NodeTypeDef *Head;} DMA_QListTypeDef;
typedef struct DMA_HandleTypeDef DMA_HandleTypeDef;
struct DMA_HandleTypeDef {
 DMA_InitTypeDef Init;uint32_t Mode,State;DMA_QListTypeDef *LinkedListQueue;void *Parent;
 void (*XferCpltCallback)(DMA_HandleTypeDef *);
 void (*XferHalfCpltCallback)(DMA_HandleTypeDef *);
 void (*XferErrorCallback)(DMA_HandleTypeDef *);
};
#define USE_HAL_ADC_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_adc.h"
#endif
