#ifndef CADC_REFERENCE_H
#define CADC_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CADCState CADCState;
size_t CADC_Size(void);
void CADC_Reset(CADCState *,uint32_t,uint32_t);
void CADC_Activate(CADCState *);
uint32_t CADC_Get(CADCState *,uint32_t,uint32_t);
void CADC_Set(CADCState *,uint32_t,uint32_t,uint32_t);
uint32_t CADC_ReadRegister(CADCState *,uint32_t,uint32_t);
uint32_t CADC_GetCallback(CADCState *,uint32_t);
void CADC_SetCallback(CADCState *,uint32_t,uint32_t);
void CADC_Callback(CADCState *,uint32_t,uint32_t);
uint32_t CADC_TickFor(CADCState *);
uint32_t CADC_Run(CADCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CADC_DMAAction(CADCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CADC_DMADataAddress(CADCState *,uint32_t);
uint32_t CADC_Constant(uint32_t);
uint32_t CADC_Mode(CADCState *);
uint32_t CADC_GetDMACallback(CADCState *,uint32_t);
void CADC_SetDMACallback(CADCState *,uint32_t,uint32_t);
void CADC_SetFactory(uint32_t,uint16_t);
uint32_t CADC_Macro(uint32_t,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
