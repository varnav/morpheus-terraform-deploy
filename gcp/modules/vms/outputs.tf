output "morphgrp1" {
  value = google_compute_instance_group.morphgrp1.id
}

output "morphgrp2" {
  value = google_compute_instance_group.morphgrp2.id
}

output "morphgrp3" {
  value = google_compute_instance_group.morphgrp3.id
}

output "zones" {
  value = data.google_compute_zones.available.names
}

output "instance1" {
  value = google_compute_instance.morph1.id
}

output "instance1_ip" {
  value = google_compute_instance.morph1.network_interface[0].network_ip
}

output "instance2" {
  value = google_compute_instance.morph2.id
}

output "instance2_ip" {
  value = google_compute_instance.morph2.network_interface[0].network_ip
}

output "instance3" {
  value = google_compute_instance.morph3.id
}

output "instance3_ip" {
  value = google_compute_instance.morph3.network_interface[0].network_ip
}
