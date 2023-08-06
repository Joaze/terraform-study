terraform {
  backend "remote" {
    organization = "joaze"
    workspaces {
      name = "example-workspaces"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  #profile = "user235"
  region  = "us-east-1"
}

# output "ami_id" {
#   value = data.aws_ami.example_ami.id
# }




resource "aws_instance" "app_server" {
  ami = var.ami_id
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

