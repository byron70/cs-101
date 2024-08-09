locals {
  google_load_balancer_ip_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
  image_port  = 8080
  target_tags = [module.label_app.id]
}

module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.1, <4"

  container = {
    image = "bitnami/wordpress"
    env = [
      {
        name  = "WORDPRESS_DATABASE_HOST"
        value = "172.21.0.2"
      },
      {
        name  = "WORDPRESS_DATABASE_USER"
        value = "app"
      },
      {
        name  = "WORDPRESS_DATABASE_PASSWORD"
        value = ""
      },
    ]

    # Declare volumes to be mounted.
    # This is similar to how docker volumes are declared.
    volumeMounts = [
      {
        mountPath = "/cache"
        name      = "tempfs-0"
        readOnly  = false
      },
    ]
  }

  # Declare the Volumes which will be used for mounting.
  volumes = [
    {
      name = "tempfs-0"

      emptyDir = {
        medium = "Memory"
      }
    },
  ]

  restart_policy = "Always"
}

module "mig_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "~> 11.0"
  machine_type         = "e2-micro"
  network              = var.network_self_link
  subnetwork           = data.google_compute_subnetwork.apps.self_link
  service_account      = null
  name_prefix          = module.label_app.id
  project_id           = module.label_this.id
  source_image_family  = "cos-stable"
  source_image_project = "cos-cloud"
  source_image         = reverse(split("/", module.gce-container.source_image))[0]
  metadata             = { "gce-container-declaration" = module.gce-container.metadata_value }
  tags                 = local.target_tags
  labels = merge(module.label_app.tags, {
    "container-vm" = module.gce-container.vm_container_label
  })
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 11.0, <12"

  mig_name          = module.label_app.id
  project_id        = module.label_this.id
  instance_template = module.mig_template.self_link
  region            = var.region
  hostname          = var.network_name
  target_size       = 1
  named_ports = [
    {
      name = "http",
      port = local.image_port
    },
    {
      name = "https",
      port = "8443"
    },
  ]
}

module "http-lb" {
  source  = "terraform-google-modules/lb-http/google"
  version = "~> 10.0, <11"

  project     = module.label_this.id
  name        = module.label_lb.id
  target_tags = local.target_tags
  firewall_networks = [
    var.network_self_link
  ]

  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = local.image_port
      port_name                       = "http"
      timeout_sec                     = 30
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = 80
        host                = null
        logging             = null
      }

      log_config = {
        enable      = false
        sample_rate = null
      }

      groups = [
        {
          group                        = module.mig.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}


resource "google_compute_firewall" "lb-to-instances" {
  name    = module.label_firewall_lb.id
  project = module.label_this.id
  network = var.network_name
  allow {
    protocol = "tcp"
    ports = [
      local.image_port
    ]
  }
  source_ranges = local.google_load_balancer_ip_ranges
  target_tags   = local.target_tags
}
/*
resource "google_compute_instance" "vm" {
  project      = module.label_this.id
  name         = module.label_app.id
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  network_interface {
    subnetwork_project = module.label_this.id
    subnetwork         = "icydev-eng-usw4-dev-subnet-apps-0"
    access_config {}
  }

  tags = module.label_app.tags

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "false"
  }

  labels = merge(module.label_app.tags, {
    container-vm = module.gce-container.vm_container_label
  })

  service_account {
    email = var.client_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
*/
