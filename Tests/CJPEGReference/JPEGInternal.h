#ifndef CJPEG_INTERNAL_H
#define CJPEG_INTERNAL_H
#include "include/CJPEGReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define JPEG 1
#define USE_HAL_JPEG_REGISTER_CALLBACKS 1
#include "Upstream/JPEGBits.h"
typedef struct { uint32_t LinkRegisters[8]; } DMA_NodeTypeDef;
typedef struct { DMA_NodeTypeDef *Head; } DMA_QListTypeDef;
typedef struct DMA_HandleTypeDef DMA_HandleTypeDef;
struct DMA_HandleTypeDef {
 uint32_t Mode,State,ErrorCode; DMA_QListTypeDef *LinkedListQueue; void *Parent;
 void (*XferCpltCallback)(DMA_HandleTypeDef *);
 void (*XferErrorCallback)(DMA_HandleTypeDef *);
 void (*XferAbortCallback)(DMA_HandleTypeDef *);
};
#include "Upstream/stm32h7rsxx_hal_jpeg.h"
struct CJPEGState {
 JPEG_TypeDef regs; JPEG_HandleTypeDef h; JPEG_ConfTypeDef config,output;
 DMA_HandleTypeDef dma[2]; DMA_QListTypeDef queue[2]; DMA_NodeTypeDef node[2];
 uint8_t data[256],quant[4][64];
 uint32_t mode,control[16],meta[2][16],calls[12],tick,tickCalls,traceCount,trace[32][1536];
};
extern CJPEGState *CJPEG_Active;
pJPEG_CallbackTypeDef CJPEG_CallbackPointer(uint32_t,uint32_t);
pJPEG_InfoReadyCallbackTypeDef CJPEG_InfoPointer(uint32_t);
pJPEG_GetDataCallbackTypeDef CJPEG_GetPointer(uint32_t);
pJPEG_DataReadyCallbackTypeDef CJPEG_DataPointer(uint32_t);
uint32_t CJPEG0_Run(CJPEGState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CJPEG1_Run(CJPEGState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CJPEG0_SetDMA(CJPEGState *,uint32_t,uint32_t,uint32_t);
void CJPEG1_SetDMA(CJPEGState *,uint32_t,uint32_t,uint32_t);
uint32_t CJPEG0_GetDMA(CJPEGState *,uint32_t,uint32_t);
uint32_t CJPEG1_GetDMA(CJPEGState *,uint32_t,uint32_t);
#endif
