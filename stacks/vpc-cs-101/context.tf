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

module "label_vpc_primary" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = merge(module.globals.context, {
    name = "vpc-primary"
  })
}

module "label_cloud_nat" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  count   = 1
  context = merge(module.globals.context, {
    name       = "cloud-nat"
    attributes = [count.index]
  })
}

module "label_router" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  count   = 1
  context = merge(module.globals.context, {
    name       = "router"
    attributes = [count.index]
  })
}
