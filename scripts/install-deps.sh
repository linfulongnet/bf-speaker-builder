#!/usr/bin/env bash
# install-deps.sh - 安装 Qt 5.7.1 编译依赖
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

info() { echo "  [INFO] $*"; }

info "Updating package index..."
apt-get update

info "Installing build essentials and development libraries..."
apt-get install -y \
    build-essential \
    perl \
    python \
    git \
    wget \
    xz-utils \
    gperf \
    bison \
    flex \
    libfontconfig1-dev \
    libfreetype6-dev \
    libx11-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxrender-dev \
    libxcb1-dev \
    libxcb-keysyms1-dev \
    libxcb-image0-dev \
    libxcb-shm0-dev \
    libxcb-icccm4-dev \
    libxcb-sync-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-xinerama0-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libusb-1.0-0-dev \
    pkg-config \
    libhidapi-dev \
    libudev-dev \
    libasound2-dev \
    libpulse-dev \
    binutils-dev

info "Dependencies installed successfully."
