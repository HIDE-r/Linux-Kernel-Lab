# Linux Kernel Lab

一个类似 OpenWrt 风格的分层构建实验项目：
- 统一把产物放在 `output/`，不污染源码目录
- 通过 `host-tools/`、`board/`、`platform/`、`package/` 分阶段构建
- 支持本机构建与 Docker 构建

## 目录说明

- `makefiles/`: 顶层构建规则与公共宏
- `host-tools/`: 宿主工具构建（如 `config/mconf`）
- `board/`: 板级配置
- `platform/`: 平台源码下载/编译（当前是 Linux 6.18.9）
- `package/`: 软件包下载/编译（当前含 busybox）
- `scripts/`: 辅助脚本（如 `staging_env.sh`）
- `docker/`: Dockerfile 与容器启动脚本
- `output/`: 构建输出目录（下载、构建中间件、staging 等）

## 环境要求

最少需要：
- `make`
- GNU toolchain（含 `gcc`/`g++`）
- `wget`、`tar`、`xz`、`bzip2`
- `perl`（时间戳脚本会用到）
- `ncurses` 开发库（`menuconfig` 需要）

交叉编译环境变量必须设置：
- `ARCH`（例如 `arm64`）
- `CROSS_COMPILE`（例如 `aarch64-linux-gnu-`）

可选下载缓存目录：
- `CONFIG_EXTERNAL_DL_DIR`（在 `.config` 中设置，默认空，空时使用 `output/dl`）
  - 绝对路径：直接使用
  - 相对路径：相对于项目根目录解析
- `DL_DIR`（命令行临时覆盖，优先级高于 `.config`）

## 快速开始（本机）

1. 加载环境变量（示例）

```bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
```

或使用仓库自带 `.envrc`（配合 `direnv`）。

2. 生成/选择配置

```bash
make menuconfig
```

3. 执行完整构建

```bash
make world -j"$(nproc)"
```

如需提前下载（避免编译阶段联网）：

```bash
make download
```

使用外部下载目录：

```bash
make download DL_DIR=/path/to/shared-dl
```

也可以通过配置文件持久化（推荐）：

```bash
make menuconfig
# Global build settings -> External download cache directory
```

## 常用目标

- `make menuconfig`: 配置入口
- `make world`: 执行完整流程（board + platform + package）
- `make download`: 仅执行 platform/package 下载阶段
- `make host-tools/compile`: 仅构建 host tools
- `make platform/compile`: 仅构建 platform
- `make package/compile`: 仅构建 package
- `make distclean`: 清理 `.config*` 与 `output/`

失败排查建议：
- 首次排错用 `make -j1 V=s <target>` 查看完整错误输出

## Docker 用法

1. 先构建镜像

```bash
export ARCH=arm64
make dockerfile
```

2. 在容器里执行构建

```bash
./docker/docker_run.sh make world -j"$(nproc)"
```

3. 进入容器交互环境

```bash
./docker/docker_run.sh
```

说明：
- Docker 脚本使用环境变量 `DOCKER_IAMGE`（保留项目里的这个拼写）
- 可在 `.envrc` 里配置 `DOCKER_IAMGE`、`PROJECT_DIR_PATH`、`DOCKERFILE`、`DOCKER_ENV_FILE`

## staging host 工具优先

用于手工调试时优先使用 `output/staging_dir/host` 下的工具，避免误用宿主机工具。

启用（当前 shell）：

```bash
source scripts/staging_env.sh
```

恢复（当前 shell）：

```bash
source scripts/staging_env.sh --off
```

仅对单条命令生效：

```bash
scripts/staging_env.sh --run <cmd> [args...]
```

查看导出结果：

```bash
scripts/staging_env.sh --print
```

## 输出目录约定

- `output/dl/`: 下载缓存（默认，可通过 `DL_DIR` 覆盖）
- `output/build/`: 构建中间目录
- `output/staging_dir/host/`: host 工具安装目录
- `output/staging_dir/<arch>-<board>/rootfs/`: 目标 rootfs staging
- `output/staging_dir/stamp/`: 各阶段 stamp 文件
