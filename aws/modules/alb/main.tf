resource "aws_security_group" "lb" {
  name        = "Morpheus_Load_Balancer"
  description = "Allow agent and web console communication on 443 inbound, and egress communication to the Morpheus app nodes"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "lb_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = var.app_vm_security_group_id
}

resource "aws_security_group_rule" "lb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_lb_target_group" "target_group" {
  name                          = var.name
  port                          = 443
  protocol                      = "HTTPS"
  load_balancing_algorithm_type = "least_outstanding_requests"
  vpc_id                        = var.vpc_id
  health_check {
    enabled  = true
    protocol = "HTTPS"
    path     = "/ping"
    matcher  = "200"
  }
  stickiness {
    enabled     = true
    type        = "app_cookie"
    cookie_name = "JSESSIONID"
  }

}

resource "aws_lb" "load_balancer" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = values(var.subnet_info)[*].id
  ip_address_type    = "ipv4"
}

resource "tls_private_key" "morpheus" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "morpheus" {
  private_key_pem = tls_private_key.morpheus.private_key_pem

  subject {
    common_name  = "morpheus.example.com"
    organization = "Morpheus Examples, LLC"
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.morpheus.private_key_pem
  certificate_body = tls_self_signed_cert.morpheus.cert_pem
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn
  certificate_arn = aws_acm_certificate.cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  for_each         = var.app_vm_info
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = each.value.id
  port             = 443
}