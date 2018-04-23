https://juejin.im/post/5adc6cc16fb9a07ac90ccae8

流程：

1. ```push```代码到```Github```触发```WebHook```。（因网络原因，本篇使用```gitee```）
2. ```Jenkins```从仓库拉去代码
3. ```maven```构建项目
4. 代码静态分析
5. 单元测试
6. ```build```镜像
7. ```push```镜像到镜像仓库（本篇使用的镜像仓库为网易镜像仓库）
8. 更新服务


Jenkins
  **Pipelines**


gitee集成WebHooks

Pipeline的几个基本概念： 更多Pipeline语法参考：pipeline 语法详解http://www.cnblogs.com/fengjian2016/p/8227532.html

Stage: 阶段，一个Pipeline可以划分为若干个Stage，每个Stage代表一组操作。注意，Stage是一个逻辑分组的概念，可以跨多个Node。
Node: 节点，一个Node就是一个Jenkins节点，或者是Master，或者是Agent，是执行Step的具体运行期环境。
Step: 步骤，Step是最基本的操作单元，小到创建一个目录，大到构建一个Docker镜像，由各类Jenkins Plugin提供。

``` js
#!groovy
pipeline{
	agent any
	//定义仓库地址
	environment {
		REPOSITORY="https://gitee.com/merryyou/sso-merryyou.git"
	}

	stages {

		stage('获取代码'){
			steps {
				echo "start fetch code from git:${REPOSITORY}"
				//清空当前目录
				deleteDir()
				//拉去代码
				git "${REPOSITORY}"
			}
		}

		stage('代码静态检查'){
			steps {
				//伪代码检查
				echo "start code check"
			}
		}		

		stage('编译+单元测试'){
			steps {
				echo "start compile"
				//切换目录
				dir('sso-client1') {
					//重新打包
					bat 'mvn -Dmaven.test.skip=true -U clean install'
				}
			}
		}

		stage('构建镜像'){
			steps {
				echo "start build image"
				dir('sso-client1') {
					//build镜像
					bat 'docker build -t hub.c.163.com/longfeizheng/sso-client1:1.0 .'
					//登录163云仓库
					bat 'docker login -u longfei_zheng@163.com -p password hub.c.163.com'
					//推送镜像到163仓库
					bat 'docker push hub.c.163.com/longfeizheng/sso-client1:1.0'
				}
			}
		}

		stage('启动服务'){
			steps {
				echo "start sso-merryyou"
				//重启服务
				bat 'docker-compose up -d --build'
			}
		}				

	}
}
```
