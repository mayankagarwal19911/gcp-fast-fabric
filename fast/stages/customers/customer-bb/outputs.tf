output "folder_details" {
  description = "Folder details."
  value = module.lz.folder_details
}

output "projects" {
  description = "Created projects."
  value = module.lz.projects
}

# output "service_accounts" {
#   description = "Created service accounts."
#   value       = module.projects.service_accounts
# }
