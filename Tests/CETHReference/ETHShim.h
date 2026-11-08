#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/ETHNamespace.h"
#include "ETHInternal.h"
#undef USE_HAL_ETH_REGISTER_CALLBACKS
#define USE_HAL_ETH_REGISTER_CALLBACKS F_CALLBACKS
#if !F_PTP
#undef HAL_ETH_USE_PTP
#endif
#undef ETH_TX_DESC_CNT
#undef ETH_RX_DESC_CNT
#define ETH_TX_DESC_CNT F_RING
#define ETH_RX_DESC_CNT F_RING
#define assert_param(x) ((void)0)
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
#define READ_BIT(r,m) ((r)&(m))
#define SET_BIT(r,m) ((r)|=(m))
#define CLEAR_BIT(r,m) ((r)&=~(m))
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#define UNUSED(x) ((void)(x))
#define HAL_GetTick() CETH_Tick()
#define HAL_RCC_GetHCLKFreq() CETH_HCLK()
#define __HAL_RCC_SBS_CLK_ENABLE() CETH_EnableSBS()
#define HAL_SBS_ConfigEthernetPHY CETH_ConfigurePHY
#define SBS_ETHERNET_PHY_GMII_OR_MII 0U
#define SBS_ETHERNET_PHY_RMII 0x800000U
#define SBS (&CETH_SBS)
#define EXTI (&CETH_EXTI)
#undef ETH
#define ETH (CETH_Active->control[9] ? &CETH_Active->globalRegisters : &CETH_Active->registers)
#define __DMB() CETH_Barrier(100)
#define __DSB() CETH_Barrier(101)
#define __get_PRIMASK() (CETH_Active->control[6])
#define __set_PRIMASK(v) CETH_SetMask(v)
#if !F_CALLBACKS
#undef __HAL_ETH_RESET_HANDLE_STATE
#define __HAL_ETH_RESET_HANDLE_STATE(h) ((h)->gState=HAL_ETH_STATE_RESET)
#endif
#include "ETHPrivate.h"
#include "ETHPrototypes.h"
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
