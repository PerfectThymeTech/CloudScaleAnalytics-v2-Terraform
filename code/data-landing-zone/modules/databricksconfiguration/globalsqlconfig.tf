resource "databricks_sql_global_config" "databricks_global_sql_config" {
  for_each        = var.client_id_secret_name == "" || var.client_secret_secret_name == "" ? [] : [1]
  security_policy = "DATA_ACCESS_CONTROL"

  data_access_config = {
    "spark.hadoop.fs.azure.account.auth.type" : "OAuth",
    "spark.hadoop.fs.azure.account.oauth.provider.type" : "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "spark.hadoop.fs.azure.account.oauth2.client.id" : "{{secrets/${databricks_secret_scope.platform_secret_scope.name}/${var.client_id_secret_name}}}",
    "spark.hadoop.fs.azure.account.oauth2.client.secret" : "{{secrets/${databricks_secret_scope.platform_secret_scope.name}/${var.client_secret_secret_name}}}",
    "spark.hadoop.fs.azure.account.oauth2.client.endpoint" : "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/token"
  }
  enable_serverless_compute = true
  sql_config_params = {
    "ANSI_MODE"                 = "TRUE",
    "LEGACY_TIME_PARSER_POLICY" = "CORRECTED",
    "READ_ONLY_EXTERNAL_METASTORE" : "FALSE",
    "TIMEZONE" : "UTC"
  }
}
