---
layout: post
title: 完整指南：在Windows上安装并配置WSL与Docker
date: 2026-03-28 17:21 +0800
description: 详细介绍如何在Windows系统上安装配置WSL2和Docker，包括GPU支持、GUI应用运行等高级功能
category: '教程'
tags: [WSL, Docker, Windows, Linux, 容器化, GPU, 开发环境]
published: true
sitemap: true
---

## 前言

Windows Subsystem for Linux (WSL) 和 Docker 是现代开发环境中不可或缺的工具。WSL 让开发者能够在 Windows 上原生运行 Linux 环境，而 Docker 则提供了轻量级的容器化解决方案。本教程将详细介绍如何在 Windows 系统上完整配置 WSL2 和 Docker，包括 GPU 支持、GUI 应用运行等高级功能。

## 目录

- [系统要求](#系统要求)
- [WSL2 安装与配置](#wsl2-安装与配置)
- [Linux 发行版管理](#linux-发行版管理)
- [Docker 安装与配置](#docker-安装与配置)
- [GPU 支持配置](#gpu-支持配置)
- [GUI 应用支持](#gui-应用支持)
- [VS Code 集成](#vs-code-集成)
- [常见问题与解决方案](#常见问题与解决方案)
- [最佳实践与技巧](#最佳实践与技巧)
- [总结](#总结)

## 系统要求

### 硬件要求
- **处理器**: 支持虚拟化技术（Intel VT-x 或 AMD-V）
- **内存**: 建议 8GB 以上（16GB 更佳）
- **存储**: 至少 20GB 可用空间
- **GPU**: NVIDIA 显卡（如需 GPU 支持）

### 软件要求
- **操作系统**: Windows 10 2004 及更高版本，或 Windows 11
- **Windows 版本**: 建议使用 Windows 11 以获得最佳体验

## WSL2 安装与配置

### 步骤 1：启用 Windows 功能

首先，我们需要启用必要的 Windows 功能。有两种方法：

#### 方法 A：自动安装（推荐）
以管理员身份打开 PowerShell，运行：
```powershell
wsl --install
```

#### 方法 B：手动启用功能
如果自动安装失败，可以手动启用以下功能：

1. 按 `Win + S` 搜索"功能"，打开"启用或关闭 Windows 功能"
   ![搜索功能](/assets/img/WSL/搜索.png)

2. 勾选以下功能：
   - ✅ 适用于 Linux 的 Windows 子系统
   - ✅ 虚拟机平台
   - ✅ Windows 虚拟机监控程序平台
   - ✅ Hyper-V（可选，某些系统需要）

   ![需要启用的功能](/assets/img/WSL/需打开的功能.png)

3. 点击"确定"，重启计算机

### 步骤 2：设置 WSL2 为默认版本

重启后，打开 PowerShell，执行：
```powershell
# 设置 WSL2 为默认版本
wsl --set-default-version 2

# 检查当前 WSL 版本
wsl --version
```

### 步骤 3：查看可用的 Linux 发行版

```powershell
# 查看可安装的 Linux 发行版
wsl --list --online
```

常见可选发行版：
- Ubuntu 24.04 LTS
- Ubuntu 22.04 LTS
- Ubuntu 20.04 LTS
- Debian
- Kali Linux
- openSUSE
- Alpine Linux

## Linux 发行版管理

### 安装 Linux 发行版

```powershell
# 安装 Ubuntu 24.04
wsl --install -d Ubuntu-24.04

# 或者安装其他版本
wsl --install -d Ubuntu-22.04
wsl --install -d Debian
```

安装过程中会提示创建用户名和密码，建议设置简单的密码（如 `1`），因为会频繁使用。

### 管理已安装的发行版

```powershell
# 查看已安装的发行版
wsl --list --verbose
# 或简写
wsl -l -v

# 设置特定发行版为 WSL2
wsl --set-version <发行版名称> 2

# 设置默认发行版
wsl --set-default <发行版名称>

# 注销并删除发行版（谨慎使用）
wsl --unregister <发行版名称>

# 导出发行版备份
wsl --export <发行版名称> <备份路径>.tar

# 导入发行版
wsl --import <新名称> <安装路径> <备份文件>.tar
```

### WSL 迁移到其他磁盘

默认情况下，WSL 安装在 C 盘。如果空间不足，可以迁移到其他磁盘：

```powershell
# 1. 导出当前发行版
wsl --export Ubuntu-24.04 D:\wsl-backup\ubuntu.tar

# 2. 注销原发行版
wsl --unregister Ubuntu-24.04

# 3. 导入到新位置
wsl --import Ubuntu-24.04 D:\WSL\Ubuntu D:\wsl-backup\ubuntu.tar

# 4. 设置默认用户（需要查看原用户名）
# 在 WSL 中运行：cat /etc/passwd
```

详细迁移步骤可以参考我的另一篇文章：[WSL迁移到其他盘](/posts/wsl迁移到其他盘/)

## Docker 安装与配置

### 方法 1：使用官方或网络公开安装脚本（推荐）

在 WSL 中执行以下命令：

```bash
# 下载并运行官方安装脚本
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 将当前用户添加到 docker 组
sudo usermod -aG docker $USER

# 重新加载组权限
newgrp docker

# 验证安装
docker --version
docker run hello-world
```

### 方法 2：使用自定义安装脚本

<a href="/assets/files/install-docker.sh" download>点击下载安装脚本</a>

然后执行：
```bash
chmod +x ./install-docker.sh
sudo ./install-docker.sh
newgrp docker
```

<!-- ### 配置 Docker 代理（可选）

如果需要通过代理访问网络，配置 Docker 代理：

详细代理配置可以参考：[为WSL和Docker配置代理](/posts/wsl-docker-proxy-config/)

在WSL和docker容器中的验证命令：
'''
curl -I https://registry-1.docker.io/v2/ #访问docker hub
curl -I https://www.google.com #访问Google
''' -->
## GPU 支持配置

### 检查 GPU 状态

首先检查系统是否正确识别 GPU：

```bash
# 查看 NVIDIA GPU 信息
nvidia-smi
```
应当出现类似以下内容：
![nvidia-smi输出](/assets/img/WSL/GPU界面.png)
### 安装 NVIDIA Container Toolkit

```bash
# 步骤 1：配置生产存储库
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 步骤 2：更新包列表
sudo apt-get update

# 步骤 3：安装 NVIDIA Container Toolkit
sudo apt-get install -y nvidia-container-toolkit

# 步骤 4：配置 Docker 使用 NVIDIA runtime
sudo nvidia-ctk runtime configure --runtime=docker

# 步骤 5：重启 Docker 服务
sudo service docker restart
# 或
sudo systemctl restart docker
```

### 验证 GPU 支持

```bash
# 测试 GPU 是否可在容器中使用
docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

# 运行 CUDA 示例
docker run --rm --runtime=nvidia --gpus all nvidia/cuda:12.0-base nvidia-smi
```

## GUI 应用支持

### WSL 原生 GUI 支持

WSL2 支持直接运行 Linux GUI 应用，无需额外配置：

```bash
# 安装 GUI 应用
sudo apt-get update
sudo apt-get install -y gedit firefox

# 直接运行
gedit
firefox
```

安装的应用会自动出现在 Windows 开始菜单中。

### Docker 容器中的 GUI 应用

要在 Docker 容器中运行 GUI 应用，需要配置 X11 转发：

```bash
# 安装音频支持（可选）
sudo apt-get install -y pulseaudio alsa-utils

# 运行 GUI 应用的 Docker 容器
docker run -it \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /mnt/wslg:/mnt/wslg \
  -e DISPLAY=unix$DISPLAY \
  -e "PULSE_SERVER=${PULSE_SERVER}" \
  your-image-name
```

#### 示例：运行 Gazebo

```bash
# 创建支持 GUI 的 Dockerfile
cat > Dockerfile << EOF
FROM osrf/ros:humble-desktop

RUN apt-get update && apt-get install -y \
    gazebo \
    pulseaudio \
    alsa-utils \
    && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=unix$DISPLAY
ENV PULSE_SERVER=${PULSE_SERVER}
EOF

# 构建镜像
docker build -t ros-gazebo-gui .

# 运行带 GUI 的容器
docker run -it --rm \
  --runtime=nvidia \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /mnt/wslg:/mnt/wslg \
  -e DISPLAY=unix$DISPLAY \
  -e "PULSE_SERVER=${PULSE_SERVER}" \
  ros-gazebo-gui \
  gazebo
```

参考文章：[在Docker中运行GUI程序](https://blog.51cto.com/u_14344/9273312)
