terraform {
  required_version = ">= 1.2.7"
  required_providers {
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "=0.0.7"
    }
  }
}

locals {
  ca_cert_cn                     = "ca.morpheus.local"
  server_cert_cn                 = "test.morpheus.local"
  backend_address_pool_name      = "morpheus-beap"
  frontend_port_name             = "morpheus-feport"
  frontend_ip_configuration_name = "morpheus-feip"
  http_setting_name              = "morpheus-be-htst"
  listener_name                  = "morpheus-httplstn"
  request_routing_rule_name      = "morpheus-rqrt"
  redirect_configuration_name    = "morpheus-rdrcfg"
  ssl_certificate_name           = "morpheus-sslcert"
  ssl_profile_name               = "morpheus-sslprofile"
  probe_name                     = "morpheus-probe"
}

resource "azurerm_public_ip" "lb" {
  name                = "morpheus-lb"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = local.ca_cert_cn
    organization = "Morpheus Examples, LLC"
  }

  validity_period_hours = 8760

  allowed_uses = [
    "cert_signing"
  ]

  is_ca_certificate = true
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem
  subject {
    common_name  = local.server_cert_cn
    organization = "Morpheus Examples, LLC"
  }
  dns_names = [
    local.server_cert_cn
  ]
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
}

resource "pkcs12_from_pem" "pfx" {
  password        = "mypassword"
  cert_pem        = tls_locally_signed_cert.server.cert_pem
  private_key_pem = tls_private_key.server.private_key_pem
}

resource "azurerm_application_gateway" "network" {
  name                = "morpheus-appgateway"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.lb.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  trusted_root_certificate {
    name = local.ca_cert_cn
    data = tls_self_signed_cert.ca.cert_pem
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Enabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 20
    probe_name            = local.probe_name
    trusted_root_certificate_names = [
      local.ca_cert_cn
    ]
  }

  probe {
    name                = local.probe_name
    interval            = 30
    host                = local.server_cert_cn
    path                = "/ping"
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = local.ssl_certificate_name
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  ssl_certificate {
    name     = local.ssl_certificate_name
    data     = pkcs12_from_pem.pfx.result
    password = "mypassword"
  }

  ssl_profile {
    name = local.ssl_profile_name
    ssl_policy {
      policy_type = "Predefined"
      policy_name = "AppGwSslPolicy20170401S"
    }
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "pool" {
  for_each                = toset(var.zones)
  network_interface_id    = lookup(var.app_network_interfaces["${each.value}"], "id")
  ip_configuration_name   = lookup(var.app_network_interfaces["${each.value}"], "ip_configuration")[0].name
  backend_address_pool_id = tolist(azurerm_application_gateway.network.backend_address_pool).0.id
}