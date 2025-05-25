
terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket       = "REPLACE_ME_STATE_BUCKET"
    key          = "global/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" { region = var.aws_region }
