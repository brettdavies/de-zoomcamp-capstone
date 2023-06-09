terraform {
  required_version = ">= 1.0"
  # backend "local" {}  # Can change from "local" to "gcs" (for google) or "s3" (for aws), if you would like to preserve your tf-state online
  cloud {
    organization = "daviesbrett"

    workspaces {
      name = "de-capstone"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
  credentials = var.gcp_de_capstone
}

# Data Lake Bucket
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "data-lake-bucket" {
  name          = "${local.data_lake_bucket}_${var.project}" # Concatenating DL bucket & Project name for unique naming
  location      = var.region

  # Optional, but recommended settings:
  storage_class = var.storage_class
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

# DWH
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
resource "google_bigquery_dataset" "raw_dataset" {
  dataset_id = var.BQ_DATASET_RAW
  project    = var.project
  location   = var.region
}

# development bucket for dbt models
resource "google_bigquery_dataset" "development_dataset" {
  dataset_id = var.BQ_DATASET_DEV
  project    = var.project
  location   = var.region
}

# production bucket for dbt models
resource "google_bigquery_dataset" "production_dataset" {
  dataset_id = var.BQ_DATASET_PROD
  project    = var.project
  location   = var.region
}