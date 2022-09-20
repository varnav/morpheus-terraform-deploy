resource "google_filestore_instance" "instance" {
  name = "${var.naming_prefix}fs"
  location = var.zones[0]
  tier = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "${var.naming_prefix}share"
  }

  networks {
    network = var.vpcname
    modes   = ["MODE_IPV4"]
  }
}