output "scraper_role_arn" {
  value = aws_iam_role.scraper_role.arn
}
output "scraper_function_name" {
  value = aws_lambda_function.scraper.function_name
}
output "scraper_function_arn" {
  value = aws_lambda_function.scraper.arn
}
output "scraper_function_invoke_arn" {
  value = aws_lambda_function.scraper.invoke_arn
}
output "scraper_function_source_code_hash" {
  value = aws_lambda_function.scraper.source_code_hash
}
output "scraper_function_runtime" {
  value = aws_lambda_function.scraper.runtime
}
output "scraper_function_handler" {
  value = aws_lambda_function.scraper.handler
}
output "scraper_function_filename" {
  value = aws_lambda_function.scraper.filename
}
output "scraper_function_memory_size" {
  value = aws_lambda_function.scraper.memory_size
}
output "scraper_function_timeout" {
  value = aws_lambda_function.scraper.timeout
}
output "scraper_function_role" {
  value = aws_lambda_function.scraper.role
}
output "scraper_function_environment" {
  value = aws_lambda_function.scraper.environment
}
output "scraper_function_tags" {
  value = aws_lambda_function.scraper.tags
}
output "scraper_function_dead_letter_config" {
  value = aws_lambda_function.scraper.dead_letter_config
}
output "scraper_function_kms_key_arn" {
  value = aws_lambda_function.scraper.kms_key_arn
}
output "scraper_function_tracing_config" {
  value = aws_lambda_function.scraper.tracing_config
}
output "scraper_function_layers" {
  value = aws_lambda_function.scraper.layers
}
output "scraper_function_vpc_config" {
  value = aws_lambda_function.scraper.vpc_config
}
output "scraper_function_source_code_size" {
  value = aws_lambda_function.scraper.source_code_size
}
output "scraper_function_description" {
  value = aws_lambda_function.scraper.description
}
output "scraper_function_version" {
  value = aws_lambda_function.scraper.version
}
