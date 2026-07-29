---
layout: post
title: python中matplotlib字体和负号修复
date: 2026-05-31 22:27 +0800
description: ''
image: ''
category: ''
tags: []
published: false
sitemap: false
---
import numpy as np
import matplotlib.pyplot as plt

# 设置字体为 SimHei 显示中文
plt.rcParams['font.sans-serif'] = ['SimHei']
# 允许显示负号
plt.rcParams['axes.unicode_minus'] = False

# 屏蔽一下日志
import logging
logging.basicConfig(level=logging.WARNING)
