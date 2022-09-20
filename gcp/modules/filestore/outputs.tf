output "nfs_mount" {
  value = "${google_filestore_instance.instance.networks[0].ip_addresses[0]}:/${google_filestore_instance.instance.file_shares[0].name}"
}