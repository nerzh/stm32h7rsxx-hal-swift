// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Matching UART/USART clock prescaler definitions from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

func serialPrescalerDivisor(_ index: UInt32) -> UInt32 {
  switch index {
  case 0: return 1
  case 1: return 2
  case 2: return 4
  case 3: return 6
  case 4: return 8
  case 5: return 10
  case 6: return 12
  case 7: return 16
  case 8: return 32
  case 9: return 64
  case 10: return 128
  default: return 256
  }
}
