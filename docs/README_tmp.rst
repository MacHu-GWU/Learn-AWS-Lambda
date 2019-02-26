一个健壮的 Lambda Function 项目:



开发阶段
------------------------------------------------------------------------------




测试阶段
------------------------------------------------------------------------------

1. Unit Test: 测试所有 handler 所用到的功能.
2. Integration Test: 测试 handler 的行为是否符合预期, 配置是否正确. 这部分是 lambda 的难点, 因为我们需要 mock AWS Event, 以及 simulate lambda runtime.


怎么为 Lambda 做 Integration Test?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

这里面的关键技术是 docker, 用 docker 模拟 lambda 的运行环境. `lambci/lambda <https://hub.docker.com/r/lambci/lambda>`_ 提供了和 AWS 几乎一摸一样的运行环境.




在 container 中构建 deployment package.
2.


docker run --rm -v "$PWD":/var/task lambci/lambda:python3.6 lambda_function.lambda_handler




部署阶段
------------------------------------------------------------------------------

1. 部署