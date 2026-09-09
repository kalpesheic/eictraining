Created Lambda function which would help to change password and same password store in serect manager, post ran lambda function, new password works for the connect database.

Created test-db which is runing in same VPC.
Lambda function, database  are running in same VPC.
Created layer(pymysql-layer) and assocaited with lambda function.
Created Two SG, one SG which is called Lambda-function SG which has inbound rule which is allowd to access Lambda function
Another SG(credential-rotation-rds-sg), which is allowed mysql/Aurora, allows ports from the lambda function SG.
Created Secret(test-db) which store credential along with endpoints details.
Created endpoint for the secret key and select same VPC along with subnet
Created Role (poc-credential-rotation-lambda-role) and attached policy(AWSLambdaBasicExecutionRole)
and inline policy(AllowSecrettest)

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:PutSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:ap-south-1:454143665149:secret:test-db-KhIqHx"
        }
    ]
}