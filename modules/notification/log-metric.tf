resource "aws_cloudwatch_log_metric_filter" "termin_found_filter" {
  name           = "TerminFoundFilter"
  pattern        = "Termin found."
  log_group_name = "/aws/lambda/TerminScraper"

  metric_transformation {
    name      = "TerminFoundMetric"
    namespace = "TerminScraper"
    value     = 1
  }
}

