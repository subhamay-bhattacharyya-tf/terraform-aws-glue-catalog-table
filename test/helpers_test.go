// File: test/helpers_test.go
package test

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/glue"
	"github.com/stretchr/testify/require"
)

type GlueTableProps struct {
	Name           string
	DatabaseName   string
	TableType      string
	Location       string
	PartitionKeys  []string
	Columns        []string
}

func getGlueClient(t *testing.T) *glue.Client {
	t.Helper()

	region := os.Getenv("AWS_REGION")
	if region == "" {
		region = "us-east-1"
	}

	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(region))
	require.NoError(t, err, "Failed to load AWS config")

	return glue.NewFromConfig(cfg)
}

func tableExists(t *testing.T, client *glue.Client, databaseName, tableName string) bool {
	t.Helper()

	_, err := client.GetTable(context.TODO(), &glue.GetTableInput{
		DatabaseName: &databaseName,
		Name:         &tableName,
	})

	return err == nil
}

func fetchTableProps(t *testing.T, client *glue.Client, databaseName, tableName string) GlueTableProps {
	t.Helper()

	props := GlueTableProps{
		Name:         tableName,
		DatabaseName: databaseName,
	}

	output, err := client.GetTable(context.TODO(), &glue.GetTableInput{
		DatabaseName: &databaseName,
		Name:         &tableName,
	})
	require.NoError(t, err, "Failed to get table")

	if output.Table != nil {
		if output.Table.TableType != nil {
			props.TableType = *output.Table.TableType
		}

		if output.Table.StorageDescriptor != nil && output.Table.StorageDescriptor.Location != nil {
			props.Location = *output.Table.StorageDescriptor.Location
		}

		if output.Table.StorageDescriptor != nil {
			for _, col := range output.Table.StorageDescriptor.Columns {
				if col.Name != nil {
					props.Columns = append(props.Columns, *col.Name)
				}
			}
		}

		for _, pk := range output.Table.PartitionKeys {
			if pk.Name != nil {
				props.PartitionKeys = append(props.PartitionKeys, *pk.Name)
			}
		}
	}

	return props
}

func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

func stringPtr(s string) *string {
	return &s
}
