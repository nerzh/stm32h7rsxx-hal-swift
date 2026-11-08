#ifndef CXSPI_REFERENCE_H
#define CXSPI_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CXSPIState CXSPIState;
size_t CXSPI_Size(void);
void CXSPI_Reset(CXSPIState *,uint32_t);
uint32_t CXSPI_Get(CXSPIState *,uint32_t,uint32_t);
void CXSPI_Set(CXSPIState *,uint32_t,uint32_t,uint32_t);
uint8_t *CXSPI_Buffer(CXSPIState *,uint32_t);
uintptr_t CXSPI_GetPointer(CXSPIState *,uint32_t);
void CXSPI_SetPointer(CXSPIState *,uint32_t,uintptr_t);
uintptr_t CXSPI_Callback(uint32_t,uint32_t);
uintptr_t CXSPI_GetCallback(CXSPIState *,uint32_t);
void CXSPI_SetCallback(CXSPIState *,uint32_t,uintptr_t);
uint32_t CXSPI_Run(CXSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CXSPI_Activate(CXSPIState *);
uint32_t CXSPI_TickFor(CXSPIState *);
uint32_t CXSPI_ClockFor(CXSPIState *,uint32_t);
uint32_t CXSPI_RecordDMA(CXSPIState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CXSPI_Compare(CXSPIState *,CXSPIState *);
uint32_t CXSPI_Constant(uint32_t);
uint32_t CXSPI_ReadRegister(CXSPIState *,uint32_t,uint32_t,uint32_t);
void CXSPI_WriteRegister(CXSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
