// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifndef STM32H7RSxx_LL_ADC_H
#define STM32H7RSxx_LL_ADC_H
#ifdef __cplusplus
#endif
#include "stm32h7rsxx.h"
#if defined (ADC1) || defined (ADC2)
#define ADC_SQR1_REGOFFSET                 (0x00000000UL)
#define ADC_SQR2_REGOFFSET                 (0x00000100UL)
#define ADC_SQR3_REGOFFSET                 (0x00000200UL)
#define ADC_SQR4_REGOFFSET                 (0x00000300UL)
#define ADC_REG_SQRX_REGOFFSET_MASK        (ADC_SQR1_REGOFFSET | ADC_SQR2_REGOFFSET \
                                            | ADC_SQR3_REGOFFSET | ADC_SQR4_REGOFFSET)
#define ADC_SQRX_REGOFFSET_POS             (8UL) 
#define ADC_REG_RANK_ID_SQRX_MASK          (ADC_CHANNEL_ID_NUMBER_MASK_POSBIT0)
#define ADC_REG_RANK_1_SQRX_BITOFFSET_POS  (ADC_SQR1_SQ1_Pos)
#define ADC_REG_RANK_2_SQRX_BITOFFSET_POS  (ADC_SQR1_SQ2_Pos)
#define ADC_REG_RANK_3_SQRX_BITOFFSET_POS  (ADC_SQR1_SQ3_Pos)
#define ADC_REG_RANK_4_SQRX_BITOFFSET_POS  (ADC_SQR1_SQ4_Pos)
#define ADC_REG_RANK_5_SQRX_BITOFFSET_POS  (ADC_SQR2_SQ5_Pos)
#define ADC_REG_RANK_6_SQRX_BITOFFSET_POS  (ADC_SQR2_SQ6_Pos)
#define ADC_REG_RANK_7_SQRX_BITOFFSET_POS  (ADC_SQR2_SQ7_Pos)
#define ADC_REG_RANK_8_SQRX_BITOFFSET_POS  (ADC_SQR2_SQ8_Pos)
#define ADC_REG_RANK_9_SQRX_BITOFFSET_POS  (ADC_SQR2_SQ9_Pos)
#define ADC_REG_RANK_10_SQRX_BITOFFSET_POS (ADC_SQR3_SQ10_Pos)
#define ADC_REG_RANK_11_SQRX_BITOFFSET_POS (ADC_SQR3_SQ11_Pos)
#define ADC_REG_RANK_12_SQRX_BITOFFSET_POS (ADC_SQR3_SQ12_Pos)
#define ADC_REG_RANK_13_SQRX_BITOFFSET_POS (ADC_SQR3_SQ13_Pos)
#define ADC_REG_RANK_14_SQRX_BITOFFSET_POS (ADC_SQR3_SQ14_Pos)
#define ADC_REG_RANK_15_SQRX_BITOFFSET_POS (ADC_SQR4_SQ15_Pos)
#define ADC_REG_RANK_16_SQRX_BITOFFSET_POS (ADC_SQR4_SQ16_Pos)
#define ADC_JDR1_REGOFFSET                 (0x00000000UL)
#define ADC_JDR2_REGOFFSET                 (0x00000100UL)
#define ADC_JDR3_REGOFFSET                 (0x00000200UL)
#define ADC_JDR4_REGOFFSET                 (0x00000300UL)
#define ADC_INJ_JDRX_REGOFFSET_MASK        (ADC_JDR1_REGOFFSET | ADC_JDR2_REGOFFSET \
                                            | ADC_JDR3_REGOFFSET | ADC_JDR4_REGOFFSET)
#define ADC_INJ_RANK_ID_JSQR_MASK          (ADC_CHANNEL_ID_NUMBER_MASK_POSBIT0)
#define ADC_JDRX_REGOFFSET_POS             (8UL) 
#define ADC_INJ_RANK_1_JSQR_BITOFFSET_POS  (ADC_JSQR_JSQ1_Pos)
#define ADC_INJ_RANK_2_JSQR_BITOFFSET_POS  (ADC_JSQR_JSQ2_Pos)
#define ADC_INJ_RANK_3_JSQR_BITOFFSET_POS  (ADC_JSQR_JSQ3_Pos)
#define ADC_INJ_RANK_4_JSQR_BITOFFSET_POS  (ADC_JSQR_JSQ4_Pos)
#define ADC_REG_TRIG_EXT_EDGE_DEFAULT      (ADC_CFGR_EXTEN_0) 
#define ADC_REG_TRIG_SOURCE_MASK           (((LL_ADC_REG_TRIG_SOFTWARE & ADC_CFGR_EXTSEL) << (4U * 0UL)) | \
                                            ((ADC_CFGR_EXTSEL)                            << (4U * 1UL)) | \
                                            ((ADC_CFGR_EXTSEL)                            << (4U * 2UL)) | \
                                            ((ADC_CFGR_EXTSEL)                            << (4U * 3UL))  )
#define ADC_REG_TRIG_EDGE_MASK             (((LL_ADC_REG_TRIG_SOFTWARE & ADC_CFGR_EXTEN) << (4U * 0UL)) | \
                                            ((ADC_REG_TRIG_EXT_EDGE_DEFAULT)             << (4U * 1UL)) | \
                                            ((ADC_REG_TRIG_EXT_EDGE_DEFAULT)             << (4U * 2UL)) | \
                                            ((ADC_REG_TRIG_EXT_EDGE_DEFAULT)             << (4U * 3UL))  )
#define ADC_REG_TRIG_EXTSEL_BITOFFSET_POS  (ADC_CFGR_EXTSEL_Pos)
#define ADC_REG_TRIG_EXTEN_BITOFFSET_POS   (ADC_CFGR_EXTEN_Pos)
#define ADC_INJ_TRIG_EXT_EDGE_DEFAULT      (ADC_JSQR_JEXTEN_0) 
#define ADC_INJ_TRIG_SOURCE_MASK           (((LL_ADC_INJ_TRIG_SOFTWARE & ADC_JSQR_JEXTSEL)  << (4U * 0UL)) | \
                                            ((ADC_JSQR_JEXTSEL)                             << (4U * 1UL)) | \
                                            ((ADC_JSQR_JEXTSEL)                             << (4U * 2UL)) | \
                                            ((ADC_JSQR_JEXTSEL)                             << (4U * 3UL))  )
#define ADC_INJ_TRIG_EDGE_MASK             (((LL_ADC_INJ_TRIG_SOFTWARE & ADC_JSQR_JEXTEN) << (4U * 0UL)) | \
                                            ((ADC_INJ_TRIG_EXT_EDGE_DEFAULT)              << (4U * 1UL)) | \
                                            ((ADC_INJ_TRIG_EXT_EDGE_DEFAULT)              << (4U * 2UL)) | \
                                            ((ADC_INJ_TRIG_EXT_EDGE_DEFAULT)              << (4U * 3UL))  )
#define ADC_INJ_TRIG_EXTSEL_BITOFFSET_POS  (ADC_JSQR_JEXTSEL_Pos)
#define ADC_INJ_TRIG_EXTEN_BITOFFSET_POS   (ADC_JSQR_JEXTEN_Pos)
#define ADC_CHANNEL_ID_NUMBER_MASK         (ADC_CFGR_AWD1CH)
#define ADC_CHANNEL_ID_BITFIELD_MASK       (ADC_AWD2CR_AWD2CH)
#define ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS (ADC_CFGR_AWD1CH_Pos)
#define ADC_CHANNEL_ID_MASK                (ADC_CHANNEL_ID_NUMBER_MASK | ADC_CHANNEL_ID_BITFIELD_MASK \
                                            | ADC_CHANNEL_ID_INTERNAL_CH_MASK)
#define ADC_CHANNEL_ID_NUMBER_MASK_POSBIT0 (ADC_SQR2_SQ5) 
#define ADC_CHANNEL_ID_INTERNAL_CH         (0x80000000UL) 
#define ADC_CHANNEL_ID_INTERNAL_CH_2       (0x00080000UL) 
#define ADC_CHANNEL_ID_INTERNAL_CH_MASK    (ADC_CHANNEL_ID_INTERNAL_CH | ADC_CHANNEL_ID_INTERNAL_CH_2)
#define ADC_SMPR1_REGOFFSET                (0x00000000UL)
#define ADC_SMPR2_REGOFFSET                (0x02000000UL)
#define ADC_CHANNEL_SMPRX_REGOFFSET_MASK   (ADC_SMPR1_REGOFFSET | ADC_SMPR2_REGOFFSET)
#define ADC_SMPRX_REGOFFSET_POS            (25UL)           
#define ADC_CHANNEL_SMPx_BITOFFSET_MASK    (0x01F00000UL)
#define ADC_CHANNEL_SMPx_BITOFFSET_POS     (20UL)           
#define ADC_CHANNEL_0_NUMBER               (0x00000000UL)
#define ADC_CHANNEL_1_NUMBER               (ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_2_NUMBER               (ADC_CFGR_AWD1CH_1)
#define ADC_CHANNEL_3_NUMBER               (ADC_CFGR_AWD1CH_1 | ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_4_NUMBER               (ADC_CFGR_AWD1CH_2)
#define ADC_CHANNEL_5_NUMBER               (ADC_CFGR_AWD1CH_2 | ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_6_NUMBER               (ADC_CFGR_AWD1CH_2 | ADC_CFGR_AWD1CH_1)
#define ADC_CHANNEL_7_NUMBER               (ADC_CFGR_AWD1CH_2 | ADC_CFGR_AWD1CH_1 | ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_8_NUMBER               (ADC_CFGR_AWD1CH_3)
#define ADC_CHANNEL_9_NUMBER               (ADC_CFGR_AWD1CH_3 | ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_10_NUMBER              (ADC_CFGR_AWD1CH_3 | ADC_CFGR_AWD1CH_1)
#define ADC_CHANNEL_11_NUMBER              (ADC_CFGR_AWD1CH_3 | ADC_CFGR_AWD1CH_1 | ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_12_NUMBER              (ADC_CFGR_AWD1CH_3 | ADC_CFGR_AWD1CH_2)
#define ADC_CHANNEL_13_NUMBER              (ADC_CFGR_AWD1CH_3 | ADC_CFGR_AWD1CH_2 | ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_14_NUMBER              (ADC_CFGR_AWD1CH_3 | ADC_CFGR_AWD1CH_2 | ADC_CFGR_AWD1CH_1)
#define ADC_CHANNEL_15_NUMBER              (ADC_CFGR_AWD1CH_3 | ADC_CFGR_AWD1CH_2 | \
                                            ADC_CFGR_AWD1CH_1 | ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_16_NUMBER              (ADC_CFGR_AWD1CH_4)
