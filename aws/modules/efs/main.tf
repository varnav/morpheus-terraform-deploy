resource "aws_security_group" "efs" {
  name        = "Morpheus_EFS"
  description = "Allow appliances communication to EFS"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "efs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.efs.id
}

resource "aws_security_group_rule" "efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = var.app_vm_security_group_id
}

resource "aws_efs_file_system" "app" {
  creation_token = "morpheus"
  encrypted      = true
}

resource "aws_efs_mount_target" "targets" {
  for_each       = var.subnet_info
  file_system_id = aws_efs_file_system.app.id
  subnet_id      = each.value.id
}