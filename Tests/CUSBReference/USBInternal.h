#ifndef CUSB_INTERNAL_H
#define CUSB_INTERNAL_H
#include "include/CUSBReference.h"
#include "USBDefinitions.h"
#include <string.h>
#include <assert.h>
struct CUSBState {
 PCD_HandleTypeDef pcd;
 HCD_HandleTypeDef hcd;
 uint32_t registers[0x4400];
 USB_CfgTypeDef configuration;
 USB_EPTypeDef endpoint;
 USB_HCTypeDef channel;
 uint8_t buffer[4096];
 uint32_t control[64],trace[256],delays[256];
};
#if defined(__arm__) || defined(__thumb__)
#define CUSB_THREAD_LOCAL
#else
#define CUSB_THREAD_LOCAL _Thread_local
#endif
extern CUSB_THREAD_LOCAL CUSBState *CUSB_Active;
void CUSB_Delay(uint32_t);
uint32_t CUSB_PCDTick(void);
uint32_t CUSB_PCDHCLK(void);
uint32_t CUSB_PCD0Run(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSB_PCD1Run(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSB_HCD00Run(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSB_HCD01Run(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSB_HCD10Run(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSB_HCD11Run(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
