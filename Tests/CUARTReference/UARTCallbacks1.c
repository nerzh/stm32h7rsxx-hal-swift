/* Application overrides of unchanged weak callbacks. */
#define CUART_VARIANT CUART1
#define CUART_CALLBACK_MODE 1
#include "UARTShim.h"
void HAL_UART_TxHalfCpltCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,0,1,0); }
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,1,1,0); }
void HAL_UART_RxHalfCpltCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,2,1,0); }
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,3,1,0); }
void HAL_UART_ErrorCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,4,1,0); }
void HAL_UART_AbortCpltCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,5,1,0); }
void HAL_UART_AbortTransmitCpltCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,6,1,0); }
void HAL_UART_AbortReceiveCpltCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,7,1,0); }
void HAL_UARTEx_WakeupCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,8,1,0); }
void HAL_UARTEx_RxFifoFullCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,9,1,0); }
void HAL_UARTEx_TxFifoEmptyCallback(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,10,1,0); }
void HAL_UART_MspInit(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,11,1,0); }
void HAL_UART_MspDeInit(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,12,1,0); }
void HAL_UARTEx_RxEventCallback(UART_HandleTypeDef *h,uint16_t position) { CUART_DispatchCallback(h,13,1,position); }
