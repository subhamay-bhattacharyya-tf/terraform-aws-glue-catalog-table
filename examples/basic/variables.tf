# -- examples/basic/variables.tf
# ============================================================================
# Example: Basic Glue Catalog Table - Variables
# ============================================================================

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "glue_table" {
  description = "Glue Catalog Table configuration map"
  type = map(object({
    table_name    = string
    database_name = string
    description   = optional(string, null)
    table_type    = optional(string, "EXTERNAL_TABLE")
    parameters    = optional(map(string), {})
    storage_descriptor = optional(object({
      location      = optional(string, null)
      input_format  = optional(string, null)
      output_format = optional(string, null)
      compressed    = optional(bool, false)
      parameters    = optional(map(string), {})
      columns = optional(list(object({
        name    = string
        type    = string
        comment = optional(string, null)
      })), [])
      ser_de_info = optional(object({
        serialization_library = optional(string, null)
        parameters            = optional(map(string), {})
      }), null)
    }), null)
  }))
}
