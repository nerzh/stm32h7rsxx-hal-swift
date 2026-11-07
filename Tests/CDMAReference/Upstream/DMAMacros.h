/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Exact declarations/macros/function source from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define HAL_DMA_ERROR_NONE             (0x0000U) /*!< No error                      */
#define HAL_DMA_ERROR_DTE              (0x0001U) /*!< Data transfer error           */
#define HAL_DMA_ERROR_ULE              (0x0002U) /*!< Update linked-list item error */
#define HAL_DMA_ERROR_USE              (0x0004U) /*!< User setting error            */
#define HAL_DMA_ERROR_TO               (0x0008U) /*!< Trigger overrun error         */
#define HAL_DMA_ERROR_TIMEOUT          (0x0010U) /*!< Timeout error                 */
#define HAL_DMA_ERROR_NO_XFER          (0x0020U) /*!< No transfer ongoing error     */
#define HAL_DMA_ERROR_BUSY             (0x0040U) /*!< Busy error                    */
#define HAL_DMA_ERROR_INVALID_CALLBACK (0x0080U) /*!< Invalid callback error        */
#define HAL_DMA_ERROR_NOT_SUPPORTED    (0x0100U) /*!< Not supported mode            */
#define DMA_IT_TC   DMA_CCR_TCIE   /*!< Transfer complete interrupt             */
#define DMA_IT_HT   DMA_CCR_HTIE   /*!< Half transfer complete interrupt        */
#define DMA_IT_DTE  DMA_CCR_DTEIE  /*!< Data transfer error interrupt           */
#define DMA_IT_ULE  DMA_CCR_ULEIE  /*!< Update linked-list item error interrupt */
#define DMA_IT_USE  DMA_CCR_USEIE  /*!< User eetting error interrupt            */
#define DMA_IT_SUSP DMA_CCR_SUSPIE /*!< Completed suspension interrupt          */
#define DMA_IT_TO   DMA_CCR_TOIE   /*!< Trigger overrun interrupt               */
#define DMA_FLAG_IDLE DMA_CSR_IDLEF /*!< Idle flag                          */
#define DMA_FLAG_TC   DMA_CSR_TCF   /*!< Transfer complete flag             */
#define DMA_FLAG_HT   DMA_CSR_HTF   /*!< Half transfer complete flag        */
#define DMA_FLAG_DTE  DMA_CSR_DTEF  /*!< Data transfer error flag           */
#define DMA_FLAG_ULE  DMA_CSR_ULEF  /*!< Update linked-list item error flag */
#define DMA_FLAG_USE  DMA_CSR_USEF  /*!< User setting error flag            */
#define DMA_FLAG_SUSP DMA_CSR_SUSPF /*!< Completed suspension flag          */
#define DMA_FLAG_TO   DMA_CSR_TOF   /*!< Trigger overrun flag               */
#define HPDMA1_REQUEST_JPEG_RX        0U       /*!< HPDMA1 HW request is JPEG_DMA_RX    */
#define HPDMA1_REQUEST_JPEG_TX        1U       /*!< HPDMA1 HW request is JPEG_DMA_TX    */
#define HPDMA1_REQUEST_XSPI1          2U       /*!< HPDMA1 HW request is XSPI1          */
#define HPDMA1_REQUEST_XSPI2          3U       /*!< HPDMA1 HW request is XSPI2          */
#define HPDMA1_REQUEST_SPI3_RX        4U       /*!< HPDMA1 HW request is SPI3_RX        */
#define HPDMA1_REQUEST_SPI3_TX        5U       /*!< HPDMA1 HW request is SPI3_TX        */
#define HPDMA1_REQUEST_SPI4_RX        6U       /*!< HPDMA1 HW request is SPI4_RX        */
#define HPDMA1_REQUEST_SPI4_TX        7U       /*!< HPDMA1 HW request is SPI4_TX        */
#define HPDMA1_REQUEST_ADC1           8U       /*!< HPDMA1 HW request is ADC1           */
#define HPDMA1_REQUEST_ADC2           9U       /*!< HPDMA1 HW request is ADC2           */
#define HPDMA1_REQUEST_ADF1_FLT0      10U      /*!< HPDMA1 HW request is ADF1_FLT0      */
#define HPDMA1_REQUEST_UART4_RX       11U      /*!< HPDMA1 HW request is UART4_RX       */
#define HPDMA1_REQUEST_UART4_TX       12U      /*!< HPDMA1 HW request is UART4_TX       */
#define HPDMA1_REQUEST_UART5_RX       13U      /*!< HPDMA1 HW request is UART5_RX       */
#define HPDMA1_REQUEST_UART5_TX       14U      /*!< HPDMA1 HW request is UART5_TX       */
#define HPDMA1_REQUEST_UART7_RX       15U      /*!< HPDMA1 HW request is UART7_RX       */
#define HPDMA1_REQUEST_UART7_TX       16U      /*!< HPDMA1 HW request is UART7_TX       */
#define HPDMA1_REQUEST_LPTIM2_IC1     17U      /*!< HPDMA1 HW request is LPTIM2_IC1     */
#define HPDMA1_REQUEST_LPTIM2_IC2     18U      /*!< HPDMA1 HW request is LPTIM2_IC2     */
#define HPDMA1_REQUEST_LPTIM2_UE      19U      /*!< HPDMA1 HW request is LPTIM2_UE      */
#define GPDMA1_REQUEST_ADC1           0U       /*!< GPDMA1 HW request is ADC1           */
#define GPDMA1_REQUEST_ADC2           1U       /*!< GPDMA1 HW request is ADC2           */
#define GPDMA1_REQUEST_CRYP_IN        2U       /*!< GPDMA1 HW request is CRYP_IN        */
#define GPDMA1_REQUEST_CRYP_OUT       3U       /*!< GPDMA1 HW request is CRYP_OUT       */
#define GPDMA1_REQUEST_SAES_IN        4U       /*!< GPDMA1 HW request is SAES_IN        */
#define GPDMA1_REQUEST_SAES_OUT       5U       /*!< GPDMA1 HW request is SAES_OUT       */
#define GPDMA1_REQUEST_HASH_IN        6U       /*!< GPDMA1 HW request is HASH_IN        */
#define GPDMA1_REQUEST_TIM1_CH1       7U       /*!< GPDMA1 HW request is TIM1_CH1       */
#define GPDMA1_REQUEST_TIM1_CH2       8U       /*!< GPDMA1 HW request is TIM1_CH2       */
#define GPDMA1_REQUEST_TIM1_CH3       9U       /*!< GPDMA1 HW request is TIM1_CH3       */
#define GPDMA1_REQUEST_TIM1_CH4       10U      /*!< GPDMA1 HW request is TIM1_CH4       */
#define GPDMA1_REQUEST_TIM1_UP        11U      /*!< GPDMA1 HW request is TIM1_UP        */
#define GPDMA1_REQUEST_TIM1_TRIG      12U      /*!< GPDMA1 HW request is TIM1_TRIG      */
#define GPDMA1_REQUEST_TIM1_COM       13U      /*!< GPDMA1 HW request is TIM1_COM       */
#define GPDMA1_REQUEST_TIM2_CH1       14U      /*!< GPDMA1 HW request is TIM2_CH1       */
#define GPDMA1_REQUEST_TIM2_CH2       15U      /*!< GPDMA1 HW request is TIM2_CH2       */
#define GPDMA1_REQUEST_TIM2_CH3       16U      /*!< GPDMA1 HW request is TIM2_CH3       */
#define GPDMA1_REQUEST_TIM2_CH4       17U      /*!< GPDMA1 HW request is TIM2_CH4       */
#define GPDMA1_REQUEST_TIM2_UP        18U      /*!< GPDMA1 HW request is TIM2_UP        */
#define GPDMA1_REQUEST_TIM2_TRIG      19U      /*!< GPDMA1 HW request is TIM2_TRIG      */
#define GPDMA1_REQUEST_TIM3_CH1       20U      /*!< GPDMA1 HW request is TIM3_CH1       */
#define GPDMA1_REQUEST_TIM3_CH2       21U      /*!< GPDMA1 HW request is TIM3_CH2       */
#define GPDMA1_REQUEST_TIM3_CH3       22U      /*!< GPDMA1 HW request is TIM3_CH3       */
#define GPDMA1_REQUEST_TIM3_CH4       23U      /*!< GPDMA1 HW request is TIM3_CH4       */
#define GPDMA1_REQUEST_TIM3_UP        24U      /*!< GPDMA1 HW request is TIM3_UP        */
#define GPDMA1_REQUEST_TIM3_TRIG      25U      /*!< GPDMA1 HW request is TIM3_TRIG      */
#define GPDMA1_REQUEST_TIM4_CH1       26U      /*!< GPDMA1 HW request is TIM4_CH1       */
#define GPDMA1_REQUEST_TIM4_CH2       27U      /*!< GPDMA1 HW request is TIM4_CH2       */
#define GPDMA1_REQUEST_TIM4_CH3       28U      /*!< GPDMA1 HW request is TIM4_CH3       */
#define GPDMA1_REQUEST_TIM4_CH4       29U      /*!< GPDMA1 HW request is TIM4_CH4       */
#define GPDMA1_REQUEST_TIM4_UP        30U      /*!< GPDMA1 HW request is TIM4_UP        */
#define GPDMA1_REQUEST_TIM4_TRIG      31U      /*!< GPDMA1 HW request is TIM4_TRIG      */
#define GPDMA1_REQUEST_TIM5_CH1       32U      /*!< GPDMA1 HW request is TIM5_CH1       */
#define GPDMA1_REQUEST_TIM5_CH2       33U      /*!< GPDMA1 HW request is TIM5_CH2       */
#define GPDMA1_REQUEST_TIM5_CH3       34U      /*!< GPDMA1 HW request is TIM5_CH3       */
#define GPDMA1_REQUEST_TIM5_CH4       35U      /*!< GPDMA1 HW request is TIM5_CH4       */
#define GPDMA1_REQUEST_TIM5_UP        36U      /*!< GPDMA1 HW request is TIM5_UP        */
#define GPDMA1_REQUEST_TIM5_TRIG      37U      /*!< GPDMA1 HW request is TIM5_TRIG      */
#define GPDMA1_REQUEST_TIM6_UP        38U      /*!< GPDMA1 HW request is TIM6_UP        */
#define GPDMA1_REQUEST_TIM7_UP        39U      /*!< GPDMA1 HW request is TIM7_UP        */
#define GPDMA1_REQUEST_TIM15_CH1      40U      /*!< GPDMA1 HW request is TIM15_CH1      */
#define GPDMA1_REQUEST_TIM15_CH2      41U      /*!< GPDMA1 HW request is TIM15_CH2      */
#define GPDMA1_REQUEST_TIM15_UP       42U      /*!< GPDMA1 HW request is TIM15_UP       */
#define GPDMA1_REQUEST_TIM15_TRIG     43U      /*!< GPDMA1 HW request is TIM15_TRIG     */
#define GPDMA1_REQUEST_TIM15_COM      44U      /*!< GPDMA1 HW request is TIM15_COM      */
#define GPDMA1_REQUEST_TIM16_CH1      45U      /*!< GPDMA1 HW request is TIM16_CH1      */
#define GPDMA1_REQUEST_TIM16_UP       46U      /*!< GPDMA1 HW request is TIM16_UP       */
#define GPDMA1_REQUEST_TIM16_COM      47U      /*!< GPDMA1 HW request is TIM16_COM      */
#define GPDMA1_REQUEST_TIM17_CH1      48U      /*!< GPDMA1 HW request is TIM17_CH1      */
#define GPDMA1_REQUEST_TIM17_UP       49U      /*!< GPDMA1 HW request is TIM17_UP       */
#define GPDMA1_REQUEST_TIM17_COM      50U      /*!< GPDMA1 HW request is TIM17_COM      */
#define GPDMA1_REQUEST_SPI1_RX        51U      /*!< GPDMA1 HW request is SPI1_RX        */
#define GPDMA1_REQUEST_SPI1_TX        52U      /*!< GPDMA1 HW request is SPI1_TX        */
#define GPDMA1_REQUEST_SPI2_RX        53U      /*!< GPDMA1 HW request is SPI2_RX        */
#define GPDMA1_REQUEST_SPI2_TX        54U      /*!< GPDMA1 HW request is SPI2_TX        */
#define GPDMA1_REQUEST_SPI3_RX        55U      /*!< GPDMA1 HW request is SPI3_RX        */
#define GPDMA1_REQUEST_SPI3_TX        56U      /*!< GPDMA1 HW request is SPI3_TX        */
#define GPDMA1_REQUEST_SPI4_RX        57U      /*!< GPDMA1 HW request is SPI4_RX        */
#define GPDMA1_REQUEST_SPI4_TX        58U      /*!< GPDMA1 HW request is SPI4_TX        */
#define GPDMA1_REQUEST_SPI5_RX        59U      /*!< GPDMA1 HW request is SPI5_RX        */
#define GPDMA1_REQUEST_SPI5_TX        60U      /*!< GPDMA1 HW request is SPI5_TX        */
#define GPDMA1_REQUEST_SPI6_RX        61U      /*!< GPDMA1 HW request is SPI6_RX        */
#define GPDMA1_REQUEST_SPI6_TX        62U      /*!< GPDMA1 HW request is SPI6_TX        */
#define GPDMA1_REQUEST_SAI1_A         63U      /*!< GPDMA1 HW request is SAI1_A         */
#define GPDMA1_REQUEST_SAI1_B         64U      /*!< GPDMA1 HW request is SAI1_B         */
#define GPDMA1_REQUEST_SAI2_A         65U      /*!< GPDMA1 HW request is SAI2_A         */
#define GPDMA1_REQUEST_SAI2_B         66U      /*!< GPDMA1 HW request is SAI2_B         */
#define GPDMA1_REQUEST_I2C1_RX        67U      /*!< GPDMA1 HW request is I2C1_RX        */
#define GPDMA1_REQUEST_I2C1_TX        68U      /*!< GPDMA1 HW request is I2C1_TX        */
#define GPDMA1_REQUEST_I2C2_RX        69U      /*!< GPDMA1 HW request is I2C2_RX        */
#define GPDMA1_REQUEST_I2C2_TX        70U      /*!< GPDMA1 HW request is I2C2_TX        */
#define GPDMA1_REQUEST_I2C3_RX        71U      /*!< GPDMA1 HW request is I2C3_RX        */
#define GPDMA1_REQUEST_I2C3_TX        72U      /*!< GPDMA1 HW request is I2C3_TX        */
#define GPDMA1_REQUEST_USART1_RX      73U      /*!< GPDMA1 HW request is USART1_RX      */
#define GPDMA1_REQUEST_USART1_TX      74U      /*!< GPDMA1 HW request is USART1_TX      */
#define GPDMA1_REQUEST_USART2_RX      75U      /*!< GPDMA1 HW request is USART2_RX      */
#define GPDMA1_REQUEST_USART2_TX      76U      /*!< GPDMA1 HW request is USART2_TX      */
#define GPDMA1_REQUEST_USART3_RX      77U      /*!< GPDMA1 HW request is USART3_RX      */
#define GPDMA1_REQUEST_USART3_TX      78U      /*!< GPDMA1 HW request is USART3_TX      */
#define GPDMA1_REQUEST_UART4_RX       79U      /*!< GPDMA1 HW request is UART4_RX       */
#define GPDMA1_REQUEST_UART4_TX       80U      /*!< GPDMA1 HW request is UART4_TX       */
#define GPDMA1_REQUEST_UART5_RX       81U      /*!< GPDMA1 HW request is UART5_RX       */
#define GPDMA1_REQUEST_UART5_TX       82U      /*!< GPDMA1 HW request is UART5_TX       */
#define GPDMA1_REQUEST_UART7_RX       83U      /*!< GPDMA1 HW request is UART7_RX       */
#define GPDMA1_REQUEST_UART7_TX       84U      /*!< GPDMA1 HW request is UART7_TX       */
#define GPDMA1_REQUEST_UART8_RX       85U      /*!< GPDMA1 HW request is UART8_RX       */
#define GPDMA1_REQUEST_UART8_TX       86U      /*!< GPDMA1 HW request is UART8_TX       */
#define GPDMA1_REQUEST_CORDIC_READ    87U      /*!< GPDMA1 HW request is CORDIC_READ    */
#define GPDMA1_REQUEST_CORDIC_WRITE   88U      /*!< GPDMA1 HW request is CORDIC_WRITE   */
#define GPDMA1_REQUEST_LPTIM1_IC1     89U      /*!< GPDMA1 HW request is LPTIM1_IC1     */
#define GPDMA1_REQUEST_LPTIM1_IC2     90U      /*!< GPDMA1 HW request is LPTIM1_IC2     */
#define GPDMA1_REQUEST_LPTIM1_UE      91U      /*!< GPDMA1 HW request is LPTIM1_UE      */
#define GPDMA1_REQUEST_LPTIM2_IC1     92U      /*!< GPDMA1 HW request is LPTIM2_IC1     */
#define GPDMA1_REQUEST_LPTIM2_IC2     93U      /*!< GPDMA1 HW request is LPTIM2_IC2     */
#define GPDMA1_REQUEST_LPTIM2_UE      94U      /*!< GPDMA1 HW request is LPTIM2_UE      */
#define GPDMA1_REQUEST_SPDIF_RX_DT    95U      /*!< GPDMA1 HW request is SPDIF_RX_DT    */
#define GPDMA1_REQUEST_SPDIF_RX_CS    96U      /*!< GPDMA1 HW request is SPDIF_RX_CS    */
#define GPDMA1_REQUEST_ADF1_FLT0      97U      /*!< GPDMA1 HW request is ADF1_FLT0      */
#define GPDMA1_REQUEST_UCPD1_TX       98U      /*!< GPDMA1 HW request is UCPD1_TX       */
#define GPDMA1_REQUEST_UCPD1_RX       99U      /*!< GPDMA1 HW request is UCPD1_RX       */
#define GPDMA1_REQUEST_PSSI           100U      /*!< GPDMA1 HW request is PSSI          */
#define GPDMA1_REQUEST_LPUART1_RX     101U      /*!< GPDMA1 HW request is LPUART1_RX    */
#define GPDMA1_REQUEST_LPUART1_TX     102U      /*!< GPDMA1 HW request is LPUART1_TX    */
#define GPDMA1_REQUEST_LPTIM3_IC1     103U      /*!< GPDMA1 HW request is LPTIM3_IC1    */
#define GPDMA1_REQUEST_LPTIM3_IC2     104U      /*!< GPDMA1 HW request is LPTIM3_IC2    */
#define GPDMA1_REQUEST_LPTIM3_UE      105U      /*!< GPDMA1 HW request is LPTIM3_UE     */
#define GPDMA1_REQUEST_I3C1_RX        106U      /*!< GPDMA1 HW request is I3C1_RX       */
#define GPDMA1_REQUEST_I3C1_TX        107U      /*!< GPDMA1 HW request is I3C1_TX       */
#define GPDMA1_REQUEST_I3C1_TC        108U      /*!< GPDMA1 HW request is I3C1_TC       */
#define GPDMA1_REQUEST_I3C1_RS        109U      /*!< GPDMA1 HW request is I3C1_RS       */
#define GPDMA1_MAX_REQUEST            109U
#define DMA_REQUEST_SW                DMA_CTR2_SWREQ /*!< DMA SW request                */
#define DMA_BREQ_SINGLE_BURST          0x00000000U     /*!< Hardware request protocol at a single / burst level */
#define DMA_BREQ_BLOCK                 DMA_CTR2_BREQ   /*!< Hardware request protocol at a block level          */
#define DMA_PERIPH_TO_MEMORY 0x00000000U             /*!< Peripheral to memory direction */
#define DMA_MEMORY_TO_PERIPH DMA_CTR2_DREQ           /*!< Memory to peripheral direction */
#define DMA_MEMORY_TO_MEMORY DMA_CTR2_SWREQ          /*!< Memory to memory direction     */
#define DMA_SINC_FIXED       0x00000000U   /*!< Source fixed       single / burst */
#define DMA_SINC_INCREMENTED DMA_CTR1_SINC /*!< Source incremented single / burst */
#define DMA_DINC_FIXED       0x00000000U   /*!< Destination fixed       single / burst */
#define DMA_DINC_INCREMENTED DMA_CTR1_DINC /*!< Destination incremented single / burst */
#define DMA_SRC_DATAWIDTH_BYTE       0x00000000U           /*!< Source data width : Byte       */
#define DMA_SRC_DATAWIDTH_HALFWORD   DMA_CTR1_SDW_LOG2_0   /*!< Source data width : HalfWord   */
#define DMA_SRC_DATAWIDTH_WORD       DMA_CTR1_SDW_LOG2_1   /*!< Source data width : Word       */
#define DMA_SRC_DATAWIDTH_DOUBLEWORD DMA_CTR1_SDW_LOG2     /*!< Source data width : DoubleWord */
#define DMA_DEST_DATAWIDTH_BYTE       0x00000000U          /*!< Destination data width : Byte       */
#define DMA_DEST_DATAWIDTH_HALFWORD   DMA_CTR1_DDW_LOG2_0  /*!< Destination data width : HalfWord   */
#define DMA_DEST_DATAWIDTH_WORD       DMA_CTR1_DDW_LOG2_1  /*!< Destination data width : Word       */
#define DMA_DEST_DATAWIDTH_DOUBLEWORD DMA_CTR1_DDW_LOG2    /*!< Destination data width : DoubleWord */
#define DMA_LOW_PRIORITY_LOW_WEIGHT  0x00000000U    /*!< Priority level : Low Priority, Low weight  */
#define DMA_LOW_PRIORITY_MID_WEIGHT  DMA_CCR_PRIO_0 /*!< Priority level : Low Priority, Mid weight  */
#define DMA_LOW_PRIORITY_HIGH_WEIGHT DMA_CCR_PRIO_1 /*!< Priority level : Low Priority, High weight */
#define DMA_HIGH_PRIORITY            DMA_CCR_PRIO   /*!< Priority level : HIGH Priority             */
#define DMA_SRC_ALLOCATED_PORT0  0x00000000U  /*!< Source allocated Port 0      */
#define DMA_SRC_ALLOCATED_PORT1  DMA_CTR1_SAP /*!< Source allocated Port 1      */
#define DMA_DEST_ALLOCATED_PORT0 0x00000000U  /*!< Destination allocated Port 0 */
#define DMA_DEST_ALLOCATED_PORT1 DMA_CTR1_DAP /*!< Destination allocated Port 1 */
#define DMA_TCEM_BLOCK_TRANSFER          0x00000000U     /*!< The TC event is generated at the end of each block and the
                                                              HT event is generated at the half of each block         */
