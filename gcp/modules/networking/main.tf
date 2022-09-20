
resource "google_compute_network" "vpc" {
  name                    = "${var.naming_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.naming_prefix}-subnet"
  ip_cidr_range = var.subnet_cidr_block
  network       = google_compute_network.vpc.id
}

resource "google_compute_global_address" "private_ip_block" {
  name         = "${var.naming_prefix}-private-ip-block"
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  prefix_length = 24
  network       = google_compute_network.vpc.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-mysql"
  network     = google_compute_network.vpc.name
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
  source_tags = ["morpheus"]
}

resource "google_compute_firewall" "allow_iac" {
  name        = "allow-iac"
  network     = google_compute_network.vpc.name
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["3389","22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "health_check" {
  name          = "allow-health-check"
  direction     = "INGRESS"
  network       = google_compute_network.vpc.name
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
  allow {
    ports    = ["80","443"]
    protocol = "tcp"
  }
}

resource "google_compute_router" "router" {
  count = var.create_router ? 1 : 0
  name    = "${var.naming_prefix}-router"
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  count = var.create_router ? 1 : 0
  name                               = "${var.naming_prefix}-nat"
  router                             = google_compute_router.router[count.index].name
  region                             = google_compute_router.router[count.index].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
