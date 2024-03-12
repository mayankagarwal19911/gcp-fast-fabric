module "security" {
  source = "../../fast/stages/2-security"
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

  kms_keys = {
    compute = {
      iam = {
        "roles/cloudkms.cryptoKeyEncrypterDecrypter" = [
          "user:user1@example.com"
        ]
      }
      labels          = { service = "compute" }
      locations       = ["europe-west1", "europe-west3", "global"]
      rotation_period = "7776000s"
    }
    storage = {
      iam             = null
      labels          = { service = "compute" }
      locations       = ["europe"]
      rotation_period = null
    }
  }
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
  service_accounts = {
    data-platform-dev      = null,
    data-platform-dev-r    = null,
    data-platform-prod     = null,
    data-platform-prod-r   = null,
    gke-dev                = null,
    gke-dev-r              = null,
    gke-prod               = null,
    gke-prod-r             = null,
    networking             = "btstrap01-prod-resman-net-0@btstrap01-prod-iac-core-0.iam.gserviceaccount.com",
    networking-r           = "btstrap01-prod-resman-net-0r@btstrap01-prod-iac-core-0.iam.gserviceaccount.com",
    project-factory-dev    = null,
    project-factory-dev-r  = null,
    project-factory-prod   = null,
    project-factory-prod-r = null,
    sandbox                = null,
    security               = "btstrap01-security-0@btstrap01-prod-iac-core-0.iam.gserviceaccount.com",
    security-r             = "btstrap01-prod-resman-sec-0r@btstrap01-prod-iac-core-0.iam.gserviceaccount.com",
    teams                  = null
  }
  # tag_keys={
  #     context="tagKeys/281477551103018",
  #     environment="tagKeys/281483865124929",
  #     tenant="tagKeys/281483710353743"
  #   }
  # tag_names={
  #     context="context",
  #     environment="environment",
  #     tenant="tenant"
  #   },
  #   tag_values={
  #     context/data="tagValues/281483224555507",
  #     context/gke="tagValues/281483203102054",
  #     context/networking="tagValues/281477883123591",
  #     context/sandbox="tagValues/281483979499568",
  #     context/security="tagValues/281479358391116",
  #     context/teams="tagValues/281478148867621",
  #     context/tenant="tagValues/281477843279044",
  #     environment/development="tagValues/281479172726645",
  #     environment/production="tagValues/281480843337357"
  #   }
  outputs_location = "~/fast-config"
}

