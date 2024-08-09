data "google_compute_subnetwork" "apps" {
  name    = module.label_subnet_apps[0].id
  project = module.label_this.id
  region  = var.region
}
