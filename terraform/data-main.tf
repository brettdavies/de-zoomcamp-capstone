##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##        Data - Main            ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##      Change as Required       ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Data Lake Bucket
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "data-lake-bucket" {
  name          = "${local.data_lake_bucket}_${var.gcp_project}" # Concatenating DL bucket & Project name for unique naming
  location      = var.gcp_region

  # Optional, but recommended settings:
  storage_class = var.gcp_storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  # lifecycle_rule {
  #   action {
  #     type = "Delete"
  #   }
  #   condition {
  #     age = 30  // days
  #   }
  # }

  force_destroy = true
}

# Big Query Data Warehouse
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
resource "google_bigquery_dataset" "raw_dataset" {
  dataset_id = var.gcp_bq_dataset_raw
  project    = var.gcp_project
  location   = var.gcp_region
}

# development bucket for dbt models
resource "google_bigquery_dataset" "development_dataset" {
  dataset_id = var.gcp_bq_dataset_dev
  project    = var.gcp_project
  location   = var.gcp_region
}

# production bucket for dbt models
resource "google_bigquery_dataset" "production_dataset" {
  dataset_id = var.gcp_bq_dataset_prod
  project    = var.gcp_project
  location   = var.gcp_region
}