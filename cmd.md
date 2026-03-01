# 本地查看网页修改效果
bundle exec jekyll serve
# 创建博客
bundle exec jekyll compose "My New Post" --post
bundle exec jekyll compose "My New Post" --collection "posts"
# 创建草稿
bundle exec jekyll compose "RM工程组经历" --collection "drafts"
# 重命名草稿
bundle exec jekyll rename _drafts/my-new-draft.md "My Renamed Draft"
# 发布草稿
bundle exec jekyll publish _drafts/my-new-draft.md --date 2014-01-24
# 重命名博客
bundle exec jekyll rename _posts/2014-01-24-my-new-post.md "My Old Post" --date "2012-03-04"
bundle exec jekyll rename _posts/2012-03-04-my-old-post.md "My New Post" --now
# 取消发布
bundle exec jekyll unpublish _posts/2014-01-24-my-new-draft.md
# 创建自定义集合（需在配置文件中设置）
bundle exec jekyll compose "My New Thing" --collection "things"
# 图片标题
![img-description](/path/to/image)
_Image Caption_
# 图片宽高
![Desktop View](/assets/img/sample/mockup.png){: w="700" h="400" }
# 图片位置（normal可换left right ，换后不能加标题）
![Desktop View](/assets/img/sample/mockup.png){: .normal }
# 指定亮暗模式下显示的图片
![Light mode only](/path/to/light-mode.png){: .light }
![Dark mode only](/path/to/dark-mode.png){: .dark }
# 阴影效果
![Desktop View](/assets/img/sample/mockup.png){: .shadow }
# 文章顶部添加图片（放到---内，1200 x 630，）
---
image:
  path: /path/to/image
  alt: image alternative text
---
# 图片占位符，加快加载速度
---
image:
  lqip: /path/to/lqip-file # or base64 URI
---
或
![Image description](/path/to/image){: lqip="/path/to/lqip-file" }
# 置顶帖
---
pin: true
---
# 提示类型（tip, info, warning, and danger）
> Example line for prompt.
{: .prompt-info }
# 内联代码
`inline code part`
# 文件路径高亮
`/path/to/a/file.extend`{: .filepath}
# 块状代码（指定语言，指定无行号）
```shell
echo 'No more line numbers!'
```
{: .nolineno }
# 指定文件路径代替语言类型显示
```shell
# content
```
{: file="path/to/file" }
# 数学功能（MathJax ）
---
math: true
---
# 流程图
---
mermaid: true
---
