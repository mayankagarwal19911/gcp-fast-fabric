# resource "random_string" "project_id" {
#   length  = 10
#   special = false
#   upper = false
# }

	# cust-b-dev-bb-project-0

locals {
  parent_folder_name = "project-${var.client_initials}"
  # project_id = "${random_string.project_id.result}"
  parent_folder_id = module.folder[0].folder.id
  # project_name = "${project_name}-${client_initials}-${var.environment}"
  # dns_name = "${substr(sha256(local.project_name), 0, 10)}.${var.domain_name}"
}
