output "user_info" {
  value = [
    for userinfo in aws_iam_user.terraform_user_sqs : {
      name : userinfo.name
      path : userinfo.path
      tags : userinfo.tags
    }
  ]
}

output "access_and_secret_key" {
  sensitive = true
  value = [
    for user_secrets in aws_iam_access_key.terraform_user_sqs : {
      name: user_secrets.user
      access_key : user_secrets.id
      secret_key : user_secrets.secret
    }
  ]
}
