#ifndef C_TIME_REFERENCE_H
#define C_TIME_REFERENCE_H
#include <stdint.h>
typedef struct {
    volatile uint32_t tick;
    uint32_t priority, frequency, coreClock;
    struct { volatile uint32_t CTRL; } sysTick;
    uint32_t configResult, configCalls, configTicks;
    uint32_t priorityCalls, lastPriority;
    uint32_t tickStep, tickReads;
} CTimeReferenceState;
void CTime_Reset(CTimeReferenceState *state);
uint32_t CTime_InitTick(CTimeReferenceState *state, uint32_t priority);
void CTime_IncTick(CTimeReferenceState *state);
uint32_t CTime_SetFrequency(CTimeReferenceState *state, uint32_t frequency);
void CTime_Delay(CTimeReferenceState *state, uint32_t delay);
void CTime_Suspend(CTimeReferenceState *state);
void CTime_Resume(CTimeReferenceState *state);
#endif
