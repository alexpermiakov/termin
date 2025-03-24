output "azs_names" {
  value = module.vpc.azs
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}
