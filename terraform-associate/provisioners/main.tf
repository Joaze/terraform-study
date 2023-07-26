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

resource "aws_key_pair" "deployer" {
  key_name = "deployer_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC10BnPQgUHiNa7A3mm0g5mVDa+V7FaJkUpSB7R9yYAStT1GRalAcmlOUrJ6tVppNhmm/kHyXmW/dpgXYQ9utOpicVXTokheEPaC+DPhJRVtUISnGHO3QOnTSPOYBe6BuNrBe1WZSvTVvDWVNnTsGy5POJLeP+qa/DLSooKGGr0ba/GlgWe909zdqAPZ82lGaJpvnrvHQV6Qv9RmUMNMO4BbdVhRjp0btLg+tjmh9Zgfwa7kW+w8FXinvwGAHq3x15PZ5XbkdfqbvgSipgz/V0tqVjvaEwzt/ulZZYWoXQ5Gq1OEod2lq6kl9G21cSch3wmNTqb1sQAP76F1y1OoD+r1aqBpP+WTgZaA/+DZZIbXcQmywalo51JfzfwOgCcjWprmr5O07cvwUiz++/7HkhUih0AW1NcWZ6gyviCEAQX/ZNoMU57EJtXYYE3JlYFuNbO5S6QKT2xiY4rjFcR06rvaSKUugKAXZKu2tS21iULEXhtuRVISySF6n9Ic57PR8= joazeoliveirra@SEN001151"
  
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "template_file" "user_data" {
  template = file("./user-data.yaml")
}


resource "aws_instance" "web-01" {
  ami             = "ami-05548f9cecf47b442" # Ubuntu 20.04 LTS // us-east-1
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name]
  key_name = aws_key_pair.deployer.key_name
  user_data = data.template_file.user_data.rendered
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  # user_data       = <<-EOF
  #             #!/bin/bash
  #             echo "Hello, World web-01" > index.html
  #             python3 -m http.server 8080 &
  #             EOF
  tags = {
    Name = "instance_web-01"
  }
}

output "public_ip" {
  value = aws_instance.web-01.public_ip
}


resource "aws_security_group" "instances" {
  name        = "instance-security-group"
  description = "Instance security group"
  vpc_id      = data.aws_vpc.default_vpc.id

  tags = {
    Name = "instance_sg"
  }
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["187.19.88.158/32"]
}

resource "aws_security_group_rule" "allow_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instances.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