#define ADC_CHANNEL_17_NUMBER              (ADC_CFGR_AWD1CH_4 | ADC_CFGR_AWD1CH_0)
#define ADC_CHANNEL_18_NUMBER              (ADC_CFGR_AWD1CH_4 | ADC_CFGR_AWD1CH_1)
#define ADC_CHANNEL_0_BITFIELD             (ADC_AWD2CR_AWD2CH_0)
#define ADC_CHANNEL_1_BITFIELD             (ADC_AWD2CR_AWD2CH_1)
#define ADC_CHANNEL_2_BITFIELD             (ADC_AWD2CR_AWD2CH_2)
#define ADC_CHANNEL_3_BITFIELD             (ADC_AWD2CR_AWD2CH_3)
#define ADC_CHANNEL_4_BITFIELD             (ADC_AWD2CR_AWD2CH_4)
#define ADC_CHANNEL_5_BITFIELD             (ADC_AWD2CR_AWD2CH_5)
#define ADC_CHANNEL_6_BITFIELD             (ADC_AWD2CR_AWD2CH_6)
#define ADC_CHANNEL_7_BITFIELD             (ADC_AWD2CR_AWD2CH_7)
#define ADC_CHANNEL_8_BITFIELD             (ADC_AWD2CR_AWD2CH_8)
#define ADC_CHANNEL_9_BITFIELD             (ADC_AWD2CR_AWD2CH_9)
#define ADC_CHANNEL_10_BITFIELD            (ADC_AWD2CR_AWD2CH_10)
#define ADC_CHANNEL_11_BITFIELD            (ADC_AWD2CR_AWD2CH_11)
#define ADC_CHANNEL_12_BITFIELD            (ADC_AWD2CR_AWD2CH_12)
#define ADC_CHANNEL_13_BITFIELD            (ADC_AWD2CR_AWD2CH_13)
#define ADC_CHANNEL_14_BITFIELD            (ADC_AWD2CR_AWD2CH_14)
#define ADC_CHANNEL_15_BITFIELD            (ADC_AWD2CR_AWD2CH_15)
#define ADC_CHANNEL_16_BITFIELD            (ADC_AWD2CR_AWD2CH_16)
#define ADC_CHANNEL_17_BITFIELD            (ADC_AWD2CR_AWD2CH_17)
#define ADC_CHANNEL_18_BITFIELD            (ADC_AWD2CR_AWD2CH_18)
#define ADC_CHANNEL_0_SMP                  (ADC_SMPR1_REGOFFSET | (( 0UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_1_SMP                  (ADC_SMPR1_REGOFFSET | (( 3UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_2_SMP                  (ADC_SMPR1_REGOFFSET | (( 6UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_3_SMP                  (ADC_SMPR1_REGOFFSET | (( 9UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_4_SMP                  (ADC_SMPR1_REGOFFSET | ((12UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_5_SMP                  (ADC_SMPR1_REGOFFSET | ((15UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_6_SMP                  (ADC_SMPR1_REGOFFSET | ((18UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_7_SMP                  (ADC_SMPR1_REGOFFSET | ((21UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_8_SMP                  (ADC_SMPR1_REGOFFSET | ((24UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_9_SMP                  (ADC_SMPR1_REGOFFSET | ((27UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_10_SMP                 (ADC_SMPR2_REGOFFSET | (( 0UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_11_SMP                 (ADC_SMPR2_REGOFFSET | (( 3UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_12_SMP                 (ADC_SMPR2_REGOFFSET | (( 6UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_13_SMP                 (ADC_SMPR2_REGOFFSET | (( 9UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_14_SMP                 (ADC_SMPR2_REGOFFSET | ((12UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_15_SMP                 (ADC_SMPR2_REGOFFSET | ((15UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_16_SMP                 (ADC_SMPR2_REGOFFSET | ((18UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_17_SMP                 (ADC_SMPR2_REGOFFSET | ((21UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_CHANNEL_18_SMP                 (ADC_SMPR2_REGOFFSET | ((24UL) << ADC_CHANNEL_SMPx_BITOFFSET_POS))
#define ADC_SINGLEDIFF_CALIB_START_MASK    (ADC_CR_ADCALDIF)
#define ADC_SINGLEDIFF_CALIB_FACTOR_MASK   (ADC_CALFACT_CALFACT_D | ADC_CALFACT_CALFACT_S)
#define ADC_SINGLEDIFF_CHANNEL_MASK        (ADC_CHANNEL_ID_BITFIELD_MASK) 
#define ADC_SINGLEDIFF_CHANNEL_SHIFT_MASK  (ADC_CALFACT_CALFACT_S_4 | ADC_CALFACT_CALFACT_S_3) 
#define ADC_SINGLEDIFF_CALIB_F_BIT_D_MASK   (0x00010000UL) 
#define ADC_SINGLEDIFF_CALIB_F_BIT_D_POS    (16UL)         
#define ADC_SINGLEDIFF_CALIB_F_BIT_D_SHIFT4 (ADC_SINGLEDIFF_CALIB_F_BIT_D_POS - 4UL) 
#define ADC_AWD_CR1_REGOFFSET              (0x00000000UL)
#define ADC_AWD_CR2_REGOFFSET              (0x00100000UL)
#define ADC_AWD_CR3_REGOFFSET              (0x00200000UL)
#define ADC_AWD_CR12_REGOFFSETGAP_MASK     (ADC_AWD2CR_AWD2CH_0)
#define ADC_AWD_CR12_REGOFFSETGAP_VAL      (0x00000024UL)
#define ADC_AWD_CRX_REGOFFSET_MASK         (ADC_AWD_CR1_REGOFFSET | ADC_AWD_CR2_REGOFFSET | ADC_AWD_CR3_REGOFFSET)
#define ADC_AWD_CR1_CHANNEL_MASK           (ADC_CFGR_AWD1CH | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)
#define ADC_AWD_CR23_CHANNEL_MASK          (ADC_AWD2CR_AWD2CH)
#define ADC_AWD_CR_ALL_CHANNEL_MASK        (ADC_AWD_CR1_CHANNEL_MASK | ADC_AWD_CR23_CHANNEL_MASK)
#define ADC_AWD_CRX_REGOFFSET_POS          (20UL)                      
#define ADC_AWD_TR1_REGOFFSET              (ADC_AWD_CR1_REGOFFSET)
#define ADC_AWD_TR2_REGOFFSET              (ADC_AWD_CR2_REGOFFSET)
#define ADC_AWD_TR3_REGOFFSET              (ADC_AWD_CR3_REGOFFSET)
#define ADC_AWD_TRX_REGOFFSET_MASK         (ADC_AWD_TR1_REGOFFSET | ADC_AWD_TR2_REGOFFSET | ADC_AWD_TR3_REGOFFSET)
#define ADC_AWD_TRX_REGOFFSET_POS          (ADC_AWD_CRX_REGOFFSET_POS)      
#define ADC_AWD_TRX_BIT_HIGH_MASK          (0x00010000UL)                   
#define ADC_AWD_TRX_BIT_HIGH_POS           (16UL)                           
#define ADC_AWD_TRX_BIT_HIGH_SHIFT4        (ADC_AWD_TRX_BIT_HIGH_POS - 4UL) 
#define ADC_OFR1_REGOFFSET                 (0x00000000UL)
#define ADC_OFR2_REGOFFSET                 (0x00000001UL)
#define ADC_OFR3_REGOFFSET                 (0x00000002UL)
#define ADC_OFR4_REGOFFSET                 (0x00000003UL)
#define ADC_OFRx_REGOFFSET_MASK            (ADC_OFR1_REGOFFSET | ADC_OFR2_REGOFFSET \
                                            | ADC_OFR3_REGOFFSET | ADC_OFR4_REGOFFSET)
#define ADC_CFGR_RES_BITOFFSET_POS         (ADC_CFGR_RES_Pos)
#define ADC_CFGR_AWD1SGL_BITOFFSET_POS     (ADC_CFGR_AWD1SGL_Pos)
#define ADC_CFGR_AWD1EN_BITOFFSET_POS      (ADC_CFGR_AWD1EN_Pos)
#define ADC_CFGR_JAWD1EN_BITOFFSET_POS     (ADC_CFGR_JAWD1EN_Pos)
#define ADC_TR1_HT1_BITOFFSET_POS          (ADC_TR1_HT1_Pos)
#define ADC_CR_BITS_PROPERTY_RS            (ADC_CR_ADCAL | ADC_CR_ADEN | ADC_CR_ADDIS \
                                            | ADC_CR_JADSTART | ADC_CR_JADSTP \
                                            | ADC_CR_ADSTART | ADC_CR_ADSTP)            
#define VREFINT_CAL_ADDR                   ((const uint16_t*) (0x08FFF810UL)) 
#define VREFINT_CAL_VREF                   (3300UL)                     
#define TEMPSENSOR_CAL1_ADDR               ((const uint16_t*) (0x08FFF814UL)) 
#define TEMPSENSOR_CAL2_ADDR               ((const uint16_t*) (0x08FFF818UL)) 
#define TEMPSENSOR_CAL1_TEMP               (30L)                        
#define TEMPSENSOR_CAL2_TEMP               (130L)                       
#define TEMPSENSOR_CAL_VREFANALOG          (3300UL)                     
#define __ADC_PTR_REG_OFFSET(__REG__, __REG_OFFFSET__)                         \
  ((__IO uint32_t *)((uint32_t) ((uint32_t)(&(__REG__)) + ((__REG_OFFFSET__) << 2UL))))
