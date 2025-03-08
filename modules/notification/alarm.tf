resource "aws_cloudwatch_metric_alarm" "termin_found_alarm" {
  alarm_name          = "termin_found_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "termin_found_metric"
  namespace           = "termin_scraper"
  period              = 86400
  statistic           = "Sum"
  threshold           = 1

  alarm_actions = [aws_sns_topic.termin_found_topic.arn]
}
