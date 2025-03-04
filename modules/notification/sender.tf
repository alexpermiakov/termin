resource "aws_sns_topic" "termin_found_topic" {
  name = "TerminFoundTopic"
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.termin_found_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.custom_sms_sender.arn
}

resource "aws_lambda_permission" "allow_sns" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.custom_sms_sender.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.termin_found_topic.arn
}

resource "aws_lambda_function" "custom_sms_sender" {
  filename         = "${path.module}/files/custom_sms_sender.zip"
  function_name    = "CustomSmsSender"
  role             = aws_iam_role.sender_lambda_exec.arn
  runtime          = "nodejs22.x"
  handler          = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/files/custom_sms_sender.zip")
}

resource "aws_iam_role" "sender_lambda_exec" {
  name               = "sender_lambda_exec"
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

resource "aws_iam_role_policy" "sender_lambda_policy" {
  name   = "cicd_policy"
  role   = aws_iam_role.sender_lambda_exec.id
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
      },
      {
        "Effect": "Allow",
        "Action": [
          "sns:Publish"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}
