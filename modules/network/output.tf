output "network_id" {
  value = google_compute_network.network.id
}
output "network_name" {
  value = google_compute_network.network.name
}

output "subnet1_name" {
  value = google_compute_subnetwork.subnet1.name
}
output "subnet2_name" {
  value = google_compute_subnetwork.subnet2.name
}
output "subnet2-secondary1-name" {
  value = google_compute_subnetwork.subnet2.secondary_ip_range[0].range_name
}
output "subnet2-secondary2-name" {
  value = google_compute_subnetwork.subnet2.secondary_ip_range[1].range_name
}


output "service_account_email" {
  value = google_service_account.service_account.email
}
