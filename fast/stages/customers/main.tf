# tfdoc:file:description Project factory.

locals {
 yaml_tf_project_mapping = { 
    parent_folder_id = local.parent_folder_id 
  }
}
module "projects" {
  source = "../../../modules/project-factory"
  count = var.temp_project_bool ? 1 : 0
  data_defaults = {
    billing_account = var.billing_account.id
    # more defaults are available, check the project factory variables
  }
  data_merges = {
    labels = {
      environment = var.environment
    }
    services = [ ]
  }
  data_overrides = {
    prefix = ""
  }
  is_project_file_a_template = true
  factories_config = var.factories_config
  yaml_tf_project_mapping = local.yaml_tf_project_mapping
  depends_on = [ module.folder ]
}
