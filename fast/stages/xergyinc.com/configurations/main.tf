# # locals {
# #   _org_config_data_raw = merge([
# #     for f in try(fileset(path.module, "org-config.yaml"), []) :
# #     yamldecode(file("${path.module}/${f}"))
# #   ]...)
# #   # simulate applying defaults to data coming from yaml files
# #   _org_config_data = {
# #     for k, v in local._org_config_data_raw :
# #     k => {
# #         projects_detail=v
# #     }
# #     }

# #     org_config_data = local._org_config_data.projects
# # }

# # output "_folder_data" {
# #   value = local.org_config_data.projects_detail
# # }

# # module "automation-project" {
# #   source          = "../../../../modules/project"
# #   for_each        = local.org_config_data.projects_detail
# #   billing_account = var.billing_account.id
# #   name            = each.key
# #   parent = coalesce(
# #     var.project_parent_ids.automation, "organizations/${each.value.org_id}"
# #   )
# #   prefix = var.prefix
# #   contacts = (
# #     var.bootstrap_user != null || var.essential_contacts == null
# #     ? {}
# #     : { (var.essential_contacts) = ["ALL"] }
# #   )
# #   # human (groups) IAM bindings
# # #   iam_by_principals = {
# # #     (local.principals.gcp-devops) = [
# # #       "roles/iam.serviceAccountAdmin",
# # #       "roles/iam.serviceAccountTokenCreator",
# # #     ]
# # #     (local.principals.gcp-organization-admins) = [
# # #       "roles/iam.serviceAccountTokenCreator",
# # #       "roles/iam.workloadIdentityPoolAdmin"
# # #     ]
# # #   }
# #   # machine (service accounts) IAM bindings
# # #   iam = {
# # #     "roles/browser" = [
# # #       module.automation-tf-resman-r-sa.iam_email
# # #     ]
# # #     "roles/owner" = [
# # #       module.automation-tf-bootstrap-sa.iam_email
# # #     ]
# # #     "roles/cloudbuild.builds.editor" = [
# # #       module.automation-tf-resman-sa.iam_email
# # #     ]
# # #     "roles/cloudbuild.builds.viewer" = [
# # #       module.automation-tf-resman-r-sa.iam_email
# # #     ]
# # #     "roles/iam.serviceAccountAdmin" = [
# # #       module.automation-tf-resman-sa.iam_email
# # #     ]
# # #     "roles/iam.serviceAccountViewer" = [
# # #       module.automation-tf-resman-r-sa.iam_email
# # #     ]
# # #     "roles/iam.workloadIdentityPoolAdmin" = [
# # #       module.automation-tf-resman-sa.iam_email
# # #     ]
# # #     "roles/iam.workloadIdentityPoolViewer" = [
# # #       module.automation-tf-resman-r-sa.iam_email
# # #     ]
# # #     "roles/source.admin" = [
# # #       module.automation-tf-resman-sa.iam_email
# # #     ]
# # #     "roles/source.reader" = [
# # #       module.automation-tf-resman-r-sa.iam_email
# # #     ]
# # #     "roles/storage.admin" = [
# # #       module.automation-tf-resman-sa.iam_email
# # #     ]
# # #     (module.organization.custom_role_id["storage_viewer"]) = [
# # #       module.automation-tf-bootstrap-r-sa.iam_email,
# # #       module.automation-tf-resman-r-sa.iam_email
# # #     ]
# # #     "roles/viewer" = [
# # #       module.automation-tf-bootstrap-r-sa.iam_email,
# # #       module.automation-tf-resman-r-sa.iam_email
# # #     ]
# # #   }
# # #   iam_bindings = {
# # #     delegated_grants_resman = {
# # #       members = [module.automation-tf-resman-sa.iam_email]
# # #       role    = "roles/resourcemanager.projectIamAdmin"
# # #       condition = {
# # #         title       = "resman_delegated_grant"
# # #         description = "Resource manager service account delegated grant."
# # #         expression = format(
# # #           "api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly(['%s'])",
# # #           "roles/serviceusage.serviceUsageConsumer"
# # #         )
# # #       }
# # #     }
# # #   }
# # #   iam_bindings_additive = {
# # #     serviceusage_resman = {
# # #       member = module.automation-tf-resman-sa.iam_email
# # #       role   = "roles/serviceusage.serviceUsageConsumer"
# # #     }
# # #     serviceusage_resman_r = {
# # #       member = module.automation-tf-resman-r-sa.iam_email
# # #       role   = "roles/serviceusage.serviceUsageViewer"
# # #     }
# # #   }
# #   org_policies = var.bootstrap_user != null ? {} : {
# #     "compute.skipDefaultNetworkCreation" = {
# #       rules = [{ enforce = true }]
# #     }
# #     "iam.automaticIamGrantsForDefaultServiceAccounts" = {
# #       rules = [{ enforce = true }]
# #     }
# #     "iam.disableServiceAccountKeyCreation" = {
# #       rules = [{ enforce = true }]
# #     }
# #   }
# #   services = concat(
# #     [
# #       "accesscontextmanager.googleapis.com",
# #       "bigquery.googleapis.com",
# #       "bigqueryreservation.googleapis.com",
# #       "bigquerystorage.googleapis.com",
# #       "billingbudgets.googleapis.com",
# #       "cloudbilling.googleapis.com",
# #       "cloudkms.googleapis.com",
# #       "cloudresourcemanager.googleapis.com",
# #       "essentialcontacts.googleapis.com",
# #       "iam.googleapis.com",
# #       "iamcredentials.googleapis.com",
# #       "orgpolicy.googleapis.com",
# #       "pubsub.googleapis.com",
# #       "servicenetworking.googleapis.com",
# #       "serviceusage.googleapis.com",
# #       "sourcerepo.googleapis.com",
# #       "stackdriver.googleapis.com",
# #       "storage-component.googleapis.com",
# #       "storage.googleapis.com",
# #       "sts.googleapis.com"
# #     ],
# #     # enable specific service only after org policies have been applied
# #     var.bootstrap_user != null ? [] : [
# #       "cloudbuild.googleapis.com",
# #       "compute.googleapis.com",
# #       "container.googleapis.com",
# #     ]
# #   )
# # }


