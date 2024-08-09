# Module returns a context that can be used
# to standardize naming and labeling
# A better method would be a TF framework (terragrunt, terraspace)
# to make configuration more re-usable 
# across several stacks and environments

locals {
  billing_account_id = var.billing_account_id
  organization_id    = try(coalesce(var.organization_id, null), null)


  context = {
    additional_tag_map  = {}
    attributes          = []
    delimiter           = "-"
    enabled             = true
    id_length_limit     = 64
    label_order         = null
    name                = coalesce(var.name, "default")
    namespace           = join("-", [var.org, var.ou])
    environment         = var.environment
    stage               = var.stage
    label_key_case      = "lower"
    label_value_case    = "lower"
    region              = var.region
    regex_replace_chars = null
    tags = {
      department = var.department
      ou         = var.ou
      org        = var.org
      region     = var.region
      repo       = var.repo
    }
  }
}

module "label_this" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = local.context
}
