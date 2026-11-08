// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_EnableARPOffload(ETH_HandleTypeDef *heth)
{
  SET_BIT(heth->Instance->MACCR, ETH_MACCR_ARP);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_DisableARPOffload(ETH_HandleTypeDef *heth)
{
  CLEAR_BIT(heth->Instance->MACCR, ETH_MACCR_ARP);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_SetARPAddressMatch(ETH_HandleTypeDef *heth, uint32_t IpAddress)
{
  WRITE_REG(heth->Instance->MACARPAR, IpAddress);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_SetL4FilterConfig(ETH_HandleTypeDef *heth, uint32_t Filter,
                                              const ETH_L4FilterConfigTypeDef *pL4FilterConfig)
{
  if (pL4FilterConfig == NULL)
  {
    return HAL_ERROR;
  }

  if (Filter == ETH_L4_FILTER_0)
  {
    /* Write configuration to MACL3L4C0R register */
    MODIFY_REG(heth->Instance->MACL3L4C0R, ETH_MACL4CR_MASK, (pL4FilterConfig->Protocol |
                                                              pL4FilterConfig->SrcPortFilterMatch |
                                                              pL4FilterConfig->DestPortFilterMatch));

    /* Write configuration to MACL4A0R register */
    WRITE_REG(heth->Instance->MACL4A0R, (pL4FilterConfig->SourcePort | (pL4FilterConfig->DestinationPort << 16)));

  }
  else /* Filter == ETH_L4_FILTER_1 */
  {
    /* Write configuration to MACL3L4C1R register */
    MODIFY_REG(heth->Instance->MACL3L4C1R, ETH_MACL4CR_MASK, (pL4FilterConfig->Protocol |
                                                              pL4FilterConfig->SrcPortFilterMatch |
                                                              pL4FilterConfig->DestPortFilterMatch));

    /* Write configuration to MACL4A1R register */
    WRITE_REG(heth->Instance->MACL4A1R, (pL4FilterConfig->SourcePort | (pL4FilterConfig->DestinationPort << 16)));
  }

  /* Enable L4 filter */
  SET_BIT(heth->Instance->MACPFR, ETH_MACPFR_IPFE);

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_GetL4FilterConfig(const ETH_HandleTypeDef *heth, uint32_t Filter,
                                              ETH_L4FilterConfigTypeDef *pL4FilterConfig)
{
  if (pL4FilterConfig == NULL)
  {
    return HAL_ERROR;
  }

  if (Filter == ETH_L4_FILTER_0)
  {
    /* Get configuration from MACL3L4C0R register */
    pL4FilterConfig->Protocol = READ_BIT(heth->Instance->MACL3L4C0R, ETH_MACL3L4CR_L4PEN);
    pL4FilterConfig->DestPortFilterMatch = READ_BIT(heth->Instance->MACL3L4C0R,
                                                    (ETH_MACL3L4CR_L4DPM | ETH_MACL3L4CR_L4DPIM));
    pL4FilterConfig->SrcPortFilterMatch = READ_BIT(heth->Instance->MACL3L4C0R,
                                                   (ETH_MACL3L4CR_L4SPM | ETH_MACL3L4CR_L4SPIM));

    /* Get configuration from MACL4A0R register */
    pL4FilterConfig->DestinationPort = (READ_BIT(heth->Instance->MACL4A0R, ETH_MAC_L4_DSTP_MASK) >> 16);
    pL4FilterConfig->SourcePort = READ_BIT(heth->Instance->MACL4A0R, ETH_MAC_L4_SRSP_MASK);
  }
  else /* Filter == ETH_L4_FILTER_1 */
  {
    /* Get configuration from MACL3L4C1R register */
    pL4FilterConfig->Protocol = READ_BIT(heth->Instance->MACL3L4C1R, ETH_MACL3L4CR_L4PEN);
    pL4FilterConfig->DestPortFilterMatch = READ_BIT(heth->Instance->MACL3L4C1R,
                                                    (ETH_MACL3L4CR_L4DPM | ETH_MACL3L4CR_L4DPIM));
    pL4FilterConfig->SrcPortFilterMatch = READ_BIT(heth->Instance->MACL3L4C1R,
                                                   (ETH_MACL3L4CR_L4SPM | ETH_MACL3L4CR_L4SPIM));

    /* Get configuration from MACL4A1R register */
    pL4FilterConfig->DestinationPort = (READ_BIT(heth->Instance->MACL4A1R, ETH_MAC_L4_DSTP_MASK) >> 16);
    pL4FilterConfig->SourcePort = READ_BIT(heth->Instance->MACL4A1R, ETH_MAC_L4_SRSP_MASK);
  }

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_SetL3FilterConfig(ETH_HandleTypeDef *heth, uint32_t Filter,
                                              const ETH_L3FilterConfigTypeDef *pL3FilterConfig)
{
  if (pL3FilterConfig == NULL)
  {
    return HAL_ERROR;
  }

  if (Filter == ETH_L3_FILTER_0)
  {
    /* Write configuration to MACL3L4C0R register */
    MODIFY_REG(heth->Instance->MACL3L4C0R, ETH_MACL3CR_MASK, (pL3FilterConfig->Protocol |
                                                              pL3FilterConfig->SrcAddrFilterMatch |
                                                              pL3FilterConfig->DestAddrFilterMatch |
                                                              (pL3FilterConfig->SrcAddrHigherBitsMatch << 6) |
                                                              (pL3FilterConfig->DestAddrHigherBitsMatch << 11)));
  }
  else  /* Filter == ETH_L3_FILTER_1 */
  {
    /* Write configuration to MACL3L4C1R register */
    MODIFY_REG(heth->Instance->MACL3L4C1R, ETH_MACL3CR_MASK, (pL3FilterConfig->Protocol |
                                                              pL3FilterConfig->SrcAddrFilterMatch |
                                                              pL3FilterConfig->DestAddrFilterMatch |
                                                              (pL3FilterConfig->SrcAddrHigherBitsMatch << 6) |
                                                              (pL3FilterConfig->DestAddrHigherBitsMatch << 11)));
  }

  if (Filter == ETH_L3_FILTER_0)
  {
    /* Check if IPv6 protocol is selected */
    if (pL3FilterConfig->Protocol != ETH_L3_IPV4_MATCH)
    {
      /* Set the IPv6 address match */
      /* Set Bits[31:0] of 128-bit IP addr */
      WRITE_REG(heth->Instance->MACL3A0R0R, pL3FilterConfig->Ip6Addr[0]);
      /* Set Bits[63:32] of 128-bit IP addr */
      WRITE_REG(heth->Instance->MACL3A1R0R, pL3FilterConfig->Ip6Addr[1]);
      /* update Bits[95:64] of 128-bit IP addr */
      WRITE_REG(heth->Instance->MACL3A2R0R, pL3FilterConfig->Ip6Addr[2]);
      /* update Bits[127:96] of 128-bit IP addr */
      WRITE_REG(heth->Instance->MACL3A3R0R, pL3FilterConfig->Ip6Addr[3]);
    }
    else /* IPv4 protocol is selected */
    {
      /* Set the IPv4 source address match */
      WRITE_REG(heth->Instance->MACL3A0R0R, pL3FilterConfig->Ip4SrcAddr);
      /* Set the IPv4 destination address match */
      WRITE_REG(heth->Instance->MACL3A1R0R, pL3FilterConfig->Ip4DestAddr);
    }
  }
  else  /* Filter == ETH_L3_FILTER_1 */
  {
    /* Check if IPv6 protocol is selected */
    if (pL3FilterConfig->Protocol != ETH_L3_IPV4_MATCH)
    {
      /* Set the IPv6 address match */
      /* Set Bits[31:0] of 128-bit IP addr */
      WRITE_REG(heth->Instance->MACL3A0R1R, pL3FilterConfig->Ip6Addr[0]);
      /* Set Bits[63:32] of 128-bit IP addr */
      WRITE_REG(heth->Instance->MACL3A1R1R, pL3FilterConfig->Ip6Addr[1]);
      /* update Bits[95:64] of 128-bit IP addr */
      WRITE_REG(heth->Instance->MACL3A1R1R, pL3FilterConfig->Ip6Addr[2]);
      /* update Bits[127:96] of 128-bit IP addr */
      WRITE_REG(heth->Instance->MACL3A1R1R, pL3FilterConfig->Ip6Addr[3]);
    }
    else /* IPv4 protocol is selected */
    {
      /* Set the IPv4 source address match */
      WRITE_REG(heth->Instance->MACL3A0R1R, pL3FilterConfig->Ip4SrcAddr);
      /* Set the IPv4 destination address match */
      WRITE_REG(heth->Instance->MACL3A0R1R, pL3FilterConfig->Ip4DestAddr);

    }
  }

  /* Enable L3 filter */
  SET_BIT(heth->Instance->MACPFR, ETH_MACPFR_IPFE);

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_GetL3FilterConfig(const ETH_HandleTypeDef *heth, uint32_t Filter,
                                              ETH_L3FilterConfigTypeDef *pL3FilterConfig)
{
  if (pL3FilterConfig == NULL)
  {
    return HAL_ERROR;
  }
  pL3FilterConfig->Protocol = READ_BIT(*((__IO uint32_t *)(&(heth->Instance->MACL3L4C0R) + Filter)),
                                       ETH_MACL3L4CR_L3PEN);
  pL3FilterConfig->SrcAddrFilterMatch = READ_BIT(*((__IO uint32_t *)(&(heth->Instance->MACL3L4C0R) + Filter)),
                                                 (ETH_MACL3L4CR_L3SAM | ETH_MACL3L4CR_L3SAIM));
  pL3FilterConfig->DestAddrFilterMatch = READ_BIT(*((__IO uint32_t *)(&(heth->Instance->MACL3L4C0R) + Filter)),
                                                  (ETH_MACL3L4CR_L3DAM | ETH_MACL3L4CR_L3DAIM));
  pL3FilterConfig->SrcAddrHigherBitsMatch = (READ_BIT(*((__IO uint32_t *)(&(heth->Instance->MACL3L4C0R) + Filter)),
                                                      ETH_MACL3L4CR_L3HSBM) >> 6);
  pL3FilterConfig->DestAddrHigherBitsMatch = (READ_BIT(*((__IO uint32_t *)(&(heth->Instance->MACL3L4C0R) + Filter)),
                                                       ETH_MACL3L4CR_L3HDBM) >> 11);

  if (Filter == ETH_L3_FILTER_0)
  {
    if (pL3FilterConfig->Protocol != ETH_L3_IPV4_MATCH)
    {
      WRITE_REG(pL3FilterConfig->Ip6Addr[0], heth->Instance->MACL3A0R0R);
      WRITE_REG(pL3FilterConfig->Ip6Addr[1], heth->Instance->MACL3A1R0R);
      WRITE_REG(pL3FilterConfig->Ip6Addr[2], heth->Instance->MACL3A2R0R);
      WRITE_REG(pL3FilterConfig->Ip6Addr[3], heth->Instance->MACL3A3R0R);
    }
    else
    {
      WRITE_REG(pL3FilterConfig->Ip4SrcAddr, heth->Instance->MACL3A0R0R);
      WRITE_REG(pL3FilterConfig->Ip4DestAddr, heth->Instance->MACL3A1R0R);
    }
  }
  else /* ETH_L3_FILTER_1 */
  {
    if (pL3FilterConfig->Protocol != ETH_L3_IPV4_MATCH)
    {
      WRITE_REG(pL3FilterConfig->Ip6Addr[0], heth->Instance->MACL3A0R1R);
      WRITE_REG(pL3FilterConfig->Ip6Addr[1], heth->Instance->MACL3A1R1R);
      WRITE_REG(pL3FilterConfig->Ip6Addr[2], heth->Instance->MACL3A2R1R);
      WRITE_REG(pL3FilterConfig->Ip6Addr[3], heth->Instance->MACL3A3R1R);
    }
    else
    {
      WRITE_REG(pL3FilterConfig->Ip4SrcAddr, heth->Instance->MACL3A0R1R);
      WRITE_REG(pL3FilterConfig->Ip4DestAddr, heth->Instance->MACL3A1R1R);
    }
  }

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_EnableL3L4Filtering(ETH_HandleTypeDef *heth)
{
  /* Enable L3/L4 filter */
  SET_BIT(heth->Instance->MACPFR, ETH_MACPFR_IPFE);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_DisableL3L4Filtering(ETH_HandleTypeDef *heth)
{
  /* Disable L3/L4 filter */
  CLEAR_BIT(heth->Instance->MACPFR, ETH_MACPFR_IPFE);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_GetRxVLANConfig(const ETH_HandleTypeDef *heth, ETH_RxVLANConfigTypeDef *pVlanConfig)
{
  if (pVlanConfig == NULL)
  {
    return HAL_ERROR;
  }

  pVlanConfig->InnerVLANTagInStatus = ((READ_BIT(heth->Instance->MACVTR,
                                                 ETH_MACVTR_EIVLRXS) >> 31) == 0U) ? DISABLE : ENABLE;
  pVlanConfig->StripInnerVLANTag  = READ_BIT(heth->Instance->MACVTR, ETH_MACVTR_EIVLS);
  pVlanConfig->InnerVLANTag = ((READ_BIT(heth->Instance->MACVTR,
                                         ETH_MACVTR_ERIVLT) >> 27) == 0U) ? DISABLE : ENABLE;
  pVlanConfig->DoubleVLANProcessing = ((READ_BIT(heth->Instance->MACVTR,
                                                 ETH_MACVTR_EDVLP) >> 26) == 0U) ? DISABLE : ENABLE;
  pVlanConfig->VLANTagHashTableMatch = ((READ_BIT(heth->Instance->MACVTR,
                                                  ETH_MACVTR_VTHM) >> 25) == 0U) ? DISABLE : ENABLE;
  pVlanConfig->VLANTagInStatus = ((READ_BIT(heth->Instance->MACVTR,
                                            ETH_MACVTR_EVLRXS) >> 24) == 0U) ? DISABLE : ENABLE;
  pVlanConfig->StripVLANTag = READ_BIT(heth->Instance->MACVTR, ETH_MACVTR_EVLS);
  pVlanConfig->VLANTypeCheck = READ_BIT(heth->Instance->MACVTR,
                                        (ETH_MACVTR_DOVLTC | ETH_MACVTR_ERSVLM | ETH_MACVTR_ESVL));
  pVlanConfig->VLANTagInverceMatch = ((READ_BIT(heth->Instance->MACVTR, ETH_MACVTR_VTIM) >> 17) == 0U)
                                     ? DISABLE : ENABLE;

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_SetRxVLANConfig(ETH_HandleTypeDef *heth, const ETH_RxVLANConfigTypeDef *pVlanConfig)
{
  if (pVlanConfig == NULL)
  {
    return HAL_ERROR;
  }

  /* Write config to MACVTR */
  MODIFY_REG(heth->Instance->MACVTR, ETH_MACRXVLAN_MASK, (((uint32_t)pVlanConfig->InnerVLANTagInStatus << 31) |
                                                          pVlanConfig->StripInnerVLANTag |
                                                          ((uint32_t)pVlanConfig->InnerVLANTag << 27) |
                                                          ((uint32_t)pVlanConfig->DoubleVLANProcessing << 26) |
                                                          ((uint32_t)pVlanConfig->VLANTagHashTableMatch << 25) |
                                                          ((uint32_t)pVlanConfig->VLANTagInStatus << 24) |
                                                          pVlanConfig->StripVLANTag |
                                                          pVlanConfig->VLANTypeCheck |
                                                          ((uint32_t)pVlanConfig->VLANTagInverceMatch << 17)));

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_SetVLANHashTable(ETH_HandleTypeDef *heth, uint32_t VLANHashTable)
{
  MODIFY_REG(heth->Instance->MACVHTR, ETH_MACVHTR_VLHT, VLANHashTable);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_GetTxVLANConfig(const ETH_HandleTypeDef *heth, uint32_t VLANTag,
                                            ETH_TxVLANConfigTypeDef *pVlanConfig)
{
  if (pVlanConfig == NULL)
  {
    return HAL_ERROR;
  }

  if (VLANTag == ETH_INNER_TX_VLANTAG)
  {
    pVlanConfig->SourceTxDesc = ((READ_BIT(heth->Instance->MACIVIR, ETH_MACVIR_VLTI) >> 20) == 0U) ? DISABLE : ENABLE;
    pVlanConfig->SVLANType = ((READ_BIT(heth->Instance->MACIVIR, ETH_MACVIR_CSVL) >> 19) == 0U) ? DISABLE : ENABLE;
    pVlanConfig->VLANTagControl = READ_BIT(heth->Instance->MACIVIR, (ETH_MACVIR_VLP | ETH_MACVIR_VLC));
  }
  else
  {
    pVlanConfig->SourceTxDesc = ((READ_BIT(heth->Instance->MACVIR, ETH_MACVIR_VLTI) >> 20) == 0U) ? DISABLE : ENABLE;
    pVlanConfig->SVLANType = ((READ_BIT(heth->Instance->MACVIR, ETH_MACVIR_CSVL) >> 19) == 0U) ? DISABLE : ENABLE;
    pVlanConfig->VLANTagControl = READ_BIT(heth->Instance->MACVIR, (ETH_MACVIR_VLP | ETH_MACVIR_VLC));
  }

  return HAL_OK;;
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_SetTxVLANConfig(ETH_HandleTypeDef *heth, uint32_t VLANTag,
                                            const ETH_TxVLANConfigTypeDef *pVlanConfig)
{
  if (VLANTag == ETH_INNER_TX_VLANTAG)
  {
    MODIFY_REG(heth->Instance->MACIVIR, ETH_MACTXVLAN_MASK, (((uint32_t)pVlanConfig->SourceTxDesc << 20) |
                                                             ((uint32_t)pVlanConfig->SVLANType << 19) |
                                                             pVlanConfig->VLANTagControl));
    /* Enable Double VLAN processing */
    SET_BIT(heth->Instance->MACVTR, ETH_MACVTR_EDVLP);
  }
  else
  {
    MODIFY_REG(heth->Instance->MACVIR, ETH_MACTXVLAN_MASK, (((uint32_t)pVlanConfig->SourceTxDesc << 20) |
                                                            ((uint32_t)pVlanConfig->SVLANType << 19) |
                                                            pVlanConfig->VLANTagControl));
  }

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_SetTxVLANIdentifier(ETH_HandleTypeDef *heth, uint32_t VLANTag, uint32_t VLANIdentifier)
{
  if (VLANTag == ETH_INNER_TX_VLANTAG)
  {
    MODIFY_REG(heth->Instance->MACIVIR, ETH_MACVIR_VLT, VLANIdentifier);
  }
  else
  {
    MODIFY_REG(heth->Instance->MACVIR, ETH_MACVIR_VLT, VLANIdentifier);
  }
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_EnableVLANProcessing(ETH_HandleTypeDef *heth)
{
  /* Enable VLAN processing */
  SET_BIT(heth->Instance->MACPFR, ETH_MACPFR_VTFE);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_DisableVLANProcessing(ETH_HandleTypeDef *heth)
{
  /* Disable VLAN processing */
  CLEAR_BIT(heth->Instance->MACPFR, ETH_MACPFR_VTFE);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_EnterLPIMode(ETH_HandleTypeDef *heth, FunctionalState TxAutomate, FunctionalState TxClockStop)
{
  /* Enable LPI Interrupts */
  __HAL_ETH_MAC_ENABLE_IT(heth, ETH_MACIER_LPIIE);

  /* Write to LPI Control register: Enter low power mode */
  MODIFY_REG(heth->Instance->MACLCSR, (ETH_MACLCSR_LPIEN | ETH_MACLCSR_LPITXA | ETH_MACLCSR_LPITCSE),
             (((uint32_t)TxAutomate << 19) |
              ((uint32_t)TxClockStop << 21) |
              ETH_MACLCSR_LPIEN));
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_ExitLPIMode(ETH_HandleTypeDef *heth)
{
  /* Clear the LPI Config and exit low power mode */
  CLEAR_BIT(heth->Instance->MACLCSR, (ETH_MACLCSR_LPIEN | ETH_MACLCSR_LPITXA | ETH_MACLCSR_LPITCSE));

  /* Enable LPI Interrupts */
  __HAL_ETH_MAC_DISABLE_IT(heth, ETH_MACIER_LPIIE);
}
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
uint32_t HAL_ETHEx_GetMACLPIEvent(const ETH_HandleTypeDef *heth)
{
  return heth->MACLPIEvent;
}
#endif
#endif
