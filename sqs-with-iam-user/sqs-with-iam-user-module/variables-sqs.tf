variable "sqs_delay_seconds" {
  description = "SQS delay seconds"
  type        = number
  default     = 0
}

variable "sqs_max_message_size" {
  description = "SQS max message size"
  type        = number
  default     = 2048
}

variable "sqs_message_retention_seconds" {
  description = "SQS retention seconds before expunge"
  type        = number
  default     = 259200
}


variable "sqs_receive_wait_time_seconds" {
  description = "SQS wait time seconds"
  type        = number
  default     = 20
}
