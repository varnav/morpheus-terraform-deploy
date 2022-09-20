locals {
  image_map = {
    debian10 = {
      name   = "debian-cloud/debian-11"
    }
    rhel = {
      name   = "rhel-cloud/rhel-8"
    }
    ubuntu = {
      name   = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
}

data "google_compute_zones" "available" {
}

resource "google_compute_instance_group" "morphgrp1" {
  name      = "${var.naming_prefix}-group1"
  zone      = data.google_compute_zones.available.names[0]
  instances = [google_compute_instance.morph1.id]
  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group" "morphgrp2" {
  name      = "${var.naming_prefix}-group2"
  zone      = data.google_compute_zones.available.names[1]
  instances = [google_compute_instance.morph2.id]
  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group" "morphgrp3" {
  name      = "${var.naming_prefix}-group3"
  zone      = data.google_compute_zones.available.names[2]
  instances = [google_compute_instance.morph3.id]
  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "google_compute_instance" "morph1" {
  name         = "${var.naming_prefix}1"
  machine_type = var.machine_type
  zone         = data.google_compute_zones.available.names[0]
  tags         = ["morpheus", "allow-health-check"]
  boot_disk {
    initialize_params {
      image = lookup(local.image_map["${var.os_flavor}"], "name")  #"debian-cloud/debian-10"
      size = var.disk_size
    }
  }
  network_interface {
    subnetwork = var.subnet_name   
  }
  metadata = {
    startup-script = "#! /bin/bash\n     sudo apt-get update\n     sudo apt-get install apache2 -y\n     sudo a2ensite default-ssl\n     sudo a2enmod ssl\n     sudo vm_hostname=\"$(curl -H \"Metadata-Flavor:Google\" \\\n   http://169.254.169.254/computeMetadata/v1/instance/name)\"\n   sudo echo \"Page served from: $vm_hostname\" | \\\n   tee /var/www/html/index.html\n   sudo systemctl restart apache2"
  }
  
}



resource "google_compute_instance" "morph2" {
  name         = "${var.naming_prefix}2"
  machine_type = var.machine_type
  zone         = data.google_compute_zones.available.names[1]
  tags         = ["morpheus", "allow-health-check"]
  boot_disk {
    initialize_params {
      image = lookup(local.image_map["${var.os_flavor}"], "name") #"debian-cloud/debian-10"
      size = var.disk_size
    }
  }
  network_interface {
    subnetwork = var.subnet_name  
  }
  metadata = {
    startup-script = "#! /bin/bash\n     sudo apt-get update\n     sudo apt-get install apache2 -y\n     sudo a2ensite default-ssl\n     sudo a2enmod ssl\n     sudo vm_hostname=\"$(curl -H \"Metadata-Flavor:Google\" \\\n   http://169.254.169.254/computeMetadata/v1/instance/name)\"\n   sudo echo \"Page served from: $vm_hostname\" | \\\n   tee /var/www/html/index.html\n   sudo systemctl restart apache2"
  }
  
}

resource "google_compute_instance" "morph3" {
  name         = "${var.naming_prefix}3"
  machine_type = var.machine_type
  zone         = data.google_compute_zones.available.names[2]
  tags         = ["morpheus", "allow-health-check"]
  boot_disk {
    initialize_params {
      image = lookup(local.image_map["${var.os_flavor}"], "name") #"debian-cloud/debian-10"
      size = var.disk_size
    }
  }
  network_interface {
    subnetwork = var.subnet_name    
  }
  metadata = {
    startup-script = "#! /bin/bash\n     sudo apt-get update\n     sudo apt-get install apache2 -y\n     sudo a2ensite default-ssl\n     sudo a2enmod ssl\n     sudo vm_hostname=\"$(curl -H \"Metadata-Flavor:Google\" \\\n   http://169.254.169.254/computeMetadata/v1/instance/name)\"\n   sudo echo \"Page served from: $vm_hostname\" | \\\n   tee /var/www/html/index.html\n   sudo systemctl restart apache2"
  }
  
}