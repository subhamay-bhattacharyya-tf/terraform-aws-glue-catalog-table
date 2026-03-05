# Basic Glue Catalog Table Example

This example creates a basic AWS Glue Catalog Table with CSV format.

## Usage

```bash
terraform init
terraform plan -var='glue_table={"table_name":"my_table","database_name":"my_database","storage_descriptor":{"location":"s3://my-bucket/data/","input_format":"org.apache.hadoop.mapred.TextInputFormat","output_format":"org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat","columns":[{"name":"id","type":"int"},{"name":"name","type":"string"}],"ser_de_info":{"serialization_library":"org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"}}}'
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
