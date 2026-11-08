#ifndef CSPI_REFERENCE_H
#define CSPI_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSPIState CSPIState;
size_t CSPI_Size(void);
void CSPI_Reset(CSPIState *,uint32_t);
uint32_t CSPI_Get(CSPIState *,uint32_t,uint32_t);
void CSPI_Set(CSPIState *,uint32_t,uint32_t,uint32_t);
uint8_t *CSPI_Buffer(CSPIState *,uint32_t);
uintptr_t CSPI_GetPointer(CSPIState *,uint32_t);
void CSPI_SetPointer(CSPIState *,uint32_t,uintptr_t);
uintptr_t CSPI_Callback(uint32_t,uint32_t);
uintptr_t CSPI_GetCallback(CSPIState *,uint32_t);
void CSPI_SetCallback(CSPIState *,uint32_t,uintptr_t);
uint32_t CSPI_Run(CSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CSPI_Activate(CSPIState *);
uint32_t CSPI_TickFor(CSPIState *);
uint32_t CSPI_ClockFor(CSPIState *,uint32_t);
uint32_t CSPI_RecordDMA(CSPIState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSPI_Compare(CSPIState *,CSPIState *);
uint32_t CSPI_Constant(uint32_t);
uint32_t CSPI_ReadRegister(CSPIState *,uint32_t,uint32_t);
void CSPI_WriteRegister(CSPIState *,uint32_t,uint32_t,uint32_t);
#endif
