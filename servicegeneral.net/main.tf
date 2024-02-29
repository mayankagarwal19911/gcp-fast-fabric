module "bootstrap_stage" {
    source = "../fast/stages/0-bootstrap"
    billing_account = {
        id           = "01621B-D308AE-C0992D"
        no_iam = true
    }

    organization = {
        domain      = "servicegeneral.net"
        id          = 695430022532
        customer_id = "C01e1u7fv"
    }

    prefix = "btstrp01"
    factories_config = {
        custom_roles = "../fast/stages/0-bootstrap/data/custom-roles/"
    }
}

