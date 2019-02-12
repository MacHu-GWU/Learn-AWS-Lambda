Learn AWS LAMBDA - invoke function
==============================================================================

.. contents::
    :local:


Prepare the lambda
------------------------------------------------------------------------------

.. code-block:: bash

    sls deploy # use serverless to deploy the demo function


There are three ways to invoke a lambda function (https://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html#SSS-Invoke-request-InvocationType):

1. Request and Response
2. Event
3. DryRun


Request and Response
------------------------------------------------------------------------------

**invoke from AWS CLI**:

- **use short function name**: ``aws lambda invoke --function-name invoke-function-demo2-dev-request_and_response --payload '{"first_name": "Sanhe", "last_name": "Hu"}' tmp.txt``
- **use long ARN with version**: ``aws lambda invoke --function-name arn:aws:lambda:us-east-1:663351365541:function:invoke-function-demo2-dev-request_and_response:\$LATEST --payload '{"first_name": "Sanhe", "last_name": "Hu"}' tmp.txt`` (Watch out the ``$`` escape)

output will be written into ``tmp.txt``

.. note::

    This method is **usually for quick testing**

Reference:

- aws cli lambda invoke options: https://docs.aws.amazon.com/cli/latest/reference/lambda/invoke.html

**invoke from Python**:

Content of ``learn_awslambda_invoke_function.handlers.request_and_response.py``:

.. code-block:: python

    # -*- coding: utf-8 -*-

    def handler(event, context):
        message = 'Hello {} {}'.format(
            event['first_name'], event['last_name'])
        return {'message': message}


    if __name__ == "__main__":
        import boto3

        session = boto3.session.Session(profile_name="sanhe")
        client = session.client("lambda")
        response = client.invoke(
            FunctionName='invoke-function-demo1-dev-request_and_response',
            InvocationType='RequestResponse',
            Payload='{"first_name": "David", "last_name": "John"}',
        )
        assert response["Payload"].read() == '{"message": "Hello David John"}'

.. note::

    This method is usually for **invoke this function from another function**

Refrence:

- ``boto3`` lambda invoke API: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/lambda.html#Lambda.Client.invoke


Event Triggered
------------------------------------------------------------------------------

Reference:

- lambda with s3 example: https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example-deployment-pkg.html#with-s3-example-deployment-pkg-python
