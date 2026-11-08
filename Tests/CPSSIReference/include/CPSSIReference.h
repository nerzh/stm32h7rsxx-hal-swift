#ifndef CPSSI_REFERENCE_H
#define CPSSI_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CPSSIState CPSSIState;
size_t CPSSI_Size(void);
void CPSSI_Reset(CPSSIState *,uint32_t mode,uint32_t dma);
uint32_t CPSSI_Get(CPSSIState *,uint32_t area,uint32_t index);
void CPSSI_Set(CPSSIState *,uint32_t area,uint32_t index,uint32_t value);
void *CPSSI_Buffer(CPSSIState *,uint32_t offset);
void *CPSSI_GetBuffer(CPSSIState *);
void CPSSI_SetBuffer(CPSSIState *,void *);
void CPSSI_Callback(CPSSIState *,uint32_t id,uint32_t token);
uint32_t CPSSI_GetCallback(CPSSIState *,uint32_t id);
void CPSSI_SetCallback(CPSSIState *,uint32_t id,uint32_t token);
uint32_t CPSSI_Tick(CPSSIState *);
uint32_t CPSSI_Start(CPSSIState *,uint32_t dir,uint32_t linked,uint32_t source,uint32_t destination,uint32_t size);
uint32_t CPSSI_Abort(CPSSIState *,uint32_t dir);
uint32_t CPSSI_Run(CPSSIState *,uint32_t op,uint32_t a,uint32_t b,uint32_t c);
uint32_t CPSSI_TraceCount(CPSSIState *);
uint32_t CPSSI_TraceWord(CPSSIState *,uint32_t event,uint32_t word);
uint32_t CPSSI_ConstantCount(void);
uint32_t CPSSI_Constant(uint32_t index);
#endif
