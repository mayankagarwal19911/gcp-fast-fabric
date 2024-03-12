
module "org-level-sa" {
  source       = "../../../modules/iam-service-account"
  project_id   = "billing-xx-0"
  name         = "rorg-doit-int-sa"
  display_name = "Terraform stage 1 resman service account (read-only)."
  prefix       = local.prefix
  # allow SA used by CI/CD workflow to impersonate this SA
  # we use additive IAM to allow tenant CI/CD SAs to impersonate it
#   iam_bindings_additive = (
#     local.cicd_resman_r_sa == "" ? {} : {
#       cicd_token_creator = {
#         member = local.cicd_resman_r_sa
#         role   = "roles/iam.serviceAccountTokenCreator"
#       }
#     }
#   )
  # we grant organization roles here as IAM bindings have precedence over
  # custom roles in the organization module, so these need to depend on it
#   iam_organization_roles = {
#     (var.organization.id) = [
#       module.organization.custom_role_id["organization_admin_viewer"],
#       module.organization.custom_role_id["tag_viewer"]
#     ]
#   }
#   iam_storage_roles = {
#     (module.automation-tf-output-gcs.name) = [module.organization.custom_role_id["storage_viewer"]]
#   }
}
