/* Test-only hardware and already-verified DMA boundary bindings. */
#include "UARTInternal.h"
#include <assert.h>
#define CUART_JOIN_INNER(a,b) a##b
#define CUART_JOIN(a,b) CUART_JOIN_INNER(a,b)
#include "Upstream/UARTNamespace.h"
#define USE_HAL_UART_REGISTER_CALLBACKS CUART_CALLBACK_MODE
#define __IO volatile
#ifdef __weak
#undef __weak
#endif
#define __weak __attribute__((weak))
#define assert_param(expression) assert(expression)
#include "Upstream/UARTHALMacros.h"
#define READ_REG(reg) CUART_ReadAddress(&(reg))
#define WRITE_REG(reg,value) CUART_WriteAddress(&(reg),(uint32_t)(value))
#define READ_BIT(reg,mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) | (mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg) & ~(clear)) | (set))
#define __LDREXW(address) CUART_ExclusiveLoad(address)
#define __STREXW(value,address) CUART_ExclusiveStore(value,address)
#include "Upstream/UARTBits.h"
#include "Upstream/DMABits.h"
#include "Upstream/DMAMacros.h"
#include "Upstream/DMA_EXMacros.h"
#define USART1 CUART_InstanceAddress(0x42001000U)
#define USART2 CUART_InstanceAddress(0x40004400U)
#define USART3 CUART_InstanceAddress(0x40004800U)
#define UART4 CUART_InstanceAddress(0x40004C00U)
#define UART5 CUART_InstanceAddress(0x40005000U)
#define UART7 CUART_InstanceAddress(0x40007800U)
#define UART8 CUART_InstanceAddress(0x40007C00U)
#define LPUART1 CUART_InstanceAddress(0x58000C00U)
#include "Upstream/UARTInstanceChecks.h"
#include "Upstream/UARTClockConstants.h"
#define __HAL_RCC_GET_USART1_SOURCE() (CUART_Active->clockSelections[0] << RCC_CCIPR3_USART1SEL_Pos)
#define __HAL_RCC_GET_USART234578_SOURCE() (CUART_Active->clockSelections[1] << RCC_CCIPR2_UART234578SEL_Pos)
#define __HAL_RCC_GET_LPUART1_SOURCE() (CUART_Active->clockSelections[2] << RCC_CCIPR4_LPUART1SEL_Pos)
#define __HAL_RCC_GET_FLAG(flag) (CUART_Active->hsiDividerReady)
#define __HAL_RCC_GET_HSI_DIVIDER() (CUART_Active->hsiDivider)
#define HSI_VALUE (CUART_Active->clockFrequencies[5])
#define CSI_VALUE (CUART_Active->clockFrequencies[6])
#define LSE_VALUE (CUART_Active->clockFrequencies[7])
#define HAL_RCC_GetPCLK1Freq() (CUART_Active->clockFrequencies[0])
#define HAL_RCC_GetPCLK2Freq() (CUART_Active->clockFrequencies[1])
#define HAL_RCC_GetPCLK4Freq() (CUART_Active->clockFrequencies[2])
#define HAL_RCC_GetPLL2QFreq() (CUART_Active->clockFrequencies[3])
#define HAL_RCC_GetPLL3QFreq() (CUART_Active->clockFrequencies[4])
#define HAL_GetTick() CUART_Tick(CUART_Active)
#define HAL_DMA_Start_IT CUART_DMAStart
#define HAL_DMAEx_List_Start_IT CUART_DMAListStart
#define HAL_DMA_Abort CUART_DMAAbortCall
#define HAL_DMA_Abort_IT CUART_DMAAbortITCall
#define HAL_DMAEx_Suspend CUART_DMASuspendCall
#define HAL_DMAEx_Resume CUART_DMAResumeCall
#define HAL_DMA_GetError CUART_DMAGetError
#include "Upstream/UARTExMacros.h"
#include "Upstream/UARTMacros.h"
typedef void (*pUART_CallbackTypeDef)(UART_HandleTypeDef *);
typedef void (*pUART_RxEventCallbackTypeDef)(UART_HandleTypeDef *, uint16_t);
#include "Upstream/UARTPrototypes.inc"
/* Native host pointers are intentionally truncated by the unchanged C body;
 * the boundary recorder converts known buffers/registers to logical addresses. */
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
