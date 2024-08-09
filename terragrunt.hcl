locals {
  org_id           = "icydev"
  project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))


  gcp_region = local.region_vars.locals.gcp_region
  project_id = local.project_vars.locals.project_id

  # simplification to add this project by hand. 
  iac_project_id = "icydev-infra"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  region = "${local.gcp_region}"
  project = "${local.project_id}"
}
EOF
}


remote_state {
  backend = "gcs"

  config = {
    project  = "icydev-infra"                                    # The GCP project where the bucket will be created.
    location = local.gcp_region                                  # The GCP location where the bucket will be created.
    bucket   = "terragrunt-state-${local.project_id}"            # (Required) The name of the GCS bucket. This name must be globally unique. For more information, see Bucket Naming Guidelines.
    prefix   = "${path_relative_to_include()}/terraform.tfstate" #- (Optional) GCS prefix inside the bucket. Named states for workspaces are stored in an object called <prefix>/<name>.tfstate.

  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}