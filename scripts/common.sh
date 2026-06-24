#!/usr/bin/env bash
# common.sh - Qt SDK 共享变量与函数（支持环境变量覆盖）
set -euo pipefail

export QT_VERSION="${QT_VERSION:-5.7.1}"
export QT_PREFIX="${QT_PREFIX:-/opt/qt${QT_VERSION//./}}"
export QT_SRC_DIR="/tmp/qt-everywhere-opensource-src-${QT_VERSION}"
export QT_TARBALL="qt-everywhere-opensource-src-${QT_VERSION}.tar.xz"

# 颜色输出
info()  { echo "  [INFO] $*"; }
warn()  { echo "  [WARN] $*" >&2; }
fatal() { echo "  [FATAL] $*" >&2; exit 1; }
