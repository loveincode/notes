让我们分析如何在ZooKeeper集合中选举leader节点。考虑一个集群中有N个节点。leader选举的过程如下：

  * 所有节点创建具有相同路径 `/app/leader_election/guid_` 的顺序、临时节点。
  * ZooKeeper集合将附加10位序列号到路径
    创建的znode将是 `/app/leader_election/guid_0000000001`，`/app/leader_election/guid_0000000002`等。
  * 对于给定的实例，在znode中创建`最小数字`的节点成为`leader`，而所有其他节点是`follower`。
  * 每个`follower节点`监视下一个具有`最小数字的znode`。例如，
    创建znode/app/leader_election/guid_000000000`8`的节点将监视znode/app/leader_election/guid_000000000`7`，
    创建znode/app/leader_election/guid_000000000`7`的节点将监视znode/app/leader_election/guid_000000000`6`。
  * 如果leader关闭，则其相应的`znode/app/leader_electionN`会被删除。
  * 下一个在线follower节点将通过监视器获得关于leader移除的通知。
  * 下一个在线follower节点将检查是否存在其他具有最小数字的znode。
    如果没有，那么它将承担leader的角色。
    否则，它找到的创建具有最小数字的znode的节点将作为leader。
  * 类似地，所有其他follower节点选举创建具有最小数字的znode的节点作为leader。

  leader选举是一个复杂的过程，但ZooKeeper服务使它非常简单。
