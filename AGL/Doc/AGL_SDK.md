# AGL SDK Development Guide

This guide covers setting up and using the AGL (Automotive Grade Linux) Software Development Kit (SDK) for cross-compilation development targeting Raspberry Pi 5.

## 📋 Prerequisites

Before setting up the SDK, ensure you have:

- **Completed [AGL minimal build](./AGL_minimal_build.md)** or have access to a pre-built SDK
- **Ubuntu 20.04+ or equivalent Linux distribution**
- **At least 10GB free disk space** for SDK installation
- **Development tools**: git, cmake, make, gcc/g++

## 🎯 What is the AGL SDK?

The AGL SDK provides:
- **Cross-compilation toolchain** for ARM64 (Raspberry Pi 5)
- **System libraries and headers** from the target AGL image
- **Development tools** for building applications
- **Qt6 development environment** for GUI applications
- **Debugging and profiling tools**

## 🛠️ Step 1: Generate the SDK

### Build SDK from Source

If you've built AGL from source, generate the SDK:

```bash
# Navigate to your AGL build directory
cd $AGL_TOP/master
source agl-init-build-env

# Generate the SDK (takes 30-60 minutes)
bitbake -c populate_sdk agl-image-minimal-crosssdk
```

**SDK Output Location:**
```bash
$AGL_TOP/master/build/tmp/deploy/sdk/
```

### SDK Files Generated

After successful build, you'll find:
```bash
# Self-extracting installer script
agl-glibc-x86_64-agl-image-minimal-crosssdk-aarch64-raspberrypi5-toolchain-*.sh

# Environment setup script (after installation)
environment-setup-aarch64-agl-linux
```

## 📦 Step 2: Install the SDK

### Run the SDK Installer

```bash
# Navigate to SDK directory
cd $AGL_TOP/master/build/tmp/deploy/sdk/

# Make installer executable and run it
chmod +x agl-glibc-x86_64-agl-image-minimal-crosssdk-aarch64-raspberrypi5-toolchain-*.sh

# Install to default location (/opt/agl-sdk/)
sudo ./agl-glibc-x86_64-agl-image-minimal-crosssdk-aarch64-raspberrypi5-toolchain-*.sh

# OR install to custom location
./agl-glibc-x86_64-agl-image-minimal-crosssdk-aarch64-raspberrypi5-toolchain-*.sh -d ~/agl-sdk
```

### SDK Installation Paths

**Default installation:**
- **SDK Root:** `/opt/agl-sdk/`
- **Sysroot:** `/opt/agl-sdk/sysroots/aarch64-agl-linux/`
- **Toolchain:** `/opt/agl-sdk/sysroots/x86_64-aglsdk-linux/`

## 🚀 Step 3: Set Up Development Environment

### Activate SDK Environment

Before any development work, source the environment:

```bash
# For default installation
source /opt/agl-sdk/environment-setup-aarch64-agl-linux

# For custom installation
source ~/agl-sdk/environment-setup-aarch64-agl-linux
```

### Verify SDK Setup

Check that cross-compilation tools are available:

```bash
# Check compiler
echo $CC
# Should output: aarch64-agl-linux-gcc --sysroot=/opt/agl-sdk/sysroots/aarch64-agl-linux

# Check target architecture
echo $ARCH
# Should output: arm64

# Test compilation
$CC --version
```

### Make Environment Permanent (Optional)

Add to your shell profile for automatic activation:

```bash
echo 'source /opt/agl-sdk/environment-setup-aarch64-agl-linux' >> ~/.bashrc
```

## 🔨 Step 4: Development Workflows

### Simple C Application

Create a simple test application:

```bash
# Create project directory
mkdir ~/agl-projects
cd ~/agl-projects

# Create hello.c
cat > hello.c << EOF
#include <stdio.h>

int main() {
    printf("Hello from AGL on Raspberry Pi 5!\n");
    return 0;
}
EOF

# Compile with SDK
$CC hello.c -o hello

# Check binary architecture
file hello
# Should show: ARM aarch64 executable
```

### CMake Project Setup

For larger projects, use CMake with the SDK:

