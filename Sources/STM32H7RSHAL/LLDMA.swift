// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_DMA_CHANNEL_0: UInt32 = 0x0000_0000
public let LL_DMA_CHANNEL_1: UInt32 = 0x0000_0001
public let LL_DMA_CHANNEL_2: UInt32 = 0x0000_0002
public let LL_DMA_CHANNEL_3: UInt32 = 0x0000_0003
public let LL_DMA_CHANNEL_4: UInt32 = 0x0000_0004
public let LL_DMA_CHANNEL_5: UInt32 = 0x0000_0005
public let LL_DMA_CHANNEL_6: UInt32 = 0x0000_0006
public let LL_DMA_CHANNEL_7: UInt32 = 0x0000_0007
public let LL_DMA_CHANNEL_8: UInt32 = 0x0000_0008
public let LL_DMA_CHANNEL_9: UInt32 = 0x0000_0009
public let LL_DMA_CHANNEL_10: UInt32 = 0x0000_000A
public let LL_DMA_CHANNEL_11: UInt32 = 0x0000_000B
public let LL_DMA_CHANNEL_12: UInt32 = 0x0000_000C
public let LL_DMA_CHANNEL_13: UInt32 = 0x0000_000D
public let LL_DMA_CHANNEL_14: UInt32 = 0x0000_000E
public let LL_DMA_CHANNEL_15: UInt32 = 0x0000_000F
public let LL_DMA_CHANNEL_ALL: UInt32 = 0x0000_0010
public let LL_DMA_CLLR_OFFSET0: UInt32 = 0x0000_0000
public let LL_DMA_CLLR_OFFSET1: UInt32 = 0x0000_0001
public let LL_DMA_CLLR_OFFSET2: UInt32 = 0x0000_0002
public let LL_DMA_CLLR_OFFSET3: UInt32 = 0x0000_0003
public let LL_DMA_CLLR_OFFSET4: UInt32 = 0x0000_0004
public let LL_DMA_CLLR_OFFSET5: UInt32 = 0x0000_0005
public let LL_DMA_CLLR_OFFSET6: UInt32 = 0x0000_0006
public let LL_DMA_CLLR_OFFSET7: UInt32 = 0x0000_0007
public let LL_DMA_LOW_PRIORITY_LOW_WEIGHT: UInt32 = 0x0000_0000
public let LL_DMA_LOW_PRIORITY_MID_WEIGHT: UInt32 = 0x0040_0000
public let LL_DMA_LOW_PRIORITY_HIGH_WEIGHT: UInt32 = 0x0080_0000
public let LL_DMA_HIGH_PRIORITY: UInt32 = 0x00C0_0000
public let LL_DMA_LINK_ALLOCATED_PORT0: UInt32 = 0x0000_0000
public let LL_DMA_LINK_ALLOCATED_PORT1: UInt32 = 0x0002_0000
public let LL_DMA_LSM_FULL_EXECUTION: UInt32 = 0x0000_0000
public let LL_DMA_LSM_1LINK_EXECUTION: UInt32 = 0x0001_0000
public let LL_DMA_DEST_WORD_PRESERVE: UInt32 = 0x0000_0000
public let LL_DMA_DEST_WORD_EXCHANGE: UInt32 = 0x1000_0000
public let LL_DMA_DEST_HALFWORD_PRESERVE: UInt32 = 0x0000_0000
public let LL_DMA_DEST_HALFWORD_EXCHANGE: UInt32 = 0x0800_0000
public let LL_DMA_DEST_BYTE_PRESERVE: UInt32 = 0x0000_0000
public let LL_DMA_DEST_BYTE_EXCHANGE: UInt32 = 0x0400_0000
public let LL_DMA_SRC_BYTE_PRESERVE: UInt32 = 0x0000_0000
public let LL_DMA_SRC_BYTE_EXCHANGE: UInt32 = 0x0000_2000
public let LL_DMA_SRC_ALLOCATED_PORT0: UInt32 = 0x0000_0000
public let LL_DMA_SRC_ALLOCATED_PORT1: UInt32 = 0x0000_4000
public let LL_DMA_DEST_ALLOCATED_PORT0: UInt32 = 0x0000_0000
public let LL_DMA_DEST_ALLOCATED_PORT1: UInt32 = 0x4000_0000
public let LL_DMA_DEST_FIXED: UInt32 = 0x0000_0000
public let LL_DMA_DEST_INCREMENT: UInt32 = 0x0008_0000
public let LL_DMA_DEST_DATAWIDTH_BYTE: UInt32 = 0x0000_0000
public let LL_DMA_DEST_DATAWIDTH_HALFWORD: UInt32 = 0x0001_0000
public let LL_DMA_DEST_DATAWIDTH_WORD: UInt32 = 0x0002_0000
public let LL_DMA_DEST_DATAWIDTH_DOUBLEWORD: UInt32 = 0x0003_0000
public let LL_DMA_DATA_ALIGN_ZEROPADD: UInt32 = 0x0000_0000
public let LL_DMA_DATA_ALIGN_SIGNEXTPADD: UInt32 = 0x0000_0800
public let LL_DMA_DATA_PACK_UNPACK: UInt32 = 0x0000_1000
public let LL_DMA_SRC_FIXED: UInt32 = 0x0000_0000
public let LL_DMA_SRC_INCREMENT: UInt32 = 0x0000_0008
public let LL_DMA_SRC_DATAWIDTH_BYTE: UInt32 = 0x0000_0000
public let LL_DMA_SRC_DATAWIDTH_HALFWORD: UInt32 = 0x0000_0001
public let LL_DMA_SRC_DATAWIDTH_WORD: UInt32 = 0x0000_0002
public let LL_DMA_SRC_DATAWIDTH_DOUBLEWORD: UInt32 = 0x0000_0003
public let LL_DMA_HWREQUEST_SINGLEBURST: UInt32 = 0x0000_0000
public let LL_DMA_HWREQUEST_BLK: UInt32 = 0x0000_0800
public let LL_DMA_TCEM_BLK_TRANSFER: UInt32 = 0x0000_0000
public let LL_DMA_TCEM_RPT_BLK_TRANSFER: UInt32 = 0x4000_0000
public let LL_DMA_TCEM_EACH_LLITEM_TRANSFER: UInt32 = 0x8000_0000
public let LL_DMA_TCEM_LAST_LLITEM_TRANSFER: UInt32 = 0xC000_0000
public let LL_DMA_TRIG_POLARITY_MASKED: UInt32 = 0x0000_0000
public let LL_DMA_TRIG_POLARITY_RISING: UInt32 = 0x0100_0000
public let LL_DMA_TRIG_POLARITY_FALLING: UInt32 = 0x0200_0000
public let LL_DMA_TRIGM_BLK_TRANSFER: UInt32 = 0x0000_0000
public let LL_DMA_TRIGM_RPT_BLK_TRANSFER: UInt32 = 0x0000_4000
public let LL_DMA_TRIGM_LLI_LINK_TRANSFER: UInt32 = 0x0000_8000
public let LL_DMA_TRIGM_SINGLBURST_TRANSFER: UInt32 = 0x0000_C000
public let LL_DMA_DIRECTION_MEMORY_TO_MEMORY: UInt32 = 0x0000_0200
public let LL_DMA_DIRECTION_PERIPH_TO_MEMORY: UInt32 = 0x0000_0000
public let LL_DMA_DIRECTION_MEMORY_TO_PERIPH: UInt32 = 0x0000_0400
public let LL_DMA_NORMAL: UInt32 = 0x0000_0000
public let LL_DMA_PFCTRL: UInt32 = 0x0000_1000
public let LL_DMA_BLKRPT_SRC_ADDR_INCREMENT: UInt32 = 0x0000_0000
public let LL_DMA_BLKRPT_SRC_ADDR_DECREMENT: UInt32 = 0x4000_0000
public let LL_DMA_BLKRPT_DEST_ADDR_INCREMENT: UInt32 = 0x0000_0000
public let LL_DMA_BLKRPT_DEST_ADDR_DECREMENT: UInt32 = 0x8000_0000
public let LL_DMA_BURST_SRC_ADDR_INCREMENT: UInt32 = 0x0000_0000
public let LL_DMA_BURST_SRC_ADDR_DECREMENT: UInt32 = 0x1000_0000
public let LL_DMA_BURST_DEST_ADDR_INCREMENT: UInt32 = 0x0000_0000
public let LL_DMA_BURST_DEST_ADDR_DECREMENT: UInt32 = 0x2000_0000
public let LL_DMA_GPDMA_LINEAR_NODE: UInt32 = 0x0000_0001
public let LL_DMA_GPDMA_2D_NODE: UInt32 = 0x0000_0002
public let LL_DMA_HPDMA_LINEAR_NODE: UInt32 = 0x0000_0004
public let LL_DMA_HPDMA_2D_NODE: UInt32 = 0x0000_0008
public let LL_DMA_UPDATE_CTR1: UInt32 = 0x8000_0000
public let LL_DMA_UPDATE_CTR2: UInt32 = 0x4000_0000
public let LL_DMA_UPDATE_CBR1: UInt32 = 0x2000_0000
public let LL_DMA_UPDATE_CSAR: UInt32 = 0x1000_0000
public let LL_DMA_UPDATE_CDAR: UInt32 = 0x0800_0000
public let LL_DMA_UPDATE_CTR3: UInt32 = 0x0400_0000
public let LL_DMA_UPDATE_CBR2: UInt32 = 0x0200_0000
public let LL_DMA_UPDATE_CLLR: UInt32 = 0x0001_0000
public let LL_HPDMA1_REQUEST_JPEG_RX: UInt32 = 0x0000_0000
public let LL_HPDMA1_REQUEST_JPEG_TX: UInt32 = 0x0000_0001
public let LL_HPDMA1_REQUEST_XSPI1: UInt32 = 0x0000_0002
public let LL_HPDMA1_REQUEST_XSPI2: UInt32 = 0x0000_0003
public let LL_HPDMA1_REQUEST_SPI3_RX: UInt32 = 0x0000_0004
public let LL_HPDMA1_REQUEST_SPI3_TX: UInt32 = 0x0000_0005
public let LL_HPDMA1_REQUEST_SPI4_RX: UInt32 = 0x0000_0006
public let LL_HPDMA1_REQUEST_SPI4_TX: UInt32 = 0x0000_0007
public let LL_HPDMA1_REQUEST_ADC1: UInt32 = 0x0000_0008
public let LL_HPDMA1_REQUEST_ADC2: UInt32 = 0x0000_0009
public let LL_HPDMA1_REQUEST_ADF1_FLT0: UInt32 = 0x0000_000A
public let LL_HPDMA1_REQUEST_UART4_RX: UInt32 = 0x0000_000B
public let LL_HPDMA1_REQUEST_UART4_TX: UInt32 = 0x0000_000C
public let LL_HPDMA1_REQUEST_UART5_RX: UInt32 = 0x0000_000D
public let LL_HPDMA1_REQUEST_UART5_TX: UInt32 = 0x0000_000E
public let LL_HPDMA1_REQUEST_UART7_RX: UInt32 = 0x0000_000F
public let LL_HPDMA1_REQUEST_UART7_TX: UInt32 = 0x0000_0010
public let LL_HPDMA1_REQUEST_LPTIM2_IC1: UInt32 = 0x0000_0011
public let LL_HPDMA1_REQUEST_LPTIM2_IC2: UInt32 = 0x0000_0012
public let LL_HPDMA1_REQUEST_LPTIM2_UE: UInt32 = 0x0000_0013
public let LL_GPDMA1_REQUEST_ADC1: UInt32 = 0x0000_0000
public let LL_GPDMA1_REQUEST_ADC2: UInt32 = 0x0000_0001
public let LL_GPDMA1_REQUEST_CRYP_IN: UInt32 = 0x0000_0002
public let LL_GPDMA1_REQUEST_CRYP_OUT: UInt32 = 0x0000_0003
public let LL_GPDMA1_REQUEST_SAES_IN: UInt32 = 0x0000_0004
public let LL_GPDMA1_REQUEST_SAES_OUT: UInt32 = 0x0000_0005
public let LL_GPDMA1_REQUEST_HASH_IN: UInt32 = 0x0000_0006
public let LL_GPDMA1_REQUEST_TIM1_CH1: UInt32 = 0x0000_0007
public let LL_GPDMA1_REQUEST_TIM1_CH2: UInt32 = 0x0000_0008
public let LL_GPDMA1_REQUEST_TIM1_CH3: UInt32 = 0x0000_0009
public let LL_GPDMA1_REQUEST_TIM1_CH4: UInt32 = 0x0000_000A
public let LL_GPDMA1_REQUEST_TIM1_UP: UInt32 = 0x0000_000B
public let LL_GPDMA1_REQUEST_TIM1_TRIG: UInt32 = 0x0000_000C
public let LL_GPDMA1_REQUEST_TIM1_COM: UInt32 = 0x0000_000D
public let LL_GPDMA1_REQUEST_TIM2_CH1: UInt32 = 0x0000_000E
public let LL_GPDMA1_REQUEST_TIM2_CH2: UInt32 = 0x0000_000F
public let LL_GPDMA1_REQUEST_TIM2_CH3: UInt32 = 0x0000_0010
public let LL_GPDMA1_REQUEST_TIM2_CH4: UInt32 = 0x0000_0011
public let LL_GPDMA1_REQUEST_TIM2_UP: UInt32 = 0x0000_0012
public let LL_GPDMA1_REQUEST_TIM2_TRIG: UInt32 = 0x0000_0013
public let LL_GPDMA1_REQUEST_TIM3_CH1: UInt32 = 0x0000_0014
public let LL_GPDMA1_REQUEST_TIM3_CH2: UInt32 = 0x0000_0015
public let LL_GPDMA1_REQUEST_TIM3_CH3: UInt32 = 0x0000_0016
public let LL_GPDMA1_REQUEST_TIM3_CH4: UInt32 = 0x0000_0017
public let LL_GPDMA1_REQUEST_TIM3_UP: UInt32 = 0x0000_0018
public let LL_GPDMA1_REQUEST_TIM3_TRIG: UInt32 = 0x0000_0019
public let LL_GPDMA1_REQUEST_TIM4_CH1: UInt32 = 0x0000_001A
public let LL_GPDMA1_REQUEST_TIM4_CH2: UInt32 = 0x0000_001B
public let LL_GPDMA1_REQUEST_TIM4_CH3: UInt32 = 0x0000_001C
public let LL_GPDMA1_REQUEST_TIM4_CH4: UInt32 = 0x0000_001D
public let LL_GPDMA1_REQUEST_TIM4_UP: UInt32 = 0x0000_001E
public let LL_GPDMA1_REQUEST_TIM4_TRIG: UInt32 = 0x0000_001F
public let LL_GPDMA1_REQUEST_TIM5_CH1: UInt32 = 0x0000_0020
public let LL_GPDMA1_REQUEST_TIM5_CH2: UInt32 = 0x0000_0021
public let LL_GPDMA1_REQUEST_TIM5_CH3: UInt32 = 0x0000_0022
public let LL_GPDMA1_REQUEST_TIM5_CH4: UInt32 = 0x0000_0023
public let LL_GPDMA1_REQUEST_TIM5_UP: UInt32 = 0x0000_0024
public let LL_GPDMA1_REQUEST_TIM5_TRIG: UInt32 = 0x0000_0025
public let LL_GPDMA1_REQUEST_TIM6_UP: UInt32 = 0x0000_0026
public let LL_GPDMA1_REQUEST_TIM7_UP: UInt32 = 0x0000_0027
public let LL_GPDMA1_REQUEST_TIM15_CH1: UInt32 = 0x0000_0028
public let LL_GPDMA1_REQUEST_TIM15_CH2: UInt32 = 0x0000_0029
public let LL_GPDMA1_REQUEST_TIM15_UP: UInt32 = 0x0000_002A
public let LL_GPDMA1_REQUEST_TIM15_TRIG: UInt32 = 0x0000_002B
public let LL_GPDMA1_REQUEST_TIM15_COM: UInt32 = 0x0000_002C
public let LL_GPDMA1_REQUEST_TIM16_CH1: UInt32 = 0x0000_002D
public let LL_GPDMA1_REQUEST_TIM16_UP: UInt32 = 0x0000_002E
public let LL_GPDMA1_REQUEST_TIM16_COM: UInt32 = 0x0000_002F
public let LL_GPDMA1_REQUEST_TIM17_CH1: UInt32 = 0x0000_0030
public let LL_GPDMA1_REQUEST_TIM17_UP: UInt32 = 0x0000_0031
public let LL_GPDMA1_REQUEST_TIM17_COM: UInt32 = 0x0000_0032
public let LL_GPDMA1_REQUEST_SPI1_RX: UInt32 = 0x0000_0033
public let LL_GPDMA1_REQUEST_SPI1_TX: UInt32 = 0x0000_0034
public let LL_GPDMA1_REQUEST_SPI2_RX: UInt32 = 0x0000_0035
public let LL_GPDMA1_REQUEST_SPI2_TX: UInt32 = 0x0000_0036
public let LL_GPDMA1_REQUEST_SPI3_RX: UInt32 = 0x0000_0037
public let LL_GPDMA1_REQUEST_SPI3_TX: UInt32 = 0x0000_0038
public let LL_GPDMA1_REQUEST_SPI4_RX: UInt32 = 0x0000_0039
public let LL_GPDMA1_REQUEST_SPI4_TX: UInt32 = 0x0000_003A
public let LL_GPDMA1_REQUEST_SPI5_RX: UInt32 = 0x0000_003B
public let LL_GPDMA1_REQUEST_SPI5_TX: UInt32 = 0x0000_003C
public let LL_GPDMA1_REQUEST_SPI6_RX: UInt32 = 0x0000_003D
public let LL_GPDMA1_REQUEST_SPI6_TX: UInt32 = 0x0000_003E
public let LL_GPDMA1_REQUEST_SAI1_A: UInt32 = 0x0000_003F
public let LL_GPDMA1_REQUEST_SAI1_B: UInt32 = 0x0000_0040
public let LL_GPDMA1_REQUEST_SAI2_A: UInt32 = 0x0000_0041
public let LL_GPDMA1_REQUEST_SAI2_B: UInt32 = 0x0000_0042
public let LL_GPDMA1_REQUEST_I2C1_RX: UInt32 = 0x0000_0043
public let LL_GPDMA1_REQUEST_I2C1_TX: UInt32 = 0x0000_0044
public let LL_GPDMA1_REQUEST_I2C2_RX: UInt32 = 0x0000_0045
public let LL_GPDMA1_REQUEST_I2C2_TX: UInt32 = 0x0000_0046
public let LL_GPDMA1_REQUEST_I2C3_RX: UInt32 = 0x0000_0047
public let LL_GPDMA1_REQUEST_I2C3_TX: UInt32 = 0x0000_0048
public let LL_GPDMA1_REQUEST_USART1_RX: UInt32 = 0x0000_0049
public let LL_GPDMA1_REQUEST_USART1_TX: UInt32 = 0x0000_004A
public let LL_GPDMA1_REQUEST_USART2_RX: UInt32 = 0x0000_004B
public let LL_GPDMA1_REQUEST_USART2_TX: UInt32 = 0x0000_004C
public let LL_GPDMA1_REQUEST_USART3_RX: UInt32 = 0x0000_004D
public let LL_GPDMA1_REQUEST_USART3_TX: UInt32 = 0x0000_004E
public let LL_GPDMA1_REQUEST_UART4_RX: UInt32 = 0x0000_004F
public let LL_GPDMA1_REQUEST_UART4_TX: UInt32 = 0x0000_0050
public let LL_GPDMA1_REQUEST_UART5_RX: UInt32 = 0x0000_0051
public let LL_GPDMA1_REQUEST_UART5_TX: UInt32 = 0x0000_0052
public let LL_GPDMA1_REQUEST_UART7_RX: UInt32 = 0x0000_0053
public let LL_GPDMA1_REQUEST_UART7_TX: UInt32 = 0x0000_0054
public let LL_GPDMA1_REQUEST_UART8_RX: UInt32 = 0x0000_0055
public let LL_GPDMA1_REQUEST_UART8_TX: UInt32 = 0x0000_0056
public let LL_GPDMA1_REQUEST_CORDIC_READ: UInt32 = 0x0000_0057
public let LL_GPDMA1_REQUEST_CORDIC_WRITE: UInt32 = 0x0000_0058
public let LL_GPDMA1_REQUEST_LPTIM1_IC1: UInt32 = 0x0000_0059
public let LL_GPDMA1_REQUEST_LPTIM1_IC2: UInt32 = 0x0000_005A
public let LL_GPDMA1_REQUEST_LPTIM1_UE: UInt32 = 0x0000_005B
public let LL_GPDMA1_REQUEST_LPTIM2_IC1: UInt32 = 0x0000_005C
public let LL_GPDMA1_REQUEST_LPTIM2_IC2: UInt32 = 0x0000_005D
public let LL_GPDMA1_REQUEST_LPTIM2_UE: UInt32 = 0x0000_005E
public let LL_GPDMA1_REQUEST_SPDIF_RX_DT: UInt32 = 0x0000_005F
public let LL_GPDMA1_REQUEST_SPDIF_RX_CS: UInt32 = 0x0000_0060
public let LL_GPDMA1_REQUEST_ADF1_FLT0: UInt32 = 0x0000_0061
public let LL_GPDMA1_REQUEST_UCPD1_TX: UInt32 = 0x0000_0062
public let LL_GPDMA1_REQUEST_UCPD1_RX: UInt32 = 0x0000_0063
public let LL_GPDMA1_REQUEST_PSSI: UInt32 = 0x0000_0064
public let LL_GPDMA1_REQUEST_LPUART1_RX: UInt32 = 0x0000_0065
public let LL_GPDMA1_REQUEST_LPUART1_TX: UInt32 = 0x0000_0066
public let LL_GPDMA1_REQUEST_LPTIM3_IC1: UInt32 = 0x0000_0067
public let LL_GPDMA1_REQUEST_LPTIM3_IC2: UInt32 = 0x0000_0068
public let LL_GPDMA1_REQUEST_LPTIM3_UE: UInt32 = 0x0000_0069
public let LL_GPDMA1_REQUEST_I3C1_RX: UInt32 = 0x0000_006A
public let LL_GPDMA1_REQUEST_I3C1_TX: UInt32 = 0x0000_006B
public let LL_GPDMA1_REQUEST_I3C1_TC: UInt32 = 0x0000_006C
public let LL_GPDMA1_REQUEST_I3C1_RS: UInt32 = 0x0000_006D
public let LL_HPDMA1_TRIGGER_DCMIPP_EVT_FRAMEEND: UInt32 = 0x0000_0000
public let LL_HPDMA1_TRIGGER_DCMIPP_EVT_HSYNC: UInt32 = 0x0000_0001
public let LL_HPDMA1_TRIGGER_DCMIPP_EVT_LINEEND: UInt32 = 0x0000_0002
public let LL_HPDMA1_TRIGGER_DCMIPP_EVT_VSYNC: UInt32 = 0x0000_0003
public let LL_HPDMA1_TRIGGER_DMA2D_CTC_FLAG: UInt32 = 0x0000_0004
public let LL_HPDMA1_TRIGGER_DMA2D_TC_FLAG: UInt32 = 0x0000_0005
public let LL_HPDMA1_TRIGGER_DMA2D_TW_FLAG: UInt32 = 0x0000_0006
public let LL_HPDMA1_TRIGGER_JPEG_EOC_FLAG: UInt32 = 0x0000_0007
public let LL_HPDMA1_TRIGGER_JPEG_IFNF_FLAG: UInt32 = 0x0000_0008
public let LL_HPDMA1_TRIGGER_JPEG_IFT_FLAG: UInt32 = 0x0000_0009
public let LL_HPDMA1_TRIGGER_JPEG_OFNE_FLAG: UInt32 = 0x0000_000A
public let LL_HPDMA1_TRIGGER_JPEG_OFT_FLAG: UInt32 = 0x0000_000B
public let LL_HPDMA1_TRIGGER_LCD: UInt32 = 0x0000_000C
public let LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG0: UInt32 = 0x0000_000D
public let LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG1: UInt32 = 0x0000_000E
public let LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG2: UInt32 = 0x0000_000F
public let LL_HPDMA1_TRIGGER_GPU2D1_GP_FLAG3: UInt32 = 0x0000_0010
public let LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_4: UInt32 = 0x0000_0011
public let LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_3: UInt32 = 0x0000_0012
public let LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_2: UInt32 = 0x0000_0013
public let LL_HPDMA1_TRIGGER_GFXTIM_0_EVT_1: UInt32 = 0x0000_0014
public let LL_HPDMA1_TRIGGER_GPDMA1_CH0_TCF: UInt32 = 0x0000_0015
public let LL_HPDMA1_TRIGGER_GPDMA1_CH1_TCF: UInt32 = 0x0000_0016
public let LL_HPDMA1_TRIGGER_GPDMA1_CH2_TCF: UInt32 = 0x0000_0017
public let LL_HPDMA1_TRIGGER_GPDMA1_CH3_TCF: UInt32 = 0x0000_0018
public let LL_HPDMA1_TRIGGER_GPDMA1_CH4_TCF: UInt32 = 0x0000_0019
public let LL_HPDMA1_TRIGGER_GPDMA1_CH5_TCF: UInt32 = 0x0000_001A
public let LL_HPDMA1_TRIGGER_GPDMA1_CH6_TCF: UInt32 = 0x0000_001B
public let LL_HPDMA1_TRIGGER_GPDMA1_CH7_TCF: UInt32 = 0x0000_001C
public let LL_HPDMA1_TRIGGER_GPDMA1_CH8_TCF: UInt32 = 0x0000_001D
public let LL_HPDMA1_TRIGGER_GPDMA1_CH9_TCF: UInt32 = 0x0000_001E
public let LL_HPDMA1_TRIGGER_GPDMA1_CH10_TCF: UInt32 = 0x0000_001F
public let LL_HPDMA1_TRIGGER_GPDMA1_CH11_TCF: UInt32 = 0x0000_0020
public let LL_HPDMA1_TRIGGER_GPDMA1_CH12_TCF: UInt32 = 0x0000_0021
public let LL_HPDMA1_TRIGGER_GPDMA1_CH13_TCF: UInt32 = 0x0000_0022
public let LL_HPDMA1_TRIGGER_GPDMA1_CH14_TCF: UInt32 = 0x0000_0023
public let LL_HPDMA1_TRIGGER_GPDMA1_CH15_TCF: UInt32 = 0x0000_0024
public let LL_HPDMA1_TRIGGER_HPDMA1_CH0_TCF: UInt32 = 0x0000_0025
public let LL_HPDMA1_TRIGGER_HPDMA1_CH1_TCF: UInt32 = 0x0000_0026
public let LL_HPDMA1_TRIGGER_HPDMA1_CH2_TCF: UInt32 = 0x0000_0027
public let LL_HPDMA1_TRIGGER_HPDMA1_CH3_TCF: UInt32 = 0x0000_0028
public let LL_HPDMA1_TRIGGER_HPDMA1_CH4_TCF: UInt32 = 0x0000_0029
public let LL_HPDMA1_TRIGGER_HPDMA1_CH5_TCF: UInt32 = 0x0000_002A
public let LL_HPDMA1_TRIGGER_HPDMA1_CH6_TCF: UInt32 = 0x0000_002B
public let LL_HPDMA1_TRIGGER_HPDMA1_CH7_TCF: UInt32 = 0x0000_002C
public let LL_HPDMA1_TRIGGER_HPDMA1_CH8_TCF: UInt32 = 0x0000_002D
public let LL_HPDMA1_TRIGGER_HPDMA1_CH9_TCF: UInt32 = 0x0000_002E
public let LL_HPDMA1_TRIGGER_HPDMA1_CH10_TCF: UInt32 = 0x0000_002F
public let LL_HPDMA1_TRIGGER_HPDMA1_CH11_TCF: UInt32 = 0x0000_0030
public let LL_HPDMA1_TRIGGER_HPDMA1_CH12_TCF: UInt32 = 0x0000_0031
public let LL_HPDMA1_TRIGGER_HPDMA1_CH13_TCF: UInt32 = 0x0000_0032
public let LL_HPDMA1_TRIGGER_HPDMA1_CH14_TCF: UInt32 = 0x0000_0033
public let LL_HPDMA1_TRIGGER_HPDMA1_CH15_TCF: UInt32 = 0x0000_0034
public let LL_GPDMA1_TRIGGER_HPDMA1_CH0_TCF: UInt32 = 0x0000_0000
public let LL_GPDMA1_TRIGGER_HPDMA1_CH1_TCF: UInt32 = 0x0000_0001
public let LL_GPDMA1_TRIGGER_HPDMA1_CH2_TCF: UInt32 = 0x0000_0002
public let LL_GPDMA1_TRIGGER_HPDMA1_CH3_TCF: UInt32 = 0x0000_0003
public let LL_GPDMA1_TRIGGER_HPDMA1_CH4_TCF: UInt32 = 0x0000_0004
public let LL_GPDMA1_TRIGGER_HPDMA1_CH5_TCF: UInt32 = 0x0000_0005
public let LL_GPDMA1_TRIGGER_HPDMA1_CH6_TCF: UInt32 = 0x0000_0006
public let LL_GPDMA1_TRIGGER_HPDMA1_CH7_TCF: UInt32 = 0x0000_0007
public let LL_GPDMA1_TRIGGER_HPDMA1_CH8_TCF: UInt32 = 0x0000_0008
public let LL_GPDMA1_TRIGGER_HPDMA1_CH9_TCF: UInt32 = 0x0000_0009
public let LL_GPDMA1_TRIGGER_HPDMA1_CH10_TCF: UInt32 = 0x0000_000A
public let LL_GPDMA1_TRIGGER_HPDMA1_CH11_TCF: UInt32 = 0x0000_000B
public let LL_GPDMA1_TRIGGER_HPDMA1_CH12_TCF: UInt32 = 0x0000_000C
public let LL_GPDMA1_TRIGGER_HPDMA1_CH13_TCF: UInt32 = 0x0000_000D
public let LL_GPDMA1_TRIGGER_HPDMA1_CH14_TCF: UInt32 = 0x0000_000E
public let LL_GPDMA1_TRIGGER_HPDMA1_CH15_TCF: UInt32 = 0x0000_000F
public let LL_GPDMA1_TRIGGER_LPTIM1_CH1: UInt32 = 0x0000_0010
public let LL_GPDMA1_TRIGGER_LPTIM1_CH2: UInt32 = 0x0000_0011
public let LL_GPDMA1_TRIGGER_LPTIM2_CH1: UInt32 = 0x0000_0012
public let LL_GPDMA1_TRIGGER_LPTIM2_CH2: UInt32 = 0x0000_0013
public let LL_GPDMA1_TRIGGER_LPTIM3_CH1: UInt32 = 0x0000_0014
public let LL_GPDMA1_TRIGGER_LPTIM3_CH2: UInt32 = 0x0000_0015
public let LL_GPDMA1_TRIGGER_LPTIM4_OUT: UInt32 = 0x0000_0016
public let LL_GPDMA1_TRIGGER_LPTIM5_OUT: UInt32 = 0x0000_0017
public let LL_GPDMA1_TRIGGER_EXTIT0_SYNC: UInt32 = 0x0000_0018
public let LL_GPDMA1_TRIGGER_RTC_WKUP: UInt32 = 0x0000_0019
public let LL_GPDMA1_TRIGGER_LPUART1_IT_R_WUP_ASYNC: UInt32 = 0x0000_001A
public let LL_GPDMA1_TRIGGER_LPUART1_IT_T_WUP_ASYNC: UInt32 = 0x0000_001B
public let LL_GPDMA1_TRIGGER_SPI6_IT_OR_SPI6_AIT_SYNC: UInt32 = 0x0000_001C
public let LL_GPDMA1_TRIGGER_GPDMA1_CH0_TCF: UInt32 = 0x0000_001D
public let LL_GPDMA1_TRIGGER_GPDMA1_CH1_TCF: UInt32 = 0x0000_001E
public let LL_GPDMA1_TRIGGER_GPDMA1_CH2_TCF: UInt32 = 0x0000_001F
public let LL_GPDMA1_TRIGGER_GPDMA1_CH3_TCF: UInt32 = 0x0000_0020
public let LL_GPDMA1_TRIGGER_GPDMA1_CH4_TCF: UInt32 = 0x0000_0021
public let LL_GPDMA1_TRIGGER_GPDMA1_CH5_TCF: UInt32 = 0x0000_0022
public let LL_GPDMA1_TRIGGER_GPDMA1_CH6_TCF: UInt32 = 0x0000_0023
public let LL_GPDMA1_TRIGGER_GPDMA1_CH7_TCF: UInt32 = 0x0000_0024
public let LL_GPDMA1_TRIGGER_GPDMA1_CH8_TCF: UInt32 = 0x0000_0025
public let LL_GPDMA1_TRIGGER_GPDMA1_CH9_TCF: UInt32 = 0x0000_0026
public let LL_GPDMA1_TRIGGER_GPDMA1_CH10_TCF: UInt32 = 0x0000_0027
public let LL_GPDMA1_TRIGGER_GPDMA1_CH11_TCF: UInt32 = 0x0000_0028
public let LL_GPDMA1_TRIGGER_GPDMA1_CH12_TCF: UInt32 = 0x0000_0029
public let LL_GPDMA1_TRIGGER_GPDMA1_CH13_TCF: UInt32 = 0x0000_002A
public let LL_GPDMA1_TRIGGER_GPDMA1_CH14_TCF: UInt32 = 0x0000_002B
public let LL_GPDMA1_TRIGGER_GPDMA1_CH15_TCF: UInt32 = 0x0000_002C
public let LL_GPDMA1_TRIGGER_TIM1_TRGO: UInt32 = 0x0000_002D
public let LL_GPDMA1_TRIGGER_TIM1_TRGO2: UInt32 = 0x0000_002E
public let LL_GPDMA1_TRIGGER_TIM2_TRGO: UInt32 = 0x0000_002F
public let LL_GPDMA1_TRIGGER_TIM3_TRGO: UInt32 = 0x0000_0030
public let LL_GPDMA1_TRIGGER_TIM4_TRGO: UInt32 = 0x0000_0031
public let LL_GPDMA1_TRIGGER_TIM5_TRGO: UInt32 = 0x0000_0032
public let LL_GPDMA1_TRIGGER_TIM6_TRGO: UInt32 = 0x0000_0033
public let LL_GPDMA1_TRIGGER_TIM7_TRGO: UInt32 = 0x0000_0034
public let LL_GPDMA1_TRIGGER_TIM9_TRGO: UInt32 = 0x0000_0035
public let LL_GPDMA1_TRIGGER_TIM12_TRGO: UInt32 = 0x0000_0036
public let LL_GPDMA1_TRIGGER_TIM15_TRGO: UInt32 = 0x0000_0037

