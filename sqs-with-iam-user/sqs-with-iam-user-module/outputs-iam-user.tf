output "user_info" {
  value = {
    name = aws_iam_user.terraform_user_sqs.name
    path = aws_iam_user.terraform_user_sqs.path
    tags = aws_iam_user.terraform_user_sqs.tags
  }
}

output "access_and_secret_key" {
  sensitive = true
  value = {
    access_key = aws_iam_access_key.terraform_user_sqs.id
    secret_key = aws_iam_access_key.terraform_user_sqs.secret
  }
}
