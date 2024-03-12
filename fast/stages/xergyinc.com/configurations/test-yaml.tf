# tfdoc:file:description Automation project and resources.

# locals {

#   _org_config_data_raw = merge([
#     for f in try(fileset(path.module, "/org-config.yaml"), []) :
#     yamldecode(file("${path.module}/${f}"))
#   ]...)
#   # simulate applying defaults to data coming from yaml files
#   _org_config_data = {
#     for k, v in local._org_config_data_raw :
#     k => [{
#       projects_detail = k

#     }]
#   }
#   org_config_data = local._org_config_data.projects


#     project_list = {
#       for index, project_details in local._org_config_data_raw.projects : index => {
#         name                  = index
#         org_id                = project_details.org_id
#         services              = project_details.services
#         iam_by_principals     = {
#           # appending domain name to groups
#           for key, value in try(project_details.iam_by_principals, {}): "group:${key}@${var.organization.domain}" => value
#         }
#         iam                   = try(project_details.iam, {})
#         iam_bindings          = try(project_details.iam_bindings, {})
#         iam_bindings_additive = try(project_details.iam_bindings_additive, {})
#       }
#   }
# }

# # resource "google_storage_bucket" "static-site" {
# #   for_each      = local.project_list
# #   name          = local.project_list[each.key].name
# #   location      = "EU"
# #   force_destroy = true

# #   uniform_bucket_level_access = true
# # }


# output "org_config_data" {
#   value = local.project_list

# }


# locals {
#     project_details = {
#   "audit" = [
#     {
#       "project_id" = "org-dev-audit"
#     },
#   ]
#   "automation" = [
#     {
#       "project_id" = "org-dev-automation"
#     },
#   ]
# }
# }


# resource "google_storage_bucket" "static-site" {
#   for_each = local.project_details
#   name          = local.project_details[each.key][0].project_id
#   location      = "EU"
#   force_destroy = true

#   uniform_bucket_level_access = true

#   website {
#     main_page_suffix = "index.html"
#     not_found_page   = "404.html"
#   }
#   cors {
#     origin          = ["http://image-store.com"]
#     method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
#     response_header = ["*"]
#     max_age_seconds = 3600
#   }
# }


# output "project_id" {
#   value = local.project_details["audit"]
# }


locals {

  template = templatefile("org-config.tftpl",
  {
    "automation-tf-resman-r-sa"                   = "module.automation-tf-resman-r-sa.iam_email"
    "automation-tf-bootstrap-sa"                  = "module.automation-tf-bootstrap-sa.iam_email"
    "automation-tf-resman-sa"                     = "module.automation-tf-resman-sa.iam_email"
    "automation-tf-bootstrap-r-sa"                = "module.automation-tf-bootstrap-r-sa.iam_email"
    "organization_storage_viewer_custom_role_id"  = "module.organization.custom_role_id['storage_viewer']"
  }
  )

}

output "modified_json" {
  value = local.template
}
