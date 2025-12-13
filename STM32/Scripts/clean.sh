#!/bin/bash
# Script to clean STM32 project build artifacts

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

echo "========================================"
echo "🧹 STM32 Project Clean Script"
echo "========================================"
echo ""

echo -e "${BLUE}Project Directory:${NC} $PROJECT_DIR"
echo -e "${BLUE}Build Directory:${NC} $BUILD_DIR"
echo ""

cd "$PROJECT_DIR"

# Check for Makefile
if [ -f "Makefile" ]; then
    echo -e "${YELLOW}Cleaning with make...${NC}"
    if make clean; then
        echo -e "${GREEN}✅ Make clean successful${NC}"
    else
        echo -e "${YELLOW}⚠️  Make clean had issues, continuing...${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No Makefile found, skipping make clean${NC}"
fi

echo ""

# Remove common build artifacts
echo -e "${YELLOW}Removing build artifacts...${NC}"

# Build directory
if [ -d "$BUILD_DIR" ]; then
    echo "  Removing $BUILD_DIR/"
    rm -rf "$BUILD_DIR"
fi

# Object files
if ls *.o 2>/dev/null | grep -q .; then
    echo "  Removing *.o files"
    rm -f *.o
fi

# Dependency files
if ls *.d 2>/dev/null | grep -q .; then
    echo "  Removing *.d files"
    rm -f *.d
fi

# Map files
if ls *.map 2>/dev/null | grep -q .; then
    echo "  Removing *.map files"
    rm -f *.map
fi

# List files
if ls *.lst 2>/dev/null | grep -q .; then
    echo "  Removing *.lst files"
    rm -f *.lst
fi

# Su files
if ls *.su 2>/dev/null | grep -q .; then
    echo "  Removing *.su files"
    rm -f *.su
fi

echo ""
echo -e "${GREEN}✅ Clean complete!${NC}"
echo ""
echo "Ready for a fresh build:"
echo "  ./build.sh"
echo ""

exit 0
