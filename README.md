# aws_mq

This is an example of Terraform code allowing to create CloudWatch log groups before the MQ broker without cycle errors.
The key to solving the problem is to set the default output on the terraform_remote_state data source.
Code has to be run twice, but no additional toggle is needed to enable/disable logs for the MQ broker.