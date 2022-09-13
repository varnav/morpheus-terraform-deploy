locals {
  image_map = {
    amazonlinux2 = {
      name   = "amzn2-ami-kernel-5.10-hvm-2.0.*.0-x86_64-gp2"
      owners = "137112412989"
    }
    rhel = {
      name   = "RHEL-8.6.0_HVM-*-x86_64-2-Hourly2-GP2"
      owners = "309956199498"
    }
    ubuntu = {
      name   = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      owners = "099720109477"
    }
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "morpheus" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "aws_security_group" "app" {
  name        = "Morpheus_Communication"
  description = "Allow appliance intercommunication, 443 inbound, and egress communication"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "app_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.app.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.app.id
}

data "aws_ami" "os_flavor" {
  most_recent = true
  filter {
    name   = "name"
    values = [lookup(local.image_map["${var.os_flavor}"], "name")]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [lookup(local.image_map["${var.os_flavor}"], "owners")] # Canonical
}

resource "aws_instance" "app" {
  for_each      = var.subnet_info
  ami           = data.aws_ami.os_flavor.id
  instance_type = var.instance_type
  root_block_device {
    encrypted   = true
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  vpc_security_group_ids = [aws_security_group.app.id]
  subnet_id              = each.value.id
  key_name               = aws_key_pair.morpheus.key_name
}