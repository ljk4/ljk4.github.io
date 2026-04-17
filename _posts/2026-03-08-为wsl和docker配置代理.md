---
layout: post
title: WSL和Docker配置代理
date: 2026-03-08 00:26 +0800
description: 为WSL和Docker配置HTTP/HTTPS代理
category: '教程'
tags: [WSL, Docker, 代理, 网络配置]
published: false
sitemap: false
---

## 配置WSL代理

### 1. 修改.wslconfig文件

在Windows用户目录创建/编辑`.wslconfig`文件：
```ini
[wsl2]
networkingMode=mirrored
autoProxy=true
localhostForwarding=true
dnsTunneling=true
```

### 2. 设置环境变量

编辑`~/.bashrc`文件，添加（7890替换为自己代理的端口，下同）：
```bash
export HTTP_PROXY="http://localhost:7890"
export HTTPS_PROXY="http://localhost:7890"
```

使配置生效：
```bash
source ~/.bashrc
```

## 配置Docker代理

### 1. 创建配置文件

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
```

### 2. 添加代理设置

在文件中写入：
```ini
[Service]
Environment="HTTP_PROXY=http://localhost:7890/"
Environment="HTTPS_PROXY=http://localhost:7890/"
```

### 3. 重启Docker

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 验证配置

### 测试网络连接
```bash
curl -I https://www.google.com
```

### 测试Docker
```bash
docker run hello-world
```
