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
  # credentials = file("./vertex-ai-404204-29a104ec4c2d.json")
  # impersonate_service_account = "terraform-service-account@vertex-ai-404204.iam.gserviceaccount.com"
  user_project_override = true
  billing_project       =  "vertex-ai-404204"
  # project     = "vertex-ai-404204"
  # "billing-xx-0"

}

provider "google-beta" {
  # credentials = file("./vertex-ai-404204-29a104ec4c2d.json")
  # impersonate_service_account = "terraform-service-account@vertex-ai-404204.iam.gserviceaccount.com"
  user_project_override = true
  billing_project       =  "vertex-ai-404204"
  # project     = "vertex-ai-404204"
  # "billing-xx-0"
}
