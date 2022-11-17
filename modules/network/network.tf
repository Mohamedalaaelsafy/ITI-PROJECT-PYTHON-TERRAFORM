resource "google_compute_network" "network" {
  name                    = "gke-network"
  auto_create_subnetworks = false
}



resource "google_compute_subnetwork" "subnet1" {
  name                     = "gke-sub1"
  ip_cidr_range            = "10.0.10.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet2" {
  name                     = "gke-sub2"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.network.id
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "gke-sub2-sec1"
    ip_cidr_range = "10.0.1.0/24"
  }
  secondary_ip_range {
    range_name    = "gke-sub2-sec2"
    ip_cidr_range = "10.0.2.0/24"
  }

}

resource "google_compute_router" "router" {
  name    = "gke-router"
  region  = "us-central1"
  network = google_compute_network.network.id
  bgp {
    asn = 64514
  }
}

# resource "google_compute_router_nat" "nat" {
#   name                   = "my-router-nat"
#   router                 = google_compute_router.router.name
#   region                 = google_compute_router.router.region
#   nat_ip_allocate_option = "AUTO_ONLY"
#   # source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
#   source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
#   subnetwork {
#     name                    = google_compute_subnetwork.subnet1.name 
#     source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
#   }

# }

resource "google_compute_router_nat" "nat" {
  name                   = "my-router-nat"
  router                 = google_compute_router.router.name
  region                 = google_compute_router.router.region
  nat_ip_allocate_option = "AUTO_ONLY"
  # source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet1.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    name                    = google_compute_subnetwork.subnet2.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    # secondary_ip_range_names = ["${google_compute_subnetwork.subnet2.secondary_ip_range[0].range_name}","${google_compute_subnetwork.subnet2.secondary_ip_range[0].range_name}"]
  }

}


// FIREWALL :D

resource "google_compute_firewall" "firewall" {
  name    = "gke-firewall"
  network = google_compute_network.network.name


  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["gke-ssh"]
  target_tags = ["gke-ssh"]
}

resource "google_compute_firewall" "node-firewall" {
  name    = "node-firewall"
  network = google_compute_network.network.name


  source_ranges = ["10.0.10.0/24", "34.171.18.254/32", "35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["node-ssh"]
  target_tags = ["node-ssh"]
}

# resource "google_compute_firewall" "internal" {
#   name          = "gke-firewall"
#   network       = google_compute_network.network.name


#   source_ranges = ["35.235.240.0/20"]
#   # allow {
#   #   protocol = "tcp"
#   # }

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   source_tags = ["ssh"]
# }
