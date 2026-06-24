#!/usr/bin/env bash
# build-image.sh - Qt 5.7.1 多架构 SDK 镜像统一构建入口
#
# 用法:
#   ./build-image.sh amd64
#   ./build-image.sh arm64
#   ./build-image.sh loong64
#
set -e

IMAGE_NAME=linfulong/qt-sdk
QT_VERSION=5.7.1

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

echo "====================================="
echo "Building Qt ${QT_VERSION} SDK image"
echo "Image:      ${IMAGE_NAME}:${TAG}"
echo "Platform:   ${PLATFORM}"
echo "Dockerfile: ${DOCKERFILE}"
echo "====================================="

docker buildx build \
    --platform=${PLATFORM} \
    -f ${DOCKERFILE} \
    -t ${IMAGE_NAME}:${TAG} \
    --load .

echo ""
echo "Done:"
echo "docker images | grep ${IMAGE_NAME}"
