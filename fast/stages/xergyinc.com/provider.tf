terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.18.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.18.0"
    }
  }
}

provider "google" {
  # credentials = file("./billing-xx-0-7795562f43ae.json")
  # impersonate_service_account = "terraform-service-account@billing-xx-0.iam.gserviceaccount.com"
  user_project_override = true
  billing_project       = "billing-xx-0"

}

provider "google-beta" {
  user_project_override = true
  billing_project       = "billing-xx-0"
}
