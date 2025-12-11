#!/bin/bash
# Script to remove the extra swap file and deallocate the space
# Run this to clean up the extra swap file when you're done building

set -e

echo "Checking for swap file..."

if [ ! -f /swapfile-extra ]; then
    echo "❌ No /swapfile-extra found. Nothing to remove."
    exit 0
fi

echo "Disabling swap file..."
sudo swapoff /swapfile-extra 2>/dev/null || echo "Swap file was not active"

echo "Removing swap file..."
sudo rm -f /swapfile-extra

echo "Checking if swap was in /etc/fstab..."
if grep -q "/swapfile-extra" /etc/fstab 2>/dev/null; then
    echo "Removing swap entry from /etc/fstab..."
    sudo sed -i '/\/swapfile-extra/d' /etc/fstab
fi

echo ""
echo "✅ Swap file removed and space deallocated!"
echo ""
echo "Current swap status:"
free -h
echo ""
swapon --show 2>/dev/null || echo "No swap files active"
