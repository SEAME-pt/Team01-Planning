# STM32 Development Scripts Documentation

This directory contains automation scripts to streamline STM32 development workflows. These scripts simplify building, flashing, and managing STM32 projects.

## 🚀 Quick Start

All scripts are located in the `Scripts/` directory and should be executable:

```bash
cd Scripts/
chmod +x *.sh  # Make scripts executable (first time only)
```

## 📜 Available Scripts

### 1. `build.sh` - Build STM32 Project

**Purpose:** Compiles the STM32 project using the Makefile with parallel compilation for faster builds.

**Usage:**
```bash
./build.sh
```

**With custom settings:**
```bash
PROJECT_DIR=/path/to/project ./build.sh
BUILD_TYPE=release ./build.sh
```

**What it does:**
- Checks for ARM GCC toolchain
- Verifies Makefile exists
- Compiles project with parallel jobs
- Shows memory usage statistics
- Displays build artifacts

**Environment Variables:**
- `PROJECT_DIR` - Project directory (default: current directory)
- `BUILD_DIR` - Build output directory (default: `build`)
- `BUILD_TYPE` - Build configuration: `debug` or `release` (default: `debug`)

**Output:**
- Compiled binaries in `build/` directory
- Memory usage report
- Build artifacts list

**When to use:** Before flashing new code or testing changes.

---

### 2. `flash.sh` - Flash Firmware to STM32

**Purpose:** Programs compiled firmware to STM32 board using various flash methods.

**Usage:**
```bash
./flash.sh
```

**With custom settings:**
```bash
FLASH_METHOD=stlink ./flash.sh
FLASH_METHOD=openocd OPENOCD_TARGET=target/stm32f7x.cfg ./flash.sh
FIRMWARE_BIN=custom_firmware.bin ./flash.sh
```

**What it does:**
- Checks for firmware binary
- Detects programmer connection
- Flashes firmware to board
- Verifies programming success
- Resets MCU after programming

**Supported Flash Methods:**
- `stlink` - ST-Link tools (default, recommended)
- `openocd` - OpenOCD
- `cubeprog` - STM32CubeProgrammer CLI

**Environment Variables:**
- `FIRMWARE_BIN` - Firmware file to flash (default: `build/*.bin`)
- `FLASH_ADDRESS` - Flash start address (default: `0x8000000`)
- `FLASH_METHOD` - Programming method (default: `stlink`)
- `OPENOCD_INTERFACE` - OpenOCD interface config (default: `interface/stlink.cfg`)
- `OPENOCD_TARGET` - OpenOCD target config (default: `target/stm32f4x.cfg`)

**When to use:** After successful build to deploy firmware to hardware.

---

### 3. `build_flash.sh` - Build and Flash in One Command

**Purpose:** Combines build and flash operations for rapid development iteration.

**Usage:**
```bash
./build_flash.sh
```

