resource "aws_cloudwatch_metric_alarm" "termin_found_alarm" {
  alarm_name          = "TerminFoundAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "TerminFoundMetric"
  namespace           = "TerminScraper"
  period              = 600
  statistic           = "Sum"
  threshold           = 1

  alarm_actions = [aws_sns_topic.termin_found_topic.arn]
}
