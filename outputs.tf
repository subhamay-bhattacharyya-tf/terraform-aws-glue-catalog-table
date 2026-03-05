# -- outputs.tf
# ============================================================================
# AWS Glue Catalog Table Module - Outputs
# ============================================================================

output "tables" {
  description = "Map of all created Glue Catalog Tables with their attributes"
  value = {
    for k, v in aws_glue_catalog_table.this : k => {
      id               = v.id
      name             = v.name
      arn              = v.arn
      database_name    = v.database_name
      catalog_id       = v.catalog_id
      table_type       = v.table_type
      storage_location = try(v.storage_descriptor[0].location, null)
      partition_keys   = [for pk in v.partition_keys : pk.name]
      columns = try([for col in v.storage_descriptor[0].columns : {
        name = col.name
        type = col.type
      }], [])
    }
  }
}

output "table_ids" {
  description = "Map of table keys to their IDs"
  value       = { for k, v in aws_glue_catalog_table.this : k => v.id }
}

output "table_arns" {
  description = "Map of table keys to their ARNs"
  value       = { for k, v in aws_glue_catalog_table.this : k => v.arn }
}

output "table_names" {
  description = "Map of table keys to their names"
  value       = { for k, v in aws_glue_catalog_table.this : k => v.name }
}
