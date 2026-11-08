#include "USBInternal.h"
#undef HAL_USB_TIMEOUT
#define HAL_USB_TIMEOUT 32U
#define HAL_Delay CUSB_Delay
#define UNUSED(x) ((void)(x))
#define __UNALIGNED_UINT32_READ(p) CUSB_UnalignedRead(p)
#define __UNALIGNED_UINT32_WRITE(p,v) CUSB_UnalignedWrite(p,v)
static uint32_t CUSB_UnalignedRead(const void *p){uint32_t v;memcpy(&v,p,4);return v;}
static void CUSB_UnalignedWrite(void *p,uint32_t v){memcpy(p,&v,4);}
#undef USB_OTG_HS
#define USB_OTG_HS ((USB_OTG_GlobalTypeDef *)(CUSB_Active->control[0] ? CUSB_Active->registers : NULL))
#undef USBx_DEVICE
#define USBx_DEVICE ((USB_OTG_DeviceTypeDef *)((uintptr_t)USBx + USB_OTG_DEVICE_BASE))
#undef USBx_INEP
#define USBx_INEP(i) ((USB_OTG_INEndpointTypeDef *)((uintptr_t)USBx + USB_OTG_IN_ENDPOINT_BASE + (i)*USB_OTG_EP_REG_SIZE))
#undef USBx_OUTEP
#define USBx_OUTEP(i) ((USB_OTG_OUTEndpointTypeDef *)((uintptr_t)USBx + USB_OTG_OUT_ENDPOINT_BASE + (i)*USB_OTG_EP_REG_SIZE))
#undef USBx_HOST
#define USBx_HOST ((USB_OTG_HostTypeDef *)((uintptr_t)USBx + USB_OTG_HOST_BASE))
#undef USBx_HC
#define USBx_HC(i) ((USB_OTG_HostChannelTypeDef *)((uintptr_t)USBx + USB_OTG_HOST_CHANNEL_BASE + (i)*USB_OTG_HOST_CHANNEL_SIZE))
#undef USBx_DFIFO
#define USBx_DFIFO(i) (*(volatile uint32_t *)((uintptr_t)USBx + USB_OTG_FIFO_BASE + (i)*USB_OTG_FIFO_SIZE))
#undef USBx_PCGCCTL
#define USBx_PCGCCTL (*(volatile uint32_t *)((uintptr_t)USBx + USB_OTG_PCGCCTL_BASE))
#undef USBx_HPRT0
#define USBx_HPRT0 (*(volatile uint32_t *)((uintptr_t)USBx + USB_OTG_HOST_PORT_BASE))
static HAL_StatusTypeDef USB_CoreReset(USB_OTG_GlobalTypeDef *);
#include "Upstream/USBLowLevelFunctions.inc"
uint32_t CUSB_Run(CUSBState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){
 CUSB_Active=s;USB_OTG_GlobalTypeDef *u=(USB_OTG_GlobalTypeDef *)s->registers;
 switch(op){
case 0:return USB_CoreInit(u,s->configuration);
case 1:return USB_SetTurnaroundTime(u,a,b);
case 2:return USB_EnableGlobalInt(u);
case 3:return USB_DisableGlobalInt(u);
case 4:return USB_SetCurrentMode(u,a);
case 5:return USB_DevInit(u,s->configuration);
case 6:return USB_FlushTxFifo(u,a);
case 7:return USB_FlushRxFifo(u);
case 8:return USB_SetDevSpeed(u,a);
case 9:return USB_GetDevSpeed(u);
case 10:return USB_ActivateEndpoint(u,&s->endpoint);
case 11:return USB_ActivateDedicatedEndpoint(u,&s->endpoint);
case 12:return USB_DeactivateEndpoint(u,&s->endpoint);
case 13:return USB_DeactivateDedicatedEndpoint(u,&s->endpoint);
case 14:return USB_EPStartXfer(u,&s->endpoint,a);
case 15:return USB_EPStopXfer(u,&s->endpoint);
case 16:return USB_EPSetStall(u,&s->endpoint);
case 17:return USB_EPClearStall(u,&s->endpoint);
case 18:return USB_WritePacket(u,s->buffer+c,a,b,0);
case 19:return (uint32_t)((uint8_t *)USB_ReadPacket(u,s->buffer+c,b)-s->buffer);
case 20:return USB_StopDevice(u);
case 21:return USB_SetDevAddress(u,a);
case 22:return USB_DevConnect(u);
case 23:return USB_DevDisconnect(u);
case 24:return USB_ReadInterrupts(u);
case 25:return USB_ReadChInterrupts(u,a);
case 26:return USB_ReadDevAllOutEpInterrupt(u);
case 27:return USB_ReadDevAllInEpInterrupt(u);
case 28:return USB_ReadDevOutEPInterrupt(u,a);
case 29:return USB_ReadDevInEPInterrupt(u,a);
case 30:USB_ClearInterrupts(u,a);return 0;
case 31:return USB_GetMode(u);
case 32:return USB_ActivateSetup(u);
case 33:return USB_EP0_OutStart(u,a,s->buffer+c);
case 34:return USB_CoreReset(u);
case 35:return USB_HostInit(u,s->configuration);
case 36:return USB_InitFSLSPClkSel(u,a);
case 37:return USB_ResetPort(u);
case 38:return USB_DriveVbus(u,a);
case 39:return USB_GetHostSpeed(u);
case 40:return USB_GetCurrentFrame(u);
case 41:return USB_HC_Init(u,a,b,c,s->control[5],s->control[6],s->control[7]);
case 42:return USB_HC_StartXfer(u,&s->channel,a);
case 43:return USB_HC_ReadInterrupt(u);
case 44:return USB_HC_Halt(u,a);
case 45:return USB_HC_Activate(u,a,b);
case 46:return USB_DoPing(u,a);
case 47:return USB_StopHost(u);
case 48:return USB_ActivateRemoteWakeup(u);
case 49:return USB_DeActivateRemoteWakeup(u);
default:assert(0);return 0;}}