public func LL_DMA_EnableChannel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x1))
}

public func LL_DMA_DisableChannel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | ((0x4 | 0x2)))
}

public func LL_DMA_IsEnabledChannel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x1))
        == (0x1)) ? 1 : 0)
}

public func LL_DMA_ResetChannel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x2))
}

public func LL_DMA_SuspendChannel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x4))
}

public func LL_DMA_ResumeChannel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) & ~(0x4))
}

public func LL_DMA_IsSuspendedChannel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x4))
        == (0x4)) ? 1 : 0)
}

public func LL_DMA_SetLinkedListBaseAddr<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ LinkedListBaseAddr: UInt32
) {

    registers.write(
        DMARegister.clbar, channel: Channel,
        value: (registers.read(DMARegister.clbar, channel: Channel) & ~(0xffff_0000))
            | ((LinkedListBaseAddr & 0xffff_0000)))
}

public func LL_DMA_GetLinkedListBaseAddr<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.clbar, channel: Channel) & (0xffff_0000)))
}

public func LL_DMA_ConfigControl<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Configuration: UInt32)
{

    registers.write(
        DMARegister.ccr, channel: Channel,
        value: (registers.read(DMARegister.ccr, channel: Channel) & ~((0xc00000 | 0x20000 | 0x10000))) | (Configuration)
    )
}

