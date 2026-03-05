# -- examples/parquet/main.tf
# ============================================================================
# Example: Glue Catalog Table with Parquet Format
# ============================================================================

resource "aws_glue_catalog_database" "this" {
  name = var.glue_table.database_name
}

module "glue_catalog_table" {
  source = "../.."

  glue_table_config = var.glue_table

  depends_on = [aws_glue_catalog_database.this]
}
