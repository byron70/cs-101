
provider "google-beta" {
  # Configuration options
  region  = var.region
  project = "icydev-infra"
}

provider "google" {
  region  = var.region
  project = "icydev-infra"
}
