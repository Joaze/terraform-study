resource "aws_sqs_queue" "terraform_sqs" {
  for_each = var.users
  name                      = "terraform_sqs_${each.value}"
  delay_seconds             = var.sqs_delay_seconds
  max_message_size          = var.sqs_max_message_size
  message_retention_seconds = var.sqs_message_retention_seconds
  receive_wait_time_seconds = var.sqs_receive_wait_time_seconds
}
