# tfdoc:file:description Project factory.

module "projects" {
  source = "../../../modules/project-factory"
  count = var.temp_project_bool ? 1 : 0
  data_defaults = {
    billing_account = var.billing_account.id
    # more defaults are available, check the project factory variables
  }
  data_merges = {
    labels = {
      environment = "dev"
    }
    services = [
      "stackdriver.googleapis.com"
    ]
  }
  data_overrides = {
    prefix = "${var.prefix}-dev"
  }
  factories_config = var.factories_config
  depends_on = [ module.folder ]
}

