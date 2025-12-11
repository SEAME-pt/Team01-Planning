# AGL Configuration File Documentation

[Previous file to start config AGL](./AGL_minimal_build.md)

The AGL configuration file is located at `~/AGL/build/conf/local.conf`

This file contains variables that BitBake uses during the build process to configure boot parameters, installed programs, and build optimizations.

## 🚀 Performance Optimization Configuration

### Optimized Build Settings for High-Memory Systems

For systems with **32GB RAM + 128GB Swap**, the following balanced parallelism configuration prevents memory allocation storms while maintaining build speed:

```bash
# ======================================================================
# OPTIMIZED BUILD CONFIGURATION - 32GB RAM + 128GB Swap
# ======================================================================
# Balanced parallelism to prevent memory allocation storms
# 32 CPU threads available, limiting to 24 total for stability

# Limit BitBake parallel tasks (recipes building simultaneously)
# 8 parallel recipes keeps things fast without overwhelming memory
BB_NUMBER_THREADS = "8"

# Each recipe can use up to 15 threads for compilation
# This gives good speed while preventing OOM
PARALLEL_MAKE = "-j 15"
```

### Memory-Heavy Package Limitations

Some packages require additional memory constraints to prevent out-of-memory errors:

```bash
# Further limit memory-heavy packages
PARALLEL_MAKE:pn-qtwebengine = "-j 4"
PARALLEL_MAKE:pn-qtwebkit = "-j 4"
PARALLEL_MAKE:pn-chromium = "-j 4"
PARALLEL_MAKE:pn-llvm = "-j 4"
PARALLEL_MAKE:pn-clang = "-j 4"
PARALLEL_MAKE:pn-rust = "-j 4"
PARALLEL_MAKE:pn-gcc = "-j 4"
```

### Special Workarounds

For ARM64 builds, NSS package may have linker issues:

```bash
# Workaround for NSS 3.98 linker errors on ARM64
# Limit parallelism to help with linking issues
PARALLEL_MAKE:pn-nss = "-j 1"
```

## 🥧 Raspberry Pi 5 Configuration

### Boot Configuration

For Raspberry Pi 5, disable U-Boot to use direct kernel boot:

```bash
# ======================================================================
# Raspberry Pi 5 - Disable U-Boot (use direct kernel boot)
# ======================================================================
RPI_USE_U_BOOT = "0"
```

## 📦 Development Tools and Packages

### SDK and Development Features

Enable development tools and debugging capabilities:

```bash
# Add development and debugging tools to the image
EXTRA_IMAGE_FEATURES:append = " tools-sdk tools-debug eclipse-debug"

# Include development packages in SDK
SDK_IMG_FEATURES:append = " dev-pkgs staticdev-pkgs"

# Include toolchain in SDK
SDK_INCLUDE_TOOLCHAIN = "1"
```

### Essential Packages

Core packages for a functional AGL system:

```bash
# Essential packages for AGL functionality
IMAGE_INSTALL:append = " adwaita-icon-theme sed weston packagegroup-qt6-essentials qtwayland"
```

### Development Libraries

Additional toolchain libraries for development:

```bash
# Development libraries for SDK toolchain
TOOLCHAIN_TARGET_TASK:append = " libsdl2 libsdl2-dev qtbase-dev qtdeclarative-dev qtquickcontrols2-agl"
```

### Package Manager Configuration

DNF package manager optimization:

```bash
# Allow package replacement during installation
OE_DNF_ARGS:append = "--allowerasing"
```

## 💡 Configuration Tips

### Thread and Parallelism Guidelines

- **Don't use maximum CPU threads** - Leave some headroom for system stability
- **Monitor memory usage** during builds with `htop` or `free -h`
- **Use swap management scripts** from the Scripts/ directory for heavy builds
- **Adjust values based on your system** - These are optimized for 32GB RAM systems

### Finding Available Packages

To view available packages for installation:

```bash
bitbake -s
```

### Adding Custom Packages

Add packages using the append syntax:

```bash
IMAGE_INSTALL:append = " vim htop git"
```

## 🔧 Configuration Validation

After modifying `local.conf`, validate your configuration:

1. **Check syntax**: Ensure no syntax errors in BitBake variables
2. **Test build**: Start with a small test build to verify settings
3. **Monitor resources**: Watch memory and CPU usage during builds
4. **Adjust as needed**: Fine-tune parallelism based on build performance

---

*These configurations are optimized for AGL development with high-memory systems and Raspberry Pi 5 deployment. Adjust thread counts and parallelism based on your specific hardware capabilities.*

