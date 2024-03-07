
module "folder" {
  source = "../../../modules/folder"
  count  = 1
  parent = "organizations/${var.organization.id}"
  name   = var.folder_name
  factories_config = var.factories_config_folder
#   iam_by_principals = {
#     (local.principals.gcp-network-admins) = [
#       # owner and viewer roles are broad and might grant unwanted access
#       # replace them with more selective custom roles for production deployments
#       "roles/editor",
#     ]
#   }
#   iam = {
#     # read-write (apply) automation service account
#     "roles/logging.admin"                  = [module.branch-network-sa.iam_email]
#     "roles/owner"                          = [module.branch-network-sa.iam_email]
#   }
#   tag_bindings = {
#     context = try(
#       module.organization.tag_values["${var.tag_names.context}/networking"].id, null
#     )
#   }
}