#define DMA_TCEM_REPEATED_BLOCK_TRANSFER DMA_CTR2_TCEM_0 /*!< The TC event is generated at the end of the repeated block
                                                              and the HT event is generated at the half of the repeated
                                                              block                                                   */
#define DMA_TCEM_EACH_LL_ITEM_TRANSFER   DMA_CTR2_TCEM_1 /*!< The TC event is generated at the end of each linked-list
                                                              item and the HT event is generated at the half of each
                                                              linked-list item                                        */
#define DMA_TCEM_LAST_LL_ITEM_TRANSFER   DMA_CTR2_TCEM   /*!< The TC event is generated at the end of the last
                                                              linked-list item and the HT event is generated at the half
                                                              of the last linked-list item                            */
#define DMA_NORMAL                           (0x00U)     /*!< Normal DMA transfer                    */
#define DMA_PFCTRL                    DMA_CTR2_PFREQ     /*!< HW request peripheral flow control mode */
#define DMA_CHANNEL_PRIV                     (DMA_CHANNEL_ATTR_PRIV_MASK | (1U<<DMA_CHANNEL_PRIV_VAL_POS))           /*!< Channel is privileged             */
#define DMA_CHANNEL_NPRIV                    (DMA_CHANNEL_ATTR_PRIV_MASK)                                            /*!< Channel is unprivileged           */
#define DMA_CHANNEL_ATTRIBUTE_UNLOCKED (0x00U)                                                                       /*!< Channel attribute is unlocked */
#define DMA_CHANNEL_ATTRIBUTE_LOCKED   (0x01U)                                                                       /*!< Channel attribute is locked   */
#define __HAL_DMA_RESET_HANDLE_STATE(__HANDLE__) \
  ((__HANDLE__)->State = HAL_DMA_STATE_RESET)
