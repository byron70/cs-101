module "globals" {
  source             = "../../modules/context"
  name               = "global"
  billing_account_id = var.billing_account_id
  department         = var.department
  environment        = var.environment
  org                = var.org
  ou                 = var.ou
  region             = var.region
  repo               = var.repo
  stage              = var.stage
}

module "label_this" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = merge(module.globals.context, {
    name = "cs-101-1"
  })
}
