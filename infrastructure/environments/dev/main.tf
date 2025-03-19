terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.89.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region  = var.region
  profile = "default"
}

module "cluster" {
  source      = "../../modules/cluster"
  environment = var.environment
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
