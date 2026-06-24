#!/usr/bin/env bash
# common.sh - Qt 5.7.1 SDK 共享变量与函数
set -euo pipefail

export QT_VERSION="5.7.1"
export QT_PREFIX="/opt/qt571"
export QT_SRC_DIR="/tmp/qt-everywhere-opensource-src-${QT_VERSION}"
export QT_TARBALL="qt-everywhere-opensource-src-${QT_VERSION}.tar.xz"

# 颜色输出
info()  { echo "  [INFO] $*"; }
warn()  { echo "  [WARN] $*" >&2; }
fatal() { echo "  [FATAL] $*" >&2; exit 1; }
