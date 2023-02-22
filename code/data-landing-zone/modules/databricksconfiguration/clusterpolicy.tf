resource "databricks_cluster_policy" "cluster_policy_job" {
  name = "cluster-policy-job"

  definition = jsonencode(merge(local.default_cluster_policy, local.job_cluster_policy))
}

resource "databricks_cluster_policy" "cluster_policy_all_purpose" {
  name = "cluster-policy-all-purpose"

  definition = jsonencode(merge(local.default_cluster_policy, local.all_purpose_cluster_policy))
}
