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
