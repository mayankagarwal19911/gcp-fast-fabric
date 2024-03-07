# locals {
#   factories_config = merge(var.factories_config,{
#     projects_data_path = "${path.module}${var.factories_config.projects_data_path}"
#     org_policies = "${path.module}${var.factories_config.org_policies}"
#   } )

#   factories_config_folder = merge(var.factories_config_folder,{
#     org_policies = "${path.module}${var.factories_config_folder.org_policies}"
#   } )

# }

# output "factories_config" {
#   value = local.factories_config
# }

# output "factories_config_folder" {
#   value = local.factories_config_folder
# }

module "lz" {
    source = "../"
    prefix = var.prefix
    billing_account = var.billing_account
    organization = var.organization
    folder_name = var.folder_name
    factories_config_folder = var.factories_config_folder
    factories_config = var.factories_config
}
