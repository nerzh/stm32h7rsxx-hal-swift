// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

typedef struct
{
  __IO uint32_t GOTGCTL;             /*!< USB_OTG Control and Status Register,       Address offset: 000h */
  __IO uint32_t GOTGINT;             /*!< USB_OTG Interrupt Register,                Address offset: 004h */
  __IO uint32_t GAHBCFG;             /*!< Core AHB Configuration Register,           Address offset: 008h */
  __IO uint32_t GUSBCFG;             /*!< Core USB Configuration Register,           Address offset: 00Ch */
  __IO uint32_t GRSTCTL;             /*!< Core Reset Register,                       Address offset: 010h */
  __IO uint32_t GINTSTS;             /*!< Core Interrupt Register,                   Address offset: 014h */
  __IO uint32_t GINTMSK;             /*!< Core Interrupt Mask Register,              Address offset: 018h */
  __IO uint32_t GRXSTSR;             /*!< Receive Sts Q Read Register,               Address offset: 01Ch */
  __IO uint32_t GRXSTSP;             /*!< Receive Sts Q Read & POP Register,         Address offset: 020h */
  __IO uint32_t GRXFSIZ;             /*!< Receive FIFO Size Register,                Address offset: 024h */
  __IO uint32_t DIEPTXF0_HNPTXFSIZ;  /*!< EP0 / Non Periodic Tx FIFO Size Register,  Address offset: 028h */
  __IO uint32_t HNPTXSTS;            /*!< Non Periodic Tx FIFO/Queue Sts reg,        Address offset: 02Ch */
  __IO uint32_t Reserved30[2];       /*!< Reserved,                                  Address offset: 030h */
  __IO uint32_t GCCFG;               /*!< General Purpose IO Register,               Address offset: 038h */
  __IO uint32_t CID;                 /*!< User ID Register,                          Address offset: 03Ch */
  __IO uint32_t GSNPSID;             /*!< USB_OTG core ID,                           Address offset: 040h */
  __IO uint32_t GHWCFG1;             /*!< User HW config1,                           Address offset: 044h */
  __IO uint32_t GHWCFG2;             /*!< User HW config2,                           Address offset: 048h */
  __IO uint32_t GHWCFG3;             /*!< User HW config3,                           Address offset: 04Ch */
  __IO uint32_t  Reserved6;          /*!< Reserved,                                  Address offset: 050h */
  __IO uint32_t GLPMCFG;             /*!< LPM Register,                              Address offset: 054h */
  __IO uint32_t GPWRDN;              /*!< Power Down Register,                       Address offset: 058h */
  __IO uint32_t GDFIFOCFG;           /*!< DFIFO Software Config Register,            Address offset: 05Ch */
  __IO uint32_t GADPCTL;             /*!< ADP Timer, Control and Status Register,    Address offset: 60Ch */
  __IO uint32_t  Reserved43[39];     /*!< Reserved,                                  Address offset: 058h */
  __IO uint32_t HPTXFSIZ;            /*!< Host Periodic Tx FIFO Size Reg,            Address offset: 100h */
  __IO uint32_t DIEPTXF[0x0F];       /*!< dev Periodic Transmit FIFO                 Address offset: 104h */
} USB_OTG_GlobalTypeDef;

typedef struct
{
  __IO uint32_t DCFG;                /*!< dev Configuration Register,   Address offset: 800h */
  __IO uint32_t DCTL;                /*!< dev Control Register,         Address offset: 804h */
  __IO uint32_t DSTS;                /*!< dev Status Register (RO),     Address offset: 808h */
  uint32_t Reserved0C;               /*!< Reserved,                     Address offset: 80Ch */
  __IO uint32_t DIEPMSK;             /*!< dev IN Endpoint Mask,         Address offset: 810h */
  __IO uint32_t DOEPMSK;             /*!< dev OUT Endpoint Mask,        Address offset: 814h */
  __IO uint32_t DAINT;               /*!< dev All Endpoints Itr Reg,    Address offset: 818h */
  __IO uint32_t DAINTMSK;            /*!< dev All Endpoints Itr Mask,   Address offset: 81Ch */
  uint32_t  Reserved20;              /*!< Reserved,                     Address offset: 820h */
  uint32_t Reserved9;                /*!< Reserved,                     Address offset: 824h */
  __IO uint32_t DVBUSDIS;            /*!< dev VBUS discharge Register,  Address offset: 828h */
  __IO uint32_t DVBUSPULSE;          /*!< dev VBUS Pulse Register,      Address offset: 82Ch */
  __IO uint32_t DTHRCTL;             /*!< dev threshold,                Address offset: 830h */
  __IO uint32_t DIEPEMPMSK;          /*!< dev empty msk,                Address offset: 834h */
  __IO uint32_t DEACHINT;            /*!< dedicated EP interrupt,       Address offset: 838h */
  __IO uint32_t DEACHMSK;            /*!< dedicated EP msk,             Address offset: 83Ch */
  uint32_t Reserved40;               /*!< dedicated EP mask,            Address offset: 840h */
  __IO uint32_t DINEP1MSK;           /*!< dedicated EP mask,            Address offset: 844h */
  uint32_t  Reserved44[15];          /*!< Reserved,                     Address offset: 844-87Ch */
  __IO uint32_t DOUTEP1MSK;          /*!< dedicated EP msk,             Address offset: 884h */
} USB_OTG_DeviceTypeDef;

