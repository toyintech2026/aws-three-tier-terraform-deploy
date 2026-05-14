terraform {
  backend "s3" {
    bucket = "toyin-terraform-state-bucket-2026"
    key    = "aws-three-tier-terraform-deploy/production/terraform.tfstate"
    region = "us-west-1"
  }
}