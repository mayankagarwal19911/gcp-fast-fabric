module "lz" {
  source                  = "../"
  prefix                  = var.prefix
  billing_account         = var.billing_account
  organization            = var.organization
  folder_name             = var.folder_name
  factories_config_folder = var.factories_config_folder
  factories_config        = var.factories_config
  # temp_project_bool = false
}

