resource "aws_iam_user" "terraform_user_sqs" {
  for_each = var.users
  name = "terraform_sqs_${each.value}"
  path = "/system/"

  tags = {
    tag-key = "sqs_users"
  }
}

resource "aws_iam_access_key" "terraform_user_sqs" {
  for_each = var.users
  user = aws_iam_user.terraform_user_sqs[each.value].name
}

resource "aws_iam_policy" "terraform_user_sqs" {
  for_each = var.users
  name = "terraform_user_sqs_${each.value}"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "1",
        Action = [
          "sqs:SetQueueAttributes",
          "sqs:SendMessageBatch",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:ListQueues",
          "sqs:ListQueueTags",
          "sqs:ListDeadLetterSourceQueues",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes",
          "sqs:DeleteMessageBatch",
          "sqs:DeleteMessage",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:ChangeMessageVisibility",
        ]
        Effect = "Allow"
        Resource = [
          aws_sqs_queue.terraform_sqs[each.value].arn
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "terraform_user_sqs" {
  for_each = var.users
  user       = aws_iam_user.terraform_user_sqs[each.value].name
  policy_arn = aws_iam_policy.terraform_user_sqs[each.value].arn
}
