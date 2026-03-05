# -- variables.tf
# ============================================================================
# AWS Glue Catalog Table Module - Variables
# ============================================================================

variable "glue_table_config" {
  description = "Map of Glue Catalog Table configurations keyed by table identifier"
  type = map(object({
    table_name    = string
    database_name = string
    catalog_id    = optional(string, null)
    description   = optional(string, null)
    owner         = optional(string, null)
    retention     = optional(number, 0)
    table_type    = optional(string, "EXTERNAL_TABLE")
    parameters    = optional(map(string), {})

    storage_descriptor = optional(object({
      location                  = optional(string, null)
      input_format              = optional(string, null)
      output_format             = optional(string, null)
      compressed                = optional(bool, false)
      number_of_buckets         = optional(number, null)
      bucket_columns            = optional(list(string), [])
      stored_as_sub_directories = optional(bool, false)
      parameters                = optional(map(string), {})

      columns = optional(list(object({
        name       = string
        type       = string
        comment    = optional(string, null)
        parameters = optional(map(string), null)
      })), [])

      ser_de_info = optional(object({
        name                  = optional(string, null)
        serialization_library = optional(string, null)
        parameters            = optional(map(string), {})
      }), null)

      sort_columns = optional(list(object({
        column     = string
        sort_order = number
      })), null)

      skewed_info = optional(object({
        skewed_column_names               = optional(list(string), [])
        skewed_column_values              = optional(list(string), [])
        skewed_column_value_location_maps = optional(map(string), {})
      }), null)

      schema_reference = optional(object({
        schema_version_number = number
        schema_id = optional(object({
          schema_arn    = optional(string, null)
          schema_name   = optional(string, null)
          registry_name = optional(string, null)
        }), null)
      }), null)
    }), null)

    partition_keys = optional(list(object({
      name    = string
      type    = string
      comment = optional(string, null)
    })), [])

    target_table = optional(object({
      catalog_id    = string
      database_name = string
      name          = string
      region        = optional(string, null)
    }), null)
  }))

  default = {}

  validation {
    condition     = alltrue([for k, v in var.glue_table_config : length(v.table_name) > 0])
    error_message = "Table name must not be empty."
  }

  validation {
    condition     = alltrue([for k, v in var.glue_table_config : length(v.database_name) > 0])
    error_message = "Database name must not be empty."
  }

  validation {
    condition     = alltrue([for k, v in var.glue_table_config : v.table_type == null ? true : contains(["EXTERNAL_TABLE", "GOVERNED", "VIRTUAL_VIEW", "ICEBERG"], v.table_type)])
    error_message = "table_type must be 'EXTERNAL_TABLE', 'GOVERNED', 'VIRTUAL_VIEW', or 'ICEBERG'."
  }

  validation {
    condition     = alltrue([for k, v in var.glue_table_config : v.retention >= 0])
    error_message = "retention must be a non-negative number."
  }

  validation {
    condition = alltrue([
      for k, v in var.glue_table_config : v.table_type != "ICEBERG" || (
        v.parameters != null &&
        lookup(v.parameters, "metadata_location", null) != null
      )
    ])
    error_message = "metadata_location parameter is required when table_type is 'ICEBERG'."
  }
}
