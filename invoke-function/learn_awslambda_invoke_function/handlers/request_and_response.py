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
        FunctionName='invoke-function-demo-dev-request_and_response',
        InvocationType='RequestResponse',
        Payload='{"first_name": "David", "last_name": "John"}',
    )
    assert response["Payload"].read() == '{"message": "Hello David John"}'
