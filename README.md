# Create OIDC Provider Before Infrastructure Provisioning
Use aws console or cli if iam credentials are presented locally:

aws iam create-open-id-connect-provider \                                                                            ✘ 252  18:50:58
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1