#define __HAL_DMA_ENABLE(__HANDLE__) \
  ((__HANDLE__)->Instance->CCR |=  DMA_CCR_EN)
#define __HAL_DMA_DISABLE(__HANDLE__) \
  ((__HANDLE__)->Instance->CCR |= (DMA_CCR_SUSP | DMA_CCR_RESET))
#define __HAL_DMA_GET_FLAG(__HANDLE__, __FLAG__) \
  ((__HANDLE__)->Instance->CSR & (__FLAG__))
#define __HAL_DMA_CLEAR_FLAG(__HANDLE__, __FLAG__) \
  ((__HANDLE__)->Instance->CFCR = (__FLAG__))
#define __HAL_DMA_ENABLE_IT(__HANDLE__, __INTERRUPT__) \
  ((__HANDLE__)->Instance->CCR |= (__INTERRUPT__))
#define __HAL_DMA_DISABLE_IT(__HANDLE__, __INTERRUPT__) \
  ((__HANDLE__)->Instance->CCR &= ~(__INTERRUPT__))
#define __HAL_DMA_GET_IT_SOURCE(__HANDLE__, __INTERRUPT__) \
  (((__HANDLE__)->Instance->CCR & (__INTERRUPT__)))
#define __HAL_DMA_SET_COUNTER(__HANDLE__, __COUNTER__) \
  MODIFY_REG((__HANDLE__)->Instance->CBR1, DMA_CBR1_BNDT, (__COUNTER__))