public func LL_DMA_SetChannelPriorityLevel<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ Priority: UInt32
) {

    registers.write(
        DMARegister.ccr, channel: Channel,
        value: (registers.read(DMARegister.ccr, channel: Channel) & ~(0xc00000)) | (Priority))
}

public func LL_DMA_GetChannelPriorityLevel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ccr, channel: Channel) & (0xc00000)))
}

public func LL_DMA_SetLinkAllocatedPort<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ LinkAllocatedPort: UInt32
) {

    registers.write(
        DMARegister.ccr, channel: Channel,
        value: (registers.read(DMARegister.ccr, channel: Channel) & ~(0x20000)) | (LinkAllocatedPort))
}

public func LL_DMA_GetLinkAllocatedPort<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ccr, channel: Channel) & (0x20000)))
}

public func LL_DMA_SetLinkStepMode<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ LinkStepMode: UInt32
) {

    registers.write(
        DMARegister.ccr, channel: Channel,
        value: (registers.read(DMARegister.ccr, channel: Channel) & ~(0x10000)) | (LinkStepMode))
}

public func LL_DMA_GetLinkStepMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ccr, channel: Channel) & (0x10000)))
}

public func LL_DMA_ConfigTransfer<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ Configuration: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel)
            & ~(0x4000_0000 | 0x1000_0000 | 0x8000000 | 0x4000000 | 0x2000 | 0x80000 | 0x8 | 0x4000 | 0x1800 | 0x30000
            | 0x3)) | (Configuration))
}

