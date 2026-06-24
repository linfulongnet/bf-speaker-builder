FROM ubuntu:18.04

LABEL maintainer="linfulong"
LABEL description="Qt 5.7.1 static SDK - ARM64"

ENV DEBIAN_FRONTEND=noninteractive

# 安装系统依赖
COPY scripts/ /tmp/scripts/
RUN bash /tmp/scripts/install-deps.sh

# 复制 Qt 源码
COPY qt-src/qt-everywhere-opensource-src-5.7.1.tar.xz /tmp/

# 编译安装 Qt（ARM64 需要 -no-pch，已内置在 build-qt.sh 中）
RUN bash /tmp/scripts/build-qt.sh

# 验证产物
RUN bash /tmp/scripts/verify.sh

# 清理构建脚本
RUN rm -rf /tmp/scripts

ENV QTDIR=/opt/qt571
ENV PATH=/opt/qt571/bin:$PATH
