resource "aws_lambda_function" "termin_scraper_lambda" {
  function_name    = "TerminScraper"
  role             = aws_iam_role.cicd_role.arn
  runtime          = "nodejs22.x"
  handler          = "index.handler"
  filename         = "${path.module}/files/scraper.zip"
  source_code_hash = filebase64sha256("${path.module}/files/scraper.zip")
}

resource "aws_iam_role" "cicd_role" {
  name               = "cicd_role"
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

resource "aws_iam_role_policy" "cicd_policy" {
  name   = "cicd_policy"
  role   = aws_iam_role.cicd_role.id
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
