terraform {
  backend "gcs" {
    bucket = "icydev-infra-usw4-tf-state"
    prefix = "stacks/mysql-cs-101"
  }
}
