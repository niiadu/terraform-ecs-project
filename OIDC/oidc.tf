######################################################################
# OIDC to enable communication between GitHub->AWS without secrets
######################################################################
resource "aws_iam_openid_connect_provider" "github_actions_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

resource "aws_iam_role" "github_actions_api_access_role" {
  name = "GithubActions"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.github_actions_oidc.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "ForAnyValue:StringLike" : {
            "token.actions.githubusercontent.com:sub" : [
              "repo:niiadu/*"
              ]
          }
        }
      }
    ]
  })
  inline_policy {
    name = "github-actions-access-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "*",
          "Resource" : "*",
          "Effect" : "Allow"
        }
      ]
    })
  }
}