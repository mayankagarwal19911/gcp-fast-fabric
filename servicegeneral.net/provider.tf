terraform {
  backend "gcs" {
    bucket  = "org-bootstrap-statefile"
    prefix  = "terraform/org/bootstrap/state"
  }
}
