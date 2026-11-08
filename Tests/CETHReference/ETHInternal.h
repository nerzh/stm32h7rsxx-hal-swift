#ifndef CETH_INTERNAL_H
#define CETH_INTERNAL_H
#include "include/CETHReference.h"
#include "ETHDefinitions.h"
#include <assert.h>
#include <string.h>
struct CETHState {
 ETH_HandleTypeDef h;
 ETH_TypeDef registers;
 ETH_TypeDef globalRegisters;
 ETH_DMADescTypeDef tx[8],rx[8];
 uint32_t buffers[16][64];
 uint8_t mac[8];
 ETH_TxPacketConfigTypeDef packet;
 ETH_BufferTypeDef links[8];
 ETH_MACConfigTypeDef configuration0;
 ETH_DMAConfigTypeDef configuration1;
 ETH_PTP_ConfigTypeDef configuration2;
 ETH_MACFilterConfigTypeDef configuration3;
 ETH_PowerDownConfigTypeDef configuration4;
 ETH_RxVLANConfigTypeDef configuration5;
 ETH_TxVLANConfigTypeDef configuration6;
 ETH_L3FilterConfigTypeDef configuration7;
 ETH_L4FilterConfigTypeDef configuration8;
 ETH_TimeStampTypeDef configuration9;
 ETH_TimeTypeDef configuration10;
 uint32_t exti[5];
 uint32_t control[64];
 uint32_t trace[2048];
 uint32_t events[32][4];
};
#if defined(__arm__) || defined(__thumb__)
#define CETH_THREAD_LOCAL
#else
#define CETH_THREAD_LOCAL _Thread_local
#endif
extern CETH_THREAD_LOCAL CETHState *CETH_Active;
extern struct CETH_SBS {volatile uint32_t PMCR;} CETH_SBS;
extern struct CETH_EXTI {volatile uint32_t IMR2, PR2, FTSR2, RTSR2, SWIER2;} CETH_EXTI;
uint32_t CETH_Tick(void);
uint32_t CETH_HCLK(void);
void CETH_EnableSBS(void);
void CETH_ConfigurePHY(uint32_t);
void CETH_Barrier(uint32_t);
void CETH_SetMask(uint32_t);
uint32_t CETH003_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH004_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH008_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH013_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH014_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH018_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH103_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH104_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH108_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH113_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH114_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CETH118_Run(CETHState *,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
