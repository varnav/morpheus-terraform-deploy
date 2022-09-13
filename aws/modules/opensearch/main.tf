data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
  description      = "Allows Amazon OpenSearch to manage AWS resources for a domain on your behalf."
}

resource "aws_security_group" "elastic" {
  name        = "Morpheus_Elastic"
  description = "Allow appliance communication on 9200 inbound, and egress communication"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "elastic_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.elastic.id
}

resource "aws_security_group_rule" "elastic" {
  # API is on 443 vs 9200 of a standard cluster
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elastic.id
  source_security_group_id = var.app_vm_security_group_id
}

resource "aws_elasticsearch_domain" "elastic" {
  domain_name           = var.domain_name
  elasticsearch_version = "7.10"
  cluster_config {
    instance_type            = "r6g.large.elasticsearch"
    dedicated_master_enabled = false
    instance_count           = 3
    zone_awareness_enabled   = true
    zone_awareness_config {
      availability_zone_count = 3
    }

  }
  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
  ebs_options {
    ebs_enabled = true
    volume_size = 200
    volume_type = "gp2"
  }
  encrypt_at_rest {
    enabled = true
  }
  node_to_node_encryption {
    enabled = true
  }
  vpc_options {
    subnet_ids         = values(var.subnet_info)[*].id
    security_group_ids = [aws_security_group.elastic.id]
  }
  depends_on = [aws_iam_service_linked_role.es]

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
    }
  ]
}
CONFIG

}