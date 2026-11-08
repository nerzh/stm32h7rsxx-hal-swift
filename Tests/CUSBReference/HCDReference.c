#include "USBInternal.h"
static void CUSB_HCDTrace(HCD_HandleTypeDef *h,uint32_t id,uint32_t channel,uint32_t value,uint32_t custom){
 CUSBState *s=(CUSBState *)((uint8_t *)h - offsetof(CUSBState,hcd));
 uint32_t *n=&s->control[8];assert(*n+12<=256);
 s->trace[(*n)++]=id;s->trace[(*n)++]=channel;s->trace[(*n)++]=value;s->trace[(*n)++]=custom;
 s->trace[(*n)++]=h->State;s->trace[(*n)++]=h->ErrorCode;s->trace[(*n)++]=h->Lock;s->trace[(*n)++]=h->hc[channel].state;
 s->trace[(*n)++]=h->hc[channel].urb_state;s->trace[(*n)++]=h->hc[channel].toggle_in;s->trace[(*n)++]=h->hc[channel].toggle_out;s->trace[(*n)++]=h->hc[channel].ErrCnt;
 if(s->control[20]==id){s->registers[s->control[21]/4]=s->control[22];s->control[20]=0;}
 if(s->control[23]==id){h->Init.dma_enable=(uint8_t)s->control[24];s->control[23]=0;}
}
void HAL_HCD_SOF_Callback(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,1,0,0,0);}
void CUSB_HCDCustom1(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,1,0,0,1);}
void HAL_HCD_Connect_Callback(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,2,0,0,0);}
void CUSB_HCDCustom2(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,2,0,0,1);}
void HAL_HCD_Disconnect_Callback(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,3,0,0,0);}
void CUSB_HCDCustom3(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,3,0,0,1);}
void HAL_HCD_PortEnabled_Callback(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,4,0,0,0);}
void CUSB_HCDCustom4(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,4,0,0,1);}
void HAL_HCD_PortDisabled_Callback(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,5,0,0,0);}
void CUSB_HCDCustom5(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,5,0,0,1);}
void HAL_HCD_MspInit(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,6,0,0,0);}
void CUSB_HCDCustom6(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,6,0,0,1);}
void HAL_HCD_MspDeInit(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,7,0,0,0);}
void CUSB_HCDCustom7(HCD_HandleTypeDef *h){CUSB_HCDTrace(h,7,0,0,1);}
void HAL_HCD_HC_NotifyURBChange_Callback(HCD_HandleTypeDef *h,uint8_t ch,HCD_URBStateTypeDef v){CUSB_HCDTrace(h,8,ch,v,0);}
void CUSB_HCDCustom8(HCD_HandleTypeDef *h,uint8_t ch,HCD_URBStateTypeDef v){CUSB_HCDTrace(h,8,ch,v,1);}
void CUSB_HCDReset(CUSBState *s,uint32_t callbacks,uint32_t nak){memset(&s->hcd,0,sizeof(s->hcd));s->hcd.Instance=(USB_OTG_GlobalTypeDef *)s->registers;s->hcd.Init.Host_channels=16;s->control[9]=callbacks;s->control[14]=nak;
 for(uint32_t i=0;i<16;i++){s->hcd.hc[i].ch_num=i;s->hcd.hc[i].xfer_buff=s->buffer;s->hcd.hc[i].max_packet=64;}
s->hcd.SOFCallback=HAL_HCD_SOF_Callback;
s->hcd.ConnectCallback=HAL_HCD_Connect_Callback;
s->hcd.DisconnectCallback=HAL_HCD_Disconnect_Callback;
s->hcd.PortEnabledCallback=HAL_HCD_PortEnabled_Callback;
s->hcd.PortDisabledCallback=HAL_HCD_PortDisabled_Callback;
s->hcd.MspInitCallback=HAL_HCD_MspInit;
s->hcd.MspDeInitCallback=HAL_HCD_MspDeInit;
s->hcd.HC_NotifyURBChangeCallback=HAL_HCD_HC_NotifyURBChange_Callback;
}
void *CUSB_HCDContext(CUSBState *s){return &s->hcd;}
uint32_t CUSB_HCDGetWord(CUSBState *s,uint32_t i){switch(i){
case 0:return s->hcd.State;
case 1:return s->hcd.ErrorCode;
case 2:return s->hcd.Lock;
default:assert(0);return 0;}}
void CUSB_HCDSetWord(CUSBState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->hcd.State=v;return;
case 1:s->hcd.ErrorCode=v;return;
case 2:s->hcd.Lock=v;return;
default:assert(0);}}
uint32_t CUSB_HCDGetConfiguration(CUSBState *s,uint32_t i){switch(i){
case 0:return s->hcd.Init.dev_endpoints;
case 1:return s->hcd.Init.Host_channels;
case 2:return s->hcd.Init.dma_enable;
case 3:return s->hcd.Init.speed;
case 4:return s->hcd.Init.ep0_mps;
case 5:return s->hcd.Init.phy_itface;
case 6:return s->hcd.Init.Sof_enable;
case 7:return s->hcd.Init.low_power_enable;
case 8:return s->hcd.Init.lpm_enable;
case 9:return s->hcd.Init.battery_charging_enable;
case 10:return s->hcd.Init.vbus_sensing_enable;
case 11:return s->hcd.Init.use_dedicated_ep1;
case 12:return s->hcd.Init.use_external_vbus;
default:assert(0);return 0;}}
void CUSB_HCDSetConfiguration(CUSBState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->hcd.Init.dev_endpoints=v;return;
case 1:s->hcd.Init.Host_channels=v;return;
case 2:s->hcd.Init.dma_enable=v;return;
case 3:s->hcd.Init.speed=v;return;
case 4:s->hcd.Init.ep0_mps=v;return;
case 5:s->hcd.Init.phy_itface=v;return;
case 6:s->hcd.Init.Sof_enable=v;return;
case 7:s->hcd.Init.low_power_enable=v;return;
case 8:s->hcd.Init.lpm_enable=v;return;
case 9:s->hcd.Init.battery_charging_enable=v;return;
case 10:s->hcd.Init.vbus_sensing_enable=v;return;
case 11:s->hcd.Init.use_dedicated_ep1=v;return;
case 12:s->hcd.Init.use_external_vbus=v;return;
default:assert(0);}}
static USB_HCTypeDef *CUSB_HCDChannel(CUSBState *s,uint32_t n){assert(n<16);return &s->hcd.hc[n];}
uint8_t *CUSB_HCDChannelBuffer(CUSBState *s,uint32_t n){return CUSB_HCDChannel(s,n)->xfer_buff;}
void CUSB_HCDSetChannelBuffer(CUSBState *s,uint32_t n,uint8_t *p){CUSB_HCDChannel(s,n)->xfer_buff=p;}
uint32_t CUSB_HCDChannelWord(CUSBState *s,uint32_t n,uint32_t field){USB_HCTypeDef *h=CUSB_HCDChannel(s,n);switch(field){
case 0:return h->dev_addr;
case 1:return h->ch_num;
case 2:return h->ep_num;
case 3:return h->ep_is_in;
case 4:return h->ch_dir;
case 5:return h->speed;
case 6:return h->do_ping;
case 7:return h->do_ssplit;
case 8:return h->do_csplit;
case 9:return h->ep_ss_schedule;
case 10:return h->iso_splt_xactPos;
case 11:return h->hub_port_nbr;
case 12:return h->hub_addr;
case 13:return h->ep_type;
case 14:return h->max_packet;
case 15:return h->data_pid;
case 16:return h->XferSize;
case 17:return h->xfer_len;
case 18:return h->xfer_count;
case 19:return h->toggle_in;
case 20:return h->toggle_out;
case 21:return h->dma_addr;
case 22:return h->NakCnt;
case 23:return h->ErrCnt;
case 24:return h->NyetErrCnt;
case 25:return h->urb_state;
case 26:return h->state;
default:assert(0);return 0;}}
void CUSB_HCDSetChannelWord(CUSBState *s,uint32_t n,uint32_t field,uint32_t v){USB_HCTypeDef *h=CUSB_HCDChannel(s,n);switch(field){
case 0:h->dev_addr=v;return;
case 1:h->ch_num=v;return;
case 2:h->ep_num=v;return;
case 3:h->ep_is_in=v;return;
case 4:h->ch_dir=v;return;
case 5:h->speed=v;return;
case 6:h->do_ping=v;return;
case 7:h->do_ssplit=v;return;
case 8:h->do_csplit=v;return;
case 9:h->ep_ss_schedule=v;return;
case 10:h->iso_splt_xactPos=v;return;
case 11:h->hub_port_nbr=v;return;
case 12:h->hub_addr=v;return;
case 13:h->ep_type=v;return;
case 14:h->max_packet=v;return;
case 15:h->data_pid=v;return;
case 16:h->XferSize=v;return;
case 17:h->xfer_len=v;return;
case 18:h->xfer_count=v;return;
case 19:h->toggle_in=v;return;
case 20:h->toggle_out=v;return;
case 21:h->dma_addr=v;return;
case 22:h->NakCnt=v;return;
case 23:h->ErrCnt=v;return;
case 24:h->NyetErrCnt=v;return;
case 25:h->urb_state=v;return;
case 26:h->state=v;return;
default:assert(0);}}
uintptr_t CUSB_HCDGetCallback(CUSBState *s,uint32_t id){switch(id){
case 1:return (uintptr_t)s->hcd.SOFCallback;
case 2:return (uintptr_t)s->hcd.ConnectCallback;
case 3:return (uintptr_t)s->hcd.DisconnectCallback;
case 4:return (uintptr_t)s->hcd.PortEnabledCallback;
case 5:return (uintptr_t)s->hcd.PortDisabledCallback;
case 6:return (uintptr_t)s->hcd.MspInitCallback;
case 7:return (uintptr_t)s->hcd.MspDeInitCallback;
case 8:return (uintptr_t)s->hcd.HC_NotifyURBChangeCallback;
default:assert(0);return 0;}}
void CUSB_HCDSetCallback(CUSBState *s,uint32_t id,uintptr_t v){switch(id){
case 1:s->hcd.SOFCallback=(void *)v;return;
case 2:s->hcd.ConnectCallback=(void *)v;return;
case 3:s->hcd.DisconnectCallback=(void *)v;return;
case 4:s->hcd.PortEnabledCallback=(void *)v;return;
case 5:s->hcd.PortDisabledCallback=(void *)v;return;
case 6:s->hcd.MspInitCallback=(void *)v;return;
case 7:s->hcd.MspDeInitCallback=(void *)v;return;
case 8:s->hcd.HC_NotifyURBChangeCallback=(void *)v;return;
default:assert(0);}}
uintptr_t CUSB_HCDCallback(uint32_t id,uint32_t custom){switch(id){
case 1:return (uintptr_t)(custom?CUSB_HCDCustom1:HAL_HCD_SOF_Callback);
case 2:return (uintptr_t)(custom?CUSB_HCDCustom2:HAL_HCD_Connect_Callback);
case 3:return (uintptr_t)(custom?CUSB_HCDCustom3:HAL_HCD_Disconnect_Callback);
case 4:return (uintptr_t)(custom?CUSB_HCDCustom4:HAL_HCD_PortEnabled_Callback);
case 5:return (uintptr_t)(custom?CUSB_HCDCustom5:HAL_HCD_PortDisabled_Callback);
case 6:return (uintptr_t)(custom?CUSB_HCDCustom6:HAL_HCD_MspInit);
case 7:return (uintptr_t)(custom?CUSB_HCDCustom7:HAL_HCD_MspDeInit);
case 8:return (uintptr_t)(custom?CUSB_HCDCustom8:HAL_HCD_HC_NotifyURBChange_Callback);
default:assert(0);return 0;}}
uint32_t CUSB_HCDRun(CUSBState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){CUSB_Active=s;switch(s->control[9]*2+s->control[14]){
case 0:return CUSB_HCD00Run(s,op,a,b,c);
case 1:return CUSB_HCD01Run(s,op,a,b,c);
case 2:return CUSB_HCD10Run(s,op,a,b,c);
case 3:return CUSB_HCD11Run(s,op,a,b,c);
default:assert(0);return 0;}}
static uint32_t normalizeHCD(CUSBState *s,uint32_t v){uint32_t b=(uint32_t)(uintptr_t)s->buffer;return (uint32_t)(v-b)<sizeof(s->buffer)?0xABC00000U+v-b:v;}
uint32_t CUSB_HCDCompare(CUSBState *a,CUSBState *b){
 for(uint32_t i=0;i<0x4400;i++){
 uint32_t av=a->registers[i],bv=b->registers[i],off=i*4;
 if(off>=0x500&&off<0x700&&(off&31)==20){av=normalizeHCD(a,av);bv=normalizeHCD(b,bv);}
 if(av!=bv)return 0x100000+off;
 }
 for(uint32_t i=0;i<3;i++)if(CUSB_HCDGetWord(a,i)!=CUSB_HCDGetWord(b,i))return 0x200000+i;
 for(uint32_t i=0;i<13;i++)if(CUSB_HCDGetConfiguration(a,i)!=CUSB_HCDGetConfiguration(b,i))return 0x300000+i;
 for(uint32_t n=0;n<16;n++){
 for(uint32_t i=0;i<27;i++)if(CUSB_HCDChannelWord(a,n,i)!=CUSB_HCDChannelWord(b,n,i))return 0x400000+(n<<8)+i;
 if(normalizeHCD(a,(uint32_t)(uintptr_t)CUSB_HCDChannelBuffer(a,n))!=normalizeHCD(b,(uint32_t)(uintptr_t)CUSB_HCDChannelBuffer(b,n)))return 0x500000+n;
 }
 if(memcmp(a->buffer,b->buffer,sizeof(a->buffer)))return 0x700000;
 if(memcmp(a->control,b->control,sizeof(a->control)))return 0x800000;
 if(memcmp(a->trace,b->trace,sizeof(a->trace)))return 0x900000;
 if(memcmp(a->delays,b->delays,sizeof(a->delays)))return 0x910000;
 for(uint32_t i=1;i<=8;i++)if(CUSB_HCDGetCallback(a,i)!=CUSB_HCDGetCallback(b,i))return 0xA00000+i;
 return 0;
}
