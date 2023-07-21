output "sqs_info" {
  value = [
    for queue in aws_sqs_queue.terraform_sqs : {
      name : queue.name
      arn : queue.arn
      url : queue.url
    }
  ]
}