```bash
# Create CMake project
mkdir ~/agl-projects/cmake-example
cd ~/agl-projects/cmake-example

# Create CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(AGLExample)

set(CMAKE_CXX_STANDARD 17)

# Find required packages
find_package(PkgConfig REQUIRED)
find_package(Qt6 COMPONENTS Core Widgets QUIET)

# Create executable
add_executable(agl-example main.cpp)

# Link Qt6 if available
if(Qt6_FOUND)
    target_link_libraries(agl-example Qt6::Core Qt6::Widgets)
endif()
EOF

# Create main.cpp
cat > main.cpp << 'EOF'
#include <iostream>
#ifdef QT_CORE_LIB
#include <QtCore/QCoreApplication>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#endif

int main(int argc, char *argv[]) {
    std::cout << "AGL CMake Example" << std::endl;
    
#ifdef QT_CORE_LIB
    QApplication app(argc, argv);
    QLabel label("Hello AGL Qt6!");
    label.show();
    return app.exec();
#else
    std::cout << "Qt6 not available" << std::endl;
    return 0;
#endif
}
EOF

# Build with CMake
mkdir build && cd build
cmake -DCMAKE_TOOLCHAIN_FILE=$OECORE_NATIVE_SYSROOT/usr/share/cmake/OEToolchainConfig.cmake ..
make
```

### Qt6 Application Development

The SDK includes Qt6 for GUI development:

```bash
# Check Qt6 availability
qmake -query
pkg-config --cflags --libs Qt6Core Qt6Widgets

# Create Qt6 project using qmake
mkdir ~/agl-projects/qt-example
cd ~/agl-projects/qt-example

# Create simple Qt application
cat > main.cpp << 'EOF'
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    QWidget window;
    QVBoxLayout *layout = new QVBoxLayout();
    QLabel *label = new QLabel("Hello AGL Qt6 Application!");
    
    layout->addWidget(label);
    window.setLayout(layout);
    window.setWindowTitle("AGL Qt6 Demo");
    window.show();
    
    return app.exec();
}
EOF

# Create .pro file
cat > qt-example.pro << 'EOF'
QT += widgets
TARGET = qt-example
SOURCES += main.cpp
EOF

# Build with qmake
qmake qt-example.pro
make
```

## 📁 SDK Directory Structure

Understanding the SDK layout:

```
/opt/agl-sdk/
├── environment-setup-aarch64-agl-linux    # Environment script
├── site-config-aarch64-agl-linux          # Site configuration
├── version-aarch64-agl-linux               # SDK version info
└── sysroots/
    ├── aarch64-agl-linux/                  # Target sysroot
    │   ├── lib/                           # Target libraries
    │   ├── usr/
    │   │   ├── include/                   # Target headers
    │   │   ├── lib/                       # Target libraries
    │   │   └── share/                     # Target data files
    │   └── etc/                           # Target configuration
    └── x86_64-aglsdk-linux/               # Host toolchain
        ├── bin/                           # Cross-compilation tools
        ├── lib/                           # Host libraries
        └── usr/                           # Host tools and utilities
```

## 🔧 Advanced SDK Usage

### Debugging Applications

The SDK includes debugging tools:

```bash
# GDB for remote debugging
$GDB your-application

# Compile with debug symbols
$CC -g -O0 your-app.c -o your-app

# Use addr2line for stack traces
$ADDR2LINE -e your-app address
```

### Package Configuration

Check available libraries:

```bash
# List all packages
pkg-config --list-all

# Get compilation flags
pkg-config --cflags --libs libname

# Common AGL packages
pkg-config --cflags --libs wayland-client
pkg-config --cflags --libs Qt6Core Qt6Widgets
```

### Cross-Compilation Tips

```bash
# Environment variables set by SDK
echo $CC                    # Cross-compiler
echo $CXX                   # Cross C++ compiler
echo $AR                    # Cross archiver
echo $STRIP                 # Cross strip utility
echo $PKG_CONFIG_PATH       # Package config path
echo $CMAKE_TOOLCHAIN_FILE  # CMake toolchain file
```

## 🚀 Deployment to Target

### Copy Applications to Raspberry Pi 5

```bash
# Copy binary to running AGL system
scp your-application root@<pi-ip-address>:/usr/bin/

# SSH into AGL system
ssh root@<pi-ip-address>

# Run application on target
/usr/bin/your-application
```

### Systemd Service Integration

Create systemd services for your applications:

```bash
# Create service file
cat > /etc/systemd/system/your-app.service << 'EOF'
[Unit]
Description=Your AGL Application
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/your-application
Restart=always
User=agl-driver

[Install]
WantedBy=graphical-session.target
EOF

# Enable and start service
systemctl enable your-app.service
systemctl start your-app.service
```

## 🐛 Troubleshooting

### Common SDK Issues