public func LL_DMA_ConfigBurstLength<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcBurstLength: UInt32, _ DestBurstLength: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~((0x3f0 | 0x3f00000)))
            | ((((SrcBurstLength &- 1) << 0x4) & 0x3f0) | (((DestBurstLength &- 1) << 0x14) & 0x3f00000)))
}

public func LL_DMA_SetDestAllocatedPort<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DestAllocatedPort: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x4000_0000)) | (DestAllocatedPort))
}

public func LL_DMA_GetDestAllocatedPort<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x4000_0000)))
}

public func LL_DMA_SetDestWordExchange<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DestWordExchange: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x1000_0000)) | (DestWordExchange))
}

public func LL_DMA_GetDestWordExchange<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x1000_0000)))
}

public func LL_DMA_SetDestHWordExchange<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DestHWordExchange: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x8000000)) | (DestHWordExchange))
}

public func LL_DMA_GetDestHWordExchange<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x8000000)))
}

public func LL_DMA_SetDestByteExchange<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DestByteExchange: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x4000000)) | (DestByteExchange))
}

public func LL_DMA_GetDestByteExchange<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x4000000)))
}

public func LL_DMA_SetSrcByteExchange<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcByteExchange: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x2000)) | (SrcByteExchange))
}

public func LL_DMA_GetSrcByteExchange<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x2000)))
}

public func LL_DMA_SetDestBurstLength<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DestBurstLength: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x3f00000))
            | (((DestBurstLength &- 1) << 0x14) & 0x3f00000))
}

public func LL_DMA_GetDestBurstLength<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return (((registers.read(DMARegister.ctr1, channel: Channel) & (0x3f00000)) >> 0x14) &+ 1)
}

public func LL_DMA_SetDestIncMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ DestInc: UInt32) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x80000)) | (DestInc))
}

public func LL_DMA_GetDestIncMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x80000)))
}

public func LL_DMA_SetDestDataWidth<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DestDataWidth: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x30000)) | (DestDataWidth))
}

public func LL_DMA_GetDestDataWidth<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x30000)))
}

public func LL_DMA_SetSrcAllocatedPort<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcAllocatedPort: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x4000)) | (SrcAllocatedPort))
}

public func LL_DMA_GetSrcAllocatedPort<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x4000)))
}

public func LL_DMA_SetDataAlignment<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DataAlignment: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x1800)) | (DataAlignment))
}

public func LL_DMA_GetDataAlignment<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x1800)))
}

public func LL_DMA_SetSrcBurstLength<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcBurstLength: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x3f0))
            | (((SrcBurstLength &- 1) << 0x4) & 0x3f0))
}

public func LL_DMA_GetSrcBurstLength<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return (((registers.read(DMARegister.ctr1, channel: Channel) & (0x3f0)) >> 0x4) &+ 1)
}

public func LL_DMA_SetSrcIncMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ SrcInc: UInt32) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x8)) | (SrcInc))
}

public func LL_DMA_GetSrcIncMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x8)))
}

public func LL_DMA_SetSrcDataWidth<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcDataWidth: UInt32
) {

    registers.write(
        DMARegister.ctr1, channel: Channel,
        value: (registers.read(DMARegister.ctr1, channel: Channel) & ~(0x3)) | (SrcDataWidth))
}

public func LL_DMA_GetSrcDataWidth<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr1, channel: Channel) & (0x3)))
}

public func LL_DMA_ConfigChannelTransfer<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ Configuration: UInt32
) {

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel)
            & ~((0xc000_0000 | 0x3000000 | 0xc000 | 0x400 | 0x200 | 0x800 | 0x1000))) | (Configuration))
}

public func LL_DMA_SetTransferEventMode<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ TransferEventMode: UInt32
) {

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel) & ~(0xc000_0000)) | (TransferEventMode))
}

public func LL_DMA_GetTransferEventMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr2, channel: Channel) & (0xc000_0000)))
}

public func LL_DMA_SetTriggerPolarity<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ TriggerPolarity: UInt32
) {

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel) & ~(0x3000000)) | (TriggerPolarity))
}

public func LL_DMA_GetTriggerPolarity<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr2, channel: Channel) & (0x3000000)))
}

public func LL_DMA_SetTriggerMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ TriggerMode: UInt32)
{

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel) & ~(0xc000)) | (TriggerMode))
}

public func LL_DMA_GetTriggerMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr2, channel: Channel) & (0xc000)))
}

public func LL_DMA_SetDataTransferDirection<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ Direction: UInt32
) {

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel) & ~(0x400 | 0x200)) | (Direction))
}

public func LL_DMA_GetDataTransferDirection<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr2, channel: Channel) & (0x400 | 0x200)))
}

public func LL_DMA_SetBlkHWRequest<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ BlkHWRequest: UInt32
) {

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel) & ~(0x800)) | (BlkHWRequest))
}

