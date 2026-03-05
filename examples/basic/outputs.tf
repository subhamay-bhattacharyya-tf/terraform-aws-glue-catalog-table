# -- examples/basic/outputs.tf
# ============================================================================
# Example: Basic Glue Catalog Table - Outputs
# ============================================================================

output "table_id" {
  description = "The ID of the Glue Catalog Table"
  value       = module.glue_catalog_table.table_id
}

output "table_name" {
  description = "The name of the Glue Catalog Table"
  value       = module.glue_catalog_table.table_name
}

output "table_arn" {
  description = "The ARN of the Glue Catalog Table"
  value       = module.glue_catalog_table.table_arn
}

output "database_name" {
  description = "The database name"
  value       = module.glue_catalog_table.database_name
}
