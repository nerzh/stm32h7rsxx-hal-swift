#include "USBInternal.h"
static void CUSB_PCDTrace(PCD_HandleTypeDef *h,uint32_t id,uint32_t value,uint32_t custom){
 CUSBState *s=(CUSBState *)h;
 uint32_t *n=&s->control[8];assert(*n+8<=256);
 s->trace[(*n)++]=id;s->trace[(*n)++]=value;s->trace[(*n)++]=custom;s->trace[(*n)++]=h->State;
 s->trace[(*n)++]=h->ErrorCode;s->trace[(*n)++]=h->Lock;s->trace[(*n)++]=h->LPM_State;s->trace[(*n)++]=h->BESL;
 if(s->control[20]==id){s->registers[s->control[21]/4]=s->control[22];s->control[20]=0;}
 if(s->control[23]==id){h->Init.dma_enable=(uint8_t)s->control[24];s->control[23]=0;}
}
void HAL_PCD_SOFCallback(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,1,0,0);}
void CUSB_Custom1(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,1,0,1);}
void HAL_PCD_SetupStageCallback(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,2,0,0);}
void CUSB_Custom2(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,2,0,1);}
void HAL_PCD_ResetCallback(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,3,0,0);}
void CUSB_Custom3(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,3,0,1);}
void HAL_PCD_SuspendCallback(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,4,0,0);}
void CUSB_Custom4(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,4,0,1);}
void HAL_PCD_ResumeCallback(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,5,0,0);}
void CUSB_Custom5(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,5,0,1);}
void HAL_PCD_ConnectCallback(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,6,0,0);}
void CUSB_Custom6(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,6,0,1);}
void HAL_PCD_DisconnectCallback(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,7,0,0);}
void CUSB_Custom7(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,7,0,1);}
void HAL_PCD_MspInit(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,8,0,0);}
void CUSB_Custom8(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,8,0,1);}
void HAL_PCD_MspDeInit(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,9,0,0);}
void CUSB_Custom9(PCD_HandleTypeDef *h){CUSB_PCDTrace(h,9,0,1);}
void HAL_PCD_DataOutStageCallback(PCD_HandleTypeDef *h,uint8_t v){CUSB_PCDTrace(h,10,v,0);}
void CUSB_Custom10(PCD_HandleTypeDef *h,uint8_t v){CUSB_PCDTrace(h,10,v,1);}
void HAL_PCD_DataInStageCallback(PCD_HandleTypeDef *h,uint8_t v){CUSB_PCDTrace(h,11,v,0);}
void CUSB_Custom11(PCD_HandleTypeDef *h,uint8_t v){CUSB_PCDTrace(h,11,v,1);}
void HAL_PCD_ISOOUTIncompleteCallback(PCD_HandleTypeDef *h,uint8_t v){CUSB_PCDTrace(h,12,v,0);}
void CUSB_Custom12(PCD_HandleTypeDef *h,uint8_t v){CUSB_PCDTrace(h,12,v,1);}
void HAL_PCD_ISOINIncompleteCallback(PCD_HandleTypeDef *h,uint8_t v){CUSB_PCDTrace(h,13,v,0);}
void CUSB_Custom13(PCD_HandleTypeDef *h,uint8_t v){CUSB_PCDTrace(h,13,v,1);}
void HAL_PCDEx_BCD_Callback(PCD_HandleTypeDef *h,PCD_BCD_MsgTypeDef v){CUSB_PCDTrace(h,14,v,0);}
void CUSB_Custom14(PCD_HandleTypeDef *h,PCD_BCD_MsgTypeDef v){CUSB_PCDTrace(h,14,v,1);}
void HAL_PCDEx_LPM_Callback(PCD_HandleTypeDef *h,PCD_LPM_MsgTypeDef v){CUSB_PCDTrace(h,15,v,0);}
void CUSB_Custom15(PCD_HandleTypeDef *h,PCD_LPM_MsgTypeDef v){CUSB_PCDTrace(h,15,v,1);}
void CUSB_PCDReset(CUSBState *s,uint32_t callbacks){
 memset(&s->pcd,0,sizeof(s->pcd));s->pcd.Instance=(USB_OTG_GlobalTypeDef *)s->registers;s->pcd.Init.dev_endpoints=8;s->control[9]=callbacks;s->control[10]=1;s->control[12]=240000000;
 for(uint32_t i=0;i<16;i++){s->pcd.IN_ep[i].num=i;s->pcd.IN_ep[i].is_in=1;s->pcd.OUT_ep[i].num=i;s->pcd.IN_ep[i].xfer_buff=s->buffer;s->pcd.OUT_ep[i].xfer_buff=s->buffer;s->pcd.IN_ep[i].maxpacket=64;s->pcd.OUT_ep[i].maxpacket=64;}
s->pcd.SOFCallback=HAL_PCD_SOFCallback;
s->pcd.SetupStageCallback=HAL_PCD_SetupStageCallback;
s->pcd.ResetCallback=HAL_PCD_ResetCallback;
s->pcd.SuspendCallback=HAL_PCD_SuspendCallback;
s->pcd.ResumeCallback=HAL_PCD_ResumeCallback;
s->pcd.ConnectCallback=HAL_PCD_ConnectCallback;
s->pcd.DisconnectCallback=HAL_PCD_DisconnectCallback;
s->pcd.MspInitCallback=HAL_PCD_MspInit;
s->pcd.MspDeInitCallback=HAL_PCD_MspDeInit;
s->pcd.DataOutStageCallback=HAL_PCD_DataOutStageCallback;
s->pcd.DataInStageCallback=HAL_PCD_DataInStageCallback;
s->pcd.ISOOUTIncompleteCallback=HAL_PCD_ISOOUTIncompleteCallback;
s->pcd.ISOINIncompleteCallback=HAL_PCD_ISOINIncompleteCallback;
s->pcd.BCDCallback=HAL_PCDEx_BCD_Callback;
s->pcd.LPMCallback=HAL_PCDEx_LPM_Callback;
}
uint32_t CUSB_PCDTick(void){CUSBState *s=CUSB_Active;uint32_t v=s->control[2];s->control[2]+=s->control[10];s->control[11]++;return v;}
uint32_t CUSB_PCDHCLK(void){CUSB_Active->control[13]++;return CUSB_Active->control[12];}
void *CUSB_PCDContext(CUSBState *s){return &s->pcd;}
uint8_t *CUSB_PCDSetup(CUSBState *s){return (uint8_t *)s->pcd.Setup;}
uint32_t CUSB_PCDGetWord(CUSBState *s,uint32_t i){switch(i){
case 0:return s->pcd.State;
case 1:return s->pcd.ErrorCode;
case 2:return s->pcd.Lock;
case 3:return s->pcd.USB_Address;
case 4:return s->pcd.LPM_State;
case 5:return s->pcd.BESL;
case 6:return s->pcd.FrameNumber;
case 7:return s->pcd.lpm_active;
case 8:return s->pcd.battery_charging_active;
default:assert(0);return 0;}}
void CUSB_PCDSetWord(CUSBState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->pcd.State=v;return;
case 1:s->pcd.ErrorCode=v;return;
case 2:s->pcd.Lock=v;return;
case 3:s->pcd.USB_Address=v;return;
case 4:s->pcd.LPM_State=v;return;
case 5:s->pcd.BESL=v;return;
case 6:s->pcd.FrameNumber=v;return;
case 7:s->pcd.lpm_active=v;return;
case 8:s->pcd.battery_charging_active=v;return;
default:assert(0);}}
uint32_t CUSB_PCDGetConfiguration(CUSBState *s,uint32_t i){switch(i){
case 0:return s->pcd.Init.dev_endpoints;
case 1:return s->pcd.Init.Host_channels;
case 2:return s->pcd.Init.dma_enable;
case 3:return s->pcd.Init.speed;
case 4:return s->pcd.Init.ep0_mps;
case 5:return s->pcd.Init.phy_itface;
case 6:return s->pcd.Init.Sof_enable;
case 7:return s->pcd.Init.low_power_enable;
case 8:return s->pcd.Init.lpm_enable;
case 9:return s->pcd.Init.battery_charging_enable;
case 10:return s->pcd.Init.vbus_sensing_enable;
case 11:return s->pcd.Init.use_dedicated_ep1;
case 12:return s->pcd.Init.use_external_vbus;
default:assert(0);return 0;}}
void CUSB_PCDSetConfiguration(CUSBState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->pcd.Init.dev_endpoints=v;return;
case 1:s->pcd.Init.Host_channels=v;return;
case 2:s->pcd.Init.dma_enable=v;return;
case 3:s->pcd.Init.speed=v;return;
case 4:s->pcd.Init.ep0_mps=v;return;
case 5:s->pcd.Init.phy_itface=v;return;
case 6:s->pcd.Init.Sof_enable=v;return;
case 7:s->pcd.Init.low_power_enable=v;return;
case 8:s->pcd.Init.lpm_enable=v;return;
case 9:s->pcd.Init.battery_charging_enable=v;return;
case 10:s->pcd.Init.vbus_sensing_enable=v;return;
case 11:s->pcd.Init.use_dedicated_ep1=v;return;
case 12:s->pcd.Init.use_external_vbus=v;return;
default:assert(0);}}
static USB_EPTypeDef *CUSB_PCDEP(CUSBState *s,uint32_t in,uint32_t n){assert(n<16);return in?&s->pcd.IN_ep[n]:&s->pcd.OUT_ep[n];}
uint8_t *CUSB_PCDEndpointBuffer(CUSBState *s,uint32_t in,uint32_t n){return CUSB_PCDEP(s,in,n)->xfer_buff;}
void CUSB_PCDSetEndpointBuffer(CUSBState *s,uint32_t in,uint32_t n,uint8_t *p){CUSB_PCDEP(s,in,n)->xfer_buff=p;}
uint32_t CUSB_PCDEndpointWord(CUSBState *s,uint32_t in,uint32_t n,uint32_t field){USB_EPTypeDef *ep=CUSB_PCDEP(s,in,n);switch(field){
case 0:return ep->num;
case 1:return ep->is_in;
case 2:return ep->is_stall;
case 3:return ep->is_iso_incomplete;
case 4:return ep->type;
case 5:return ep->data_pid_start;
case 6:return ep->maxpacket;
case 7:return ep->xfer_len;
case 8:return ep->xfer_count;
case 9:return ep->even_odd_frame;
case 10:return ep->tx_fifo_num;
case 11:return ep->dma_addr;
case 12:return ep->xfer_size;
default:assert(0);return 0;}}
void CUSB_PCDSetEndpointWord(CUSBState *s,uint32_t in,uint32_t n,uint32_t field,uint32_t v){USB_EPTypeDef *ep=CUSB_PCDEP(s,in,n);switch(field){
case 0:ep->num=v;return;
case 1:ep->is_in=v;return;
case 2:ep->is_stall=v;return;
case 3:ep->is_iso_incomplete=v;return;
case 4:ep->type=v;return;
case 5:ep->data_pid_start=v;return;
case 6:ep->maxpacket=v;return;
case 7:ep->xfer_len=v;return;
case 8:ep->xfer_count=v;return;
case 9:ep->even_odd_frame=v;return;
case 10:ep->tx_fifo_num=v;return;
case 11:ep->dma_addr=v;return;
case 12:ep->xfer_size=v;return;
default:assert(0);}}
uintptr_t CUSB_PCDGetCallback(CUSBState *s,uint32_t id){switch(id){
case 1:return (uintptr_t)s->pcd.SOFCallback;
case 2:return (uintptr_t)s->pcd.SetupStageCallback;
case 3:return (uintptr_t)s->pcd.ResetCallback;
case 4:return (uintptr_t)s->pcd.SuspendCallback;
case 5:return (uintptr_t)s->pcd.ResumeCallback;
case 6:return (uintptr_t)s->pcd.ConnectCallback;
case 7:return (uintptr_t)s->pcd.DisconnectCallback;
case 8:return (uintptr_t)s->pcd.MspInitCallback;
case 9:return (uintptr_t)s->pcd.MspDeInitCallback;
case 10:return (uintptr_t)s->pcd.DataOutStageCallback;
case 11:return (uintptr_t)s->pcd.DataInStageCallback;
case 12:return (uintptr_t)s->pcd.ISOOUTIncompleteCallback;
case 13:return (uintptr_t)s->pcd.ISOINIncompleteCallback;
case 14:return (uintptr_t)s->pcd.BCDCallback;
case 15:return (uintptr_t)s->pcd.LPMCallback;
default:assert(0);return 0;}}
void CUSB_PCDSetCallback(CUSBState *s,uint32_t id,uintptr_t v){switch(id){
case 1:s->pcd.SOFCallback=(void *)v;return;
case 2:s->pcd.SetupStageCallback=(void *)v;return;
case 3:s->pcd.ResetCallback=(void *)v;return;
case 4:s->pcd.SuspendCallback=(void *)v;return;
case 5:s->pcd.ResumeCallback=(void *)v;return;
case 6:s->pcd.ConnectCallback=(void *)v;return;
case 7:s->pcd.DisconnectCallback=(void *)v;return;
case 8:s->pcd.MspInitCallback=(void *)v;return;
case 9:s->pcd.MspDeInitCallback=(void *)v;return;
case 10:s->pcd.DataOutStageCallback=(void *)v;return;
case 11:s->pcd.DataInStageCallback=(void *)v;return;
case 12:s->pcd.ISOOUTIncompleteCallback=(void *)v;return;
case 13:s->pcd.ISOINIncompleteCallback=(void *)v;return;
case 14:s->pcd.BCDCallback=(void *)v;return;
case 15:s->pcd.LPMCallback=(void *)v;return;
default:assert(0);}}
uintptr_t CUSB_PCDCallback(uint32_t id,uint32_t custom){switch(id){
case 1:return (uintptr_t)(custom?CUSB_Custom1:HAL_PCD_SOFCallback);
case 2:return (uintptr_t)(custom?CUSB_Custom2:HAL_PCD_SetupStageCallback);
case 3:return (uintptr_t)(custom?CUSB_Custom3:HAL_PCD_ResetCallback);
case 4:return (uintptr_t)(custom?CUSB_Custom4:HAL_PCD_SuspendCallback);
case 5:return (uintptr_t)(custom?CUSB_Custom5:HAL_PCD_ResumeCallback);
case 6:return (uintptr_t)(custom?CUSB_Custom6:HAL_PCD_ConnectCallback);
case 7:return (uintptr_t)(custom?CUSB_Custom7:HAL_PCD_DisconnectCallback);
case 8:return (uintptr_t)(custom?CUSB_Custom8:HAL_PCD_MspInit);
case 9:return (uintptr_t)(custom?CUSB_Custom9:HAL_PCD_MspDeInit);
case 10:return (uintptr_t)(custom?CUSB_Custom10:HAL_PCD_DataOutStageCallback);
case 11:return (uintptr_t)(custom?CUSB_Custom11:HAL_PCD_DataInStageCallback);
case 12:return (uintptr_t)(custom?CUSB_Custom12:HAL_PCD_ISOOUTIncompleteCallback);
case 13:return (uintptr_t)(custom?CUSB_Custom13:HAL_PCD_ISOINIncompleteCallback);
case 14:return (uintptr_t)(custom?CUSB_Custom14:HAL_PCDEx_BCD_Callback);
case 15:return (uintptr_t)(custom?CUSB_Custom15:HAL_PCDEx_LPM_Callback);
default:assert(0);return 0;}}
uint32_t CUSB_PCDRun(CUSBState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CUSB_Active=s;return s->control[9]?CUSB_PCD1Run(s,op,a,b,c):CUSB_PCD0Run(s,op,a,b,c);}
static uint32_t normalizePCD(CUSBState *s,uint32_t v){uint32_t b=(uint32_t)(uintptr_t)s->buffer,p=(uint32_t)(uintptr_t)s->pcd.Setup;if((uint32_t)(v-b)<sizeof(s->buffer))return 0xABC00000U+v-b;if((uint32_t)(v-p)<sizeof(s->pcd.Setup))return 0xABD00000U+v-p;return v;}
uint32_t CUSB_PCDCompare(CUSBState *a,CUSBState *b){
 for(uint32_t i=0;i<0x4400;i++){
 uint32_t av=a->registers[i],bv=b->registers[i],off=i*4;
 if(off>=0x900&&off<0xD00&&(off&31)==20){av=normalizePCD(a,av);bv=normalizePCD(b,bv);}
 if(av!=bv)return 0x100000+off;
 }
 for(uint32_t i=0;i<9;i++)if(CUSB_PCDGetWord(a,i)!=CUSB_PCDGetWord(b,i))return 0x200000+i;
 for(uint32_t i=0;i<13;i++)if(CUSB_PCDGetConfiguration(a,i)!=CUSB_PCDGetConfiguration(b,i))return 0x300000+i;
 for(uint32_t in=0;in<2;in++)for(uint32_t n=0;n<16;n++){
 for(uint32_t i=0;i<13;i++){
 uint32_t av=CUSB_PCDEndpointWord(a,in,n,i),bv=CUSB_PCDEndpointWord(b,in,n,i);
 if(i==11){av=normalizePCD(a,av);bv=normalizePCD(b,bv);}
 if(av!=bv)return 0x400000+(in<<12)+(n<<8)+i;
 }
 if(normalizePCD(a,(uint32_t)(uintptr_t)CUSB_PCDEndpointBuffer(a,in,n))!=normalizePCD(b,(uint32_t)(uintptr_t)CUSB_PCDEndpointBuffer(b,in,n)))return 0x500000+(in<<12)+n;
 }
 if(memcmp(a->pcd.Setup,b->pcd.Setup,sizeof(a->pcd.Setup)))return 0x600000;
 if(memcmp(a->buffer,b->buffer,sizeof(a->buffer)))return 0x700000;
 if(memcmp(a->control,b->control,sizeof(a->control)))return 0x800000;
 if(memcmp(a->trace,b->trace,sizeof(a->trace)))return 0x900000;
 if(memcmp(a->delays,b->delays,sizeof(a->delays)))return 0x910000;
 for(uint32_t i=1;i<=15;i++)if(CUSB_PCDGetCallback(a,i)!=CUSB_PCDGetCallback(b,i))return 0xA00000+i;
 return 0;
}
