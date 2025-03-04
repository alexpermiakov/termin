resource "aws_cloudwatch_event_rule" "hourly_trigger" {
  name                = "hourly-lambda-trigger"
  description         = "Trigger the scraper every hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.hourly_trigger.name
  target_id = "hourly-lambda-target"
  arn       = aws_lambda_function.termin_scraper_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  function_name = aws_lambda_function.termin_scraper_lambda.function_name
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.hourly_trigger.arn
}
