locals {
  tag_bindings = try(yamldecode(file("${path.module}/tags.yaml")))
}

module "lz" {
  source                  = "../"
  billing_account         = var.billing_account
  organization            = var.organization
  factories_config_folder = var.factories_config_folder
  factories_config        = var.factories_config
  # temp_project_bool = false
  tag_bindings = local.tag_bindings
  zone_name = var.zone_name
  zone_project_id = var.zone_project_id
  workload_identity_providers = var.workload_identity_providers
  group_description = var.group_description
  group_display_name = var.group_display_name
  group_name = var.group_name
  client_initials = var.client_initials
}