#define __HAL_DMA_GET_COUNTER(__HANDLE__) \
  (((__HANDLE__)->Instance->CBR1) & DMA_CBR1_BNDT)
#define HAL_TIMEOUT_DMA_ABORT          (0x00000005U) /* DMA channel abort timeout 5 milli-second */
#define HAL_DMA_CHANNEL_START          (0x00000050U) /* DMA channel offset                       */
#define HAL_DMA_CHANNEL_SIZE           (0x00000080U) /* DMA channel size                         */
#define HAL_DMA_OFFSET_MASK            (0x00000FFFU) /* DMA channel offset mask                  */
#define DMA_CHANNEL_ATTR_PRIV_MASK     (0x01000000U) /* DMA channel privilege               */
#define DMA_CHANNEL_PRIV_VAL_POS                 0U
#define DMA_CHANNEL_BURST_MIN          (0x00000001U) /* DMA channel minimum burst size           */
#define DMA_CHANNEL_BURST_MAX          (0x00000040U) /* DMA channel maximum burst size           */
#define GET_DMA_INSTANCE(__HANDLE__) \
  ((DMA_TypeDef *)((uint32_t)((__HANDLE__)->Instance) & (~HAL_DMA_OFFSET_MASK)))
#define GET_DMA_CHANNEL(__HANDLE__) \
  ((((uint32_t)((__HANDLE__)->Instance) & HAL_DMA_OFFSET_MASK) - HAL_DMA_CHANNEL_START) / HAL_DMA_CHANNEL_SIZE)
