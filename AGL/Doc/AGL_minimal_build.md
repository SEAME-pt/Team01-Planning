# AGL Minimal Build Guide

This guide walks you through building Automotive Grade Linux (AGL) from source, specifically targeting Raspberry Pi 5 with a minimal configuration.

## 📋 Prerequisites

- **Ubuntu 20.04+ or equivalent Linux distribution**
- **At least 200GB free disk space** (AGL builds are large)
- **32GB+ RAM recommended** (8GB minimum with swap)
- **Fast internet connection** (initial download is ~10GB)

## 🚀 Step 1: Environment Setup

### Define AGL Build Directory

Set up the main AGL directory structure:

```bash
export AGL_TOP=$HOME/AGL
```

**Make it permanent** by adding to your shell profile:

```bash
echo 'export AGL_TOP=$HOME/AGL' >> $HOME/.bashrc
source $HOME/.bashrc
```

### Create AGL Directory Structure

```bash
mkdir -p $AGL_TOP
cd $AGL_TOP
```

## 🔧 Step 2: Install Google Repo Tool

The repo tool manages the multiple Git repositories that make up AGL:

```bash
# Create local bin directory
mkdir -p $HOME/bin

# Add to PATH
export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> $HOME/.bashrc

# Download and install repo tool
curl https://storage.googleapis.com/git-repo-downloads/repo > $HOME/bin/repo
chmod a+x $HOME/bin/repo
```

## 📥 Step 3: Download AGL Source Code

Download the latest AGL master branch:

```bash
cd $AGL_TOP
mkdir master
cd master

# Initialize repo for AGL master branch
repo init -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo

# Download all source code (this takes a while!)
repo sync
```

**⏱️ Note:** The `repo sync` command downloads approximately 10GB of source code and may take 30-60 minutes depending on your internet connection.

## 🛠️ Step 4: Configure Build Environment

### Explore Available Options

First, check available machines and features:

```bash
cd $AGL_TOP/master
source meta-agl/scripts/aglsetup.sh -h
```

### Initialize Build for Raspberry Pi 5

Set up the build environment with demo and development features:

```bash
source meta-agl/scripts/aglsetup.sh -m raspberrypi5 agl-demo agl-devel agl-ic
```

**What this does:**
- **`-m raspberrypi5`**: Target Raspberry Pi 5 hardware
- **`agl-demo`**: Include demo applications and UI
- **`agl-devel`**: Add development tools and debugging
- **`agl-ic`**: Include Instrument Cluster features

This creates a `build/` directory in `$AGL_TOP/master/` with the build configuration.

### Activate Build Environment (For Future Sessions)

For subsequent builds or when opening a new terminal:

```bash
cd $AGL_TOP/master
source agl-init-build-env
```

## 🏗️ Step 5: Build AGL Image

### Start the Build

Build the minimal AGL image with cross-compilation SDK:

```bash
bitbake agl-image-minimal-crosssdk
```

**⚠️ Important Build Notes:**
- **First build takes 4-8 hours** depending on your system
- **Uses significant CPU and memory** - monitor system resources
- **Consider using memory optimization scripts** from the `Scripts/` directory
- **Build output will be in** `build/tmp/deploy/images/raspberrypi5/`

### Configure Build Settings (Recommended)

Before starting the build, optimize your configuration: **[📖 Configuration Guide](./AGL_config.md)**

## 🧰 Additional BitBake Commands

### Generate SDK

Create a standalone SDK for cross-compilation development:

```bash
bitbake -c populate_sdk agl-image-minimal-crosssdk
```

**SDK Location:** `build/tmp/deploy/sdk/`

### List Available Packages

Show all packages available for installation:

```bash
bitbake -s
```

### Clean and Rebuild Packages

Clean specific packages before rebuilding:

```bash
# Clean a specific package
bitbake -c clean <package-name>

# Clean and rebuild
bitbake -c cleanall <package-name>
bitbake <package-name>
```

### Useful BitBake Options

```bash
# Show detailed build progress
bitbake -v agl-image-minimal-crosssdk

# Continue build despite errors (not recommended for production)
bitbake -k agl-image-minimal-crosssdk

# Show dependency information
bitbake -g agl-image-minimal-crosssdk
```

## 📁 Build Output Locations

After successful build, find your files here:

```bash
# Main image files
$AGL_TOP/master/build/tmp/deploy/images/raspberrypi5/

# Key files:
# - agl-image-minimal-crosssdk-raspberrypi5.rootfs.wic.xz  (Compressed image)
# - agl-image-minimal-crosssdk-raspberrypi5.rootfs.wic.bmap (Block map for faster flashing)

# SDK (if built)
$AGL_TOP/master/build/tmp/deploy/sdk/

# Build logs
$AGL_TOP/master/build/tmp/log/
```

## 🚀 Next Steps

1. **📝 [Configure your build](./AGL_config.md)** - Optimize settings for your hardware
2. **💾 [Flash to SD card](./Scripts.md#flash_sd_cardsh---flash-agl-image-to-sd-card)** - Deploy to Raspberry Pi 5
3. **🔧 [Development setup](./AGL_config.md#development-tools-and-packages)** - Set up SDK and development tools

## 🐛 Troubleshooting

### Common Build Issues

**Out of memory errors:**
```bash
# Use memory optimization scripts
./Scripts/add_swap.sh 8
./Scripts/configure_memory.sh
```

**Disk space issues:**
```bash
# Clean build cache (frees ~50GB)
bitbake -c cleanall agl-image-minimal-crosssdk

# Check disk usage
df -h $AGL_TOP
```

**Build failures:**
```bash
# Check build logs
less $AGL_TOP/master/build/tmp/log/cooker/raspberrypi5/console-latest.log

# Clean and retry specific package
bitbake -c cleanall <failing-package>
bitbake <failing-package>
```

**Network/download issues:**
```bash
# Resume interrupted repo sync
cd $AGL_TOP/master
repo sync

# Force clean repo sync (last resort)
repo forall -c 'git clean -fd && git reset --hard HEAD'
repo sync
```

## 💡 Tips for Successful Builds

- **Monitor system resources** with `htop` during builds
- **Use quality-of-life scripts** from `Scripts/` directory
- **Save build environment** by documenting your `local.conf` changes
- **Keep source updated** with `repo sync` regularly
- **Make incremental changes** to configuration and test build

---

*This guide provides a complete workflow for building AGL from source. For deployment and advanced configuration, see the linked documentation files.*







