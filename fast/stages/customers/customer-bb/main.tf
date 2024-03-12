locals {
  tag_bindings = try(yamldecode(file("${path.module}/tags.yaml")))
}

module "lz" {
  source                  = "../"
  prefix                  = var.prefix
  billing_account         = var.billing_account
  organization            = var.organization
  folder_name             = var.folder_name
  factories_config_folder = var.factories_config_folder
  factories_config        = var.factories_config
  # temp_project_bool = false
  tag_bindings = local.tag_bindings
  # zone_name = var.zone_name
  # zone_project_id = var.zone_project_id
  workload_identity_providers = var.workload_identity_providers
}
