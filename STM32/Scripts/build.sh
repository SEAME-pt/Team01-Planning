#!/bin/bash
# Script to build STM32 project

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project configuration
PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
BUILD_DIR="${BUILD_DIR:-build}"
BUILD_TYPE="${BUILD_TYPE:-debug}"

echo "========================================"
echo "🔨 STM32 Project Build Script"
echo "========================================"
echo ""

# Check for ARM toolchain
if ! command -v arm-none-eabi-gcc &> /dev/null; then
    echo -e "${RED}❌ Error: ARM GCC toolchain not found!${NC}"
    echo "Please install arm-none-eabi-gcc"
    echo "  Ubuntu/Debian: sudo apt install gcc-arm-none-eabi"
    echo "  macOS: brew install --cask gcc-arm-embedded"
    exit 1
fi

echo -e "${BLUE}Project Directory:${NC} $PROJECT_DIR"
echo -e "${BLUE}Build Directory:${NC} $BUILD_DIR"
echo -e "${BLUE}Build Type:${NC} $BUILD_TYPE"
echo -e "${BLUE}Toolchain Version:${NC} $(arm-none-eabi-gcc --version | head -n1)"
echo ""

# Check for Makefile
if [ ! -f "$PROJECT_DIR/Makefile" ]; then
    echo -e "${RED}❌ Error: Makefile not found in $PROJECT_DIR${NC}"
    echo "Please ensure you're in the correct project directory."
    exit 1
fi

# Build the project
echo -e "${YELLOW}Building project...${NC}"
echo ""

cd "$PROJECT_DIR"

# Set number of parallel jobs
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

if make -j"$JOBS" BUILD_TYPE="$BUILD_TYPE"; then
    echo ""
    echo -e "${GREEN}✅ Build successful!${NC}"
    echo ""
    
    # Show build artifacts
    if [ -d "$BUILD_DIR" ]; then
        echo "📦 Build artifacts:"
        ls -lh "$BUILD_DIR"/*.elf "$BUILD_DIR"/*.bin "$BUILD_DIR"/*.hex 2>/dev/null || true
        echo ""
        
        # Show memory usage
        if [ -f "$BUILD_DIR"/*.elf ]; then
            echo "📊 Memory usage:"
            arm-none-eabi-size "$BUILD_DIR"/*.elf
            echo ""
        fi
    fi
    
    echo -e "${GREEN}Next steps:${NC}"
    echo "  - Flash to board: ./flash.sh"
    echo "  - Build and flash: ./build_flash.sh"
    exit 0
else
    echo ""
    echo -e "${RED}❌ Build failed!${NC}"
    echo ""
    echo "Common issues:"
    echo "  - Missing source files"
    echo "  - Incorrect include paths"
    echo "  - Syntax errors in code"
    echo "  - Wrong MCU configuration in Makefile"
    echo ""
    exit 1
fi