#define IS_DMA_MODE(MODE) \
  (((MODE) == DMA_NORMAL) || \
   ((MODE) == DMA_PFCTRL))
#define IS_DMA_DIRECTION(DIRECTION)         \
  (((DIRECTION) == DMA_PERIPH_TO_MEMORY) || \
   ((DIRECTION) == DMA_MEMORY_TO_PERIPH) || \
   ((DIRECTION) == DMA_MEMORY_TO_MEMORY))
#define IS_DMA_LEVEL_COMPLETE(LEVEL)     \
  (((LEVEL) == HAL_DMA_FULL_TRANSFER) || \
   ((LEVEL) == HAL_DMA_HALF_TRANSFER))
#define IS_DMA_SOURCE_INC(INC)  \
  (((INC) == DMA_SINC_FIXED) || \
   ((INC) == DMA_SINC_INCREMENTED))
#define IS_DMA_DESTINATION_INC(INC) \
  (((INC) == DMA_DINC_FIXED)     || \
   ((INC) == DMA_DINC_INCREMENTED))
#define IS_DMA_SOURCE_DATA_WIDTH(WIDTH)       \
  (((WIDTH) == DMA_SRC_DATAWIDTH_BYTE)     || \
   ((WIDTH) == DMA_SRC_DATAWIDTH_HALFWORD) || \
   ((WIDTH) == DMA_SRC_DATAWIDTH_WORD)     || \
   ((WIDTH) == DMA_SRC_DATAWIDTH_DOUBLEWORD))
