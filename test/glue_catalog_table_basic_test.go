// File: test/glue_catalog_table_basic_test.go
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

// TestGlueCatalogTableBasic tests creating a basic Glue Catalog Table
func TestGlueCatalogTableBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	tableName := fmt.Sprintf("tt_glue_basic_%s", unique)
	databaseName := fmt.Sprintf("tt_db_%s", unique)

	tfDir := "../examples/basic"

	glueConfig := map[string]interface{}{
		"table_name":    tableName,
		"database_name": databaseName,
		"table_type":    "EXTERNAL_TABLE",
		"storage_descriptor": map[string]interface{}{
			"location":      fmt.Sprintf("s3://test-bucket-%s/data/", unique),
			"input_format":  "org.apache.hadoop.mapred.TextInputFormat",
			"output_format": "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat",
			"columns": []map[string]interface{}{
				{"name": "id", "type": "int"},
				{"name": "name", "type": "string"},
			},
			"ser_de_info": map[string]interface{}{
				"serialization_library": "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe",
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

	outputTableName := terraform.Output(t, tfOptions, "table_name")
	require.Equal(t, tableName, outputTableName)

	outputDatabaseName := terraform.Output(t, tfOptions, "database_name")
	require.Equal(t, databaseName, outputDatabaseName)
}
