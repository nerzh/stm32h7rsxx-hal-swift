#include "USBInternal.h"
#undef USE_HAL_HCD_REGISTER_CALLBACKS
#define USE_HAL_HCD_REGISTER_CALLBACKS 0
#define USE_HAL_HCD_IN_NAK_AUTO_ACTIVATE_DISABLE 1
#define HAL_Delay CUSB_Delay
#define UNUSED(x) ((void)(x))
#define assert_param(x) ((void)0)
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
#undef USB_OTG_FS
#define USB_OTG_FS ((USB_OTG_GlobalTypeDef *)(CUSB_Active->control[0] ? NULL : CUSB_Active->registers))
#define HAL_HCD_Init CUSB_HCD01_HAL_HCD_Init
#define HAL_HCD_HC_Init CUSB_HCD01_HAL_HCD_HC_Init
#define HAL_HCD_HC_Halt CUSB_HCD01_HAL_HCD_HC_Halt
#define HAL_HCD_DeInit CUSB_HCD01_HAL_HCD_DeInit
#define HAL_HCD_HC_SubmitRequest CUSB_HCD01_HAL_HCD_HC_SubmitRequest
#define HAL_HCD_IRQHandler CUSB_HCD01_HAL_HCD_IRQHandler
#define HAL_HCD_RegisterCallback CUSB_HCD01_HAL_HCD_RegisterCallback
#define HAL_HCD_UnRegisterCallback CUSB_HCD01_HAL_HCD_UnRegisterCallback
#define HAL_HCD_RegisterHC_NotifyURBChangeCallback CUSB_HCD01_HAL_HCD_RegisterHC_NotifyURBChangeCallback
#define HAL_HCD_UnRegisterHC_NotifyURBChangeCallback CUSB_HCD01_HAL_HCD_UnRegisterHC_NotifyURBChangeCallback
#define HAL_HCD_Start CUSB_HCD01_HAL_HCD_Start
#define HAL_HCD_Stop CUSB_HCD01_HAL_HCD_Stop
#define HAL_HCD_ResetPort CUSB_HCD01_HAL_HCD_ResetPort
#define HAL_HCD_GetState CUSB_HCD01_HAL_HCD_GetState
#define HAL_HCD_HC_GetURBState CUSB_HCD01_HAL_HCD_HC_GetURBState
#define HAL_HCD_HC_GetXferCount CUSB_HCD01_HAL_HCD_HC_GetXferCount
#define HAL_HCD_HC_GetState CUSB_HCD01_HAL_HCD_HC_GetState
#define HAL_HCD_GetCurrentFrame CUSB_HCD01_HAL_HCD_GetCurrentFrame
#define HAL_HCD_GetCurrentSpeed CUSB_HCD01_HAL_HCD_GetCurrentSpeed
#define HAL_HCD_HC_SetHubInfo CUSB_HCD01_HAL_HCD_HC_SetHubInfo
#define HAL_HCD_HC_ClearHubInfo CUSB_HCD01_HAL_HCD_HC_ClearHubInfo
#define HAL_HCD_HC_Activate CUSB_HCD01_HAL_HCD_HC_Activate
#define HCD_HC_IN_IRQHandler CUSB_HCD01_HCD_HC_IN_IRQHandler
#define HCD_HC_OUT_IRQHandler CUSB_HCD01_HCD_HC_OUT_IRQHandler
#define HCD_RXQLVL_IRQHandler CUSB_HCD01_HCD_RXQLVL_IRQHandler
#define HCD_Port_IRQHandler CUSB_HCD01_HCD_Port_IRQHandler
HAL_StatusTypeDef HAL_HCD_Init(HCD_HandleTypeDef *hhcd);
HAL_StatusTypeDef HAL_HCD_HC_Init(HCD_HandleTypeDef *hhcd, uint8_t ch_num, uint8_t epnum,
                                  uint8_t dev_address, uint8_t speed, uint8_t ep_type, uint16_t mps);
HAL_StatusTypeDef HAL_HCD_HC_Halt(HCD_HandleTypeDef *hhcd, uint8_t ch_num);
HAL_StatusTypeDef HAL_HCD_DeInit(HCD_HandleTypeDef *hhcd);
HAL_StatusTypeDef HAL_HCD_HC_SubmitRequest(HCD_HandleTypeDef *hhcd,
                                           uint8_t ch_num,
                                           uint8_t direction,
                                           uint8_t ep_type,
                                           uint8_t token,
                                           uint8_t *pbuff,
                                           uint16_t length,
                                           uint8_t do_ping);
