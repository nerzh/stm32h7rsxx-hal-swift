// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.
static void FDCAN_CalcultateRamBlockAddresses(FDCAN_HandleTypeDef *hfdcan)
{
  uint32_t RAMcounter;
  uint32_t SramCanInstanceBase = SRAMCAN_BASE;

  if (hfdcan->Instance == FDCAN2)
  {
    SramCanInstanceBase += SRAMCAN_SIZE;
  }

  /* Standard filter list start address */
  hfdcan->msgRam.StandardFilterSA = SramCanInstanceBase + SRAMCAN_FLSSA;

  /* Standard filter elements number */
  MODIFY_REG(hfdcan->Instance->RXGFC, FDCAN_RXGFC_LSS, (hfdcan->Init.StdFiltersNbr << FDCAN_RXGFC_LSS_Pos));

  /* Extended filter list start address */
  hfdcan->msgRam.ExtendedFilterSA = SramCanInstanceBase + SRAMCAN_FLESA;

  /* Extended filter elements number */
  MODIFY_REG(hfdcan->Instance->RXGFC, FDCAN_RXGFC_LSE, (hfdcan->Init.ExtFiltersNbr << FDCAN_RXGFC_LSE_Pos));

  /* Rx FIFO 0 start address */
  hfdcan->msgRam.RxFIFO0SA = SramCanInstanceBase + SRAMCAN_RF0SA;

  /* Rx FIFO 1 start address */
  hfdcan->msgRam.RxFIFO1SA = SramCanInstanceBase + SRAMCAN_RF1SA;

  /* Tx event FIFO start address */
  hfdcan->msgRam.TxEventFIFOSA = SramCanInstanceBase + SRAMCAN_TEFSA;

  /* Tx FIFO/queue start address */
  hfdcan->msgRam.TxFIFOQSA = SramCanInstanceBase + SRAMCAN_TFQSA;

  /* Flush the allocated Message RAM area */
  for (RAMcounter = SramCanInstanceBase; RAMcounter < (SramCanInstanceBase + SRAMCAN_SIZE); RAMcounter += 4U)
  {
    *(uint32_t *)(RAMcounter) = 0x00000000U;
  }
}
