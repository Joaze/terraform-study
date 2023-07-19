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

module "web-app-1" {
  source = "..//web-app-module"
  
  #input variables
  instance_type = "t2.micro"
  ami = "ami-011899242bb902164"
  

}



