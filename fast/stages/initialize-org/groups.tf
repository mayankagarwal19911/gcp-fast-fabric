module "google_cloud_identity_group" {
  source          = "../../../modules/cloud-identity-group"
  for_each = local.iam_principal_bindings
  display_name = replace("${each.key}", "group:", "")
  description  = "Terraform Managed"
  customer_id = "customers/C03p38uzs"
  name = replace("${each.key}", "group:", "")
}
