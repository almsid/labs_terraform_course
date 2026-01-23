# variables.tf

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 3 and 63 characters"
  }
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "enable_versioning" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true  # Optional variables need defaults
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}
