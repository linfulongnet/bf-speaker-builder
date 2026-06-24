# Qt 5.7.1 多架构 SDK Docker 镜像

基于 Ubuntu 18.04，为 amd64 / arm64 / loong64 构建 Qt 5.7.1 静态编译 SDK 的 Docker 镜像工具。

## 设计要点

- Qt 组件**全部静态编译**（`libQt5Core.a`、`libQt5Gui.a`、`libQt5Widgets.a` …）
- glibc / libpthread / libdl 保留**动态链接**，兼容国产 Linux 发行版
- 镜像仅含 Qt SDK + 编译工具链 + 常用开发库，不包含业务项目
- **镜像仓库用户名**可通过环境变量 `IMAGE_OWNER` 覆盖（默认 `linfulong`）
- **Qt 安装路径**由 `QT_VERSION` 自动生成（如 `5.7.1` → `/opt/qt571`）

## 支持架构

| 架构 | 状态 |
|------|------|
| amd64 | 已支持 |
| arm64 | 已支持（QEMU cross-build 验证，生产建议飞腾/鲲鹏原生编译） |
| loong64 | 预留（需要 LoongArch 补丁） |

## 配置变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `IMAGE_OWNER` | `linfulong` | Docker 镜像仓库用户名 / 组织名 |
| `QT_VERSION` | `5.7.1` | Qt 版本号，决定镜像 Tag 和安装路径 |

`QT_VERSION` 去掉点号后拼接为安装路径：`/opt/qt${QT_VERSION//./}`。如 `5.7.1` → `/opt/qt571`。

所有 Dockerfile 通过 `--build-arg` 接收这些参数，`scripts/common.sh` 也从环境变量读取，保证一致。

## 获取 Qt 5.7.1 源码

下载 `qt-everywhere-opensource-src-5.7.1.tar.xz` 放到 `qt-src/` 目录下。

**官方地址：**

```
https://download.qt.io/archive/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz
```

**国内镜像（任选）：**

- 清华 TUNA：
  `https://mirrors.tuna.tsinghua.edu.cn/qt/archive/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz`

- 中科大 USTC：
  `https://mirrors.ustc.edu.cn/qtproject/archive/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz`

- 华为云：
  `https://mirrors.huaweicloud.com/qt/archive/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz`

## 依赖

- Docker ≥ 20.10（需 `buildx` 支持）
- 磁盘空间 ≥ 15 GB（Qt 源码 + 编译产物）

## 快速开始

```bash
# 1. 下载 Qt 源码
mkdir -p qt-src
wget -P qt-src/ https://download.qt.io/archive/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz

# 2. 构建镜像（默认配置）
./build-image.sh amd64

# 或指定自定义镜像仓库名 / Qt 版本
# IMAGE_OWNER=myorg QT_VERSION=5.7.1 ./build-image.sh amd64

# 3. 查看产物
docker images | grep qt-sdk
```

构建 ARM64 需先注册 QEMU：

```bash
docker run --rm --privileged tonistiigi/binfmt --install arm64
./build-image.sh arm64
```

## 项目结构

```
├── build-image.sh          # 统一构建入口（变量：IMAGE_OWNER, QT_VERSION）
├── docker/
│   ├── amd64/Dockerfile    # 通过 ARG 接收 QT_PREFIX / QT_TARBALL
│   ├── arm64/Dockerfile
│   └── loong64/Dockerfile
├── scripts/
│   ├── common.sh           # 公共变量与函数（从环境变量读取配置）
│   ├── install-deps.sh     # 系统依赖安装
│   ├── build-qt.sh         # Qt 配置、编译、安装
│   └── verify.sh           # 编译产物验证
├── patches/
│   ├── arm64/              # ARM64 补丁
│   └── loong64/            # LoongArch 补丁
└── qt-src/                 # 放置 Qt 源码包（.gitignore 排除）
```

## 镜像名称

| 架构 | 生成规则 |
|------|----------|
| amd64 | `${IMAGE_OWNER}/qt-sdk:${QT_VERSION}-amd64` |
| arm64 | `${IMAGE_OWNER}/qt-sdk:${QT_VERSION}-arm64` |
| loong64 | `${IMAGE_OWNER}/qt-sdk:${QT_VERSION}-loong64` |

默认示例：`linfulong/qt-sdk:5.7.1-amd64`

## 使用镜像

```bash
# 拉取镜像（替换为实际的 IMAGE_OWNER 和 QT_VERSION）
docker pull ${IMAGE_OWNER}/qt-sdk:${QT_VERSION}-amd64

# 挂载项目编译
docker run --rm -v $(pwd)/my-project:/src ${IMAGE_OWNER}/qt-sdk:${QT_VERSION}-amd64 \
    sh -c "cd /src && qmake && make"
```

## CI/CD 集成

GitHub Actions 示例：

```yaml
- name: Build Qt project
  env:
    IMAGE_OWNER: linfulong
    QT_VERSION: 5.7.1
  run: |
    docker run --rm -v ${{ github.workspace }}:/src \
      $IMAGE_OWNER/qt-sdk:$QT_VERSION-amd64 \
      sh -c "cd /src && qmake && make"
```

## ARM64 注意事项

- **开发验证**：QEMU 模拟编译约 3~10 小时，仅用于验证可行性和 Dockerfile 正确性
- **生产构建**：在飞腾/鲲鹏原生 ARM64 机器上编译约 30~60 分钟
- **no-pch**：ARM64 平台已默认启用 `-no-pch`，避免预编译头兼容问题

## LoongArch 路线图

Qt 5.7.1 不原生支持 LoongArch。未来通过 `patches/loong64/` 目录维护平台补丁，
在 Dockerfile 中取消注释补丁指令即可启用。

## License

MIT
