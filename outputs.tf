# -- outputs.tf
# ============================================================================
# AWS Glue Catalog Table Module - Outputs
# ============================================================================

output "table_id" {
  description = "The ID of the Glue Catalog Table (catalog_id:database_name:table_name)"
  value       = aws_glue_catalog_table.this.id
}

output "table_name" {
  description = "The name of the Glue Catalog Table"
  value       = aws_glue_catalog_table.this.name
}

output "table_arn" {
  description = "The ARN of the Glue Catalog Table"
  value       = aws_glue_catalog_table.this.arn
}

output "database_name" {
  description = "The name of the database containing the table"
  value       = aws_glue_catalog_table.this.database_name
}

output "catalog_id" {
  description = "The catalog ID (AWS account ID)"
  value       = aws_glue_catalog_table.this.catalog_id
}

output "table_type" {
  description = "The type of the table"
  value       = aws_glue_catalog_table.this.table_type
}

output "storage_location" {
  description = "The S3 location of the table data"
  value       = try(aws_glue_catalog_table.this.storage_descriptor[0].location, null)
}

output "partition_keys" {
  description = "The partition keys of the table"
  value       = [for pk in aws_glue_catalog_table.this.partition_keys : pk.name]
}

output "columns" {
  description = "The columns of the table"
  value = try([for col in aws_glue_catalog_table.this.storage_descriptor[0].columns : {
    name = col.name
    type = col.type
  }], [])
}