#if defined(USE_FULL_LL_DRIVER)
#if defined(ADC_MULTIMODE_SUPPORT)
#endif 
#endif 
#define LL_ADC_FLAG_ADRDY                  ADC_ISR_ADRDY      
#define LL_ADC_FLAG_EOC                    ADC_ISR_EOC        
#define LL_ADC_FLAG_EOS                    ADC_ISR_EOS        
#define LL_ADC_FLAG_OVR                    ADC_ISR_OVR        
#define LL_ADC_FLAG_EOSMP                  ADC_ISR_EOSMP      
#define LL_ADC_FLAG_JEOC                   ADC_ISR_JEOC       
#define LL_ADC_FLAG_JEOS                   ADC_ISR_JEOS       
#define LL_ADC_FLAG_JQOVF                  ADC_ISR_JQOVF      
#define LL_ADC_FLAG_AWD1                   ADC_ISR_AWD1       
#define LL_ADC_FLAG_AWD2                   ADC_ISR_AWD2       
#define LL_ADC_FLAG_AWD3                   ADC_ISR_AWD3       
#if defined(ADC_MULTIMODE_SUPPORT)
#define LL_ADC_FLAG_ADRDY_MST              ADC_CSR_ADRDY_MST  
#define LL_ADC_FLAG_ADRDY_SLV              ADC_CSR_ADRDY_SLV  
#define LL_ADC_FLAG_EOC_MST                ADC_CSR_EOC_MST    
#define LL_ADC_FLAG_EOC_SLV                ADC_CSR_EOC_SLV    
#define LL_ADC_FLAG_EOS_MST                ADC_CSR_EOS_MST    
#define LL_ADC_FLAG_EOS_SLV                ADC_CSR_EOS_SLV    
#define LL_ADC_FLAG_OVR_MST                ADC_CSR_OVR_MST    
#define LL_ADC_FLAG_OVR_SLV                ADC_CSR_OVR_SLV    
#define LL_ADC_FLAG_EOSMP_MST              ADC_CSR_EOSMP_MST  
#define LL_ADC_FLAG_EOSMP_SLV              ADC_CSR_EOSMP_SLV  
#define LL_ADC_FLAG_JEOC_MST               ADC_CSR_JEOC_MST   
#define LL_ADC_FLAG_JEOC_SLV               ADC_CSR_JEOC_SLV   
#define LL_ADC_FLAG_JEOS_MST               ADC_CSR_JEOS_MST   
#define LL_ADC_FLAG_JEOS_SLV               ADC_CSR_JEOS_SLV   
#define LL_ADC_FLAG_JQOVF_MST              ADC_CSR_JQOVF_MST  
#define LL_ADC_FLAG_JQOVF_SLV              ADC_CSR_JQOVF_SLV  
#define LL_ADC_FLAG_AWD1_MST               ADC_CSR_AWD1_MST   
#define LL_ADC_FLAG_AWD1_SLV               ADC_CSR_AWD1_SLV   
#define LL_ADC_FLAG_AWD2_MST               ADC_CSR_AWD2_MST   
#define LL_ADC_FLAG_AWD2_SLV               ADC_CSR_AWD2_SLV   
#define LL_ADC_FLAG_AWD3_MST               ADC_CSR_AWD3_MST   
#define LL_ADC_FLAG_AWD3_SLV               ADC_CSR_AWD3_SLV   
#endif 
#define LL_ADC_IT_ADRDY                    ADC_IER_ADRDYIE    
#define LL_ADC_IT_EOC                      ADC_IER_EOCIE      
#define LL_ADC_IT_EOS                      ADC_IER_EOSIE      
#define LL_ADC_IT_OVR                      ADC_IER_OVRIE      
#define LL_ADC_IT_EOSMP                    ADC_IER_EOSMPIE    
#define LL_ADC_IT_JEOC                     ADC_IER_JEOCIE     
#define LL_ADC_IT_JEOS                     ADC_IER_JEOSIE     
#define LL_ADC_IT_JQOVF                    ADC_IER_JQOVFIE    
#define LL_ADC_IT_AWD1                     ADC_IER_AWD1IE     
#define LL_ADC_IT_AWD2                     ADC_IER_AWD2IE     
#define LL_ADC_IT_AWD3                     ADC_IER_AWD3IE     
#define LL_ADC_DMA_REG_REGULAR_DATA        (0x00000000UL)      
#if defined(ADC_MULTIMODE_SUPPORT)
#define LL_ADC_DMA_REG_REGULAR_DATA_MULTI  (0x00000001UL)      
#endif 
#define LL_ADC_CLOCK_SYNC_PCLK_DIV1        (ADC_CCR_CKMODE_0)                    
#define LL_ADC_CLOCK_SYNC_PCLK_DIV2        (ADC_CCR_CKMODE_1)                    
#define LL_ADC_CLOCK_SYNC_PCLK_DIV4        (ADC_CCR_CKMODE_1 | ADC_CCR_CKMODE_0) 
#define LL_ADC_CLOCK_ASYNC_DIV1            (0x00000000UL)                      
#define LL_ADC_CLOCK_ASYNC_DIV2            (ADC_CCR_PRESC_0)                   
#define LL_ADC_CLOCK_ASYNC_DIV4            (ADC_CCR_PRESC_1)                   
#define LL_ADC_CLOCK_ASYNC_DIV6            (ADC_CCR_PRESC_1 | ADC_CCR_PRESC_0) 
#define LL_ADC_CLOCK_ASYNC_DIV8            (ADC_CCR_PRESC_2)                   
#define LL_ADC_CLOCK_ASYNC_DIV10           (ADC_CCR_PRESC_2 | ADC_CCR_PRESC_0) 
#define LL_ADC_CLOCK_ASYNC_DIV12           (ADC_CCR_PRESC_2 | ADC_CCR_PRESC_1) 
#define LL_ADC_CLOCK_ASYNC_DIV16           (ADC_CCR_PRESC_2 | ADC_CCR_PRESC_1 \
                                            | ADC_CCR_PRESC_0)                  
#define LL_ADC_CLOCK_ASYNC_DIV32           (ADC_CCR_PRESC_3)                   
#define LL_ADC_CLOCK_ASYNC_DIV64           (ADC_CCR_PRESC_3 | ADC_CCR_PRESC_0) 
#define LL_ADC_CLOCK_ASYNC_DIV128          (ADC_CCR_PRESC_3 | ADC_CCR_PRESC_1) 
#define LL_ADC_CLOCK_ASYNC_DIV256          (ADC_CCR_PRESC_3 | ADC_CCR_PRESC_1 \
                                            | ADC_CCR_PRESC_0)                  
#define LL_ADC_PATH_INTERNAL_NONE          (0x00000000UL)       
#define LL_ADC_PATH_INTERNAL_VREFINT       (ADC_CCR_VREFEN)     
#define LL_ADC_PATH_INTERNAL_TEMPSENSOR    (ADC_CCR_TSEN)       
#define LL_ADC_PATH_INTERNAL_VBAT          (ADC_CCR_VBATEN)     
#define LL_ADC_PATH_INTERNAL_VDDCORE       (ADC_OR_OP0)         
#define LL_ADC_RESOLUTION_12B              (0x00000000UL)                      
#define LL_ADC_RESOLUTION_10B              (                 ADC_CFGR_RES_0)   
#define LL_ADC_RESOLUTION_8B               (ADC_CFGR_RES_1                 )   
#define LL_ADC_RESOLUTION_6B               (ADC_CFGR_RES_1 | ADC_CFGR_RES_0)   
#define LL_ADC_DATA_ALIGN_RIGHT            (0x00000000UL)     
#define LL_ADC_DATA_ALIGN_LEFT             (ADC_CFGR_ALIGN)   
#define LL_ADC_LP_MODE_NONE                (0x00000000UL)     
#define LL_ADC_LP_AUTOWAIT                 (ADC_CFGR_AUTDLY)  
#define LL_ADC_OFFSET_1                    ADC_OFR1_REGOFFSET 
#define LL_ADC_OFFSET_2                    ADC_OFR2_REGOFFSET 
#define LL_ADC_OFFSET_3                    ADC_OFR3_REGOFFSET 
#define LL_ADC_OFFSET_4                    ADC_OFR4_REGOFFSET 
#define LL_ADC_OFFSET_DISABLE              (0x00000000UL)         
#define LL_ADC_OFFSET_ENABLE               (ADC_OFR1_OFFSET1_EN)  
#define LL_ADC_OFFSET_SIGN_NEGATIVE        (0x00000000UL)       
#define LL_ADC_OFFSET_SIGN_POSITIVE        (ADC_OFR1_OFFSETPOS) 
#define LL_ADC_OFFSET_SATURATION_DISABLE   (0x00000000UL)     
#define LL_ADC_OFFSET_SATURATION_ENABLE    (ADC_OFR1_SATEN)   
#define LL_ADC_GROUP_REGULAR               (0x00000001UL)     
#define LL_ADC_GROUP_INJECTED              (0x00000002UL)     
#define LL_ADC_GROUP_REGULAR_INJECTED      (0x00000003UL)     
#define LL_ADC_CHANNEL_0                   (ADC_CHANNEL_0_NUMBER  | ADC_CHANNEL_0_SMP \
                                            | ADC_CHANNEL_0_BITFIELD)                       
#define LL_ADC_CHANNEL_1                   (ADC_CHANNEL_1_NUMBER  | ADC_CHANNEL_1_SMP \
                                            | ADC_CHANNEL_1_BITFIELD)                       
#define LL_ADC_CHANNEL_2                   (ADC_CHANNEL_2_NUMBER  | ADC_CHANNEL_2_SMP \
                                            | ADC_CHANNEL_2_BITFIELD)                       
#define LL_ADC_CHANNEL_3                   (ADC_CHANNEL_3_NUMBER  | ADC_CHANNEL_3_SMP \
                                            | ADC_CHANNEL_3_BITFIELD)                       
#define LL_ADC_CHANNEL_4                   (ADC_CHANNEL_4_NUMBER  | ADC_CHANNEL_4_SMP \
                                            | ADC_CHANNEL_4_BITFIELD)                       
#define LL_ADC_CHANNEL_5                   (ADC_CHANNEL_5_NUMBER  | ADC_CHANNEL_5_SMP \
                                            | ADC_CHANNEL_5_BITFIELD)                       
