
provider "google" {
  # credentials = file("./xergy-org-prod-billing-exp-0-a57812d1dc4f.json")
  impersonate_service_account = "resource-manager-admin@billing-xx-0.iam.gserviceaccount.com"
  user_project_override       = true
  billing_project             = "billing-xx-0"
  # project                     = "billing-xx-0"
}


# terraform {
#   backend "gcs" {
#     bucket = "org-terraform-state-01"
#     prefix = "terraform/state"
#   }
# }
