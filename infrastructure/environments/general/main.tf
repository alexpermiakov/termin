terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.89.0"
    }
  }

  backend "s3" {}
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

provider "aws" {
  region = var.region
}

module "cluster" {
  source         = "../../modules/cluster"
  environment    = var.environment
  region         = var.region
  aws_account_id = var.aws_account_id
}

# module "notification" {
#   source  = "../../modules/notification"
#   runtime = "nodejs22.x"
#   period  = 86400
# }

# module "scraping" {
#   source  = "../../modules/scraping"
#   runtime = "nodejs22.x"
# }

# module "networking" {
#   source         = "../../modules/networking"
#   vpc_cidr_block = "10.0.0.0/20"
#   subnet_cidr_blocks = [
#     "10.0.1.0/24",
#     "10.0.2.0/24",
#     "10.0.3.0/24"
#   ]
#   availability_zones = [
#     "eu-central-1a",
#     "eu-central-1b"
#   ]
# }