#define LL_ADC_CHANNEL_6                   (ADC_CHANNEL_6_NUMBER  | ADC_CHANNEL_6_SMP \
                                            | ADC_CHANNEL_6_BITFIELD)                       
#define LL_ADC_CHANNEL_7                   (ADC_CHANNEL_7_NUMBER  | ADC_CHANNEL_7_SMP \
                                            | ADC_CHANNEL_7_BITFIELD)                       
#define LL_ADC_CHANNEL_8                   (ADC_CHANNEL_8_NUMBER  | ADC_CHANNEL_8_SMP \
                                            | ADC_CHANNEL_8_BITFIELD)                       
#define LL_ADC_CHANNEL_9                   (ADC_CHANNEL_9_NUMBER  | ADC_CHANNEL_9_SMP \
                                            | ADC_CHANNEL_9_BITFIELD)                       
#define LL_ADC_CHANNEL_10                  (ADC_CHANNEL_10_NUMBER | ADC_CHANNEL_10_SMP \
                                            | ADC_CHANNEL_10_BITFIELD)                      
#define LL_ADC_CHANNEL_11                  (ADC_CHANNEL_11_NUMBER | ADC_CHANNEL_11_SMP \
                                            | ADC_CHANNEL_11_BITFIELD)                      
#define LL_ADC_CHANNEL_12                  (ADC_CHANNEL_12_NUMBER | ADC_CHANNEL_12_SMP \
                                            | ADC_CHANNEL_12_BITFIELD)                      
#define LL_ADC_CHANNEL_13                  (ADC_CHANNEL_13_NUMBER | ADC_CHANNEL_13_SMP \
                                            | ADC_CHANNEL_13_BITFIELD)                      
#define LL_ADC_CHANNEL_14                  (ADC_CHANNEL_14_NUMBER | ADC_CHANNEL_14_SMP \
                                            | ADC_CHANNEL_14_BITFIELD)                      
#define LL_ADC_CHANNEL_15                  (ADC_CHANNEL_15_NUMBER | ADC_CHANNEL_15_SMP \
                                            | ADC_CHANNEL_15_BITFIELD)                      
#define LL_ADC_CHANNEL_16                  (ADC_CHANNEL_16_NUMBER | ADC_CHANNEL_16_SMP \
                                            | ADC_CHANNEL_16_BITFIELD) 
#define LL_ADC_CHANNEL_17                  (ADC_CHANNEL_17_NUMBER | ADC_CHANNEL_17_SMP \
                                            | ADC_CHANNEL_17_BITFIELD) 
#define LL_ADC_CHANNEL_18                  (ADC_CHANNEL_18_NUMBER | ADC_CHANNEL_18_SMP \
                                            | ADC_CHANNEL_18_BITFIELD) 
#define LL_ADC_CHANNEL_VREFINT             (LL_ADC_CHANNEL_17 | ADC_CHANNEL_ID_INTERNAL_CH)   
#define LL_ADC_CHANNEL_TEMPSENSOR          (LL_ADC_CHANNEL_16 | ADC_CHANNEL_ID_INTERNAL_CH)   
#define LL_ADC_CHANNEL_VBAT                (LL_ADC_CHANNEL_16 | ADC_CHANNEL_ID_INTERNAL_CH_2) 
#define LL_ADC_CHANNEL_VDDCORE             (LL_ADC_CHANNEL_17 | ADC_CHANNEL_ID_INTERNAL_CH_2) 
#define LL_ADC_REG_TRIG_SOFTWARE           (0x00000000UL)                                        
#define LL_ADC_REG_TRIG_EXT_TIM1_CH1       (ADC_REG_TRIG_EXT_EDGE_DEFAULT)                       
#define LL_ADC_REG_TRIG_EXT_TIM1_CH2       (ADC_CFGR_EXTSEL_0 | ADC_REG_TRIG_EXT_EDGE_DEFAULT)   
#define LL_ADC_REG_TRIG_EXT_TIM1_CH3       (ADC_CFGR_EXTSEL_1 | ADC_REG_TRIG_EXT_EDGE_DEFAULT)   
#define LL_ADC_REG_TRIG_EXT_TIM2_CH2       (ADC_CFGR_EXTSEL_1 | ADC_CFGR_EXTSEL_0 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_TIM3_TRGO      (ADC_CFGR_EXTSEL_2 | ADC_REG_TRIG_EXT_EDGE_DEFAULT)   
#define LL_ADC_REG_TRIG_EXT_TIM4_CH4       (ADC_CFGR_EXTSEL_2 | ADC_CFGR_EXTSEL_0 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_EXTI_LINE11    (ADC_CFGR_EXTSEL_2 | ADC_CFGR_EXTSEL_1 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_TIM12_TRGO     (ADC_CFGR_EXTSEL_2 | ADC_CFGR_EXTSEL_1 \
                                            | ADC_CFGR_EXTSEL_0 | ADC_REG_TRIG_EXT_EDGE_DEFAULT) 
#define LL_ADC_REG_TRIG_EXT_TIM9_TRGO      (ADC_CFGR_EXTSEL_3 | ADC_REG_TRIG_EXT_EDGE_DEFAULT)   
#define LL_ADC_REG_TRIG_EXT_TIM1_TRGO      (ADC_CFGR_EXTSEL_3 | ADC_CFGR_EXTSEL_0 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_TIM1_TRGO2     (ADC_CFGR_EXTSEL_3 | ADC_CFGR_EXTSEL_1 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_TIM2_TRGO      (ADC_CFGR_EXTSEL_3 | ADC_CFGR_EXTSEL_1 \
                                            | ADC_CFGR_EXTSEL_0 | ADC_REG_TRIG_EXT_EDGE_DEFAULT)  
#define LL_ADC_REG_TRIG_EXT_TIM4_TRGO      (ADC_CFGR_EXTSEL_3 | ADC_CFGR_EXTSEL_2 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_TIM6_TRGO      (ADC_CFGR_EXTSEL_3 | ADC_CFGR_EXTSEL_2 \
                                            | ADC_CFGR_EXTSEL_0 | ADC_REG_TRIG_EXT_EDGE_DEFAULT) 
#define LL_ADC_REG_TRIG_EXT_TIM15_TRGO     (ADC_CFGR_EXTSEL_3 | ADC_CFGR_EXTSEL_2 \
                                            | ADC_CFGR_EXTSEL_1 | ADC_REG_TRIG_EXT_EDGE_DEFAULT) 
#define LL_ADC_REG_TRIG_EXT_TIM3_CH4       (ADC_CFGR_EXTSEL_3 | ADC_CFGR_EXTSEL_2 \
                                            | ADC_CFGR_EXTSEL_1 | ADC_CFGR_EXTSEL_0 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_LPTIM1_CH1     (ADC_CFGR_EXTSEL_4 | ADC_CFGR_EXTSEL_1 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_LPTIM2_CH1     (ADC_CFGR_EXTSEL_4 | ADC_CFGR_EXTSEL_1 \
                                            | ADC_CFGR_EXTSEL_0 | ADC_REG_TRIG_EXT_EDGE_DEFAULT) 
#define LL_ADC_REG_TRIG_EXT_LPTIM3_CH1     (ADC_CFGR_EXTSEL_4 | ADC_CFGR_EXTSEL_2 \
                                            | ADC_REG_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_REG_TRIG_EXT_RISING         (ADC_CFGR_EXTEN_0)                      
#define LL_ADC_REG_TRIG_EXT_FALLING        (ADC_CFGR_EXTEN_1)                      
#define LL_ADC_REG_TRIG_EXT_RISINGFALLING  (ADC_CFGR_EXTEN_1 | ADC_CFGR_EXTEN_0)   
#define LL_ADC_REG_SAMPLING_MODE_NORMAL               (0x00000000UL)       
#define LL_ADC_REG_SAMPLING_MODE_BULB                 (ADC_CFGR2_BULB)     
#define LL_ADC_REG_SAMPLING_MODE_TRIGGER_CONTROLED    (ADC_CFGR2_SMPTRIG)  
#define LL_ADC_REG_CONV_SINGLE             (0x00000000UL)     
#define LL_ADC_REG_CONV_CONTINUOUS         (ADC_CFGR_CONT)    
#define LL_ADC_REG_DMA_TRANSFER_NONE       (0x00000000UL)     
#define LL_ADC_REG_DMA_TRANSFER_LIMITED    (ADC_CFGR_DMAEN)   
#define LL_ADC_REG_DMA_TRANSFER_UNLIMITED  (ADC_CFGR_DMACFG | ADC_CFGR_DMAEN)    
#define LL_ADC_REG_MDF_TRANSFER_NONE       (0x00000000UL)     
#define LL_ADC_REG_MDF_TRANSFER_ENABLE     (ADC_CFGR_ADFCFG)  
#if defined(ADC_SMPR1_SMPPLUS)
#define LL_ADC_SAMPLINGTIME_COMMON_DEFAULT      (0x00000000UL)      
#define LL_ADC_SAMPLINGTIME_COMMON_3C5_REPL_2C5 (ADC_SMPR1_SMPPLUS) 
#endif 
#define LL_ADC_REG_OVR_DATA_PRESERVED      (0x00000000UL)     
#define LL_ADC_REG_OVR_DATA_OVERWRITTEN    (ADC_CFGR_OVRMOD)  
#define LL_ADC_REG_SEQ_SCAN_DISABLE        (0x00000000UL)                 
#define LL_ADC_REG_SEQ_SCAN_ENABLE_2RANKS  (ADC_SQR1_L_0)                 
#define LL_ADC_REG_SEQ_SCAN_ENABLE_3RANKS  (ADC_SQR1_L_1)                 
#define LL_ADC_REG_SEQ_SCAN_ENABLE_4RANKS  (ADC_SQR1_L_1 | ADC_SQR1_L_0)  
#define LL_ADC_REG_SEQ_SCAN_ENABLE_5RANKS  (ADC_SQR1_L_2)                 
#define LL_ADC_REG_SEQ_SCAN_ENABLE_6RANKS  (ADC_SQR1_L_2 | ADC_SQR1_L_0)  
#define LL_ADC_REG_SEQ_SCAN_ENABLE_7RANKS  (ADC_SQR1_L_2 | ADC_SQR1_L_1) 
#define LL_ADC_REG_SEQ_SCAN_ENABLE_8RANKS  (ADC_SQR1_L_2 | ADC_SQR1_L_1 \
                                            | ADC_SQR1_L_0)                
