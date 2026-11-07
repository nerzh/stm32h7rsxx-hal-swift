#ifndef CDCMIPP_REFERENCE_H
#define CDCMIPP_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CDCMIPPState CDCMIPPState;
size_t CDCMIPP_Size(void);
void CDCMIPP_Reset(CDCMIPPState *,uint32_t mode);
uint32_t CDCMIPP_Get(CDCMIPPState *,uint32_t area,uint32_t index);
void CDCMIPP_Set(CDCMIPPState *,uint32_t area,uint32_t index,uint32_t value);
uint32_t CDCMIPP_Tick(CDCMIPPState *);
void CDCMIPP_Callback(CDCMIPPState *,uint32_t id,uint32_t token);
void CDCMIPP_PipeCallback(CDCMIPPState *,uint32_t id,uint32_t token,uint32_t pipe);
void CDCMIPP_SetCallback(CDCMIPPState *,uint32_t id,uint32_t token);
uint32_t CDCMIPP_GetCallback(CDCMIPPState *,uint32_t id);
uint32_t CDCMIPP_Run(CDCMIPPState *,uint32_t op,uint32_t a,uint32_t b,uint32_t c);
uint32_t CDCMIPP_TraceCount(CDCMIPPState *);
uint32_t CDCMIPP_TraceWord(CDCMIPPState *,uint32_t event,uint32_t word);
uint32_t CDCMIPP_ConstantCount(void);
uint32_t CDCMIPP_Constant(uint32_t i);
#endif
