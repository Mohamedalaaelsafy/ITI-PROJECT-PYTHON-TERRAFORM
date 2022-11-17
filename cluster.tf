resource "google_service_account" "default" {
  account_id   = "cluster-service-account"
  display_name = "Cluster Service Account"
}
resource "google_project_iam_member" "default_binding" {
  project = "optimistic-yeti-367811"
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}
resource "google_project_iam_member" "default_binding1" {
  project = "optimistic-yeti-367811"
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}
resource "google_project_iam_member" "default_binding2" {
  project = "optimistic-yeti-367811"
  role    = "roles/visualinspection.serviceAgent"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "default_binding3" {
  project = "optimistic-yeti-367811"
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "default_binding4" {
  project = "optimistic-yeti-367811"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.default.email}"
}




resource "google_container_cluster" "primary" {
  name                     = "gke-cluster"
  location                 = "us-central1-a"
#   node_locations = ["us-central1-a"]
  network                  = module.network.network_name
  subnetwork               = module.network.subnet2_name
  
  networking_mode          = "VPC_NATIVE"
  remove_default_node_pool = true
  initial_node_count       = 1
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    master_global_access_config {
      enabled = false
    }
  }
  master_authorized_networks_config {
    # cidr_blocks {
    #   display_name = "my-ip"
    #   cidr_block   = "197.55.8.60/32"
    # }
    cidr_blocks {
      display_name = "private_ip"
      cidr_block = "${google_compute_instance.instance.network_interface.0.network_ip}/32"
    }
  }


  ip_allocation_policy {
    cluster_secondary_range_name  = module.network.subnet2-secondary1-name
    services_secondary_range_name = module.network.subnet2-secondary2-name
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 2
  max_pods_per_node = 20
  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 50
    service_account = google_service_account.default.email
    oauth_scopes = [
     "https://www.googleapis.com/auth/cloud-platform",
     "https://www.googleapis.com/auth/devstorage.read_only",
     "https://www.googleapis.com/auth/servicecontrol",
     "https://www.googleapis.com/auth/service.management.readonly",
     "https://www.googleapis.com/auth/trace.append"
    ]
    tags = [ "node-ssh" ]
  }

}