#define LL_ADC_REG_SEQ_SCAN_ENABLE_9RANKS  (ADC_SQR1_L_3)                 
#define LL_ADC_REG_SEQ_SCAN_ENABLE_10RANKS (ADC_SQR1_L_3 | ADC_SQR1_L_0)  
#define LL_ADC_REG_SEQ_SCAN_ENABLE_11RANKS (ADC_SQR1_L_3 | ADC_SQR1_L_1)  
#define LL_ADC_REG_SEQ_SCAN_ENABLE_12RANKS (ADC_SQR1_L_3 | ADC_SQR1_L_1 \
                                            | ADC_SQR1_L_0)                
#define LL_ADC_REG_SEQ_SCAN_ENABLE_13RANKS (ADC_SQR1_L_3 | ADC_SQR1_L_2)  
#define LL_ADC_REG_SEQ_SCAN_ENABLE_14RANKS (ADC_SQR1_L_3 | ADC_SQR1_L_2 \
                                            | ADC_SQR1_L_0)                
#define LL_ADC_REG_SEQ_SCAN_ENABLE_15RANKS (ADC_SQR1_L_3 | ADC_SQR1_L_2 \
                                            | ADC_SQR1_L_1)                
#define LL_ADC_REG_SEQ_SCAN_ENABLE_16RANKS (ADC_SQR1_L_3 | ADC_SQR1_L_2 \
                                            | ADC_SQR1_L_1 | ADC_SQR1_L_0) 
#define LL_ADC_REG_SEQ_DISCONT_DISABLE     (0x00000000UL)                          
#define LL_ADC_REG_SEQ_DISCONT_1RANK       (ADC_CFGR_DISCEN)                       
#define LL_ADC_REG_SEQ_DISCONT_2RANKS      (ADC_CFGR_DISCNUM_0 | ADC_CFGR_DISCEN)  
#define LL_ADC_REG_SEQ_DISCONT_3RANKS      (ADC_CFGR_DISCNUM_1 | ADC_CFGR_DISCEN)  
#define LL_ADC_REG_SEQ_DISCONT_4RANKS      (ADC_CFGR_DISCNUM_1 | ADC_CFGR_DISCNUM_0 \
                                            | ADC_CFGR_DISCEN)                       
#define LL_ADC_REG_SEQ_DISCONT_5RANKS      (ADC_CFGR_DISCNUM_2 | ADC_CFGR_DISCEN)   
#define LL_ADC_REG_SEQ_DISCONT_6RANKS      (ADC_CFGR_DISCNUM_2 | ADC_CFGR_DISCNUM_0 \
                                            | ADC_CFGR_DISCEN)                       
#define LL_ADC_REG_SEQ_DISCONT_7RANKS      (ADC_CFGR_DISCNUM_2 | ADC_CFGR_DISCNUM_1 \
                                            | ADC_CFGR_DISCEN)                       
#define LL_ADC_REG_SEQ_DISCONT_8RANKS      (ADC_CFGR_DISCNUM_2 | ADC_CFGR_DISCNUM_1 \
                                            | ADC_CFGR_DISCNUM_0 | ADC_CFGR_DISCEN)  
#define LL_ADC_REG_RANK_1                  (ADC_SQR1_REGOFFSET | ADC_REG_RANK_1_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_2                  (ADC_SQR1_REGOFFSET | ADC_REG_RANK_2_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_3                  (ADC_SQR1_REGOFFSET | ADC_REG_RANK_3_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_4                  (ADC_SQR1_REGOFFSET | ADC_REG_RANK_4_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_5                  (ADC_SQR2_REGOFFSET | ADC_REG_RANK_5_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_6                  (ADC_SQR2_REGOFFSET | ADC_REG_RANK_6_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_7                  (ADC_SQR2_REGOFFSET | ADC_REG_RANK_7_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_8                  (ADC_SQR2_REGOFFSET | ADC_REG_RANK_8_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_9                  (ADC_SQR2_REGOFFSET | ADC_REG_RANK_9_SQRX_BITOFFSET_POS)  
#define LL_ADC_REG_RANK_10                 (ADC_SQR3_REGOFFSET | ADC_REG_RANK_10_SQRX_BITOFFSET_POS) 
#define LL_ADC_REG_RANK_11                 (ADC_SQR3_REGOFFSET | ADC_REG_RANK_11_SQRX_BITOFFSET_POS) 
#define LL_ADC_REG_RANK_12                 (ADC_SQR3_REGOFFSET | ADC_REG_RANK_12_SQRX_BITOFFSET_POS) 
#define LL_ADC_REG_RANK_13                 (ADC_SQR3_REGOFFSET | ADC_REG_RANK_13_SQRX_BITOFFSET_POS) 
#define LL_ADC_REG_RANK_14                 (ADC_SQR3_REGOFFSET | ADC_REG_RANK_14_SQRX_BITOFFSET_POS) 
#define LL_ADC_REG_RANK_15                 (ADC_SQR4_REGOFFSET | ADC_REG_RANK_15_SQRX_BITOFFSET_POS) 
#define LL_ADC_REG_RANK_16                 (ADC_SQR4_REGOFFSET | ADC_REG_RANK_16_SQRX_BITOFFSET_POS) 
#define LL_ADC_INJ_TRIG_SOFTWARE           (0x00000000UL)                                        
#define LL_ADC_INJ_TRIG_EXT_TIM1_TRGO      (ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                       
#define LL_ADC_INJ_TRIG_EXT_TIM1_CH4       (ADC_JSQR_JEXTSEL_0 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)  
#define LL_ADC_INJ_TRIG_EXT_TIM2_TRGO      (ADC_JSQR_JEXTSEL_1 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)  
#define LL_ADC_INJ_TRIG_EXT_TIM2_CH1       (ADC_JSQR_JEXTSEL_1 | ADC_JSQR_JEXTSEL_0 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_TIM3_CH4       (ADC_JSQR_JEXTSEL_2 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT) 
#define LL_ADC_INJ_TRIG_EXT_TIM4_TRGO      (ADC_JSQR_JEXTSEL_2 | ADC_JSQR_JEXTSEL_0 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_EXTI_LINE15    (ADC_JSQR_JEXTSEL_2 | ADC_JSQR_JEXTSEL_1 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_TIM9_CH1       (ADC_JSQR_JEXTSEL_2 | ADC_JSQR_JEXTSEL_1 \
                                            | ADC_JSQR_JEXTSEL_0 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
#define LL_ADC_INJ_TRIG_EXT_TIM1_TRGO2     (ADC_JSQR_JEXTSEL_3 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)  
#define LL_ADC_INJ_TRIG_EXT_TIM12_TRGO     (ADC_JSQR_JEXTSEL_3 | ADC_JSQR_JEXTSEL_0 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_TIM9_TRGO      (ADC_JSQR_JEXTSEL_3 | ADC_JSQR_JEXTSEL_1 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_TIM3_CH3       (ADC_JSQR_JEXTSEL_3 | ADC_JSQR_JEXTSEL_1 \
                                            | ADC_JSQR_JEXTSEL_0 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
#define LL_ADC_INJ_TRIG_EXT_TIM3_TRGO      (ADC_JSQR_JEXTSEL_3 | ADC_JSQR_JEXTSEL_2 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_TIM3_CH1       (ADC_JSQR_JEXTSEL_3 | ADC_JSQR_JEXTSEL_2 \
                                            | ADC_JSQR_JEXTSEL_0 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
#define LL_ADC_INJ_TRIG_EXT_TIM6_TRGO      (ADC_JSQR_JEXTSEL_3 | ADC_JSQR_JEXTSEL_2 \
                                            | ADC_JSQR_JEXTSEL_1 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
#define LL_ADC_INJ_TRIG_EXT_TIM15_TRGO     (ADC_JSQR_JEXTSEL_3 | ADC_JSQR_JEXTSEL_2 \
                                            | ADC_JSQR_JEXTSEL_1 | ADC_JSQR_JEXTSEL_0 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_LPTIM1_CH2     (ADC_JSQR_JEXTSEL_4 | ADC_JSQR_JEXTSEL_1 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_LPTIM2_CH2     (ADC_JSQR_JEXTSEL_4 | ADC_JSQR_JEXTSEL_1 \
                                            | ADC_JSQR_JEXTSEL_0 | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
#define LL_ADC_INJ_TRIG_EXT_LPTIM3_CH1     (ADC_JSQR_JEXTSEL_4 | ADC_JSQR_JEXTSEL_2 \
                                            | ADC_INJ_TRIG_EXT_EDGE_DEFAULT)                     
#define LL_ADC_INJ_TRIG_EXT_RISING         (                    ADC_JSQR_JEXTEN_0) 
#define LL_ADC_INJ_TRIG_EXT_FALLING        (ADC_JSQR_JEXTEN_1                    ) 
#define LL_ADC_INJ_TRIG_EXT_RISINGFALLING  (ADC_JSQR_JEXTEN_1 | ADC_JSQR_JEXTEN_0) 
#define LL_ADC_INJ_TRIG_INDEPENDENT        (0x00000000UL)     
#define LL_ADC_INJ_TRIG_FROM_GRP_REGULAR   (ADC_CFGR_JAUTO)   
#define LL_ADC_INJ_QUEUE_2CONTEXTS_LAST_ACTIVE (0x00000000UL)   
#define LL_ADC_INJ_QUEUE_2CONTEXTS_END_EMPTY   (ADC_CFGR_JQM)   
#define LL_ADC_INJ_QUEUE_DISABLE               (ADC_CFGR_JQDIS) 
#define LL_ADC_INJ_SEQ_SCAN_DISABLE        (0x00000000UL)                  
#define LL_ADC_INJ_SEQ_SCAN_ENABLE_2RANKS  (                ADC_JSQR_JL_0) 
#define LL_ADC_INJ_SEQ_SCAN_ENABLE_3RANKS  (ADC_JSQR_JL_1                ) 
#define LL_ADC_INJ_SEQ_SCAN_ENABLE_4RANKS  (ADC_JSQR_JL_1 | ADC_JSQR_JL_0) 
#define LL_ADC_INJ_SEQ_DISCONT_DISABLE     (0x00000000UL)     
#define LL_ADC_INJ_SEQ_DISCONT_1RANK       (ADC_CFGR_JDISCEN) 
#define LL_ADC_INJ_RANK_1                  (ADC_JDR1_REGOFFSET \
                                            | ADC_INJ_RANK_1_JSQR_BITOFFSET_POS) 
