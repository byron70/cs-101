output "billing_account_id" {
  value = local.billing_account_id
}

output "organization_id" {
  value = local.organization_id
}

output "context" {
  value       = local.context
  description = "Normalized context, generated from context inputs."
}

output "normalized_context" {
  value = module.label_this.normalized_context
}

output "id" {
  value       = module.label_this.id
  description = "ID from label module. Useful when variable name is specified"
}

output "id_full" {
  value       = module.label_this.id_full
  description = "ID from label module without length restriction"
}

