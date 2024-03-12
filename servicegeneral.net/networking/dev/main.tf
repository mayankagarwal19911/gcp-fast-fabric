module "networking" {
  source = "../../../fast/stages/2-networking-b-vpn"
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

  automation = {
    federated_identity_pool = "projects/454241663950/locations/global/workloadIdentityPools/btstrap01-bootstrap",
    federated_identity_providers = {
      gh-fast-fab = {
        audiences = [
          "https://iam.googleapis.com/projects/454241663950/locations/global/workloadIdentityPools/btstrap01-bootstrap/providers/btstrap01-bootstrap-gh-fast-fab"
        ],
        issuer           = "github",
        issuer_uri       = "https://token.actions.githubusercontent.com",
        name             = "projects/454241663950/locations/global/workloadIdentityPools/btstrap01-bootstrap/providers/btstrap01-bootstrap-gh-fast-fab",
        principal_branch = "principalSet://iam.googleapis.com/%s/attribute.fast_sub/repo:%s:ref:refs/heads/%s",
        principal_repo   = "principalSet://iam.googleapis.com/%s/attribute.repository/%s"
      }
    },
    outputs_bucket = "btstrap01-prod-iac-core-outputs-0",
    project_id     = "btstrap01-prod-iac-core-0",
    project_number = "454241663950",
    service_accounts = {
      bootstrap   = "btstrap01-prod-bootstrap-0@btstrap01-prod-iac-core-0.iam.gserviceaccount.com",
      bootstrap-r = "btstrap01-prod-bootstrap-0r@btstrap01-prod-iac-core-0.iam.gserviceaccount.com",
      resman      = "btstrap01-prod-resman-0@btstrap01-prod-iac-core-0.iam.gserviceaccount.com",
      resman-r    = "btstrap01-prod-resman-0r@btstrap01-prod-iac-core-0.iam.gserviceaccount.com"
    }
  }

  folder_ids = {
    data-platform-dev  = null,
    data-platform-prod = null,
    gke-dev            = null,
    gke-prod           = null,
    networking         = "folders/736592255343",
    networking-dev     = "folders/1050189866718",
    networking-prod    = "folders/261493040463",
    sandbox            = null,
    security           = "folders/1054703009252",
    teams              = null
  }

  factories_config = {
    data_dir              = "../../../fast/stages/2-networking-b-vpn/data/"
    dns_policy_rules_file = "../../../fast/stages/2-networking-b-vpn/data/dns-policy-rules.yaml"
    # firewall_policy_name  = "../../../fast/stages/2-networking-b-vpn/data/firewall-rules/dev/"
    }
  custom_roles = {
    service_project_network_admin = "../../../fast/stages/0-bootstrap/data/custom-roles/" 
  }
  outputs_location = "~/fast-config"
}
