#ifndef CSPDIFRX_REFERENCE_H
#define CSPDIFRX_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSPDIFRXState CSPDIFRXState;
size_t CSPDIFRX_Size(void);
void CSPDIFRX_Reset(CSPDIFRXState *,uint32_t);
uint32_t CSPDIFRX_Get(CSPDIFRXState *,uint32_t,uint32_t);
void CSPDIFRX_Set(CSPDIFRXState *,uint32_t,uint32_t,uint32_t);
uint32_t *CSPDIFRX_Buffer(CSPDIFRXState *,uint32_t);
uint32_t *CSPDIFRX_GetBuffer(CSPDIFRXState *,uint32_t);
void CSPDIFRX_SetBuffer(CSPDIFRXState *,uint32_t,uint32_t *);
void CSPDIFRX_Callback(CSPDIFRXState *,uint32_t,uint32_t);
uint32_t CSPDIFRX_GetCallback(CSPDIFRXState *,uint32_t);
void CSPDIFRX_SetCallback(CSPDIFRXState *,uint32_t,uint32_t);
uint32_t CSPDIFRX_Tick(CSPDIFRXState *);
uint32_t CSPDIFRX_Start(CSPDIFRXState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
void CSPDIFRX_Disable(CSPDIFRXState *,uint32_t);
uint32_t CSPDIFRX_Run(CSPDIFRXState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSPDIFRX_TraceWord(CSPDIFRXState *,uint32_t,uint32_t);
uint32_t CSPDIFRX_Constant(uint32_t);
#endif
