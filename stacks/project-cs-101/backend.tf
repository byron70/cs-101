terraform {
  backend "gcs" {
    bucket  = "icydev-infra-usw4-tf-state"
    prefix  = "stacks/projects"
  }
}