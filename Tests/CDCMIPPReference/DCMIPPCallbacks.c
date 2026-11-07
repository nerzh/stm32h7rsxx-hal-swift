#include "DCMIPPInternal.h"
void HAL_DCMIPP_MspInit(DCMIPP_HandleTypeDef *h) { (void)h;CDCMIPP_Callback(CDCMIPP_Active,0,1); }
static void common0(DCMIPP_HandleTypeDef *h) { (void)h;CDCMIPP_Callback(CDCMIPP_Active,0,2); }
void HAL_DCMIPP_MspDeInit(DCMIPP_HandleTypeDef *h) { (void)h;CDCMIPP_Callback(CDCMIPP_Active,1,1); }
static void common1(DCMIPP_HandleTypeDef *h) { (void)h;CDCMIPP_Callback(CDCMIPP_Active,1,2); }
void HAL_DCMIPP_ErrorCallback(DCMIPP_HandleTypeDef *h) { (void)h;CDCMIPP_Callback(CDCMIPP_Active,2,1); }
static void common2(DCMIPP_HandleTypeDef *h) { (void)h;CDCMIPP_Callback(CDCMIPP_Active,2,2); }
pDCMIPP_CallbackTypeDef CDCMIPP_CallbackPointer(uint32_t id,uint32_t token) {
    if(!token)return NULL;
    switch(id) {
    case 0:return token==1?HAL_DCMIPP_MspInit:common0;
    case 1:return token==1?HAL_DCMIPP_MspDeInit:common1;
    case 2:return token==1?HAL_DCMIPP_ErrorCallback:common2;
    default:return common0;
    }
}
void HAL_DCMIPP_PIPE_LimitEventCallback(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,1,1,pipe); }
static void pipe1(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,1,2,pipe); }
void HAL_DCMIPP_PIPE_LineEventCallback(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,2,1,pipe); }
static void pipe2(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,2,2,pipe); }
void HAL_DCMIPP_PIPE_FrameEventCallback(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,3,1,pipe); }
static void pipe3(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,3,2,pipe); }
void HAL_DCMIPP_PIPE_VsyncEventCallback(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,4,1,pipe); }
static void pipe4(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,4,2,pipe); }
void HAL_DCMIPP_PIPE_ErrorCallback(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,5,1,pipe); }
static void pipe5(DCMIPP_HandleTypeDef *h,uint32_t pipe) { (void)h;CDCMIPP_PipeCallback(CDCMIPP_Active,5,2,pipe); }
pDCMIPP_PIPE_CallbackTypeDef CDCMIPP_PipeCallbackPointer(uint32_t id,uint32_t token) {
    if(!token)return NULL;
    switch(id) {
    case 1:return token==1?HAL_DCMIPP_PIPE_LimitEventCallback:pipe1;
    case 2:return token==1?HAL_DCMIPP_PIPE_LineEventCallback:pipe2;
    case 3:return token==1?HAL_DCMIPP_PIPE_FrameEventCallback:pipe3;
    case 4:return token==1?HAL_DCMIPP_PIPE_VsyncEventCallback:pipe4;
    case 5:return token==1?HAL_DCMIPP_PIPE_ErrorCallback:pipe5;
    default:return pipe1;
    }
}
void CDCMIPP_SetCallback(CDCMIPPState *s,uint32_t id,uint32_t token) {
    switch(id) {
    case 0:s->handle.MspInitCallback=CDCMIPP_CallbackPointer(0,token);break;
    case 1:s->handle.MspDeInitCallback=CDCMIPP_CallbackPointer(1,token);break;
    case 2:s->handle.ErrorCallback=CDCMIPP_CallbackPointer(2,token);break;
    case 3:s->handle.PIPE_LimitEventCallback=CDCMIPP_PipeCallbackPointer(1,token);break;
    case 4:s->handle.PIPE_LineEventCallback=CDCMIPP_PipeCallbackPointer(2,token);break;
    case 5:s->handle.PIPE_FrameEventCallback=CDCMIPP_PipeCallbackPointer(3,token);break;
    case 6:s->handle.PIPE_VsyncEventCallback=CDCMIPP_PipeCallbackPointer(4,token);break;
    case 7:s->handle.PIPE_ErrorCallback=CDCMIPP_PipeCallbackPointer(5,token);break;
    default:assert(0);
    }
}
uint32_t CDCMIPP_GetCallback(CDCMIPPState *s,uint32_t id) {
    switch(id) {
    case 0:return !s->handle.MspInitCallback?0:s->handle.MspInitCallback==CDCMIPP_CallbackPointer(0,1)?1:2;
    case 1:return !s->handle.MspDeInitCallback?0:s->handle.MspDeInitCallback==CDCMIPP_CallbackPointer(1,1)?1:2;
    case 2:return !s->handle.ErrorCallback?0:s->handle.ErrorCallback==CDCMIPP_CallbackPointer(2,1)?1:2;
    case 3:return !s->handle.PIPE_LimitEventCallback?0:s->handle.PIPE_LimitEventCallback==CDCMIPP_PipeCallbackPointer(1,1)?1:2;
    case 4:return !s->handle.PIPE_LineEventCallback?0:s->handle.PIPE_LineEventCallback==CDCMIPP_PipeCallbackPointer(2,1)?1:2;
    case 5:return !s->handle.PIPE_FrameEventCallback?0:s->handle.PIPE_FrameEventCallback==CDCMIPP_PipeCallbackPointer(3,1)?1:2;
    case 6:return !s->handle.PIPE_VsyncEventCallback?0:s->handle.PIPE_VsyncEventCallback==CDCMIPP_PipeCallbackPointer(4,1)?1:2;
    case 7:return !s->handle.PIPE_ErrorCallback?0:s->handle.PIPE_ErrorCallback==CDCMIPP_PipeCallbackPointer(5,1)?1:2;
    default:assert(0);return 0;
    }
}
