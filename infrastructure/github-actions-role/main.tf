resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["74f3a68f16524f15424927704c9506f55a9316bd"]
}

module "github_actions_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.5.0"

  create_role = true
  role_name   = "TerraformExecutionRole"

  provider_url = replace(aws_iam_openid_connect_provider.github_oidc.url, "https://", "")

  oidc_subjects_with_wildcards = [
    "repo:alexpermiakov/termin:environment:production",
  ]

  role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}
