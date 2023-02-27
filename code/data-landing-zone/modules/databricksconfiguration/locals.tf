locals {
  default_cluster_policy = {
    "autoscale.min_workers" : {
      "type" : "range",
      "defaultValue" : 1,
      "maxValue" : 10,
      "isOptional" : false,
      "hidden" : false
    },
    "autoscale.max_workers" : {
      "type" : "range",
      "maxValue" : 10,
      "defaultValue" : 5,
      "isOptional" : false,
      "hidden" : false
    },
    "azure_attributes.availability" : {
      "type" : "fixed",
      "defaultValue" : "ON_DEMAND_AZURE",
      "isOptional" : false,
      "hidden" : true
    },
    "azure_attributes.spot_bid_max_price" : {
      "type" : "fixed",
      "value" : -1,
      "isOptional" : false,
      "hidden" : true
    },
    "cluster_log_conf.type" : {
      "type" : "fixed",
      "value" : "DBFS",
      "isOptional" : false,
      "hidden" : false
    },
    "cluster_log_conf.path" : {
      "type" : "fixed",
      "value" : "dbfs:/cluster-logs",
      "isOptional" : false,
      "hidden" : false
    },
    "custom_tags.costCenter" : {
      "type" : "regex",
      "pattern" : "[A-Z]{5}-[0-9]{5}",
      "isOptional" : false,
      "hidden" : false
    },
    "enable_local_disk_encryption" : {
      "type" : "fixed",
      "value" : true,
      "isOptional" : false,
      "hidden" : true
    },
    "num_workers" : {
      "type" : "forbidden",
      "isOptional" : true,
      "hidden" : true
    },
    "spark_version" : {
      "type" : "unlimited",
      "defaultValue" : "auto:latest-lts",
      "isOptional" : false,
      "hidden" : false
    },
    "ssh_public_keys.*" : {
      "type" : "forbidden",
      "isOptional" : true,
      "hidden" : true
    }
  }

  job_cluster_policy = {
    "cluster_type" : {
      "type" : "fixed",
      "value" : "job"
    },
    "spark_conf.spark.databricks.cluster.profile" : {
      "type" : "forbidden",
      "isOptional" : true,
      "hidden" : true
    }
  }

  all_purpose_cluster_policy = {
    "cluster_type" : {
      "type" : "fixed",
      "value" : "all-purpose"
    },
    "autotermination_minutes" : {
      "type" : "range",
      "minValue" : 1
      "maxValue" : 120
      "defaultValue" : 30,
      "isOptional" : false,
      "hidden" : false
    },
    "dbus_per_hour" : {
      "type" : "range",
      "maxValue" : 100
    },
    "driver_instance_pool_id" : {
      "type" : "forbidden",
      "isOptional" : true,
      "hidden" : true
    },
    "instance_pool_id" : {
      "type" : "forbidden",
      "isOptional" : true,
      "hidden" : true
    },
    "data_security_mode" : {
      "type" : "allowlist",
      "values" : [
        "SINGLE_USER",
        "NONE",
        # "LEGACY_SINGLE_USER",
        # "LEGACY_SINGLE_USER_STANDARD"
      ],
      "defaultValue" : "SINGLE_USER",
      "hidden" : true
    }
  }
}