#define LL_ADC_INJ_RANK_2                  (ADC_JDR2_REGOFFSET \
                                            | ADC_INJ_RANK_2_JSQR_BITOFFSET_POS) 
#define LL_ADC_INJ_RANK_3                  (ADC_JDR3_REGOFFSET \
                                            | ADC_INJ_RANK_3_JSQR_BITOFFSET_POS) 
#define LL_ADC_INJ_RANK_4                  (ADC_JDR4_REGOFFSET \
                                            | ADC_INJ_RANK_4_JSQR_BITOFFSET_POS) 
#define LL_ADC_SAMPLINGTIME_2CYCLES_5      (0x00000000UL)       
#define LL_ADC_SAMPLINGTIME_6CYCLES_5      (ADC_SMPR2_SMP10_0)  
#define LL_ADC_SAMPLINGTIME_12CYCLES_5     (ADC_SMPR2_SMP10_1)  
#define LL_ADC_SAMPLINGTIME_24CYCLES_5     (ADC_SMPR2_SMP10_1 \
                                            | ADC_SMPR2_SMP10_0) 
#define LL_ADC_SAMPLINGTIME_47CYCLES_5     (ADC_SMPR2_SMP10_2)  
#define LL_ADC_SAMPLINGTIME_92CYCLES_5     (ADC_SMPR2_SMP10_2 \
                                            | ADC_SMPR2_SMP10_0) 
#define LL_ADC_SAMPLINGTIME_247CYCLES_5    (ADC_SMPR2_SMP10_2 \
                                            | ADC_SMPR2_SMP10_1) 
#define LL_ADC_SAMPLINGTIME_640CYCLES_5    (ADC_SMPR2_SMP10_2 \
                                            | ADC_SMPR2_SMP10_1 \
                                            | ADC_SMPR2_SMP10_0) 
#define LL_ADC_SINGLE_ENDED                (                  ADC_CALFACT_CALFACT_S)         
#define LL_ADC_DIFFERENTIAL_ENDED          (ADC_CR_ADCALDIF | ADC_CALFACT_CALFACT_D)         
#define LL_ADC_BOTH_SINGLE_DIFF_ENDED      (LL_ADC_SINGLE_ENDED | LL_ADC_DIFFERENTIAL_ENDED) 
#define LL_ADC_AWD1                        (ADC_AWD_CR1_CHANNEL_MASK \
                                            | ADC_AWD_CR1_REGOFFSET) 
#define LL_ADC_AWD2                        (ADC_AWD_CR23_CHANNEL_MASK \
                                            | ADC_AWD_CR2_REGOFFSET) 
#define LL_ADC_AWD3                        (ADC_AWD_CR23_CHANNEL_MASK \
                                            | ADC_AWD_CR3_REGOFFSET) 
#define LL_ADC_AWD_DISABLE                 (0x00000000UL)                           
#define LL_ADC_AWD_ALL_CHANNELS_REG        (ADC_AWD_CR23_CHANNEL_MASK \
                                            | ADC_CFGR_AWD1EN)                       
#define LL_ADC_AWD_ALL_CHANNELS_INJ        (ADC_AWD_CR23_CHANNEL_MASK \
                                            | ADC_CFGR_JAWD1EN)                      
