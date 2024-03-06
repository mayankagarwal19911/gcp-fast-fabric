# tfdoc:file:description Automation project and resources.

locals {
  _org_config_data_raw = merge([
    for f in try(fileset(path.module, "/configurations/org-config.yaml"), []) :
    yamldecode(file("${path.module}/${f}"))
  ]...)

  yaml_tf_variables_mapping = {
    automation-tf-resman-r-sa = module.automation-tf-resman-r-sa.iam_email
    automation-tf-bootstrap-sa = module.automation-tf-bootstrap-sa.iam_email
    automation-tf-resman-sa = module.automation-tf-resman-sa.iam_email
    automation-tf-bootstrap-r-sa = module.automation-tf-bootstrap-r-sa.iam_email
    organization_storage_viewer_custom_role_id = module.organization.custom_role_id["storage_viewer"]
  }

  rendered_org_decoded_yaml = yamldecode(templatefile("${path.module}/configurations/org-config.tftpl",
    local.yaml_tf_variables_mapping
    ))

  project_list = {
    for index, project_details in local.rendered_org_decoded_yaml.projects : index => {
      name     = index
      org_id   = project_details.org_id
      services = project_details.services
      iam_by_principals = {
        # appending domain name to groups
        for key, value in try(project_details.iam_by_principals, {}) : "group:${key}@${var.organization.domain}" => value
      }
      iam                   = try(project_details.iam, {})
      iam_bindings          = try(project_details.iam_bindings, {})
      iam_bindings_additive = try(project_details.iam_bindings_additive, {})
    }
  }
}

output "rendered_org_yaml" {
  value = local.rendered_org_decoded_yaml.projects["automation"].iam
}
module "org_project" {
  source          = "../../../modules/project"
  for_each        = local.project_list
  billing_account = var.billing_account.id
  name            = each.key
  parent = coalesce(
    try(each.value.project_parent_idn, ""), "organizations/${each.value.org_id}"
  )
  prefix = local.prefix
  contacts = (
    var.bootstrap_user != null || var.essential_contacts == null
    ? {}
    : { (var.essential_contacts) = ["ALL"] }
  )
  # human (groups) IAM bindings
  iam_by_principals = local.project_list[each.key].iam_by_principals

  # machine (service accounts) IAM bindings
  iam = local.project_list[each.key].iam
  iam_bindings = local.project_list[each.key].iam_bindings
  iam_bindings_additive = local.project_list[each.key].iam_bindings_additive
  
  services = concat(try(local.project_list[each.key].services, []),
    # enable specific service only after org policies have been applied
    var.bootstrap_user != null ? [] : [
      "cloudbuild.googleapis.com",
      "compute.googleapis.com",
      "container.googleapis.com",
    ]
  )
}

# output files bucket
module "tf_output_gcs" {
  source     = "../../../modules/gcs"
  for_each   = local.project_details
  project_id = local.project_details[each.key][0].project_id
  name          = "${local.project_details[each.key][0].project_id}-outputs-0"
  prefix        = local.prefix
  location      = local.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  depends_on    = [module.organization]
}
