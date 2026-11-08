#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/IRDANamespace.h"
#include "IRDAInternal.h"
#undef USE_HAL_IRDA_REGISTER_CALLBACKS
#define USE_HAL_IRDA_REGISTER_CALLBACKS F_MODE
#define assert_param(x) ((void)0)
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
#define READ_BIT(r,m) ((r)&(m))
#define SET_BIT(r,m) ((r)|=(m))
#define CLEAR_BIT(r,m) ((r)&=~(m))
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#define HAL_IS_BIT_SET(r,m) (((r)&(m))==(m))
#define UNUSED(x) ((void)(x))
#define HAL_GetTick() CIRDA_Tick()
#define USART1 CIRDA_Instance(0x42001000U)
#define USART2 CIRDA_Instance(0x40004400U)
#define USART3 CIRDA_Instance(0x40004800U)
#include "../CUARTReference/Upstream/UARTClockConstants.h"
#define __HAL_RCC_GET_USART1_SOURCE() (CIRDA_Active->control[5] << RCC_CCIPR3_USART1SEL_Pos)
#define __HAL_RCC_GET_USART234578_SOURCE() (CIRDA_Active->control[5] << RCC_CCIPR2_UART234578SEL_Pos)
#define __HAL_RCC_GET_FLAG(f) (CIRDA_Active->control[6])
#define __HAL_RCC_GET_HSI_DIVIDER() (CIRDA_Active->control[7])
#define HSI_VALUE (CIRDA_Active->control[4])
#define CSI_VALUE (CIRDA_Active->control[4])
#define LSE_VALUE (CIRDA_Active->control[4])
#define HAL_RCC_GetPCLK1Freq() (CIRDA_Active->control[4])
#define HAL_RCC_GetPCLK2Freq() (CIRDA_Active->control[4])
#define HAL_RCC_GetPLL2QFreq() (CIRDA_Active->control[4])
#define HAL_RCC_GetPLL3QFreq() (CIRDA_Active->control[4])
#define HAL_DMA_Start_IT CIRDA_DMAStart
#define HAL_DMAEx_List_Start_IT CIRDA_DMAList
#define HAL_DMA_Abort CIRDA_DMAAbort
#define HAL_DMA_Abort_IT CIRDA_DMAAbortIT
#define HAL_DMAEx_Suspend CIRDA_DMASuspend
#define HAL_DMAEx_Resume CIRDA_DMAResume
#define HAL_DMA_GetError(h) ((h)->ErrorCode)
#include "IRDAPrivate.h"
#include "IRDAPrototypes.h"
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif

#define UART4 CIRDA_Instance(0x40004C00U)
#define UART5 CIRDA_Instance(0x40005000U)
#define UART7 CIRDA_Instance(0x40007800U)
#define UART8 CIRDA_Instance(0x40007C00U)
