variable "region" {
  description = "The region in which the resources will be created"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}
