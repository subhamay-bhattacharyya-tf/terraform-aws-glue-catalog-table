// File: test/glue_catalog_table_partitioned_test.go
package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestGlueCatalogTablePartitioned tests creating a Glue Catalog Table with partition keys
func TestGlueCatalogTablePartitioned(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	tableName := fmt.Sprintf("tt_glue_part_%s", unique)
	databaseName := fmt.Sprintf("tt_db_%s", unique)

	tfDir := "../examples/partitioned"

	glueConfig := map[string]interface{}{
		"partitioned_table": map[string]interface{}{
			"table_name":    tableName,
			"database_name": databaseName,
			"table_type":    "EXTERNAL_TABLE",
			"storage_descriptor": map[string]interface{}{
				"location":      fmt.Sprintf("s3://test-bucket-%s/events/", unique),
				"input_format":  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
				"output_format": "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat",
				"columns": []map[string]interface{}{
					{"name": "event_id", "type": "string"},
					{"name": "user_id", "type": "string"},
					{"name": "event_data", "type": "string"},
				},
				"ser_de_info": map[string]interface{}{
					"serialization_library": "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
				},
			},
			"partition_keys": []map[string]interface{}{
				{"name": "year", "type": "string"},
				{"name": "month", "type": "string"},
				{"name": "day", "type": "string"},
			},
		},
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region":     "us-east-1",
			"glue_table": glueConfig,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getGlueClient(t)

	exists := tableExists(t, client, databaseName, tableName)
	require.True(t, exists, "Expected table %q to exist in database %q", tableName, databaseName)

	props := fetchTableProps(t, client, databaseName, tableName)
	require.Equal(t, "EXTERNAL_TABLE", props.TableType)
	require.Contains(t, props.PartitionKeys, "year")
	require.Contains(t, props.PartitionKeys, "month")
	require.Contains(t, props.PartitionKeys, "day")
}
