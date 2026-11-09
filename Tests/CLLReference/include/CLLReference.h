#pragma once
#include <stdint.h>
typedef struct CLLState CLLState;
typedef struct { uint32_t index, value, write; } CLLAccess;
CLLState *CLL_Create(void);
void CLL_Destroy(CLLState *s);
void CLL_Reset(CLLState *s, uint32_t seed, uint32_t salt, uint32_t port);
uint32_t CLL_Run(CLLState *s, uint32_t operation, uint32_t *args);
const uint32_t *CLL_GetCells(CLLState *s);
const CLLAccess *CLL_GetTrace(CLLState *s);
uint32_t CLL_GetTraceCount(CLLState *s);
uint32_t CLL_Constant(uint32_t index);
#include "CLLSystemReference.h"

#include "CLLClockReference.h"

#include "CLLDMAReference.h"

#include "CLLTimerReference.h"

#include "CLLADCReference.h"

#include "CLLSerialReference.h"

#include "CLLSPIReference.h"

#include "CLLI2CReference.h"

#include "CLLRTCReference.h"

#include "CLLComputationReference.h"

#include "CLLConnectionReference.h"

#include "CLLUtilitiesReference.h"
