
terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket       = "ai-ready-lakehouse-tfstate"
    key          = "global/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" { region = var.aws_region }