**Environment not activated:**
```bash
# Symptom: $CC is empty or wrong
echo $CC

# Solution: Source environment script
source /opt/agl-sdk/environment-setup-aarch64-agl-linux
```

**Missing dependencies:**
```bash
# Check available packages
pkg-config --list-all | grep -i <package>

# Install development packages in AGL build
# Add to local.conf: IMAGE_INSTALL:append = " package-dev"
```

**Qt applications fail to run:**
```bash
# Ensure Qt6 libraries are in target image
# Add to local.conf: IMAGE_INSTALL:append = " qtbase qtdeclarative qtwayland"

# Set Qt platform on target
export QT_QPA_PLATFORM=wayland
```

**Cross-compilation errors:**
```bash
# Verify SDK installation
ls -la /opt/agl-sdk/sysroots/

# Check toolchain
which $CC

# Verify sysroot
ls $SDKTARGETSYSROOT/usr/include/
```

## 💡 Best Practices

### Development Workflow

1. **Always source environment** before compilation
2. **Use CMake or qmake** for complex projects
3. **Test on target hardware** regularly
4. **Use version control** for your applications
5. **Document dependencies** in your project

### Performance Optimization

```bash
# Compile with optimizations
$CC -O2 -march=armv8-a your-app.c -o your-app

# Strip debugging symbols for production
$STRIP your-app

# Check binary size
ls -lh your-app
```

### Integration with AGL Services

```bash
# Use D-Bus for system integration
pkg-config --cflags --libs dbus-1

# Integrate with AGL Application Framework# AGL SDK Development Guide

This guide covers setting up and using the AGL (Automotive Grade Linux) Software Development Kit (SDK) for cross-compilation development targeting Raspberry Pi 5.

## 📋 Prerequisites

Before setting up the SDK, ensure you have:

- **Completed [AGL minimal build](./AGL_minimal_build.md)** or have access to a pre-built SDK
- **Ubuntu 20.04+ or equivalent Linux distribution**
- **At least 10GB free disk space** for SDK installation
- **Development tools**: git, cmake, make, gcc/g++

## 🎯 What is the AGL SDK?

The AGL SDK provides:
- **Cross-compilation toolchain** for ARM64 (Raspberry Pi 5)
- **System libraries and headers** from the target AGL image
- **Development tools** for building applications
- **Qt6 development environment** for GUI applications
- **Debugging and profiling tools**

## 🛠️ Step 1: Generate the SDK

### Build SDK from Source

If you've built AGL from source, generate the SDK:

```bash
# Navigate to your AGL build directory
cd $AGL_TOP/master
source agl-init-build-env

# Generate the SDK (takes 30-60 minutes)
bitbake -c populate_sdk agl-image-minimal-crosssdk
```

**SDK Output Location:**
```bash
$AGL_TOP/master/build/tmp/deploy/sdk/
```

### SDK Files Generated

After successful build, you'll find:
```bash
# Self-extracting installer script
agl-glibc-x86_64-agl-image-minimal-crosssdk-aarch64-raspberrypi5-toolchain-*.sh

# Environment setup script (after installation)
environment-setup-aarch64-agl-linux
```

## 📦 Step 2: Install the SDK

### Run the SDK Installer

```bash
# Navigate to SDK directory
cd $AGL_TOP/master/build/tmp/deploy/sdk/

# Make installer executable and run it
chmod +x agl-glibc-x86_64-agl-image-minimal-crosssdk-aarch64-raspberrypi5-toolchain-*.sh

# Install to default location (/opt/agl-sdk/)
sudo ./agl-glibc-x86_64-agl-image-minimal-crosssdk-aarch64-raspberrypi5-toolchain-*.sh

# OR install to custom location
./agl-glibc-x86_64-agl-image-minimal-crosssdk-aarch64-raspberrypi5-toolchain-*.sh -d ~/agl-sdk
```

### SDK Installation Paths

**Default installation:**
- **SDK Root:** `/opt/agl-sdk/`
- **Sysroot:** `/opt/agl-sdk/sysroots/aarch64-agl-linux/`
- **Toolchain:** `/opt/agl-sdk/sysroots/x86_64-aglsdk-linux/`

## 🚀 Step 3: Set Up Development Environment

### Activate SDK Environment

Before any development work, source the environment:

```bash
# For default installation
source /opt/agl-sdk/environment-setup-aarch64-agl-linux

# For custom installation
source ~/agl-sdk/environment-setup-aarch64-agl-linux
```

### Verify SDK Setup

Check that cross-compilation tools are available:

```bash
# Check compiler
echo $CC
# Should output: aarch64-agl-linux-gcc --sysroot=/opt/agl-sdk/sysroots/aarch64-agl-linux