public func LL_DMA_GetBlkHWRequest<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr2, channel: Channel) & (0x800)))
}

public func LL_DMA_SetPeriphRequest<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Request: UInt32) {

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel) & ~(0x7f)) | (Request))
}

public func LL_DMA_GetPeriphRequest<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr2, channel: Channel) & (0x7f)))
}

public func LL_DMA_SetHWTrigger<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Trigger: UInt32) {

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel) & ~(0x3f0000)) | ((Trigger << 0x10) & 0x3f0000))
}

public func LL_DMA_GetHWTrigger<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr2, channel: Channel) & (0x3f0000)) >> 0x10)
}

public func LL_DMA_SetTransferMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Mode: UInt32) {

    registers.write(
        DMARegister.ctr2, channel: Channel,
        value: (registers.read(DMARegister.ctr2, channel: Channel) & ~(0x1000)) | (Mode & 0x1000))
}

public func LL_DMA_GetTransferMode<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr2, channel: Channel) & (0x1000)))
}

public func LL_DMA_ConfigBlkRptAddrUpdate<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ Configuration: UInt32
) {

    registers.write(
        DMARegister.cbr1, channel: Channel,
        value: (registers.read(DMARegister.cbr1, channel: Channel)
            & ~(0x8000_0000 | 0x4000_0000 | 0x2000_0000 | 0x1000_0000)) | (Configuration))
}

public func LL_DMA_ConfigBlkCounters<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ BlkDataLength: UInt32, _ BlkRptCount: UInt32
) {

    registers.write(
        DMARegister.cbr1, channel: Channel,
        value: (registers.read(DMARegister.cbr1, channel: Channel) & ~((0xffff | 0x7ff0000)))
            | ((BlkDataLength | (BlkRptCount << 0x10))))
}

public func LL_DMA_SetBlkRptDestAddrUpdate<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ BlkRptDestAddrUpdate: UInt32
) {

    registers.write(
        DMARegister.cbr1, channel: Channel,
        value: (registers.read(DMARegister.cbr1, channel: Channel) & ~(0x8000_0000)) | (BlkRptDestAddrUpdate))
}

public func LL_DMA_GetBlkRptDestAddrUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.cbr1, channel: Channel) & (0x8000_0000)))
}

public func LL_DMA_SetBlkRptSrcAddrUpdate<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ BlkRptSrcAddrUpdate: UInt32
) {

    registers.write(
        DMARegister.cbr1, channel: Channel,
        value: (registers.read(DMARegister.cbr1, channel: Channel) & ~(0x4000_0000)) | (BlkRptSrcAddrUpdate))
}

public func LL_DMA_GetBlkRptSrcAddrUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.cbr1, channel: Channel) & (0x4000_0000)))
}

public func LL_DMA_SetDestAddrUpdate<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DestAddrUpdate: UInt32
) {

    registers.write(
        DMARegister.cbr1, channel: Channel,
        value: (registers.read(DMARegister.cbr1, channel: Channel) & ~(0x2000_0000)) | (DestAddrUpdate))
}

public func LL_DMA_GetDestAddrUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.cbr1, channel: Channel) & (0x2000_0000)))
}

public func LL_DMA_SetSrcAddrUpdate<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcAddrUpdate: UInt32
) {

    registers.write(
        DMARegister.cbr1, channel: Channel,
        value: (registers.read(DMARegister.cbr1, channel: Channel) & ~(0x1000_0000)) | (SrcAddrUpdate))
}

public func LL_DMA_GetSrcAddrUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.cbr1, channel: Channel) & (0x1000_0000)))
}

public func LL_DMA_SetBlkRptCount<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ BlkRptCount: UInt32)
{

    registers.write(
        DMARegister.cbr1, channel: Channel,
        value: (registers.read(DMARegister.cbr1, channel: Channel) & ~(0x7ff0000)) | ((BlkRptCount << 0x10) & 0x7ff0000)
    )
}

public func LL_DMA_GetBlkRptCount<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.cbr1, channel: Channel) & (0x7ff0000)) >> 0x10)
}

public func LL_DMA_SetBlkDataLength<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ BlkDataLength: UInt32
) {

    registers.write(
        DMARegister.cbr1, channel: Channel,
        value: (registers.read(DMARegister.cbr1, channel: Channel) & ~(0xffff)) | (BlkDataLength))
}

public func LL_DMA_GetBlkDataLength<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.cbr1, channel: Channel) & (0xffff)))
}

public func LL_DMA_ConfigAddresses<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcAddress: UInt32, _ DestAddress: UInt32
) {

    registers.write(DMARegister.csar, channel: Channel, value: SrcAddress)
    registers.write(DMARegister.cdar, channel: Channel, value: DestAddress)
}

public func LL_DMA_SetSrcAddress<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ SrcAddress: UInt32) {

    registers.write(DMARegister.csar, channel: Channel, value: SrcAddress)
}

public func LL_DMA_GetSrcAddress<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return (registers.read(DMARegister.csar, channel: Channel))
}

public func LL_DMA_SetDestAddress<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ DestAddress: UInt32)
{

    registers.write(DMARegister.cdar, channel: Channel, value: DestAddress)
}

public func LL_DMA_GetDestAddress<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return (registers.read(DMARegister.cdar, channel: Channel))
}

public func LL_DMA_ConfigAddrUpdateValue<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcAddrOffset: UInt32, _ DestAddrOffset: UInt32
) {

    registers.write(
        DMARegister.ctr3, channel: Channel, value: (SrcAddrOffset & 0x1fff) | ((DestAddrOffset << 0x10) & 0x1fff_0000))
}

public func LL_DMA_SetDestAddrUpdateValue<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DestAddrOffset: UInt32
) {

    registers.write(
        DMARegister.ctr3, channel: Channel,
        value: (registers.read(DMARegister.ctr3, channel: Channel) & ~(0x1fff_0000))
            | (((DestAddrOffset << 0x10) & 0x1fff_0000)))
}

public func LL_DMA_GetDestAddrUpdateValue<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr3, channel: Channel) & (0x1fff_0000)) >> 0x10)
}

public func LL_DMA_SetSrcAddrUpdateValue<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ SrcAddrOffset: UInt32
) {

    registers.write(
        DMARegister.ctr3, channel: Channel,
        value: (registers.read(DMARegister.ctr3, channel: Channel) & ~(0x1fff)) | (SrcAddrOffset & 0x1fff))
}

public func LL_DMA_GetSrcAddrUpdateValue<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.ctr3, channel: Channel) & (0x1fff)))
}

public func LL_DMA_ConfigBlkRptAddrUpdateValue<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ BlkRptSrcAddrOffset: UInt32, _ BlkRptDestAddrOffset: UInt32
) {

    registers.write(
        DMARegister.cbr2, channel: Channel,
        value: ((BlkRptDestAddrOffset << 0x10) & 0xffff_0000) | (BlkRptSrcAddrOffset & 0xffff))
}

public func LL_DMA_SetBlkRptDestAddrUpdateValue<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ BlkRptDestAddrOffset: UInt32
) {

    registers.write(
        DMARegister.cbr2, channel: Channel,
        value: (registers.read(DMARegister.cbr2, channel: Channel) & ~(0xffff_0000))
            | (((BlkRptDestAddrOffset << 0x10) & 0xffff_0000)))
}

public func LL_DMA_GetBlkRptDestAddrUpdateValue<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32
{

    return ((registers.read(DMARegister.cbr2, channel: Channel) & (0xffff_0000)) >> 0x10)
}

public func LL_DMA_SetBlkRptSrcAddrUpdateValue<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ BlkRptSrcAddrOffset: UInt32
) {

    registers.write(
        DMARegister.cbr2, channel: Channel,
        value: (registers.read(DMARegister.cbr2, channel: Channel) & ~(0xffff)) | (BlkRptSrcAddrOffset))
}

public func LL_DMA_GetBlkRptSrcAddrUpdateValue<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32
{

    return ((registers.read(DMARegister.cbr2, channel: Channel) & (0xffff)))
}

public func LL_DMA_ConfigLinkUpdate<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ RegistersUpdate: UInt32, _ LinkedListAddrOffset: UInt32
) {

    registers.write(
        DMARegister.cllr, channel: Channel,
        value: (registers.read(DMARegister.cllr, channel: Channel)
            & ~((0x8000_0000 | 0x4000_0000 | 0x2000_0000 | 0x1000_0000 | 0x8000000 | 0x4000000 | 0x2000000 | 0x10000
            | 0xfffc))) | ((RegistersUpdate | (LinkedListAddrOffset & 0xfffc))))
}

public func LL_DMA_EnableCTR1Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) | (0x8000_0000))
}

public func LL_DMA_DisableCTR1Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) & ~(0x8000_0000))
}

public func LL_DMA_IsEnabledCTR1Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.cllr, channel: Channel) & (0x8000_0000))
        == (0x8000_0000)) ? 1 : 0)
}

public func LL_DMA_EnableCTR2Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) | (0x4000_0000))
}

public func LL_DMA_DisableCTR2Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) & ~(0x4000_0000))
}

public func LL_DMA_IsEnabledCTR2Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.cllr, channel: Channel) & (0x4000_0000))
        == (0x4000_0000)) ? 1 : 0)
}

public func LL_DMA_EnableCBR1Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) | (0x2000_0000))
}

public func LL_DMA_DisableCBR1Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) & ~(0x2000_0000))
}

public func LL_DMA_IsEnabledCBR1Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.cllr, channel: Channel) & (0x2000_0000))
        == (0x2000_0000)) ? 1 : 0)
}

public func LL_DMA_EnableCSARUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) | (0x1000_0000))
}

public func LL_DMA_DisableCSARUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) & ~(0x1000_0000))
}

public func LL_DMA_IsEnabledCSARUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.cllr, channel: Channel) & (0x1000_0000))
        == (0x1000_0000)) ? 1 : 0)
}

public func LL_DMA_EnableCDARUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) | (0x8000000))
}

public func LL_DMA_DisableCDARUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) & ~(0x8000000))
}

public func LL_DMA_IsEnabledCDARUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.cllr, channel: Channel) & (0x8000000))
        == (0x8000000)) ? 1 : 0)
}

public func LL_DMA_EnableCTR3Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) | (0x4000000))
}

public func LL_DMA_DisableCTR3Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) & ~(0x4000000))
}

public func LL_DMA_IsEnabledCTR3Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.cllr, channel: Channel) & (0x4000000))
        == (0x4000000)) ? 1 : 0)
}

public func LL_DMA_EnableCBR2Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) | (0x2000000))
}

public func LL_DMA_DisableCBR2Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) & ~(0x2000000))
}

