#ifndef CGRAPHICS_REFERENCE_H
#define CGRAPHICS_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CGraphicsState CGraphicsState;
size_t CGraphics_Size(void);
void CGraphics_Reset(CGraphicsState *state, uint32_t mode);
uint32_t CGraphics_Get(CGraphicsState *state, uint32_t area, uint32_t index);
void CGraphics_Set(CGraphicsState *state, uint32_t area, uint32_t index, uint32_t value);
uint32_t CGraphics_Run(CGraphicsState *state, uint32_t operation, uint32_t a, uint32_t b, uint32_t c, uint32_t d);
uint32_t CGraphics_GetCallback(CGraphicsState *state, uint32_t module, uint32_t index);
void CGraphics_SetCallback(CGraphicsState *state, uint32_t module, uint32_t index, uint32_t token);
void CGraphics_EmitCallback(CGraphicsState *state, uint32_t module, uint32_t index, uint32_t token, uint32_t argument);
uint32_t CGraphics_ReadGPU(CGraphicsState *state, uint32_t offset);
void CGraphics_WriteGPU(CGraphicsState *state, uint32_t offset, uint32_t value);
uint32_t CGraphics_Mask(CGraphicsState *state, uint32_t operation, uint32_t value);
uint32_t CGraphics_Address(CGraphicsState *state, uint32_t area, uint32_t index);
uint32_t CGraphics_ReadMemory(CGraphicsState *state, uint32_t address);
void CGraphics_WriteMemory(CGraphicsState *state, uint32_t address, uint32_t value);
uint32_t CGraphics_TraceCount(CGraphicsState *state);
uint32_t CGraphics_TraceWord(CGraphicsState *state, uint32_t event, uint32_t word);
#endif
