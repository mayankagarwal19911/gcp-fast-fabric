
module "tenant-folder" {
  source = "../../../../modules/folder"
  parent = "organizations/${var.organization.id}"
  name   = "Networking"
  iam_by_principals = {
    (local.principals.gcp-network-admins) = [
      # owner and viewer roles are broad and might grant unwanted access
      # replace them with more selective custom roles for production deployments
      "roles/editor",
    ]
  }
  iam = {
    # read-write (apply) automation service account
    "roles/logging.admin"                  = [module.branch-network-sa.iam_email]
    "roles/owner"                          = [module.branch-network-sa.iam_email]
    "roles/resourcemanager.folderAdmin"    = [module.branch-network-sa.iam_email]
    "roles/resourcemanager.projectCreator" = [module.branch-network-sa.iam_email]
    "roles/compute.xpnAdmin"               = [module.branch-network-sa.iam_email]
    # read-only (plan) automation service account
    "roles/viewer"                       = [module.branch-network-r-sa.iam_email]
    "roles/resourcemanager.folderViewer" = [module.branch-network-r-sa.iam_email]
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/networking"].id, null
    )
  }
}