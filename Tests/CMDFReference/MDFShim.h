#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/MDFNamespace.h"
#include "MDFInternal.h"
#undef USE_HAL_MDF_REGISTER_CALLBACKS
#define USE_HAL_MDF_REGISTER_CALLBACKS F_MODE
#define ADF1 ((MDF_TypeDef *)CMDF_Active->regs)
#define assert_param(x) ((void)0)
#define HAL_MAX_DELAY UINT32_MAX
#define HAL_GetTick() CMDF_Tick(CMDF_Active)
#define DMA_LINKEDLIST 0x80U
#define DMA_LINKEDLIST_CIRCULAR 0x81U
#define NODE_CBR1_DEFAULT_OFFSET 2U
#define NODE_CSAR_DEFAULT_OFFSET 3U
#define NODE_CDAR_DEFAULT_OFFSET 4U
#if !F_MODE
#undef __HAL_MDF_RESET_HANDLE_STATE
#define __HAL_MDF_RESET_HANDLE_STATE(h) ((h)->State=HAL_MDF_STATE_RESET)
#endif
static MDF_HandleTypeDef *v_mdfHandle;
static void MDF_AcqStart(MDF_HandleTypeDef *const,const MDF_FilterConfigTypeDef *const);
static void MDF_DmaXferCpltCallback(DMA_HandleTypeDef *);
static void MDF_DmaXferHalfCpltCallback(DMA_HandleTypeDef *);
static void MDF_DmaErrorCallback(DMA_HandleTypeDef *);
static HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *d,uint32_t src,uint32_t dst,uint32_t size) {(void)d;return CMDF_Start(CMDF_Active,0,src,dst,size);}
static HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *d) {return CMDF_Start(CMDF_Active,1,d->LinkedListQueue->Head->LinkRegisters[3],d->LinkedListQueue->Head->LinkRegisters[4],d->LinkedListQueue->Head->LinkRegisters[2]);}
static HAL_StatusTypeDef HAL_DMA_Abort(DMA_HandleTypeDef *d) {(void)d;return CMDF_Abort(CMDF_Active);}
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
