resource "aws_lambda_function" "termin_scraper_lambda" {
  function_name    = "TerminScraper"
  role             = var.cicd_role_arn
  runtime          = "nodejs22.x"
  handler          = "index.handler"
  filename         = "${path.module}/files/scraper.zip"
  source_code_hash = filebase64sha256("${path.module}/files/scraper.zip")
}

variable "cicd_role_arn" {
  type        = string
  description = "ARN of the IAM role for the Lambda function"
}
