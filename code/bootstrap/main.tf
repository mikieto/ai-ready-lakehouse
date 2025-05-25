
terraform {
  required_version = ">= 1.6.0"
}

variable "aws_region" {
  type = string
  default = "us-east-1" 
}

provider "aws" { region = var.aws_region }

resource "aws_s3_bucket" "tfstate" {
  bucket = "ai-ready-lakehouse-tfstate"
  versioning { enabled = true }
  lifecycle { prevent_destroy = true }
}

output "state_bucket" { value = aws_s3_bucket.tfstate.id }
