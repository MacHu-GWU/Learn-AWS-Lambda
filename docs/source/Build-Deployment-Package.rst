Build Deployment Package in Container
==============================================================================

首先请阅读这篇官方文档, 对 `构建 Deployment Package <https://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html>`_ 有一个基本的概念. 简单来说, 就是在本地机器上将依赖都安装好, 然后将 handler 源码和依赖打包成 ``.zip`` 上传即可.

无论你使用什么编程语言, **你构的建依赖包的环境必须要跟生产环境一致, 才能够确保生产环境下不会出现奇奇怪怪的错误**. AWS Lambda 是构建在 Amazon 自定义的 Linux 系统上的, 而很多人的开发环境是 Windows 或是 MacOS, 那么在开发机器上构建的 deployment package 就 **有可能无法在生产环境下使用**. 举例来说, Python 下的 numpy 的底层是 C, 使用 ``pip install numpy`` 在 Windows / MacOS / Linux 上生成的编译好的文件并不相同. 而其中只有在 Linux 上安装的 numpy 才能直接在 AWS Lambda 上使用.

随着技术的进步, 我们从过去到现在的方式依次是:

- 买一台 Linux 开发机器.
- 在本地用 VM 虚拟机创建一个 Linux 虚拟机, 在上面操作.
- SSH 到 Linux 服务器上, 从 Git 上拉代码构建.
- **用 Docker 运行 Linux 容器, 在容器中构建**.

如果你不知道什么是容器, 那么你可以理解为: 容器就是一个启动和关闭时间在 毫秒/秒 级的虚拟机. `更多的容器知识请看这里 <https://yeasy.gitbooks.io/docker_practice/content/>`_.

**Linux 容器中我们需要什么工具?**

- bash
- vim
- git
- make
- aws cli
- ssh
- zip
- python
- pip
- virtualenv

**流程**:

- 从 ``git`` 上拉取源代码, 如果是私有仓库则可能会用到 ``ssh``.
- 用 ``virtualenv`` 创建 python 的虚拟环境.
- 用 ``pip`` 安装所有依赖包.
- 用 ``zip`` 打包所有依赖
- 用 ``aws-cli`` 将打包上传至 S3

这一系列行动可以用一个 shell script 脚本来完成.


## Lambda Function 运维的关键技术


### 多个 function 共享一份源代码

不同的 function, 通常有不同的依赖. 老的办法是为每一个 function 单独开一个 repository, 配置一份 requirements.txt. 对于 serverless 架构的 App, 我们需要的 function 很可能上百. 管理 100 个 repository, 想象都心累.

往往一个 service 下面的很多 function, 都会使用到一些共同的包. 为什么不把这些联系的比较紧密的 function 放在一个 repository 里, 然后把所有的 handler, 集中放在一个 package 里. 然后所有的 function 共用一套依赖包. **由于 python 是动态语言, 我们调用一个 handler 时, 没有用到的依赖并没有被 import 进来, 自然也不会占用内存和减慢启动时间了**.

实际工程上, 可以把所有的 function 都放在 ``<repo_name>/<package_name>/handlers`` 这个目录下. 这个 ``<package_name>/handlers`` 本身也是个 importable sub package. 而里面的每一个 ``.py`` 文件就代表一个 function, 当然这里的每一个 function 都有一个同名函数 ``def handler(event, context):``

具体的目录结构如下::

    <repo_name>/<package_name>/handlers
                                |-- __init__.py
                                |-- <function_name1>.py
                                |-- <function_name1>.py
                                |-- ...

在这种设计下, 我们只用维护一个 deployment package, 就能批量的部署所有function.
