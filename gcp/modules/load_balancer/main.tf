resource "google_compute_backend_service" "backend" {
  name      = "${var.naming_prefix}-backend"
  port_name = "https"
  protocol  = "HTTPS"
  load_balancing_scheme = "EXTERNAL"
  session_affinity                = "GENERATED_COOKIE"
  timeout_sec                     = 30
  connection_draining_timeout_sec = 0
  backend {
    group = var.instance_grp1
  }
  
  backend {
    group = var.instance_grp2
  }

  backend {
    group = var.instance_grp3
  }

  health_checks = [
    google_compute_health_check.health.id,
  ]
}

resource "google_compute_health_check" "health" {
  name         = "${var.naming_prefix}-health"
  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  
  https_health_check {
    port               = "443"
    port_specification = "USE_FIXED_PORT"
    proxy_header       = "NONE"
    request_path       = "/"
    #response           = "MORPHEUS PING"
  }
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "default" {
  private_key_pem = tls_private_key.default.private_key_pem

  validity_period_hours = 8760
  early_renewal_hours = 3

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = ["morpheus.example.com"]

  subject {
    common_name  = "morpheus.example.com"
    organization = "Morpheus Examples, LLC"
  }
}

resource "google_compute_ssl_certificate" "default" {
  name        = "default-cert"
  private_key = tls_private_key.default.private_key_pem
  certificate = tls_self_signed_cert.default.cert_pem
}

resource "google_compute_global_address" "morphip" {
  name = "${var.naming_prefix}ip"
}

resource "google_compute_global_forwarding_rule" "morph-rule" {
  name       = "${var.naming_prefix}-monitor-port-443"
  load_balancing_scheme = "EXTERNAL"
  provider              = google
  ip_protocol           = "TCP"
  ip_address = "${google_compute_global_address.morphip.address}"
  port_range = "443-443"
  target     = google_compute_target_https_proxy.morphproxy.id
}

resource "google_compute_url_map" "morphlb" {
  name            = "${var.naming_prefix}lb"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_https_proxy" "morphproxy" {
  name    = "${var.naming_prefix}proxy"
  url_map = "${google_compute_url_map.morphlb.self_link}"
  ssl_certificates = [google_compute_ssl_certificate.default.id]
}
