/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define SBS_HDPL_VALUE_0               0x000000B4U               /*!< Hide protection level 0 */

#define SBS_HDPL_VALUE_1               0x00000051U               /*!< Hide protection level 1 */

#define SBS_HDPL_VALUE_2               0x0000008AU               /*!< Hide protection level 2 */

#define SBS_HDPL_VALUE_3               0x0000006FU               /*!< Hide protection level 3 */

#define SBS_IT_FPU_IOC                 SBS_FPUIMR_FPU_IE_0       /*!< Floating Point Unit Invalid operation Interrupt */

#define SBS_IT_FPU_DZC                 SBS_FPUIMR_FPU_IE_1       /*!< Floating Point Unit Divide-by-zero Interrupt */

#define SBS_IT_FPU_UFC                 SBS_FPUIMR_FPU_IE_2       /*!< Floating Point Unit Underflow Interrupt */

#define SBS_IT_FPU_OFC                 SBS_FPUIMR_FPU_IE_3       /*!< Floating Point Unit Overflow Interrupt */

#define SBS_IT_FPU_IDC                 SBS_FPUIMR_FPU_IE_4       /*!< Floating Point Unit Input denormal Interrupt */

#define SBS_IT_FPU_IXC                 SBS_FPUIMR_FPU_IE_5       /*!< Floating Point Unit Inexact Interrupt */

#define SBS_IO_ANALOG_CELL             SBS_CCCSR_COMP_EN         /*!< Compensation cell for the I/O analog switches */

#define SBS_IO_XSPI1_CELL              SBS_CCCSR_XSPI1_COMP_EN   /*!< Compensation cell for the I/O of the XSPI1 */

#define SBS_IO_XSPI2_CELL              SBS_CCCSR_XSPI2_COMP_EN   /*!< Compensation cell for the I/O of the XSPI2 */

#define SBS_IO_ANALOG_CELL_READY       SBS_CCCSR_COMP_RDY        /*!< Ready flag of compensation cell for the I/O analog switches */

#define SBS_IO_XSPI1_CELL_READY        SBS_CCCSR_XSPI1_COMP_RDY  /*!< Ready flag of compensation cell for the I/O of the XSPI1 */

#define SBS_IO_XSPI2_CELL_READY        SBS_CCCSR_XSPI2_COMP_RDY  /*!< Ready flag of compensation cell for the I/O of the XSPI2 */

#define SBS_IO_CELL_CODE               0UL                       /*!< Code from the cell */

#define SBS_IO_REGISTER_CODE           1UL                       /*!< Code from the values in the cell code register */

#define SBS_IO_ANALOG_HSLV             SBS_CCCSR_IOHSLV          /*!< High speed at low voltage for the I/O analog switches */

#define SBS_IO_XSPI1_HSLV              SBS_CCCSR_XSPI1_IOHSLV    /*!< High speed at low voltage for the I/O of the XSPI1 */

#define SBS_IO_XSPI2_HSLV              SBS_CCCSR_XSPI2_IOHSLV    /*!< High speed at low voltage for the I/O of the XSPI2 */

#define SBS_ETHERNET_PHY_GMII_OR_MII    0U                       /*!< GMII or MII */

#define SBS_ETHERNET_PHY_RMII           SBS_PMCR_ETH_PHYSEL_2    /*!< RMII */

#define SBS_AXISRAM_WS_0               0U                         /*!< 0 Wait state */

#define SBS_AXISRAM_WS_1               SBS_PMCR_AXISRAM_WS        /*!< 1 Wait state */

#define SBS_EXTI_PIN_PORTA             0x00UL                     /*!< Port A pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTB             0x01UL                     /*!< Port B pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTC             0x02UL                     /*!< Port C pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTD             0x03UL                     /*!< Port D pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTE             0x04UL                     /*!< Port E pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTF             0x05UL                     /*!< Port F pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTG             0x06UL                     /*!< Port G pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTH             0x07UL                     /*!< Port H pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTM             0x0CUL                     /*!< Port M pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTN             0x0DUL                     /*!< Port N pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTO             0x0EUL                     /*!< Port O pin input of EXTI event detection */