public func LL_DMA_IsEnabledCBR2Update<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.cllr, channel: Channel) & (0x2000000))
        == (0x2000000)) ? 1 : 0)
}

public func LL_DMA_EnableCLLRUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) | (0x10000))
}

public func LL_DMA_DisableCLLRUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.cllr, channel: Channel, value: registers.read(DMARegister.cllr, channel: Channel) & ~(0x10000))
}

public func LL_DMA_IsEnabledCLLRUpdate<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.cllr, channel: Channel) & (0x10000))
        == (0x10000)) ? 1 : 0)
}

public func LL_DMA_SetLinkedListAddrOffset<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ LinkedListAddrOffset: UInt32
) {

    registers.write(
        DMARegister.cllr, channel: Channel,
        value: (registers.read(DMARegister.cllr, channel: Channel) & ~(0xfffc)) | ((LinkedListAddrOffset & 0xfffc)))
}

public func LL_DMA_GetLinkedListAddrOffset<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.cllr, channel: Channel) & (0xfffc)) >> 0x2)
}

public func LL_DMA_GetFIFOLevel<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return ((registers.read(DMARegister.csr, channel: Channel) & (0xff0000)) >> 0x10)
}

public func LL_DMA_EnableChannelPrivilege<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    registers.write(
        DMARegister.privcfgr, channel: 0,
        value: registers.read(DMARegister.privcfgr, channel: 0) | ((0x1 << (Channel & 0x0000_000F))))
}

public func LL_DMA_DisableChannelPrivilege<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    registers.write(
        DMARegister.privcfgr, channel: 0,
        value: registers.read(DMARegister.privcfgr, channel: 0) & ~((0x1 << (Channel & 0x0000_000F))))
}

public func LL_DMA_IsEnabledChannelPrivilege<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    return
        (((registers.read(DMARegister.privcfgr, channel: 0) & ((0x1 << (Channel & 0x0000_000F))))
        == (0x1 << (Channel & 0x0000_000F))) ? 1 : 0)
}

public func LL_DMA_EnableChannelLockAttribute<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    registers.write(
        DMARegister.rcfglockr, channel: 0,
        value: registers.read(DMARegister.rcfglockr, channel: 0) | ((0x1 << (Channel & 0x0000_000F))))
}

public func LL_DMA_IsEnabledChannelLockAttribute<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32)
    -> UInt32
{
    return
        (((registers.read(DMARegister.rcfglockr, channel: 0) & ((0x1 << (Channel & 0x0000_000F))))
        == (0x1 << (Channel & 0x0000_000F))) ? 1 : 0)
}

public func LL_DMA_ClearFlag_TO<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.cfcr, channel: Channel, value: 0x4000)
}

public func LL_DMA_ClearFlag_SUSP<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.cfcr, channel: Channel, value: 0x2000)
}

public func LL_DMA_ClearFlag_USE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.cfcr, channel: Channel, value: 0x1000)
}

public func LL_DMA_ClearFlag_ULE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.cfcr, channel: Channel, value: 0x800)
}

public func LL_DMA_ClearFlag_DTE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.cfcr, channel: Channel, value: 0x400)
}

public func LL_DMA_ClearFlag_HT<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.cfcr, channel: Channel, value: 0x200)
}

public func LL_DMA_ClearFlag_TC<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(DMARegister.cfcr, channel: Channel, value: 0x100)
}

public func LL_DMA_IsActiveFlag_TO<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.csr, channel: Channel) & (0x4000))
        == (0x4000)) ? 1 : 0)
}

public func LL_DMA_IsActiveFlag_SUSP<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.csr, channel: Channel) & (0x2000))
        == (0x2000)) ? 1 : 0)
}

public func LL_DMA_IsActiveFlag_USE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.csr, channel: Channel) & (0x1000))
        == (0x1000)) ? 1 : 0)
}

public func LL_DMA_IsActiveFlag_ULE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.csr, channel: Channel) & (0x800))
        == (0x800)) ? 1 : 0)
}

public func LL_DMA_IsActiveFlag_DTE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.csr, channel: Channel) & (0x400))
        == (0x400)) ? 1 : 0)
}

public func LL_DMA_IsActiveFlag_HT<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.csr, channel: Channel) & (0x200))
        == (0x200)) ? 1 : 0)
}

public func LL_DMA_IsActiveFlag_TC<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.csr, channel: Channel) & (0x100))
        == (0x100)) ? 1 : 0)
}

public func LL_DMA_IsActiveFlag_IDLE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.csr, channel: Channel) & (0x1))
        == (0x1)) ? 1 : 0)
}

public func LL_DMA_IsActiveFlag_MIS<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    return
        (((registers.read(DMARegister.misr, channel: 0) & ((0x1 << (Channel & 0x0F))))
        == (0x1 << (Channel & 0x0F))) ? 1 : 0)
}

public func LL_DMA_EnableIT_TO<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x4000))
}

public func LL_DMA_EnableIT_SUSP<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x2000))
}

public func LL_DMA_EnableIT_USE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x1000))
}

public func LL_DMA_EnableIT_ULE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x800))
}

public func LL_DMA_EnableIT_DTE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x400))
}

public func LL_DMA_EnableIT_HT<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x200))
}

public func LL_DMA_EnableIT_TC<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) | (0x100))
}

public func LL_DMA_DisableIT_TO<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) & ~(0x4000))
}

public func LL_DMA_DisableIT_SUSP<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) & ~(0x2000))
}

public func LL_DMA_DisableIT_USE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) & ~(0x1000))
}

public func LL_DMA_DisableIT_ULE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) & ~(0x800))
}

public func LL_DMA_DisableIT_DTE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) & ~(0x400))
}

public func LL_DMA_DisableIT_HT<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) & ~(0x200))
}

public func LL_DMA_DisableIT_TC<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) {

    registers.write(
        DMARegister.ccr, channel: Channel, value: registers.read(DMARegister.ccr, channel: Channel) & ~(0x100))
}

public func LL_DMA_IsEnabledIT_TO<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x4000))
        == 0x4000) ? 1 : 0)
}

public func LL_DMA_IsEnabledIT_SUSP<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x2000))
        == 0x2000) ? 1 : 0)
}

public func LL_DMA_IsEnabledIT_USE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x1000))
        == 0x1000) ? 1 : 0)
}

public func LL_DMA_IsEnabledIT_ULE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x800))
        == 0x800) ? 1 : 0)
}

public func LL_DMA_IsEnabledIT_DTE<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x400))
        == 0x400) ? 1 : 0)
}

public func LL_DMA_IsEnabledIT_HT<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x200))
        == 0x200) ? 1 : 0)
}

public func LL_DMA_IsEnabledIT_TC<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    return
        (((registers.read(DMARegister.ccr, channel: Channel) & (0x100))
        == 0x100) ? 1 : 0)
}

public func LL_DMA_DeInit<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {

    let status: UInt32 = LLErrorStatus.success.rawValue

    if Channel == LL_DMA_CHANNEL_ALL {
        if registers.controller == .gpdma1 {
            LL_AHB1_GRP1_ForceReset(&registers, LL_AHB1_GRP1_PERIPH_GPDMA1)

            LL_AHB1_GRP1_ReleaseReset(&registers, LL_AHB1_GRP1_PERIPH_GPDMA1)
        } else {
            LL_AHB5_GRP1_ForceReset(&registers, LL_AHB5_GRP1_PERIPH_HPDMA1)

            LL_AHB5_GRP1_ReleaseReset(&registers, LL_AHB5_GRP1_PERIPH_HPDMA1)
        }
    } else {

        LL_DMA_SuspendChannel(&registers, Channel)

        LL_DMA_ResetChannel(&registers, Channel)

        registers.write(DMARegister.clbar, channel: Channel, value: 0)

        registers.write(DMARegister.ccr, channel: Channel, value: 0)

        registers.write(DMARegister.ctr1, channel: Channel, value: 0)

        registers.write(DMARegister.ctr2, channel: Channel, value: 0)

        registers.write(DMARegister.cbr1, channel: Channel, value: 0)

        registers.write(DMARegister.csar, channel: Channel, value: 0)

        registers.write(DMARegister.cdar, channel: Channel, value: 0)

        if ((Channel == 12 || Channel == 13 || Channel == 14 || Channel == 15) ? 1 : 0) != 0 {
            registers.write(DMARegister.ctr3, channel: Channel, value: 0)

            registers.write(DMARegister.cbr2, channel: Channel, value: 0)
        }

        registers.write(DMARegister.cllr, channel: Channel, value: 0)

        registers.write(DMARegister.cfcr, channel: Channel, value: 0x0000_3F00)

        LL_DMA_DisableChannelPrivilege(&registers, Channel)
    }
    return status
}

