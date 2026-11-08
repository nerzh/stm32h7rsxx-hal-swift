// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CMSIS definitions from 7e6e213ddc397c76622a0aca2f623ccc3b34c010.

typedef struct
{
  __IO uint32_t CR;          /*!< PKA control register,                 Address offset: 0x00 */
  __IO uint32_t SR;          /*!< PKA status register,                  Address offset: 0x04 */
  __IO uint32_t CLRFR;       /*!< PKA clear flag register,              Address offset: 0x08 */
  uint32_t Reserved1[253];   /*!< Reserved,                             Address offset: 0x000C-0x03FC */
  __IO uint32_t RAM[1334];   /*!< PKA RAM                               Address offset: 0x0400-0x18D8 */
} PKA_TypeDef;
#define PKA_BASE                        (AHB3PERIPH_BASE + 0x2000UL)
#define PKA_CR_EN_Pos                       (0U)
#define PKA_CR_EN_Msk                       (0x1UL << PKA_CR_EN_Pos)                /*!< 0x00000001 */
#define PKA_CR_EN                           PKA_CR_EN_Msk                           /*!< PKA enable */
#define PKA_CR_START_Pos                    (1U)
#define PKA_CR_START_Msk                    (0x1UL << PKA_CR_START_Pos)             /*!< 0x00000002 */
#define PKA_CR_START                        PKA_CR_START_Msk                        /*!< Start operation */
#define PKA_CR_MODE_Pos                     (8U)
#define PKA_CR_MODE_Msk                     (0x3FUL << PKA_CR_MODE_Pos)             /*!< 0x00003F00 */
#define PKA_CR_MODE                         PKA_CR_MODE_Msk                         /*!< MODE[5:0] PKA operation code */
#define PKA_CR_MODE_0                       (0x01UL << PKA_CR_MODE_Pos)             /*!< 0x00000100 */
#define PKA_CR_MODE_1                       (0x02UL << PKA_CR_MODE_Pos)             /*!< 0x00000200 */
#define PKA_CR_MODE_2                       (0x04UL << PKA_CR_MODE_Pos)             /*!< 0x00000400 */
#define PKA_CR_MODE_3                       (0x08UL << PKA_CR_MODE_Pos)             /*!< 0x00000800 */
#define PKA_CR_MODE_4                       (0x10UL << PKA_CR_MODE_Pos)             /*!< 0x00001000 */
#define PKA_CR_MODE_5                       (0x20UL << PKA_CR_MODE_Pos)             /*!< 0x00002000 */
#define PKA_CR_PROCENDIE_Pos                (17U)
#define PKA_CR_PROCENDIE_Msk                (0x1UL << PKA_CR_PROCENDIE_Pos)         /*!< 0x00020000 */
#define PKA_CR_PROCENDIE                    PKA_CR_PROCENDIE_Msk                    /*!< End of operation interrupt enable */
#define PKA_CR_RAMERRIE_Pos                 (19U)
#define PKA_CR_RAMERRIE_Msk                 (0x1UL << PKA_CR_RAMERRIE_Pos)          /*!< 0x00080000 */
#define PKA_CR_RAMERRIE                     PKA_CR_RAMERRIE_Msk                     /*!< RAM error interrupt enable */
#define PKA_CR_ADDRERRIE_Pos                (20U)
#define PKA_CR_ADDRERRIE_Msk                (0x1UL << PKA_CR_ADDRERRIE_Pos)         /*!< 0x00100000 */
#define PKA_CR_ADDRERRIE                    PKA_CR_ADDRERRIE_Msk                    /*!< Address error interrupt enable */
#define PKA_CR_OPERRIE_Pos                  (21U)
#define PKA_CR_OPERRIE_Msk                  (0x1UL << PKA_CR_OPERRIE_Pos)           /*!< 0x00200000 */
#define PKA_CR_OPERRIE                      PKA_CR_OPERRIE_Msk                      /*!< Operation Error interrupt enable */
#define PKA_SR_INITOK_Pos                   (0U)
#define PKA_SR_INITOK_Msk                   (0x1UL << PKA_SR_INITOK_Pos)            /*!< 0x00000001 */
#define PKA_SR_INITOK                       PKA_SR_INITOK_Msk                       /*!< PKA initialisation flag */
#define PKA_SR_LMF_Pos                      (1U)
#define PKA_SR_LMF_Msk                      (0x1UL << PKA_SR_LMF_Pos)               /*!< 0x00000002 */
#define PKA_SR_LMF                          PKA_SR_LMF_Msk                          /*!< Limited mode flag */
#define PKA_SR_BUSY_Pos                     (16U)
#define PKA_SR_BUSY_Msk                     (0x1UL << PKA_SR_BUSY_Pos)              /*!< 0x00010000 */
#define PKA_SR_BUSY                         PKA_SR_BUSY_Msk                         /*!< PKA operation is in progress */
#define PKA_SR_PROCENDF_Pos                 (17U)
#define PKA_SR_PROCENDF_Msk                 (0x1UL << PKA_SR_PROCENDF_Pos)          /*!< 0x00020000 */
#define PKA_SR_PROCENDF                     PKA_SR_PROCENDF_Msk                     /*!< PKA end of operation flag */
#define PKA_SR_RAMERRF_Pos                  (19U)
#define PKA_SR_RAMERRF_Msk                  (0x1UL << PKA_SR_RAMERRF_Pos)           /*!< 0x00080000 */
#define PKA_SR_RAMERRF                      PKA_SR_RAMERRF_Msk                      /*!< PKA RAM error flag */
#define PKA_SR_ADDRERRF_Pos                 (20U)
#define PKA_SR_ADDRERRF_Msk                 (0x1UL << PKA_SR_ADDRERRF_Pos)          /*!< 0x00100000 */
#define PKA_SR_ADDRERRF                     PKA_SR_ADDRERRF_Msk                     /*!< Address error flag */
#define PKA_SR_OPERRF_Pos                   (21U)
#define PKA_SR_OPERRF_Msk                   (0x1UL << PKA_SR_OPERRF_Pos)            /*!< 0x00200000 */
#define PKA_SR_OPERRF                       PKA_SR_OPERRF_Msk                       /*!< PKA operation Error flag*/
#define PKA_CLRFR_PROCENDFC_Pos             (17U)
#define PKA_CLRFR_PROCENDFC_Msk             (0x1UL << PKA_CLRFR_PROCENDFC_Pos)      /*!< 0x00020000 */
#define PKA_CLRFR_PROCENDFC                 PKA_CLRFR_PROCENDFC_Msk                 /*!< Clear PKA end of operation flag */
#define PKA_CLRFR_RAMERRFC_Pos              (19U)
#define PKA_CLRFR_RAMERRFC_Msk              (0x1UL << PKA_CLRFR_RAMERRFC_Pos)       /*!< 0x00080000 */
#define PKA_CLRFR_RAMERRFC                  PKA_CLRFR_RAMERRFC_Msk                  /*!< Clear PKA RAM error flag */
#define PKA_CLRFR_ADDRERRFC_Pos             (20U)
#define PKA_CLRFR_ADDRERRFC_Msk             (0x1UL << PKA_CLRFR_ADDRERRFC_Pos)      /*!< 0x00100000 */
#define PKA_CLRFR_ADDRERRFC                 PKA_CLRFR_ADDRERRFC_Msk                 /*!< Clear address error flag */
#define PKA_CLRFR_OPERRFC_Pos               (21U)
#define PKA_CLRFR_OPERRFC_Msk               (0x1UL << PKA_CLRFR_OPERRFC_Pos)        /*!< 0x00200000 */
#define PKA_CLRFR_OPERRFC                   PKA_CLRFR_OPERRFC_Msk                   /*!< Clear PKA operation Error flag*/
#define PKA_RAM_OFFSET                                 (0x0400UL)                   /*!< PKA RAM address offset */
#define PKA_MONTGOMERY_PARAM_IN_MOD_NB_BITS            ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus number of bits */
#define PKA_MONTGOMERY_PARAM_IN_MODULUS                ((0x1088UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus */
#define PKA_MONTGOMERY_PARAM_OUT_PARAMETER             ((0x0620UL - PKA_RAM_OFFSET)>>2)    /*!< Output Montgomery parameter */
#define PKA_MODULAR_EXP_IN_EXP_NB_BITS                 ((0x0400UL - PKA_RAM_OFFSET)>>2)    /*!< Input exponent number of bits */
#define PKA_MODULAR_EXP_IN_OP_NB_BITS                  ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_MODULAR_EXP_IN_MONTGOMERY_PARAM            ((0x0620UL - PKA_RAM_OFFSET)>>2)    /*!< Input storage area for Montgomery parameter */
#define PKA_MODULAR_EXP_IN_EXPONENT_BASE               ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input base of the exponentiation */
#define PKA_MODULAR_EXP_IN_EXPONENT                    ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Input exponent to process */
#define PKA_MODULAR_EXP_IN_MODULUS                     ((0x1088UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus */
#define PKA_MODULAR_EXP_PROTECT_IN_EXPONENT_BASE       ((0x16C8UL - PKA_RAM_OFFSET)>>2)    /*!< Input base of the protected exponentiation */
#define PKA_MODULAR_EXP_PROTECT_IN_EXPONENT            ((0x14B8UL - PKA_RAM_OFFSET)>>2)    /*!< Input exponent to process protected exponentiation*/
#define PKA_MODULAR_EXP_PROTECT_IN_MODULUS             ((0x0838UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus to process protected exponentiation */
#define PKA_MODULAR_EXP_PROTECT_IN_PHI                 ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input phi to process protected exponentiation */
#define PKA_MODULAR_EXP_OUT_RESULT                     ((0x0838UL - PKA_RAM_OFFSET)>>2)    /*!< Output result of the exponentiation */
#define PKA_MODULAR_EXP_OUT_ERROR                      ((0x1298UL - PKA_RAM_OFFSET)>>2)    /*!< Output error of the exponentiation */
#define PKA_MODULAR_EXP_OUT_MONTGOMERY_PARAM           ((0x0620UL - PKA_RAM_OFFSET)>>2)    /*!< Output storage area for Montgomery parameter */
#define PKA_MODULAR_EXP_OUT_EXPONENT_BASE              ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Output base of the exponentiation */
#define PKA_ECC_SCALAR_MUL_IN_EXP_NB_BITS              ((0x0400UL - PKA_RAM_OFFSET)>>2)    /*!< Input curve prime order n number of bits */
#define PKA_ECC_SCALAR_MUL_IN_OP_NB_BITS               ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus number of bits */
#define PKA_ECC_SCALAR_MUL_IN_A_COEFF_SIGN             ((0x0410UL - PKA_RAM_OFFSET)>>2)    /*!< Input sign of the 'a' coefficient */
#define PKA_ECC_SCALAR_MUL_IN_A_COEFF                  ((0x0418UL - PKA_RAM_OFFSET)>>2)    /*!< Input ECC curve 'a' coefficient */
#define PKA_ECC_SCALAR_MUL_IN_B_COEFF                  ((0x0520UL - PKA_RAM_OFFSET)>>2)    /*!< Input ECC curve 'b' coefficient */
#define PKA_ECC_SCALAR_MUL_IN_MOD_GF                   ((0x1088UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus GF(p) */
#define PKA_ECC_SCALAR_MUL_IN_K                        ((0x12A0UL - PKA_RAM_OFFSET)>>2)    /*!< Input 'k' of KP */
#define PKA_ECC_SCALAR_MUL_IN_INITIAL_POINT_X          ((0x0578UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P X coordinate */
#define PKA_ECC_SCALAR_MUL_IN_INITIAL_POINT_Y          ((0x0470UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P Y coordinate */
#define PKA_ECC_SCALAR_MUL_IN_N_PRIME_ORDER            ((0x0F88UL - PKA_RAM_OFFSET)>>2)    /*!< Input prime order n */
#define PKA_ECC_SCALAR_MUL_OUT_RESULT_X                ((0x0578UL - PKA_RAM_OFFSET)>>2)    /*!< Output result X coordinate */
#define PKA_ECC_SCALAR_MUL_OUT_RESULT_Y                ((0x05D0UL - PKA_RAM_OFFSET)>>2)    /*!< Output result Y coordinate */
#define PKA_ECC_SCALAR_MUL_OUT_ERROR                   ((0x0680UL - PKA_RAM_OFFSET)>>2)    /*!< Output result error */
#define PKA_POINT_CHECK_IN_MOD_NB_BITS                 ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus number of bits */
#define PKA_POINT_CHECK_IN_A_COEFF_SIGN                ((0x0410UL - PKA_RAM_OFFSET)>>2)    /*!< Input sign of the 'a' coefficient */
#define PKA_POINT_CHECK_IN_A_COEFF                     ((0x0418UL - PKA_RAM_OFFSET)>>2)    /*!< Input ECC curve 'a' coefficient */
#define PKA_POINT_CHECK_IN_B_COEFF                     ((0x0520UL - PKA_RAM_OFFSET)>>2)    /*!< Input ECC curve 'b' coefficient */
#define PKA_POINT_CHECK_IN_MOD_GF                      ((0x0470UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus GF(p) */
#define PKA_POINT_CHECK_IN_INITIAL_POINT_X             ((0x0578UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P X coordinate */
#define PKA_POINT_CHECK_IN_INITIAL_POINT_Y             ((0x05D0UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P Y coordinate */
#define PKA_POINT_CHECK_IN_MONTGOMERY_PARAM            ((0x04C8UL - PKA_RAM_OFFSET)>>2)    /*!< Input storage area for Montgomery parameter */
#define PKA_POINT_CHECK_OUT_ERROR                      ((0x0680UL - PKA_RAM_OFFSET)>>2)    /*!< Output error */
#define PKA_ECDSA_SIGN_IN_ORDER_NB_BITS                ((0x0400UL - PKA_RAM_OFFSET)>>2)    /*!< Input order number of bits */
#define PKA_ECDSA_SIGN_IN_MOD_NB_BITS                  ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus number of bits */
#define PKA_ECDSA_SIGN_IN_A_COEFF_SIGN                 ((0x0410UL - PKA_RAM_OFFSET)>>2)    /*!< Input sign of the 'a' coefficient */
#define PKA_ECDSA_SIGN_IN_A_COEFF                      ((0x0418UL - PKA_RAM_OFFSET)>>2)    /*!< Input ECC curve 'a' coefficient */
#define PKA_ECDSA_SIGN_IN_B_COEFF                      ((0x0520UL - PKA_RAM_OFFSET)>>2)    /*!< Input ECC curve 'b' coefficient */
#define PKA_ECDSA_SIGN_IN_MOD_GF                       ((0x1088UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus GF(p) */
#define PKA_ECDSA_SIGN_IN_K                            ((0x12A0UL - PKA_RAM_OFFSET)>>2)    /*!< Input k value of the ECDSA */
#define PKA_ECDSA_SIGN_IN_INITIAL_POINT_X              ((0x0578UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P X coordinate */
#define PKA_ECDSA_SIGN_IN_INITIAL_POINT_Y              ((0x0470UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P Y coordinate */
#define PKA_ECDSA_SIGN_IN_HASH_E                       ((0x0FE8UL - PKA_RAM_OFFSET)>>2)    /*!< Input e, hash of the message */
#define PKA_ECDSA_SIGN_IN_PRIVATE_KEY_D                ((0x0F28UL - PKA_RAM_OFFSET)>>2)    /*!< Input d, private key */
#define PKA_ECDSA_SIGN_IN_ORDER_N                      ((0x0F88UL - PKA_RAM_OFFSET)>>2)    /*!< Input n, order of the curve */
#define PKA_ECDSA_SIGN_OUT_ERROR                       ((0x0FE0UL - PKA_RAM_OFFSET)>>2)    /*!< Output error */
#define PKA_ECDSA_SIGN_OUT_SIGNATURE_R                 ((0x0730UL - PKA_RAM_OFFSET)>>2)    /*!< Output signature r */
#define PKA_ECDSA_SIGN_OUT_SIGNATURE_S                 ((0x0788UL - PKA_RAM_OFFSET)>>2)    /*!< Output signature s */
#define PKA_ECDSA_SIGN_OUT_FINAL_POINT_X               ((0x1400UL - PKA_RAM_OFFSET)>>2)    /*!< Extended output result point X coordinate */
#define PKA_ECDSA_SIGN_OUT_FINAL_POINT_Y               ((0x1458UL - PKA_RAM_OFFSET)>>2)    /*!< Extended output result point Y coordinate */
#define PKA_ECDSA_VERIF_IN_ORDER_NB_BITS               ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input order number of bits */
#define PKA_ECDSA_VERIF_IN_MOD_NB_BITS                 ((0x04C8UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus number of bits */
#define PKA_ECDSA_VERIF_IN_A_COEFF_SIGN                ((0x0468UL - PKA_RAM_OFFSET)>>2)    /*!< Input sign of the 'a' coefficient */
#define PKA_ECDSA_VERIF_IN_A_COEFF                     ((0x0470UL - PKA_RAM_OFFSET)>>2)    /*!< Input ECC curve 'a' coefficient */
#define PKA_ECDSA_VERIF_IN_MOD_GF                      ((0x04D0UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus GF(p) */
#define PKA_ECDSA_VERIF_IN_INITIAL_POINT_X             ((0x0678UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P X coordinate */
#define PKA_ECDSA_VERIF_IN_INITIAL_POINT_Y             ((0x06D0UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P Y coordinate */
#define PKA_ECDSA_VERIF_IN_PUBLIC_KEY_POINT_X          ((0x12F8UL - PKA_RAM_OFFSET)>>2)    /*!< Input public key point X coordinate */
#define PKA_ECDSA_VERIF_IN_PUBLIC_KEY_POINT_Y          ((0x1350UL - PKA_RAM_OFFSET)>>2)    /*!< Input public key point Y coordinate */
#define PKA_ECDSA_VERIF_IN_SIGNATURE_R                 ((0x10E0UL - PKA_RAM_OFFSET)>>2)    /*!< Input r, part of the signature */
#define PKA_ECDSA_VERIF_IN_SIGNATURE_S                 ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input s, part of the signature */
#define PKA_ECDSA_VERIF_IN_HASH_E                      ((0x13A8UL - PKA_RAM_OFFSET)>>2)    /*!< Input e, hash of the message */
#define PKA_ECDSA_VERIF_IN_ORDER_N                     ((0x1088UL - PKA_RAM_OFFSET)>>2)    /*!< Input n, order of the curve */
#define PKA_ECDSA_VERIF_OUT_RESULT                     ((0x05D0UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_RSA_CRT_EXP_IN_MOD_NB_BITS                 ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operands number of bits */
#define PKA_RSA_CRT_EXP_IN_DP_CRT                      ((0x0730UL - PKA_RAM_OFFSET)>>2)    /*!< Input Dp CRT parameter */
#define PKA_RSA_CRT_EXP_IN_DQ_CRT                      ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Input Dq CRT parameter */
#define PKA_RSA_CRT_EXP_IN_QINV_CRT                    ((0x0948UL - PKA_RAM_OFFSET)>>2)    /*!< Input qInv CRT parameter */
#define PKA_RSA_CRT_EXP_IN_PRIME_P                     ((0x0B60UL - PKA_RAM_OFFSET)>>2)    /*!< Input Prime p */
#define PKA_RSA_CRT_EXP_IN_PRIME_Q                     ((0x1088UL - PKA_RAM_OFFSET)>>2)    /*!< Input Prime q */
#define PKA_RSA_CRT_EXP_IN_EXPONENT_BASE               ((0x12A0UL - PKA_RAM_OFFSET)>>2)    /*!< Input base of the exponentiation */
#define PKA_RSA_CRT_EXP_OUT_RESULT                     ((0x0838UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_MODULAR_REDUC_IN_OP_LENGTH                 ((0x0400UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand length */
#define PKA_MODULAR_REDUC_IN_MOD_LENGTH                ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus length */
#define PKA_MODULAR_REDUC_IN_OPERAND                   ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand */
#define PKA_MODULAR_REDUC_IN_MODULUS                   ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus */
#define PKA_MODULAR_REDUC_OUT_RESULT                   ((0xE78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_ARITHMETIC_ADD_IN_OP_NB_BITS               ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_ARITHMETIC_ADD_IN_OP1                      ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_ARITHMETIC_ADD_IN_OP2                      ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op2 */
#define PKA_ARITHMETIC_ADD_OUT_RESULT                  ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_ARITHMETIC_SUB_IN_OP_NB_BITS               ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_ARITHMETIC_SUB_IN_OP1                      ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_ARITHMETIC_SUB_IN_OP2                      ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op2 */
#define PKA_ARITHMETIC_SUB_OUT_RESULT                  ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_ARITHMETIC_MUL_NB_BITS                     ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_ARITHMETIC_MUL_IN_OP1                      ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_ARITHMETIC_MUL_IN_OP2                      ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op2 */
#define PKA_ARITHMETIC_MUL_OUT_RESULT                  ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_COMPARISON_IN_OP_NB_BITS                   ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_COMPARISON_IN_OP1                          ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_COMPARISON_IN_OP2                          ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op2 */
#define PKA_COMPARISON_OUT_RESULT                      ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_MODULAR_ADD_NB_BITS                        ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_MODULAR_ADD_IN_OP1                         ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_MODULAR_ADD_IN_OP2                         ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op2 */
#define PKA_MODULAR_ADD_IN_OP3_MOD                     ((0x1088UL - PKA_RAM_OFFSET)>>2)   /*!< Input operand op3 (modulus) */
#define PKA_MODULAR_ADD_OUT_RESULT                     ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_MODULAR_INV_NB_BITS                        ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_MODULAR_INV_IN_OP1                         ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_MODULAR_INV_IN_OP2_MOD                     ((0x0C68UL - PKA_RAM_OFFSET)>>2)   /*!< Input operand op2 (modulus) */
#define PKA_MODULAR_INV_OUT_RESULT                     ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_MODULAR_SUB_IN_OP_NB_BITS                  ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_MODULAR_SUB_IN_OP1                         ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_MODULAR_SUB_IN_OP2                         ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op2 */
#define PKA_MODULAR_SUB_IN_OP3_MOD                     ((0x1088UL - PKA_RAM_OFFSET)>>2)   /*!< Input operand op3 */
#define PKA_MODULAR_SUB_OUT_RESULT                     ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_MONTGOMERY_MUL_IN_OP_NB_BITS               ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_MONTGOMERY_MUL_IN_OP1                      ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_MONTGOMERY_MUL_IN_OP2                      ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op2 */
#define PKA_MONTGOMERY_MUL_IN_OP3_MOD                  ((0x1088UL - PKA_RAM_OFFSET)>>2)   /*!< Input modulus */
#define PKA_MONTGOMERY_MUL_OUT_RESULT                  ((0x0E78UL - PKA_RAM_OFFSET)>>2)    /*!< Output result */
#define PKA_ARITHMETIC_ALL_OPS_NB_BITS                 ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand number of bits */
#define PKA_ARITHMETIC_ALL_OPS_IN_OP1                  ((0x0A50UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op1 */
#define PKA_ARITHMETIC_ALL_OPS_IN_OP2                  ((0x0C68UL - PKA_RAM_OFFSET)>>2)    /*!< Input operand op2 */
#define PKA_ARITHMETIC_ALL_OPS_IN_OP3                  ((0x1088UL - PKA_RAM_OFFSET)>>2)   /*!< Input operand op2 */
#define PKA_ARITHMETIC_ALL_OPS_OUT_RESULT              ((0x0E78UL - PKA_RAM_OFFSET)>>2)   /*!< Output result for arithmetic operations */
#define PKA_ECC_COMPLETE_ADD_IN_MOD_NB_BITS            ((0x0408UL - PKA_RAM_OFFSET)>>2)   /*!< Input Modulus number of bits */
#define PKA_ECC_COMPLETE_ADD_IN_A_COEFF_SIGN           ((0x0410UL - PKA_RAM_OFFSET)>>2)   /*!< Input sign of the 'a' coefficient */
#define PKA_ECC_COMPLETE_ADD_IN_A_COEFF                ((0x0418UL - PKA_RAM_OFFSET)>>2)   /*!< Input ECC curve '|a|' coefficient */
#define PKA_ECC_COMPLETE_ADD_IN_MOD_P                  ((0x0470UL - PKA_RAM_OFFSET)>>2)   /*!< Input modulus GF(p) */
#define PKA_ECC_COMPLETE_ADD_IN_POINT1_X               ((0x0628UL - PKA_RAM_OFFSET)>>2)   /*!< Input initial point P X coordinate */
#define PKA_ECC_COMPLETE_ADD_IN_POINT1_Y               ((0x0680UL - PKA_RAM_OFFSET)>>2)   /*!< Input initial point P Y coordinate */
#define PKA_ECC_COMPLETE_ADD_IN_POINT1_Z               ((0x06D8UL - PKA_RAM_OFFSET)>>2)   /*!< Input initial point P Z coordinate */
#define PKA_ECC_COMPLETE_ADD_IN_POINT2_X               ((0x0730UL - PKA_RAM_OFFSET)>>2)   /*!< Input initial point Q X coordinate */
#define PKA_ECC_COMPLETE_ADD_IN_POINT2_Y               ((0x0788UL - PKA_RAM_OFFSET)>>2)   /*!< Input initial point Q Y coordinate */
#define PKA_ECC_COMPLETE_ADD_IN_POINT2_Z               ((0x07E0UL - PKA_RAM_OFFSET)>>2)   /*!< Input initial point Q Z coordinate */
#define PKA_ECC_COMPLETE_ADD_OUT_RESULT_X              ((0x0D60UL - PKA_RAM_OFFSET)>>2)   /*!< Output result X coordinate */
#define PKA_ECC_COMPLETE_ADD_OUT_RESULT_Y              ((0x0DB8UL - PKA_RAM_OFFSET)>>2)   /*!< Output result Y coordinate */
#define PKA_ECC_COMPLETE_ADD_OUT_RESULT_Z              ((0x0E10UL - PKA_RAM_OFFSET)>>2)   /*!< Output result Z coordinate */
#define PKA_ECC_DOUBLE_LADDER_IN_PRIME_ORDER_NB_BITS  ((0x0400UL - PKA_RAM_OFFSET)>>2)    /*!< Input n, order of the curve */
#define PKA_ECC_DOUBLE_LADDER_IN_MOD_NB_BITS          ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input Modulus number of bits */
#define PKA_ECC_DOUBLE_LADDER_IN_A_COEFF_SIGN         ((0x0410UL - PKA_RAM_OFFSET)>>2)    /*!< Input sign of the 'a' coefficient */
#define PKA_ECC_DOUBLE_LADDER_IN_A_COEFF              ((0x0418UL - PKA_RAM_OFFSET)>>2)    /*!< Input ECC curve '|a|' coefficient */
#define PKA_ECC_DOUBLE_LADDER_IN_MOD_P                ((0x0470UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus GF(p) */
#define PKA_ECC_DOUBLE_LADDER_IN_K_INTEGER            ((0x0520UL - PKA_RAM_OFFSET)>>2)    /*!< Input 'k' integer coefficient */
#define PKA_ECC_DOUBLE_LADDER_IN_M_INTEGER            ((0x0578UL - PKA_RAM_OFFSET)>>2)    /*!< Input 'm' integer coefficient */
#define PKA_ECC_DOUBLE_LADDER_IN_POINT1_X             ((0x0628UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P X coordinate */
#define PKA_ECC_DOUBLE_LADDER_IN_POINT1_Y             ((0x0680UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P Y coordinate */
#define PKA_ECC_DOUBLE_LADDER_IN_POINT1_Z             ((0x06D8UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point P Z coordinate */
#define PKA_ECC_DOUBLE_LADDER_IN_POINT2_X             ((0x0730UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point Q X coordinate */
#define PKA_ECC_DOUBLE_LADDER_IN_POINT2_Y             ((0x0788UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point Q Y coordinate */
#define PKA_ECC_DOUBLE_LADDER_IN_POINT2_Z             ((0x07E0UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial point Q Z coordinate */
#define PKA_ECC_DOUBLE_LADDER_OUT_RESULT_X          ((0x0578UL - PKA_RAM_OFFSET)>>2)    /*!< Output result X coordinate (affine coordinate) */
#define PKA_ECC_DOUBLE_LADDER_OUT_RESULT_Y          ((0x05D0UL - PKA_RAM_OFFSET)>>2)    /*!< Output result Y coordinate (affine coordinate) */
#define PKA_ECC_DOUBLE_LADDER_OUT_ERROR             ((0x0520UL - PKA_RAM_OFFSET)>>2)    /*!< Output result error */
#define PKA_ECC_PROJECTIVE_AFF_IN_MOD_NB_BITS           ((0x0408UL - PKA_RAM_OFFSET)>>2)    /*!< Input Modulus number of bits */
#define PKA_ECC_PROJECTIVE_AFF_IN_MOD_P                 ((0x0470UL - PKA_RAM_OFFSET)>>2)    /*!< Input modulus GF(p) */
#define PKA_ECC_PROJECTIVE_AFF_IN_POINT_X               ((0x0D60UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial projective point P X coordinate */
#define PKA_ECC_PROJECTIVE_AFF_IN_POINT_Y               ((0x0DB8UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial projective point P Y coordinate */
#define PKA_ECC_PROJECTIVE_AFF_IN_POINT_Z               ((0x0E10UL - PKA_RAM_OFFSET)>>2)    /*!< Input initial projective point P Z coordinate */
#define PKA_ECC_PROJECTIVE_AFF_IN_MONTGOMERY_PARAM_R2   ((0x04C8UL - PKA_RAM_OFFSET)>>2)    /*!< Input storage area for Montgomery parameter */
#define PKA_ECC_PROJECTIVE_AFF_OUT_RESULT_X      ((0x0578UL - PKA_RAM_OFFSET)>>2)    /*!< Output result x affine coordinate */
#define PKA_ECC_PROJECTIVE_AFF_OUT_RESULT_Y      ((0x05D0UL - PKA_RAM_OFFSET)>>2)    /*!< Output result y affine coordinate */
#define PKA_ECC_PROJECTIVE_AFF_OUT_ERROR         ((0x0680UL - PKA_RAM_OFFSET)>>2)    /*!< Output result error */
