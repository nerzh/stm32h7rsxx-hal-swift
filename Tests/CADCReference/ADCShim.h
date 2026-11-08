#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/ADCNamespace.h"
#include "ADCDefinitions.h"
#undef USE_HAL_ADC_REGISTER_CALLBACKS
#define USE_HAL_ADC_REGISTER_CALLBACKS F_MODE
#define assert_param(x) ((void)0)
#define HAL_MAX_DELAY UINT32_MAX
uint32_t CADC_Tick(void);
extern uint32_t SystemCoreClock;
#define HAL_GetTick() CADC_Tick()
#define DMA_LINKEDLIST 0x80U
#define DMA_SRC_DATAWIDTH_WORD 2U
#define DMA_SRC_DATAWIDTH_HALFWORD 1U
#define HAL_DMA_STATE_BUSY 2U
#define NODE_CBR1_DEFAULT_OFFSET 2U
#define NODE_CSAR_DEFAULT_OFFSET 3U
#define NODE_CDAR_DEFAULT_OFFSET 4U
#define ADC_CFGR_FIELDS_1 (ADC_CFGR_RES | ADC_CFGR_ALIGN | ADC_CFGR_CONT | ADC_CFGR_OVRMOD | ADC_CFGR_DISCEN | ADC_CFGR_DISCNUM | ADC_CFGR_EXTEN | ADC_CFGR_EXTSEL)
#define ADC_ENABLE_TIMEOUT 2UL
#define ADC_DISABLE_TIMEOUT 2UL
#define ADC_CONVERSION_TIME_MAX_CPU_CYCLES (653UL * 4096UL * 256UL)
#define ADC_CALIBRATION_TIMEOUT 633600000UL
#define ADC_JSQR_FIELDS (ADC_JSQR_JL | ADC_JSQR_JEXTSEL | ADC_JSQR_JEXTEN | ADC_JSQR_JSQ1 | ADC_JSQR_JSQ2 | ADC_JSQR_JSQ3 | ADC_JSQR_JSQ4)
HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *);
HAL_StatusTypeDef HAL_DMAEx_List_GetNodeConfig(DMA_NodeConfTypeDef *,DMA_NodeTypeDef *);
HAL_StatusTypeDef HAL_DMA_Abort(DMA_HandleTypeDef *);
#include "ADCPrototypes.h"
#if !F_MODE
#undef __HAL_ADC_RESET_HANDLE_STATE
#define __HAL_ADC_RESET_HANDLE_STATE(h) ((h)->State=HAL_ADC_STATE_RESET)
#endif
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#endif
