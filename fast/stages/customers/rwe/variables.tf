#TODO: tfdoc annotations

variable "billing_account" {
  # tfdoc:variable:source 0-bootstrap
  description = "Billing account id. If billing account is not part of the same org set `is_org_level` to false."
  type = object({
    id           = string
    is_org_level = optional(bool, true)
  })
  validation {
    condition     = var.billing_account.is_org_level != null
    error_message = "Invalid `null` value for `billing_account.is_org_level`."
  }
}

variable "factories_config" {
  description = "Path to folder with YAML resource description data files."
  type = object({
    projects_data_path = string
    budgets = optional(object({
      billing_account       = string
      budgets_data_path     = string
      notification_channels = optional(map(any), {})
    }))
    custom_roles = optional(string)
    org_policies = optional(string)
  })
}

variable "organization" {
  description = "Organization details."
  type = object({
    id          = number
    domain      = optional(string)
    customer_id = optional(string)
  })
}

# variable "folder_name" {
#   description = "Folder name to create"
#   type        = string
#   nullable    = false
# }

variable "factories_config_folder" {
  description = "Path to folder with YAML folder level description policies data files."
  type = object({
    org_policies = optional(string)
  })
}


variable "temp_project_bool" {
  description = "Temporary variable to be used as false when folder needs to be created first."
  type        = bool
  default     = true
}

variable "tag_bindings" {
  description = "Tag bindings for this folder, in key => tag value id format."
  type        = map(string)
  nullable    = false
  default     = {}
}

variable "zone_name" {
  description = "Zone name, must be unique within the project."
  type        = string
}

variable "zone_project_id" {
  description = "Project id for the zone."
  type        = string
}

variable "workload_identity_providers" {
  description = "Workload Identity Federation pools. The `cicd_repositories` variable references keys here."
  type = map(object({
    attribute_condition = optional(string)
    issuer              = string
    custom_settings = optional(object({
      issuer_uri = optional(string)
      audiences  = optional(list(string), [])
      jwks_json  = optional(string)
    }), {})
  }))
  default  = {}
  nullable = false
}

variable "group_description" {
  description = "Group description."
  type        = string
  default     = null
}

variable "group_display_name" {
  description = "Group display name."
  type        = string
}

variable "group_name" {
  description = "Group name."
  type        = string
}

variable "client_initials" {
  description = "Client initials to be used in resources naming convention"
  type = string
  nullable = false
}
