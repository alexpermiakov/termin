# Create OIDC Provider Before Infrastructure Provisioning
1. Create a temp user with full IAM access
2. Add env vars where *** is temp user's credentials
export aws_access_key_id = ***
export aws_secret_access_key = ***

3. aws iam create-open-id-connect-provider \                                                                            ✘ 252  18:50:58
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1

4. Remove the temp user and its credentials.