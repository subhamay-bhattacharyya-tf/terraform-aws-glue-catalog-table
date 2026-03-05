# -- examples/basic/main.tf
# ============================================================================
# Example: Basic Glue Catalog Table
# ============================================================================

resource "aws_glue_catalog_database" "this" {
  for_each = toset([for k, v in var.glue_table : v.database_name])
  name     = each.value
}

module "glue_catalog_table" {
  source = "../.."

  glue_table_config = var.glue_table

  depends_on = [aws_glue_catalog_database.this]
}
