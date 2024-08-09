terraform {
  required_version = ">= 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.40.0, <6"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.40.0"
    }
  }
}
