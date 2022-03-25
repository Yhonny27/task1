#1. Creat a Custom Service account
resource "google_service_account" "store_user" {
  account_id   = "store-user"
  display_name = "Store User"
}
resource "google_project_iam_binding" "store_usera" {
  project            = "projectx-344700"
  role               = "roles/pubsub.editor"

  members = [
    "serviceAccount:${google_service_account.store_user.email}",
  ]
}
resource "google_project_iam_binding" "store_userb" {
  project            = "projectx-344700"
  role               = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.store_user.email}",
  ]
}
resource "google_project_iam_binding" "store_userc" {
  project            = "projectx-344700"
  role               = "roles/cloudscheduler.admin"

  members = [
    "serviceAccount:${google_service_account.store_user.email}",
 ]
}
#Create Cloud Storage and Bucket to save the json file
resource "google_storage_bucket" "bucket22_task1" {
  name          = "bucket22_task1"
  location      = "US"
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}
#b. Create a Topic
#Topic
resource "google_pubsub_topic" "topic_task1" {
  name = "topic_task1"

  labels = {
    foo = "task1"
  }
  message_retention_duration = "86600s"
}
# Create a Subscription
resource "google_pubsub_subscription" "subscription_task1" {
  name  = "subscription_task1"
  topic = google_pubsub_topic.topic_task1.name

  labels = {
    foo = "bar"
  }
  # 20 minutes
  message_retention_duration = "1200s"
  retain_acked_messages      = true
  ack_deadline_seconds = 20
}
#d. Create a Cloud Scheduler to publish a new message to the PubSub topic every 1 minute at Mexico City time zone (CST).
resource "google_cloud_scheduler_job" "task1_cs_job" {
  name        = "task1_cs_job"
  description = "task1 job"
  schedule    = "* * * * *"
  time_zone   = "America/Mexico_City"

  pubsub_target {
    topic_name = google_pubsub_topic.topic_task1.id
    data       = base64encode("Working CS")
  }
}
#a. Create a Compute Engine instance setting up the SA created before.
resource "google_compute_instance" "instance" {
  name          = "vm-task1"
  machine_type  = "e2-medium"
  zone          = "us-central1-c"
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  } 
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  metadata_startup_script = file("task1.sh")
  tags = ["terraform-compute-jobs"]
  
  service_account {
  email  = google_service_account.store_user.email
  scopes = ["cloud-platform"]
  }
}
