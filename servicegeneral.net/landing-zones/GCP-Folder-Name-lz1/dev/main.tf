module "project-factory" {
    source = "../../../../fast/stages/3-project-factory/dev"
    billing_account = {
        id     = "01621B-D308AE-C0992D"
        no_iam = true
    }
    factories_config = {
       projects_data_path = "../../../../fast/stages/3-project-factory/dev/data/projects/"
    }
    prefix = "btstrap01"
}

