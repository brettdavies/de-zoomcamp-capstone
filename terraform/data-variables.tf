##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##       Data - Variables        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##      Change as Required       ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

locals {
  data_lake_bucket = "dl_raw"
}

variable "gcp_storage_class" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default     = "STANDARD"
}

variable "gcp_bq_dataset_raw" {
  description = "BigQuery Dataset that raw data (from GCS) will be written to"
  type        = string
  default     = "gcs_raw"
}

variable "gcp_bq_dataset_dev" {
  description = "BigQuery Dataset where dbt development models will be written"
  type        = string
  default     = "development"
}

variable "gcp_bq_dataset_prod" {
  description = "BigQuery Dataset where dbt development models will be written"
  type        = string
  default     = "production"
}