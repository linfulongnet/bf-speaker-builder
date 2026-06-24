# Qt 5.7.1 多架构 SDK Docker 镜像设计方案

## 一、设计目标

构建一套长期维护的 Qt SDK 镜像体系，用于：

* Qt 5.7.1 开发环境
* Qt 静态编译
* Docker化管理
* 多架构支持
* CI/CD集成
* 后续支持 LoongArch

---

## 二、支持平台

| 平台    | 架构              |
| ----- | --------------- |
| Linux | x86_64          |
| Linux | ARM64           |
| Linux | LoongArch64（预留） |

---

## 三、设计原则

### Qt静态

Qt组件：

```text
libQt5Core.a
libQt5Gui.a
libQt5Widgets.a
...
```

全部静态编译。

---

### glibc动态

保留：

```text
glibc
libpthread
libdl
librt
```

动态链接。

原因：

* 兼容国产Linux发行版
* 避免glibc版本冲突
* 降低可执行文件体积

---

### SDK镜像职责单一

镜像仅提供：

```text
Qt SDK
编译工具链
常用开发库
```

不包含任何业务项目。

---

## 四、目录结构

```text
qt-sdk/

├── docker
│
│   ├── amd64
│   │   └── Dockerfile
│   │
│   ├── arm64
│   │   └── Dockerfile
│   │
│   └── loong64
│       └── Dockerfile
│
├── scripts
│   ├── install-deps.sh
│   ├── build-qt.sh
│   ├── verify.sh
│   └── common.sh
│
├── patches
│   ├── arm64
│   └── loong64
│
├── qt-src
│   └── qt-everywhere-opensource-src-5.7.1
│
└── build-image.sh
```

---

## 五、镜像命名规范

推荐：

```text
linfulong/qt571-sdk:5.7.1-amd64

linfulong/qt571-sdk:5.7.1-arm64

linfulong/qt571-sdk:5.7.1-loong64
```

避免：

```text
x86_64-1.0
aarch64-1.0
```

因为：

```text
5.7.1-amd64
```

直接体现：

* Qt版本
* CPU架构

后续升级：

```text
5.12.12-amd64

5.15.16-amd64
```

也保持统一。

---

## 六、Dockerfile策略

### 推荐方案

每个架构独立Dockerfile

```text
docker/

├── amd64/Dockerfile
├── arm64/Dockerfile
└── loong64/Dockerfile
```

原因：

Qt 5.7.1年代较老。

未来：

ARM64

可能需要：

```bash
-no-pch
```

LoongArch

可能需要：

```bash
patch -p1
```

不同架构逐渐产生差异。

独立Dockerfile维护成本最低。

---

## 七、公共脚本

### install-deps.sh

负责：

```text
apt update
安装编译工具
安装XCB依赖
安装音频依赖
安装字体依赖
```

---

### build-qt.sh

负责：

```text
configure
make
make install
```

---

### verify.sh

负责验证：

```text
qmake
moc
uic
rcc
Qt模块
```

---

## 八、Qt安装目录

统一：

```text
/opt/qt571
```

目录结构：

```text
/opt/qt571

├── bin
├── include
├── lib
├── plugins
├── qml
└── translations
```

---

## 九、推荐Qt配置

```bash
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
-prefix /opt/qt571
```

---

## 十、镜像构建流程

### 构建AMD64

```bash
./build-image.sh amd64
```

生成：

```text
linfulong/qt571-sdk:5.7.1-amd64
```

---

### 构建ARM64

```bash
./build-image.sh arm64
```

生成：

```text
linfulong/qt571-sdk:5.7.1-arm64
```

---

### 构建LoongArch

```bash
./build-image.sh loong64
```

生成：

```text
linfulong/qt571-sdk:5.7.1-loong64
```

---

## 十一、ARM64构建策略

### 开发阶段

采用：

```text
Docker Buildx
QEMU
```

构建：

```bash
docker buildx build \
--platform linux/arm64
```

用于验证。

---

### 发布阶段

推荐：

```text
飞腾
鲲鹏
```

原生ARM64机器。

原因：

Qt 5.7.1编译时间极长。

QEMU：

```text
3~10小时
```

原生：

```text
30~60分钟
```

---

## 十二、LoongArch规划

Qt 5.7.1不原生支持LoongArch。

未来：

```text
patches/loong64
```

目录维护补丁。

不影响：

```text
amd64
arm64
```

现有镜像。

---

## 十三、CI/CD规划

统一入口：

```bash
./build-image.sh amd64

./build-image.sh arm64

./build-image.sh loong64
```

支持：

* GitLab CI
* GitHub Actions
* Jenkins

---

## 十四、最终推荐方案

推荐：

✓ 多架构独立Dockerfile

✓ 公共脚本复用

✓ Qt静态编译

✓ glibc动态链接

✓ SDK镜像职责单一

✓ ARM64先QEMU验证

✓ ARM64最终原生编译

✓ LoongArch预留补丁体系

适用于长期维护的Qt SDK基础设施。
