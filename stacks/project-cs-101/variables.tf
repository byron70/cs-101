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
