#!/usr/bin/env bash
# verify.sh - 验证 Qt SDK 编译产物
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

info "Verifying Qt ${QT_VERSION} installation at ${QT_PREFIX}..."

check_bin() {
    local tool="$1"
    if [ -x "${QT_PREFIX}/bin/${tool}" ]; then
        info "  [OK] ${tool}"
    else
        fatal "  [FAIL] ${tool} not found or not executable"
    fi
}

check_lib() {
    local lib="$1"
    if [ -f "${QT_PREFIX}/lib/${lib}" ]; then
        info "  [OK] ${lib}"
    else
        fatal "  [FAIL] ${lib} not found"
    fi
}

# 验证核心工具
info "Checking core Qt tools..."
check_bin qmake
check_bin moc
check_bin uic
check_bin rcc

# 验证静态库
info "Checking static libraries..."
check_lib libQt5Core.a
check_lib libQt5Gui.a
check_lib libQt5Widgets.a
check_lib libQt5Network.a
check_lib libQt5XcbQpa.a

# 打印 qmake 版本
info "qmake version:"
"${QT_PREFIX}/bin/qmake" -version

info "Verification complete - Qt ${QT_VERSION} SDK is ready."
