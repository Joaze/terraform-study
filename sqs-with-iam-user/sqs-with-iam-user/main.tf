terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "user235"
}

module "sqs_with_iam_user" {
  source = "../sqs-with-iam-user-module"
  #input variables
  users = [
    "antonio",
    "pedro",
    "lucas"
  ]
}

output "iam-user-sqs" {
  value = module.sqs_with_iam_user.user_info
}

output "access_and_secret_key" {
  sensitive = true
  value = module.sqs_with_iam_user.access_and_secret_key
}

output "sqs_info" {
  value =  module.sqs_with_iam_user.sqs_info
}





