/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description Organization-level IAM bindings locals.

locals {
  # IAM roles in the org to reset (remove principals)
  iam_delete_roles = [ ]
  # domain IAM bindings
  iam_domain_bindings = {}
  
  # human (groups) IAM bindings
  iam_principal_bindings = {
    (local.principals.org-admin) = {
      authoritative = [
        "roles/resourcemanager.organizationAdmin"
      ]
      additive = []
    }
    (local.principals.org-secops-admin) = {
      authoritative = [
        "roles/iam.securityReviewer",
        "roles/logging.viewer",
        "roles/monitoring.admin",
        "roles/orgpolicy.policyAdmin",
        "roles/advisorynotifications.admin",
        "roles/cloudsecurityscanner.editor",
        "roles/compute.orgFirewallPolicyAdmin",
        "roles/compute.orgSecurityPolicyAdmin"
      ]
      additive = [
      ]
    }
  }
  # machine (service accounts) IAM bindings, in logical format
  # the service account module's "magic" outputs allow us to use dynamic values
  iam_sa_bindings = {
    (module.org-level-sa.iam_email) = {
      authoritative = [
        "organizations/592550595621/roles/orgDoItViewer"
      ]
      additive = concat(
        [

        ],
        # local.billing_mode != "org" ? [] : [
        #   "roles/billing.admin"
        # ]
      )
    }
  }

  # bootstrap user bindings
  iam_user_bootstrap_bindings = var.bootstrap_user == null ? {} : {
    "user:${var.bootstrap_user}" = {
      authoritative = [
        "roles/logging.admin",
        "roles/owner",
        "roles/billing.admin",
        "roles/iam.organizationRoleAdmin",
        "roles/resourcemanager.organizationAdmin",
        "roles/resourcemanager.projectCreator",
        "roles/resourcemanager.tagAdmin",
        "roles/orgpolicy.policyAdmin"
      ]
      # TODO: align additive roles with the README
      additive = []
      # (
      #   local.billing_mode != "org" ? [] : [
      #     "roles/billing.admin"
      #   ]
      # )
    },
   "user:mayank@xergyinc.com" = {
      authoritative = [
        "roles/logging.admin",
        "roles/owner",
        "roles/billing.admin",
        "roles/iam.organizationRoleAdmin",
        "roles/resourcemanager.organizationAdmin",
        "roles/resourcemanager.projectCreator",
        "roles/resourcemanager.tagAdmin",
        "roles/orgpolicy.policyAdmin",
        "roles/resourcemanager.folders.create",
        "roles/resourcemanager.projectCreator"
      ]
      additive = [
      ]
      # (
      #   local.billing_mode != "org" ? [] : [
      #     "roles/billing.admin"
      #   ]
      # )
    }
  }

}
