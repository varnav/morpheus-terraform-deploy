resource "aws_security_group" "amazonmq" {
  name        = "Morpheus_AmazonMQ"
  description = "Allow appliance communication on 5671 (SSL) or 5672 inbound, and egress communication"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "amazonmq_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.amazonmq.id
}

resource "aws_security_group_rule" "amazonmq_amqps" {
  type                     = "ingress"
  from_port                = 5671
  to_port                  = 5671
  protocol                 = "tcp"
  security_group_id        = aws_security_group.amazonmq.id
  source_security_group_id = var.app_vm_security_group_id
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_security_group_rule" "amazonmq_console" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.amazonmq.id
}

resource "aws_mq_broker" "amazonmq" {
  broker_name                = var.broker_name
  deployment_mode            = "CLUSTER_MULTI_AZ"
  engine_type                = "RabbitMQ"
  engine_version             = var.engine_version
  host_instance_type         = "mq.m5.large"
  security_groups            = [aws_security_group.amazonmq.id]
  subnet_ids                 = values(var.subnet_info)[*].id
  publicly_accessible        = false # will requrie accessing the API and web through internal connections
  auto_minor_version_upgrade = true
  user {
    username = var.username
    password = var.password
  }

}