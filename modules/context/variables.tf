# context variables used for standardized name, tagging
variable "org" {
  type        = string
  description = "Organization, usually Monument"
}
variable "ou" {
  type        = string
  description = "Business unit, Department or Organizational Unit for resource"
}
variable "environment" {
  type        = string
  description = "Region abbreviation. Mainly use for naming context."
}
variable "name" {
  type        = string
  description = "(optional) describe the context"
}
variable "region" {
  type        = string
  description = "Cloud provider region"
}
variable "department" {
  type        = string
  description = "Cost center for resource."
}
variable "repo" {
  type        = string
  description = "Tracking back to IaC repository."
}
variable "stage" {
  type        = string
  description = "Deployment environment"
}
# end of context variables

variable "billing_account_id" {
  type        = string
  description = "(optional) GCP Billing Account Identifier ex. 123456-123456-123456"
}
variable "organization_id" {
  type        = string
  description = "(optional) Organization ID for GCP workspace."
  default     = null
}
