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
在 WSL2 中，由于 Docker 容器是运行在 Linux 子系统内部的虚拟化层，网络结构较为复杂。要让 WSL 和 Docker 都能使用代理，通常需要解决网络链路和环境变量配置两个问题。
根据你提供的 Docker 安装脚本，该脚本已经配置了基础的镜像加速器和用户权限。但由于容器内部是一个隔离的环境，它不会自动继承宿主机的代理设置。
以下是实现 WSL2 和 Docker 全局代理的方案：
第一步：获取 WSL 宿主机 IP
WSL2 是通过虚拟网卡与 Windows 通信的。在 WSL 中，Windows 宿主机的 IP 通常是你的代理服务器监听地址。
 * 在 WSL 中运行命令查看宿主机 IP：
   cat /etc/resolv.conf | grep nameserver | awk '{print $2}'

   假设得到的 IP 是 172.x.x.x，你的代理端口是 7890。
第二步：配置 WSL 全局代理
编辑你的 ~/.bashrc 文件：
 * nano ~/.bashrc
 * 在文件末尾添加以下内容（将 172.x.x.x:7890 替换为实际 IP 和端口）：
   export hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export https_proxy="http://${hostip}:7890"
export http_proxy="http://${hostip}:7890"
export all_proxy="socks5://${hostip}:7890"

 * 执行 source ~/.bashrc 使其生效。
第三步：配置 Docker 容器代理
虽然你的脚本配置了 daemon.json，但那是针对 Docker 引擎拉取镜像的。若要让 容器内部 联网（如 apt update 或 pip install）也走代理，需要配置 Docker 客户端。
 * 创建配置文件：
   mkdir -p ~/.docker
nano ~/.docker/config.json

 * 添加代理配置：
   写入以下内容：
   {
 "proxies": {
   "default": {
     "httpProxy": "http://172.x.x.x:7890",
     "httpsProxy": "http://172.x.x.x:7890",
     "noProxy": "localhost,127.0.0.1"
   }
 }
}

   注意：这里的 IP 建议使用具体的宿主机虚拟 IP，或者在 Clash 中开启 "Allow LAN"（允许局域网连接）。
第四步：Clash 必做设置（关键）
如果上述配置后仍无法联网，通常是因为 Clash 拦截了来自虚拟局域网的请求：
 * 开启 Allow LAN： 在 Clash 界面确保 Allow LAN 选项是打开的。
 * 设置系统防火墙： Windows 防火墙可能会拦截 WSL 的入站流量。可以尝试临时关闭防火墙测试，或者添加允许端口 7890 的入站规则。
验证安装
配置完成后，你可以再次运行你脚本中的验证步骤：
 * 执行 docker run --rm hello-world。
 * 如果能正常拉取并运行，说明 Docker 引擎和容器网络已通。
由于你之后可能需要进行 RoboMaster 相关的算法开发或模型训练，是否需要我为你提供一份针对深度学习环境（如 PyTorch/Cuda）的 Docker 镜像配置建议？