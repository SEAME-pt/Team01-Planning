# STM32 Development Guide

Welcome to the STM32 development documentation! This directory contains comprehensive guides, scripts, and resources for compiling and flashing code to STM32 microcontrollers.

## 📚 Documentation

### Getting Started

1. **[STM32_Setup.md](Doc/STM32_Setup.md)** - Initial Development Environment Setup
   - Hardware requirements
   - Software installation (ARM toolchain, ST-Link tools, OpenOCD)
   - Connection setup
   - Verification steps

2. **[STM32_Build.md](Doc/STM32_Build.md)** - Compiling STM32 Projects
   - Build systems (Makefile, CMake, STM32CubeIDE)
   - Compiler flags and optimization
   - Memory management
   - Build configurations
   - Troubleshooting

3. **[STM32_Flash.md](Doc/STM32_Flash.md)** - Programming STM32 Boards
   - Flash methods (ST-Link, OpenOCD, STM32CubeProgrammer, UART)
   - Flash commands and options
   - Verification and debugging
   - Troubleshooting

4. **[Scripts.md](Doc/Scripts.md)** - Automation Scripts
   - Script usage and configuration
   - Workflow examples
   - Customization options

## 🚀 Quick Start

### Prerequisites

Install the ARM GCC toolchain and ST-Link tools:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi

# Install ST-Link tools
git clone https://github.com/stlink-org/stlink.git
cd stlink
make release
cd build/Release
sudo make install
sudo ldconfig
```

### Basic Workflow

1. **Navigate to your STM32 project**
   ```bash
   cd /path/to/your/stm32/project
   ```

2. **Build the project**
   ```bash
   make
   # or use the automation script
   /path/to/Team01-Planning/STM32/Scripts/build.sh
   ```

3. **Flash to board**
   ```bash
   st-flash write build/firmware.bin 0x8000000
   # or use the automation script
   /path/to/Team01-Planning/STM32/Scripts/flash.sh
   ```

4. **Or do both in one command**
   ```bash
   /path/to/Team01-Planning/STM32/Scripts/build_flash.sh
   ```

## 🛠️ Automation Scripts

The `Scripts/` directory contains helpful automation tools:

| Script | Purpose | Usage |
|--------|---------|-------|
| `build.sh` | Compile STM32 project | `./build.sh` |
| `flash.sh` | Flash firmware to board | `./flash.sh` |
| `build_flash.sh` | Build and flash in one command | `./build_flash.sh` |
| `clean.sh` | Remove build artifacts | `./clean.sh` |

All scripts support customization via environment variables. See [Scripts.md](Doc/Scripts.md) for details.

## 🎯 Common Tasks

### Compile for Debug

```bash
BUILD_TYPE=debug ./Scripts/build.sh
```

### Compile for Release (Optimized)

```bash
BUILD_TYPE=release ./Scripts/build.sh
```

### Flash Using Different Methods

```bash
# ST-Link (default)
FLASH_METHOD=stlink ./Scripts/flash.sh

# OpenOCD
FLASH_METHOD=openocd ./Scripts/flash.sh

# STM32CubeProgrammer
FLASH_METHOD=cubeprog ./Scripts/flash.sh
```

### Clean and Rebuild

```bash
./Scripts/clean.sh && ./Scripts/build.sh
```

### Check STM32 Connection

```bash
st-info --probe
```

### Erase Flash

```bash
st-flash erase
```

## 📁 Directory Structure

```
STM32/
├── README.md                   # This file
├── Doc/                        # Documentation
│   ├── STM32_Setup.md         # Environment setup guide
│   ├── STM32_Build.md         # Build process guide
│   ├── STM32_Flash.md         # Flash programming guide
│   └── Scripts.md             # Scripts documentation
└── Scripts/                    # Automation scripts
    ├── build.sh               # Build automation
    ├── flash.sh               # Flash automation
    ├── build_flash.sh         # Combined build & flash
    └── clean.sh               # Clean artifacts
```

## 🔧 Supported Hardware

### STM32 Series
- STM32F0 (Cortex-M0)
- STM32F1 (Cortex-M3)
- STM32F2 (Cortex-M3)
- STM32F3 (Cortex-M4)
- STM32F4 (Cortex-M4F)
- STM32F7 (Cortex-M7)
- STM32H7 (Cortex-M7)
- STM32L0/L1/L4/L5 (Low power)
- STM32G0/G4 (Mainstream)

### Programmers
- ST-Link V2
- ST-Link V2-1
- ST-Link V3
- J-Link (via OpenOCD)
- USB DFU
- UART Bootloader

## 🌐 Resources

### Official Resources
- [STMicroelectronics](https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus.html)
- [STM32 Community Forums](https://community.st.com/)
- [STM32 GitHub Examples](https://github.com/STMicroelectronics)

### Tools
- [ARM GCC Toolchain](https://developer.arm.com/downloads/-/gnu-rm)
- [stlink Tools](https://github.com/stlink-org/stlink)
- [OpenOCD](http://openocd.org/)
- [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html)
- [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html)
- [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html)

### Learning Resources
- [ARM Cortex-M Developer Resources](https://developer.arm.com/architectures/cpu-architecture/m-profile)
- [STM32 Documentation](https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus.html#documentation)
- [Embedded Development Tutorials](https://www.digikey.com/en/maker/tutorials)

## 🤝 Contributing to This Guide

This documentation is part of the Team01-Planning repository. To contribute:

1. Test your changes on real hardware
2. Follow the existing documentation style
3. Update relevant sections
4. Provide clear examples
5. Submit a pull request

## 📝 Notes

- These guides are based on common STM32 development practices
- Scripts are designed to be portable across Linux and macOS
- Always verify connections before flashing
- Keep ST-Link firmware updated for best compatibility
- Back up important firmware before making changes

## 🆘 Getting Help

If you encounter issues:

1. Check the **Troubleshooting** sections in each guide
2. Verify your hardware connections
3. Ensure all software is properly installed
4. Consult the STM32 Community Forums
5. Review the error messages carefully

## 🎓 Project Context

This documentation is part of the **SEAME Team01** project focused on Software-Defined Vehicle (SDV) development. The team uses STM32 microcontrollers for CAN-FD communication and other embedded systems tasks in conjunction with Raspberry Pi 5 and Automotive Grade Linux (AGL).

For more information about the project:
- See the main [README.md](../README.md) in the repository root
- Check the [Daily logs](../Daily/) for team progress
- Review [TSF documentation](../TSF/TSF-RESUME.md) for trustworthy software framework principles

---

**Happy STM32 Development! 🚀**