typedef struct
{
  __IO uint32_t DIEPCTL;             /*!< dev IN Endpoint Control Register,          Address offset: 900h + (ep_num * 20h) + 00h */
  __IO uint32_t Reserved04;          /*!< Reserved,                                  Address offset: 900h + (ep_num * 20h) + 04h */
  __IO uint32_t DIEPINT;             /*!< dev IN Endpoint Itr Register,              Address offset: 900h + (ep_num * 20h) + 08h */
  __IO uint32_t Reserved0C;          /*!< Reserved,                                  Address offset: 900h + (ep_num * 20h) + 0Ch */
  __IO uint32_t DIEPTSIZ;            /*!< IN Endpoint Txfer Size Register,           Address offset: 900h + (ep_num * 20h) + 10h */
  __IO uint32_t DIEPDMA;             /*!< IN Endpoint DMA Address Register,          Address offset: 900h + (ep_num * 20h) + 14h */
  __IO uint32_t DTXFSTS;             /*!< IN Endpoint Tx FIFO Status Register,       Address offset: 900h + (ep_num * 20h) + 18h */
  __IO uint32_t Reserved18;          /*!< Reserved,                                  Address offset: 900h + (ep_num * 20h) + 1Ch */
} USB_OTG_INEndpointTypeDef;

typedef struct
{
  __IO uint32_t DOEPCTL;             /*!< dev OUT Endpoint Control Register,         Address offset: B00h + (ep_num * 20h) + 00h */
  __IO uint32_t Reserved04;          /*!< Reserved,                                  Address offset: B00h + (ep_num * 20h) + 04h */
  __IO uint32_t DOEPINT;             /*!< dev OUT Endpoint Itr Register,             Address offset: B00h + (ep_num * 20h) + 08h */
  __IO uint32_t Reserved0C;          /*!< Reserved,                                  Address offset: B00h + (ep_num * 20h) + 0Ch */
  __IO uint32_t DOEPTSIZ;            /*!< dev OUT Endpoint Txfer Size Register,      Address offset: B00h + (ep_num * 20h) + 10h */
  __IO uint32_t DOEPDMA;             /*!< dev OUT Endpoint DMA Address Register,     Address offset: B00h + (ep_num * 20h) + 14h */
  __IO uint32_t Reserved18[2];       /*!< Reserved,                                  Address offset: B00h + (ep_num * 20h) + 18h */
} USB_OTG_OUTEndpointTypeDef;

typedef struct
{
  __IO uint32_t HCFG;                 /*!< Host Configuration Register,              Address offset: 400h */
  __IO uint32_t HFIR;                 /*!< Host Frame Interval Register,             Address offset: 404h */
  __IO uint32_t HFNUM;                /*!< Host Frame Nbr/Frame Remaining,           Address offset: 408h */
  uint32_t Reserved40C;               /*!< Reserved,                                 Address offset: 40Ch */
  __IO uint32_t HPTXSTS;              /*!< Host Periodic Tx FIFO/ Queue Status,      Address offset: 410h */
  __IO uint32_t HAINT;                /*!< Host All Channels Interrupt Register,     Address offset: 414h */
  __IO uint32_t HAINTMSK;             /*!< Host All Channels Interrupt Mask,         Address offset: 418h */
} USB_OTG_HostTypeDef;

typedef struct
{
  __IO uint32_t HCCHAR;               /*!< Host Channel Characteristics Register,    Address offset: 500h */
  __IO uint32_t HCSPLT;               /*!< Host Channel Split Control Register,      Address offset: 504h */
  __IO uint32_t HCINT;                /*!< Host Channel Interrupt Register,          Address offset: 508h */
  __IO uint32_t HCINTMSK;             /*!< Host Channel Interrupt Mask Register,     Address offset: 50Ch */
  __IO uint32_t HCTSIZ;               /*!< Host Channel Transfer Size Register,      Address offset: 510h */
  __IO uint32_t HCDMA;                /*!< Host Channel DMA Address Register,        Address offset: 514h */
  uint32_t Reserved[2];               /*!< Reserved,                                 Address offset: 518h */
} USB_OTG_HostChannelTypeDef;
