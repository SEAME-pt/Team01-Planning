# STM32 Development Setup

This guide provides step-by-step instructions for setting up an STM32 development environment for compiling and flashing code to STM32 microcontrollers.

## Hardware Requirements

### STM32 Board
- STM32 microcontroller board (e.g., STM32F4, STM32F7, STM32H7 series)
- USB cable for power and programming
- ST-Link programmer (often integrated on development boards)

### Development Host
- Linux, macOS, or Windows development machine
- Minimum 4GB RAM (8GB recommended)
- At least 2GB free disk space for tools and libraries

## Software Requirements

### Core Tools

#### 1. ARM GCC Toolchain
The GNU Arm Embedded Toolchain provides the compiler and tools needed to build STM32 projects.

**Installation on Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
```

**Installation on macOS:**
```bash
brew install --cask gcc-arm-embedded
```

**Manual Installation (All platforms):**
Download from [ARM Developer](https://developer.arm.com/downloads/-/gnu-rm)

**Verify installation:**
```bash
arm-none-eabi-gcc --version
```

#### 2. STM32CubeMX (Optional but Recommended)
STM32CubeMX is a graphical tool for configuring STM32 microcontrollers and generating initialization code.

- Download from [STMicroelectronics](https://www.st.com/en/development-tools/stm32cubemx.html)
- Free but requires ST account registration
- Supports all STM32 series
- Generates HAL/LL library code

#### 3. Build Tools
**Make:**
```bash
# Ubuntu/Debian
sudo apt install build-essential make

# macOS (comes with Xcode Command Line Tools)
xcode-select --install
```

**CMake (if using CMake-based projects):**
```bash
# Ubuntu/Debian
sudo apt install cmake

# macOS
brew install cmake
```

### Programming Tools

#### Option 1: ST-Link Tools (Recommended)
The official ST-Link utilities for flashing and debugging.

**Installation on Ubuntu/Debian:**
```bash
# Install dependencies
sudo apt install libusb-1.0-0-dev

# Clone and build stlink tools
git clone https://github.com/stlink-org/stlink.git
cd stlink
make release
cd build/Release
sudo make install
sudo ldconfig
```

**Verify installation:**
```bash
st-info --version
st-flash --version
```

**Udev rules (Linux only):**
Create `/etc/udev/rules.d/49-stlinkv2.rules`:
```
# ST-Link V2
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666"
# ST-Link V2-1
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666"
# ST-Link V3
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", MODE="0666"
```

Then reload udev:
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

#### Option 2: OpenOCD
OpenOCD provides debugging and programming capabilities for many ARM microcontrollers.

**Installation:**
```bash
# Ubuntu/Debian
sudo apt install openocd

# macOS
brew install openocd
```

#### Option 3: STM32CubeProgrammer (GUI)
Official ST programming tool with graphical interface.

- Download from [STMicroelectronics](https://www.st.com/en/development-tools/stm32cubeprog.html)
- Supports ST-Link, UART, USB DFU, and SPI/I2C programming
- Available for Windows, Linux, and macOS

### Development IDEs (Optional)

#### STM32CubeIDE
- Official integrated development environment from ST
- Based on Eclipse with STM32-specific features
- Includes toolchain, debugger, and STM32CubeMX integration
- Free download from [STMicroelectronics](https://www.st.com/en/development-tools/stm32cubeide.html)

#### VS Code with Extensions
- Cortex-Debug extension
- C/C++ extension
- CMake Tools extension (if using CMake)

## Project Structure

A typical STM32 project structure:

```
STM32Project/
├── Core/
│   ├── Inc/           # Header files
│   └── Src/           # Source files
├── Drivers/
│   ├── STM32F4xx_HAL_Driver/  # HAL library
│   └── CMSIS/                  # CMSIS core
├── Makefile           # Build configuration
├── startup_stm32f4xx.s  # Startup code
└── STM32F4xx_FLASH.ld   # Linker script
```

## Hardware Connection

### Using ST-Link
1. **Identify ST-Link pins** on your development board:
   - SWDIO (Serial Wire Debug I/O)
   - SWCLK (Serial Wire Clock)
   - GND (Ground)
   - 3.3V (Power - optional if board is powered separately)

2. **Connect ST-Link to STM32 board:**
   - ST-Link SWDIO → STM32 SWDIO
   - ST-Link SWCLK → STM32 SWCLK
   - ST-Link GND → STM32 GND
   - ST-Link 3.3V → STM32 3.3V (if needed)

3. **Connect ST-Link to computer via USB**

4. **Verify connection:**
   ```bash
   st-info --probe
   ```

### Using UART Bootloader
Some STM32 boards support flashing via UART:
1. Set BOOT0 pin to HIGH (3.3V)
2. Reset the board
3. Connect UART adapter:
   - TX → STM32 RX
   - RX → STM32 TX
   - GND → GND
4. Use `stm32flash` utility

## Quick Start Example

### 1. Clone a Sample Project
```bash
git clone https://github.com/STMicroelectronics/STM32CubeF4.git
cd STM32CubeF4/Projects/STM32F4-Discovery/Examples/GPIO/GPIO_EXTI
```

### 2. Build the Project
```bash
cd SW4STM32/STM32F4-Discovery
make
```

### 3. Flash to Board
```bash
st-flash write build/project.bin 0x8000000
```

## Verification

After setup, verify your installation:

```bash
# Check toolchain
arm-none-eabi-gcc --version

# Check programmer
st-info --probe

# Expected output:
# Found 1 stlink programmers
#  version:    V2J37S27
#  serial:     [serial number]
#  flash:      [flash size] (pagesize: [page size])
#  sram:       [sram size]
#  chipid:     0x[chip id]
#  dev-type:   STM32[series]
```

## Common Issues

### ST-Link Not Detected
- Check USB cable connection
- Verify udev rules are installed (Linux)
- Try different USB port
- Update ST-Link firmware

### Compilation Errors
- Verify ARM toolchain is in PATH
- Check Makefile for correct MCU configuration
- Ensure all HAL libraries are present

### Flash Fails
- Check board power supply
- Verify correct flash address (usually 0x8000000)
- Ensure no other debugger is connected
- Try mass erase: `st-flash erase`

## Next Steps

- See [STM32_Build.md](STM32_Build.md) for compilation instructions
- See [STM32_Flash.md](STM32_Flash.md) for flashing procedures
- See [Scripts.md](Scripts.md) for automation scripts

## Resources

- [STMicroelectronics Official Site](https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus.html)
- [STM32 Community Forums](https://community.st.com/)
- [STM32 GitHub Examples](https://github.com/STMicroelectronics)
- [ARM Cortex-M Developer Resources](https://developer.arm.com/architectures/cpu-architecture/m-profile)
- [stlink Tools Documentation](https://github.com/stlink-org/stlink)
