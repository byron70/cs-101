module "psa" {
  source  = "terraform-google-modules/sql-db/google//modules/private_service_access"
  version = "~> 21.0, <22"

  project_id      = module.label_this.id
  vpc_network     = var.network_name
  deletion_policy = ""
}


module "mysql" {
  source  = "terraform-google-modules/sql-db/google//modules/safer_mysql"
  version = "~> 21.0, <22"

  name                 = "cs-101"
  random_instance_name = true
  project_id           = module.label_this.id

  deletion_protection = false

  database_version = var.mysql_version
  edition          = var.mysql_edition
  region           = var.region
  tier             = var.mysql_instance_type

  # https://cloud.google.com/sql/docs/mysql/flags
  database_flags = [
    {
      name  = "cloudsql_iam_authentication"
      value = "on"
    },
    {
      name  = "long_query_time"
      value = 500
    },
    {
      name  = "slow_query_log"
      value = "on"
    },
    {
      name  = "log_output"
      value = "FILE"
    },
  ]

  additional_users = [
    {
      name = "app"
      // just for the purpose of this exercise
      password        = ""
      host            = "%"
      type            = "BUILT_IN"
      random_password = true
    },
  ]

  # Supports creation of both IAM Users and IAM Service Accounts with provided emails
  iam_users = [
    {
      id    = "dbadmin",
      email = "byronosity@gmail.com"
    }
  ]

  allocated_ip_range = module.psa.google_compute_global_address_name
  assign_public_ip   = false
  user_labels        = module.label_this.tags
  vpc_network        = var.network_self_link

  // Optional: used to enforce ordering in the creation of resources.
  module_depends_on = [module.psa.peering_completed]
}
