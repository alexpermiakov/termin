terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.89.0"
    }
  }

  backend "s3" {
    region         = "eu-central-1"
    bucket         = "terraform-state-bucket-ap1988"
    key            = "state.tfstate"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

# module "iam" {
#   source = "../../modules/iam"
# }

module "scraping" {
  source = "../../modules/scraping"
}
