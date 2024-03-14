# tfdoc:file:description Audit log project and sink.

locals {
  log_sink_destinations = merge(
    # use the same dataset for all sinks with `bigquery` as  destination
    {
      for k, v in var.log_sinks :
      k => module.log-export-dataset.0 if v.type == "bigquery"
    },
    # use the same gcs bucket for all sinks with `storage` as destination
    {
      for k, v in var.log_sinks :
      k => module.log-export-gcs.0 if v.type == "storage"
    },
    # use separate pubsub topics and logging buckets for sinks with
    # destination `pubsub` and `logging`
    module.log-export-pubsub,
    module.log-export-logbucket
  )
  log_types = toset([for k, v in var.log_sinks : v.type])

  audit_project_id     = lookup(local.project_details, "audit")[0].id
  audit_project_number = lookup(local.project_details, "audit")[0].project_number
}

# one log export per type, with conditionals to skip those not needed

module "log-export-dataset" {
  source        = "../../../modules/bigquery-dataset"
  count         = contains(local.log_types, "bigquery") ? 1 : 0
  project_id    = local.audit_project_id
  id            = "audit_export"
  friendly_name = "Audit logs export."
  location      = local.locations.bq
}

module "log-export-gcs" {
  source        = "../../../modules/gcs"
  count         = contains(local.log_types, "storage") ? 1 : 0
  project_id    = local.audit_project_id
  name          = "${var.prefix}-${var.environment}-audit"
  prefix        = local.prefix
  location      = local.locations.gcs
  storage_class = local.gcs_storage_class
}

module "log-export-logbucket" {
  source      = "../../../modules/logging-bucket"
  for_each    = toset([for k, v in var.log_sinks : k if v.type == "logging"])
  parent_type = "project"
  parent      = local.audit_project_id
  id          = "audit-logs-${each.key}"
  location    = local.locations.logging
  
}

module "log-export-pubsub" {
  source     = "../../../modules/pubsub"
  for_each   = toset([for k, v in var.log_sinks : k if v.type == "pubsub"])
  project_id = local.audit_project_id
  name       = "audit-logs-${each.key}"
  regions    = local.locations.pubsub
}
