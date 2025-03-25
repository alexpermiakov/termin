terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.89.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "terraform-state-terminapp"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
