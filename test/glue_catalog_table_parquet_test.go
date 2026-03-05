// File: test/glue_catalog_table_parquet_test.go
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

// TestGlueCatalogTableParquet tests creating a Glue Catalog Table with Parquet format
func TestGlueCatalogTableParquet(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	tableName := fmt.Sprintf("tt_glue_parquet_%s", unique)
	databaseName := fmt.Sprintf("tt_db_%s", unique)

	tfDir := "../examples/parquet"

	glueConfig := map[string]interface{}{
		"table_name":    tableName,
		"database_name": databaseName,
		"table_type":    "EXTERNAL_TABLE",
		"storage_descriptor": map[string]interface{}{
			"location":      fmt.Sprintf("s3://test-bucket-%s/parquet/", unique),
			"input_format":  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
			"output_format": "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat",
			"compressed":    true,
			"columns": []map[string]interface{}{
				{"name": "id", "type": "bigint"},
				{"name": "event_time", "type": "timestamp"},
				{"name": "payload", "type": "string"},
			},
			"ser_de_info": map[string]interface{}{
				"serialization_library": "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
				"parameters": map[string]interface{}{
					"serialization.format": "1",
				},
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
	require.Contains(t, props.Columns, "id")
	require.Contains(t, props.Columns, "event_time")
	require.Contains(t, props.Columns, "payload")
}
