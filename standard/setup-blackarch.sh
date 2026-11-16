#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)

# Disable CheckSpace inside container namespaces
sed -i 's/^CheckSpace/#CheckSpace/' /etc/pacman.conf

# Initialize and populate base OS keyrings
pacman-key --init
if [ "$ARCH" = "aarch64" ]; then
    pacman-key --populate archlinuxarm
else
    pacman-key --populate archlinux
fi

# Install prerequisites for strap.sh (curl, bsdtar/libarchive, gnupg, coreutils)
pacman -Syu --noconfirm curl libarchive gnupg coreutils

# Download and verify official BlackArch strap.sh
curl -fsSL https://blackarch.org/strap.sh -o /tmp/strap.sh
echo "d338a4bb95d9e09f97508da68ac9e17d963b85f6  /tmp/strap.sh" | sha1sum -c

# Execute strap.sh (note: without /dev/tty in container builds, it skips pacman -Su)
chmod +x /tmp/strap.sh
/tmp/strap.sh
rm -f /tmp/strap.sh

# Enable [multilib] on x86_64 only (Arch Linux ARM does not have multilib)
if [ "$ARCH" = "x86_64" ]; then
    sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
fi

# Perform full system upgrade (required since strap.sh skips -Su without a tty)
pacman -Syu --noconfirm

# Clean package caches to keep image lightweight
pacman -Scc --noconfirm
rm -rf /var/cache/pacman/pkg/* /tmp/*
