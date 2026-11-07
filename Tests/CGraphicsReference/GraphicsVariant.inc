/* Weak hooks are overridden by these test callbacks, like application hooks. */
#define MMU_CB(name,index,token) void name(GFXMMU_HandleTypeDef *h) { (void)h; CGraphics_EmitCallback(CGraphics_Active,0,index,token,0); }
#define GPU_CB(name,index,token) void name(GPU2D_HandleTypeDef *h) { (void)h; CGraphics_EmitCallback(CGraphics_Active,1,index,token,0); }
MMU_CB(HAL_GFXMMU_ErrorCallback,0,1)
MMU_CB(HAL_GFXMMU_MspInit,1,1)
MMU_CB(HAL_GFXMMU_MspDeInit,2,1)
GPU_CB(HAL_GPU2D_MspInit,0,1)
GPU_CB(HAL_GPU2D_MspDeInit,1,1)
GPU_CB(HAL_GPU2D_ErrorCallback,3,1)
void HAL_GPU2D_CommandListCpltCallback(GPU2D_HandleTypeDef *h,uint32_t id) { (void)h; CGraphics_EmitCallback(CGraphics_Active,1,2,1,id); }
MMU_CB(customMMUError,0,2)
MMU_CB(customMMUInit,1,2)
MMU_CB(customMMUDeinit,2,2)
GPU_CB(customGPUInit,0,2)
GPU_CB(customGPUDeinit,1,2)
void customGPUComplete(GPU2D_HandleTypeDef *h,uint32_t id) { (void)h; CGraphics_EmitCallback(CGraphics_Active,1,2,2,id); }
static pGFXMMU_CallbackTypeDef mmuCallback(uint32_t index,uint32_t token) {
    if(!token)return NULL;
    switch(index) {
    case 0:return token==1?HAL_GFXMMU_ErrorCallback:customMMUError;
    case 1:return token==1?HAL_GFXMMU_MspInit:customMMUInit;
    default:return token==1?HAL_GFXMMU_MspDeInit:customMMUDeinit;
    }
}
static pGPU2D_CallbackTypeDef gpuCallback(uint32_t index,uint32_t token) {
    if(!token)return NULL;
    return index==0?(token==1?HAL_GPU2D_MspInit:customGPUInit):(token==1?HAL_GPU2D_MspDeInit:customGPUDeinit);
}
static pGPU2D_CommandListCpltCallbackTypeDef completion(uint32_t token) {
    return !token?NULL:token==1?HAL_GPU2D_CommandListCpltCallback:customGPUComplete;
}
void CGRAPH_JOIN(CGRAPH_VARIANT,_SetCallback)(CGraphicsState *s,uint32_t module,uint32_t index,uint32_t token) {
    if(!module) {
        switch(index) {case 0:s->mmuHandle.ErrorCallback=mmuCallback(index,token);break;
        case 1:s->mmuHandle.MspInitCallback=mmuCallback(index,token);break;
        case 2:s->mmuHandle.MspDeInitCallback=mmuCallback(index,token);break;default:assert(0);}
    } else {
        switch(index) {case 0:s->gpuHandle.MspInitCallback=gpuCallback(index,token);break;
        case 1:s->gpuHandle.MspDeInitCallback=gpuCallback(index,token);break;
        case 2:s->gpuHandle.CommandListCpltCallback=completion(token);break;default:assert(0);}
    }
}
uint32_t CGRAPH_JOIN(CGRAPH_VARIANT,_GetCallback)(CGraphicsState *s,uint32_t module,uint32_t index) {
    if(!module) {
        pGFXMMU_CallbackTypeDef cb=index==0?s->mmuHandle.ErrorCallback:index==1?s->mmuHandle.MspInitCallback:s->mmuHandle.MspDeInitCallback;
        return !cb?0:cb==mmuCallback(index,1)?1:2;
    }
    if(index==2)return !s->gpuHandle.CommandListCpltCallback?0:s->gpuHandle.CommandListCpltCallback==completion(1)?1:2;
    pGPU2D_CallbackTypeDef cb=index==0?s->gpuHandle.MspInitCallback:s->gpuHandle.MspDeInitCallback;
    return !cb?0:cb==gpuCallback(index,1)?1:2;
}
uint32_t CGRAPH_JOIN(CGRAPH_VARIANT,_Run)(CGraphicsState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d) {
    GFXMMU_HandleTypeDef *m=&s->mmuHandle;GPU2D_HandleTypeDef *g=&s->gpuHandle;
    switch(op) {
    case 0:return HAL_GFXMMU_Init(a?NULL:m);
    case 1:return HAL_GFXMMU_DeInit(a?NULL:m);
    case 2:return HAL_GFXMMU_ConfigLut(m,a,b,CGraphics_Address(s,c?0:4,d));
    case 3:return HAL_GFXMMU_DisableLutLines(m,a,b);
    case 4:{ GFXMMU_LutLineTypeDef line={a,b,c&255,(c>>8)&255,(int32_t)d};return HAL_GFXMMU_ConfigLutLine(m,&line); }
    case 5:{ GFXMMU_BuffersTypeDef buffers={a,b,c,d};return HAL_GFXMMU_ModifyBuffers(m,&buffers); }
    case 6:{ GFXMMU_PackingTypeDef packing={a&1,b&1,(a>>1)&1,(b>>1)&1,(a>>2)&1,(b>>2)&1,(a>>3)&1,(b>>3)&1,c};return HAL_GFXMMU_ConfigPacking(m,&packing); }
    case 7:HAL_GFXMMU_IRQHandler(m);return 0;
    case 8:return HAL_GFXMMU_GetState(m);
    case 9:return HAL_GFXMMU_GetError(m);
    case 10:__HAL_GFXMMU_RESET_HANDLE_STATE(m);return 0;
#if CGRAPH_MODE
    case 11:return HAL_GFXMMU_RegisterCallback(m,a,mmuCallback(a,b));
    case 12:return HAL_GFXMMU_UnRegisterCallback(m,a);
#endif
    case 20:return HAL_GPU2D_Init(a?NULL:g);
    case 21:return HAL_GPU2D_DeInit(a?NULL:g);
    case 22:return HAL_GPU2D_ReadRegister(g,a);
    case 23:return HAL_GPU2D_WriteRegister(g,a,b);
    case 24:HAL_GPU2D_IRQHandler(g);return 0;
    case 25:HAL_GPU2D_ER_IRQHandler(g);return 0;
    case 26:return HAL_GPU2D_GetState(g);
    case 27:return HAL_GPU2D_GetError(g);
    case 28:__HAL_GPU2D_RESET_HANDLE_STATE(g);return 0;
    case 29:return __HAL_GPU2D_GET_FLAG(g,a);
    case 30:__HAL_GPU2D_CLEAR_FLAG(g,a);return 0;
    case 31:return __HAL_GPU2D_GET_IT_SOURCE(g,a);
#if CGRAPH_MODE
    case 32:return HAL_GPU2D_RegisterCallback(a?NULL:g,b,gpuCallback(b,c));
    case 33:return HAL_GPU2D_UnRegisterCallback(a?NULL:g,b);
    case 34:return HAL_GPU2D_RegisterCommandListCpltCallback(a?NULL:g,completion(b));
    case 35:return HAL_GPU2D_UnRegisterCommandListCpltCallback(a?NULL:g);
#endif
    default:assert(!"Invalid graphics operation");return UINT32_MAX;
    }
}
