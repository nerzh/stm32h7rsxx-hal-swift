/* Copyright (c) 2022 STMicroelectronics. SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS register declarations/bits at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define RAMECC_IER_GIE_Pos             (0U)
#define RAMECC_IER_GIE_Msk             (0x1UL << RAMECC_IER_GIE_Pos)           /*!< 0x00000001 */
#define RAMECC_IER_GIE                 RAMECC_IER_GIE_Msk                      /*!< Global interrupt enable */
#define RAMECC_IER_GECCSEIE_Pos        (1U)
#define RAMECC_IER_GECCSEIE_Msk        (0x1UL << RAMECC_IER_GECCSEIE_Pos)      /*!< 0x00000002 */
#define RAMECC_IER_GECCSEIE            RAMECC_IER_GECCSEIE_Msk                 /*!< Global ECC single error interrupt enable */
#define RAMECC_IER_GECCDEIE_Pos        (2U)
#define RAMECC_IER_GECCDEIE_Msk        (0x1UL << RAMECC_IER_GECCDEIE_Pos)      /*!< 0x00000004 */
#define RAMECC_IER_GECCDEIE            RAMECC_IER_GECCDEIE_Msk                 /*!< Global ECC double error interrupt enable */
#define RAMECC_IER_GECCDEBWIE_Pos      (3U)
#define RAMECC_IER_GECCDEBWIE_Msk      (0x1UL << RAMECC_IER_GECCDEBWIE_Pos)    /*!< 0x00000008 */
#define RAMECC_IER_GECCDEBWIE          RAMECC_IER_GECCDEBWIE_Msk               /*!< Global ECC double error on byte write (BW) interrupt enable */
#define RAMECC_CR_ECCSEIE_Pos          (2U)
#define RAMECC_CR_ECCSEIE_Msk          (0x1UL << RAMECC_CR_ECCSEIE_Pos)        /*!< 0x00000004 */
#define RAMECC_CR_ECCSEIE              RAMECC_CR_ECCSEIE_Msk                   /*!< ECC single error interrupt enable */
#define RAMECC_CR_ECCDEIE_Pos          (3U)
#define RAMECC_CR_ECCDEIE_Msk          (0x1UL << RAMECC_CR_ECCDEIE_Pos)        /*!< 0x00000008 */
#define RAMECC_CR_ECCDEIE              RAMECC_CR_ECCDEIE_Msk                   /*!< ECC double error interrupt enable */
#define RAMECC_CR_ECCDEBWIE_Pos        (4U)
#define RAMECC_CR_ECCDEBWIE_Msk        (0x1UL << RAMECC_CR_ECCDEBWIE_Pos)      /*!< 0x00000010 */
#define RAMECC_CR_ECCDEBWIE            RAMECC_CR_ECCDEBWIE_Msk                 /*!< ECC double error on byte write (BW) interrupt enable */
#define RAMECC_CR_ECCELEN_Pos          (5U)
#define RAMECC_CR_ECCELEN_Msk          (0x1UL << RAMECC_CR_ECCELEN_Pos)        /*!< 0x00000020 */
#define RAMECC_CR_ECCELEN              RAMECC_CR_ECCELEN_Msk                   /*!< ECC error latching enable */
#define RAMECC_SR_SEDCF_Pos            (0U)
#define RAMECC_SR_SEDCF_Msk            (0x1UL << RAMECC_SR_SEDCF_Pos)           /*!< 0x00000001 */
#define RAMECC_SR_SEDCF                RAMECC_SR_SEDCF_Msk                      /*!< ECC single error detected and corrected flag */
#define RAMECC_SR_DEDF_Pos             (1U)
#define RAMECC_SR_DEDF_Msk             (0x1UL << RAMECC_SR_DEDF_Pos)            /*!< 0x00000002 */
#define RAMECC_SR_DEDF                 RAMECC_SR_DEDF_Msk                       /*!< ECC double error detected flag */
#define RAMECC_SR_DEBWDF_Pos           (2U)
#define RAMECC_SR_DEBWDF_Msk           (0x1UL << RAMECC_SR_DEBWDF_Pos)          /*!< 0x00000004 */
#define RAMECC_SR_DEBWDF               RAMECC_SR_DEBWDF_Msk                     /*!< ECC double error on byte write (BW) detected flag */
#define RAMECC_FAR_FADD_Pos            (0U)
#define RAMECC_FAR_FADD_Msk            (0xFFFFFFFFUL << RAMECC_FAR_FADD_Pos)    /*!< 0xFFFFFFFF */
#define RAMECC_FAR_FADD                RAMECC_FAR_FADD_Msk                      /*!< ECC error failing address */
#define RAMECC_FDRL_FDATAL_Pos         (0U)
#define RAMECC_FDRL_FDATAL_Msk         (0xFFFFFFFFUL << RAMECC_FDRL_FDATAL_Pos) /*!< 0xFFFFFFFF */
#define RAMECC_FDRL_FDATAL             RAMECC_FDRL_FDATAL_Msk                   /*!< Failing data low */
#define RAMECC_FDRH_FDATAH_Pos         (0U)
#define RAMECC_FDRH_FDATAH_Msk         (0xFFFFFFFFUL << RAMECC_FDRH_FDATAH_Pos) /*!< 0xFFFFFFFF */
#define RAMECC_FDRH_FDATAH             RAMECC_FDRH_FDATAH_Msk                   /* Failing data high (64-bit memory) */
#define RAMECC_FECR_FEC_Pos            (0U)
#define RAMECC_FECR_FEC_Msk            (0xFFFFFFFFUL << RAMECC_FECR_FEC_Pos)   /*!< 0xFFFFFFFF */
#define RAMECC_FECR_FEC                RAMECC_FECR_FEC_Msk                     /*!< Failing error code */
