
locals {
  cicd_resman_sa   = try(module.automation-tf-cicd-sa["resman"].iam_email, "")
  cicd_resman_r_sa = try(module.automation-tf-cicd-r-sa["resman"].iam_email, "")
}
# resource hierarchy stage's bucket and service account

module "automation-tf-resman-gcs" {
  source        = "../../../modules/gcs"
  project_id    = local.automation_project_id
  name          = "iac-core-resman-0"
  prefix        = local.prefix
  location      = local.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin"  = [module.automation-tf-resman-sa.iam_email]
    "roles/storage.objectViewer" = [module.automation-tf-resman-r-sa.iam_email]
  }
  depends_on = [module.organization]
}

module "automation-tf-resman-sa" {
  source       = "../../../modules/iam-service-account"
  project_id   = local.automation_project_id
  name         = "resman-0"
  display_name = "Terraform org level(Stage 1) resman service account."
  prefix       = local.prefix
  # allow SA used by CI/CD workflow to impersonate this SA
  # we use additive IAM to allow tenant CI/CD SAs to impersonate it
  iam_bindings_additive = (
    local.cicd_resman_sa == "" ? {} : {
      cicd_token_creator = {
        member = local.cicd_resman_sa
        role   = "roles/iam.serviceAccountTokenCreator"
      }
    }
  )
  iam_storage_roles = {
    ("${module.tf_output_gcs["automation"].name}") = ["roles/storage.admin"]
  }
}

module "automation-tf-resman-r-sa" {
  source     = "../../../modules/iam-service-account"
  project_id = local.automation_project_id
  # local.automation_project_id
  name         = "resman-0r"
  display_name = "Terraform org level(Stage 1) resman service account (read-only)."
  prefix       = local.prefix
  # allow SA used by CI/CD workflow to impersonate this SA
  # we use additive IAM to allow tenant CI/CD SAs to impersonate it
  iam_bindings_additive = (
    local.cicd_resman_r_sa == "" ? {} : {
      cicd_token_creator = {
        member = local.cicd_resman_r_sa
        role   = "roles/iam.serviceAccountTokenCreator"
      }
    }
  )
  # we grant organization roles here as IAM bindings have precedence over
  # custom roles in the organization module, so these need to depend on it
  iam_organization_roles = {
    (var.organization.id) = [
      module.organization.custom_role_id["organization_admin_viewer"],
      module.organization.custom_role_id["tag_viewer"]
    ]
  }
  iam_storage_roles = {
    ("${module.tf_output_gcs["automation"].name}") = [module.organization.custom_role_id["storage_viewer"]]
  }
}


# this stage's bucket and service account

module "automation-tf-bootstrap-gcs" {
  source        = "../../../modules/gcs"
  project_id    = local.automation_project_id
  name          = "iac-core-bootstrap-0"
  prefix        = local.prefix
  location      = local.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  depends_on    = [module.organization]
}

module "automation-tf-bootstrap-sa" {
  source       = "../../../modules/iam-service-account"
  project_id   = local.automation_project_id
  name         = "bootstrap-0"
  display_name = "Terraform organization bootstrap service account."
  prefix       = local.prefix
  # allow SA used by CI/CD workflow to impersonate this SA
  iam = {
    "roles/iam.serviceAccountTokenCreator" = compact([
      try(module.automation-tf-cicd-sa["bootstrap"].iam_email, null)
    ])
  }
  iam_storage_roles = {
    ("${module.tf_output_gcs["automation"].name}") = ["roles/storage.admin"]
  }
}

module "automation-tf-bootstrap-r-sa" {
  source       = "../../../modules/iam-service-account"
  project_id   = local.automation_project_id
  name         = "bootstrap-0r"
  display_name = "Terraform organization bootstrap service account (read-only)."
  prefix       = local.prefix
  # allow SA used by CI/CD workflow to impersonate this SA
  iam = {
    "roles/iam.serviceAccountTokenCreator" = compact([
      try(module.automation-tf-cicd-r-sa["bootstrap"].iam_email, null)
    ])
  }
  # we grant organization roles here as IAM bindings have precedence over
  # custom roles in the organization module, so these need to depend on it
  iam_organization_roles = {
    (var.organization.id) = [
      module.organization.custom_role_id["organization_admin_viewer"],
      module.organization.custom_role_id["tag_viewer"]
    ]
  }
  iam_storage_roles = {
    ("${module.tf_output_gcs["automation"].name}") = [module.organization.custom_role_id["storage_viewer"]]
  }
}
