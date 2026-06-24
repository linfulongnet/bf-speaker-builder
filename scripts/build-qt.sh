#!/usr/bin/env bash
# build-qt.sh - 从源码配置、编译、安装 Qt 5.7.1
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

info "Extracting Qt source tarball..."
tar xf "/tmp/${QT_TARBALL}" -C /tmp

cd "${QT_SRC_DIR}"

info "Configuring Qt ${QT_VERSION} (static, prefix=${QT_PREFIX})..."
./configure \
    -static \
    -opensource \
    -confirm-license \
    -release \
    -qt-pcre \
    -qt-zlib \
    -qt-libpng \
    -qt-libjpeg \
    -qt-freetype \
    -qt-xcb \
    -fontconfig \
    -no-qml-debug \
    -no-cups \
    -no-pch \
    -no-opengl \
    -no-openssl \
    -nomake tests \
    -nomake examples \
    -skip qt3d \
    -skip qtcanvas3d \
    -skip qtconnectivity \
    -skip qtlocation \
    -skip qtpurchasing \
    -skip qtquickcontrols \
    -skip qtquickcontrols2 \
    -skip qtsensors \
    -skip qtserialbus \
    -skip qttools \
    -skip qtwebengine \
    -skip qtwebview \
    -skip qtactiveqt \
    -skip qtdeclarative \
    -skip qtcharts \
    -skip qtdatavis3d \
    -skip qtdoc \
    -skip qtgamepad \
    -skip qtgraphicaleffects \
    -skip qtsvg \
    -skip qtvirtualkeyboard \
    -skip qtscxml \
    -skip qtscript \
    -skip qtxmlpatterns \
    -prefix "${QT_PREFIX}"

info "Building Qt (make -j$(nproc))..."
make -j$(nproc)

info "Installing Qt to ${QT_PREFIX}..."
make install

info "Cleaning up build artifacts..."
rm -rf "${QT_SRC_DIR}" /tmp/${QT_TARBALL}

info "Qt ${QT_VERSION} build complete."
