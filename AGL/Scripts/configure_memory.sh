#!/bin/bash
# Script to configure kernel memory settings for heavy BitBake builds
# This prevents OOM killer from killing processes before swap is fully used

set -e

echo "========================================"
echo "Configuring Kernel Memory Settings"
echo "========================================"
echo ""

# Increase swappiness to make kernel use swap more aggressively
# Default is 60, we set to 100 to maximize swap usage
echo "Setting vm.swappiness to 100 (use swap aggressively)..."
sudo sysctl vm.swappiness=100

# Set overcommit_memory to allow more memory allocation
# 1 = kernel will overcommit memory without limits
echo "Setting vm.overcommit_memory to 1 (allow overcommit)..."
sudo sysctl vm.overcommit_memory=1

# Increase overcommit ratio
echo "Setting vm.overcommit_ratio to 100..."
sudo sysctl vm.overcommit_ratio=100

# Reduce tendency to reclaim cache (prefer swap instead)
echo "Setting vm.vfs_cache_pressure to 50..."
sudo sysctl vm.vfs_cache_pressure=50

echo ""
echo "✅ Kernel memory settings configured for heavy builds!"
echo ""
echo "Current settings:"
echo "  vm.swappiness = $(cat /proc/sys/vm/swappiness)"
echo "  vm.overcommit_memory = $(cat /proc/sys/vm/overcommit_memory)"
echo "  vm.overcommit_ratio = $(cat /proc/sys/vm/overcommit_ratio)"
echo "  vm.vfs_cache_pressure = $(cat /proc/sys/vm/vfs_cache_pressure)"
echo ""
echo "Memory status:"
free -h
echo ""
echo "⚠️  These settings will reset on reboot."
echo "To make permanent, add these lines to /etc/sysctl.conf:"
echo "  vm.swappiness=100"
echo "  vm.overcommit_memory=1"
echo "  vm.overcommit_ratio=100"
echo "  vm.vfs_cache_pressure=50"
