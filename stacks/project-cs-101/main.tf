module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 15.0"

  name = module.label_this.id
  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
  ]
  billing_account = module.globals.billing_account_id
}
