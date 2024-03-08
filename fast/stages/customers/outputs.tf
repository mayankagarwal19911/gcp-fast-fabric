output "projects" {
  description = "Created projects."
  value = [
    for project in module.projects[0].projects: {
      project_id = project.project_id
      number     = project.number
    }
  ]
}

output "folder_details" {
 value = module.folder  
}
