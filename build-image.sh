#!/usr/bin/env bash
# build-image.sh - Qt SDK 多架构镜像统一构建入口（版本/路径/镜像名均可变量覆盖）
#
# 用法:
#   ./build-image.sh amd64
#   ./build-image.sh arm64
#   ./build-image.sh loong64
#
# 可通过环境变量覆盖:
#   IMAGE_OWNER=myorg QT_VERSION=5.12.12 ./build-image.sh amd64
#
set -e

IMAGE_OWNER="${IMAGE_OWNER:-linfulong}"
IMAGE_NAME="${IMAGE_OWNER}/qt-sdk"
QT_VERSION="${QT_VERSION:-5.7.1}"
QT_PREFIX="/opt/qt${QT_VERSION//./}"

ARCH=${1:-amd64}

case "$ARCH" in
    amd64)
        PLATFORM=linux/amd64
        ;;
    arm64)
        PLATFORM=linux/arm64
        ;;
    loong64)
        PLATFORM=linux/loong64
        ;;
    *)
        echo "Unsupported arch: $ARCH"
        echo "Usage:"
        echo "  $0 amd64"
        echo "  $0 arm64"
        echo "  $0 loong64"
        exit 1
esac

TAG="${QT_VERSION}-${ARCH}"
DOCKERFILE="docker/${ARCH}/Dockerfile"
QT_TARBALL="qt-everywhere-opensource-src-${QT_VERSION}.tar.xz"

echo "====================================="
echo "Building Qt ${QT_VERSION} SDK image"
echo "Owner:      ${IMAGE_OWNER}"
echo "Qt prefix:  ${QT_PREFIX}"
echo "Image:      ${IMAGE_NAME}:${TAG}"
echo "Platform:   ${PLATFORM}"
echo "Dockerfile: ${DOCKERFILE}"
echo "====================================="

docker buildx build \
    --platform=${PLATFORM} \
    -f ${DOCKERFILE} \
    -t ${IMAGE_NAME}:${TAG} \
    --build-arg QT_VERSION="${QT_VERSION}" \
    --build-arg QT_PREFIX="${QT_PREFIX}" \
    --build-arg QT_TARBALL="${QT_TARBALL}" \
    --load .

echo ""
echo "Built: ${IMAGE_NAME}:${TAG}"
