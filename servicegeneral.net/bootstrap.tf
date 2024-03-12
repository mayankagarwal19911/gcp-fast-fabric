locals {
  org = yamldecode(file("./bootstrap-org.yaml"))
}

module "bootstrap_stage" {
  source = "../fast/stages/0-bootstrap"
  billing_account = {
    id     = local.org.billing_account_id
    no_iam = local.org.no_iam
  }

  organization = {
    domain      = local.org.organization_domain
    id          = local.org.organization_id
    customer_id = local.org.customer_id
  }

  prefix = local.org.prefix
    factories_config = {
        custom_roles = local.org.custom_roles_path
    }

    workload_identity_providers = {
    # Use the public GitHub and specify an attribute condition
        gh-fast-fab = {
            attribute_condition = local.org.attribute_condition
            issuer              = local.org.issuer
         }
    }

    cicd_repositories = {
        "${local.org.cicd_repository_name}" = {
            branch            = local.org.branch
            identity_provider = local.org.identity_provider
            name              = local.org.name
            type              = local.org.type
        }
    }

    outputs_location = local.org.outputs_location
}
