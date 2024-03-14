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
  user_project_override = true
  billing_project       = "billing-xx-0"

}

provider "google-beta" {
  user_project_override = true
  billing_project       = "billing-xx-0"
}