#define IS_DMA_DESTINATION_DATA_WIDTH(WIDTH)   \
  (((WIDTH) == DMA_DEST_DATAWIDTH_BYTE)     || \
   ((WIDTH) == DMA_DEST_DATAWIDTH_HALFWORD) || \
   ((WIDTH) == DMA_DEST_DATAWIDTH_WORD)     || \
   ((WIDTH) == DMA_DEST_DATAWIDTH_DOUBLEWORD))
#define IS_DMA_BURST_LENGTH(LENGTH)       \
  (((LENGTH) >= DMA_CHANNEL_BURST_MIN) && \
   ((LENGTH) <= DMA_CHANNEL_BURST_MAX))
#define IS_DMA_PRIORITY(PRIORITY)                  \
  (((PRIORITY) == DMA_LOW_PRIORITY_LOW_WEIGHT)  || \
   ((PRIORITY) == DMA_LOW_PRIORITY_MID_WEIGHT)  || \
   ((PRIORITY) == DMA_LOW_PRIORITY_HIGH_WEIGHT) || \
   ((PRIORITY) == DMA_HIGH_PRIORITY))
#define  IS_DMA_TRANSFER_ALLOCATED_PORT(ALLOCATED_PORT) \
  (((ALLOCATED_PORT) & (~(DMA_CTR1_SAP | DMA_CTR1_DAP))) == 0U)
