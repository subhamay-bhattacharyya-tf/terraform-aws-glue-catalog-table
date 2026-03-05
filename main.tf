# -- main.tf
# ============================================================================
# AWS Glue Catalog Table Resource
# Creates and manages Glue Catalog Tables with configurable schema, 
# storage descriptor, and partition keys
# ============================================================================

resource "aws_glue_catalog_table" "this" {
  for_each = var.glue_table_config

  name          = each.value.table_name
  database_name = each.value.database_name
  catalog_id    = each.value.catalog_id
  description   = each.value.description
  owner         = each.value.owner
  retention     = each.value.retention
  table_type    = each.value.table_type
  parameters    = each.value.parameters

  dynamic "storage_descriptor" {
    for_each = each.value.storage_descriptor != null ? [each.value.storage_descriptor] : []
    content {
      location                  = storage_descriptor.value.location
      input_format              = storage_descriptor.value.input_format
      output_format             = storage_descriptor.value.output_format
      compressed                = storage_descriptor.value.compressed
      number_of_buckets         = storage_descriptor.value.number_of_buckets
      bucket_columns            = storage_descriptor.value.bucket_columns
      stored_as_sub_directories = storage_descriptor.value.stored_as_sub_directories
      parameters                = storage_descriptor.value.parameters

      dynamic "columns" {
        for_each = storage_descriptor.value.columns != null ? storage_descriptor.value.columns : []
        content {
          name       = columns.value.name
          type       = columns.value.type
          comment    = columns.value.comment
          parameters = columns.value.parameters
        }
      }

      dynamic "ser_de_info" {
        for_each = storage_descriptor.value.ser_de_info != null ? [storage_descriptor.value.ser_de_info] : []
        content {
          name                  = ser_de_info.value.name
          serialization_library = ser_de_info.value.serialization_library
          parameters            = ser_de_info.value.parameters
        }
      }

      dynamic "sort_columns" {
        for_each = storage_descriptor.value.sort_columns != null ? storage_descriptor.value.sort_columns : []
        content {
          column     = sort_columns.value.column
          sort_order = sort_columns.value.sort_order
        }
      }

      dynamic "skewed_info" {
        for_each = storage_descriptor.value.skewed_info != null ? [storage_descriptor.value.skewed_info] : []
        content {
          skewed_column_names               = skewed_info.value.skewed_column_names
          skewed_column_values              = skewed_info.value.skewed_column_values
          skewed_column_value_location_maps = skewed_info.value.skewed_column_value_location_maps
        }
      }

      dynamic "schema_reference" {
        for_each = storage_descriptor.value.schema_reference != null ? [storage_descriptor.value.schema_reference] : []
        content {
          schema_version_number = schema_reference.value.schema_version_number

          dynamic "schema_id" {
            for_each = schema_reference.value.schema_id != null ? [schema_reference.value.schema_id] : []
            content {
              schema_arn    = schema_id.value.schema_arn
              schema_name   = schema_id.value.schema_name
              registry_name = schema_id.value.registry_name
            }
          }
        }
      }
    }
  }

  dynamic "partition_keys" {
    for_each = each.value.partition_keys != null ? each.value.partition_keys : []
    content {
      name    = partition_keys.value.name
      type    = partition_keys.value.type
      comment = partition_keys.value.comment
    }
  }

  dynamic "target_table" {
    for_each = each.value.target_table != null ? [each.value.target_table] : []
    content {
      catalog_id    = target_table.value.catalog_id
      database_name = target_table.value.database_name
      name          = target_table.value.name
      region        = target_table.value.region
    }
  }
}
