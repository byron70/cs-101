### context 
variable "billing_account_id" {
  type        = string
  description = "(optional) GCP Billing Account Identifier ex. 123456-123456-123456"
}
variable "department" {
  type = string
}
variable "environment" {
  type = string
}
variable "org" {
  type = string
}
variable "ou" {
  type = string
}
variable "region" {
  type = string
}
variable "repo" {
  type = string
}
variable "stage" {
  type = string
}

### vpc
variable "network_name" {
  type        = string
  description = "Name of VPC network"
}
variable "network_self_link" {
  type        = string
  description = "VPC Network link for cloudsql proxy"
}

### mysql 
variable "mysql_instance_type" {
  type        = string
  description = "(optional) mysql instance size https://cloud.google.com/sql/docs/mysql/instance-settings#machine-type-2ndgen"
  default     = "db-f1-micro"
}
variable "mysql_version" {
  type        = string
  description = "(optional) mysql version https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion"
  default     = "MYSQL_8_0_37"
}
variable "mysql_edition" {
  type        = string
  description = "(optional) ENTERPRISE or ENTERPRISE_PLUS https://cloud.google.com/sql/docs/mysql/instance-settings#machine-type-2ndgen"
  default     = "ENTERPRISE"
}
