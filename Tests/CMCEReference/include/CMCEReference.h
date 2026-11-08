#ifndef CMCE_REFERENCE_H
#define CMCE_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CMCEState CMCEState;
size_t CMCE_Size(void);
void CMCE_Reset(CMCEState *,uint32_t mode,uint32_t instance);
uint32_t CMCE_Get(CMCEState *,uint32_t area,uint32_t index);
void CMCE_Set(CMCEState *,uint32_t area,uint32_t index,uint32_t value);
void CMCE_Write(CMCEState *,uint32_t offset,uint32_t value);
uint32_t *CMCE_Key(CMCEState *);
uint32_t CMCE_Tick(CMCEState *);
void CMCE_Callback(CMCEState *,uint32_t id,uint32_t token);
uint32_t CMCE_GetCallback(CMCEState *,uint32_t id);
void CMCE_SetCallback(CMCEState *,uint32_t id,uint32_t token);
uint32_t CMCE_Run(CMCEState *,uint32_t op,uint32_t a,uint32_t b);
uint32_t CMCE_TraceWord(CMCEState *,uint32_t event,uint32_t word);
uint32_t CMCE_KeyCRC(const uint32_t *);
uint32_t CMCE_Constant(uint32_t);
#endif
