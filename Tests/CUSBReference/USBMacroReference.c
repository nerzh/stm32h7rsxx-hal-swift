#include "include/CUSBReference.h"
#include "USBDefinitions.h"

void CUSB_ClearEndpointInterrupt(uint32_t *registers, uint32_t endpoint,
                                uint32_t input, uint32_t interrupts) {
    uintptr_t USBx_BASE = (uintptr_t)registers;
    if (input != 0) {
        CLEAR_IN_EP_INTR(endpoint, interrupts);
    } else {
        CLEAR_OUT_EP_INTR(endpoint, interrupts);
    }
}
