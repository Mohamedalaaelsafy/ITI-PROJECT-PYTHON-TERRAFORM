resource "google_compute_instance" "instance" {
  name         = "gke-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  # hostname = "bastion"
  tags = [ "gke-ssh" ]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = module.network.network_name
    subnetwork = module.network.subnet1_name
    # access_config {}
  }
  service_account {
    email  = module.network.service_account_email
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
  metadata_startup_script =  <<-EOF
  sudo apt update -y
  sudo apt install kubectl -y
  sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y
  gcloud container clusters get-credentials gke-cluster --zone us-central1-a --project optimistic-yeti-367811
  EOF
# depends_on = [google_container_cluster.primary]
}