#define IS_DMA_REQUEST(REQUEST)     \
  (((REQUEST) == DMA_REQUEST_SW) || \
   ((REQUEST) <= GPDMA1_REQUEST_I3C1_RS))
#define IS_DMA_BLOCK_HW_REQUEST(MODE)   \
  (((MODE) == DMA_BREQ_SINGLE_BURST) || \
   ((MODE) == DMA_BREQ_BLOCK))
#define IS_DMA_TCEM_EVENT_MODE(MODE)               \
  (((MODE) == DMA_TCEM_BLOCK_TRANSFER)          || \
   ((MODE) == DMA_TCEM_REPEATED_BLOCK_TRANSFER) || \
   ((MODE) == DMA_TCEM_EACH_LL_ITEM_TRANSFER)   || \
   ((MODE) == DMA_TCEM_LAST_LL_ITEM_TRANSFER))
#define IS_DMA_BLOCK_SIZE(SIZE) \
  (((SIZE) > 0U) && ((SIZE) <= DMA_CBR1_BNDT))
#define IS_DMA_GLOBAL_ACTIVE_FLAG(INSTANCE, GLOBAL_FLAG) \
  (((INSTANCE)->MISR & (GLOBAL_FLAG)))
#define IS_DMA_ATTRIBUTES(ATTRIBUTE)    \
  (((ATTRIBUTE) == DMA_CHANNEL_PRIV) || \
   ((ATTRIBUTE) == DMA_CHANNEL_NPRIV))
