locals {
  config = yamldecode(file("./config.yaml"))
}

module "bootstrap_stage" {
  source = "../../fast/stages/0-bootstrap"
  billing_account = local.config.billing_account
  organization = local.config.organization

  prefix = local.config.prefix
  factories_config = local.config.factories_config

  project_parent_ids = local.config.project_parent_ids

  essential_contacts = local.config.essential_contacts
  groups = local.config.groups

  # workload_identity_providers = {
  # # Use the public GitHub and specify an attribute condition
  #     gh-fast-fab = {
  #         attribute_condition = local.config.attribute_condition
  #         issuer              = local.config.issuer
  #      }
  # }

  # cicd_repositories = {
  #     "${local.config.cicd_repository_name}" = {
  #         branch            = local.config.branch
  #         identity_provider = local.config.identity_provider
  #         name              = local.config.name
  #         type              = local.config.type
  #     }
  # }

  # outputs_location = local.config.outputs_location
}
