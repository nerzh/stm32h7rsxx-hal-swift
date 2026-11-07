/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
 * Exact declarations/macros/function source from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_CORDIC_DMA_REFERENCE_TYPES_H
#define C_CORDIC_DMA_REFERENCE_TYPES_H
#include <stdint.h>
#define __IO volatile
typedef enum
{
  HAL_OK       = 0x00,
  HAL_ERROR    = 0x01,
  HAL_BUSY     = 0x02,
  HAL_TIMEOUT  = 0x03
} HAL_StatusTypeDef;
typedef enum
{
  HAL_UNLOCKED = 0x00,
  HAL_LOCKED   = 0x01
} HAL_LockTypeDef;
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS device source at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
typedef struct
{
       uint32_t RESERVED1;     /*!< Reserved 1,                                      Address offset: 0x00 */
  __IO uint32_t PRIVCFGR;      /*!< DMA privileged configuration register,           Address offset: 0x04 */
  __IO uint32_t RCFGLOCKR;     /*!< DMA configuration lock register,                 Address offset: 0x08 */
  __IO uint32_t MISR;          /*!< DMA masked interrupt status register,            Address offset: 0x0C */
} DMA_TypeDef;
typedef struct
{
  __IO uint32_t CLBAR;         /*!< DMA channel x linked-list base address register, Address offset: 0x50 + (x * 0x80) */
       uint32_t RESERVED1[2];  /*!< Reserved 1,                                      Address offset: 0x54 -- 0x58      */
  __IO uint32_t CFCR;          /*!< DMA channel x flag clear register,               Address offset: 0x5C + (x * 0x80) */
  __IO uint32_t CSR;           /*!< DMA channel x flag status register,              Address offset: 0x60 + (x * 0x80) */
  __IO uint32_t CCR;           /*!< DMA channel x control register,                  Address offset: 0x64 + (x * 0x80) */
       uint32_t RESERVED2[10]; /*!< Reserved 2,                                      Address offset: 0x68 -- 0x8C      */
  __IO uint32_t CTR1;          /*!< DMA channel x transfer register 1,               Address offset: 0x90 + (x * 0x80) */
  __IO uint32_t CTR2;          /*!< DMA channel x transfer register 2,               Address offset: 0x94 + (x * 0x80) */
  __IO uint32_t CBR1;          /*!< DMA channel x block register 1,                  Address offset: 0x98 + (x * 0x80) */
  __IO uint32_t CSAR;          /*!< DMA channel x source address register,           Address offset: 0x9C + (x * 0x80) */
  __IO uint32_t CDAR;          /*!< DMA channel x destination address register,      Address offset: 0xA0 + (x * 0x80) */
  __IO uint32_t CTR3;          /*!< DMA channel x transfer register 3,               Address offset: 0xA4 + (x * 0x80) */
  __IO uint32_t CBR2;          /*!< DMA channel x block register 2,                  Address offset: 0xA8 + (x * 0x80) */
       uint32_t RESERVED3[8];  /*!< Reserved 3,                                      Address offset: 0xAC -- 0xC8      */
  __IO uint32_t CLLR;          /*!< DMA channel x linked-list address register,      Address offset: 0xCC + (x * 0x80) */
} DMA_Channel_TypeDef;
typedef struct
{
  uint32_t Request;               /*!< Specifies the DMA channel request.
                                       This parameter can be a value of @ref DMA_Request_Selection                    */

  uint32_t BlkHWRequest;          /*!< Specifies the Block hardware request mode for DMA channel.
                                       Block Hardware request feature can be used only with dedicated peripherals.
                                       This parameter can be a value of @ref DMA_Block_Request                        */

  uint32_t Direction;             /*!< Specifies the transfer direction for DMA channel.
                                       This parameter can be a value of @ref DMA_Transfer_Direction                   */

  uint32_t SrcInc;                /*!< Specifies the source increment mode for the DMA channel.
                                       This parameter can be a value of @ref DMA_Source_Increment_Mode                */

  uint32_t DestInc;               /*!< Specifies the destination increment mode for the DMA channel.
                                       This parameter can be a value of @ref DMA_Destination_Increment_Mode           */

  uint32_t SrcDataWidth;          /*!< Specifies the source data width for the DMA channel.
                                       This parameter can be a value of @ref DMA_Source_Data_Width                    */

  uint32_t DestDataWidth;         /*!< Specifies the destination data width for the DMA channel.
                                       This parameter can be a value of @ref DMA_Destination_Data_Width               */

  uint32_t Priority;              /*!< Specifies the priority level for the DMA channel.
                                       This parameter can be a value of @ref DMA_Priority_Level                       */

  uint32_t SrcBurstLength;        /*!< Specifies the source burst length (number of beats within a burst) for the DMA
                                       channel.
                                       This parameter can be a value between 1 and 64                                 */

  uint32_t DestBurstLength;       /*!< Specifies the destination burst length (number of beats within a burst) for the
                                       DMA channel.
                                       This parameter can be a value between 1 and 64                                 */

  uint32_t TransferAllocatedPort; /*!< Specifies the transfer allocated ports.
                                       This parameter can be a combination of @ref DMA_Transfer_Allocated_Port        */

  uint32_t TransferEventMode;     /*!< Specifies the transfer event mode for the DMA channel.
                                       This parameter can be a value of @ref DMA_Transfer_Event_Mode                  */

  uint32_t Mode;                  /*!< Specifies the transfer mode for the DMA channel.
                                       This parameter can be a value of @ref DMA_Transfer_Mode                        */

} DMA_InitTypeDef;
typedef struct
{
  uint32_t Priority;          /*!< Specifies the priority level for the DMA channel.
                                   This parameter can be a value of @ref DMA_Priority_Level        */

  uint32_t LinkStepMode;      /*!< Specifies the link step mode for the DMA channel.
                                   This parameter can be a value of @ref DMAEx_Link_Step_Mode      */

  uint32_t LinkAllocatedPort; /*!< Specifies the linked-list allocated port for the DMA channel.
                                   This parameter can be a value of @ref DMAEx_Link_Allocated_Port */

  uint32_t TransferEventMode; /*!< Specifies the transfer event mode for the DMA channel.
                                   This parameter can be a value of @ref DMA_Transfer_Event_Mode   */

  uint32_t LinkedListMode;    /*!< Specifies linked-list transfer mode for the DMA channel.
                                   This parameter can be a value of @ref DMAEx_LinkedList_Mode     */

} DMA_InitLinkedListTypeDef;
typedef enum
{
  HAL_DMA_STATE_RESET   = 0x00U, /*!< DMA not yet initialized or disabled */
  HAL_DMA_STATE_READY   = 0x01U, /*!< DMA initialized and ready for use   */
  HAL_DMA_STATE_BUSY    = 0x02U, /*!< DMA process is ongoing              */
  HAL_DMA_STATE_ERROR   = 0x03U, /*!< DMA error state                     */
  HAL_DMA_STATE_ABORT   = 0x04U, /*!< DMA Abort state                     */
  HAL_DMA_STATE_SUSPEND = 0x05U, /*!< DMA Suspend state                   */

} HAL_DMA_StateTypeDef;
typedef enum
{
  HAL_DMA_FULL_TRANSFER = 0x00U, /*!< Full channel transfer */
  HAL_DMA_HALF_TRANSFER = 0x01U, /*!< Half channel transfer */

} HAL_DMA_LevelCompleteTypeDef;
typedef enum
{
  HAL_DMA_XFER_CPLT_CB_ID     = 0x00U, /*!< Complete transfer callback ID      */
  HAL_DMA_XFER_HALFCPLT_CB_ID = 0x01U, /*!< Half complete transfer callback ID */
  HAL_DMA_XFER_ERROR_CB_ID    = 0x02U, /*!< Error transfer callback ID         */
  HAL_DMA_XFER_ABORT_CB_ID    = 0x03U, /*!< Abort transfer callback ID         */
  HAL_DMA_XFER_SUSPEND_CB_ID  = 0x04U, /*!< Suspend transfer callback ID       */
  HAL_DMA_XFER_ALL_CB_ID      = 0x05U  /*!< All callback ID                    */

} HAL_DMA_CallbackIDTypeDef;
typedef struct __DMA_HandleTypeDef
{
  DMA_Channel_TypeDef       *Instance;                             /*!< Register the DMA channel base address   */

  DMA_InitTypeDef           Init;                                  /*!< DMA channel init parameters             */

  DMA_InitLinkedListTypeDef InitLinkedList;                        /*!< DMA channel linked-list init parameters */

  HAL_LockTypeDef           Lock;                                  /*!< DMA locking object                      */

  uint32_t                  Mode;                                  /*!< DMA transfer mode                       */

  __IO HAL_DMA_StateTypeDef State;                                 /*!< DMA transfer state                      */

  __IO uint32_t             ErrorCode;                             /*!< DMA error code                          */

  void                      *Parent;                               /*!< Parent object state                     */

  void (* XferCpltCallback)(struct __DMA_HandleTypeDef *hdma);     /*!< DMA transfer complete callback          */

  void (* XferHalfCpltCallback)(struct __DMA_HandleTypeDef *hdma); /*!< DMA half transfer complete callback     */

  void (* XferErrorCallback)(struct __DMA_HandleTypeDef *hdma);    /*!< DMA transfer error callback             */

  void (* XferAbortCallback)(struct __DMA_HandleTypeDef *hdma);    /*!< DMA transfer Abort callback             */

  void (* XferSuspendCallback)(struct __DMA_HandleTypeDef *hdma);  /*!< DMA transfer Suspend callback           */

  struct __DMA_QListTypeDef  *LinkedListQueue;                     /*!< DMA linked-list queue                   */

} DMA_HandleTypeDef;
#endif
