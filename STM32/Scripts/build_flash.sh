#!/bin/bash
# Script to build and flash STM32 project in one command

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "========================================"
echo "🚀 STM32 Build & Flash Script"
echo "========================================"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Step 1: Build
echo -e "${BLUE}━━━ Step 1: Building Project ━━━${NC}"
echo ""

if [ -f "$SCRIPT_DIR/build.sh" ]; then
    if bash "$SCRIPT_DIR/build.sh"; then
        echo -e "${GREEN}✅ Build completed${NC}"
    else
        echo -e "${RED}❌ Build failed${NC}"
        exit 1
    fi
else
    # Fallback to direct make if build.sh doesn't exist
    echo -e "${YELLOW}Note: build.sh not found, using make directly${NC}"
    if make; then
        echo -e "${GREEN}✅ Build completed${NC}"
    else
        echo -e "${RED}❌ Build failed${NC}"
        exit 1
    fi
fi

echo ""

# Step 2: Flash
echo -e "${BLUE}━━━ Step 2: Flashing Firmware ━━━${NC}"
echo ""

if [ -f "$SCRIPT_DIR/flash.sh" ]; then
    if bash "$SCRIPT_DIR/flash.sh"; then
        echo -e "${GREEN}✅ Flash completed${NC}"
    else
        echo -e "${RED}❌ Flash failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Error: flash.sh not found${NC}"
    exit 1
fi

echo ""
echo "========================================"
echo -e "${GREEN}🎉 Build and Flash Complete!${NC}"
echo "========================================"
echo ""
echo "Your STM32 board should now be running the new firmware."
echo ""

exit 0
