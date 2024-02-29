module "bootstrap_stage" {
  source = "../fast/stages/0-bootstrap"
  billing_account = {
    id     = "01621B-D308AE-C0992D"
    no_iam = true
  }

  organization = {
    domain      = "servicegeneral.net"
    id          = 695430022532
    customer_id = "C01e1u7fv"
  }

  prefix = "btstrap01"
    factories_config = {
        custom_roles = "../fast/stages/0-bootstrap/data/custom-roles/"
    }

    workload_identity_providers = {
    # Use the public GitHub and specify an attribute condition
        gh-fast-fab = {
            attribute_condition = "attribute.repository_owner==\"mayankagarwal19911\""
            issuer              = "github"
         }
    }

    cicd_repositories = {
        bootstrap = {
            branch            = "master"
            identity_provider = "github-sample"
            name              = "mayankagarwal19911/gcp-fast-fabric"
            type              = "github"
        }
    }
}

