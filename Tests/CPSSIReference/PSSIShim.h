#define P_JOIN_I(a,b) a##b
#define P_JOIN(a,b) P_JOIN_I(a,b)
#include "Upstream/PSSINamespace.h"
#include "PSSIInternal.h"
#undef USE_HAL_PSSI_REGISTER_CALLBACKS
#define USE_HAL_PSSI_REGISTER_CALLBACKS P_MODE
#if !P_DMA
#undef HAL_DMA_MODULE_ENABLED
#endif
#define assert_param(x) ((void)0)
#define UNUSED(x) ((void)(x))
#define MODIFY_REG(reg,clear,set) ((reg)=((reg)&~(clear))|(set))
#define HAL_MAX_DELAY UINT32_MAX
typedef uint32_t FlagStatus;
#define DMA_DEST_DATAWIDTH_BYTE 0U
#define DMA_SRC_DATAWIDTH_BYTE 0U
#define DMA_LINKEDLIST 0x80U
#define NODE_CBR1_DEFAULT_OFFSET 2U
#define NODE_CSAR_DEFAULT_OFFSET 3U
#define NODE_CDAR_DEFAULT_OFFSET 4U
#define HAL_GetTick() CPSSI_Tick(CPSSI_Active)
#if !P_MODE
#undef HAL_PSSI_RESET_HANDLE_STATE
#define HAL_PSSI_RESET_HANDLE_STATE(h) ((h)->State = HAL_PSSI_STATE_RESET)
#endif
static void PSSI_Error(PSSI_HandleTypeDef *,uint32_t);
static HAL_StatusTypeDef PSSI_WaitOnStatusUntilTimeout(PSSI_HandleTypeDef *,uint32_t,FlagStatus,uint32_t,uint32_t);
#if P_DMA
void PSSI_DMATransmitCplt(DMA_HandleTypeDef *);
void PSSI_DMAReceiveCplt(DMA_HandleTypeDef *);
void PSSI_DMAError(DMA_HandleTypeDef *);
void PSSI_DMAAbort(DMA_HandleTypeDef *);
static HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *d,uint32_t src,uint32_t dst,uint32_t size) { return CPSSI_Start(CPSSI_Active,d==&CPSSI_Active->dma[0]?0:1,0,src,dst,size); }
static HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *d) { return CPSSI_Start(CPSSI_Active,d==&CPSSI_Active->dma[0]?0:1,1,d->LinkedListQueue->Head->LinkRegisters[3],d->LinkedListQueue->Head->LinkRegisters[4],d->LinkedListQueue->Head->LinkRegisters[2]); }
static HAL_StatusTypeDef HAL_DMA_Abort_IT(DMA_HandleTypeDef *d) {
 uint32_t dir=d==&CPSSI_Active->dma[0]?0:1;
 uint32_t result=CPSSI_Abort(CPSSI_Active,dir);
 if(CPSSI_Active->meta[dir][14] && result==HAL_OK && d->XferAbortCallback)d->XferAbortCallback(d);
 return result;
}
#endif
// Target-address casts intentionally truncate host pointers in the unchanged bodies.
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
