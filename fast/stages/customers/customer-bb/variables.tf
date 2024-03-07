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
    custom_roles          = optional(string)
    org_policies          = optional(string)
  })
}

variable "prefix" {
  # tfdoc:variable:source 0-bootstrap
  description = "Prefix used for resources that need unique names. Use 9 characters or less."
  type        = string
  validation {
    condition     = try(length(var.prefix), 0) < 10
    error_message = "Use a maximum of 9 characters for prefix."
  }
}

variable "organization" {
  description = "Organization details."
  type = object({
    id          = number
    domain      = optional(string)
    customer_id = optional(string)
  })
}

variable "folder_name" {
  description = "Folder name to create"
  type = string
  nullable = false
}

variable "factories_config_folder" {
  description = "Path to folder with YAML folder level description policies data files."
  type = object({
    org_policies          = optional(string)
  })
}


variable "temp_project_bool"{
  description = "Temporary variable to be used as false when folder needs to be created first."
  type = bool
  default = true
}