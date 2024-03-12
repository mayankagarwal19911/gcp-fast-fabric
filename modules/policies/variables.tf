
variable "organization_id" {
  description = "Organization id in organizations/nnnnnn format."
  type        = string
  validation {
    condition     = can(regex("^organizations/[0-9]+", var.organization_id))
    error_message = "The organization_id must in the form organizations/nnn."
  }
}


variable "org_policies" {
  description = "Organization policies applied to this organization keyed by policy name."
  type = map(object({
    inherit_from_parent = optional(bool) # for list policies only.
    reset               = optional(bool)
    rules = optional(list(object({
      allow = optional(object({
        all    = optional(bool)
        values = optional(list(string))
      }))
      deny = optional(object({
        all    = optional(bool)
        values = optional(list(string))
      }))
      enforce = optional(bool) # for boolean policies only.
      condition = optional(object({
        description = optional(string)
        expression  = optional(string)
        location    = optional(string)
        title       = optional(string)
      }), {})
    })), [])
  }))
  default  = {}
  nullable = false
}

variable "org_policy_custom_constraints" {
  description = "Organization policy custom constraints keyed by constraint name."
  type = map(object({
    display_name   = optional(string)
    description    = optional(string)
    action_type    = string
    condition      = string
    method_types   = list(string)
    resource_types = list(string)
  }))
  default  = {}
  nullable = false
}


variable "factories_config" {
  description = "Paths to data files and folders that enable factory functionality."
  type = object({
    custom_roles                  = optional(string)
    org_policies                  = optional(string)
    org_policy_custom_constraints = optional(string)
  })
  nullable = false
  default  = {}
}