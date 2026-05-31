---
layout: post
title: Kaggle 中使用 Conda 的方法
date: 2026-05-31 22:12 +0800
description: '在 Kaggle Notebook 中安装和配置 Miniconda，创建虚拟环境并运行项目的完整教程'
category: [教程, Kaggle]
tags: [kaggle, conda, miniconda, python, 虚拟环境]
published: true
sitemap: true
---

在 Kaggle Notebook 中使用 Conda 可以更好地管理 Python 环境和依赖包。本文介绍如何在 Kaggle 中安装 Miniconda、创建虚拟环境并运行项目。

## 1. 查看当前 Python 环境
创建notebook后在单元格中运行
```python
!python -V
```

## 2. 下载并安装 Miniconda

```python
# 设置安装目录
root_dir = "/kaggle/conda"
!mkdir -p $root_dir

# 切换到安装目录
%cd /kaggle/conda

# 下载 Miniconda 安装包
!wget -q --show-progress https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# 确认下载文件存在
!ls

# 安装 Miniconda
!bash Miniconda3-latest-Linux-x86_64.sh -b -p $root_dir/miniconda3 -f
```

## 3. 初始化 Conda

```python
# 初始化 conda
!$root_dir/miniconda3/bin/conda init

# 接受许可协议（main 频道）
!$root_dir/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main

# 接受许可协议（R 频道）
!$root_dir/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
```

## 4. 创建 Conda 环境

```python
# 创建名为 gvhmr 的 Python 3.10 环境
!$root_dir/miniconda3/bin/conda create --name gvhmr python=3.10 -y

# 列出所有 conda 环境
!$root_dir/miniconda3/bin/conda env list
```

## 5. 进入 Conda 环境

```python
# 激活环境
!source $root_dir/miniconda3/bin/activate gvhmr
```

## 6. 安装项目依赖

```python
# 切换到代码目录（示例路径）
%cd /kaggle/input/datasets/some123we/gvhmr-code/GVHMR/GVHMR

# 安装 chumpy（需提前安装，避免构建隔离问题）
!source $root_dir/miniconda3/bin/activate gvhmr; pip install chumpy --no-build-isolation

# 安装 requirements.txt 中的依赖
!source $root_dir/miniconda3/bin/activate gvhmr; pip install -r requirements.txt
```

## 7. 处理只读目录问题

Kaggle 的 `/kaggle/input/` 目录是只读的，无法进行可编辑安装（`pip install -e .`）。需要将代码复制到 `/kaggle/working/` 目录：

```python
# 查看当前路径
!pwd

# 复制代码到 working 目录
!cp -r /kaggle/input/datasets/some123we/gvhmr-code/GVHMR/GVHMR /kaggle/working/GVHMR

# 切换到 working 目录
%cd /kaggle/working/GVHMR

# 可编辑安装项目
!source $root_dir/miniconda3/bin/activate gvhmr; pip install -e .

# 创建输出目录
!mkdir ../output
```

## 8. 运行训练/推理命令

```python
# 运行 demo 脚本
!source $root_dir/miniconda3/bin/activate gvhmr; python /kaggle/working/GVHMR/tools/demo/demo_folder.py \
    -f /kaggle/input/datasets/some123we/gvhmr-code/video/data/h36m_videos \
    -d /kaggle/working/output \
    -s
```

## 注意事项

1. **路径问题**：每次使用 `!` 执行命令时都是新 shell，因此每次都需要重新激活 conda 环境
2. **目录权限**：`/kaggle/input/` 是只读的，需要复制到 `/kaggle/working/` 才能进行写操作
3. **环境持久化**：Kaggle Notebook 重启后需要重新安装和配置 Conda

## 参考链接

- [如何在 Kaggle 中使用 miniconda](https://blog.csdn.net/weixin_41446370/article/details/147921915)