# Check target architecture
echo $ARCH
# Should output: arm64

# Test compilation
$CC --version
```

### Make Environment Permanent (Optional)

Add to your shell profile for automatic activation:

```bash
echo 'source /opt/agl-sdk/environment-setup-aarch64-agl-linux' >> ~/.bashrc
```

## 🔨 Step 4: Development Workflows

### Simple C Application

Create a simple test application:

```bash
# Create project directory
mkdir ~/agl-projects
cd ~/agl-projects

# Create hello.c
cat > hello.c << EOF
#include <stdio.h>

int main() {
    printf("Hello from AGL on Raspberry Pi 5!\n");
    return 0;
}
EOF

# Compile with SDK
$CC hello.c -o hello

# Check binary architecture
file hello
# Should show: ARM aarch64 executable
```

### CMake Project Setup

For larger projects, use CMake with the SDK:

```bash
# Create CMake project
mkdir ~/agl-projects/cmake-example
cd ~/agl-projects/cmake-example

# Create CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(AGLExample)

set(CMAKE_CXX_STANDARD 17)

# Find required packages
find_package(PkgConfig REQUIRED)
find_package(Qt6 COMPONENTS Core Widgets QUIET)

# Create executable
add_executable(agl-example main.cpp)

# Link Qt6 if available
if(Qt6_FOUND)
    target_link_libraries(agl-example Qt6::Core Qt6::Widgets)
endif()
EOF

# Create main.cpp
cat > main.cpp << 'EOF'
#include <iostream>
#ifdef QT_CORE_LIB
#include <QtCore/QCoreApplication>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#endif

int main(int argc, char *argv[]) {
    std::cout << "AGL CMake Example" << std::endl;
    
#ifdef QT_CORE_LIB
    QApplication app(argc, argv);
    QLabel label("Hello AGL Qt6!");
    label.show();
    return app.exec();
#else
    std::cout << "Qt6 not available" << std::endl;
    return 0;
#endif
}
EOF

# Build with CMake
mkdir build && cd build
cmake -DCMAKE_TOOLCHAIN_FILE=$OECORE_NATIVE_SYSROOT/usr/share/cmake/OEToolchainConfig.cmake ..
make
```

### Qt6 Application Development

The SDK includes Qt6 for GUI development:

```bash
# Check Qt6 availability
qmake -query
pkg-config --cflags --libs Qt6Core Qt6Widgets

# Create Qt6 project using qmake
mkdir ~/agl-projects/qt-example
cd ~/agl-projects/qt-example

# Create simple Qt application
cat > main.cpp << 'EOF'
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    QWidget window;
    QVBoxLayout *layout = new QVBoxLayout();
    QLabel *label = new QLabel("Hello AGL Qt6 Application!");
    
    layout->addWidget(label);
    window.setLayout(layout);
    window.setWindowTitle("AGL Qt6 Demo");
    window.show();
    
    return app.exec();
}
EOF

# Create .pro file
cat > qt-example.pro << 'EOF'
QT += widgets
TARGET = qt-example
SOURCES += main.cpp
EOF

# Build with qmake
qmake qt-example.pro
make
```

## 📁 SDK Directory Structure

Understanding the SDK layout:

```
/opt/agl-sdk/
├── environment-setup-aarch64-agl-linux    # Environment script
├── site-config-aarch64-agl-linux          # Site configuration
├── version-aarch64-agl-linux               # SDK version info
└── sysroots/
    ├── aarch64-agl-linux/                  # Target sysroot
    │   ├── lib/                           # Target libraries
    │   ├── usr/
    │   │   ├── include/                   # Target headers
    │   │   ├── lib/                       # Target libraries
    │   │   └── share/                     # Target data files
    │   └── etc/                           # Target configuration
    └── x86_64-aglsdk-linux/               # Host toolchain
        ├── bin/                           # Cross-compilation tools
        ├── lib/                           # Host libraries
        └── usr/                           # Host tools and utilities
```

## 🔧 Advanced SDK Usage

### Debugging Applications

The SDK includes debugging tools:

```bash
# GDB for remote debugging
$GDB your-application

# Compile with debug symbols
$CC -g -O0 your-app.c -o your-app

# Use addr2line for stack traces
$ADDR2LINE -e your-app address
```

### Package Configuration

Check available libraries:

```bash
# List all packages
pkg-config --list-all

# Get compilation flags
pkg-config --cflags --libs libname

