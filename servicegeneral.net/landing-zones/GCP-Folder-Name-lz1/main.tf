module "resman" {
  source = "../../../fast/stages/1-resman"
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
  custom_roles= {
      organization_admin_viewer="organizations/695430022532/roles/organizationAdminViewer",
      organization_iam_admin="organizations/695430022532/roles/organizationIamAdmin",
      service_project_network_admin="organizations/695430022532/roles/serviceProjectNetworkAdmin",
      storage_viewer="organizations/695430022532/roles/storageViewer",
      tag_viewer="organizations/695430022532/roles/tagViewer",
      tenant_network_admin="organizations/695430022532/roles/tenantNetworkAdmin"
    }
    # logging={
    #   project_id="btstrap01-prod-audit-logs-0",
    #   project_number="698418922306",
    #   writer_identities={
    #     audit-logs="serviceAccount:service-org-695430022532@gcp-sa-logging.iam.gserviceaccount.com",
    #     vpc-sc="serviceAccount:service-org-695430022532@gcp-sa-logging.iam.gserviceaccount.com",
    #     workspace-audit-logs="serviceAccount:service-org-695430022532@gcp-sa-logging.iam.gserviceaccount.com"
    #   }
    # }
    org_policy_tags={
      key_id="tagKeys/281476659193603",
      key_name="org-policies",
      values={
        allowed-policy-member-domains-all="tagValues/281484974359632"
      }
    }
    outputs_location = "~/fast-config"
}

