#ifndef CSERIAL_INTERNAL_H
#define CSERIAL_INTERNAL_H
#include "include/CSerialControlReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define MDIOS 1
#define CEC 1
#define USE_HAL_MDIOS_REGISTER_CALLBACKS 1
#define USE_HAL_CEC_REGISTER_CALLBACKS 1
#include "Upstream/SerialBits.h"
#include "Upstream/stm32h7rsxx_hal_mdios.h"
#include "Upstream/stm32h7rsxx_hal_cec.h"
struct CSerialState {
 MDIOS_TypeDef mdios; CEC_TypeDef cec;
 MDIOS_HandleTypeDef mh; CEC_HandleTypeDef ch;
 struct { uint32_t IMR2,PR2,RTSR2,FTSR2,SWIER2; } exti;
 uint32_t mode,kind,control[4],traceCount,trace[16][180];
 uint8_t data[131104];
};
extern CSerialState *CSerial_Active;
uint32_t CSerialMDIOS0_Run(CSerialState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSerialMDIOS1_Run(CSerialState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSerialCEC0_Run(CSerialState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSerialCEC1_Run(CSerialState *,uint32_t,uint32_t,uint32_t,uint32_t);

pMDIOS_CallbackTypeDef CSerial_MDIOScallback(uint32_t,uint32_t);
pCEC_CallbackTypeDef CSerial_CECcallback(uint32_t,uint32_t);
pCEC_RxCallbackTypeDef CSerial_CECrxCallback(uint32_t);
#endif
