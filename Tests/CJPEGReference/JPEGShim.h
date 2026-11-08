#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/JPEGNamespace.h"
#include "JPEGInternal.h"
#undef USE_HAL_JPEG_REGISTER_CALLBACKS
#define USE_HAL_JPEG_REGISTER_CALLBACKS F_MODE
#define assert_param(x) ((void)0)
#define HAL_MAX_DELAY UINT32_MAX
#define HAL_GetTick() CJPEG_Tick(CJPEG_Active)
#define MODIFY_REG(reg,clear,set) ((reg)=(((reg)&~(clear))|(set)))
#define DMA_LINKEDLIST 0x80U
#define HAL_DMA_STATE_BUSY 2U
#define HAL_DMA_ERROR_NONE 0U
#define HAL_DMA_ERROR_TIMEOUT 0x10U
#define NODE_CBR1_DEFAULT_OFFSET 2U
#define NODE_CSAR_DEFAULT_OFFSET 3U
#define NODE_CDAR_DEFAULT_OFFSET 4U
#define __HAL_DMA_GET_COUNTER(d) (CJPEG_Active->meta[(d)-CJPEG_Active->dma][9])
#define HAL_DMAEx_GetFifoLevel(d) (CJPEG_Active->meta[(d)-CJPEG_Active->dma][10])
#define HAL_DMA_GetError(d) ((d)->ErrorCode)
#if !F_MODE
#undef __HAL_JPEG_RESET_HANDLE_STATE
#define __HAL_JPEG_RESET_HANDLE_STATE(h) ((h)->State=HAL_JPEG_STATE_RESET)
#endif
static HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *d,uint32_t src,uint32_t dst,uint32_t size) {return CJPEG_Start(CJPEG_Active,d-CJPEG_Active->dma,0,src,dst,size);}
static HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *d) {return CJPEG_Start(CJPEG_Active,d-CJPEG_Active->dma,1,d->LinkedListQueue->Head->LinkRegisters[3],d->LinkedListQueue->Head->LinkRegisters[4],d->LinkedListQueue->Head->LinkRegisters[2]);}
static HAL_StatusTypeDef HAL_DMA_Abort(DMA_HandleTypeDef *d) {return CJPEG_Abort(CJPEG_Active,d-CJPEG_Active->dma,0);}
static HAL_StatusTypeDef HAL_DMA_Abort_IT(DMA_HandleTypeDef *d) {return CJPEG_Abort(CJPEG_Active,d-CJPEG_Active->dma,1);}
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
#include "Upstream/JPEGPrivate.inc"
static HAL_StatusTypeDef JPEG_Bits_To_SizeCodes(const uint8_t *Bits, uint8_t *Huffsize, uint32_t *Huffcode,
                                                uint32_t *LastK);
static HAL_StatusTypeDef JPEG_DCHuff_BitsVals_To_SizeCodes(JPEG_DCHuffTableTypeDef *DC_BitsValsTable,
                                                           JPEG_DC_HuffCodeTableTypeDef *DC_SizeCodesTable);
static HAL_StatusTypeDef JPEG_ACHuff_BitsVals_To_SizeCodes(JPEG_ACHuffTableTypeDef *AC_BitsValsTable,
                                                           JPEG_AC_HuffCodeTableTypeDef *AC_SizeCodesTable);
static HAL_StatusTypeDef JPEG_Set_HuffDC_Mem(const JPEG_HandleTypeDef *hjpeg, JPEG_DCHuffTableTypeDef *HuffTableDC,
                                             const __IO uint32_t *DCTableAddress);
static HAL_StatusTypeDef JPEG_Set_HuffAC_Mem(const JPEG_HandleTypeDef *hjpeg, JPEG_ACHuffTableTypeDef *HuffTableAC,
                                             const __IO uint32_t *ACTableAddress);
static HAL_StatusTypeDef JPEG_Set_HuffEnc_Mem(JPEG_HandleTypeDef *hjpeg);
static void JPEG_Set_Huff_DHTMem(const JPEG_HandleTypeDef *hjpeg);
static uint32_t  JPEG_Set_Quantization_Mem(const JPEG_HandleTypeDef *hjpeg, const uint8_t *QTable,
                                           __IO uint32_t *QTableAddress);
static void JPEG_SetColorYCBCR(JPEG_HandleTypeDef *hjpeg);
static void JPEG_SetColorGrayScale(JPEG_HandleTypeDef *hjpeg);
static void JPEG_SetColorCMYK(JPEG_HandleTypeDef *hjpeg);
static void JPEG_Init_Process(JPEG_HandleTypeDef *hjpeg);
static uint32_t JPEG_Process(JPEG_HandleTypeDef *hjpeg);
static void JPEG_ReadInputData(JPEG_HandleTypeDef *hjpeg, uint32_t nbRequestWords);
static void JPEG_StoreOutputData(JPEG_HandleTypeDef *hjpeg, uint32_t nbOutputWords);
static uint32_t JPEG_GetQuality(const JPEG_HandleTypeDef *hjpeg);
static HAL_StatusTypeDef JPEG_DMA_StartProcess(JPEG_HandleTypeDef *hjpeg);
static void JPEG_DMA_ContinueProcess(JPEG_HandleTypeDef *hjpeg);
static void JPEG_DMA_EndProcess(JPEG_HandleTypeDef *hjpeg);
static void JPEG_DMA_PollResidualData(JPEG_HandleTypeDef *hjpeg);
static void JPEG_DMAOutCpltCallback(DMA_HandleTypeDef *hdma);
static void JPEG_DMAInCpltCallback(DMA_HandleTypeDef *hdma);
static void JPEG_DMAErrorCallback(DMA_HandleTypeDef *hdma);
static void JPEG_DMAOutAbortCallback(DMA_HandleTypeDef *hdma)  ;