**What it does:**
- Runs `build.sh` to compile project
- Automatically runs `flash.sh` if build succeeds
- Provides clear status for each step
- Stops if build fails (won't flash bad firmware)

**Environment Variables:**
Accepts all variables from both `build.sh` and `flash.sh`:
```bash
BUILD_TYPE=release FLASH_METHOD=openocd ./build_flash.sh
```

**When to use:** During active development for quick compile-test cycles.

---

### 4. `clean.sh` - Clean Build Artifacts

**Purpose:** Removes all build artifacts and intermediate files to ensure clean builds.

**Usage:**
```bash
./clean.sh
```

**What it does:**
- Runs `make clean` if Makefile exists
- Removes build directory
- Deletes object files (*.o)
- Deletes dependency files (*.d)
- Deletes map files (*.map)
- Deletes listing files (*.lst)
- Deletes stack usage files (*.su)

**Environment Variables:**
- `PROJECT_DIR` - Project directory (default: current directory)
- `BUILD_DIR` - Build directory to remove (default: `build`)

**When to use:** 
- Before a clean rebuild
- After changing build configuration
- When troubleshooting build issues
- Before committing to version control

---

## 🔄 Typical Workflows

### Initial Setup

```bash
cd Scripts/
chmod +x *.sh
```

### Development Cycle

**Quick iteration:**
```bash
./build_flash.sh    # Build and flash in one command
```

**Separate steps:**
```bash
./build.sh          # Compile project
./flash.sh          # Flash to board
```

**Clean rebuild:**
```bash
./clean.sh          # Remove old artifacts
./build.sh          # Fresh build
./flash.sh          # Flash to board
```

### Release Build

```bash
./clean.sh                      # Clean old artifacts
BUILD_TYPE=release ./build.sh   # Build optimized
./flash.sh                      # Deploy to hardware
```

### Using Different Flash Methods

**ST-Link (default):**
```bash
./flash.sh
```

**OpenOCD (for different debuggers or remote debugging):**
```bash
FLASH_METHOD=openocd \
OPENOCD_TARGET=target/stm32f7x.cfg \
./flash.sh
```

**STM32CubeProgrammer:**
```bash
FLASH_METHOD=cubeprog ./flash.sh
```

## ⚙️ Configuration

### Customizing for Your Board

Edit the scripts or use environment variables:

```bash
# For STM32F7 instead of STM32F4
export OPENOCD_TARGET=target/stm32f7x.cfg

# For custom build directory
export BUILD_DIR=output

# For release builds
export BUILD_TYPE=release
```

### Making Configuration Permanent

Add to your shell profile (`~/.bashrc` or `~/.zshrc`):

```bash
# STM32 Development Settings
export PROJECT_DIR=$HOME/stm32_projects/my_project
export BUILD_TYPE=release
export FLASH_METHOD=stlink
```

### Project-Specific Configuration

Create a `.env` file in your project directory:

```bash
# .env file
BUILD_DIR=output
BUILD_TYPE=debug
FLASH_METHOD=stlink
FLASH_ADDRESS=0x8000000
```

Then source it before running scripts:
```bash
source .env
./build_flash.sh
```

## 🛡️ Safety Features

All scripts include:
- **Error checking** with `set -e` (exit on error)
- **Colorized output** for better visibility
- **Prerequisite checks** (toolchain, files, hardware)
- **Clear error messages** with troubleshooting hints
- **Status reporting** after operations
- **Safe defaults** to prevent accidents

## 🐛 Troubleshooting

### "ARM toolchain not found"

```bash
# Ubuntu/Debian
sudo apt install gcc-arm-none-eabi

# macOS
brew install --cask gcc-arm-embedded

# Verify
arm-none-eabi-gcc --version
```

### "ST-Link not detected"

```bash
# Check connection
st-info --probe

# Check USB device (Linux)
lsusb | grep -i st-link

# Check udev rules (Linux)
ls /etc/udev/rules.d/*stlink*

# Install stlink if needed
# See STM32_Setup.md
```

### "Makefile not found"

Ensure you're in the correct project directory:
```bash
cd /path/to/your/stm32/project
ls Makefile  # Should exist
```

### "Permission denied" when running scripts

```bash
chmod +x Scripts/*.sh
```

### Flash fails repeatedly

```bash
# Try full erase first
st-flash erase

# Then flash
./flash.sh

# Or use connect-under-reset
st-flash --connect-under-reset write build/firmware.bin 0x8000000
```

## 📋 Script Options Reference

### build.sh Options

```bash
# Default build
./build.sh

# Release build (optimized)
BUILD_TYPE=release ./build.sh

# Custom project path
PROJECT_DIR=/path/to/project ./build.sh

# Custom build directory
BUILD_DIR=output ./build.sh
```

### flash.sh Options

```bash
# Default flash (ST-Link)
./flash.sh

# OpenOCD flash
FLASH_METHOD=openocd ./flash.sh

# Custom firmware file
FIRMWARE_BIN=path/to/firmware.bin ./flash.sh

# Custom flash address
FLASH_ADDRESS=0x8004000 ./flash.sh

# OpenOCD with custom target
FLASH_METHOD=openocd \
OPENOCD_TARGET=target/stm32h7x.cfg \
./flash.sh
```

### build_flash.sh Options

Accepts all options from both `build.sh` and `flash.sh`:

```bash
# Release build with OpenOCD flash
BUILD_TYPE=release FLASH_METHOD=openocd ./build_flash.sh

# Custom everything
PROJECT_DIR=/path/to/project \
BUILD_TYPE=release \
FLASH_METHOD=stlink \
./build_flash.sh
```

## 🎯 Best Practices

1. **Always clean before important builds**
   ```bash
   ./clean.sh && ./build.sh
   ```

2. **Use release builds for production**
   ```bash
   BUILD_TYPE=release ./build_flash.sh
   ```

3. **Verify connection before flashing**
   ```bash
   st-info --probe  # Check first
   ./flash.sh       # Then flash
   ```

4. **Keep firmware files versioned**
   ```bash
   cp build/firmware.bin firmware_v1.2.3.bin
   ```

5. **Test on hardware frequently**
   ```bash
   # After each feature
   ./build_flash.sh
   ```

## 🔗 Integration with Make

You can integrate these scripts into your Makefile:

```makefile
# Add to your Makefile

.PHONY: build flash build-flash clean-all

build:
	@bash Scripts/build.sh

flash:
	@bash Scripts/flash.sh

build-flash:
	@bash Scripts/build_flash.sh

clean-all:
	@bash Scripts/clean.sh
	@make clean
```

Then use:
```bash
make build-flash  # Build and flash using scripts
```

## 📝 Script Output Examples

### Successful Build

```
========================================
🔨 STM32 Project Build Script
========================================

Project Directory: /home/user/stm32_project
Build Directory: build
Build Type: debug
Toolchain Version: arm-none-eabi-gcc (GNU Arm Embedded Toolchain 10.3-2021.10)

Building project...

[... compilation output ...]

✅ Build successful!

📦 Build artifacts:
-rwxr-xr-x 1 user user 45K firmware.elf
-rw-r--r-- 1 user user 12K firmware.bin
-rw-r--r-- 1 user user 23K firmware.hex

📊 Memory usage:
   text    data     bss     dec     hex filename
  11234     256    1024   12514    30e2 build/firmware.elf

Next steps:
  - Flash to board: ./flash.sh
  - Build and flash: ./build_flash.sh
```

### Successful Flash

```
========================================
⚡ STM32 Flash Programming Script
========================================

Firmware File: build/firmware.bin
Flash Address: 0x8000000
Flash Method: stlink
File Size: 12544 bytes

Checking ST-Link connection...
✓ ST-Link detected

st-flash 1.7.0
  version:    V2J37S27
  serial:     066DFF575251717867013628
  flash:      524288 (pagesize: 16384)
  sram:       131072
  chipid:     0x0463
  dev-type:   STM32F4xx_High

Flashing firmware...
2024-12-13T13:27:00 INFO common.c: Starting Flash write for VL/F0/F3/F1_XL
2024-12-13T13:27:00 INFO flash_loader.c: Successfully loaded flash loader in sram
 12/12 pages written

✅ Flash successful!

🎉 Device programmed successfully!

The STM32 should now be running your firmware.
Use a serial terminal or debugger to verify operation.
```

## 📚 See Also

- [STM32_Setup.md](STM32_Setup.md) - Initial environment setup
- [STM32_Build.md](STM32_Build.md) - Detailed build information
- [STM32_Flash.md](STM32_Flash.md) - Detailed flashing information

## 🌟 Tips

- **Tab completion**: Most shells support tab completion for environment variables
- **Command history**: Use up arrow or `Ctrl+R` to recall previous commands
- **Script chaining**: Combine with `&&` for conditional execution
  ```bash
  ./clean.sh && ./build.sh && ./flash.sh
  ```
- **Background jobs**: Long builds can run in background
  ```bash
  ./build.sh > build.log 2>&1 &
  ```
- **Aliases**: Create shell aliases for common tasks
  ```bash
  alias stm-build='cd ~/stm32_project && ./Scripts/build.sh'
  alias stm-flash='cd ~/stm32_project && ./Scripts/flash.sh'
  ```

## 🤝 Contributing

When modifying scripts:
1. Test thoroughly on your hardware
2. Maintain error checking with `set -e`
3. Keep colorized, friendly output
4. Add clear error messages
5. Update this documentation
6. Follow existing script patterns

---

**Remember**: These scripts are meant to make development faster and easier. Don't hesitate to customize them for your specific workflow! 🚀
