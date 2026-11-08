#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/SMARTCARDNamespace.h"
#include "SMARTCARDInternal.h"
#undef USE_HAL_SMARTCARD_REGISTER_CALLBACKS
#define USE_HAL_SMARTCARD_REGISTER_CALLBACKS F_MODE
#define assert_param(x) ((void)0)
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
#define READ_BIT(r,m) ((r)&(m))
#define SET_BIT(r,m) ((r)|=(m))
#define CLEAR_BIT(r,m) ((r)&=~(m))
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#define HAL_IS_BIT_SET(r,m) (((r)&(m))==(m))
#define HAL_IS_BIT_CLR(r,m) (((r)&(m))==0U)
#define UNUSED(x) ((void)(x))
#define HAL_GetTick() CSMARTCARD_Tick()
#define USART1 CSMARTCARD_Instance(0x42001000U)
#define USART2 CSMARTCARD_Instance(0x40004400U)
#define USART3 CSMARTCARD_Instance(0x40004800U)
#include "../CUARTReference/Upstream/UARTClockConstants.h"
#define __HAL_RCC_GET_USART1_SOURCE() (CSMARTCARD_Active->control[5] << RCC_CCIPR3_USART1SEL_Pos)
#define __HAL_RCC_GET_USART234578_SOURCE() (CSMARTCARD_Active->control[5] << RCC_CCIPR2_UART234578SEL_Pos)
#define __HAL_RCC_GET_FLAG(f) (CSMARTCARD_Active->control[6])
#define __HAL_RCC_GET_HSI_DIVIDER() (CSMARTCARD_Active->control[7])
#define HSI_VALUE (CSMARTCARD_Active->control[4])
#define CSI_VALUE (CSMARTCARD_Active->control[4])
#define LSE_VALUE (CSMARTCARD_Active->control[4])
#define HAL_RCC_GetPCLK1Freq() (CSMARTCARD_Active->control[4])
#define HAL_RCC_GetPCLK2Freq() (CSMARTCARD_Active->control[4])
#define HAL_RCC_GetPLL2QFreq() (CSMARTCARD_Active->control[4])
#define HAL_RCC_GetPLL3QFreq() (CSMARTCARD_Active->control[4])
#define HAL_DMA_Start_IT CSMARTCARD_DMAStart
#define HAL_DMAEx_List_Start_IT CSMARTCARD_DMAList
#define HAL_DMA_Abort CSMARTCARD_DMAAbort
#define HAL_DMA_Abort_IT CSMARTCARD_DMAAbortIT
#define HAL_DMAEx_Suspend CSMARTCARD_DMASuspend
#define HAL_DMAEx_Resume CSMARTCARD_DMAResume
#define HAL_DMA_GetError(h) ((h)->ErrorCode)
#include "SMARTCARDPrivate.h"
#include "SMARTCARDPrototypes.h"
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
