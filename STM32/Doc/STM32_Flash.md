# STM32 Flash Programming

This guide covers different methods to flash compiled code to STM32 microcontrollers.

## Prerequisites

- Built firmware (`.bin` or `.hex` file)
- STM32 board connected to development machine
- Programming tool installed (see [STM32_Setup.md](STM32_Setup.md))

## Flash Memory Overview

### STM32 Flash Layout

```
0x08000000  ┌─────────────────┐
            │  Vector Table   │  (interrupt vectors)
            ├─────────────────┤
            │  Application    │  (your code)
            │     Code        │
            ├─────────────────┤
            │     Data        │  (constants, strings)
            ├─────────────────┤
            │                 │
            │   (Unused)      │
            │                 │
0x080XXXXX  └─────────────────┘
```

**Key addresses:**
- `0x08000000` - Flash start (application entry point)
- Flash size varies by model: 64KB to 2MB+

## Method 1: ST-Link Tools (Recommended)

### st-flash Command

ST-Link tools provide simple command-line flashing.

#### Flash Binary File

```bash
st-flash write build/firmware.bin 0x8000000
```

Parameters:
- `write` - Flash operation
- `build/firmware.bin` - Binary file to flash
- `0x8000000` - Start address (STM32 flash base)

#### Flash HEX File

```bash
st-flash --format ihex write build/firmware.hex
```

#### Verify Flash

```bash
st-flash read read_back.bin 0x8000000 0x10000  # Read 64KB
cmp build/firmware.bin read_back.bin           # Compare files
```

#### Erase Flash

```bash
# Erase entire flash
st-flash erase

# Useful when flash is in unknown state
```

#### Check Connection

```bash
st-info --probe
```

Output shows:
- ST-Link version
- Connected MCU
- Flash and SRAM sizes
- Chip ID

### Common st-flash Options

```bash
st-flash --reset write firmware.bin 0x8000000   # Reset after flash
st-flash --connect-under-reset write ...         # Connect while held in reset
st-flash write firmware.bin 0x8000000 --format binary  # Explicit format
```

## Method 2: OpenOCD

OpenOCD provides advanced debugging and programming capabilities.

### Configuration

Create `openocd.cfg` or use predefined configs:

```bash
# Using built-in configuration
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg
```

Common interface files:
- `interface/stlink.cfg` - ST-Link V2/V3
- `interface/stlink-v2-1.cfg` - ST-Link V2.1

Common target files:
- `target/stm32f0x.cfg` - STM32F0 series
- `target/stm32f1x.cfg` - STM32F1 series
- `target/stm32f4x.cfg` - STM32F4 series
- `target/stm32f7x.cfg` - STM32F7 series
- `target/stm32h7x.cfg` - STM32H7 series

### Flash with OpenOCD

#### Method A: Command Line

```bash
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "program build/firmware.elf verify reset exit"
```

Command breakdown:
- `-f interface/stlink.cfg` - Programmer interface
- `-f target/stm32f4x.cfg` - Target MCU
- `-c "program ... exit"` - Commands to execute

#### Method B: Interactive Session

```bash
# Start OpenOCD server
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg

# In another terminal, connect with telnet
telnet localhost 4444

# OpenOCD commands:
> reset halt
> flash write_image erase build/firmware.bin 0x08000000
> verify_image build/firmware.bin 0x08000000
> reset run
> exit
```

### OpenOCD Flash Commands

```bash
# Erase flash
flash erase_sector 0 0 last

# Write binary
flash write_bank 0 firmware.bin 0

# Write with erase
flash write_image erase firmware.bin 0x08000000

# Verify
verify_image firmware.bin 0x08000000

# Read flash
flash read_bank 0 readback.bin 0 0x10000
```

## Method 3: STM32CubeProgrammer

STM32CubeProgrammer provides both GUI and CLI interfaces.

### GUI Method

1. **Launch STM32CubeProgrammer**
2. **Select connection method**: ST-LINK
3. **Connect** to the board
4. **Open file**: Click "Open file" and select `.bin`, `.hex`, or `.elf`
5. **Set address**: For `.bin` files, enter `0x08000000`
6. **Download**: Click "Start Programming"

### CLI Method

```bash
# Flash binary file
STM32_Programmer_CLI -c port=SWD -w build/firmware.bin 0x08000000 -v -rst

# Flash hex file
STM32_Programmer_CLI -c port=SWD -w build/firmware.hex -v -rst

# Flash elf file
STM32_Programmer_CLI -c port=SWD -d build/firmware.elf -v -rst
```

Parameters:
- `-c port=SWD` - Connect via SWD
- `-w` - Write (flash)
- `-v` - Verify after programming
- `-rst` - Reset after programming
- `-d` - Download (for ELF files)

### Full Erase

```bash
STM32_Programmer_CLI -c port=SWD -e all
```

## Method 4: UART Bootloader

Some STM32 MCUs support flashing via UART using the built-in bootloader.

### Hardware Setup

