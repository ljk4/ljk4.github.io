#!/usr/bin/env ruby
# frozen_string_literal: true

# 扫描 _posts/ 目录，自动更新 README.md 中的文章目录部分。
# 在 README.md 中使用标记注释：
#   <!-- ARTICLES_START -->
#   <!-- ARTICLES_END -->
# 脚本会替换这两个标记之间的内容。

require 'yaml'
require 'time'

POSTS_DIR = File.join(__dir__, '..', '_posts')
README_PATH = File.join(__dir__, '..', 'README.md')

START_MARKER = '<!-- ARTICLES_START -->'
END_MARKER = '<!-- ARTICLES_END -->'

def parse_front_matter(filepath)
  content = File.read(filepath, encoding: 'utf-8')
  return nil unless content.start_with?("---\n")

  parts = content.split("---\n", 3)
  return nil if parts.length < 3

  YAML.safe_load(parts[1])
rescue Psych::SyntaxError
  nil
end

def get_all_posts
  posts = []
  return posts unless Dir.exist?(POSTS_DIR)

  Dir.glob(File.join(POSTS_DIR, '*.md')).each do |filepath|
    filename = File.basename(filepath)
    next if filename == '.placeholder'

    fm = parse_front_matter(filepath)
    title = fm&.dig('title') || filename
    description = fm&.dig('description') || ''
    date = filename[0..9] # YYYY-MM-DD
    slug = File.basename(filename, '.md')[11..] # 去掉 YYYY-MM-DD- 前缀
    url = "https://ljk4.github.io/posts/#{slug}/"

    posts << { title: title, description: description.to_s, date: date, url: url }
  end

  posts.sort_by { |p| p[:date] }.reverse
end

def generate_article_table(posts)
  lines = []
  lines << "共 **#{posts.length}** 篇文章\n"
  lines << '| 日期 | 标题 |'
  lines << '|------|------|'

  posts.each do |p|
    lines << "| #{p[:date]} | [#{p[:title]}](#{p[:url]}) |"
  end

  lines.join("\n")
end

def update_readme
  posts = get_all_posts
  if posts.empty?
    puts '未找到任何文章，跳过更新。'
    return
  end

  table = generate_article_table(posts)
  readme = File.read(README_PATH, encoding: 'utf-8')

  pattern = /(#{Regexp.escape(START_MARKER)})(.*?)(#{Regexp.escape(END_MARKER)})/m

  unless readme.match?(pattern)
    puts "错误：README.md 中未找到 #{START_MARKER} ... #{END_MARKER} 标记"
    return
  end

  new_readme = readme.gsub(pattern, "\\1\n#{table}\n\\3")
  File.write(README_PATH, new_readme, encoding: 'utf-8')

  puts "已更新 README.md，共 #{posts.length} 篇文章。"
end

update_readme
