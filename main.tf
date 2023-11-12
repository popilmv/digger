provider "google" {
  credentials = file("service-account-key.json")
  project     = "high-territory-403908" 
  region      = var.region      
}

# backend in GCS.
terraform {
  backend "gcs" {
    bucket  = "my-terraform-bucket-27"  #name
    prefix  = "terraform-bucket-27"           
  }
}

resource "google_compute_network" "my_network" {
  name = "my-network"
}


resource "google_compute_subnetwork" "my_subnetwork" {
  name          = "my-subnetwork"
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = "10.0.0.0/16"  
  region      = "us-central1"
}


resource "google_compute_instance" "my-instance" {
  name = var.machine_name
  machine_type = var.machine_type  
  zone         = "us-central1-a"  
  boot_disk {
    initialize_params {
      image = var.image
      size  = 10
    }
  }

  network_interface {
    network = google_compute_network.my_network.self_link
    subnetwork = google_compute_subnetwork.my_subnetwork.name
  }

  tags = ["with-bucket", "homework"]
}

resource "google_compute_address" "instance_ip" {
  name = "my-instance-ip"
  address_type = "INTERNAL"
  subnetwork = google_compute_subnetwork.my_subnetwork.self_link
  depends_on = [google_compute_instance.homework]
}

resource "digger_target" "my_target" {
  name = "my-target"
}

resource "digger_plan" "my_plan" {
  target = digger_target.my_target.self_link
  backend = terraform.backend.gcs.bucket
  prefix = terraform.backend.gcs.prefix
}

resource "digger_apply" "my_apply" {
  plan = digger_plan.my_plan.self_link
}
