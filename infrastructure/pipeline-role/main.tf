resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["74f3a68f16524f15424927704c9506f55a9316bd"]
}

resource "aws_iam_role" "terraform_execution_role" {
  name = "TerraformExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity",
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::746669194690:oidc-provider/token.actions.githubusercontent.com"
      },
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
          "token.actions.githubusercontent.com:iss" = "https://token.actions.githubusercontent.com"
        },
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:alexpermiakov/termin:*"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_admin" {
  role       = aws_iam_role.terraform_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
