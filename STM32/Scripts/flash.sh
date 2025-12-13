#!/bin/bash
# Script to flash compiled firmware to STM32 board

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BUILD_DIR="${BUILD_DIR:-build}"
FIRMWARE_BIN="${FIRMWARE_BIN:-$BUILD_DIR/*.bin}"
FLASH_ADDRESS="${FLASH_ADDRESS:-0x8000000}"
FLASH_METHOD="${FLASH_METHOD:-stlink}"

echo "========================================"
echo "⚡ STM32 Flash Programming Script"
echo "========================================"
echo ""

# Expand wildcard for firmware file (safely)
if [[ "$FIRMWARE_BIN" == *"*"* ]]; then
    # Contains wildcard, expand it safely
    shopt -s nullglob
    FILES=($FIRMWARE_BIN)
    FIRMWARE_BIN="${FILES[0]}"
    shopt -u nullglob
fi

# Check if firmware file exists
if [ ! -f "$FIRMWARE_BIN" ]; then
    echo -e "${RED}❌ Error: Firmware file not found: $FIRMWARE_BIN${NC}"
    echo "Please build the project first:"
    echo "  make"
    echo "  or: ./build.sh"
    exit 1
fi

echo -e "${BLUE}Firmware File:${NC} $FIRMWARE_BIN"
echo -e "${BLUE}Flash Address:${NC} $FLASH_ADDRESS"
echo -e "${BLUE}Flash Method:${NC} $FLASH_METHOD"
echo -e "${BLUE}File Size:${NC} $(if [[ "$OSTYPE" == "darwin"* ]]; then stat -f%z "$FIRMWARE_BIN"; else stat -c%s "$FIRMWARE_BIN"; fi) bytes"
echo ""

# Function to flash using st-link
flash_stlink() {
    if ! command -v st-flash &> /dev/null; then
        echo -e "${RED}❌ Error: st-flash not found!${NC}"
        echo "Please install stlink tools:"
        echo "  https://github.com/stlink-org/stlink"
        return 1
    fi
    
    echo -e "${YELLOW}Checking ST-Link connection...${NC}"
    if ! st-info --probe &> /dev/null; then
        echo -e "${RED}❌ Error: ST-Link not detected!${NC}"
        echo ""
        echo "Troubleshooting:"
        echo "  1. Check USB cable connection"
        echo "  2. Ensure ST-Link is connected to target board"
        echo "  3. Verify power supply to target"
        echo "  4. Check udev rules (Linux): /etc/udev/rules.d/49-stlinkv2.rules"
        return 1
    fi
    
    echo -e "${GREEN}✓ ST-Link detected${NC}"
    st-info --probe
    echo ""
    
    echo -e "${YELLOW}Flashing firmware...${NC}"
    if st-flash write "$FIRMWARE_BIN" "$FLASH_ADDRESS"; then
        echo ""
        echo -e "${GREEN}✅ Flash successful!${NC}"
        return 0
    else
        echo ""
        echo -e "${RED}❌ Flash failed!${NC}"
        return 1
    fi
}

# Function to flash using OpenOCD
flash_openocd() {
    if ! command -v openocd &> /dev/null; then
        echo -e "${RED}❌ Error: openocd not found!${NC}"
        echo "Please install OpenOCD:"
        echo "  Ubuntu/Debian: sudo apt install openocd"
        echo "  macOS: brew install openocd"
        return 1
    fi
    
    # Detect appropriate config files
    INTERFACE_CFG="${OPENOCD_INTERFACE:-interface/stlink.cfg}"
    TARGET_CFG="${OPENOCD_TARGET:-target/stm32f4x.cfg}"
    
    echo -e "${YELLOW}Flashing with OpenOCD...${NC}"
    echo "Interface: $INTERFACE_CFG"
    echo "Target: $TARGET_CFG"
    echo ""
    
    if openocd -f "$INTERFACE_CFG" -f "$TARGET_CFG" \
        -c "program $FIRMWARE_BIN verify reset exit $FLASH_ADDRESS"; then
        echo ""
        echo -e "${GREEN}✅ Flash successful!${NC}"
        return 0
    else
        echo ""
        echo -e "${RED}❌ Flash failed!${NC}"
        return 1
    fi
}

# Function to flash using STM32CubeProgrammer CLI
flash_cubeprog() {
    if ! command -v STM32_Programmer_CLI &> /dev/null; then
        echo -e "${RED}❌ Error: STM32_Programmer_CLI not found!${NC}"
        echo "Please install STM32CubeProgrammer:"
        echo "  https://www.st.com/en/development-tools/stm32cubeprog.html"
        return 1
    fi
    
    echo -e "${YELLOW}Flashing with STM32CubeProgrammer...${NC}"
    echo ""
    
    if STM32_Programmer_CLI -c port=SWD -w "$FIRMWARE_BIN" "$FLASH_ADDRESS" -v -rst; then
        echo ""
        echo -e "${GREEN}✅ Flash successful!${NC}"
        return 0
    else
        echo ""
        echo -e "${RED}❌ Flash failed!${NC}"
        return 1
    fi
}

# Flash using selected method
case "$FLASH_METHOD" in
    stlink|st-link)
        flash_stlink
        ;;
    openocd)
        flash_openocd
        ;;
    cubeprog|stm32cubeprog)
        flash_cubeprog
        ;;
    *)
        echo -e "${RED}❌ Error: Unknown flash method: $FLASH_METHOD${NC}"
        echo "Supported methods: stlink, openocd, cubeprog"
        echo ""
        echo "Usage examples:"
        echo "  FLASH_METHOD=stlink ./flash.sh"
        echo "  FLASH_METHOD=openocd ./flash.sh"
        exit 1
        ;;
esac

exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 Device programmed successfully!${NC}"
    echo ""
    echo "The STM32 should now be running your firmware."
    echo "Use a serial terminal or debugger to verify operation."
else
    echo ""
    echo -e "${RED}⚠️  Flash operation failed${NC}"
    echo ""
    echo "Troubleshooting steps:"
    echo "  1. Verify board connection"
    echo "  2. Check power supply"
    echo "  3. Try: st-flash erase"
    echo "  4. Try flashing with reset: st-flash --connect-under-reset write ..."
    echo "  5. Update ST-Link firmware"
fi

exit $exit_code
