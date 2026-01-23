# main.tf

# Use locals to compute values used in multiple places
locals {
  default_tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Module      = "s3-bucket"
  }

  # Merge default tags with user-provided tags
  all_tags = merge(local.default_tags, var.tags)
}

# The S3 bucket resource
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = local.all_tags
}

# Versioning configuration
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
