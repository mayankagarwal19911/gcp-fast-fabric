locals {
#  projects = merge([
#   for p in module.projects :
#     {
#       for key, value in p.projects :
#         value.name => {
#           number           = value.number
#           project_id       = value.project_id
#           custom_role_ids  = value.custom_role_ids
#         }
#     }
#   ]...)

  # workload_identity_pool_id = {
  #   for pool in  google_iam_workload_identity_pool.default : pool.project => pool
  # }
}

# output "projects" {
#   description = "Created projects."
#   value = local.projects
# }

output "folder_details" {
  description = "Folder details"
  value = module.folder
}

# output "service_accounts" {
#   description = "Created service accounts."
#   value = module.projects[0].service_accounts
# }

# output "billing_account" {
#   description = "Billing account details."
#   value = module.projects[0].billing_account
# }

# output "workload_identity_pool_id" {
#   value = local.workload_identity_pool_id
# }

# output "workload_identity_providers" {
#   value = google_iam_workload_identity_pool_provider.default
# }

# output "cicd_repositories" {
#   value = local.cicd_repositories_sa_details
# }


# output "dns_details" {
#   value = module.dns
# }

# output "iam_group" {
#   value = local._iam_by_principals
# }