public func LL_DMA_Init<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DMA_InitStruct: inout LL_DMA_InitTypeDef
) -> UInt32 {

    if DMA_InitStruct.Direction != LL_DMA_DIRECTION_MEMORY_TO_MEMORY {
    }

    if DMA_InitStruct.Mode == LL_DMA_PFCTRL {
    }

    if (((registers.controller == .hpdma1 && Channel < 16) ? 1 : 0) != 0)
        || (((registers.controller == .gpdma1 && Channel < 16) ? 1 : 0) != 0)
    {

    }

    if DMA_InitStruct.TriggerPolarity != LL_DMA_TRIG_POLARITY_MASKED {

    }

    if ((Channel == 12 || Channel == 13 || Channel == 14 || Channel == 15) ? 1 : 0) != 0 {

    }

    LL_DMA_SetLinkedListBaseAddr(&registers, Channel, DMA_InitStruct.LinkedListBaseAddr)

    LL_DMA_ConfigControl(
        &registers, Channel, DMA_InitStruct.Priority | DMA_InitStruct.LinkAllocatedPort | DMA_InitStruct.LinkStepMode)

    LL_DMA_ConfigTransfer(
        &registers, Channel,
        DMA_InitStruct.DestAllocatedPort | DMA_InitStruct.DestWordExchange | DMA_InitStruct.DestHWordExchange
            | DMA_InitStruct.DestByteExchange | DMA_InitStruct.DestIncMode | DMA_InitStruct.DestDataWidth
            | DMA_InitStruct.SrcAllocatedPort | DMA_InitStruct.SrcByteExchange | DMA_InitStruct.DataAlignment
            | DMA_InitStruct.SrcIncMode | DMA_InitStruct.SrcDataWidth)
    if (((registers.controller == .hpdma1 && Channel < 16) ? 1 : 0) != 0)
        || (((registers.controller == .gpdma1 && Channel < 16) ? 1 : 0) != 0)
    {
        LL_DMA_ConfigBurstLength(&registers, Channel, DMA_InitStruct.SrcBurstLength, DMA_InitStruct.DestBurstLength)
    }

    LL_DMA_ConfigChannelTransfer(
        &registers, Channel,
        DMA_InitStruct.TransferEventMode | DMA_InitStruct.TriggerPolarity | DMA_InitStruct.BlkHWRequest
            | DMA_InitStruct.Mode | DMA_InitStruct.Direction)

    if DMA_InitStruct.Direction != LL_DMA_DIRECTION_MEMORY_TO_MEMORY {
        LL_DMA_SetPeriphRequest(&registers, Channel, DMA_InitStruct.Request)
    }

    if DMA_InitStruct.TriggerPolarity != LL_DMA_TRIG_POLARITY_MASKED {
        LL_DMA_SetHWTrigger(&registers, Channel, DMA_InitStruct.TriggerSelection)
        LL_DMA_SetTriggerMode(&registers, Channel, DMA_InitStruct.TriggerMode)
    }

    LL_DMA_SetBlkDataLength(&registers, Channel, DMA_InitStruct.BlkDataLength)

    if ((Channel == 12 || Channel == 13 || Channel == 14 || Channel == 15) ? 1 : 0) != 0 {
        LL_DMA_SetBlkRptCount(&registers, Channel, DMA_InitStruct.BlkRptCount)
        LL_DMA_ConfigBlkRptAddrUpdate(
            &registers, Channel,
            DMA_InitStruct.BlkRptSrcAddrUpdateMode | DMA_InitStruct.BlkRptDestAddrUpdateMode
                | DMA_InitStruct.SrcAddrUpdateMode | DMA_InitStruct.DestAddrUpdateMode)
    }

    LL_DMA_ConfigAddresses(&registers, Channel, DMA_InitStruct.SrcAddress, DMA_InitStruct.DestAddress)

    if ((Channel == 12 || Channel == 13 || Channel == 14 || Channel == 15) ? 1 : 0) != 0 {
        LL_DMA_ConfigAddrUpdateValue(&registers, Channel, DMA_InitStruct.SrcAddrOffset, DMA_InitStruct.DestAddrOffset)

        LL_DMA_ConfigBlkRptAddrUpdateValue(
            &registers, Channel, DMA_InitStruct.BlkRptSrcAddrOffset, DMA_InitStruct.BlkRptDestAddrOffset)
    }

    LL_DMA_SetLinkedListAddrOffset(&registers, Channel, DMA_InitStruct.LinkedListAddrOffset)
    return LLErrorStatus.success.rawValue
}

public func LL_DMA_StructInit(_ DMA_InitStruct: inout LL_DMA_InitTypeDef) {
    DMA_InitStruct.SrcAddress = 0x0000_0000
    DMA_InitStruct.DestAddress = 0x0000_0000
    DMA_InitStruct.Direction = LL_DMA_DIRECTION_MEMORY_TO_MEMORY
    DMA_InitStruct.BlkHWRequest = LL_DMA_HWREQUEST_SINGLEBURST
    DMA_InitStruct.DataAlignment = LL_DMA_DATA_ALIGN_ZEROPADD
    DMA_InitStruct.SrcBurstLength = 1
    DMA_InitStruct.DestBurstLength = 1
    DMA_InitStruct.SrcDataWidth = LL_DMA_SRC_DATAWIDTH_BYTE
    DMA_InitStruct.DestDataWidth = LL_DMA_DEST_DATAWIDTH_BYTE
    DMA_InitStruct.SrcIncMode = LL_DMA_SRC_FIXED
    DMA_InitStruct.DestIncMode = LL_DMA_DEST_FIXED
    DMA_InitStruct.Priority = LL_DMA_LOW_PRIORITY_LOW_WEIGHT
    DMA_InitStruct.BlkDataLength = 0x0000_0000
    DMA_InitStruct.Mode = LL_DMA_NORMAL
    DMA_InitStruct.BlkRptCount = 0x0000_0000
    DMA_InitStruct.TriggerMode = LL_DMA_TRIGM_BLK_TRANSFER
    DMA_InitStruct.TriggerPolarity = LL_DMA_TRIG_POLARITY_MASKED
    DMA_InitStruct.TriggerSelection = 0x0000_0000
    DMA_InitStruct.Request = 0x0000_0000
    DMA_InitStruct.TransferEventMode = LL_DMA_TCEM_BLK_TRANSFER
    DMA_InitStruct.DestWordExchange = LL_DMA_DEST_WORD_PRESERVE
    DMA_InitStruct.DestHWordExchange = LL_DMA_DEST_HALFWORD_PRESERVE
    DMA_InitStruct.DestByteExchange = LL_DMA_DEST_BYTE_PRESERVE
    DMA_InitStruct.SrcByteExchange = LL_DMA_SRC_BYTE_PRESERVE
    DMA_InitStruct.SrcAllocatedPort = LL_DMA_SRC_ALLOCATED_PORT0
    DMA_InitStruct.DestAllocatedPort = LL_DMA_DEST_ALLOCATED_PORT0
    DMA_InitStruct.LinkAllocatedPort = LL_DMA_LINK_ALLOCATED_PORT0
    DMA_InitStruct.LinkStepMode = LL_DMA_LSM_FULL_EXECUTION
    DMA_InitStruct.SrcAddrUpdateMode = LL_DMA_BURST_SRC_ADDR_INCREMENT
    DMA_InitStruct.DestAddrUpdateMode = LL_DMA_BURST_DEST_ADDR_INCREMENT
    DMA_InitStruct.SrcAddrOffset = 0x0000_0000
    DMA_InitStruct.DestAddrOffset = 0x0000_0000
    DMA_InitStruct.BlkRptSrcAddrUpdateMode = LL_DMA_BLKRPT_SRC_ADDR_INCREMENT
    DMA_InitStruct.BlkRptDestAddrUpdateMode = LL_DMA_BLKRPT_DEST_ADDR_INCREMENT
    DMA_InitStruct.BlkRptSrcAddrOffset = 0x0000_0000
    DMA_InitStruct.BlkRptDestAddrOffset = 0x0000_0000
    DMA_InitStruct.LinkedListBaseAddr = 0x0000_0000
    DMA_InitStruct.LinkedListAddrOffset = 0x0000_0000
}

public func LL_DMA_ListStructInit(_ DMA_InitLinkedListStruct: inout LL_DMA_InitLinkedListTypeDef) {
    DMA_InitLinkedListStruct.Priority = LL_DMA_LOW_PRIORITY_LOW_WEIGHT
    DMA_InitLinkedListStruct.LinkStepMode = LL_DMA_LSM_FULL_EXECUTION
    DMA_InitLinkedListStruct.TransferEventMode = LL_DMA_TCEM_LAST_LLITEM_TRANSFER
    DMA_InitLinkedListStruct.LinkAllocatedPort = LL_DMA_LINK_ALLOCATED_PORT0
}

public func LL_DMA_List_DeInit<IO: LLDMARegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    return LL_DMA_DeInit(&registers, Channel)
}

public func LL_DMA_List_Init<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ DMA_InitLinkedListStruct: inout LL_DMA_InitLinkedListTypeDef
) -> UInt32 {

    if (((registers.controller == .hpdma1 && Channel < 16) ? 1 : 0) != 0)
        || (((registers.controller == .gpdma1 && Channel < 16) ? 1 : 0) != 0)
    {
    }

    LL_DMA_ConfigControl(
        &registers, Channel,
        DMA_InitLinkedListStruct.Priority | DMA_InitLinkedListStruct.LinkAllocatedPort
            | DMA_InitLinkedListStruct.LinkStepMode)

    LL_DMA_SetTransferEventMode(&registers, Channel, DMA_InitLinkedListStruct.TransferEventMode)
    return LLErrorStatus.success.rawValue
}

public func LL_DMA_NodeStructInit(_ DMA_InitNodeStruct: inout LL_DMA_InitNodeTypeDef) {
    DMA_InitNodeStruct.DestAllocatedPort = LL_DMA_DEST_ALLOCATED_PORT0
    DMA_InitNodeStruct.DestWordExchange = LL_DMA_DEST_WORD_PRESERVE
    DMA_InitNodeStruct.DestHWordExchange = LL_DMA_DEST_HALFWORD_PRESERVE
    DMA_InitNodeStruct.DestByteExchange = LL_DMA_DEST_BYTE_PRESERVE
    DMA_InitNodeStruct.DestBurstLength = 1
    DMA_InitNodeStruct.DestIncMode = LL_DMA_DEST_FIXED
    DMA_InitNodeStruct.DestDataWidth = LL_DMA_DEST_DATAWIDTH_BYTE
    DMA_InitNodeStruct.SrcAllocatedPort = LL_DMA_SRC_ALLOCATED_PORT0
    DMA_InitNodeStruct.SrcByteExchange = LL_DMA_SRC_BYTE_PRESERVE
    DMA_InitNodeStruct.DataAlignment = LL_DMA_DATA_ALIGN_ZEROPADD
    DMA_InitNodeStruct.SrcBurstLength = 1
    DMA_InitNodeStruct.SrcIncMode = LL_DMA_SRC_FIXED
    DMA_InitNodeStruct.SrcDataWidth = LL_DMA_SRC_DATAWIDTH_BYTE
    DMA_InitNodeStruct.TransferEventMode = LL_DMA_TCEM_BLK_TRANSFER
    DMA_InitNodeStruct.TriggerPolarity = LL_DMA_TRIG_POLARITY_MASKED
    DMA_InitNodeStruct.TriggerSelection = 0x0000_0000
    DMA_InitNodeStruct.TriggerMode = LL_DMA_TRIGM_BLK_TRANSFER
    DMA_InitNodeStruct.BlkHWRequest = LL_DMA_HWREQUEST_SINGLEBURST
    DMA_InitNodeStruct.Direction = LL_DMA_DIRECTION_MEMORY_TO_MEMORY
    DMA_InitNodeStruct.Request = 0x0000_0000
    DMA_InitNodeStruct.Mode = LL_DMA_NORMAL
    DMA_InitNodeStruct.BlkRptDestAddrUpdateMode = LL_DMA_BLKRPT_DEST_ADDR_INCREMENT
    DMA_InitNodeStruct.BlkRptSrcAddrUpdateMode = LL_DMA_BLKRPT_SRC_ADDR_INCREMENT
    DMA_InitNodeStruct.DestAddrUpdateMode = LL_DMA_BURST_DEST_ADDR_INCREMENT
    DMA_InitNodeStruct.SrcAddrUpdateMode = LL_DMA_BURST_SRC_ADDR_INCREMENT
    DMA_InitNodeStruct.BlkRptCount = 0x0000_0000
    DMA_InitNodeStruct.BlkDataLength = 0x0000_0000
    DMA_InitNodeStruct.SrcAddress = 0x0000_0000
    DMA_InitNodeStruct.DestAddress = 0x0000_0000
    DMA_InitNodeStruct.DestAddrOffset = 0x0000_0000
    DMA_InitNodeStruct.SrcAddrOffset = 0x0000_0000
    DMA_InitNodeStruct.BlkRptDestAddrOffset = 0x0000_0000
    DMA_InitNodeStruct.BlkRptSrcAddrOffset = 0x0000_0000
    DMA_InitNodeStruct.UpdateRegisters =
        (LL_DMA_UPDATE_CTR1 | LL_DMA_UPDATE_CTR2 | LL_DMA_UPDATE_CBR1 | LL_DMA_UPDATE_CSAR | LL_DMA_UPDATE_CDAR
            | LL_DMA_UPDATE_CTR3 | LL_DMA_UPDATE_CBR2 | LL_DMA_UPDATE_CLLR)
    DMA_InitNodeStruct.NodeType = LL_DMA_GPDMA_LINEAR_NODE
}

