#ifndef CMDF_REFERENCE_H
#define CMDF_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CMDFState CMDFState;
size_t CMDF_Size(void);
void CMDF_Reset(CMDFState *,uint32_t);
uint32_t CMDF_Get(CMDFState *,uint32_t,uint32_t);
void CMDF_Set(CMDFState *,uint32_t,uint32_t,uint32_t);
uint32_t CMDF_GetCallback(CMDFState *,uint32_t);
void CMDF_SetCallback(CMDFState *,uint32_t,uint32_t);
void CMDF_Callback(CMDFState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CMDF_Tick(CMDFState *);
uint32_t CMDF_Start(CMDFState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CMDF_Abort(CMDFState *);
uint32_t CMDF_Run(CMDFState *,uint32_t,uint32_t,uint32_t);
uint32_t CMDF_TraceWord(CMDFState *,uint32_t,uint32_t);
uint32_t *CMDF_Output(CMDFState *,uint32_t);
#endif
