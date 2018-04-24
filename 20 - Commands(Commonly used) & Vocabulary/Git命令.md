## git clone

  git clone [url]

## git add
  git add 命令可将该文件添加到缓存，如我们添加以下两个文件：

## git status 命令用于查看项目的当前状态。

## git status -s

## git add .

## git diff

  尚未缓存的改动：git diff
  查看已缓存的改动： git diff --cached
  查看已缓存的与未缓存的所有改动：git diff HEAD
  显示摘要而非整个 diff：git diff --stat

## git commit

  git commit -m

  git commit -a

  git commit -am

## git reset HEAD

## git rm
从工作目录中手工删除文件
git rm <file>
git rm -f <file>
从暂存区域移除，但仍然希望保留在当前工作目录中
git rm --cached <file>

git mv README  README.md

## git push

## 历史

### git log

### git log --oneline 查看历史记录的简洁的版本

### git log --author=Linus --oneline -5 只想查找指定用户的提交日志可以使用命令：git log --author , 例如，比方说我们要找 Git 源码中 Linus 提交的部分：

### git log --oneline --before={3.weeks.ago} --after={2010-04-18} --no-merges
  你要指定日期，可以执行几个选项：--since 和 --before，但是你也可以用 --until 和 --after。
  例如，如果我要看 Git 项目中三周前且在四月十八日之后的所有提交，我可以执行这个（我还用了 --no-merges 选项以隐藏合并提交）：
