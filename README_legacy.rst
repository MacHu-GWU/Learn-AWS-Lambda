Learn AWS Lambda
================
AWS Lambda是一项将一个Python函数(也支持Node.js和Java)的输入输出用Json封装起来, 然后AWS自动配置好Balancer等一切网络需要的组件, 从而快速创建一个使用Http Request接口的API服务。换言之, 我们可以将我们的Python函数封装起来, 让人通过网络调用我们的函数。而期间的网络访问如何Balance, 身份验证如何进行, 以及维护服务器的工作, 就全部交给AWS就好了。

简单来说, 部署一个Lambda函数需要三步:

1. 创建你的Lambda函数的代码
2. 将代码部署到AWS Lambda上
3. 创建一个API Endpoint供外部调用


创建你的Lambda函数的代码
---------------
AWS Lambda需要你的代码在virtualenv环境下开发。virtualenv是一个让你的每个项目都有一个独立的Python第三方包的配置环境, 以解决多个项目对同一个包有不同版本的以来的问题。注意, AWS Lambda只支持Python2.7, 所以以下所有内容都是在ubuntu Python2.7的环境下进行。

1. 首先你要安装virtualenv, 安装方法就跟安装其他第三方库一样 ``sudo pip2 install virtualenv`` 就好了。
2. 然后你要使用virtualenv创建一个project, ``virtualenv <path/to/project>``; 注意, 当你有多个Python版本并存时, 要创建指定版本的Python环境时, VirtualEnv命令变为: ``virtualenv -p /usr/bin/python2.7 <path/to/project/>``
3. 然后进入你的项目 ``cd <path/to/project>``, 激活你的环境 ``source bin/activate``
4. 在这个环境下, 你使用 ``pip2 install <package_name>`` 实际上是将包安装到了虚拟环境下, 而不是本地Python的第三方库中。
5. 当你编写好了你的Lambda函数时, 需要在virtualenv环境下进行测试 ``python2 lambda_handler.py``
6. 当你想要退出虚拟环境时 ``deactivate``


将代码部署到AWS Lambda上
-----------------
AWS Lambda对部署包的大小(Deploy
ment包不得超过50MB, 解压后不得超过250MB), 运算复杂度(一次调用需要在300秒以内结束), 网络IO(payload size不得大于128KB) 都做出了一些限制: http://docs.aws.amazon.com/lambda/latest/dg/limits.html。

AWS支持三种方式将你的代码部署到Lambda上。

1. 直接粘贴代码, 此情形只适用于不依赖第三方库, 单一模块的功能
2. 上传部署包, 但有10MB的限制
3. 从S3导入, 大小不能超过50MB

其中比较标准的做法是第3种, 制作部署包的步骤如下:

1. 确保Lambda所调用的主函数 ``lambda_handle.py`` 中的 ``def lambda_handle(event, context):`` 能够在VirtualEnv下正确运行
2. 将 ``lambda_handle.py`` 模块拷贝到 ``site-packages`` 目录下
3. 将整个 ``site-packages`` 目录下的文件(不包括目录本身)打包成 ``.zip``
4. 上传到S3
5. 配置一个Test Event, 测试你刚刚的部署

从上面的步骤可以看出, AWS Lambda实际上会自己Build一个包含标准库的Python2.7 VirtualEnv。而需要用户上传的是所安装的第三方库。并且用户的函数被封装在了一个模块中, 作为第三方库放到了 ``site-packages`` 中。

而对于依赖第三方包的功能, 例如numpy, scipy, sklearn。由于其编译复杂, 而且在Linux环境下有许多错误, 而且很容易就超过了大小限制。所以Lambda不适合于对第三方包依赖过多的项目。而如果有能力将第三方包中需要的模块拿出来用标准库重新实现, 这样可以避免很多潜在的错误, 并可以节约部署包的空间。但是自己的实现肯定没有第三方库中的性能高。所以就需要开发者自行取舍了。


创建一个API Endpoint供外部调用
---------------------
在Lambda成功跑起来了之后, 当然要为开发者提供一个具有身份验证(或不需要验证)的接口来调用它, 步骤如下:

AWS Console -> Lambda -> Choose your Function -> API Endpoint -> Add API Endpoint -> API Gateway -> 填写相应的内容

特别要注意的是Security一栏。通常有三种身份验证方式:

1. Open Access: 任何人都可以调用Lambda函数
2. Open Access With API Key: 需要提供API Key
3. AWS IAM: 只有关联了AWS IAM角色的机器或Session, 或是EC2才能访问你的资源。


使用Open Access
~~~~~~~~~~~~~
什么都不用设置, 开箱即用。


使用Open Access With API Key
~~~~~~~~~~~~~~~~~~~~~~~~~~
所谓Open Access With API Key就是在调用你的资源时, 还必须提供API Key验证你的身份。

AWS Console -> API Gateway -> Choose your API -> Left hand menu, API Key -> Create -> Config 'API Stage Association' -> Save

然后在你的Http request的Header中加入 ``{"x-api-key": "Your API Key"}``


使用AWS IAM
~~~~~~~~~
没有研究过这种方法。


附录
--
一些有用的链接:

- VirtualEnv Usage: https://virtualenv.pypa.io/en/latest/userguide.html
- Create Lambda Function: http://docs.aws.amazon.com/lambda/latest/dg/get-started-create-function.html
- Create Deployment Package: http://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html
- Create Deployment Package for VirtualEnv: http://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html#deployment-pkg-for-virtualenv
