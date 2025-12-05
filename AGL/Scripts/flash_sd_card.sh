#!/bin/bash
# Script to flash AGL image to SD card for Raspberry Pi 5

set -e

# Image file (compressed)
IMAGE="/home/team1/AGL/build/tmp/deploy/images/raspberrypi5/agl-image-minimal-crosssdk-raspberrypi5.rootfs.wic.xz"
BMAP="/home/team1/AGL/build/tmp/deploy/images/raspberrypi5/agl-image-minimal-crosssdk-raspberrypi5.rootfs.wic.bmap"

# SD card device (CHANGE THIS IF NEEDED!)
DEVICE="/dev/sda"

echo "========================================"
echo "AGL Image Flash Tool for Raspberry Pi 5"
echo "========================================"
echo ""
echo "Image: $IMAGE"
echo "Target device: $DEVICE"
echo ""
echo "⚠️  WARNING: This will ERASE ALL DATA on $DEVICE!"
echo ""

# Show current partitions
echo "Current partitions on $DEVICE:"
lsblk -p "$DEVICE"
echo ""

read -p "Are you sure you want to continue? (type 'yes' to proceed): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "Step 1: Unmounting all partitions on $DEVICE..."
sudo umount ${DEVICE}p* 2>/dev/null || echo "No partitions were mounted"

echo ""
echo "Step 2: Flashing image to SD card with dd..."
echo "This will take several minutes..."
echo ""

xzcat "$IMAGE" | sudo dd of="$DEVICE" bs=4M status=progress conv=fsync

echo ""
echo "Step 3: Syncing filesystems..."
sync

echo ""
echo "✅ Flashing complete!"
echo ""
echo "You can now safely remove the SD card and insert it into your Raspberry Pi 5."
echo ""
echo "To boot:"
echo "  1. Insert SD card into Raspberry Pi 5"
echo "  2. Connect HDMI, keyboard, mouse, and power"
echo "  3. Power on - AGL should boot automatically!"
echo ""
