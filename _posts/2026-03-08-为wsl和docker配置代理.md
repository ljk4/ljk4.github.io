---
layout: post
title: 为WSL和Docker配置代理
date: 2026-03-08 00:26 +0800
description: ''
image: ''
category: ''
tags: []
published: false
sitemap: false
---
在 WSL 中为 Docker 配置代理可以帮助解决网络访问问题，尤其是在需要通过代理访问外部资源时。以下是详细的配置步骤。

1. 配置 WSL 的代理

步骤 1: 修改 .wslconfig 文件

在宿主机的用户目录下创建或编辑 .wslconfig 文件，添加以下内容：

[wsl2]
networkingMode=mirrored
autoProxy=true
localhostForwarding=true
dnsTunneling=true

步骤 2: 设置环境变量

编辑 WSL 的 ~/.bashrc 文件，在末尾添加以下内容：

export HTTP_PROXY="http://localhost:10809"
export HTTPS_PROXY="http://localhost:10809"

然后运行以下命令使更改生效：

source ~/.bashrc

1. 配置 Docker 的代理

步骤 1: 创建代理配置文件

在 WSL 中运行以下命令创建 Docker 守护进程的代理配置文件：

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo vi /etc/systemd/system/docker.service.d/http-proxy.conf

步骤 2: 添加代理设置

在文件中写入以下内容：

[Service]
Environment="HTTP_PROXY=http://localhost:10809/"
Environment="HTTPS_PROXY=http://localhost:10809/"

步骤 3: 重启 Docker 服务

执行以下命令以应用更改：

sudo systemctl daemon-reload
sudo systemctl restart docker

1. 验证配置

测试网络连接是否通过代理：

curl -I https://www.google.com

检查 Docker 是否正常工作：

docker run hello-world