#define SBS_EXTI_PIN_PORTP             0x0FUL                     /*!< Port P pin input of EXTI event detection */

#define AXIM_ASIB_READ_ISS_NORMAL       0U                         /*!< Normal issuing capability */

#define AXIM_ASIB_READ_ISS_FORCE_TO_1   AXIM_ASIB_FNMOD_READ_ISS   /*!< Force issuing capability to 1 */

#define AXIM_ASIB_WRITE_ISS_NORMAL      0U                          /*!< Normal issuing capability */

#define AXIM_ASIB_WRITE_ISS_FORCE_TO_1  AXIM_ASIB_FNMOD_WRITE_ISS   /*!< Force issuing capability to 1 */

#define AXIM_AMIB_READ_ISS_NORMAL       0U                         /*!< Normal issuing capability */

#define AXIM_AMIB_READ_ISS_FORCE_TO_1   AXIM_AMIB_FNMOD_READ_ISS   /*!< Force issuing capability to 1 */

#define AXIM_AMIB_WRITE_ISS_NORMAL      0U                          /*!< Normal issuing capability */

#define AXIM_AMIB_WRITE_ISS_FORCE_TO_1  AXIM_AMIB_FNMOD_WRITE_ISS   /*!< Force issuing capability to 1 */

#define AXIM_AMIB_WRITE_ISS_BM_NORMAL      0U                          /*!< Normal issuing capability */

#define AXIM_AMIB_WRITE_ISS_BM_FORCE_TO_1  AXIM_AMIB_FNMOD_WRITE_ISS   /*!< Force issuing capability to 1 */

#define __HAL_SBS_FPU_INTERRUPT_ENABLE(__INTERRUPT__)    do { \
                                                              assert_param(IS_SBS_FPU_INTERRUPT((__INTERRUPT__))); \
                                                              SET_BIT(SBS->FPUIMR, (__INTERRUPT__)); \
                                                            } while(0)

#define __HAL_SBS_FPU_INTERRUPT_DISABLE(__INTERRUPT__)   do { \
                                                              assert_param(IS_SBS_FPU_INTERRUPT((__INTERRUPT__))); \
                                                              CLEAR_BIT(SBS->FPUIMR, (__INTERRUPT__)); \
                                                            } while(0)

#define __HAL_SBS_GET_MEMORIES_ERASE_STATUS()            ((SBS->MESR) & (SBS_MESR_MEF))

#define VREFBUF_VOLTAGE_SCALE0   VREFBUF_CSR_VRS_OUT1   /*!< Voltage reference scale 0 (VREF_OUT1) */

#define VREFBUF_VOLTAGE_SCALE1   VREFBUF_CSR_VRS_OUT2   /*!< Voltage reference scale 1 (VREF_OUT2) */

#define VREFBUF_VOLTAGE_SCALE2   VREFBUF_CSR_VRS_OUT3   /*!< Voltage reference scale 2 (VREF_OUT3) */

#define VREFBUF_VOLTAGE_SCALE3   VREFBUF_CSR_VRS_OUT4   /*!< Voltage reference scale 3 (VREF_OUT4) */

#define IS_VREFBUF_VOLTAGE_SCALE(__SCALE__)  (((__SCALE__) == VREFBUF_VOLTAGE_SCALE0) || \
                                              ((__SCALE__) == VREFBUF_VOLTAGE_SCALE1) || \
                                              ((__SCALE__) == VREFBUF_VOLTAGE_SCALE2) || \
                                              ((__SCALE__) == VREFBUF_VOLTAGE_SCALE3))

#define VREFBUF_HIGH_IMPEDANCE_DISABLE  ((uint32_t)0x00000000) /*!< VREF_plus pin is internally connected to Voltage reference buffer output */

