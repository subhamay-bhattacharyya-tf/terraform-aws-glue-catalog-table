# Terraform AWS Glue Catalog Table Module

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table/actions/workflows/ci.yaml/badge.svg)&nbsp;![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/2983112d16d4dd7076415b0c523f1c98/raw/terraform-aws-glue-catalog-table.json?)

A Terraform module for creating and managing AWS Glue Catalog Tables with configurable schema, storage descriptors, partition keys, and SerDe configurations.

## Features

- JSON-style configuration input via single object variable
- Support for multiple table types (EXTERNAL_TABLE, GOVERNED, VIRTUAL_VIEW)
- Configurable storage descriptors with columns and SerDe info
- Partition key support for efficient data querying
- Sort columns and skewed info configuration
- Schema registry reference support
- Target table configuration for resource links
- Built-in input validation

## Usage

### Basic Glue Catalog Table (CSV)

```hcl
module "glue_catalog_table" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table?ref=main"

  glue_table_config = {
    table_name    = "my_table"
    database_name = "my_database"
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor = {
      location      = "s3://my-bucket/data/"
      input_format  = "org.apache.hadoop.mapred.TextInputFormat"
      output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

      columns = [
        { name = "id", type = "int" },
        { name = "name", type = "string" },
        { name = "created_at", type = "timestamp" }
      ]

      ser_de_info = {
        serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
        parameters = {
          "field.delim" = ","
        }
      }
    }
  }
}
```

### Glue Catalog Table with Parquet Format

```hcl
module "glue_catalog_table" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table?ref=main"

  glue_table_config = {
    table_name    = "events_parquet"
    database_name = "analytics_db"
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor = {
      location      = "s3://my-bucket/parquet-data/"
      input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
      output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
      compressed    = true

      columns = [
        { name = "event_id", type = "string" },
        { name = "event_time", type = "timestamp" },
        { name = "payload", type = "string" }
      ]

      ser_de_info = {
        serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
        parameters = {
          "serialization.format" = "1"
        }
      }
    }
  }
}
```

### Glue Catalog Table with Partition Keys

```hcl
module "glue_catalog_table" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-catalog-table?ref=main"

  glue_table_config = {
    table_name    = "events_partitioned"
    database_name = "analytics_db"
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor = {
      location      = "s3://my-bucket/events/"
      input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
      output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

      columns = [
        { name = "event_id", type = "string" },
        { name = "user_id", type = "string" },
        { name = "event_data", type = "string" }
      ]

      ser_de_info = {
        serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      }
    }

    partition_keys = [
      { name = "year", type = "string" },
      { name = "month", type = "string" },
      { name = "day", type = "string" }
    ]
  }
}
```

### Using JSON Input

```bash
terraform apply -var='glue_table_config={"table_name":"my_table","database_name":"my_db","storage_descriptor":{"location":"s3://bucket/data/","input_format":"org.apache.hadoop.mapred.TextInputFormat","output_format":"org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat","columns":[{"name":"id","type":"int"}],"ser_de_info":{"serialization_library":"org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"}}}'
```

## Examples

| Example | Description |
|---------|-------------|
| [basic](examples/basic) | Basic Glue Catalog Table with CSV format |
| [parquet](examples/parquet) | Glue Catalog Table with Parquet format |
| [partitioned](examples/partitioned) | Glue Catalog Table with partition keys |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| glue_table_config | Configuration object for Glue Catalog Table | `object` | - | yes |

### glue_table_config Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| table_name | string | - | Name of the table (required) |
| database_name | string | - | Name of the database (required) |
| catalog_id | string | null | ID of the Glue Catalog (defaults to AWS account ID) |
| description | string | null | Description of the table |
| owner | string | null | Owner of the table |
| retention | number | 0 | Retention time for the table |
| table_type | string | "EXTERNAL_TABLE" | Type of table: `EXTERNAL_TABLE`, `GOVERNED`, `VIRTUAL_VIEW`, or `ICEBERG` |
| parameters | map(string) | {} | Table parameters |
| storage_descriptor | object | null | Storage descriptor configuration |
| partition_keys | list(object) | [] | Partition key definitions |
| target_table | object | null | Target table for resource links |

### storage_descriptor Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| location | string | null | S3 location of the table data |
| input_format | string | null | Input format class |
| output_format | string | null | Output format class |
| compressed | bool | false | Whether data is compressed |
| number_of_buckets | number | -1 | Number of buckets |
| bucket_columns | list(string) | null | Bucket column names |
| stored_as_sub_directories | bool | false | Whether stored as subdirectories |
| parameters | map(string) | {} | Storage parameters |
| columns | list(object) | [] | Column definitions |
| ser_de_info | object | null | SerDe configuration |
| sort_columns | list(object) | null | Sort column configuration |
| skewed_info | object | null | Skewed data configuration |
| schema_reference | object | null | Schema registry reference |

### Column Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| name | string | - | Column name (required) |
| type | string | - | Column data type (required) |
| comment | string | null | Column comment |
| parameters | map(string) | null | Column parameters |

### partition_keys Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| name | string | - | Partition key name (required) |
| type | string | - | Partition key data type (required) |
| comment | string | null | Partition key comment |

## Outputs

| Name | Description |
|------|-------------|
| table_id | The ID of the Glue Catalog Table (catalog_id:database_name:table_name) |
| table_name | The name of the Glue Catalog Table |
| table_arn | The ARN of the Glue Catalog Table |
| database_name | The name of the database containing the table |
| catalog_id | The catalog ID (AWS account ID) |
| table_type | The type of the table |
| storage_location | The S3 location of the table data |
| partition_keys | The partition keys of the table |
| columns | The columns of the table |

## Resources Created

| Resource | Description |
|----------|-------------|
| aws_glue_catalog_table | The Glue Catalog Table |

## Validation

The module validates inputs and provides descriptive error messages for:

- Empty table name
- Empty database name
- Invalid table_type value
- Negative retention value

## Testing

The module includes Terratest-based integration tests:

```bash
cd test
go mod tidy
go test -v -timeout 30m
```

### Test Cases

| Test | Description |
|------|-------------|
| TestGlueCatalogTableBasic | Basic table creation with CSV format |
| TestGlueCatalogTableParquet | Table with Parquet format |
| TestGlueCatalogTablePartitioned | Table with partition keys |

AWS credentials must be configured via environment variables or AWS CLI profile.

## CI/CD Configuration

The CI workflow runs on:
- Push to `main`, `feature/**`, and `bug/**` branches
- Pull requests to `main`
- Manual workflow dispatch

The workflow includes:
- Terraform validation and format checking
- Examples validation
- Terratest integration tests
- Changelog generation (non-main branches)
- Semantic release (main branch only)

### GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN` | IAM role ARN for OIDC authentication |

### GitHub Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TERRAFORM_VERSION` | Terraform version for CI jobs | `1.3.0` |
| `GO_VERSION` | Go version for Terratest | `1.21` |

## License

MIT License - See [LICENSE](LICENSE) for details.