# locals {
# #   project_ids = {
# #   "audit" = {
# #     "custom_role_ids" = {}
# #     "id" = "org-dev-audit"
# #     "name" = "org-dev-audit"
# #     "number" = "53194414571"
# #     "project_id" = "org-dev-audit"
# #     "service_accounts" = {
# #       "cloud_services" = "53194414571@cloudservices.gserviceaccount.com"
# #       "default" = {
# #         "cloudbuild" = "53194414571@cloudbuild.gserviceaccount.com"
# #         "workstations" = "service-53194414571@gcp-sa-workstationsvm.iam.gserviceaccount.com"
# #       }
# #       "robots" = {
# #         "accessapproval" = "service-p53194414571@gcp-sa-accessapproval.iam.gserviceaccount.com"
# #       }
# #     }
# #     "services" = tolist([
# #       "accesscontextmanager.googleapis.com",

# #     ])
# #     "sink_writer_identities" = {}
# #     "tag_keys" = {}
# #     "tag_values" = {}
# #   }
# #   "automation" = {
# #     "custom_role_ids" = {}
# #     "id" = "org-dev-automation"
# #     "name" = "org-dev-automation"
# #     "number" = "1085146850262"
# #     "project_id" = "org-dev-automation"
# #     "service_accounts" = {
# #       "cloud_services" = "1085146850262@cloudservices.gserviceaccount.com"
# #       "default" = {
# #         "cloudbuild" = "1085146850262@cloudbuild.gserviceaccount.com"
# #       }
# #       "robots" = {
# #         "accessapproval" = "service-p1085146850262@gcp-sa-accessapproval.iam.gserviceaccount.com"
# #       }
# #     }
# #     "services" = tolist([
# #       "accesscontextmanager.googleapis.com",

# #     ])
# #     "sink_writer_identities" = {}
# #     "tag_keys" = {}
# #     "tag_values" = {}
# #   }
# # }


# # # pp = [for key, value in local.project_ids : key]

# # pp = {for key, value in local.project_ids : key => [{
# #         project_id = local.project_ids[key].project_id
# #       }]
# #     }

# # values = { for id in local.pp: id => 
# #           lookup(local.project_ids, id, "default")
# #           }

# # matching_value = (length([for id in local.pp : id if strcontains(id, "audit")]) > 0)
# # matching_elements = [for id in local.pp : id if strcontains(id, "automat")][0]

# # project_id = { for k, v in jsondecode(local.project_ids) : k => v.project_id }
# # project_list = flatten([
# #     for key, value in local.project_ids : {
# #       key = {
# #         project_id = value.project_id
# #       }
# #     }
# #   ])

#   _org_config_data_raw = merge([
#     for f in try(fileset(path.module, "/configurations/org-config.yaml"), []) :
#     yamldecode(file("${path.module}/${f}"))
#   ]...)
#   # simulate applying defaults to data coming from yaml files
#   _org_config_data = {
#     for k, v in local._org_config_data_raw :
#     k => {
#         projects_detail=v

#     }
#   }
#   org_config_data = local._org_config_data

# }

# output "project_ids" {
#   value = local.org_config_data

# }

# # output "match_automate" {
# #   value = local.matching_elements
# # }