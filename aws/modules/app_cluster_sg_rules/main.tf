resource "aws_security_group_rule" "app" {
  for_each          = toset(var.services_ingress_ports)
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  self              = true
  security_group_id = var.app_vm_security_group_id
}