terraform {
  backend "s3" {
    bucket       = "terraform-state-798704874551"
    key          = "week-00/lab-01/student-work/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
