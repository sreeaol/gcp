provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

# External 10 GB persistent disk
resource "google_compute_disk" "extra_disk" {
  name  = "micro-vm-disk"
  type  = "pd-standard"
  zone  = "us-central1-a"
  size  = 10
}

# Micro VM instance
resource "google_compute_instance" "micro_vm" {
  name         = "micro-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network       = "default"
    access_config {} # external IP
  }

  # Attach the external disk
  attached_disk {
    source = google_compute_disk.extra_disk.id
  }

  metadata = {
    ssh-keys = "YOUR_USERNAME:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Variables
variable "project_id" {
  description = "GCP project ID"
  type        = string
}
