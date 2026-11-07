#ifndef CDCMIPP_INTERNAL_H
#define CDCMIPP_INTERNAL_H
#include "include/CDCMIPPReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define DCMIPP 1
#define USE_HAL_DCMIPP_REGISTER_CALLBACKS 1
#include "Upstream/DCMIPPBits.h"
#include "Upstream/stm32h7rsxx_hal_dcmipp.h"
struct CDCMIPPState {
    DCMIPP_TypeDef registers;
    DCMIPP_HandleTypeDef handle;
    struct {
        DCMIPP_ParallelConfTypeDef parallel;
        DCMIPP_PipeConfTypeDef pipe;
        DCMIPP_IPPlugConfTypeDef ipplug;
        DCMIPP_CropConfTypeDef crop;
        DCMIPP_EmbeddedSyncUnmaskTypeDef sync;
        uint32_t counter;
    } parameters;
    uint32_t mode,control[6],traceCount,trace[32][44];
};
extern CDCMIPPState *CDCMIPP_Active;
uint32_t CDCMIPP0_Run(CDCMIPPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CDCMIPP1_Run(CDCMIPPState *,uint32_t,uint32_t,uint32_t,uint32_t);
pDCMIPP_CallbackTypeDef CDCMIPP_CallbackPointer(uint32_t id,uint32_t token);
pDCMIPP_PIPE_CallbackTypeDef CDCMIPP_PipeCallbackPointer(uint32_t id,uint32_t token);
#endif
