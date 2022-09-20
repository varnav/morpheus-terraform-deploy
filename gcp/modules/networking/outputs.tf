output "subnet" {
  value = google_compute_subnetwork.subnet.name
}

output "vpcid" {
  value = google_compute_network.vpc.id
}

output "vpcname" {
  value = google_compute_network.vpc.name
}