#define VREFBUF_HIGH_IMPEDANCE_ENABLE   VREFBUF_CSR_HIZ        /*!< VREF_plus pin is high impedance */

#define IS_VREFBUF_HIGH_IMPEDANCE(__VALUE__)  (((__VALUE__) == VREFBUF_HIGH_IMPEDANCE_DISABLE) || \
                                               ((__VALUE__) == VREFBUF_HIGH_IMPEDANCE_ENABLE))

#define IS_VREFBUF_TRIMMING(__VALUE__)        ((__VALUE__) <= VREFBUF_CCR_TRIM)

#define FMC_SWAPBANK_MODE0              (0x00000000U)     /*!< FMC memory default mapping is used */

#define FMC_SWAPBANK_MODE1              FMC_BCR1_BMAP_0   /*!< FMC SDRAM bank1 and NOR/SRAM/PSRAM bank are swapped */

#define IS_FMC_SWAPBANK_MODE(__MODE__) (((__MODE__) == FMC_SWAPBANK_MODE0) || \
                                        ((__MODE__) == FMC_SWAPBANK_MODE1))

#define IS_SBS_FPU_INTERRUPT(__INTERRUPT__)      ((((__INTERRUPT__) & SBS_IT_FPU_IOC) == SBS_IT_FPU_IOC) || \
                                                  (((__INTERRUPT__) & SBS_IT_FPU_DZC) == SBS_IT_FPU_DZC) || \
                                                  (((__INTERRUPT__) & SBS_IT_FPU_UFC) == SBS_IT_FPU_UFC) || \
                                                  (((__INTERRUPT__) & SBS_IT_FPU_OFC) == SBS_IT_FPU_OFC) || \
                                                  (((__INTERRUPT__) & SBS_IT_FPU_IDC) == SBS_IT_FPU_IDC) || \
                                                  (((__INTERRUPT__) & SBS_IT_FPU_IXC) == SBS_IT_FPU_IXC))

#define IS_SBS_HDPL(__LEVEL__)                   (((__LEVEL__) == SBS_HDPL_VALUE_0) || \
                                                  ((__LEVEL__) == SBS_HDPL_VALUE_1) || \
                                                  ((__LEVEL__) == SBS_HDPL_VALUE_2) || \
                                                  ((__LEVEL__) == SBS_HDPL_VALUE_3))

#define IS_SBS_COMPENSATION_CELL(__CELL__)       (((__CELL__) == SBS_IO_ANALOG_CELL) || \
                                                  ((__CELL__) == SBS_IO_XSPI1_CELL)  || \
                                                  ((__CELL__) == SBS_IO_XSPI2_CELL))

#define IS_SBS_COMPENSATION_CELL_READY(__CELL__) (((__CELL__) == SBS_IO_ANALOG_CELL_READY) || \
                                                  ((__CELL__) == SBS_IO_XSPI1_CELL_READY)  || \
                                                  ((__CELL__) == SBS_IO_XSPI2_CELL_READY))

#define IS_SBS_IOHSLV(__HSLV__)                  (((__HSLV__) == SBS_IO_ANALOG_HSLV) || \
                                                  ((__HSLV__) == SBS_IO_XSPI1_HSLV)  || \
                                                  ((__HSLV__) == SBS_IO_XSPI2_HSLV))

#define IS_SBS_EXTI_INPUT(__INPUT__)             ((__INPUT__) < 16U)

#define IS_SBS_EXTI_PIN(__PIN__)                 (((__PIN__) == SBS_EXTI_PIN_PORTA) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTB) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTC) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTD) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTE) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTF) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTG) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTH) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTM) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTN) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTO) || \
                                                  ((__PIN__) == SBS_EXTI_PIN_PORTP))

