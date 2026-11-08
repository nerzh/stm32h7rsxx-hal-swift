#ifndef CFDCAN_REFERENCE_H
#define CFDCAN_REFERENCE_H
#include <stdint.h>
typedef struct CFDCANState CFDCANState;
CFDCANState *CFDCAN_Create(uint32_t mode,uint32_t instance);
void CFDCAN_Destroy(CFDCANState *s);
void CFDCAN_Reset(CFDCANState *s,uint32_t instance);
uint32_t CFDCAN_Get(CFDCANState *s,uint32_t area,uint32_t index);
void CFDCAN_Set(CFDCANState *s,uint32_t area,uint32_t index,uint32_t value);
uint32_t CFDCAN_Run(CFDCANState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d);
uint32_t CFDCAN_GetCallback(CFDCANState *s,uint32_t id);
void CFDCAN_SetCallback(CFDCANState *s,uint32_t id,uint32_t token);
void CFDCAN_Callback(CFDCANState *s,uint32_t id,uint32_t token,uint32_t argument);
uint32_t CFDCAN_ModelTick(CFDCANState *s);
uint8_t *CFDCAN_Data(CFDCANState *s,uint32_t output);
uint32_t CFDCAN_Constant(uint32_t index);
#endif
