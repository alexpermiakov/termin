# Create OIDC Provider Before Infrastructure Provisioning
Use aws console or cli if iam credentials are presented locally:

aws iam create-open-id-connect-provider \                                                                            ✘ 252  18:50:58
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 74f3a68f16524f15424927704c9506f55a9316bd

