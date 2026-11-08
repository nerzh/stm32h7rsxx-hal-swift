#define S_JOIN_I(a,b) a##b
#define S_JOIN(a,b) S_JOIN_I(a,b)
#include "Upstream/SPDIFRXNamespace.h"
#include "SPDIFRXInternal.h"
#undef USE_HAL_SPDIFRX_REGISTER_CALLBACKS
#define USE_HAL_SPDIFRX_REGISTER_CALLBACKS S_MODE
#undef SPDIFRX
#define SPDIFRX (CSPDIFRX_Active->control[8]?&CSPDIFRX_Active->global:&CSPDIFRX_Active->regs)
#define assert_param(x) ((void)0)
#define SPDIFRX_TIMEOUT_VALUE 10U
#define SystemCoreClock (CSPDIFRX_Active->control[0])
#define HAL_GetTick() CSPDIFRX_Tick(CSPDIFRX_Active)
#define HAL_MAX_DELAY UINT32_MAX
typedef uint32_t FlagStatus;
#define DMA_LINKEDLIST 0x80U
#define DMA_LINKEDLIST_CIRCULAR 0x81U
#define NODE_CBR1_DEFAULT_OFFSET 2U
#define NODE_CSAR_DEFAULT_OFFSET 3U
#define NODE_CDAR_DEFAULT_OFFSET 4U
#define __HAL_DMA_DISABLE(d) CSPDIFRX_Disable(CSPDIFRX_Active,(d)==&CSPDIFRX_Active->dma[0]?0:1)
#if !S_MODE
#undef __HAL_SPDIFRX_RESET_HANDLE_STATE
#define __HAL_SPDIFRX_RESET_HANDLE_STATE(h) ((h)->State=HAL_SPDIFRX_STATE_RESET)
#endif
static void SPDIFRX_DMARxCplt(DMA_HandleTypeDef *);
static void SPDIFRX_DMARxHalfCplt(DMA_HandleTypeDef *);
static void SPDIFRX_DMACxCplt(DMA_HandleTypeDef *);
static void SPDIFRX_DMACxHalfCplt(DMA_HandleTypeDef *);
static void SPDIFRX_DMAError(DMA_HandleTypeDef *);
static void SPDIFRX_ReceiveControlFlow_IT(SPDIFRX_HandleTypeDef *);
static void SPDIFRX_ReceiveDataFlow_IT(SPDIFRX_HandleTypeDef *);
static HAL_StatusTypeDef SPDIFRX_WaitOnFlagUntilTimeout(SPDIFRX_HandleTypeDef *,uint32_t,FlagStatus,uint32_t,uint32_t);
static HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *d,uint32_t src,uint32_t dst,uint32_t size) { return CSPDIFRX_Start(CSPDIFRX_Active,d==&CSPDIFRX_Active->dma[0]?0:1,0,src,dst,size); }
static HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *d) { return CSPDIFRX_Start(CSPDIFRX_Active,d==&CSPDIFRX_Active->dma[0]?0:1,1,d->LinkedListQueue->Head->LinkRegisters[3],d->LinkedListQueue->Head->LinkRegisters[4],d->LinkedListQueue->Head->LinkRegisters[2]); }
// The DMA boundary normalizes these target-address truncations on the host.
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