#define LL_ADC_AWD_ALL_CHANNELS_REG_INJ    (ADC_AWD_CR23_CHANNEL_MASK \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN)    
#define LL_ADC_AWD_CHANNEL_0_REG           ((LL_ADC_CHANNEL_0  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_0_INJ           ((LL_ADC_CHANNEL_0  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_0_REG_INJ       ((LL_ADC_CHANNEL_0  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_1_REG           ((LL_ADC_CHANNEL_1  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_1_INJ           ((LL_ADC_CHANNEL_1  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_1_REG_INJ       ((LL_ADC_CHANNEL_1  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_2_REG           ((LL_ADC_CHANNEL_2  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_2_INJ           ((LL_ADC_CHANNEL_2  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_2_REG_INJ       ((LL_ADC_CHANNEL_2  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_3_REG           ((LL_ADC_CHANNEL_3  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_3_INJ           ((LL_ADC_CHANNEL_3  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_3_REG_INJ       ((LL_ADC_CHANNEL_3  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_4_REG           ((LL_ADC_CHANNEL_4  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_4_INJ           ((LL_ADC_CHANNEL_4  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_4_REG_INJ       ((LL_ADC_CHANNEL_4  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_5_REG           ((LL_ADC_CHANNEL_5  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_5_INJ           ((LL_ADC_CHANNEL_5  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_5_REG_INJ       ((LL_ADC_CHANNEL_5  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_6_REG           ((LL_ADC_CHANNEL_6  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_6_INJ           ((LL_ADC_CHANNEL_6  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_6_REG_INJ       ((LL_ADC_CHANNEL_6  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_7_REG           ((LL_ADC_CHANNEL_7  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_7_INJ           ((LL_ADC_CHANNEL_7  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_7_REG_INJ       ((LL_ADC_CHANNEL_7  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_8_REG           ((LL_ADC_CHANNEL_8  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_8_INJ           ((LL_ADC_CHANNEL_8  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_8_REG_INJ       ((LL_ADC_CHANNEL_8  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_9_REG           ((LL_ADC_CHANNEL_9  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_9_INJ           ((LL_ADC_CHANNEL_9  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_9_REG_INJ       ((LL_ADC_CHANNEL_9  & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_10_REG          ((LL_ADC_CHANNEL_10 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_10_INJ          ((LL_ADC_CHANNEL_10 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_10_REG_INJ      ((LL_ADC_CHANNEL_10 & ADC_CHANNEL_ID_MASK)\
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_11_REG          ((LL_ADC_CHANNEL_11 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_11_INJ          ((LL_ADC_CHANNEL_11 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_11_REG_INJ      ((LL_ADC_CHANNEL_11 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_12_REG          ((LL_ADC_CHANNEL_12 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_12_INJ          ((LL_ADC_CHANNEL_12 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_12_REG_INJ      ((LL_ADC_CHANNEL_12 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_13_REG          ((LL_ADC_CHANNEL_13 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_13_INJ          ((LL_ADC_CHANNEL_13 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_13_REG_INJ      ((LL_ADC_CHANNEL_13 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_14_REG          ((LL_ADC_CHANNEL_14 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_14_INJ          ((LL_ADC_CHANNEL_14 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_14_REG_INJ      ((LL_ADC_CHANNEL_14 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_15_REG          ((LL_ADC_CHANNEL_15 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_15_INJ          ((LL_ADC_CHANNEL_15 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_15_REG_INJ      ((LL_ADC_CHANNEL_15 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_16_REG          ((LL_ADC_CHANNEL_16 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_16_INJ          ((LL_ADC_CHANNEL_16 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_16_REG_INJ      ((LL_ADC_CHANNEL_16 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_17_REG          ((LL_ADC_CHANNEL_17 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_17_INJ          ((LL_ADC_CHANNEL_17 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_17_REG_INJ      ((LL_ADC_CHANNEL_17 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CHANNEL_18_REG          ((LL_ADC_CHANNEL_18 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CHANNEL_18_INJ          ((LL_ADC_CHANNEL_18 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CHANNEL_18_REG_INJ      ((LL_ADC_CHANNEL_18 & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CH_VREFINT_REG          ((LL_ADC_CHANNEL_VREFINT    & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CH_VREFINT_INJ          ((LL_ADC_CHANNEL_VREFINT    & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CH_VREFINT_REG_INJ      ((LL_ADC_CHANNEL_VREFINT    & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CH_TEMPSENSOR_REG       ((LL_ADC_CHANNEL_TEMPSENSOR & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CH_TEMPSENSOR_INJ       ((LL_ADC_CHANNEL_TEMPSENSOR & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CH_TEMPSENSOR_REG_INJ   ((LL_ADC_CHANNEL_TEMPSENSOR & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CH_VBAT_REG             ((LL_ADC_CHANNEL_VBAT       & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CH_VBAT_INJ             ((LL_ADC_CHANNEL_VBAT       & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CH_VBAT_REG_INJ         ((LL_ADC_CHANNEL_VBAT       & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_CH_VDDCORE_REG          ((LL_ADC_CHANNEL_VDDCORE    & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)    
#define LL_ADC_AWD_CH_VDDCORE_INJ          ((LL_ADC_CHANNEL_VDDCORE    & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)   
#define LL_ADC_AWD_CH_VDDCORE_REG_INJ      ((LL_ADC_CHANNEL_VDDCORE    & ADC_CHANNEL_ID_MASK) \
                                            | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN \
                                            | ADC_CFGR_AWD1SGL)                      
#define LL_ADC_AWD_THRESHOLD_HIGH          (ADC_TR1_HT1)      
#define LL_ADC_AWD_THRESHOLD_LOW           (ADC_TR1_LT1)      
#define LL_ADC_AWD_THRESHOLDS_HIGH_LOW     (ADC_TR1_HT1 \
                                            | ADC_TR1_LT1)     
#define LL_ADC_AWD_FILTERING_NONE          (0x00000000UL)                          
#define LL_ADC_AWD_FILTERING_2SAMPLES      (ADC_TR1_AWDFILT_0)                     
#define LL_ADC_AWD_FILTERING_3SAMPLES      (ADC_TR1_AWDFILT_1)                     
#define LL_ADC_AWD_FILTERING_4SAMPLES      (ADC_TR1_AWDFILT_1 | ADC_TR1_AWDFILT_0) 
#define LL_ADC_AWD_FILTERING_5SAMPLES      (ADC_TR1_AWDFILT_2)                     
#define LL_ADC_AWD_FILTERING_6SAMPLES      (ADC_TR1_AWDFILT_2 | ADC_TR1_AWDFILT_0) 
#define LL_ADC_AWD_FILTERING_7SAMPLES      (ADC_TR1_AWDFILT_2 | ADC_TR1_AWDFILT_1) 
#define LL_ADC_AWD_FILTERING_8SAMPLES      (ADC_TR1_AWDFILT_2 | ADC_TR1_AWDFILT_1 \
                                            | ADC_TR1_AWDFILT_0)                    
#define LL_ADC_OVS_DISABLE                 (0x00000000UL)                      
#define LL_ADC_OVS_GRP_REGULAR_CONTINUED   (ADC_CFGR2_ROVSE)                   
#define LL_ADC_OVS_GRP_REGULAR_RESUMED     (ADC_CFGR2_ROVSM | ADC_CFGR2_ROVSE) 
#define LL_ADC_OVS_GRP_INJECTED            (ADC_CFGR2_JOVSE)                   
#define LL_ADC_OVS_GRP_INJ_REG_RESUMED     (ADC_CFGR2_JOVSE | ADC_CFGR2_ROVSE) 
#define LL_ADC_OVS_REG_CONT                (0x00000000UL)     
#define LL_ADC_OVS_REG_DISCONT             (ADC_CFGR2_TROVS)  
#define LL_ADC_OVS_RATIO_2                 (0x00000000UL)                        
#define LL_ADC_OVS_RATIO_4                 (ADC_CFGR2_OVSR_0)                    
#define LL_ADC_OVS_RATIO_8                 (ADC_CFGR2_OVSR_1)                    
#define LL_ADC_OVS_RATIO_16                (ADC_CFGR2_OVSR_1 | ADC_CFGR2_OVSR_0) 
#define LL_ADC_OVS_RATIO_32                (ADC_CFGR2_OVSR_2)                    
#define LL_ADC_OVS_RATIO_64                (ADC_CFGR2_OVSR_2 | ADC_CFGR2_OVSR_0) 
#define LL_ADC_OVS_RATIO_128               (ADC_CFGR2_OVSR_2 | ADC_CFGR2_OVSR_1) 
#define LL_ADC_OVS_RATIO_256               (ADC_CFGR2_OVSR_2 | ADC_CFGR2_OVSR_1 \
                                            | ADC_CFGR2_OVSR_0)                   
#define LL_ADC_OVS_SHIFT_NONE              (0x00000000UL)                        
#define LL_ADC_OVS_SHIFT_RIGHT_1           (ADC_CFGR2_OVSS_0)                    
#define LL_ADC_OVS_SHIFT_RIGHT_2           (ADC_CFGR2_OVSS_1)                    
#define LL_ADC_OVS_SHIFT_RIGHT_3           (ADC_CFGR2_OVSS_1 | ADC_CFGR2_OVSS_0) 
#define LL_ADC_OVS_SHIFT_RIGHT_4           (ADC_CFGR2_OVSS_2)                    
#define LL_ADC_OVS_SHIFT_RIGHT_5           (ADC_CFGR2_OVSS_2 | ADC_CFGR2_OVSS_0) 
#define LL_ADC_OVS_SHIFT_RIGHT_6           (ADC_CFGR2_OVSS_2 | ADC_CFGR2_OVSS_1) 
#define LL_ADC_OVS_SHIFT_RIGHT_7           (ADC_CFGR2_OVSS_2 | ADC_CFGR2_OVSS_1 \
                                            | ADC_CFGR2_OVSS_0)                   
#define LL_ADC_OVS_SHIFT_RIGHT_8           (ADC_CFGR2_OVSS_3)                    
#if defined(ADC_MULTIMODE_SUPPORT)
#define LL_ADC_MULTI_INDEPENDENT           (0x00000000UL)                    
#define LL_ADC_MULTI_DUAL_REG_SIMULT       (ADC_CCR_DUAL_2 | ADC_CCR_DUAL_1) 
#define LL_ADC_MULTI_DUAL_REG_INTERL       (ADC_CCR_DUAL_2 | ADC_CCR_DUAL_1 \
                                            | ADC_CCR_DUAL_0)                  
#define LL_ADC_MULTI_DUAL_INJ_SIMULT       (ADC_CCR_DUAL_2 | ADC_CCR_DUAL_0) 
#define LL_ADC_MULTI_DUAL_INJ_ALTERN       (ADC_CCR_DUAL_3 | ADC_CCR_DUAL_0) 
#define LL_ADC_MULTI_DUAL_REG_SIM_INJ_SIM  (ADC_CCR_DUAL_0)                  
#define LL_ADC_MULTI_DUAL_REG_SIM_INJ_ALT  (ADC_CCR_DUAL_1)                  
#define LL_ADC_MULTI_DUAL_REG_INT_INJ_SIM  (ADC_CCR_DUAL_1 | ADC_CCR_DUAL_0) 
#define LL_ADC_MULTI_REG_DMA_EACH_ADC        (0x00000000UL)                    
#define LL_ADC_MULTI_REG_DMA_LIMIT_RES12_10B (ADC_CCR_MDMA_1)                  
#define LL_ADC_MULTI_REG_DMA_LIMIT_RES8_6B   (ADC_CCR_MDMA_1 | ADC_CCR_MDMA_0) 
#define LL_ADC_MULTI_REG_DMA_UNLMT_RES12_10B (ADC_CCR_DMACFG | ADC_CCR_MDMA_1) 
#define LL_ADC_MULTI_REG_DMA_UNLMT_RES8_6B   (ADC_CCR_DMACFG | ADC_CCR_MDMA_1 \
                                              | ADC_CCR_MDMA_0)                 
#define LL_ADC_MULTI_TWOSMP_DELAY_1CYCLE   (0x00000000UL)                      
#define LL_ADC_MULTI_TWOSMP_DELAY_2CYCLES  (ADC_CCR_DELAY_0)                   
#define LL_ADC_MULTI_TWOSMP_DELAY_3CYCLES  (ADC_CCR_DELAY_1)                   
#define LL_ADC_MULTI_TWOSMP_DELAY_4CYCLES  (ADC_CCR_DELAY_1 | ADC_CCR_DELAY_0) 
#define LL_ADC_MULTI_TWOSMP_DELAY_5CYCLES  (ADC_CCR_DELAY_2)                   
#define LL_ADC_MULTI_TWOSMP_DELAY_6CYCLES  (ADC_CCR_DELAY_2 | ADC_CCR_DELAY_0) 
#define LL_ADC_MULTI_TWOSMP_DELAY_7CYCLES  (ADC_CCR_DELAY_2 | ADC_CCR_DELAY_1) 
#define LL_ADC_MULTI_TWOSMP_DELAY_8CYCLES  (ADC_CCR_DELAY_2 | ADC_CCR_DELAY_1 \
                                            | ADC_CCR_DELAY_0)                  
#define LL_ADC_MULTI_TWOSMP_DELAY_9CYCLES  (ADC_CCR_DELAY_3)                   
#define LL_ADC_MULTI_TWOSMP_DELAY_10CYCLES (ADC_CCR_DELAY_3 | ADC_CCR_DELAY_0) 
#define LL_ADC_MULTI_TWOSMP_DELAY_11CYCLES (ADC_CCR_DELAY_3 | ADC_CCR_DELAY_1) 
#define LL_ADC_MULTI_TWOSMP_DELAY_12CYCLES (ADC_CCR_DELAY_3 | ADC_CCR_DELAY_1 \
                                            | ADC_CCR_DELAY_0)                  
#define LL_ADC_MULTI_MASTER                (ADC_CDR_RDATA_MST) 
#define LL_ADC_MULTI_SLAVE                 (ADC_CDR_RDATA_SLV) 
#define LL_ADC_MULTI_MASTER_SLAVE          (ADC_CDR_RDATA_SLV \
                                            | ADC_CDR_RDATA_MST) 
#endif 
#define LL_ADC_TEMPERATURE_CALC_ERROR      ((int16_t)0x7FFF)  
#define LL_ADC_DELAY_INTERNAL_REGUL_STAB_US ( 20UL)           
#define LL_ADC_DELAY_VREFINT_STAB_US           ( 12UL)        
#define LL_ADC_DELAY_TEMPSENSOR_STAB_US        (120UL)        
#define LL_ADC_DELAY_TEMPSENSOR_BUFFER_STAB_US ( 15UL)        
#define LL_ADC_DELAY_CALIB_ENABLE_ADC_CYCLES   (  4UL)        
#define LL_ADC_WriteReg(__INSTANCE__, __REG__, __VALUE__) WRITE_REG(__INSTANCE__->__REG__, (__VALUE__))
#define LL_ADC_ReadReg(__INSTANCE__, __REG__) READ_REG(__INSTANCE__->__REG__)
#define __LL_ADC_CHANNEL_TO_DECIMAL_NB(__CHANNEL__)                                        \
  ((((__CHANNEL__) & ADC_CHANNEL_ID_BITFIELD_MASK) == 0UL) ?                               \
   (                                                                                       \
       ((__CHANNEL__) & ADC_CHANNEL_ID_NUMBER_MASK) >> ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS \
   )                                                                                       \
   :                                                                                       \
   (                                                                                       \
       (uint32_t)POSITION_VAL((__CHANNEL__))                                               \
   )                                                                                       \
  )
#define __LL_ADC_DECIMAL_NB_TO_CHANNEL(__DECIMAL_NB__)                                                  \
  (((__DECIMAL_NB__) <= 9UL) ?                                                                          \
   (                                                                                                    \
       ((__DECIMAL_NB__) << ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)                             |          \
       (ADC_AWD2CR_AWD2CH_0 << (__DECIMAL_NB__))                                              |          \
       (ADC_SMPR1_REGOFFSET | (((3UL * (__DECIMAL_NB__))) << ADC_CHANNEL_SMPx_BITOFFSET_POS))           \
   )                                                                                                    \
   :                                                                                                    \
   (                                                                                                    \
       ((__DECIMAL_NB__) << ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)                                      | \
       (ADC_AWD2CR_AWD2CH_0 << (__DECIMAL_NB__))                                                       | \
       (ADC_SMPR2_REGOFFSET | (((3UL * ((__DECIMAL_NB__) - 10UL))) << ADC_CHANNEL_SMPx_BITOFFSET_POS))  \
   )                                                                                                    \
  )
#define __LL_ADC_IS_CHANNEL_INTERNAL(__CHANNEL__)                              \
  (((__CHANNEL__) & ADC_CHANNEL_ID_INTERNAL_CH_MASK) != 0UL)
#define __LL_ADC_CHANNEL_INTERNAL_TO_EXTERNAL(__CHANNEL__)                     \
  ((__CHANNEL__) & ~ADC_CHANNEL_ID_INTERNAL_CH_MASK)
#define __LL_ADC_IS_CHANNEL_INTERNAL_AVAILABLE(__ADC_INSTANCE__, __CHANNEL__)  \
  ((((__ADC_INSTANCE__) == ADC1)                                               \
    &&(((__CHANNEL__) == LL_ADC_CHANNEL_TEMPSENSOR)   ||                       \
       ((__CHANNEL__) == LL_ADC_CHANNEL_VREFINT))                              \
   )                                                                           \
   ||                                                                          \
   (((__ADC_INSTANCE__) == ADC2)                                               \
    &&(((__CHANNEL__) == LL_ADC_CHANNEL_VBAT)         ||                       \
       ((__CHANNEL__) == LL_ADC_CHANNEL_VDDCORE))                              \
   )                                                                           \
  )
#define __LL_ADC_ANALOGWD_CHANNEL_GROUP(__CHANNEL__, __GROUP__)                                           \
  (((__GROUP__) == LL_ADC_GROUP_REGULAR)                                                                  \
   ? (((__CHANNEL__) & ADC_CHANNEL_ID_MASK) | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)                         \
   :                                                                                                      \
   ((__GROUP__) == LL_ADC_GROUP_INJECTED)                                                                 \
   ? (((__CHANNEL__) & ADC_CHANNEL_ID_MASK) | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1SGL)                        \
   :                                                                                                      \
   (((__CHANNEL__) & ADC_CHANNEL_ID_MASK) | ADC_CFGR_JAWD1EN | ADC_CFGR_AWD1EN | ADC_CFGR_AWD1SGL)        \
  )
#define __LL_ADC_ANALOGWD_SET_THRESHOLD_RESOLUTION(__ADC_RESOLUTION__, __AWD_THRESHOLD__) \
  ((__AWD_THRESHOLD__) << ((__ADC_RESOLUTION__) >> (ADC_CFGR_RES_BITOFFSET_POS - 1U )))
#define __LL_ADC_ANALOGWD_GET_THRESHOLD_RESOLUTION(__ADC_RESOLUTION__, __AWD_THRESHOLD_12_BITS__) \
  ((__AWD_THRESHOLD_12_BITS__) >> ((__ADC_RESOLUTION__) >> (ADC_CFGR_RES_BITOFFSET_POS - 1U )))
#define __LL_ADC_ANALOGWD_THRESHOLDS_HIGH_LOW(__AWD_THRESHOLD_TYPE__, __AWD_THRESHOLDS__)                            \
  (((__AWD_THRESHOLDS__) >> (((__AWD_THRESHOLD_TYPE__) & ADC_AWD_TRX_BIT_HIGH_MASK) >> ADC_AWD_TRX_BIT_HIGH_SHIFT4)) \
   & LL_ADC_AWD_THRESHOLD_LOW)
#define __LL_ADC_CALIB_FACTOR_SINGLE_DIFF(__CALIB_FACTOR_SINGLE_ENDED__, __CALIB_FACTOR_DIFFERENTIAL__)        \
  (((__CALIB_FACTOR_DIFFERENTIAL__) << ADC_CALFACT_CALFACT_D_Pos) | (__CALIB_FACTOR_SINGLE_ENDED__))
#if defined(ADC_MULTIMODE_SUPPORT)
#define __LL_ADC_MULTI_CONV_DATA_MASTER_SLAVE(__ADC_MULTI_MASTER_SLAVE__, __ADC_MULTI_CONV_DATA__) \
  (((__ADC_MULTI_CONV_DATA__) >> ((ADC_CDR_RDATA_SLV_Pos) & ~(__ADC_MULTI_MASTER_SLAVE__))) & ADC_CDR_RDATA_MST)
#endif 
#if defined(ADC_MULTIMODE_SUPPORT)
#define __LL_ADC_MULTI_INSTANCE_MASTER(__ADCx__) \
  ( ( ((__ADCx__) == ADC2)                                                     \
    )?                                                                         \
    (ADC1)                                                                     \
    :                                                                          \
    (__ADCx__)                                                                 \
  )
#endif 
#define __LL_ADC_COMMON_INSTANCE(__ADCx__)  (ADC12_COMMON)
#if defined(ADC2)
#define __LL_ADC_IS_ENABLED_ALL_COMMON_INSTANCE(__ADCXY_COMMON__)              \
  (LL_ADC_IsEnabled(ADC1) | LL_ADC_IsEnabled(ADC2))
#else
#define __LL_ADC_IS_ENABLED_ALL_COMMON_INSTANCE(__ADCXY_COMMON__)  (LL_ADC_IsEnabled(ADC1))
#endif 
#define __LL_ADC_DIGITAL_SCALE(__ADC_RESOLUTION__)                             \
  (0xFFFUL >> ((__ADC_RESOLUTION__) >> (ADC_CFGR_RES_BITOFFSET_POS - 1UL)))
#define __LL_ADC_CONVERT_DATA_RESOLUTION(__DATA__,\
                                         __ADC_RESOLUTION_CURRENT__,\
                                         __ADC_RESOLUTION_TARGET__)          \
(((__DATA__)                                                                 \
  << ((__ADC_RESOLUTION_CURRENT__) >> (ADC_CFGR_RES_BITOFFSET_POS - 1UL)))   \
 >> ((__ADC_RESOLUTION_TARGET__) >> (ADC_CFGR_RES_BITOFFSET_POS - 1UL))      \
)
#define __LL_ADC_CALC_DATA_TO_VOLTAGE(__VREFANALOG_VOLTAGE__,\
                                      __ADC_DATA__,\
                                      __ADC_RESOLUTION__)                    \
((__ADC_DATA__) * (__VREFANALOG_VOLTAGE__)                                   \
 / __LL_ADC_DIGITAL_SCALE(__ADC_RESOLUTION__)                                \
)
#define __LL_ADC_CALC_DIFF_DATA_TO_VOLTAGE(__VREFANALOG_VOLTAGE__,\
                                           __ADC_DATA__,\
                                           __ADC_RESOLUTION__)\
((int32_t)((__ADC_DATA__) << 1U) * (int32_t)(__VREFANALOG_VOLTAGE__)\
 / (int32_t)(__LL_ADC_DIGITAL_SCALE(__ADC_RESOLUTION__))\
 - (int32_t)(__VREFANALOG_VOLTAGE__))
#define __LL_ADC_CALC_VREFANALOG_VOLTAGE(__VREFINT_ADC_DATA__,\
                                         __ADC_RESOLUTION__)                 \
(((uint32_t)(*VREFINT_CAL_ADDR) * VREFINT_CAL_VREF)                          \
 / __LL_ADC_CONVERT_DATA_RESOLUTION((__VREFINT_ADC_DATA__),                  \
                                    (__ADC_RESOLUTION__),                    \
                                    LL_ADC_RESOLUTION_12B)                   \
)
#define __LL_ADC_CALC_TEMPERATURE(__VREFANALOG_VOLTAGE__,\
                                  __TEMPSENSOR_ADC_DATA__,\
                                  __ADC_RESOLUTION__)\
((((int32_t)*TEMPSENSOR_CAL2_ADDR - (int32_t)*TEMPSENSOR_CAL1_ADDR) != 0) ?       \
 (((( ((int32_t)((__LL_ADC_CONVERT_DATA_RESOLUTION((__TEMPSENSOR_ADC_DATA__),     \
                                                   (__ADC_RESOLUTION__),          \
                                                   LL_ADC_RESOLUTION_12B)         \
                  * (__VREFANALOG_VOLTAGE__))                                     \
                 / TEMPSENSOR_CAL_VREFANALOG)                                     \
       - (int32_t) *TEMPSENSOR_CAL1_ADDR)                                         \
    ) * (int32_t)(TEMPSENSOR_CAL2_TEMP - TEMPSENSOR_CAL1_TEMP)                    \
   ) / (int32_t)((int32_t)*TEMPSENSOR_CAL2_ADDR - (int32_t)*TEMPSENSOR_CAL1_ADDR) \
  ) + TEMPSENSOR_CAL1_TEMP                                                        \
 )                                                                                \
 :                                                                                \
 ((int32_t)LL_ADC_TEMPERATURE_CALC_ERROR)                                         \
)
#define __LL_ADC_CALC_TEMPERATURE_TYP_PARAMS(__TEMPSENSOR_TYP_AVGSLOPE__,\
                                             __TEMPSENSOR_TYP_CALX_V__,\
                                             __TEMPSENSOR_CALX_TEMP__,\
                                             __VREFANALOG_VOLTAGE__,\
                                             __TEMPSENSOR_ADC_DATA__,\
                                             __ADC_RESOLUTION__)            \
(((((int32_t)((((__TEMPSENSOR_ADC_DATA__) * (__VREFANALOG_VOLTAGE__))       \
               / __LL_ADC_DIGITAL_SCALE(__ADC_RESOLUTION__))                \
              * 1000UL)                                                     \
    -                                                                       \
    (int32_t)(((__TEMPSENSOR_TYP_CALX_V__))                                 \
              * 1000UL)                                                     \
   )                                                                        \
  ) / (int32_t)(__TEMPSENSOR_TYP_AVGSLOPE__)                                \
 ) + (int32_t)(__TEMPSENSOR_CALX_TEMP__)                                    \
)
#if defined(ADC_MULTIMODE_SUPPORT)
#else
#endif 
#if defined(ADC_SMPR1_SMPPLUS)
#endif 
#if defined(ADC_MULTIMODE_SUPPORT)
#endif 
#if defined(ADC_MULTIMODE_SUPPORT)
#endif 
#if defined(ADC_MULTIMODE_SUPPORT)
#endif 
#if defined(USE_FULL_LL_DRIVER)
#endif 
#endif 
#ifdef __cplusplus
#endif
#endif 