void HAL_HCD_IRQHandler(HCD_HandleTypeDef *hhcd);
HAL_StatusTypeDef HAL_HCD_Start(HCD_HandleTypeDef *hhcd);
HAL_StatusTypeDef HAL_HCD_Stop(HCD_HandleTypeDef *hhcd);
HAL_StatusTypeDef HAL_HCD_ResetPort(HCD_HandleTypeDef *hhcd);
HCD_StateTypeDef HAL_HCD_GetState(HCD_HandleTypeDef const *hhcd);
HCD_URBStateTypeDef HAL_HCD_HC_GetURBState(HCD_HandleTypeDef const *hhcd, uint8_t chnum);
uint32_t HAL_HCD_HC_GetXferCount(HCD_HandleTypeDef const *hhcd, uint8_t chnum);
HCD_HCStateTypeDef  HAL_HCD_HC_GetState(HCD_HandleTypeDef const *hhcd, uint8_t chnum);
uint32_t HAL_HCD_GetCurrentFrame(HCD_HandleTypeDef *hhcd);
uint32_t HAL_HCD_GetCurrentSpeed(HCD_HandleTypeDef *hhcd);
HAL_StatusTypeDef HAL_HCD_HC_SetHubInfo(HCD_HandleTypeDef *hhcd, uint8_t ch_num,
                                        uint8_t addr, uint8_t PortNbr);
HAL_StatusTypeDef HAL_HCD_HC_ClearHubInfo(HCD_HandleTypeDef *hhcd, uint8_t ch_num);
HAL_StatusTypeDef HAL_HCD_HC_Activate(HCD_HandleTypeDef *hhcd, uint8_t ch_num);
static void HCD_HC_IN_IRQHandler(HCD_HandleTypeDef *hhcd, uint8_t chnum);
static void HCD_HC_OUT_IRQHandler(HCD_HandleTypeDef *hhcd, uint8_t chnum);
static void HCD_RXQLVL_IRQHandler(HCD_HandleTypeDef *hhcd);
static void HCD_Port_IRQHandler(HCD_HandleTypeDef *hhcd);
#include "Upstream/HCDFunctions.inc"
uint32_t CUSB_HCD01Run(CUSBState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){HCD_HandleTypeDef *h=&s->hcd;switch(op){
case 95:return HAL_HCD_Init(h);
case 96:return HAL_HCD_HC_Init(h,a,b,c,s->control[5],s->control[6],s->control[7]);
case 97:return HAL_HCD_HC_Halt(h,a);
case 98:return HAL_HCD_DeInit(h);
case 99:return HAL_HCD_HC_SubmitRequest(h,a,b,c,s->control[15],s->buffer+s->control[18],s->control[16],s->control[17]);
case 100:HAL_HCD_IRQHandler(h);return 0;
case 101:return HAL_ERROR;
case 102:return HAL_ERROR;
case 103:return HAL_ERROR;
case 104:return HAL_ERROR;
case 105:return HAL_HCD_Start(h);
case 106:return HAL_HCD_Stop(h);
case 107:return HAL_HCD_ResetPort(h);
case 108:return HAL_HCD_GetState(h);
case 109:return HAL_HCD_HC_GetURBState(h,a);
case 110:return HAL_HCD_HC_GetXferCount(h,a);
case 111:return HAL_HCD_HC_GetState(h,a);
case 112:return HAL_HCD_GetCurrentFrame(h);
case 113:return HAL_HCD_GetCurrentSpeed(h);
case 114:return HAL_HCD_HC_SetHubInfo(h,a,b,c);
case 115:return HAL_HCD_HC_ClearHubInfo(h,a);
case 116:return HAL_HCD_HC_Activate(h,a);
case 117:HCD_HC_IN_IRQHandler(h,a);return 0;
case 118:HCD_HC_OUT_IRQHandler(h,a);return 0;
case 119:HCD_RXQLVL_IRQHandler(h);return 0;
case 120:HCD_Port_IRQHandler(h);return 0;
default:assert(0);return 0;}}
