# STM32 Build Process

This guide explains how to compile STM32 projects using different build systems and configurations.

## Prerequisites

Before building, ensure you have:
- ARM GCC toolchain installed (see [STM32_Setup.md](STM32_Setup.md))
- Make or CMake (depending on build system)
- Project source code and configuration files

## Build Systems

### Using Makefile (Most Common)

#### Understanding the Makefile

A typical STM32 Makefile includes:

```makefile
# Target MCU
MCU = -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard

# Build directory
BUILD_DIR = build

# C sources
C_SOURCES = \
Core/Src/main.c \
Core/Src/stm32f4xx_it.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c

# ASM sources
ASM_SOURCES = startup_stm32f4xx.s

# Toolchain
PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size

# Compiler flags
CFLAGS = $(MCU) -Wall -fdata-sections -ffunction-sections
LDFLAGS = $(MCU) -specs=nano.specs -T STM32F4xx_FLASH.ld -Wl,--gc-sections
```

#### Basic Build Commands

**Clean build:**
```bash
make clean
make
```

**Verbose build:**
```bash
make V=1
```

**Parallel build (faster):**
```bash
make -j$(nproc)
```

**Build specific target:**
```bash
make all          # Build everything
make clean        # Clean build artifacts
make flash        # Build and flash (if defined in Makefile)
```

#### Build Output

The build process generates:
- `*.o` - Object files (compiled source files)
- `*.elf` - Executable and Linkable Format (main output with debug info)
- `*.bin` - Binary file (raw binary for flashing)
- `*.hex` - Intel HEX file (alternative flash format)
- `*.map` - Memory map file (shows memory layout)

### Using CMake

CMake provides a more flexible build system for complex projects.

#### CMakeLists.txt Example

```cmake
cmake_minimum_required(VERSION 3.15)

project(STM32_Project C ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Toolchain configuration
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_SIZE arm-none-eabi-size)

# MCU configuration
set(MCU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")
set(CMAKE_C_FLAGS "${MCU_FLAGS} -Wall -fdata-sections -ffunction-sections")
set(CMAKE_EXE_LINKER_FLAGS "${MCU_FLAGS} -specs=nano.specs -T${CMAKE_SOURCE_DIR}/STM32F4xx_FLASH.ld -Wl,--gc-sections")

# Add source files
file(GLOB_RECURSE SOURCES "Core/Src/*.c" "Drivers/*.c")
add_executable(${PROJECT_NAME}.elf ${SOURCES} startup_stm32f4xx.s)

# Generate binary and hex files
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.bin
)
```

#### CMake Build Commands

**Configure and build:**
```bash
mkdir build
cd build
cmake ..
make
```

**Build with specific generator:**
```bash
cmake -G "Ninja" ..
ninja
```

**Clean build:**
```bash
rm -rf build
mkdir build
cd build
cmake ..
make
```

### Using STM32CubeIDE

STM32CubeIDE provides a graphical build interface:

1. **Open project** in STM32CubeIDE
2. **Configure build** (Project → Properties → C/C++ Build)
3. **Build project** (Project → Build Project or Ctrl+B)
4. **View console** for build output

Build configurations:
- **Debug**: With debug symbols, no optimization
- **Release**: Optimized, minimal size

## Compiler Flags Explained

### MCU-Specific Flags

```bash
-mcpu=cortex-m4          # Target Cortex-M4 processor
-mthumb                  # Use Thumb instruction set
-mfpu=fpv4-sp-d16       # Floating-point unit configuration
-mfloat-abi=hard        # Hardware floating-point ABI
```

### Optimization Flags

```bash
-O0                      # No optimization (debug)
-O1                      # Basic optimization
-O2                      # Moderate optimization (recommended for release)
-O3                      # Aggressive optimization
-Os                      # Optimize for size
-Og                      # Optimize for debugging
```

### Warning Flags

```bash
-Wall                    # Enable all common warnings
-Wextra                  # Enable extra warnings
-Werror                  # Treat warnings as errors
-Wpedantic              # Strict ISO C compliance
```

### Code Generation Flags

```bash
-fdata-sections         # Place each data in separate section
-ffunction-sections     # Place each function in separate section
-specs=nano.specs       # Use newlib-nano (smaller C library)
```

