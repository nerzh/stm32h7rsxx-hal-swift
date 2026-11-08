#ifndef CRTC_REFERENCE_H
#define CRTC_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CRTCState CRTCState;
size_t CRTC_Size(void);
void CRTC_Reset(CRTCState *,uint32_t);
uint32_t CRTC_Get(CRTCState *,uint32_t,uint32_t);
void CRTC_Set(CRTCState *,uint32_t,uint32_t,uint32_t);
uint32_t CRTC_GetCallback(CRTCState *,uint32_t);
void CRTC_SetCallback(CRTCState *,uint32_t,uint32_t);
void CRTC_Callback(CRTCState *,uint32_t,uint32_t);
uint32_t CRTC_TickFor(CRTCState *);
uint32_t CRTC_Run(CRTCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CRTC_TraceWord(CRTCState *,uint32_t,uint32_t);
uint32_t CRTC_Constant(uint32_t);
#endif
