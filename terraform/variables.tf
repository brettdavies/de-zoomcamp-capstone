locals {
  data_lake_bucket = "dl_raw"
}

variable "project" {
  description = "Your GCP Project ID"
  default = "de-capstone"
  type = string
}

variable "region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  default = "us-west2"
  type = string
}

variable "gcp_de_capstone" {
  description = "Google Cloud service account credentials"
  type = string
  sensitive = true
}

variable "storage_class" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default = "STANDARD"
}

variable "BQ_DATASET_RAW" {
  description = "BigQuery Dataset that raw data (from GCS) will be written to"
  type        = string
  default     = "gcs_raw"
}

variable "BQ_DATASET_DEV" {
  description = "BigQuery Dataset where dbt development models will be written"
  type        = string
  default     = "development"
}

variable "BQ_DATASET_PROD" {
  description = "BigQuery Dataset where dbt development models will be written"
  type        = string
  default     = "production"
}