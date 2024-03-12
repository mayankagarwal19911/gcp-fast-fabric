
# provider "google" {
#   credentials = file("./btstrap01-dev-project-xx-0-f50ac92e228d.json")
#   impersonate_service_account = "terraform-service-account@btstrap01-dev-project-xx-0.iam.gserviceaccount.com"
#   user_project_override       = true
#   # billing_project             = "billing-xx-0"
#   # project                     = "billing-xx-0"
# }

provider "google" {
  user_project_override = true
  billing_project       = "billing-xx-0"
}

provider "google-beta" {
  user_project_override = true
  billing_project       = "billing-xx-0"
}

# terraform {
#   backend "gcs" {
#     bucket = "org-terraform-state-01"
#     prefix = "terraform/state"
#   }
# }
