module "label_subnet_apps" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  count   = 2
  context = merge(module.globals.context, {
    name       = "subnet-apps"
    attributes = [count.index]
  })
}

module "label_subnet_int" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  count   = 2
  context = merge(module.globals.context, {
    name       = "subnet-int"
    attributes = [count.index]
  })
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1, <10"

  project_id   = module.label_this.id
  network_name = "vpc-primary"
  routing_mode = "GLOBAL"

  subnets = concat([for i, v in module.label_subnet_apps : {
    subnet_name           = v.id
    subnet_ip             = "10.10.${10 * i + 10}.0/24"
    subnet_region         = var.region
    subnet_private_access = "true"
    }],
    [for i, v in module.label_subnet_int : {
      subnet_name           = v.id
      subnet_ip             = "10.10.${10 * i + 100}.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
  }])

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]

  ingress_rules = [
    {
      name          = "allow-ingress-ssh-from-iap"
      source_ranges = ["35.235.240.0/20"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22", ]
        },
      ]
    },
  ]
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 5.2, <6"
  create_router                      = true
  project_id                         = module.label_this.id
  region                             = var.region
  name                               = module.label_cloud_nat[0].id
  network                            = module.vpc.network_self_link
  router                             = module.label_router[0].id
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetworks = [for i, v in module.label_subnet_apps : {
    name                     = v.id
    source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
    secondary_ip_range_names = []
  }]
}
