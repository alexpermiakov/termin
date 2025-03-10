resource "aws_lambda_function" "scraper" {
  function_name    = "scraper"
  role             = aws_iam_role.scraper_role.arn
  runtime          = var.runtime
  handler          = "index.handler"
  filename         = "${path.module}/files/scraper.zip"
  source_code_hash = filebase64sha256("${path.module}/files/scraper.zip")
}

resource "aws_iam_role" "scraper_role" {
  name               = "scraper_role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "scraper_policy" {
  name   = "scraper_policy"
  role   = aws_iam_role.scraper_role.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}
