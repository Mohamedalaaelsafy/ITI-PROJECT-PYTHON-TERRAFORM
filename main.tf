provider "google" {
  project = "optimistic-yeti-367811"
  region  = "us-central1"
}

module "network" {
  source = "./modules/network"
}