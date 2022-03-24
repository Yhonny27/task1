terraform {
  backend "gcs" {
    bucket  = "terraform-gcs-demo"
    prefix  = "terraform/task1"
    credentials = "terraform-sa.json"
  }
}

