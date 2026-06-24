FROM ubuntu:18.04

LABEL maintainer="linfulong"
LABEL description="Qt 5.7.1 static SDK - LoongArch64 (预留)"

ARG QT_VERSION=5.7.1
ARG QT_PREFIX=/opt/qt571
ARG QT_TARBALL=qt-everywhere-opensource-src-5.7.1.tar.xz

ENV QTDIR=${QT_PREFIX}
ENV PATH=${QT_PREFIX}/bin:$PATH
ENV QT_VERSION=${QT_VERSION}
ENV QT_PREFIX=${QT_PREFIX}
ENV DEBIAN_FRONTEND=noninteractive

# 安装系统依赖
COPY scripts/ /tmp/scripts/
RUN bash /tmp/scripts/install-deps.sh

# 复制 Qt 源码
COPY qt-src/${QT_TARBALL} /tmp/

# 将来 LoongArch 可能需要打补丁，示例：
# COPY patches/loong64/ /tmp/patches/
# RUN cd /tmp/qt-everywhere-opensource-src-${QT_VERSION} && patch -p1 < /tmp/patches/loongarch-port.patch

# 编译安装 Qt
RUN bash /tmp/scripts/build-qt.sh

# 验证产物
RUN bash /tmp/scripts/verify.sh

# 清理构建脚本
RUN rm -rf /tmp/scripts
