variable "name" {
  type    = string
  default = "mikosins-mq-test"
}

data "terraform_remote_state" "mq" {
  backend  = "local" # use local for test purposes only
  defaults = {
    broker_id = null
  }
}

resource "aws_security_group" "mq" {
  name = var.name
}

resource "random_password" "mq" {
  length  = 12
  special = false
}

resource "aws_mq_broker" "main" {
  broker_name        = var.name
  engine_type        = "ActiveMQ"
  engine_version     = "5.17.3"
  host_instance_type = "mq.t3.micro"
  security_groups    = [aws_security_group.mq.id]

  logs {
    audit   = data.terraform_remote_state.mq.outputs.broker_id != null ? true : false
    general = data.terraform_remote_state.mq.outputs.broker_id != null ? true : false
  }

  user {
    username = var.name
    password = random_password.mq.result
  }

  apply_immediately = true
}

resource "aws_cloudwatch_log_group" "audit" {
  name              = "/aws/amazonmq/broker/${aws_mq_broker.main.id}/audit"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "general" {
  name              = "/aws/amazonmq/broker/${aws_mq_broker.main.id}/general"
  retention_in_days = 1
}

output "broker_id" {
  value = aws_mq_broker.main.id
}