1. **Set BOOT0 pin HIGH** (connect to 3.3V)
2. **Reset the MCU**
3. **Connect UART adapter**:
   - TX → STM32 RX
   - RX → STM32 TX
   - GND → GND

### Using stm32flash

```bash
# Install stm32flash
sudo apt install stm32flash

# Flash via UART
stm32flash -w build/firmware.bin -v -g 0x08000000 /dev/ttyUSB0

# Read flash
stm32flash -r flash_backup.bin /dev/ttyUSB0

# Erase flash
stm32flash -o /dev/ttyUSB0
```

Parameters:
- `-w` - Write file
- `-r` - Read flash
- `-v` - Verify
- `-g` - Go (start execution at address)
- `/dev/ttyUSB0` - Serial port (adjust as needed)

**After flashing**: Set BOOT0 back to LOW and reset.

## Method 5: Using Makefile Targets

Add flash targets to your Makefile:

```makefile
# Flash using st-flash
flash: all
	st-flash write $(BUILD_DIR)/$(TARGET).bin 0x8000000

# Flash using OpenOCD
flash-openocd: all
	openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
	  -c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"

# Erase flash
erase:
	st-flash erase

.PHONY: flash flash-openocd erase
```

Usage:
```bash
make flash           # Build and flash
make flash-openocd   # Build and flash with OpenOCD
make erase          # Erase flash
```

## Flash Options and Features

### Write Protection

Some STM32s have write protection:

```bash
# Remove write protection (OpenOCD)
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "init; reset halt; stm32f4x unlock 0; reset; exit"
```

### Read Protection

**Warning**: Setting read protection prevents reading flash contents.

Levels:
- Level 0: No protection
- Level 1: Cannot read via debug interface
- Level 2: Permanent protection (irreversible!)

### Option Bytes

Configure MCU behavior (boot address, watchdog, etc.):

```bash
# Using STM32CubeProgrammer
STM32_Programmer_CLI -c port=SWD -ob [option]
```

## Verification and Debugging

### Verify Flash Contents

```bash
# Using st-flash
st-flash read readback.bin 0x8000000 [size]
hexdump -C readback.bin | head

# Using OpenOCD
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "init; verify_image build/firmware.bin 0x08000000; exit"
```

### Check Device Info

```bash
# st-info
st-info --probe
st-info --descr

# OpenOCD
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "init; targets; exit"
```

### Reset MCU

```bash
# Hardware reset using st-flash
st-flash reset

# Using OpenOCD
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "init; reset; exit"
```

## Troubleshooting

### "Error: Target not halted"

**Solution**:
```bash
# Hold device in reset during connection
st-flash --connect-under-reset write firmware.bin 0x8000000

# Or with OpenOCD
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "init; reset halt; program firmware.elf verify reset exit"
```

### "Error: Flash loader program failed"

**Solution**:
1. Try full erase: `st-flash erase`
2. Disconnect and reconnect ST-Link
3. Check power supply stability
4. Try slower clock speed

### "Warning: Invalid flash size"

**Solution**:
- Verify correct target configuration
- Check chip marking on MCU
- Update st-link firmware

### "Cannot connect to target"

**Solutions**:
- Check physical connections
- Verify power supply (3.3V)
- Check NRST isn't held low
- Try connecting under reset
- Check udev rules (Linux)

### Flash Verification Fails

**Solutions**:
1. Try flashing again
2. Perform full erase first
3. Check file integrity: `md5sum firmware.bin`
4. Reduce SWD clock speed

## Automation Scripts

See [Scripts.md](Scripts.md) for convenient flash scripts:
- `flash.sh` - Simple flash script
- `flash_verify.sh` - Flash with verification
- `build_flash.sh` - Combined build and flash

## Best Practices

1. **Always verify** after flashing
2. **Backup flash** before major changes
3. **Use version control** for firmware
4. **Document flash addresses** for multi-app systems
5. **Test on target** hardware regularly
6. **Keep ST-Link firmware updated**

## Quick Reference

```bash
# Most common flash commands

# ST-Link (easiest)
st-flash write firmware.bin 0x8000000

# OpenOCD (flexible)
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "program firmware.elf verify reset exit"

# STM32CubeProgrammer (official)
STM32_Programmer_CLI -c port=SWD -w firmware.bin 0x08000000 -v -rst

# Check connection
st-info --probe

# Erase everything
st-flash erase
```

## Next Steps

- See [STM32_Debug.md](STM32_Debug.md) for debugging techniques (if available)
- See [Scripts.md](Scripts.md) for automation scripts
- See [STM32_Build.md](STM32_Build.md) for compilation instructions

## Resources

- [stlink GitHub](https://github.com/stlink-org/stlink)
- [OpenOCD Documentation](http://openocd.org/doc/)
- [STM32CubeProgrammer User Manual](https://www.st.com/resource/en/user_manual/um2237-stm32cubeprogrammer-software-description-stmicroelectronics.pdf)
- [STM32 Flash Programming Manual](https://www.st.com/resource/en/programming_manual/)
