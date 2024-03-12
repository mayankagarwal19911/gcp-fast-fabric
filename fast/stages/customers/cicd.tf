# tfdoc:file:description Workload Identity Federation configurations for CI/CD.

locals {
  _cicd_repositories_raw = {
    for f in try(fileset(var.factories_config.projects_data_path, "*.yaml"), []) :
    replace(f, ".yaml", "") => yamldecode(
      file("${var.factories_config.projects_data_path}/${f}")
    )
  }

  _cicd_repositories = {
    for key, value in local._cicd_repositories_raw: key =>{
        for k, v in value : k => v if k == "lz_repo"
    } 
  }

  # our use case is github so below definitiona can be ignored 
  cicd_repositories = {
    for k, v in coalesce(local._cicd_repositories, {}) : k => v
    if(
      v.lz_repo != null
      &&
      (
        try(v.lz_repo.type, null) == "sourcerepo"
        ||
        contains(
          keys(local._workload_identity_providers),
          coalesce(try(v.lz_repo.identity_provider, null), ":")
        )
      )
      &&
      fileexists(
        format("${path.module}/templates/workflow-%s.yaml", try(v.lz_repo.type, ""))
      )
    )
  }

  cicd_providers = [
    for provider in local.workload_identity_providers : {
      audiences = concat(
        coalesce(provider.workload_identity_providers.provider_value.custom_settings.audiences, []),
        ["https://iam.googleapis.com/${provider.workload_identity_providers.provider_name}"]
      )
      issuer           = provider.workload_identity_providers.provider_value.issuer
      issuer_uri       = provider.workload_identity_providers.provider_value.custom_settings.issuer_uri
      name             = provider.name
      principal_branch = provider.workload_identity_providers.provider_value.issuer.principal_branch
      principal_repo   = provider.workload_identity_providers.provider_value.issuer.principal_repo
    }
  ]

  cicd_repositories_sa_details = flatten([
    for used_project_name, repository in local._cicd_repositories : [
      for provider in local.workload_identity_providers : {
        project_id = provider.project_id
        type = repository.lz_repo.type
        repo_name = repository.lz_repo.name
        provider = provider
        principal_repo = provider.workload_identity_providers.provider_value.issuer.principal_repo
        principal_branch  = provider.workload_identity_providers.provider_value.issuer.principal_branch
        branch = repository.lz_repo.branch
        sa_name = "${used_project_name}-cicd"
        workload_identity_pool_name = provider.workload_identity_pool_name
      }
      if strcontains(provider.project_id, used_project_name)
    ]
  ])
}

# SAs used by CI/CD workflows to impersonate automation SAs
module "automation-tf-cicd-sa" {
  source       = "../../../modules/iam-service-account"
  count     = length(local.cicd_repositories_sa_details)
  project_id   = local.cicd_repositories_sa_details[count.index].project_id
  name         = local.cicd_repositories_sa_details[count.index].sa_name
  display_name = "Terraform CI/CD ${local.cicd_repositories_sa_details[count.index].sa_name} service account."
  # prefix       = var.data_overrides.prefix
  iam = (
    local.cicd_repositories_sa_details[count.index].type == "sourcerepo"
    # used directly from the cloud build trigger for source repos
    ? {}
    # impersonated via workload identity federation for external repos
    : {
      "roles/iam.workloadIdentityUser" = [
        local.cicd_repositories_sa_details[count.index].branch == null
        ? format(
          local.cicd_repositories_sa_details[count.index].principal_repo,
          local.cicd_repositories_sa_details[count.index].workload_identity_pool_name,
          local.cicd_repositories_sa_details[count.index].repo_name
        )
        : format(
          local.cicd_repositories_sa_details[count.index].principal_branch,
          local.cicd_repositories_sa_details[count.index].workload_identity_pool_name,
          local.cicd_repositories_sa_details[count.index].repo_name,
          local.cicd_repositories_sa_details[count.index].branch
        )
      ]
    }
  )
  # iam_project_roles = {
  #   (local.automation_project_id) = ["roles/logging.logWriter"]
  # }
  # iam_storage_roles = {
  #   ("${module.tf_output_gcs["automation"].name}") = ["roles/storage.objectViewer"]
  # }
}
