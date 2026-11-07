#ifndef CLTDC_REFERENCE_H
#define CLTDC_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CLTDCState CLTDCState;
size_t CLTDC_Size(void);
void CLTDC_Reset(CLTDCState *,uint32_t mode);
uint32_t CLTDC_Get(CLTDCState *,uint32_t area,uint32_t index);
void CLTDC_Set(CLTDCState *,uint32_t area,uint32_t index,uint32_t value);
const uint32_t *CLTDC_Colors(CLTDCState *);
uint32_t CLTDC_Tick(CLTDCState *);
void CLTDC_Callback(CLTDCState *,uint32_t id,uint32_t token);
void CLTDC_SetCallback(CLTDCState *,uint32_t id,uint32_t token);
uint32_t CLTDC_GetCallback(CLTDCState *,uint32_t id);
uint32_t CLTDC_Run(CLTDCState *,uint32_t op,uint32_t a,uint32_t b,uint32_t c);
uint32_t CLTDC_TraceCount(CLTDCState *);
uint32_t CLTDC_TraceWord(CLTDCState *,uint32_t event,uint32_t word);
uint32_t CLTDC_ConstantCount(void);
uint32_t CLTDC_Constant(uint32_t i);
#endif
