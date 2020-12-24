variable "region" {
  type        = string
  description = "GCP region"
}

variable "admin_project" {
  type        = string
  description = "GCP Seed Project"
}

variable "target_project_name" {
  type    = string
  default = "gcp-demo"
}

variable "billing_account_id" {
  description = "Org billing account id"
  type = string
}

variable "folder_id" {
  description = "'gcp_training_root' folder id"
  type = string
}
