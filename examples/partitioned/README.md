# Partitioned Glue Catalog Table Example

This example creates an AWS Glue Catalog Table with partition keys for efficient querying.

## Usage

```bash
terraform init
terraform plan -var='glue_table={"table_name":"events_partitioned","database_name":"analytics_db","storage_descriptor":{"location":"s3://my-bucket/events/","input_format":"org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat","output_format":"org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat","columns":[{"name":"event_id","type":"string"},{"name":"user_id","type":"string"},{"name":"event_data","type":"string"}],"ser_de_info":{"serialization_library":"org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"}},"partition_keys":[{"name":"year","type":"string"},{"name":"month","type":"string"},{"name":"day","type":"string"}]}'
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
| partition_keys | The partition keys of the table |
