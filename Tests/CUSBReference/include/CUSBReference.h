#ifndef CUSB_REFERENCE_H
#define CUSB_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CUSBState CUSBState;
size_t CUSB_Size(void);
void CUSB_Reset(CUSBState *,uint32_t);
uint32_t *CUSB_Registers(CUSBState *);
uint32_t *CUSB_Control(CUSBState *);
uint32_t *CUSB_Trace(CUSBState *);
uint8_t *CUSB_Buffer(CUSBState *);
uint32_t CUSB_Run(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CUSB_DelayFor(CUSBState *,uint32_t);
uint32_t CUSB_Constant(uint32_t);
uint32_t CUSB_GetConfiguration(CUSBState *,uint32_t);
void CUSB_SetConfiguration(CUSBState *,uint32_t,uint32_t);
uint32_t CUSB_GetEndpoint(CUSBState *,uint32_t);
void CUSB_SetEndpoint(CUSBState *,uint32_t,uint32_t);
uint32_t CUSB_GetChannel(CUSBState *,uint32_t);
void CUSB_SetChannel(CUSBState *,uint32_t,uint32_t);
uint8_t *CUSB_GetEndpointBuffer(CUSBState *);
void CUSB_SetEndpointBuffer(CUSBState *,uint8_t *);
uint8_t *CUSB_GetChannelBuffer(CUSBState *);
void CUSB_SetChannelBuffer(CUSBState *,uint8_t *);
uint32_t CUSB_Compare(CUSBState *,CUSBState *);
void CUSB_PCDReset(CUSBState *,uint32_t);
void *CUSB_PCDContext(CUSBState *);
uint8_t *CUSB_PCDSetup(CUSBState *);
uint32_t CUSB_PCDGetWord(CUSBState *,uint32_t);
void CUSB_PCDSetWord(CUSBState *,uint32_t,uint32_t);
uint32_t CUSB_PCDGetConfiguration(CUSBState *,uint32_t);
void CUSB_PCDSetConfiguration(CUSBState *,uint32_t,uint32_t);
uint8_t *CUSB_PCDEndpointBuffer(CUSBState *,uint32_t,uint32_t);
void CUSB_PCDSetEndpointBuffer(CUSBState *,uint32_t,uint32_t,uint8_t *);
uint32_t CUSB_PCDEndpointWord(CUSBState *,uint32_t,uint32_t,uint32_t);
void CUSB_PCDSetEndpointWord(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
uintptr_t CUSB_PCDGetCallback(CUSBState *,uint32_t);
void CUSB_PCDSetCallback(CUSBState *,uint32_t,uintptr_t);
uintptr_t CUSB_PCDCallback(uint32_t,uint32_t);
uint32_t CUSB_PCDRun(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSB_PCDCompare(CUSBState *,CUSBState *);
void CUSB_HCDReset(CUSBState *,uint32_t,uint32_t);
void *CUSB_HCDContext(CUSBState *);
uint32_t CUSB_HCDGetWord(CUSBState *,uint32_t);
void CUSB_HCDSetWord(CUSBState *,uint32_t,uint32_t);
uint32_t CUSB_HCDGetConfiguration(CUSBState *,uint32_t);
void CUSB_HCDSetConfiguration(CUSBState *,uint32_t,uint32_t);
uint8_t *CUSB_HCDChannelBuffer(CUSBState *,uint32_t);
void CUSB_HCDSetChannelBuffer(CUSBState *,uint32_t,uint8_t *);
uint32_t CUSB_HCDChannelWord(CUSBState *,uint32_t,uint32_t);
void CUSB_HCDSetChannelWord(CUSBState *,uint32_t,uint32_t,uint32_t);
uintptr_t CUSB_HCDGetCallback(CUSBState *,uint32_t);
void CUSB_HCDSetCallback(CUSBState *,uint32_t,uintptr_t);
uintptr_t CUSB_HCDCallback(uint32_t,uint32_t);
uint32_t CUSB_HCDRun(CUSBState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSB_HCDCompare(CUSBState *,CUSBState *);
#endif