#define IS_AXIM_ASIB_READ_ISS(__ISS__)          (((__ISS__) == AXIM_ASIB_READ_ISS_NORMAL) || \
                                                 ((__ISS__) == AXIM_ASIB_READ_ISS_FORCE_TO_1))

#define IS_AXIM_ASIB_WRITE_ISS(__ISS__)         (((__ISS__) == AXIM_ASIB_WRITE_ISS_NORMAL) || \
                                                 ((__ISS__) == AXIM_ASIB_WRITE_ISS_FORCE_TO_1))

#define IS_AXIM_QOS(__QOS__)                    ((__QOS__) <= AXIM_ASIB_READQOS_AR_QOS)

#define IS_AXIM_AMIB_READ_ISS(__ISS__)          (((__ISS__) == AXIM_AMIB_READ_ISS_NORMAL) || \
                                                 ((__ISS__) == AXIM_AMIB_READ_ISS_FORCE_TO_1))

#define IS_AXIM_AMIB_WRITE_ISS(__ISS__)         (((__ISS__) == AXIM_AMIB_WRITE_ISS_NORMAL) || \
                                                 ((__ISS__) == AXIM_AMIB_WRITE_ISS_FORCE_TO_1))

#define IS_AXIM_AMIB_READ_ISS_BM(__ISS__)       (((__ISS__) == AXIM_AMIB_READ_ISS_NORMAL) || \
                                                 ((__ISS__) == AXIM_AMIB_READ_ISS_FORCE_TO_1))

#define IS_AXIM_AMIB_WRITE_ISS_BM(__ISS__)      (((__ISS__) == AXIM_AMIB_WRITE_ISS_BM_NORMAL) || \
                                                 ((__ISS__) == AXIM_AMIB_WRITE_ISS_BM_FORCE_TO_1))

#define VREFBUF_TIMEOUT_VALUE     (uint32_t)10   /* 10 ms  */

#define SBS_HDPL_INCREMENT_VALUE  (uint8_t)0x6A

#define SBS_DEBUG_LOCK_VALUE      (uint8_t)0xC3

#define SBS_DEBUG_UNLOCK_VALUE    (uint8_t)0xB4

#define SBS_BKLOCKR_MASK          (SBS_BKLOCKR_PVD_BL      | \
                                   SBS_BKLOCKR_FLASHECC_BL | \
                                   SBS_BKLOCKR_CM7LCKUP_BL | \
                                   SBS_BKLOCKR_BKRAMECC_BL | \
                                   SBS_BKLOCKR_DTCMECC_BL  | \
                                   SBS_BKLOCKR_ITCMECC_BL  | \
                                   SBS_BKLOCKR_ARAM3ECC_BL | \
                                   SBS_BKLOCKR_ARAM1ECC_BL)

#define IS_SBS_TIMER_BREAK_INPUT(__VALUE__) \
  ((((__VALUE__) & SBS_BKLOCKR_MASK) != 0U) && \
   (((__VALUE__) & ~SBS_BKLOCKR_MASK) == 0U))

#define IS_SBS_IO_COMPENSATION_CODE(__VALUE__) \
  (((__VALUE__) == SBS_IO_CELL_CODE) || \
   ((__VALUE__) == SBS_IO_REGISTER_CODE))

#define IS_SBS_IO_COMPENSATION_CELL_PMOS_VALUE(__VALUE__) (((__VALUE__) < 16U))

#define IS_SBS_IO_COMPENSATION_CELL_NMOS_VALUE(__VALUE__) (((__VALUE__) < 16U))

#define IS_SBS_ETHERNET_PHY(__VALUE__) \
  (((__VALUE__) == SBS_ETHERNET_PHY_GMII_OR_MII) || \
   ((__VALUE__) == SBS_ETHERNET_PHY_RMII))

#define IS_SBS_AXISRAM_WS(__VALUE__) \
  (((__VALUE__) == SBS_AXISRAM_WS_0) || \
   ((__VALUE__) == SBS_AXISRAM_WS_1))
