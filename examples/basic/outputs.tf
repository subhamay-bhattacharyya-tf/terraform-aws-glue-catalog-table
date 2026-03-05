# -- examples/basic/outputs.tf
# ============================================================================
# Example: Basic Glue Catalog Table - Outputs
# ============================================================================

output "tables" {
  description = "All created Glue Catalog Tables"
  value       = module.glue_catalog_table.tables
}

output "table_ids" {
  description = "Map of table keys to their IDs"
  value       = module.glue_catalog_table.table_ids
}

output "table_arns" {
  description = "Map of table keys to their ARNs"
  value       = module.glue_catalog_table.table_arns
}

output "table_names" {
  description = "Map of table keys to their names"
  value       = module.glue_catalog_table.table_names
}
