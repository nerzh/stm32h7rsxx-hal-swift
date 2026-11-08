static HAL_StatusTypeDef (*ISRPointer(uint32_t i))(I2C_HandleTypeDef *,uint32_t,uint32_t){switch(i){
case 0:return NULL;
case 1:return I2C_Master_ISR_IT;
case 2:return I2C_Mem_ISR_IT;
case 3:return I2C_Slave_ISR_IT;
case 4:return I2C_Master_ISR_DMA;
case 5:return I2C_Mem_ISR_DMA;
case 6:return I2C_Slave_ISR_DMA;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetWord)(CI2CState *s,uint32_t i){switch(i){
case 0:return s->h.Init.Timing;
case 1:return s->h.Init.OwnAddress1;
case 2:return s->h.Init.AddressingMode;
case 3:return s->h.Init.DualAddressMode;
case 4:return s->h.Init.OwnAddress2;
case 5:return s->h.Init.OwnAddress2Masks;
case 6:return s->h.Init.GeneralCallMode;
case 7:return s->h.Init.NoStretchMode;
case 8:return s->h.XferSize;
case 9:return s->h.XferCount;
case 10:return s->h.State;
case 11:return s->h.Mode;
case 12:return s->h.ErrorCode;
case 13:return s->h.Lock;
case 14:return s->h.XferOptions;
case 15:return s->h.PreviousState;
case 16:for(uint32_t k=0;k<=6;k++)if(s->h.XferISR==ISRPointer(k))return k;assert(0);return 0;
case 17:return s->h.AddrEventCount;
case 18:return s->h.Devaddress;
case 19:return s->h.Memaddress;
default:assert(0);return 0;}}
void F_JOIN(F_VARIANT,_SetWord)(CI2CState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->h.Init.Timing=v;break;
case 1:s->h.Init.OwnAddress1=v;break;
case 2:s->h.Init.AddressingMode=v;break;
case 3:s->h.Init.DualAddressMode=v;break;
case 4:s->h.Init.OwnAddress2=v;break;
case 5:s->h.Init.OwnAddress2Masks=v;break;
case 6:s->h.Init.GeneralCallMode=v;break;
case 7:s->h.Init.NoStretchMode=v;break;
case 8:s->h.XferSize=v;break;
case 9:s->h.XferCount=v;break;
case 10:s->h.State=v;break;
case 11:s->h.Mode=v;break;
case 12:s->h.ErrorCode=v;break;
case 13:s->h.Lock=v;break;
case 14:s->h.XferOptions=v;break;
case 15:s->h.PreviousState=v;break;
case 16:s->h.XferISR=ISRPointer(v);break;
case 17:s->h.AddrEventCount=v;break;
case 18:s->h.Devaddress=v;break;
case 19:s->h.Memaddress=v;break;
default:assert(0);break;}}
static void (*DMAPointer(uint32_t i))(DMA_HandleTypeDef *){switch(i){case 0:return NULL;
case 1:return I2C_DMAMasterTransmitCplt;
case 2:return I2C_DMAMasterReceiveCplt;
case 3:return I2C_DMASlaveTransmitCplt;
case 4:return I2C_DMASlaveReceiveCplt;
case 5:return I2C_DMAError;
case 6:return I2C_DMAAbort;
default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CI2CState *s,uint32_t d,uint32_t id){void (*f)(DMA_HandleTypeDef *)=NULL;switch(id){
case 0:f=s->dma[d].XferCpltCallback;break;
case 1:f=s->dma[d].XferHalfCpltCallback;break;
case 2:f=s->dma[d].XferErrorCallback;break;
case 3:f=s->dma[d].XferAbortCallback;break;
default:assert(0);break;}for(uint32_t k=0;k<=6;k++)if(f==DMAPointer(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CI2CState *s,uint32_t d,uint32_t id,uint32_t v){switch(id){
case 0:s->dma[d].XferCpltCallback=DMAPointer(v);break;
case 1:s->dma[d].XferHalfCpltCallback=DMAPointer(v);break;
case 2:s->dma[d].XferErrorCallback=DMAPointer(v);break;
case 3:s->dma[d].XferAbortCallback=DMAPointer(v);break;
default:assert(0);break;}}
uint32_t F_JOIN(F_VARIANT,_Run)(CI2CState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){
uint8_t *data=s->control[13]?NULL:s->buffer+s->control[14];switch(op){
case 0:return HAL_I2C_Init(&s->h);
case 1:return HAL_I2C_DeInit(&s->h);
#if F_MODE
case 2:return HAL_I2C_RegisterCallback(&s->h,(HAL_I2C_CallbackIDTypeDef)a,(pI2C_CallbackTypeDef)CI2C_Callback(a<=10?a:0,b));
#endif
#if F_MODE
case 3:return HAL_I2C_UnRegisterCallback(&s->h,(HAL_I2C_CallbackIDTypeDef)a);
#endif
#if F_MODE
case 4:return HAL_I2C_RegisterAddrCallback(&s->h,(pI2C_AddrCallbackTypeDef)CI2C_Callback(11,b));
#endif
#if F_MODE
case 5:return HAL_I2C_UnRegisterAddrCallback(&s->h);
#endif
case 6:return HAL_I2C_Master_Transmit(&s->h,a,data,b,c);
case 7:return HAL_I2C_Master_Receive(&s->h,a,data,b,c);
case 8:return HAL_I2C_Slave_Transmit(&s->h,data,b,c);
case 9:return HAL_I2C_Slave_Receive(&s->h,data,b,c);
case 10:return HAL_I2C_Master_Transmit_IT(&s->h,a,data,b);
case 11:return HAL_I2C_Master_Receive_IT(&s->h,a,data,b);
case 12:return HAL_I2C_Slave_Transmit_IT(&s->h,data,b);
case 13:return HAL_I2C_Slave_Receive_IT(&s->h,data,b);
case 14:return HAL_I2C_Master_Transmit_DMA(&s->h,a,data,b);
case 15:return HAL_I2C_Master_Receive_DMA(&s->h,a,data,b);
case 16:return HAL_I2C_Slave_Transmit_DMA(&s->h,data,b);
case 17:return HAL_I2C_Slave_Receive_DMA(&s->h,data,b);
case 18:return HAL_I2C_Mem_Write(&s->h,a,s->control[15],s->control[16],data,b,c);
case 19:return HAL_I2C_Mem_Read(&s->h,a,s->control[15],s->control[16],data,b,c);
case 20:return HAL_I2C_Mem_Write_IT(&s->h,a,s->control[15],s->control[16],data,b);
case 21:return HAL_I2C_Mem_Read_IT(&s->h,a,s->control[15],s->control[16],data,b);
case 22:return HAL_I2C_Mem_Write_DMA(&s->h,a,s->control[15],s->control[16],data,b);
case 23:return HAL_I2C_Mem_Read_DMA(&s->h,a,s->control[15],s->control[16],data,b);
case 24:return HAL_I2C_IsDeviceReady(&s->h,a,b,c);
case 25:return HAL_I2C_Master_Seq_Transmit_IT(&s->h,a,data,b,s->control[17]);
case 26:return HAL_I2C_Master_Seq_Transmit_DMA(&s->h,a,data,b,s->control[17]);
case 27:return HAL_I2C_Master_Seq_Receive_IT(&s->h,a,data,b,s->control[17]);
case 28:return HAL_I2C_Master_Seq_Receive_DMA(&s->h,a,data,b,s->control[17]);
case 29:return HAL_I2C_Slave_Seq_Transmit_IT(&s->h,data,b,s->control[17]);
case 30:return HAL_I2C_Slave_Seq_Transmit_DMA(&s->h,data,b,s->control[17]);
case 31:return HAL_I2C_Slave_Seq_Receive_IT(&s->h,data,b,s->control[17]);
case 32:return HAL_I2C_Slave_Seq_Receive_DMA(&s->h,data,b,s->control[17]);
case 33:return HAL_I2C_EnableListen_IT(&s->h);
case 34:return HAL_I2C_DisableListen_IT(&s->h);
case 35:return HAL_I2C_Master_Abort_IT(&s->h,a);
case 36:HAL_I2C_EV_IRQHandler(&s->h);return 0;
case 37:HAL_I2C_ER_IRQHandler(&s->h);return 0;
case 38:return HAL_I2C_GetState(&s->h);
case 39:return HAL_I2C_GetMode(&s->h);
case 40:return HAL_I2C_GetError(&s->h);
case 41:return I2C_Master_ISR_IT(&s->h,a,b);
case 42:return I2C_Mem_ISR_IT(&s->h,a,b);
case 43:return I2C_Slave_ISR_IT(&s->h,a,b);
case 44:return I2C_Master_ISR_DMA(&s->h,a,b);
case 45:return I2C_Mem_ISR_DMA(&s->h,a,b);
case 46:return I2C_Slave_ISR_DMA(&s->h,a,b);
case 47:return I2C_RequestMemoryWrite(&s->h,a,s->control[15],s->control[16],c,s->control[18]);
case 48:return I2C_RequestMemoryRead(&s->h,a,s->control[15],s->control[16],c,s->control[18]);
case 49:I2C_ITAddrCplt(&s->h,a);return 0;
case 50:I2C_ITMasterSeqCplt(&s->h);return 0;
case 51:I2C_ITSlaveSeqCplt(&s->h);return 0;
case 52:I2C_ITMasterCplt(&s->h,a);return 0;
case 53:I2C_ITSlaveCplt(&s->h,a);return 0;
case 54:I2C_ITListenCplt(&s->h,a);return 0;
case 55:I2C_ITError(&s->h,a);return 0;
case 56:I2C_TreatErrorCallback(&s->h);return 0;
case 57:I2C_Flush_TXDR(&s->h);return 0;
case 58:I2C_DMAMasterTransmitCplt(&s->dma[a&1U]);return 0;
case 59:I2C_DMASlaveTransmitCplt(&s->dma[a&1U]);return 0;
case 60:I2C_DMAMasterReceiveCplt(&s->dma[a&1U]);return 0;
case 61:I2C_DMASlaveReceiveCplt(&s->dma[a&1U]);return 0;
case 62:I2C_DMAError(&s->dma[a&1U]);return 0;
case 63:I2C_DMAAbort(&s->dma[a&1U]);return 0;
case 64:return I2C_WaitOnFlagUntilTimeout(&s->h,a,(FlagStatus)b,c,s->control[18]);
case 65:return I2C_WaitOnTXISFlagUntilTimeout(&s->h,c,s->control[18]);
case 66:return I2C_WaitOnSTOPFlagUntilTimeout(&s->h,c,s->control[18]);
case 67:return I2C_WaitOnRXNEFlagUntilTimeout(&s->h,c,s->control[18]);
case 68:return I2C_IsErrorOccurred(&s->h,c,s->control[18]);
case 69:I2C_TransferConfig(&s->h,a,b,s->control[19],c);return 0;
case 70:I2C_Enable_IRQ(&s->h,a);return 0;
case 71:I2C_Disable_IRQ(&s->h,a);return 0;
case 72:I2C_ConvertOtherXferOptions(&s->h);return 0;
case 73:return HAL_I2CEx_ConfigAnalogFilter(&s->h,a);
case 74:return HAL_I2CEx_ConfigDigitalFilter(&s->h,a);
case 75:return HAL_I2CEx_EnableWakeUp(&s->h);
case 76:return HAL_I2CEx_DisableWakeUp(&s->h);
case 77:return HAL_I2CEx_ConfigFastModePlus(&s->h,a);
case 100:return __HAL_I2C_GET_FLAG(&s->h,a);
case 101:__HAL_I2C_CLEAR_FLAG(&s->h,a);return 0;
case 102:__HAL_I2C_ENABLE_IT(&s->h,a);return 0;
case 103:__HAL_I2C_DISABLE_IT(&s->h,a);return 0;
case 104:return __HAL_I2C_GET_IT_SOURCE(&s->h,a);
case 105:__HAL_I2C_ENABLE(&s->h);return 0;
case 106:__HAL_I2C_DISABLE(&s->h);return 0;
case 107:__HAL_I2C_GENERATE_NACK(&s->h);return 0;
case 108:
#if F_MODE
__HAL_I2C_RESET_HANDLE_STATE(&s->h);
#else
s->h.State=HAL_I2C_STATE_RESET;
#endif
return 0;
default:return HAL_ERROR;}}
