module "my_bucket" {
  source = "../../../modules/s3-bucket"  # Path to project root modules

  # Required variables (no defaults)
  bucket_name = "my-app-data"
  environment = "dev"

  # Optional variables (have defaults)
  enable_versioning = true

  tags = {
    Team    = "platform"
    Project = "my-app"
  }
}

# Access module outputs
output "bucket_arn" {
  value = module.my_bucket.bucket_arn
}
