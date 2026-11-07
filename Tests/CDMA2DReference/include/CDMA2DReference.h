#ifndef CDMA2D_REFERENCE_H
#define CDMA2D_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CDMA2DState CDMA2DState;
size_t CDMA2D_Size(void);
void CDMA2D_Reset(CDMA2DState *,uint32_t mode);
uint32_t CDMA2D_Get(CDMA2DState *,uint32_t area,uint32_t index);
void CDMA2D_Set(CDMA2DState *,uint32_t area,uint32_t index,uint32_t value);
void CDMA2D_Write(CDMA2DState *,uint32_t offset,uint32_t value);
uint32_t CDMA2D_Tick(CDMA2DState *);
void CDMA2D_Callback(CDMA2DState *,uint32_t id,uint32_t token);
void CDMA2D_SetCallback(CDMA2DState *,uint32_t id,uint32_t token);
uint32_t CDMA2D_GetCallback(CDMA2DState *,uint32_t id);
uint32_t CDMA2D_Run(CDMA2DState *,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d,uint32_t e);
uint32_t CDMA2D_TraceCount(CDMA2DState *);
uint32_t CDMA2D_TraceWord(CDMA2DState *,uint32_t event,uint32_t word);
uint32_t CDMA2D_ConstantCount(void);
uint32_t CDMA2D_Constant(uint32_t i);
#endif
