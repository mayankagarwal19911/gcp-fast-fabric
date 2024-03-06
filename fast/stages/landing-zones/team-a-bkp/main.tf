# tfdoc:file:description Project factory.

module "zone_1_folder" {
  source = "../../../../modules/folder"
  count  = 1
  parent = "organizations/${var.organization.id}"
  name   = "Data Platform"
  factories_config = var.factories_config
  # tag_bindings = {
  #   context = try(
  #     module.organization.tag_values["${var.tag_names.context}/data"].id, null
  #   )
  # }
}


# module "projects" {
#   source = "../../../../modules/project-factory"
#   data_defaults = {
#     billing_account = var.billing_account.id
#     # more defaults are available, check the project factory variables
#   }
#   data_merges = {
#     labels = {
#       environment = "dev"
#     }
#     services = [
#       "stackdriver.googleapis.com"
#     ]
#   }
#   data_overrides = {
#     prefix = "${var.prefix}-dev"
#   }
#   factories_config = var.factories_config
#   depends_on = [ module.zone_1_folder ]
# }
