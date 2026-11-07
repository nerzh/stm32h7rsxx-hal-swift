#ifndef CGFXTIM_REFERENCE_H
#define CGFXTIM_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CGFXTIMState CGFXTIMState;
size_t CGFXTIM_Size(void);
void CGFXTIM_Reset(CGFXTIMState *, uint32_t mode);
uint32_t CGFXTIM_Get(CGFXTIMState *, uint32_t area, uint32_t index);
void CGFXTIM_Set(CGFXTIMState *, uint32_t area, uint32_t index, uint32_t value);
uint32_t CGFXTIM_Read(CGFXTIMState *, uint32_t offset);
void CGFXTIM_Write(CGFXTIMState *, uint32_t offset, uint32_t value);
uint32_t CGFXTIM_Run(CGFXTIMState *, uint32_t op, uint32_t a, uint32_t b, uint32_t nulls);
uint32_t CGFXTIM_GetCallback(CGFXTIMState *, uint32_t id);
void CGFXTIM_SetCallback(CGFXTIMState *, uint32_t id, uint32_t token);
void CGFXTIM_Callback(CGFXTIMState *, uint32_t id, uint32_t token);
uint32_t *CGFXTIM_Output(CGFXTIMState *, uint32_t selector);
uint32_t CGFXTIM_TraceCount(CGFXTIMState *);
uint32_t CGFXTIM_TraceWord(CGFXTIMState *, uint32_t event, uint32_t word);
uint32_t CGFXTIM_ConstantCount(void);
uint32_t CGFXTIM_Constant(uint32_t index);
#endif