### Linker Flags

```bash
-Wl,--gc-sections       # Remove unused sections
-Wl,-Map=output.map     # Generate memory map file
-T linker_script.ld     # Specify linker script
```

## Memory Optimization

### Check Memory Usage

```bash
arm-none-eabi-size build/project.elf
```

Output example:
```
   text    data     bss     dec     hex filename
  12345     100    2048   14493    3897 build/project.elf
```

- **text**: Program code (Flash)
- **data**: Initialized data (Flash → RAM)
- **bss**: Uninitialized data (RAM)

### Reduce Flash Usage

1. **Enable size optimization:**
   ```makefile
   CFLAGS += -Os
   ```

2. **Use newlib-nano:**
   ```makefile
   LDFLAGS += -specs=nano.specs
   ```

3. **Remove unused functions:**
   ```makefile
   CFLAGS += -ffunction-sections -fdata-sections
   LDFLAGS += -Wl,--gc-sections
   ```

4. **Disable debug info in release:**
   ```makefile
   # Remove -g flag for release builds
   ```

### Reduce RAM Usage

1. **Use const for constant data** (keeps it in Flash)
2. **Optimize stack size** in linker script
3. **Use static allocation** instead of dynamic
4. **Review buffer sizes**

## Build Configurations

### Debug Build

Best for development and debugging:

```makefile
CFLAGS += -g3          # Maximum debug info
CFLAGS += -Og          # Debug-friendly optimization
CFLAGS += -DDEBUG      # Define DEBUG macro
```

### Release Build

Optimized for production:

```makefile
CFLAGS += -O2          # Optimize for performance
CFLAGS += -Os          # Or optimize for size
CFLAGS += -DNDEBUG     # Define NDEBUG (disables assert)
```

### Custom Build Configuration

Create different configurations for testing:

```makefile
ifeq ($(BUILD_TYPE),debug)
    CFLAGS += -g3 -Og -DDEBUG
else ifeq ($(BUILD_TYPE),release)
    CFLAGS += -O2 -DNDEBUG
else ifeq ($(BUILD_TYPE),size)
    CFLAGS += -Os -DNDEBUG
endif
```

Usage:
```bash
make BUILD_TYPE=debug
make BUILD_TYPE=release
make BUILD_TYPE=size
```

## Common Build Issues

### Undefined Reference Errors

**Cause**: Missing source files or libraries

**Solution**:
```bash
# Add missing source to Makefile
C_SOURCES += path/to/missing_file.c
```

### Linker Script Errors

**Cause**: Incorrect memory configuration

**Solution**: Verify memory sizes in linker script match your MCU:
```ld
MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 128K
}
```

### Stack/Heap Overflow

**Cause**: Insufficient stack or heap allocation

**Solution**: Increase in linker script:
```ld
_Min_Heap_Size = 0x200;   /* Increase heap */
_Min_Stack_Size = 0x400;  /* Increase stack */
```

### Multiple Definition Errors

**Cause**: Same function/variable defined in multiple files

**Solution**:
- Use `static` for file-local functions
- Use `extern` for declarations in headers
- Ensure implementation exists in only one .c file

## Automation Scripts

See [Scripts.md](Scripts.md) for automated build scripts:
- `build.sh` - Automated compilation
- `rebuild.sh` - Clean and rebuild
- `build_flash.sh` - Compile and flash in one command

## Verification

After successful build, verify output:

```bash
# Check if binary was created
ls -lh build/*.bin build/*.elf

# Verify file is valid ELF
file build/project.elf

# Check memory usage
arm-none-eabi-size build/project.elf

# Inspect symbols (optional)
arm-none-eabi-nm build/project.elf | less

# Disassemble (optional)
arm-none-eabi-objdump -D build/project.elf | less
```

## Next Steps

- See [STM32_Flash.md](STM32_Flash.md) for flashing instructions
- See [Scripts.md](Scripts.md) for automation scripts

## Resources

- [GCC ARM Options](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html)
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [CMake Documentation](https://cmake.org/documentation/)
- [ARM Cortex-M Programming](https://developer.arm.com/documentation/)
