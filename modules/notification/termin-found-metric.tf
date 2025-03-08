resource "aws_cloudwatch_log_metric_filter" "termin_found_metric" {
  name           = "termin_found_metric"
  pattern        = "Termin found."
  log_group_name = "/aws/lambda/scraper"

  metric_transformation {
    name      = "termin_found_metric"
    namespace = "termin_scraper"
    value     = "1"
  }
}
