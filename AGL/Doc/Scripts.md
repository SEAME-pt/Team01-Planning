# AGL Development Scripts Documentation

This directory contains quality-of-life scripts to make AGL (Automotive Grade Linux) development easier and more reliable. These scripts help manage system resources during heavy BitBake builds and simplify deployment to Raspberry Pi 5.

## 🚀 Quick Start

All scripts are located in the `Scripts/` directory and should be run from there:

```bash
cd Scripts/
chmod +x *.sh  # Make scripts executable (first time only)
```

## 📜 Available Scripts

### 1. `add_swap.sh` - Add Extra Swap Space

**Purpose:** Prevents out-of-memory (OOM) crashes during heavy BitBake builds by adding additional swap space.

**Usage:**
```bash
./add_swap.sh <size_in_GB>
```

**Example:**
```bash
./add_swap.sh 4    # Adds 4GB of additional swap
```

**What it does:**
- Creates a swap file of specified size (in GB)
- Sets proper permissions (600) for security
- Activates the swap immediately
- Shows current memory/swap status
- Provides instructions for making it permanent

**Notes:**
- Works alongside your existing 2GB swap
- File created at `/swapfile-extra`
- Temporary by default (won't survive reboots)
- Use the provided command to make it permanent

**When to use:** Before starting large BitBake builds that might consume lots of memory.

---

### 2. `configure_memory.sh` - Optimize Kernel Memory Settings

**Purpose:** Configures kernel memory management for heavy BitBake builds to maximize swap usage and prevent OOM kills.

**Usage:**
```bash
./configure_memory.sh
```

**What it does:**
- Sets `vm.swappiness=100` (use swap aggressively)
- Sets `vm.overcommit_memory=1` (allow memory overcommit)
- Sets `vm.overcommit_ratio=100` (increase overcommit ratio)
- Sets `vm.vfs_cache_pressure=50` (prefer swap over cache reclaim)
- Shows current settings and memory status

**Notes:**
- Settings are temporary (reset on reboot)
- Provides instructions for making settings permanent
- Best used in combination with `add_swap.sh`

**When to use:** Before starting memory-intensive builds, especially after adding extra swap.

---

### 3. `flash_sd_card.sh` - Flash AGL Image to SD Card

**Purpose:** Safely flash built AGL images to SD card for Raspberry Pi 5 deployment.

**Usage:**
```bash
./flash_sd_card.sh
```

**What it does:**
- Flashes the AGL minimal image to Raspberry Pi 5 SD card
- Uses the pre-configured image path for raspberrypi5 builds
- Shows current partitions before flashing
- Requires confirmation before proceeding
- Unmounts existing partitions safely
- Uses `xzcat` and `dd` for efficient flashing
- Syncs filesystems after completion

**⚠️ WARNING:** This will erase ALL data on the target device!

**Configuration (modify in script if needed):**
- **Image path:** `/home/team1/AGL/build/tmp/deploy/images/raspberrypi5/agl-image-minimal-crosssdk-raspberrypi5.rootfs.wic.xz`
- **Target device:** `/dev/sda`


**When to use:** After successfully building an AGL image and ready to deploy to hardware.

---

### 4. `remove_swap.sh` - Clean Up Extra Swap

**Purpose:** Removes the extra swap file created by `add_swap.sh` and deallocates disk space.

**Usage:**
```bash
./remove_swap.sh
```

**What it does:**
- Checks for existing `/swapfile-extra`
- Disables the swap file safely
- Removes the swap file from disk
- Cleans up `/etc/fstab` entries if present
- Shows current swap status

**Notes:**
- Safe to run even if no extra swap exists
- Automatically handles cleanup of persistent configurations
- Frees up disk space

**When to use:** After completing builds when you no longer need the extra swap space.

## 🔄 Typical Workflow

### For Heavy BitBake Builds:

1. **Before building:**
   ```bash
   ./add_swap.sh <Size_in_Gb>           # Add 128GB extra swap
   ./configure_memory.sh     # Optimize memory settings
   ```

2. **After building:**
   ```bash
   ./remove_swap.sh          # Clean up extra swap
   ```

### For Deployment:

3. **Deploy to hardware:**
   ```bash
   ./flash_sd_card.sh        # Flash to Raspberry Pi 5
   ```

## ⚙️ Configuration

### Customizing flash_sd_card.sh

Edit the script to change default paths:

```bash
# Change image path if using different build
IMAGE="/path/to/your/agl-image.wic.xz"

# Change target device (find with 'lsblk')
DEVICE="/dev/sdX"  # Replace X with your SD card device
```

### Making Memory Settings Permanent

To make memory optimizations survive reboots, add to `/etc/sysctl.conf`:

```bash
echo "vm.swappiness=100" | sudo tee -a /etc/sysctl.conf
echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf
echo "vm.overcommit_ratio=100" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
```

### Making Swap Permanent

To make extra swap survive reboots:

```bash
echo '/swapfile-extra none swap sw 0 0' | sudo tee -a /etc/fstab
```

## 🛡️ Safety Features

- **Confirmation prompts** before destructive operations
- **Error checking** with `set -e` in all scripts
- **Safe unmounting** before SD card operations
- **Status reporting** after each operation
- **Cleanup instructions** provided where needed

## 🐛 Troubleshooting

### Common Issues:

**"Permission denied" when running scripts:**
```bash
chmod +x Scripts/*.sh
```

**"Device busy" during SD card flashing:**
- Ensure SD card partitions are unmounted
- Close any file managers browsing the SD card
- Use `lsblk` to verify the correct device

**BitBake still runs out of memory:**
- Increase swap size: `./add_swap.sh 16`
- Check available disk space for swap file
- Monitor with `htop` or `free -h`

**Scripts can't find image file:**
- Verify your BitBake build completed successfully
- Check the image path in `flash_sd_card.sh`
- Ensure you're using the correct machine target

## 📝 Notes

- All scripts include friendly status messages and emojis for better UX :3
- Scripts are designed to be safe and provide clear feedback
- Always read the output messages for important instructions
- These scripts supplement but don't replace reading the AGL build documentation