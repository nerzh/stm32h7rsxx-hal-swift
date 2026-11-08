// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Explicitly corrected RPMB oracle derived from HAL revision
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// Only the three marked scratch-pointer resets differ from the original bodies.
// Upstream/MMCFunctions.inc remains the unchanged baseline for defined paths.
#include "MMCInternal.h"
#define F_VARIANT CMMCCorrected
#include "MMCShim.h"
#include "MMCPrototypes.h"
HAL_StatusTypeDef CMMC_RPMB_WriteBlocksCorrected(MMC_HandleTypeDef *hmmc, const uint8_t *pData, uint16_t BlockAdd,
                                           uint16_t NumberOfBlocks, const uint8_t *pMAC, uint32_t Timeout)
{

  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t tickstart = HAL_GetTick();
  uint32_t count;
  uint32_t byte_count = 0;
  uint32_t data;
  uint32_t dataremaining;
  uint8_t tail_pack[12] = {0};
  uint8_t zero_pack[4] = {0};
  uint8_t echo_nonce[16] = {0};
  const uint8_t local_nonce[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x00, 0x01, 0x02,
                                   0x03, 0x04, 0x00, 0x01, 0x02, 0x03, 0x04, 0x08
                                  };
  const uint8_t *rtempbuff;
  uint8_t  *tempbuff;
  uint32_t arg = 0x80000000U;
  uint32_t offset = 0;

  if ((NumberOfBlocks != 0x1U) && (NumberOfBlocks != 0x2U) && (NumberOfBlocks != 0x20U))
  {
    hmmc->ErrorCode |= HAL_MMC_ERROR_PARAM;
    return HAL_ERROR;
  }

  if ((NULL == pData) || (NULL == pMAC))
  {
    hmmc->ErrorCode |= HAL_MMC_ERROR_PARAM;
    return HAL_ERROR;
  }

  tail_pack[11] = 0x02;

  if (hmmc->State == HAL_MMC_STATE_READY)
  {
    hmmc->ErrorCode = HAL_MMC_ERROR_NONE;
    hmmc->State = HAL_MMC_STATE_BUSY;

    /* Initialize data control register */
    hmmc->Instance->DCTRL = 0U;

    errorstate = SDMMC_CmdBlockCount(hmmc->Instance,  0x00000001U);
    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Send Request Packet */

    /* Configure the MMC DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = MMC_BLOCKSIZE;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_CARD;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hmmc->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hmmc->Instance);

    /* Write Blocks in Polling mode */
    hmmc->Context = MMC_CONTEXT_WRITE_MULTIPLE_BLOCK;

    /* Write Multi Block command */
    errorstate = SDMMC_CmdWriteMultiBlock(hmmc->Instance, 0);

    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Write block(s) in polling mode */
    rtempbuff = zero_pack;
    dataremaining = config.DataLength;
    while (!__HAL_MMC_GET_FLAG(hmmc,
                               SDMMC_FLAG_TXUNDERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DATAEND))
    {
      if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_TXFIFOHE) && (dataremaining >= SDMMC_FIFO_SIZE))
      {

        /* Write data to SDMMC Tx FIFO */
        for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
        {
          data = (uint32_t)(*rtempbuff);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 8U);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 16U);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 24U);
          rtempbuff++;
          byte_count++;
          (void)SDMMC_WriteFIFO(hmmc->Instance, &data);
          if (byte_count < MMC_RPMB_NONCE_POSITION)
          {
            rtempbuff = zero_pack;
          }
          else if (byte_count == MMC_RPMB_NONCE_POSITION)
          {
            rtempbuff = local_nonce;
          }
          else if (byte_count == MMC_RPMB_WRITE_COUNTER_POSITION)
          {
            rtempbuff = tail_pack;
          }
          else
          {
            /* Nothing to do */
          }
        }
        dataremaining -= SDMMC_FIFO_SIZE;
      }

      if (((HAL_GetTick() - tickstart) >=  Timeout) || (Timeout == 0U))
      {
        /* Clear all the static flags */
        __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
        hmmc->ErrorCode |= errorstate;
        hmmc->State = HAL_MMC_STATE_READY;
        return HAL_TIMEOUT;
      }
    }
    __SDMMC_CMDTRANS_DISABLE(hmmc->Instance);

    /* Read Response Packt */
    errorstate = SDMMC_CmdBlockCount(hmmc->Instance,  0x00000001);
    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Configure the MMC DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = MMC_BLOCKSIZE;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hmmc->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hmmc->Instance);

    /* Write Blocks in Polling mode */
    hmmc->Context = MMC_CONTEXT_READ_MULTIPLE_BLOCK;

    /* Write Multi Block command */
    errorstate = SDMMC_CmdReadMultiBlock(hmmc->Instance, 0);

    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Clear all the static flags */
    __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_DATA_FLAGS);
    /* Poll on SDMMC flags */
    tempbuff = zero_pack;

    byte_count = 0;
    dataremaining = config.DataLength;
    while (!__HAL_MMC_GET_FLAG(hmmc,
                               SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DATAEND))
    {
      if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_RXFIFOHF) && (dataremaining >= SDMMC_FIFO_SIZE))
      {
        /* Read data from SDMMC Rx FIFO */
        for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
        {
          data = SDMMC_ReadFIFO(hmmc->Instance);
          *tempbuff = (uint8_t)(data & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 8U) & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 16U) & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 24U) & 0xFFU);
          tempbuff++;
          byte_count++;
          if (byte_count < MMC_RPMB_NONCE_POSITION)
          {
            tempbuff = zero_pack;
          }
          else if (byte_count == MMC_RPMB_NONCE_POSITION)
          {
            tempbuff = echo_nonce;
          }
          else if (byte_count == MMC_RPMB_WRITE_COUNTER_POSITION)
          {
            tempbuff = tail_pack;
          }
          else
          {
            /* Nothing to do */
          }
        }
        dataremaining -= SDMMC_FIFO_SIZE;
      }

      if (((HAL_GetTick() - tickstart) >=  Timeout) || (Timeout == 0U))
      {
        /* Clear all the static flags */
        __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
        hmmc->ErrorCode |= HAL_MMC_ERROR_TIMEOUT;
        hmmc->State = HAL_MMC_STATE_READY;
        return HAL_TIMEOUT;
      }
    }
    __SDMMC_CMDTRANS_DISABLE(hmmc->Instance);

    /* Get error state */
    if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_DTIMEOUT))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_DATA_TIMEOUT;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_DCRCFAIL))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_DATA_CRC_FAIL;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_TXUNDERR))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_TX_UNDERRUN;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else
    {
      /* Nothing to do */
    }

    /* Clear all the static flags */
    __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_DATA_FLAGS);

    hmmc->State = HAL_MMC_STATE_READY;

    for (uint8_t i = 0; i < 16U; i++)
    {
      if (local_nonce[i] != echo_nonce[i])
      {
        return HAL_ERROR;
      }
    }
  }
  else
  {
    hmmc->ErrorCode |= HAL_MMC_ERROR_BUSY;
    return HAL_ERROR;
  }
  tail_pack[11]  = 0x03;
  tail_pack[10]  = 0x00;
  tail_pack[7]   = (uint8_t)(NumberOfBlocks) & 0xFFU;
  tail_pack[6]   = (uint8_t)(NumberOfBlocks >> 8) & 0xFFU;
  tail_pack[5]   = (uint8_t)(BlockAdd) & 0xFFU;
  tail_pack[4]   = (uint8_t)(BlockAdd >> 8) & 0xFFU;

  rtempbuff = zero_pack;
  byte_count = 0;
  arg |= NumberOfBlocks;

  if (hmmc->State == HAL_MMC_STATE_READY)
  {
    hmmc->ErrorCode = HAL_MMC_ERROR_NONE;


    hmmc->State = HAL_MMC_STATE_BUSY;

    /* Initialize data control register */
    hmmc->Instance->DCTRL = 0U;

    errorstate = SDMMC_CmdBlockCount(hmmc->Instance, arg);
    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Send Request Packet */
    /* Configure the MMC DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = NumberOfBlocks * MMC_BLOCKSIZE;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_CARD;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hmmc->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hmmc->Instance);

    /* Write Blocks in Polling mode */

    {
      hmmc->Context = MMC_CONTEXT_WRITE_MULTIPLE_BLOCK;

      /* Write Multi Block command */
      errorstate = SDMMC_CmdWriteMultiBlock(hmmc->Instance, 0);
    }

    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }


    /* Write block(s) in polling mode */
    dataremaining = config.DataLength;
    while (!__HAL_MMC_GET_FLAG(hmmc,
                               SDMMC_FLAG_TXUNDERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DATAEND))
    {
      if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_TXFIFOHE) && (dataremaining >= SDMMC_FIFO_SIZE))
      {

        /* Write data to SDMMC Tx FIFO */
        for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
        {
          data = (uint32_t)(*rtempbuff);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 8U);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 16U);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 24U);
          rtempbuff++;
          byte_count++;
          (void)SDMMC_WriteFIFO(hmmc->Instance, &data);
          /* Explicit deviation: reset scratch storage for every padding word. */
          if (byte_count < MMC_RPMB_KEYMAC_POSITION)
          {
            rtempbuff = zero_pack;
          }
          else if (byte_count == MMC_RPMB_KEYMAC_POSITION)
          {
            rtempbuff = pMAC;
          }
          if (byte_count == MMC_RPMB_DATA_POSITION)
          {
            rtempbuff = &pData[offset];
          }
          if ((byte_count >= MMC_RPMB_NONCE_POSITION) && \
              (byte_count < MMC_RPMB_WRITE_COUNTER_POSITION))
          {
            rtempbuff = zero_pack;
          }
          if (byte_count == MMC_RPMB_WRITE_COUNTER_POSITION)
          {
            rtempbuff = tail_pack;
          }
          else if (byte_count == MMC_BLOCKSIZE)
          {
            offset += (uint32_t)256U;
            byte_count = 0;
            rtempbuff = zero_pack; /* Explicit deviation: restart each frame. */
          }
          else
          {
            /* Nothing to do */
          }
        }
        dataremaining -= SDMMC_FIFO_SIZE;
      }

      if (((HAL_GetTick() - tickstart) >=  Timeout) || (Timeout == 0U))
      {
        /* Clear all the static flags */
        __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
        hmmc->ErrorCode |= errorstate;
        hmmc->State = HAL_MMC_STATE_READY;
        return HAL_TIMEOUT;
      }
    }
    __SDMMC_CMDTRANS_DISABLE(hmmc->Instance);

    /* Response Packet */

    errorstate = SDMMC_CmdBlockCount(hmmc->Instance, arg);
    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Configure the MMC DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = MMC_BLOCKSIZE;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hmmc->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hmmc->Instance);

    /* Write Blocks in Polling mode */

    {
      hmmc->Context = MMC_CONTEXT_READ_MULTIPLE_BLOCK;

      /* Write Multi Block command */
      errorstate = SDMMC_CmdReadMultiBlock(hmmc->Instance, 0);
    }

    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }


    /* Clear all the static flags */
    __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_DATA_FLAGS);
    /* Poll on SDMMC flags */
    tempbuff = zero_pack;
    byte_count = 0;
    dataremaining = config.DataLength;
    while (!__HAL_MMC_GET_FLAG(hmmc,
                               SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DATAEND))
    {
      if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_RXFIFOHF) && (dataremaining >= SDMMC_FIFO_SIZE))
      {
        /* Read data from SDMMC Rx FIFO */
        for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
        {
          data = SDMMC_ReadFIFO(hmmc->Instance);
          *tempbuff = (uint8_t)(data & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 8U) & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 16U) & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 24U) & 0xFFU);
          tempbuff++;
          byte_count++;
          if (byte_count < MMC_RPMB_WRITE_COUNTER_POSITION)
          {
            tempbuff = zero_pack;
          }
          else if (byte_count == MMC_RPMB_WRITE_COUNTER_POSITION)
          {
            tempbuff = tail_pack;
          }
          else
          {
            /* Nothing to do */
          }
        }
        dataremaining -= SDMMC_FIFO_SIZE;
      }

      if (((HAL_GetTick() - tickstart) >=  Timeout) || (Timeout == 0U))
      {
        /* Clear all the static flags */
        __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
        hmmc->ErrorCode |= HAL_MMC_ERROR_TIMEOUT;
        hmmc->State = HAL_MMC_STATE_READY;
        return HAL_TIMEOUT;
      }
    }
    __SDMMC_CMDTRANS_DISABLE(hmmc->Instance);

    /* Get error state */
    if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_DTIMEOUT))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_DATA_TIMEOUT;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_DCRCFAIL))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_DATA_CRC_FAIL;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_TXUNDERR))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_TX_UNDERRUN;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else
    {
      /* Nothing to do */
    }

    /* Clear all the static flags */
    __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_DATA_FLAGS);

    hmmc->State = HAL_MMC_STATE_READY;

    /* Check result of operation */
    if (((tail_pack[9] & (uint8_t)0xFEU) != 0x00U) || (tail_pack[10] != 0x03U))
    {
      hmmc->RPMBErrorCode |= tail_pack[9];
      return HAL_ERROR;
    }

    return HAL_OK;
  }
  else
  {
    hmmc->ErrorCode |= HAL_MMC_ERROR_BUSY;
    return HAL_ERROR;
  }
}
HAL_StatusTypeDef CMMC_RPMB_ReadBlocksCorrected(MMC_HandleTypeDef *hmmc, uint8_t *pData, uint16_t BlockAdd,
                                          uint16_t NumberOfBlocks, const uint8_t *pNonce, uint8_t *pMAC,
                                          uint32_t Timeout)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t tickstart = HAL_GetTick();
  uint32_t count;
  uint32_t byte_count = 0;
  uint32_t data;
  uint8_t tail_pack[12] = {0};
  uint8_t zero_pack[4] = {0};
  uint8_t echo_nonce[16] = {0};
  uint32_t dataremaining;
  const uint8_t *rtempbuff;
  uint8_t  *tempbuff;
  uint32_t arg = 0;
  uint32_t offset = 0;

  arg |= NumberOfBlocks;

  tail_pack[11] = 0x04;
  tail_pack[10] = 0x00;
  tail_pack[7]  = 0x00;
  tail_pack[6]  = 0x00;
  tail_pack[5]  = (uint8_t)(BlockAdd) & 0xFFU;
  tail_pack[4]  = (uint8_t)(BlockAdd >> 8) & 0xFFU;
  tail_pack[3]  = 0x00;
  tail_pack[2]  = 0x00;
  tail_pack[1]  = 0x00;
  tail_pack[0]  = 0x00;

  if (hmmc->State == HAL_MMC_STATE_READY)
  {
    hmmc->ErrorCode = HAL_MMC_ERROR_NONE;
    hmmc->State = HAL_MMC_STATE_BUSY;

    /* Initialize data control register */
    hmmc->Instance->DCTRL = 0U;

    errorstate = SDMMC_CmdBlockCount(hmmc->Instance, 1);
    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Send Request Packet */

    /* Configure the MMC DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = MMC_BLOCKSIZE;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_CARD;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hmmc->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hmmc->Instance);

    /* Write Blocks in Polling mode */
    hmmc->Context = MMC_CONTEXT_WRITE_MULTIPLE_BLOCK;

    /* Write Multi Block command */
    errorstate = SDMMC_CmdWriteMultiBlock(hmmc->Instance, 0);

    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Write block(s) in polling mode */
    rtempbuff = zero_pack;
    dataremaining = config.DataLength;
    while (!__HAL_MMC_GET_FLAG(hmmc,
                               SDMMC_FLAG_TXUNDERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DATAEND))
    {
      if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_TXFIFOHE) && (dataremaining >= SDMMC_FIFO_SIZE))
      {

        /* Write data to SDMMC Tx FIFO */
        for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
        {
          data = (uint32_t)(*rtempbuff);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 8U);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 16U);
          rtempbuff++;
          byte_count++;
          data |= ((uint32_t)(*rtempbuff) << 24U);
          rtempbuff++;
          byte_count++;
          (void)SDMMC_WriteFIFO(hmmc->Instance, &data);
          if (byte_count < MMC_RPMB_NONCE_POSITION)
          {
            rtempbuff = zero_pack;
          }
          else if (byte_count == MMC_RPMB_NONCE_POSITION)
          {
            rtempbuff = pNonce;
          }
          else if (byte_count == MMC_RPMB_WRITE_COUNTER_POSITION)
          {
            rtempbuff = tail_pack;
          }
          else
          {
            /* Nothing to do */
          }
        }
        dataremaining -= SDMMC_FIFO_SIZE;
      }

      if (((HAL_GetTick() - tickstart) >=  Timeout) || (Timeout == 0U))
      {
        /* Clear all the static flags */
        __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
        hmmc->ErrorCode |= errorstate;
        hmmc->State = HAL_MMC_STATE_READY;
        return HAL_TIMEOUT;
      }
    }
    __SDMMC_CMDTRANS_DISABLE(hmmc->Instance);

    /* Read Response Packet */
    errorstate = SDMMC_CmdBlockCount(hmmc->Instance, arg);
    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Configure the MMC DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = NumberOfBlocks * MMC_BLOCKSIZE;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hmmc->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hmmc->Instance);

    /* Write Blocks in Polling mode */
    hmmc->Context = MMC_CONTEXT_READ_MULTIPLE_BLOCK;

    /* Write Multi Block command */
    errorstate = SDMMC_CmdReadMultiBlock(hmmc->Instance, 0);

    if (errorstate != HAL_MMC_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= errorstate;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }

    /* Clear all the static flags */
    __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_DATA_FLAGS);
    /* Poll on SDMMC flags */
    tempbuff = zero_pack;
    byte_count = 0;

    dataremaining = config.DataLength;
    while (!__HAL_MMC_GET_FLAG(hmmc,
                               SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DATAEND))
    {
      if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_RXFIFOHF) && (dataremaining >= SDMMC_FIFO_SIZE))
      {
        /* Read data from SDMMC Rx FIFO */
        for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
        {
          data = SDMMC_ReadFIFO(hmmc->Instance);
          *tempbuff = (uint8_t)(data & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 8U) & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 16U) & 0xFFU);
          tempbuff++;
          byte_count++;
          *tempbuff = (uint8_t)((data >> 24U) & 0xFFU);
          tempbuff++;
          byte_count++;
          if (byte_count < MMC_RPMB_KEYMAC_POSITION)
          {
            tempbuff = zero_pack;
          }
          else if (byte_count == MMC_RPMB_KEYMAC_POSITION)
          {
            tempbuff = (uint8_t *)pMAC;
          }
          else if (byte_count == MMC_RPMB_DATA_POSITION)
          {
            tempbuff = &pData[offset];
          }
          else if (byte_count == MMC_RPMB_NONCE_POSITION)
          {
            tempbuff = echo_nonce;
          }
          else if (byte_count == MMC_RPMB_WRITE_COUNTER_POSITION)
          {
            tempbuff = tail_pack;
          }
          else if (byte_count == MMC_BLOCKSIZE)
          {
            byte_count = 0;
            offset += (uint32_t)256U;
            tempbuff = zero_pack; /* Explicit deviation: restart each frame. */
          }
          else
          {
            /* Nothing to do */
          }
        }
        dataremaining -= SDMMC_FIFO_SIZE;
      }

      if (((HAL_GetTick() - tickstart) >=  Timeout) || (Timeout == 0U))
      {
        /* Clear all the static flags */
        __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
        hmmc->ErrorCode |= HAL_MMC_ERROR_TIMEOUT;
        hmmc->State = HAL_MMC_STATE_READY;
        return HAL_TIMEOUT;
      }
    }
    __SDMMC_CMDTRANS_DISABLE(hmmc->Instance);

    /* Get error state */
    if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_DTIMEOUT))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_DATA_TIMEOUT;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_DCRCFAIL))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_DATA_CRC_FAIL;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else if (__HAL_MMC_GET_FLAG(hmmc, SDMMC_FLAG_TXUNDERR))
    {
      /* Clear all the static flags */
      __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_FLAGS);
      hmmc->ErrorCode |= HAL_MMC_ERROR_TX_UNDERRUN;
      hmmc->State = HAL_MMC_STATE_READY;
      return HAL_ERROR;
    }
    else
    {
      /* Nothing to do */
    }

    /* Clear all the static flags */
    __HAL_MMC_CLEAR_FLAG(hmmc, SDMMC_STATIC_DATA_FLAGS);

    hmmc->State = HAL_MMC_STATE_READY;

    for (uint8_t i = 0; i < 16U; i++)
    {
      if (pNonce[i] != echo_nonce[i])
      {
        return HAL_ERROR;
      }
    }

    /* Check result of operation */
    if ((tail_pack[9] != 0x00U) || (tail_pack[10] != 0x04U))
    {
      hmmc->RPMBErrorCode |= tail_pack[9];
      return HAL_ERROR;
    }

    return HAL_OK;
  }
  else
  {
    hmmc->ErrorCode |= HAL_MMC_ERROR_BUSY;
    return HAL_ERROR;
  }
}
