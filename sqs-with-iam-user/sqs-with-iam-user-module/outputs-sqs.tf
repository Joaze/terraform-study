output "sqs_info" {
  value = {
    name = aws_sqs_queue.terraform_sqs.name
    arn  = aws_sqs_queue.terraform_sqs.arn
    url = aws_sqs_queue.terraform_sqs.url
  }
}