public func LL_DMA_CreateLinkNode<Memory: DMAMemoryIO>(
    _ DMA_InitNodeStruct: LL_DMA_InitNodeTypeDef, _ pNode: LL_DMA_LinkNodeTypeDef<Memory>
) -> UInt32 {
    var reg_counter: UInt32 = 0

    if DMA_InitNodeStruct.Direction != LL_DMA_DIRECTION_MEMORY_TO_MEMORY {
    }

    if DMA_InitNodeStruct.TriggerPolarity != LL_DMA_TRIG_POLARITY_MASKED {

    }
    do {

    }

    if (DMA_InitNodeStruct.NodeType == LL_DMA_HPDMA_2D_NODE) || (DMA_InitNodeStruct.NodeType == LL_DMA_GPDMA_2D_NODE) {

    }

    if (DMA_InitNodeStruct.UpdateRegisters & LL_DMA_UPDATE_CTR1) == LL_DMA_UPDATE_CTR1 {
        pNode.LinkRegisters[Int(reg_counter)] =
            (DMA_InitNodeStruct.DestIncMode | DMA_InitNodeStruct.DestDataWidth | DMA_InitNodeStruct.DataAlignment
                | DMA_InitNodeStruct.SrcIncMode | DMA_InitNodeStruct.SrcDataWidth)

        pNode.LinkRegisters[Int(reg_counter)] |=
            (DMA_InitNodeStruct.DestAllocatedPort | DMA_InitNodeStruct.DestWordExchange
                | DMA_InitNodeStruct.DestHWordExchange | DMA_InitNodeStruct.DestByteExchange
                | ((DMA_InitNodeStruct.DestBurstLength &- 1) << 0x14) | DMA_InitNodeStruct.SrcAllocatedPort
                | DMA_InitNodeStruct.SrcByteExchange | ((DMA_InitNodeStruct.SrcBurstLength &- 1) << 0x4))

        reg_counter &+= 1
    }

    if (DMA_InitNodeStruct.UpdateRegisters & LL_DMA_UPDATE_CTR2) == LL_DMA_UPDATE_CTR2 {
        pNode.LinkRegisters[Int(reg_counter)] =
            (DMA_InitNodeStruct.TransferEventMode | DMA_InitNodeStruct.TriggerPolarity | DMA_InitNodeStruct.BlkHWRequest
                | DMA_InitNodeStruct.Mode | DMA_InitNodeStruct.Direction)

        if DMA_InitNodeStruct.Direction != LL_DMA_DIRECTION_MEMORY_TO_MEMORY {
            pNode.LinkRegisters[Int(reg_counter)] |= DMA_InitNodeStruct.Request & 0x7f
        }

        if DMA_InitNodeStruct.TriggerPolarity != LL_DMA_TRIG_POLARITY_MASKED {
            pNode.LinkRegisters[Int(reg_counter)] |=
                (((DMA_InitNodeStruct.TriggerSelection << 0x10) & 0x3f0000) | DMA_InitNodeStruct.TriggerMode)
        }

        reg_counter &+= 1
    }

    if (DMA_InitNodeStruct.UpdateRegisters & LL_DMA_UPDATE_CBR1) == LL_DMA_UPDATE_CBR1 {
        pNode.LinkRegisters[Int(reg_counter)] = DMA_InitNodeStruct.BlkDataLength

        if (DMA_InitNodeStruct.NodeType == LL_DMA_HPDMA_2D_NODE)
            || (DMA_InitNodeStruct.NodeType == LL_DMA_GPDMA_2D_NODE)
        {
            pNode.LinkRegisters[Int(reg_counter)] |=
                (DMA_InitNodeStruct.BlkRptDestAddrUpdateMode | DMA_InitNodeStruct.BlkRptSrcAddrUpdateMode
                    | DMA_InitNodeStruct.DestAddrUpdateMode | DMA_InitNodeStruct.SrcAddrUpdateMode
                    | ((DMA_InitNodeStruct.BlkRptCount << 0x10) & 0x7ff0000))
        }

        reg_counter &+= 1
    }

    if (DMA_InitNodeStruct.UpdateRegisters & LL_DMA_UPDATE_CSAR) == LL_DMA_UPDATE_CSAR {
        pNode.LinkRegisters[Int(reg_counter)] = DMA_InitNodeStruct.SrcAddress

        reg_counter &+= 1
    }

    if (DMA_InitNodeStruct.UpdateRegisters & LL_DMA_UPDATE_CDAR) == LL_DMA_UPDATE_CDAR {
        pNode.LinkRegisters[Int(reg_counter)] = DMA_InitNodeStruct.DestAddress

        reg_counter &+= 1
    }

    if (DMA_InitNodeStruct.NodeType == LL_DMA_HPDMA_2D_NODE) || (DMA_InitNodeStruct.NodeType == LL_DMA_GPDMA_2D_NODE) {
        if (DMA_InitNodeStruct.UpdateRegisters & LL_DMA_UPDATE_CTR3) == LL_DMA_UPDATE_CTR3 {
            pNode.LinkRegisters[Int(reg_counter)] =
                (DMA_InitNodeStruct.SrcAddrOffset | ((DMA_InitNodeStruct.DestAddrOffset << 0x10) & 0x1fff_0000))

            reg_counter &+= 1
        }
    }

    if (DMA_InitNodeStruct.NodeType == LL_DMA_HPDMA_2D_NODE) || (DMA_InitNodeStruct.NodeType == LL_DMA_GPDMA_2D_NODE) {
        if (DMA_InitNodeStruct.UpdateRegisters & LL_DMA_UPDATE_CBR2) == LL_DMA_UPDATE_CBR2 {
            pNode.LinkRegisters[Int(reg_counter)] =
                (DMA_InitNodeStruct.BlkRptSrcAddrOffset
                    | ((DMA_InitNodeStruct.BlkRptDestAddrOffset << 0x10) & 0xffff_0000))

            reg_counter &+= 1
        }
    }

    if (DMA_InitNodeStruct.UpdateRegisters & LL_DMA_UPDATE_CLLR) == LL_DMA_UPDATE_CLLR {
        pNode.LinkRegisters[Int(reg_counter)] =
            ((DMA_InitNodeStruct.UpdateRegisters
                & (0x8000_0000 | 0x4000_0000 | 0x2000_0000 | 0x1000_0000 | 0x8000000 | 0x10000)))

        if (DMA_InitNodeStruct.NodeType == LL_DMA_HPDMA_2D_NODE)
            || (DMA_InitNodeStruct.NodeType == LL_DMA_GPDMA_2D_NODE)
        {
            pNode.LinkRegisters[Int(reg_counter)] |= (DMA_InitNodeStruct.UpdateRegisters & (0x4000000 | 0x2000000))
        }
    } else {
        pNode.LinkRegisters[Int(reg_counter)] = 0
    }
    return LLErrorStatus.success.rawValue
}

public func LL_DMA_ConnectLinkNode<Memory: DMAMemoryIO>(
    _ pPrevLinkNode: LL_DMA_LinkNodeTypeDef<Memory>, _ PrevNodeCLLRIdx: UInt32,
    _ pNewLinkNode: LL_DMA_LinkNodeTypeDef<Memory>, _ NewNodeCLLRIdx: UInt32
) {
    pPrevLinkNode.LinkRegisters[Int(PrevNodeCLLRIdx)] =
        ((pNewLinkNode.address & 0xfffc)
            | (pNewLinkNode.LinkRegisters[Int(NewNodeCLLRIdx)]
                & (0x8000_0000 | 0x4000_0000 | 0x2000_0000 | 0x1000_0000 | 0x8000000 | 0x4000000 | 0x2000000 | 0x10000)))
}

public func LL_DMA_DisconnectNextLinkNode<Memory: DMAMemoryIO>(
    _ pLinkNode: LL_DMA_LinkNodeTypeDef<Memory>, _ LinkNodeCLLRIdx: UInt32
) {
    pLinkNode.LinkRegisters[Int(LinkNodeCLLRIdx)] = 0
}

public let LL_DMA_CH_OFFSET_TAB: InlineArray<16, UInt32> = [
    0x50, 0xD0, 0x150, 0x1D0, 0x250, 0x2D0, 0x350, 0x3D0,
    0x450, 0x4D0, 0x550, 0x5D0, 0x650, 0x6D0, 0x750, 0x7D0,
]

public func LL_DMA_WriteReg<IO: LLDMARegisterIO>(
    _ registers: inout IO, _ register: DMARegister, _ value: UInt32, channel: UInt32 = 0
) {
    registers.write(register, channel: channel, value: value)
}
public func LL_DMA_ReadReg<IO: LLDMARegisterIO>(_ registers: inout IO, _ register: DMARegister, channel: UInt32 = 0)
    -> UInt32
{
    registers.read(register, channel: channel)
}

// Pointer-conversion macros accept target bus addresses, including their C fallback cases.
public func LL_DMA_GET_INSTANCE(_ channelAddress: UInt32) -> UInt32 {
    channelAddress > 0x4002_17D0 ? 0x5200_0000 : 0x4002_1000
}
public func LL_DMA_GET_CHANNEL(_ channelAddress: UInt32) -> UInt32 {
    for channel in 0..<15 {
        let offset = LL_DMA_CH_OFFSET_TAB[channel]
        if channelAddress == 0x5200_0000 &+ offset || channelAddress == 0x4002_1000 &+ offset { return UInt32(channel) }
    }
    return LL_DMA_CHANNEL_15
}
public func LL_DMA_GET_CHANNEL_INSTANCE(_ controllerAddress: UInt32, _ channel: UInt32) -> UInt32 {
    if channel < 16 && (controllerAddress == 0x5200_0000 || controllerAddress == 0x4002_1000) {
        return controllerAddress &+ LL_DMA_CH_OFFSET_TAB[Int(channel)]
    }
    return 0x4002_17D0
}
