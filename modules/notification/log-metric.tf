resource "aws_cloudwatch_log_metric_filter" "termin_found_filter" {
  name           = "termin_found_filter"
  pattern        = "Termin found."
  log_group_name = "/aws/lambda/scraper"

  metric_transformation {
    name      = "termin_found_metric"
    namespace = "TerminScraper"
    value     = 1
  }
}

