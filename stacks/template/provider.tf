
provider "google-beta" {
  # Configuration options
  region  = var.region
  project = "icydev-eng-usw4-dev-cs-101-1"
}

provider "google" {
  region  = var.region
  project = "icydev-eng-usw4-dev-cs-101-1"
}