# Common AGL packages
pkg-config --cflags --libs wayland-client
pkg-config --cflags --libs Qt6Core Qt6Widgets
```

### Cross-Compilation Tips

```bash
# Environment variables set by SDK
echo $CC                    # Cross-compiler
echo $CXX                   # Cross C++ compiler
echo $AR                    # Cross archiver
echo $STRIP                 # Cross strip utility
echo $PKG_CONFIG_PATH       # Package config path
echo $CMAKE_TOOLCHAIN_FILE  # CMake toolchain file
```

## 🚀 Deployment to Target

### Copy Applications to Raspberry Pi 5

```bash
# Copy binary to running AGL system
scp your-application root@<pi-ip-address>:/usr/bin/

# SSH into AGL system
ssh root@<pi-ip-address>

# Run application on target
/usr/bin/your-application
```

### Systemd Service Integration

Create systemd services for your applications:

```bash
# Create service file
cat > /etc/systemd/system/your-app.service << 'EOF'
[Unit]
Description=Your AGL Application
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/your-application
Restart=always
User=agl-driver

[Install]
WantedBy=graphical-session.target
EOF

# Enable and start service
systemctl enable your-app.service
systemctl start your-app.service
```

## 🐛 Troubleshooting

### Common SDK Issues

**Environment not activated:**
```bash
# Symptom: $CC is empty or wrong
echo $CC

# Solution: Source environment script
source /opt/agl-sdk/environment-setup-aarch64-agl-linux
```

**Missing dependencies:**
```bash
# Check available packages
pkg-config --list-all | grep -i <package>

# Install development packages in AGL build
# Add to local.conf: IMAGE_INSTALL:append = " package-dev"
```

**Qt applications fail to run:**
```bash
# Ensure Qt6 libraries are in target image
# Add to local.conf: IMAGE_INSTALL:append = " qtbase qtdeclarative qtwayland"

# Set Qt platform on target
export QT_QPA_PLATFORM=wayland
```

**Cross-compilation errors:**
```bash
# Verify SDK installation
ls -la /opt/agl-sdk/sysroots/

# Check toolchain
which $CC

# Verify sysroot
ls $SDKTARGETSYSROOT/usr/include/
```

## 💡 Best Practices

### Development Workflow

1. **Always source environment** before compilation
2. **Use CMake or qmake** for complex projects
3. **Test on target hardware** regularly
4. **Use version control** for your applications
5. **Document dependencies** in your project

### Performance Optimization

```bash
# Compile with optimizations
$CC -O2 -march=armv8-a your-app.c -o your-app

# Strip debugging symbols for production
$STRIP your-app

# Check binary size
ls -lh your-app
```

### Integration with AGL Services

```bash
# Use D-Bus for system integration
pkg-config --cflags --libs dbus-1

# Integrate with AGL Application Framework
pkg-config --cflags --libs afb-daemon

# Use Wayland for display
pkg-config --cflags --libs wayland-client
```

## 📚 Related Documentation

- **[AGL Minimal Build Guide](./AGL_minimal_build.md)** - Building AGL from source
- **[AGL Configuration](./AGL_config.md)** - Build configuration options
- **[Development Scripts](./Scripts.md)** - Quality-of-life development tools

## 🔗 External Resources

- **[AGL Official Documentation](https://docs.automotivelinux.org/)**
- **[Yocto Project SDK Manual](https://docs.yoctoproject.org/sdk-manual/)**
- **[Qt6 for Embedded Linux](https://doc.qt.io/qt-6/embedded-linux.html)**

---

*This SDK guide provides a complete development environment for creating AGL applications. Use it alongside the build and configuration guides for a full development workflow.*

pkg-config --cflags --libs afb-daemon

# Use Wayland for display
pkg-config --cflags --libs wayland-client
```

## 📚 Related Documentation

- **[AGL Minimal Build Guide](./AGL_minimal_build.md)** - Building AGL from source
- **[AGL Configuration](./AGL_config.md)** - Build configuration options
- **[Development Scripts](./Scripts.md)** - Quality-of-life development tools

## 🔗 External Resources

- **[AGL Official Documentation](https://docs.automotivelinux.org/)**
- **[Yocto Project SDK Manual](https://docs.yoctoproject.org/sdk-manual/)**
- **[Qt6 for Embedded Linux](https://doc.qt.io/qt-6/embedded-linux.html)**

---

*This SDK guide provides a complete development environment for creating AGL applications. Use it alongside the build and configuration guides for a full development workflow.*
