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
          "token.actions.githubusercontent.com:sub" = "repo:alexpermiakov/termin:environment:staging:ref:refs/heads/main"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_admin" {
  role       = aws_iam_role.terraform_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
