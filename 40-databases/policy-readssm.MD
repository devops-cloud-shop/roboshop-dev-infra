{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ReadParameterStoreAccess",
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ],
      "Resource": "arn:aws:ssm:us-east-1:600442391603:parameter/*"
    }
  ]
}