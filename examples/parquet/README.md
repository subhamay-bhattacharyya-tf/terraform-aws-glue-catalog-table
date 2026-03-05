# Parquet Glue Catalog Table Example

This example creates an AWS Glue Catalog Table with Parquet format and Snappy compression.

## Usage

```bash
terraform init
terraform plan -var='glue_table={"table_name":"parquet_table","database_name":"analytics_db","storage_descriptor":{"location":"s3://my-bucket/parquet-data/","input_format":"org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat","output_format":"org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat","compressed":true,"columns":[{"name":"id","type":"bigint"},{"name":"event_time","type":"timestamp"},{"name":"payload","type":"string"}],"ser_de_info":{"serialization_library":"org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe","parameters":{"serialization.format":"1"}}}}'
terraform apply
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| glue_table | Glue Catalog Table configuration | object | yes |
| region | AWS region | string | no |

## Outputs

| Name | Description |
|------|-------------|
| table_id | The ID of the Glue Catalog Table |
| table_name | The name of the Glue Catalog Table |
| table_arn | The ARN of the Glue Catalog Table |
| database_name | The database name |
| storage_location | The S3 location of the table data |
