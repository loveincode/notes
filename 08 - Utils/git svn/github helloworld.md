## Intro
##  What is GitHub?
##  Create a Repository
##  Create a Branch

##  Make a Commit
##  Open a Pull Request

我尝试用类比的方法来解释一下 pull reqeust。想想我们中学考试，老师改卷的场景吧。你做的试卷就像仓库，你的试卷肯定会有很多错误，就相当于程序里的 bug。老师把你的试卷拿过来，相当于先 fork。在你的卷子上做一些修改批注，相当于 git commit。最后把改好的试卷给你，相当于发 pull request，你拿到试卷重新改正错误，相当于 merge。

当你想更正别人仓库里的错误时，要走一个流程：先 `fork` 别人的仓库，相当于拷贝一份，相信我，不会有人直接让你改修原仓库的 `clone` 到本地分支，做一些 bug fix发起 `pull request` 给原仓库，让他看到你修改的 bug原仓库 review 这个 bug，如果是正确的话，就会 merge 到他自己的项目中至此，整个 pull request 的过程就结束了。

理解了 pull request 的含义和流程，具体操作也就简单了。以 Github 排名最高的 https://github.com/twbs/bootstrap 为例说明。
1. 先点击 fork 仓库，项目现在就在你的账号下了

2. 在你自己的机器上 git clone 这个仓库，切换分支（也可以在 master 下），做一些修改。~  git clone https://github.com/beepony/bootstrap.git
~  cd bootstrap
~  git checkout -b test-pr
~  git add . && git commit -m "test-pr"
~  git push origin test-pr

3. 完成修改之后，回到 test-pr 分支，点击旁边绿色的 Compare & pull request 按钮

4. 添加一些注释信息，确认提交

5. 仓库作者看到，你提的确实是对的，就会 merge，合并到他的项目中

有一个仓库，叫Repo A。你如果要往里贡献代码，首先要Fork这个Repo，于是在你的Github账号下有了一个Repo A2,。
然后你在这个A2下工作，Commit，push等。然后你希望原始仓库Repo A合并你的工作，你可以在Github上发起一个Pull Request，意思是请求Repo A的所有者从你的A2合并分支。如果被审核通过并正式合并，这样你就为项目A做贡献了

##  Merge Pull Request
