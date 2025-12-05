#!/bin/bash
# Script to add some additional swap space for BitBake builds
# This supplements your existing 2GB swap to prevent OOM crashes
# Total swap will be 2 + first argument - BitBake will never run out! :3

set -e

echo "Creating $(1)G swap file..."
echo "This may take a few minutes..."
sudo fallocate -l $(1)G /swapfile-extra || sudo dd if=/dev/zero of=/swapfile-extra bs=1M count=131072

echo "Setting correct permissions..."
sudo chmod 600 /swapfile-extra

echo "Setting up swap space..."
sudo mkswap /swapfile-extra

echo "Enabling swap..."
sudo swapon /swapfile-extra

echo "Verifying swap..."
free -h

echo ""
echo "✅ Additional 128GB swap activated! BitBake will never BOOM again! :3"
echo ""
echo "To make this permanent (survive reboots), run:"
echo "  echo '/swapfile-extra none swap sw 0 0' | sudo tee -a /etc/fstab"
echo ""
echo "Current swap usage:"
swapon --show
