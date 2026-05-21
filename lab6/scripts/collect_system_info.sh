#!/usr/bin/env bash
set -euo pipefail

echo '--- Date ---'
date

echo
echo '--- OS ---'
if [[ -f /etc/os-release ]]; then
  cat /etc/os-release
else
  uname -a
fi

echo
echo '--- Kernel ---'
uname -a

echo
echo '--- CPU ---'
lscpu || true

echo
echo '--- Memory ---'
free -h || true

echo
echo '--- Disks ---'
lsblk || true

echo
echo '--- Filesystem usage ---'
df -h || true
