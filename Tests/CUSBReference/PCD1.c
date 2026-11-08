#include "USBInternal.h"
#undef USE_HAL_PCD_REGISTER_CALLBACKS
#define USE_HAL_PCD_REGISTER_CALLBACKS 1
#define HAL_Delay CUSB_Delay
#define HAL_GetTick CUSB_PCDTick
#define HAL_RCC_GetHCLKFreq CUSB_PCDHCLK
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
#define HAL_PCD_Init CUSB_PCD1_HAL_PCD_Init
#define HAL_PCD_DeInit CUSB_PCD1_HAL_PCD_DeInit
#define HAL_PCD_RegisterCallback CUSB_PCD1_HAL_PCD_RegisterCallback
#define HAL_PCD_UnRegisterCallback CUSB_PCD1_HAL_PCD_UnRegisterCallback
#define HAL_PCD_RegisterDataOutStageCallback CUSB_PCD1_HAL_PCD_RegisterDataOutStageCallback
#define HAL_PCD_UnRegisterDataOutStageCallback CUSB_PCD1_HAL_PCD_UnRegisterDataOutStageCallback
#define HAL_PCD_RegisterDataInStageCallback CUSB_PCD1_HAL_PCD_RegisterDataInStageCallback
#define HAL_PCD_UnRegisterDataInStageCallback CUSB_PCD1_HAL_PCD_UnRegisterDataInStageCallback
#define HAL_PCD_RegisterIsoOutIncpltCallback CUSB_PCD1_HAL_PCD_RegisterIsoOutIncpltCallback
#define HAL_PCD_UnRegisterIsoOutIncpltCallback CUSB_PCD1_HAL_PCD_UnRegisterIsoOutIncpltCallback
#define HAL_PCD_RegisterIsoInIncpltCallback CUSB_PCD1_HAL_PCD_RegisterIsoInIncpltCallback
#define HAL_PCD_UnRegisterIsoInIncpltCallback CUSB_PCD1_HAL_PCD_UnRegisterIsoInIncpltCallback
#define HAL_PCD_RegisterBcdCallback CUSB_PCD1_HAL_PCD_RegisterBcdCallback
#define HAL_PCD_UnRegisterBcdCallback CUSB_PCD1_HAL_PCD_UnRegisterBcdCallback
#define HAL_PCD_RegisterLpmCallback CUSB_PCD1_HAL_PCD_RegisterLpmCallback
#define HAL_PCD_UnRegisterLpmCallback CUSB_PCD1_HAL_PCD_UnRegisterLpmCallback
#define HAL_PCD_Start CUSB_PCD1_HAL_PCD_Start
#define HAL_PCD_Stop CUSB_PCD1_HAL_PCD_Stop
#define HAL_PCD_IRQHandler CUSB_PCD1_HAL_PCD_IRQHandler
#define HAL_PCD_DevConnect CUSB_PCD1_HAL_PCD_DevConnect
#define HAL_PCD_DevDisconnect CUSB_PCD1_HAL_PCD_DevDisconnect
#define HAL_PCD_SetAddress CUSB_PCD1_HAL_PCD_SetAddress
#define HAL_PCD_EP_Open CUSB_PCD1_HAL_PCD_EP_Open
#define HAL_PCD_EP_Close CUSB_PCD1_HAL_PCD_EP_Close
#define HAL_PCD_EP_Receive CUSB_PCD1_HAL_PCD_EP_Receive
#define HAL_PCD_EP_GetRxCount CUSB_PCD1_HAL_PCD_EP_GetRxCount
#define HAL_PCD_EP_Transmit CUSB_PCD1_HAL_PCD_EP_Transmit
#define HAL_PCD_EP_SetStall CUSB_PCD1_HAL_PCD_EP_SetStall
#define HAL_PCD_EP_ClrStall CUSB_PCD1_HAL_PCD_EP_ClrStall
#define HAL_PCD_EP_Abort CUSB_PCD1_HAL_PCD_EP_Abort
#define HAL_PCD_EP_Flush CUSB_PCD1_HAL_PCD_EP_Flush
#define HAL_PCD_ActivateRemoteWakeup CUSB_PCD1_HAL_PCD_ActivateRemoteWakeup
#define HAL_PCD_DeActivateRemoteWakeup CUSB_PCD1_HAL_PCD_DeActivateRemoteWakeup
#define HAL_PCD_GetState CUSB_PCD1_HAL_PCD_GetState
#define HAL_PCD_SetTestMode CUSB_PCD1_HAL_PCD_SetTestMode
#define PCD_WriteEmptyTxFifo CUSB_PCD1_PCD_WriteEmptyTxFifo
#define PCD_EP_OutXfrComplete_int CUSB_PCD1_PCD_EP_OutXfrComplete_int
#define PCD_EP_OutSetupPacket_int CUSB_PCD1_PCD_EP_OutSetupPacket_int
#define HAL_PCDEx_SetTxFiFo CUSB_PCD1_HAL_PCDEx_SetTxFiFo
#define HAL_PCDEx_SetRxFiFo CUSB_PCD1_HAL_PCDEx_SetRxFiFo
#define HAL_PCDEx_ActivateLPM CUSB_PCD1_HAL_PCDEx_ActivateLPM
#define HAL_PCDEx_DeActivateLPM CUSB_PCD1_HAL_PCDEx_DeActivateLPM
#define HAL_PCDEx_BCD_VBUSDetect CUSB_PCD1_HAL_PCDEx_BCD_VBUSDetect
#define HAL_PCDEx_ActivateBCD CUSB_PCD1_HAL_PCDEx_ActivateBCD
#define HAL_PCDEx_DeActivateBCD CUSB_PCD1_HAL_PCDEx_DeActivateBCD
HAL_StatusTypeDef HAL_PCD_Init(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_DeInit(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_RegisterCallback(PCD_HandleTypeDef *hpcd,
                                           HAL_PCD_CallbackIDTypeDef CallbackID,
                                           pPCD_CallbackTypeDef pCallback);
HAL_StatusTypeDef HAL_PCD_UnRegisterCallback(PCD_HandleTypeDef *hpcd, HAL_PCD_CallbackIDTypeDef CallbackID);
HAL_StatusTypeDef HAL_PCD_RegisterDataOutStageCallback(PCD_HandleTypeDef *hpcd,
                                                       pPCD_DataOutStageCallbackTypeDef pCallback);
HAL_StatusTypeDef HAL_PCD_UnRegisterDataOutStageCallback(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_RegisterDataInStageCallback(PCD_HandleTypeDef *hpcd,
                                                      pPCD_DataInStageCallbackTypeDef pCallback);
HAL_StatusTypeDef HAL_PCD_UnRegisterDataInStageCallback(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_RegisterIsoOutIncpltCallback(PCD_HandleTypeDef *hpcd,
                                                       pPCD_IsoOutIncpltCallbackTypeDef pCallback);
HAL_StatusTypeDef HAL_PCD_UnRegisterIsoOutIncpltCallback(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_RegisterIsoInIncpltCallback(PCD_HandleTypeDef *hpcd,
                                                      pPCD_IsoInIncpltCallbackTypeDef pCallback);
HAL_StatusTypeDef HAL_PCD_UnRegisterIsoInIncpltCallback(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_RegisterBcdCallback(PCD_HandleTypeDef *hpcd, pPCD_BcdCallbackTypeDef pCallback);
HAL_StatusTypeDef HAL_PCD_UnRegisterBcdCallback(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_RegisterLpmCallback(PCD_HandleTypeDef *hpcd, pPCD_LpmCallbackTypeDef pCallback);
HAL_StatusTypeDef HAL_PCD_UnRegisterLpmCallback(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_Start(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_Stop(PCD_HandleTypeDef *hpcd);
void HAL_PCD_IRQHandler(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_DevConnect(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_DevDisconnect(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_SetAddress(PCD_HandleTypeDef *hpcd, uint8_t address);
HAL_StatusTypeDef HAL_PCD_EP_Open(PCD_HandleTypeDef *hpcd, uint8_t ep_addr,
                                  uint16_t ep_mps, uint8_t ep_type);
HAL_StatusTypeDef HAL_PCD_EP_Close(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
HAL_StatusTypeDef HAL_PCD_EP_Receive(PCD_HandleTypeDef *hpcd, uint8_t ep_addr, uint8_t *pBuf, uint32_t len);
uint32_t HAL_PCD_EP_GetRxCount(PCD_HandleTypeDef const *hpcd, uint8_t ep_addr);
HAL_StatusTypeDef HAL_PCD_EP_Transmit(PCD_HandleTypeDef *hpcd, uint8_t ep_addr, uint8_t *pBuf, uint32_t len);
HAL_StatusTypeDef HAL_PCD_EP_SetStall(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
HAL_StatusTypeDef HAL_PCD_EP_ClrStall(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
HAL_StatusTypeDef HAL_PCD_EP_Abort(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
HAL_StatusTypeDef HAL_PCD_EP_Flush(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
HAL_StatusTypeDef HAL_PCD_ActivateRemoteWakeup(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCD_DeActivateRemoteWakeup(PCD_HandleTypeDef *hpcd);
PCD_StateTypeDef HAL_PCD_GetState(PCD_HandleTypeDef const *hpcd);
HAL_StatusTypeDef HAL_PCD_SetTestMode(const PCD_HandleTypeDef *hpcd, uint8_t testmode);
static HAL_StatusTypeDef PCD_WriteEmptyTxFifo(PCD_HandleTypeDef *hpcd, uint32_t epnum);
static HAL_StatusTypeDef PCD_EP_OutXfrComplete_int(PCD_HandleTypeDef *hpcd, uint32_t epnum);
static HAL_StatusTypeDef PCD_EP_OutSetupPacket_int(PCD_HandleTypeDef *hpcd, uint32_t epnum);
HAL_StatusTypeDef HAL_PCDEx_SetTxFiFo(PCD_HandleTypeDef *hpcd, uint8_t fifo, uint16_t size);
HAL_StatusTypeDef HAL_PCDEx_SetRxFiFo(PCD_HandleTypeDef *hpcd, uint16_t size);
HAL_StatusTypeDef HAL_PCDEx_ActivateLPM(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCDEx_DeActivateLPM(PCD_HandleTypeDef *hpcd);
void HAL_PCDEx_BCD_VBUSDetect(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCDEx_ActivateBCD(PCD_HandleTypeDef *hpcd);
HAL_StatusTypeDef HAL_PCDEx_DeActivateBCD(PCD_HandleTypeDef *hpcd);
#include "Upstream/PCDFunctions.inc"
#include "Upstream/PCDExtendedFunctions.inc"
uint32_t CUSB_PCD1Run(CUSBState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){PCD_HandleTypeDef *h=&s->pcd;switch(op){
case 50:return HAL_PCD_Init(h);
case 51:return HAL_PCD_DeInit(h);
case 52:return HAL_PCD_RegisterCallback(h,a,(pPCD_CallbackTypeDef)(b?CUSB_PCDCallback(a>=1&&a<=9?a:1,1):0));
case 53:return HAL_PCD_UnRegisterCallback(h,a);
case 54:return HAL_PCD_RegisterDataOutStageCallback(h,(pPCD_DataOutStageCallbackTypeDef)(b?CUSB_PCDCallback(10,1):0));
case 55:return HAL_PCD_UnRegisterDataOutStageCallback(h);
case 56:return HAL_PCD_RegisterDataInStageCallback(h,(pPCD_DataInStageCallbackTypeDef)(b?CUSB_PCDCallback(11,1):0));
case 57:return HAL_PCD_UnRegisterDataInStageCallback(h);
case 58:return HAL_PCD_RegisterIsoOutIncpltCallback(h,(pPCD_IsoOutIncpltCallbackTypeDef)(b?CUSB_PCDCallback(12,1):0));
case 59:return HAL_PCD_UnRegisterIsoOutIncpltCallback(h);
case 60:return HAL_PCD_RegisterIsoInIncpltCallback(h,(pPCD_IsoInIncpltCallbackTypeDef)(b?CUSB_PCDCallback(13,1):0));
case 61:return HAL_PCD_UnRegisterIsoInIncpltCallback(h);
case 62:return HAL_PCD_RegisterBcdCallback(h,(pPCD_BcdCallbackTypeDef)(b?CUSB_PCDCallback(14,1):0));
case 63:return HAL_PCD_UnRegisterBcdCallback(h);
case 64:return HAL_PCD_RegisterLpmCallback(h,(pPCD_LpmCallbackTypeDef)(b?CUSB_PCDCallback(15,1):0));
case 65:return HAL_PCD_UnRegisterLpmCallback(h);
case 66:return HAL_PCD_Start(h);
case 67:return HAL_PCD_Stop(h);
case 68:HAL_PCD_IRQHandler(h);return 0;
case 69:return HAL_PCD_DevConnect(h);
case 70:return HAL_PCD_DevDisconnect(h);
case 71:return HAL_PCD_SetAddress(h,a);
case 72:return HAL_PCD_EP_Open(h,a,b,c);
case 73:return HAL_PCD_EP_Close(h,a);
case 74:return HAL_PCD_EP_Receive(h,a,s->buffer+c,b);
case 75:return HAL_PCD_EP_GetRxCount(h,a);
case 76:return HAL_PCD_EP_Transmit(h,a,s->buffer+c,b);
case 77:return HAL_PCD_EP_SetStall(h,a);
case 78:return HAL_PCD_EP_ClrStall(h,a);
case 79:return HAL_PCD_EP_Abort(h,a);
case 80:return HAL_PCD_EP_Flush(h,a);
case 81:return HAL_PCD_ActivateRemoteWakeup(h);
case 82:return HAL_PCD_DeActivateRemoteWakeup(h);
case 83:return HAL_PCD_GetState(h);
case 84:return HAL_PCD_SetTestMode(h,a);
case 85:return PCD_WriteEmptyTxFifo(h,a);
case 86:return PCD_EP_OutXfrComplete_int(h,a);
case 87:return PCD_EP_OutSetupPacket_int(h,a);
case 88:return HAL_PCDEx_SetTxFiFo(h,a,b);
case 89:return HAL_PCDEx_SetRxFiFo(h,a);
case 90:return HAL_PCDEx_ActivateLPM(h);
case 91:return HAL_PCDEx_DeActivateLPM(h);
case 92:HAL_PCDEx_BCD_VBUSDetect(h);return 0;
case 93:return HAL_PCDEx_ActivateBCD(h);
case 94:return HAL_PCDEx_DeActivateBCD(h);
default:assert(0);return 0;}}
