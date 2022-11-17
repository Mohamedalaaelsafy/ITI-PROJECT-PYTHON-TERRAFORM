//subnet service account

resource "google_service_account" "service_account" {
  account_id   = "gke-service-account"
  display_name = "GKE Service Account"
}

resource "google_project_iam_member" "firestore_owner_binding" {
  project = "optimistic-yeti-367811"
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "firestore_owner_binding1" {
  project = "optimistic-yeti-367811"
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "firestore_owner_binding2" {
  project = "optimistic-yeti-367811"
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "firestore_owner_binding3" {
  project = "optimistic-yeti-367811"
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "firestore_owner_binding4" {
  project = "optimistic-yeti-367811"
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "firestore_owner_binding5" {
  project = "optimistic-yeti-367811"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_project_iam_member" "firestore_owner_binding6" {
  project = "optimistic-yeti-367811"
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

// ansible service account

resource "google_service_account" "ansible-service_account" {
  account_id   = "ansible-servigcrce-account"
  display_name = "Ansible Service Account"
}

resource "google_project_iam_member" "ansible_binding" {
  project = "optimistic-yeti-367811"
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.ansible-service_account.email}"
}

resource "google_service_account_key" "mykey" {
  service_account_id = google_service_account.ansible-service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
  # provisioner "local-exec" {
  #   command = "echo ${self.private_key} > ../test"
  # }
}

resource "local_file" "myaccountjson" {
    content     = base64decode(google_service_account_key.mykey.private_key)
    filename = "./test345.json"
    
}

# resource "local_file" "service_account_json" {
#     content     = base64decode(google_service_account_key.service_account.private_key)
#     filename = "./sc.json"
    
# }