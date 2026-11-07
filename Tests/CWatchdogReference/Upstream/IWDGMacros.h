/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define IWDG_PRESCALER_4                0x00000000u                                     /*!< IWDG prescaler set to 4   */
#define IWDG_PRESCALER_8                IWDG_PR_PR_0                                    /*!< IWDG prescaler set to 8   */
#define IWDG_PRESCALER_16               IWDG_PR_PR_1                                    /*!< IWDG prescaler set to 16  */
#define IWDG_PRESCALER_32               (IWDG_PR_PR_1 | IWDG_PR_PR_0)                   /*!< IWDG prescaler set to 32  */
#define IWDG_PRESCALER_64               IWDG_PR_PR_2                                    /*!< IWDG prescaler set to 64  */
#define IWDG_PRESCALER_128              (IWDG_PR_PR_2 | IWDG_PR_PR_0)                   /*!< IWDG prescaler set to 128 */
#define IWDG_PRESCALER_256              (IWDG_PR_PR_2 | IWDG_PR_PR_1)                   /*!< IWDG prescaler set to 256 */
#define IWDG_PRESCALER_512              (IWDG_PR_PR_2 | IWDG_PR_PR_1 | IWDG_PR_PR_0)    /*!< IWDG prescaler set to 512 */
#define IWDG_PRESCALER_1024             IWDG_PR_PR_3                                    /*!< IWDG prescaler set to 1024 */
#define IWDG_WINDOW_DISABLE             IWDG_WINR_WIN
#define IWDG_EWI_DISABLE                0x00000000u       /*!< EWI Disable */
#define IWDG_STATUS_DISABLE             0x00000000u
#define IWDG_STATUS_ENABLE              IWDG_SR_ONF
#define __HAL_IWDG_START(__HANDLE__)                WRITE_REG((__HANDLE__)->Instance->KR, IWDG_KEY_ENABLE)
#define __HAL_IWDG_RELOAD_COUNTER(__HANDLE__)       WRITE_REG((__HANDLE__)->Instance->KR, IWDG_KEY_RELOAD)
#define IWDG_KEY_RELOAD                 0x0000AAAAu  /*!< IWDG Reload Counter Enable   */
#define IWDG_KEY_ENABLE                 0x0000CCCCu  /*!< IWDG Peripheral Enable       */
#define IWDG_KEY_WRITE_ACCESS_ENABLE    0x00005555u  /*!< IWDG KR Write Access Enable  */
#define IWDG_KEY_WRITE_ACCESS_DISABLE   0x00000000u  /*!< IWDG KR Write Access Disable */
#define IWDG_ENABLE_WRITE_ACCESS(__HANDLE__)  WRITE_REG((__HANDLE__)->Instance->KR, IWDG_KEY_WRITE_ACCESS_ENABLE)
#define IWDG_DISABLE_WRITE_ACCESS(__HANDLE__) WRITE_REG((__HANDLE__)->Instance->KR, IWDG_KEY_WRITE_ACCESS_DISABLE)
#define IS_IWDG_PRESCALER(__PRESCALER__)      (((__PRESCALER__) == IWDG_PRESCALER_4)  || \
                                               ((__PRESCALER__) == IWDG_PRESCALER_8)  || \
                                               ((__PRESCALER__) == IWDG_PRESCALER_16) || \
                                               ((__PRESCALER__) == IWDG_PRESCALER_32) || \
                                               ((__PRESCALER__) == IWDG_PRESCALER_64) || \
                                               ((__PRESCALER__) == IWDG_PRESCALER_128)|| \
                                               ((__PRESCALER__) == IWDG_PRESCALER_256)|| \
                                               ((__PRESCALER__) == IWDG_PRESCALER_512)|| \
                                               ((__PRESCALER__) == IWDG_PRESCALER_1024))
#define IS_IWDG_RELOAD(__RELOAD__)            ((__RELOAD__) <= IWDG_RLR_RL)
#define IS_IWDG_WINDOW(__WINDOW__)            ((__WINDOW__) <= IWDG_WINR_WIN)
#define IS_IWDG_EWI(__EWI__)            ((__EWI__) <= IWDG_EWCR_EWIT)
