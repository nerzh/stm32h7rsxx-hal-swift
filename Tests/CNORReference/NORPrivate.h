#define NOR_CMD_ADDRESS_FIRST_BYTE            (uint16_t)0x0AAA
#define NOR_CMD_ADDRESS_FIRST_CFI_BYTE        (uint16_t)0x00AA
#define NOR_CMD_ADDRESS_SECOND_BYTE           (uint16_t)0x0555
#define NOR_CMD_ADDRESS_THIRD_BYTE            (uint16_t)0x0AAA

#define NOR_CMD_ADDRESS_FIRST                 (uint16_t)0x0555
#define NOR_CMD_ADDRESS_FIRST_CFI             (uint16_t)0x0055
#define NOR_CMD_ADDRESS_SECOND                (uint16_t)0x02AA
#define NOR_CMD_ADDRESS_THIRD                 (uint16_t)0x0555
#define NOR_CMD_ADDRESS_FOURTH                (uint16_t)0x0555
#define NOR_CMD_ADDRESS_FIFTH                 (uint16_t)0x02AA
#define NOR_CMD_ADDRESS_SIXTH                 (uint16_t)0x0555

/* Constants to define data to program a command */
#define NOR_CMD_DATA_READ_RESET               (uint16_t)0x00F0
#define NOR_CMD_DATA_FIRST                    (uint16_t)0x00AA
#define NOR_CMD_DATA_SECOND                   (uint16_t)0x0055
#define NOR_CMD_DATA_AUTO_SELECT              (uint16_t)0x0090
#define NOR_CMD_DATA_PROGRAM                  (uint16_t)0x00A0
#define NOR_CMD_DATA_CHIP_BLOCK_ERASE_THIRD   (uint16_t)0x0080
#define NOR_CMD_DATA_CHIP_BLOCK_ERASE_FOURTH  (uint16_t)0x00AA
#define NOR_CMD_DATA_CHIP_BLOCK_ERASE_FIFTH   (uint16_t)0x0055
#define NOR_CMD_DATA_CHIP_ERASE               (uint16_t)0x0010
#define NOR_CMD_DATA_CFI                      (uint16_t)0x0098

#define NOR_CMD_DATA_BUFFER_AND_PROG          (uint8_t)0x25
#define NOR_CMD_DATA_BUFFER_AND_PROG_CONFIRM  (uint8_t)0x29
#define NOR_CMD_DATA_BLOCK_ERASE              (uint8_t)0x30

#define NOR_CMD_READ_ARRAY                    (uint16_t)0x00FF
#define NOR_CMD_WORD_PROGRAM                  (uint16_t)0x0040
#define NOR_CMD_BUFFERED_PROGRAM              (uint16_t)0x00E8
#define NOR_CMD_CONFIRM                       (uint16_t)0x00D0
#define NOR_CMD_BLOCK_ERASE                   (uint16_t)0x0020
#define NOR_CMD_BLOCK_UNLOCK                  (uint16_t)0x0060
#define NOR_CMD_READ_STATUS_REG               (uint16_t)0x0070
#define NOR_CMD_CLEAR_STATUS_REG              (uint16_t)0x0050

/* Mask on NOR STATUS REGISTER */
#define NOR_MASK_STATUS_DQ4                   (uint16_t)0x0010
#define NOR_MASK_STATUS_DQ5                   (uint16_t)0x0020
#define NOR_MASK_STATUS_DQ6                   (uint16_t)0x0040
#define NOR_MASK_STATUS_DQ7                   (uint16_t)0x0080

/* Address of the primary command set */
#define NOR_ADDRESS_COMMAND_SET               (uint16_t)0x0013

/* Command set code assignment (defined in JEDEC JEP137B version may 2004) */
#define NOR_INTEL_SHARP_EXT_COMMAND_SET       (uint16_t)0x0001 /* Supported in this driver */
#define NOR_AMD_FUJITSU_COMMAND_SET           (uint16_t)0x0002 /* Supported in this driver */
#define NOR_INTEL_STANDARD_COMMAND_SET        (uint16_t)0x0003 /* Not Supported in this driver */
#define NOR_AMD_FUJITSU_EXT_COMMAND_SET       (uint16_t)0x0004 /* Not Supported in this driver */
#define NOR_WINDBOND_STANDARD_COMMAND_SET     (uint16_t)0x0006 /* Not Supported in this driver */
#define NOR_MITSUBISHI_STANDARD_COMMAND_SET   (uint16_t)0x0100 /* Not Supported in this driver */
#define NOR_MITSUBISHI_EXT_COMMAND_SET        (uint16_t)0x0101 /* Not Supported in this driver */
#define NOR_PAGE_WRITE_COMMAND_SET            (uint16_t)0x0102 /* Not Supported in this driver */
#define NOR_INTEL_PERFORMANCE_COMMAND_SET     (uint16_t)0x0200 /* Not Supported in this driver */
#define NOR_INTEL_DATA_COMMAND_SET            (uint16_t)0x0210 /* Not Supported in this driver */

/**
  * @}
  */

