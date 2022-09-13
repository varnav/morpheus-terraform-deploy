resource "aws_security_group" "aurora" {
  name        = "Morpheus_Aurora"
  description = "Allow appliances communication to "
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "aurora_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.aurora.id
}

resource "aws_security_group_rule" "aurora" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aurora.id
  source_security_group_id = var.app_vm_security_group_id
}

resource "aws_db_subnet_group" "morpheus" {
  name       = "morpheus"
  subnet_ids = values(var.subnet_info)[*].id
}

data "aws_subnet" "az" {
  for_each = var.subnet_info
  id       = each.value.id
}

resource "aws_rds_cluster" "morpheus" {
  cluster_identifier        = var.cluster_id
  engine                    = "aurora-mysql"
  engine_version            = "5.7.mysql_aurora.2.10.2"
  availability_zones        = values(data.aws_subnet.az)[*].availability_zone
  master_username           = var.master_username
  master_password           = var.master_password
  backup_retention_period   = 7
  preferred_backup_window   = "07:00-09:00"
  storage_encrypted         = true
  db_subnet_group_name      = aws_db_subnet_group.morpheus.id
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.cluster_id}-final"
  apply_immediately         = false
  copy_tags_to_snapshot     = true
  vpc_security_group_ids    = [aws_security_group.aurora.id]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "morpheus-${count.index}"
  cluster_identifier = aws_rds_cluster.morpheus.id
  instance_class     = "db.r6g.large"
  engine             = aws_rds_cluster.morpheus.engine
  engine_version     = aws_rds_cluster.morpheus.engine_version
}