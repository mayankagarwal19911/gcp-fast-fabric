# tfdoc:file:description Workload Identity Federation provider definitions.

locals {

  _workload_identity_providers_data_raw = {
    for f in try(fileset(var.factories_config.projects_data_path, "*.yaml"), []) :
    replace(f, ".yaml", "") => yamldecode(
      file("${var.factories_config.projects_data_path}/${f}")
    )
  }

  _workload_identity_providers = {
    for key, value in local._workload_identity_providers_data_raw: key =>{
        for k, v in value : k => v if k == "workload_identity_provider"
    } 
  }

  workload_identity_providers_defs = {
    # https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
    github = {
      attribute_mapping = {
        "google.subject"             = "assertion.sub"
        "attribute.sub"              = "assertion.sub"
        "attribute.actor"            = "assertion.actor"
        "attribute.repository"       = "assertion.repository"
        "attribute.repository_owner" = "assertion.repository_owner"
        "attribute.ref"              = "assertion.ref"
        "attribute.fast_sub"         = "\"repo:\" + assertion.repository + \":ref:\" + assertion.ref"
      }
      issuer_uri       = "https://token.actions.githubusercontent.com"
      principal_branch = "principalSet://iam.googleapis.com/%s/attribute.fast_sub/repo:%s:ref:refs/heads/%s"
      principal_repo   = "principalSet://iam.googleapis.com/%s/attribute.repository/%s"
    }
    # https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html#token-payload
  }

  workload_identity_providers = flatten([
    for derived_project_name, project in local.projects : [
      for used_project_name, provider_value in local._workload_identity_providers : {
        name                        = used_project_name
        number                      = project.number
        project_id                  = project.project_id
        workload_identity_providers = {
          provider_name = keys(provider_value.workload_identity_provider)[0]
          provider_value = {
            attribute_condition = provider_value.workload_identity_provider[keys(provider_value.workload_identity_provider)[0]].attribute_condition
            custom_settings = provider_value.workload_identity_provider[keys(provider_value.workload_identity_provider)[0]].custom_settings
            issuer = lookup(local.workload_identity_providers_defs, provider_value.workload_identity_provider[keys(provider_value.workload_identity_provider)[0]].issuer, {})
          }
        },
        workload_identity_pool_id = local.workload_identity_pool_id[project.project_id].workload_identity_pool_id
        workload_identity_pool_name = local.workload_identity_pool_id[project.project_id].name
      }if can(provider_value.workload_identity_provider) && strcontains(derived_project_name, used_project_name)
    ]
  ])
}

resource "google_iam_workload_identity_pool" "default" {
  provider                  = google-beta
  for_each                  = local.projects
  project                   = each.value.project_id
  workload_identity_pool_id = "${each.key}-idn-pl"
}

resource "google_iam_workload_identity_pool_provider" "default" {
  provider = google-beta
  count = length(local.workload_identity_providers)
  project  = local.workload_identity_providers[count.index].project_id
  workload_identity_pool_id = local.workload_identity_providers[count.index].workload_identity_pool_id
  workload_identity_pool_provider_id = local.workload_identity_providers[count.index].workload_identity_providers.provider_name
  attribute_condition                = local.workload_identity_providers[count.index].workload_identity_providers.provider_value.attribute_condition
  attribute_mapping                  = local.workload_identity_providers[count.index].workload_identity_providers.provider_value.issuer.attribute_mapping
  oidc {
    # Setting an empty list configures allowed_audiences to the url of the provider
    allowed_audiences = local.workload_identity_providers[count.index].workload_identity_providers.provider_value.custom_settings.audiences
    # If users don't provide an issuer_uri, we set the public one for the platform choosed.
    issuer_uri = (
      local.workload_identity_providers[count.index].workload_identity_providers.provider_value.custom_settings.issuer_uri != null
      ? local.workload_identity_providers[count.index].workload_identity_providers.provider_value.custom_settings.issuer_uri
      : try(local.workload_identity_providers[count.index].workload_identity_providers.provider_value.issuer.issuer_uri, null)
    )
    # OIDC JWKs in JSON String format. If no value is provided, they key is
    # fetched from the `.well-known` path for the issuer_uri
    jwks_json = local.workload_identity_providers[count.index].workload_identity_providers.provider_value.custom_settings.audiences
  }
}
